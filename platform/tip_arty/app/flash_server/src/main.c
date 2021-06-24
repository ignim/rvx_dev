#include "ervp_printf.h"
#include "ervp_external_peri_group_api.h"
#include "ervp_delay.h"
#include "ervp_external_peri_group_memorymap.h"
#include "ervp_platform_controller_api.h"
#include "frvp_spi_flash.h"
#include "ervp_core_id.h"

#define ENABLE_LOG 0

int main() {
	int i;
	int cmd;
	int num_bytes;
	unsigned int flash_addr;
	volatile int* data_array = (volatile int*)(SRAM_ADDR+SRAM_SIZE-0x2000);

	if(EXCLUSIVE_ID==0)
	{
		printf("\n[RVC|INFO] flash server is running");
		printf("\n[RVC|INFO] flash base addr: 0x%x", get_flash_base_addr());
		printf("\n[RVC|INFO] buffer is set to 0x%x", data_array);
		configure_spi_flash();
		set_gpreg(3,(int)data_array);
		while(1)
		{
			cmd = get_gpreg(0);
			switch(cmd)
			{
				case OCD_FLASH_CMD_IDLE:
					break;
				case OCD_FLASH_CMD_CHECK:
					printf("\n[RVC|INFO] cmd is normally working!");
					break;
				case OCD_FLASH_CMD_ERASE:
					flash_addr = get_gpreg(1);
					erase_sector(flash_addr);
					break;
				case OCD_FLASH_CMD_READ:
					flash_addr = get_gpreg(1);
					num_bytes = get_gpreg(2);
					read_flash(flash_addr,num_bytes,(unsigned char*)data_array);
					printf("\n[RVC|INFO] flash read 0x%x num_bytes: %d first data: 0x%8x", flash_addr, num_bytes, data_array[0]);
					if(ENABLE_LOG==1)
						for(i=0; i<num_bytes; i++)
							printf("\n[RVC|INFO] read data: 0x%8x", data_array[i]);
					printf("\n[RVC|INFO] flash read complete");
					break;
				case OCD_FLASH_CMD_WRITE:
					flash_addr = get_gpreg(1);
					num_bytes = get_gpreg(2);
					printf("\n[RVC|INFO] flash write 0x%x num_bytes: %d first data: 0x%8x", flash_addr, num_bytes, data_array[0]);
					write_flash_wo_erase(flash_addr,num_bytes,(unsigned char*)data_array);
					if(ENABLE_LOG==1)
						for(i=0; i<num_bytes; i++)
							printf("\n[RVC|INFO] write data: 0x%8x", data_array[i]);
					printf("\n[RVC|INFO] flash write complete");
					break;
				default:
					printf("\n[RVC|INFO] undefined flash cmd %d", cmd);
			}
			if(cmd!=OCD_FLASH_CMD_IDLE)
			{
				set_gpreg(0,OCD_FLASH_CMD_IDLE);
				delay_ms(10);
			}
		}
	}
	return 0;
}

