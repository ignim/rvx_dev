#include "ervp_uart.h"
#include "ervp_printf.h"
#include "ervp_variable_allocation.h"

#include "platform_info.h"
#include "arducam.h"
#include "oled_rgb.h"

#ifdef INCLUDE_JPEG_ENCODER
#include "jpeg_encoder.h"
#endif

#define IMAGE_WIDTH 96
#define IMAGE_HEIGHT 64

RvxImage raw_image;

char rgb_data[IMAGE_WIDTH*2*IMAGE_HEIGHT];

void custom_init_image()
{
	raw_image.width = IMAGE_WIDTH;
	raw_image.height = IMAGE_HEIGHT;
	raw_image.format = IMAGE_FMT_RGB_565_PACKED;

	raw_image.stride[0] = IMAGE_WIDTH * 2;
	raw_image.stride[1] = 0;
	raw_image.stride[2] = 0;

	raw_image.addr[0] = &rgb_data;
	raw_image.addr[1] = 0;
	raw_image.addr[2] = 0;
}

int main()
{
	RvxImage *image_to_export = 0;
	char key;

	/* take picture */
	arducam_init(ARDUCAM_RGB_565_QVGA);
	oled_rgb_start();
	//arducam_init_image_structure(&raw_image);
	custom_init_image();

	printf("Camera On\n");
	
	arducam_config_spi();
	arducam_single_capture(&raw_image);
	
	oled_rgb_config_spi();
	oled_rgb_draw_rvx_image(&raw_image);

	printf("Camera Stop\n");

#ifdef INCLUDE_JPEG_ENCODER
	while(1)
	{
		printf("types \'j\' for jpeg or \'b\' for bmp\n");
		key = getc_from_mcom();
		if((key=='b') || (key=='j'))
			break;
	}
#else
	key = 'b';
#endif

	switch(key)
	{
		case 'j':
#ifdef INCLUDE_JPEG_ENCODER
			/* convert jpeg */
			printf("convert jpeg\n");
			image_to_export = jpegenc_convert_image(&raw_image, 0);
#endif
			break;
		case 'b':
			/* convert bmp */
			printf("convert bmp\n");
			image_to_export = convert_image(&raw_image, 0, IMAGE_FMT_BMP);
			break;
		default:
			break;
	}
	prepare_image_dump(image_to_export);
	return 0;
}
