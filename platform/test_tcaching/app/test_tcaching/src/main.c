#include "platform_info.h"
#include "ervp_printf.h"
#include "ervp_core_id.h"
#include "ervp_multicore_synch.h"
#include "ervp_profiling.h"
#include "ervp_tcaching.h"
#include "ervp_variable_allocation.h"
#include "ervp_memory_util.h"

#define NUM_DATA	(10000)

float *a_notcached;
float *b_notcached;

float *c_correct;
float *c_notcached;
float *c_cached;

static inline void alloc_memory();
static inline void init_memory();
static inline void compute(const volatile float *a, const volatile float *b, float *c);

static inline void alloc_memory()
{
	a_notcached = malloc(NUM_DATA*sizeof(float));
	b_notcached = malloc(NUM_DATA*sizeof(float));
	c_correct = malloc(NUM_DATA*sizeof(float));
	c_notcached = malloc(NUM_DATA*sizeof(float));
	c_cached = malloc(NUM_DATA*sizeof(float));
}

static inline void init_memory()
{
	int i;
	for(i = 0; i < NUM_DATA; i++)
	{
		a_notcached[i] = i;
		b_notcached[i] = NUM_DATA-i;
		c_notcached[i] = 0;
		compute(&(a_notcached[i]),&(b_notcached[i]),&(c_correct[i]));
	}
}

static inline void compute(const volatile float *a, const volatile float *b, float *c)
{
	float value_a, value_b;
	value_a = *a;
	value_b = *b;
	*c = (value_a / value_b) + (value_b / value_a);
}

void check_result(float* ref, float* result, int size)
{
	int i;
	int all_correct = 1;
	for(i = 0; i < size; i++)
	{
		int equal = 0;
		if(result[i]==ref[i])
			equal = 1;
		else
		{
			all_correct = 0;
			printf("\n[%1d@%d] %f %f", equal, i, ref[i], result[i]);
		}
	}
	if(all_correct)
		printf("\nall is correct");
	else
		printf("\nsome is incorrect");
}

int main()
{
	int i;
	int index_start, index_end, index_size;
	const int core_id = EXCLUSIVE_ID;
	const int num_data_per_core = NUM_DATA / NUM_CORE;
	volatile float *a_tcached, *b_tcached, *c_tcached;

	// init
	if(core_id==0)
	{
		alloc_memory();
		init_memory();
	}
	index_start = core_id*num_data_per_core;
	if(core_id==(NUM_CORE-1))
		index_end = NUM_DATA;
	else
		index_end = index_start + num_data_per_core;
	index_size = index_end - index_start;
	printf("\n[%d] %d ~ %d (%d)", core_id, index_start, index_end, index_size);
	flush_cache();
	reach_and_pass_barrier(0, NUM_CORE);

	// compute no-cache
	if(core_id==0)
		profiling_start("no-caching");
	for(i = index_start; i < index_end; i++)
	{
		compute(&(a_notcached[i]),&(b_notcached[i]),&(c_notcached[i]));
	}
	if(request_unique_grant(0, NUM_CORE))
	{
		profiling_end("no-caching");
		release_unique_grant(0, NUM_CORE); 
	}

	// prepare
	flush_cache();
	reach_and_pass_barrier(0, NUM_CORE);

	// compute tcaching
	if(core_id==0)
		profiling_start("tcaching");
	
	a_tcached = tcaching_malloc(&(a_notcached[index_start]), index_size*sizeof(float));
	b_tcached = tcaching_malloc(&(b_notcached[index_start]), index_size*sizeof(float));
	c_tcached = tcaching_malloc(&(c_cached[index_start]), index_size*sizeof(float));
	
	for(i = 0; i < index_size; i++)
	{
		compute(&(a_tcached[i]),&(b_tcached[i]),&(c_tcached[i]));
	}

	tcaching_free((void *)a_tcached);
	tcaching_free((void *)b_tcached);
	tcaching_free((void *)c_tcached);

	if(request_unique_grant(0, NUM_CORE))
	{
		profiling_end("tcaching");
		release_unique_grant(0, NUM_CORE);
	}

	// check
	if(core_id==0)
	{
		check_result(c_correct, c_notcached, NUM_DATA);
		check_result(c_correct, c_cached, NUM_DATA);
	}

	return 0;
}

