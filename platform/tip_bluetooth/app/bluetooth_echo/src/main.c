#include "platform_info.h"
#include "ervp_printf.h"
#include "ervp_multicore_synch.h"
#include "ervp_reg_util.h"
#include "ervp_bluetooth.h"
#include "ervp_uart.h"

volatile int a = 0;
char out_text[100] = "End";
char in_text[10];

int main() {
	bluetooth_init();

	while(1)
	{
		in_text[0] = bluetooth_getc();
		printf("%c", in_text[0]);
		bluetooth_putc(in_text[0]);
		if(in_text[0]=='Q') break;
	}
	printf("End! %d\n", a);
	bluetooth_puts(out_text);
	return 0;
}
