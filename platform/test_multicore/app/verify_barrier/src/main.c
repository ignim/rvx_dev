#include "ervp_printf.h"
#include "ervp_platform_controller_api.h"
#include "ervp_core_id.h"
#include "ervp_multicore_synch.h"

volatile int a = 0;
volatile int b = 0;

int main() {
	const int barrier_index = BARRIER_INDEX_FOR_USER;

	reach_and_pass_barrier(barrier_index,NUM_CORE);
	acquire_lock(LOCK_INDEX_FOR_USER+0);
	a++;
	printf("a %d %d\n", EXCLUSIVE_ID, a);
	release_lock(LOCK_INDEX_FOR_USER+0);
	reach_and_pass_barrier(barrier_index,NUM_CORE);
	acquire_lock(LOCK_INDEX_FOR_USER+1);
	b++;
	printf("b %d %d %d\n", EXCLUSIVE_ID, a, b);
	release_lock(LOCK_INDEX_FOR_USER+1);
	return 0;
}

