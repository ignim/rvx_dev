#include "ervp_printf.h"
#include "ervp_external_peri_group_api.h"
#include "ervp_core_id.h"
#include "ervp_interrupt.h"
#include "ervp_timer.h"
#include "ervp_delay.h"
#include "ervp_platform_controller_api.h"
#include "ervp_multicore_synch.h"

void odd_isr()
{
	printf("Odd %d\n", EXCLUSIVE_ID);
}

void even_isr()
{
	printf("Even %d\n", EXCLUSIVE_ID);
}

int main() {
	int core_id = EXCLUSIVE_ID;
	config_timer_interval_ms(2*(core_id+1)*get_test_period_ms());
	if ((core_id&1)==0)
		register_isr_timer(even_isr);
	else
		register_isr_timer(odd_isr);
	delay_ms(EXCLUSIVE_ID*get_test_period_ms());
	start_timer_periodic();
	allow_interrupt_timer();
	enable_interrupt();
	while (1);
	return 0;
}
