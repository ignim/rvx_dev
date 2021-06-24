#include "ervp_printf.h"
#include "ervp_mmio_util.h"
#include "munoc_api.h"
#include "ervp_external_peri_group_api.h"
#include "ervp_platform_controller_api.h"

#include "ervp_core_id.h"

int main() {
#ifdef VP_ENV
	printf("Hello Multi World! CORE ID %02d\n", EXCLUSIVE_ID);
#else
	if(is_sim())
		printf("C %02d\n", EXCLUSIVE_ID);
	else
	{
		printf("Hello Multi World! CORE ID : %02d\n", EXCLUSIVE_ID);
	}
#endif
	return 0;
}

