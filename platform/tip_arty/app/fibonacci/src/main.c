#include "ervp_printf.h"
#include "ervp_core_id.h"

#define ITERATIONS 10

int fib(int i) {
    return (i > 1) ? fib(i-1) + fib(i-2) : i;
}

int main() {
	int i;

	if(EXCLUSIVE_ID==0)
	{
		printf("fibonacci starting...\n");

		for(i = 0; i < ITERATIONS; i++)
			printf("fib(%03d) = %d\n", i, fib(i));
	}

	return 0;
}
