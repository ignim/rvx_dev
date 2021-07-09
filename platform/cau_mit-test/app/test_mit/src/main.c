#include "ervp_uart.h"
#include "ervp_printf.h"
#include "ervp_variable_allocation.h"
#include "ervp_profile.h"
#include "ervp_tcu.h"
#include "ervp_tcaching.h"
#include "ervp_core_id.h"
#include "ervp_delay.h"

#include "ervp_real_clock.h"

#include "platform_info.h"
#include "arducam.h"
#include "oled_rgb.h"

#ifdef INCLUDE_JPEG_ENCODER
#include "jpeg_encoder.h"
#endif
#include "math.h"



#include "ervp_core_id.h"

#include "ervp_multicore_synch.h"
#include "ervp_profiling.h"
#include "ervp_memory_util.h"
#include "ervp_barrier.h"
#include "ervp_lock.h"


#define TCACHE 1

#define ROW_NUM_MAX 240
#define COL_NUM_MAX 320
#define TOTAL_PIXEL COL_NUM_MAX*ROW_NUM_MAX


RvxImage raw_image;
int image_update = 0;
int calculate_lbp = 0;
int first_pic = 1;
int tick = 0;

unsigned char image1_rgb888[3*TOTAL_PIXEL];
unsigned char image2_rgb888[3*TOTAL_PIXEL];

//unsigned short image_temp_rgb888[3*TOTAL_PIXEL];
//int real_clock_start = 0, real_clock_end = 0, real_clock_timer = 0;


int main()
{	
	RvxImage *image_to_export = 0;
	char key;
	unsigned int jpeg_addr;
	int jpeg_size;
	
	int real_clock_start = 0, real_clock_end = 0, real_clock_timer = 0;

	int core_id = EXCLUSIVE_ID;	
	
	
	
	if(core_id==0){ 

		/* take picture */

		arducam_init(ARDUCAM_RGB_565_QVGA);
		oled_rgb_start();
		arducam_init_image_structure(&raw_image);

		//printf("Camera On\n");
		//printf("Camera On\t");
		
		while(1)
		{
			printf("");
			if ( image_update == 0 ) {
				printf("\n");
				real_clock_start = get_real_clock_tick();
				arducam_config_spi();
				arducam_single_capture(&raw_image);
				
				acquire_lock(0);
				image_update = 1;
				release_lock(0);

				
				/* init oled & draw picture */
				oled_rgb_config_spi();
				oled_rgb_draw_rvx_image(&raw_image);

				if (tick == 1) {
					tick = 0;
					first_pic = 0;
				}
				else tick = 1;
				
				real_clock_end = get_real_clock_tick();
				real_clock_timer = real_clock_end - real_clock_start;
				printf("\tDRAW TIME %d ", real_clock_timer);


				if(has_input_from_mcom())
				{
					key = getc_from_mcom();
					if(key==' ')
						break;
				}
			}
		}
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
	
	
	if(core_id == 1) {
		int total_pixel = TOTAL_PIXEL;

		//unsigned char *image_a_rgb565 = (unsigned char *)malloc((sizeof(int)*total_pixel*3));
		//unsigned char *image_b_rgb565 = (unsigned char *)malloc((sizeof(int)*total_pixel*3));
		unsigned char *image_a_rgb565 = malloc((sizeof(char)*total_pixel*3));
		unsigned char *image_b_rgb565 = malloc((sizeof(char)*total_pixel*3));
		
		int addr;	
		float psnr;
		
		#if TCACHE
			volatile char *a_tcached, *b_tcached, *c_tcached;
		#endif 
		
		while(1)
		{
			printf("");
			if( image_update == 1 ) {
				printf("\tPSNR START ");
				addr = raw_image.addr[0];
				
				real_clock_start = get_real_clock_tick();
				
				#if TCACHE
					flush_cache();
					a_tcached = tcaching_malloc(image_a_rgb565, sizeof(char)*total_pixel*3);
					b_tcached = tcaching_malloc(image_b_rgb565, sizeof(char)*total_pixel*3);
					
					psnr = calculate_psnr(a_tcached, b_tcached, addr, total_pixel, tick, first_pic);

					tcaching_free((void *)a_tcached);
					tcaching_free((void *)b_tcached);
				#else
					psnr = calculate_psnr(image_a_rgb565, image_b_rgb565, addr, total_pixel, tick, first_pic);
				#endif 
				
				real_clock_end = get_real_clock_tick();
				
				printf("\tPSNR : %.2f", psnr);
				if(psnr > 0 && psnr <= 20) {
					if ( calculate_lbp == 0 ) {
						acquire_lock(0);
						calculate_lbp = 1;
						release_lock(0);
						printf("\tLBP START ");
						for ( int i = 0; i < total_pixel * 3; i ++ ){
							image1_rgb888[i] = image_a_rgb565[i];
							image2_rgb888[i] = image_b_rgb565[i];
						}
					}
					else if ( calculate_lbp == 1 ) 					
						printf("\tLBP BUSY ");
				}
				else if(psnr > 20) printf("\tLBP PASS ");
				
				
				acquire_lock(0);
				image_update = 0;
				release_lock(0);		
						
				
				real_clock_timer = real_clock_end - real_clock_start;
				printf("\tPSNR TIME %d ", real_clock_timer);
			}
		}
		return 0;
	}
	
	if(core_id == 2) {
		int total_pixel = TOTAL_PIXEL;
		
		int addr;
		double mse = 0;
		int width = COL_NUM_MAX;
		int height = ROW_NUM_MAX;
		unsigned int image1_binhist[30] = { 0 };
		unsigned int image2_binhist[30] = { 0 };
		#if TCACHE
			volatile char *a_tcached, *b_tcached, *c_tcached;
		#endif
		int i;
		while(1)
		{
			printf("");
			if( calculate_lbp == 1 ) {
				
				addr = raw_image.addr[0];
				
				real_clock_start = get_real_clock_tick();
				#if TCACHE
					flush_cache();
					a_tcached = tcaching_malloc(image1_rgb888, sizeof(char)*total_pixel*3);
					b_tcached = tcaching_malloc(image2_rgb888, sizeof(char)*total_pixel*3);
					
					rgb2hist(a_tcached, b_tcached, image1_binhist, image2_binhist);
					 
					tcaching_free((void *)a_tcached);
					tcaching_free((void *)b_tcached);
				#else
					rgb2hist(image1_rgb888, image2_rgb888, image1_binhist, image2_binhist);
					
				#endif 
				//printf("\n binhist_1 ");
				//for(i = 0; i < 10; i++) printf("%d ",image1_binhist[i]);
				//for(i = 10; i < 20; i++) printf("%d ",image1_binhist[i]);
				//for(i = 20; i < 30; i++) printf("%d ",image1_binhist[i]);
				//printf("\n binhist_2 ");
				//for(i = 0; i < 10; i++) printf("%d ",image2_binhist[i]);
				//for(i = 10; i < 20; i++) printf("%d ",image2_binhist[i]);
				//for(i = 20; i < 30; i++) printf("%d ",image2_binhist[i]);
				//printf("\n");
				mse = calculate_mse(image1_binhist, image2_binhist);
				real_clock_end = get_real_clock_tick();
				
				acquire_lock(0);
				calculate_lbp = 0;
				release_lock(0);
				
				real_clock_timer = real_clock_end - real_clock_start;
				printf("\t\t\t\t\t\t\t\t\t\t\t\t\tMSE : %7.2lf", mse);
				printf("\tLBP TIME %d \n", real_clock_timer);
			}
		}
		return 0;
	}
	
	if(core_id == 3) {
		while(1)
		{
			printf("");
			if(has_input_from_mcom())
			{
				key = getc_from_mcom();
				if(key==' ')
					break;
			}
			delay_sec(1);
		}
		return 0;
	}
	
	
	
}
