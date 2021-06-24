#include "ervp_printf.h"
#include "ervp_core_id.h"
#include "ervp_delay.h"

int main() {
	if(EXCLUSIVE_ID==0)
	{
		int conut = 0 ;
		printf("delay_us\n");
		delay_us(100);
		printf("delay_ms\n");
		delay_ms(10);
		printf("delay_sec\n");
		while(1)
		{
			delay_sec(1);
			printf("%d\n", conut++);
		}
	}
	return 0;
}
