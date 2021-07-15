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
#include "stdbool.h"
#include "input.h"
#include "hog_header.h"



#include "ervp_core_id.h"

#include "ervp_multicore_synch.h"
#include "ervp_profiling.h"
#include "ervp_memory_util.h"
#include "ervp_barrier.h"
#include "ervp_lock.h"


#define TCACHE 1
#define HOG_WIDTH 64
#define HOG_HEIGHT 64
#define ROW_NUM_MAX 240
#define COL_NUM_MAX 320
#define C 3
#define TOTAL_PIXEL COL_NUM_MAX*ROW_NUM_MAX
#define ML 1

RvxImage raw_image;
volatile int image_update = 0;
volatile int calculate_lbp = 0;
volatile int calculate_hog_svm = 0;
volatile int first_pic = 1;
volatile int tick = 0;

volatile unsigned char * image1_rgb888;
volatile unsigned char  * image2_rgb888;
volatile unsigned char * image2_hog;

//unsigned short image_temp_rgb888[3*TOTAL_PIXEL];
//int real_clock_start = 0, real_clock_end = 0, real_clock_timer = 0;

double calculate_mse(int* image_a_binhist, int* image_b_binhist);
void rgb2hist(unsigned char* image_a_rgb888, unsigned char* image_b_rgb888, int* image_a_binhist, int* image_b_binhist, unsigned char* image_a_r, unsigned char* image_a_g, unsigned char* image_a_b, unsigned char* image_b_r, unsigned char* image_b_g, unsigned char* image_b_b);
char binfinder(int arr);
void lbp(int x, int y, int width, int height, unsigned char * image, int* binhist, int binnum);
void RvxImage2Array(unsigned int addr, unsigned char* image_a_rgb888);
void gaussian_masking_4rgb888(unsigned char* image_a_rgb888);
void grayscale_4rgb888(unsigned char* image_a_rgb888);
void grayscale_4rgb565(unsigned int addr);
void Array2RvxImage(unsigned char* image_a_rgb888, unsigned int addr);
float calculate_psnr(char* image_a_rgb888, char* image_b_rgb888, int addr, int total_pixel, int tick, int first_pic);


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
		acquire_lock(1);
		image1_rgb888= (unsigned char *)malloc(sizeof(char)*TOTAL_PIXEL*C);
		image2_rgb888 =(unsigned char *)malloc(sizeof(char)*TOTAL_PIXEL*C);
		image2_hog =(unsigned char *)malloc(sizeof(char)*TOTAL_PIXEL*C);	
		release_lock(1);
		//printf("image_1_rgb888:%x,size : %d\n",image1_rgb888,sizeof(char)*TOTAL_PIXEL*C);
		//printf("image_2_rgb888:%x,size : %d\n",image2_rgb888,sizeof(char)*TOTAL_PIXEL*C);	
		//printf("Camera On\n");
		//printf("Camera On\t");
		
		while(1)
		{
			if ( image_update == 0 ) {
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
				printf("\n\tDRAW TIME %d ", real_clock_timer);


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
		acquire_lock(1);
		volatile unsigned char *image_a_rgb888 = malloc((sizeof(char)*total_pixel*3));
		volatile unsigned char *image_b_rgb888 = malloc((sizeof(char)*total_pixel*3));
		release_lock(1);
		//printf("image_a_rgb888:%x, size :%d\n",image_a_rgb888,sizeof(char)*total_pixel*3);
		//printf("image_b_rgb888:%x, size :%d\n",image_b_rgb888,sizeof(char)*total_pixel*3);
		int addr;	
		float psnr;
		
		#if TCACHE
			volatile unsigned char *a_tcached, *b_tcached, *c_tcached;
		#endif 
		
		while(1)
		{
			if( image_update == 1 ) {
				printf("\n\t\t\t\tPSNR START ");
				addr = raw_image.addr[0];
				
				real_clock_start = get_real_clock_tick();
				
				#if TCACHE
					acquire_lock(1);
					flush_cache();
					a_tcached = tcaching_malloc(image_a_rgb888, sizeof(char)*total_pixel*3);
					b_tcached = tcaching_malloc(image_b_rgb888, sizeof(char)*total_pixel*3);
					release_lock(1);
					psnr = calculate_psnr(a_tcached, b_tcached, addr, total_pixel, tick, first_pic);

					tcaching_free((void *)a_tcached);
					tcaching_free((void *)b_tcached);
				#else
					psnr = calculate_psnr(image_a_rgb888, image_b_rgb888, addr, total_pixel, tick, first_pic);
				#endif 
				
				real_clock_end = get_real_clock_tick();
				
				printf("\n\t\t\t\tPSNR : %.2f", psnr);
				real_clock_timer = real_clock_end - real_clock_start;
				printf("\n\t\t\t\tPSNR TIME %d", real_clock_timer);
				
				if(psnr > 0 && psnr <= 20) {
					if ( calculate_lbp == 0 ) {
	
						for ( int i = 0; i < total_pixel * 3; i ++ ){
							image1_rgb888[i] = image_a_rgb888[i];
							image2_rgb888[i] = image_b_rgb888[i];
							image2_hog[i] = image_b_rgb888[i];
						}
						acquire_lock(0);
						calculate_lbp = 1;
						release_lock(0);
						printf("\n\t\t\t\t\t\t\tLBP START ");
					}
					else if ( calculate_lbp == 1 ) 					
						printf("\n\t\t\t\t\t\t\tLBP BUSY ");
					if ( calculate_hog_svm == 0 ) {
						acquire_lock(0);
						calculate_hog_svm = 1;
						release_lock(0);
					}
					else if ( calculate_hog_svm == 1 ) 					
						printf("\n\t\t\t\t\t\t\tHOG BUSY ");
				}
				else if(psnr > 20) {
					printf("\n\t\t\t\t\t\t\tLBP PASS ");
			 		printf("\n\t\t\t\t\t\t\t\t\t\tHOG PASS \t\t\t");
		 		}	
				acquire_lock(0);
				image_update = 0;
				release_lock(0);		
						
				
				
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
		acquire_lock(1);
		unsigned char* image_a_r = (unsigned char*)malloc(sizeof(char) * total_pixel);
		unsigned char* image_a_g = (unsigned char*)malloc(sizeof(char) * total_pixel);
		unsigned char* image_a_b = (unsigned char*)malloc(sizeof(char) * total_pixel);
		unsigned char* image_b_r = (unsigned char*)malloc(sizeof(char) * total_pixel);
		unsigned char* image_b_g = (unsigned char*)malloc(sizeof(char) * total_pixel);
		unsigned char* image_b_b = (unsigned char*)malloc(sizeof(char) * total_pixel);
		release_lock(1);
		#if TCACHE
			volatile char *a_tcached, *b_tcached, *c_tcached;
		#endif
		int i;
		while(1)
		{
			if( calculate_lbp == 1 ) {
				
				addr = raw_image.addr[0];
				
				real_clock_start = get_real_clock_tick();
				#if TCACHE
					acquire_lock(1);
					flush_cache();
					
					a_tcached = tcaching_malloc(image1_rgb888, sizeof(char)*total_pixel*3);
					b_tcached = tcaching_malloc(image2_rgb888, sizeof(char)*total_pixel*3);
					release_lock(1);
					rgb2hist(a_tcached, b_tcached, image1_binhist, image2_binhist, image_a_r, image_a_g, image_a_b, image_b_r, image_b_g, image_b_b);
					 
					tcaching_free((void *)a_tcached);
					tcaching_free((void *)b_tcached);
				#else
					rgb2hist(image1_rgb888, image2_rgb888, image1_binhist, image2_binhist, image_a_r, image_a_g, image_a_b, image_b_r, image_b_g, image_b_b);
					
				#endif
				mse = calculate_mse(image1_binhist, image2_binhist);
				real_clock_end = get_real_clock_tick();
				
				acquire_lock(0);
				calculate_lbp = 0;
				release_lock(0);
				
				real_clock_timer = real_clock_end - real_clock_start;
				printf("\n\t\t\t\t\t\t\tMSE : %7.2lf", mse);
				printf("\n\t\t\t\t\t\t\tLBP TIME %d", real_clock_timer);
			}
		}
		return 0;
	}
	
	if(core_id == 3) {
	#if ML
		int total_pixel = TOTAL_PIXEL;
		acquire_lock(1);
		volatile double * hog_output= (double *)malloc(sizeof(double)*1764);
		volatile unsigned char * resized_gray =(unsigned char *)malloc(sizeof(char)*64*64);
		release_lock(1);
		//printf("\nhog_output:%x, size :%d",hog_output,sizeof(double)*1764);
		//printf("\nresized_gray:%x, size :%d",resized_gray,sizeof(char)*64*64);
		double prob;
		int org_index,x,y;

		#if TCACHE
			//volatile unsigned char *IMG_cached;
			volatile unsigned char  * b_tcached,* resized_gray_cached;
			volatile double *hog_output_cached;
		#endif
		while(1)
		{
			if( calculate_hog_svm == 1 ) {
				printf("\n\t\t\t\t\t\t\t\t\t\tHOG START\t\t\t");
				real_clock_start = get_real_clock_tick();
				#if TCACHE
					acquire_lock(1);
					flush_cache();
					b_tcached = tcaching_malloc(image2_hog, sizeof(char)*total_pixel*3);
					resized_gray_cached = tcaching_malloc(resized_gray, sizeof(char)*64*64);
					hog_output_cached= (double *)tcaching_malloc(&hog_output[0], sizeof(double)*1764);
					release_lock(1);
					//converto grayscale and resize to 64*64
					for(int j = 0; j < HOG_HEIGHT; j++){
						for(int i = 0; i < HOG_WIDTH; i++){
							x = (i * COL_NUM_MAX / HOG_WIDTH);
							y = j * ROW_NUM_MAX / HOG_HEIGHT;
							org_index = y * COL_NUM_MAX + x;
							resized_gray_cached[i+j*HOG_WIDTH] = (unsigned char)((b_tcached[3*org_index+2]*30 +b_tcached[3*org_index+1]*59+b_tcached[3*org_index]*11)/100);
						}
					}
					tcaching_free((char *)b_tcached);


					//IMG_cached = tcaching_malloc(IMG_V1, sizeof(char)*64*64);
					hog_feature(resized_gray_cached, hog_output_cached,0 );
					//hog_feature(IMG_NV1, hog_output_cached,0 );
					prob=predict(hog_output_cached);					 
					//tcaching_free((void *)IMG_cached);
					tcaching_free((double *)hog_output_cached);
					tcaching_free((char *)resized_gray_cached);

				#else
					for(int j = 0; j < HOG_HEIGHT; j++){
						for(int i = 0; i < HOG_WIDTH; i++){
							x = (i * COL_NUM_MAX / HOG_WIDTH);
							y = j * ROW_NUM_MAX / HOG_HEIGHT;
							org_index = y * COL_NUM_MAX + x;
							resized_gray[i+j*HOG_WIDTH] = (unsigned char)((image2_hog[3*org_index+2]*30 +image2_hog[3*org_index+1]*59+image2_hog[3*org_index]*11)/100);
						}
					}

					//hog_feature(IMG_V2, hog_output,0 );
					hog_feature(resized_gray, hog_output,0 );
					prob=predict(hog_output);
					free(hog_output);
				#endif 
				printf("\n\t\t\t\t\t\t\t\t\t\tCAR Prob. %.4f", prob);
				if(prob > 0.7){
					printf("\n\t\t\t\t\t\t\t\t\t\tCAR Detect");
				}
				else{
					printf("\n\t\t\t\t\t\t\t\t\t\tCAR Detect");
				} 

				real_clock_end = get_real_clock_tick();
				
				acquire_lock(0);
				calculate_hog_svm = 0;
				release_lock(0);
				
				real_clock_timer = real_clock_end - real_clock_start;

				printf("\n\t\t\t\t\t\t\t\t\t\tHOG TIME %d \n", real_clock_timer);
				free(hog_output);
				free(resized_gray);
			}
		}
		return 0;
	#endif
	}
	
	
	
}
