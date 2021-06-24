#include "uthash.h"
#include "ervp_profiling.h"
#include "ervp_delay.h"

int main()
{
	for(int i=0; i<50; i++)
	{
		profiling_start("a");
		delay_ms(10);
		profiling_end("a");
	}
	for(int i=0; i<10; i++)
	{
		profiling_start("b");
		delay_sec(1);
		profiling_end("b");
	}
	profiling_print();
	return 0;
}
