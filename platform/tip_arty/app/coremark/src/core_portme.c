#include <stdio.h>
#include <stdlib.h>
#include "coremark.h"
#include "platform_info.h"
#include "csr_encoding.h"
#include "ervp_real_clock.h"

#if VALIDATION_RUN
	volatile ee_s32 seed1_volatile=0x3415;
	volatile ee_s32 seed2_volatile=0x3415;
	volatile ee_s32 seed3_volatile=0x66;
#endif

#if PERFORMANCE_RUN
	volatile ee_s32 seed1_volatile=0x0;
	volatile ee_s32 seed2_volatile=0x0;
	volatile ee_s32 seed3_volatile=0x66;
#endif

#if PROFILE_RUN
	volatile ee_s32 seed1_volatile=0x8;
	volatile ee_s32 seed2_volatile=0x8;
	volatile ee_s32 seed3_volatile=0x8;
#endif

volatile ee_s32 seed4_volatile=ITERATIONS;
volatile ee_s32 seed5_volatile=0;

static CORE_TICKS t0, t1;

void start_time(void)
{
  t0 = get_real_clock_tick();
}

void stop_time(void)
{
  t1 = get_real_clock_tick();
}

CORE_TICKS get_time(void)
{
  return t1 - t0;
}

secs_ret time_in_secs(CORE_TICKS ticks)
{
  // scale timer down to avoid uint64_t -> double conversion in RV32
  const int scale = 8;
  uint32_t delta = ticks >> scale;
  uint32_t freq = get_timer_freq() >> scale;
  return ((secs_ret)delta) / freq;
}

uint64_t get_timer_value()
{
	return get_real_clock_tick();
}

unsigned long get_cpu_freq()
{
  return CPU_FREQ;
}

unsigned long get_timer_freq()
{
  return TIMER_FREQ;
}



