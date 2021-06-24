#include "ervp_printf.h"
#include "ervp_external_peri_group_api.h"
#include "ervp_core_id.h"
#include "ervp_interrupt.h"
#include "ervp_timer.h"
#include "ervp_delay.h"
#include "ervp_platform_controller_api.h"

void int_service_routine()
{
    static int i = 0;
		delay_us(((i&3)+1)<<8);
    printf("Timer interrupt: %d\n", i++);
}

int main()
{
	if(EXCLUSIVE_ID==0)
	{
		config_timer_interval_ms(get_test_period_ms());
		register_isr_timer(int_service_routine);
		start_timer_periodic();
		allow_interrupt_timer();
		enable_interrupt();
		while(1);
	}
	return 0;
}
