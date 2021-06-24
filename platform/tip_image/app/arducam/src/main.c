#include "ervp_core_id.h"
#include "ervp_uart.h"
#include "ervp_printf.h"

#include "oled_rgb.h"
#include "arducam.h"
#include "ervp_image.h"

#define RGB_INPUT

RvxImage arducam_image;
RvxImage *rgb565_image = 0;

int main()
{
	if(EXCLUSIVE_ID==0)
	{

#ifdef RGB_INPUT
		arducam_init(ARDUCAM_RGB_565_QVGA);
#else
		arducam_init(ARDUCAM_YUV_422_QVGA);
#endif
		arducam_init_image_structure(&arducam_image);
		//arducam_set_test_color_bar();

		oled_rgb_start();
		oled_rgb_clear();

		while(1)
		{
			arducam_config_spi();
			arducam_single_capture(&arducam_image);
			if(arducam_image.format != IMAGE_FMT_RGB_565_PACKED)
				rgb565_image = convert_image(&arducam_image, rgb565_image, IMAGE_FMT_RGB_565_PACKED);
			else
				rgb565_image = &arducam_image;

			oled_rgb_config_spi();
			oled_rgb_draw_rvx_image(rgb565_image);

			if(has_input_from_mcom())
			{
				char key = getc_from_mcom();
				if(key==' ')
					break;
			}
		}
		oled_rgb_end();
	}
	return 0;
}
