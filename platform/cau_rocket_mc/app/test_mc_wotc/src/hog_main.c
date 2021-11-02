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
#include "hog_header.h"

#define HOG_WIDTH 64
#define HOG_HEIGHT 64
#define ROW_NUM_MAX 240
#define COL_NUM_MAX 320
#define WIDTH 320
#define HEIGHT 240 

#define C 3
#define TOTAL_PIXEL COL_NUM_MAX*ROW_NUM_MAX
#define ML 1
#define TCACHE 0
#define CAPTURE_IMAGE 0
#define get_r(x) ((x & 0x1F)*527 +23) >>6
#define get_g(x) (((x & 0x7E0) >> 5)*259 + 33) >>6
#define get_b(x) (((x & 0x0000F800) >> 11)*527 +23) >>6

#define GET_GRAY(x) (unsigned char)((int)( (x & 0x001F)*30 + ((x & 0x07E0)>>5)*59 + ((x & 0xF800)>>11)*50 )/100)
ErvpImage raw_image;
ErvpImage *rgb565_image = 0;

volatile int image_update = 0;
int calculate_lbp = 0;
int first_pic = 1;
int tick = 0;

volatile unsigned char * image1_rgb888;
volatile unsigned char * image2_rgb888;
volatile unsigned char * image2_hog;


	char key;
	int jpeg_addr;
	int jpeg_size;	
	int i,j;
	int real_clock_start = 0, real_clock_end = 0, real_clock_timer = 0, real_clock_timer2=0;
	////////////////////////////////////////////////////////////////////////////////////
	//////////////////////        custom value  START       ////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////

 	int line = 0;
	int sizeind = 0;
	int temp, temp1, temp2, sub;
	int clock_tick[10] = {0};

	unsigned char  grey_image[HOG_WIDTH*HOG_HEIGHT] BIG_DATA;
	/////////////////////////ony for fore 0//////////////////////////////////
	//acquire_lock(0);
	uint16_t org_index,x,y;
//	double * resized_image = (double *)malloc((sizeof(double)*32*32));
int main(void){
	int core_id = EXCLUSIVE_ID;	
	if(core_id==0){ 

		/* take picture */

		//arducam_init(ARDUCAM_RGB_565_QVGA);
		//oled_rgb_start();
		//arducam_init_image_structure(&raw_image);
		acquire_lock(1);
		image1_rgb888= (unsigned char *)malloc(sizeof(char)*TOTAL_PIXEL*C);
		image2_rgb888 =(unsigned char *)malloc(sizeof(char)*TOTAL_PIXEL*C);
		image2_hog =(unsigned char *)malloc(sizeof(char)*TOTAL_PIXEL*C);	
		release_lock(1);
		//printf("image_1_rgb888:%x,size : %d\n",image1_rgb888,sizeof(char)*TOTAL_PIXEL*C);
		//printf("image_2_rgb888:%x,size : %d\n",image2_rgb888,sizeof(char)*TOTAL_PIXEL*C);	
		//printf("Camera On\n");
		//printf("Camera On\t");
		int iter=0;
		while(iter <4)
		{
			
			if ( image_update == 0 ) {
				iter= iter+1;
				// real_clock_start = get_real_clock_tick();
				// arducam_config_spi();
				// arducam_single_capture(&raw_image);
#if CAPTURE_IMAGE == 1
			for(j = 0; j < HOG_HEIGHT; j++)
			{
				for(i = 0; i < HOG_WIDTH; i++)
				{	x = (i * WIDTH / HOG_WIDTH);
					y = j * HEIGHT / HOG_HEIGHT;
					org_index = y * WIDTH + x;
					grey_image[i+j*HOG_WIDTH] =GET_GRAY(REG16(raw_image.addr[0] +org_index*2));
					//printf("grey_image[%d]= %d\n",org_index,grey_image[org_index]);			
				}
			}
#else
			printf("----------------------------------\n");
			printf("TEST IMAGE #%d: \n",iter);
			if( iter == 1){
				for(j = 0; j < HOG_HEIGHT; j++)
				{
					for(i = 0; i < HOG_WIDTH; i++){
						grey_image[j*HOG_WIDTH+i]=  IMG_V1[j*HOG_WIDTH+i];
					}	
				
				}
			}
			else if (iter == 2){
				for(j = 0; j < HOG_HEIGHT; j++)
				{
					for(i = 0; i < HOG_WIDTH; i++){
						grey_image[j*HOG_WIDTH+i]=  IMG_NV1[j*HOG_WIDTH+i];
					}	
				
				}				
			}
			else if (iter == 3){
				for(j = 0; j < HOG_HEIGHT; j++)
				{
					for(i = 0; i < HOG_WIDTH; i++){
						grey_image[j*HOG_WIDTH+i]=  IMG_V2[j*HOG_WIDTH+i];
					}	
				
				}				
			}
			else if (iter == 4){
				for(j = 0; j < HOG_HEIGHT; j++)
				{
					for(i = 0; i < HOG_WIDTH; i++){
						grey_image[j*HOG_WIDTH+i]=  IMG_NV2[j*HOG_WIDTH+i];
					}	
				
				}				
			}			

#endif	
				acquire_lock(0);
				image_update = 1;
				release_lock(0);


				if(has_input_from_mcom())
				{
					key = getc_from_mcom();
					if(key==' ')
						break;
				}
			}
	
		}
		//printf("Camera Stop\n");
	}
	if(core_id==1){
	//printf("core1 init\n");
	while(1){
		if ( image_update == 1 ) {		

	double * hog_output= (double *)malloc(sizeof(double)*1764);
#if TCACHE
		char * input_image_tcached  = (char *)tcaching_malloc(grey_image,sizeof(char)*HOG_WIDTH*HOG_HEIGHT);
	    //printf("init hog\n");
	    real_clock_start = get_real_clock_tick();
	    hog_feature(input_image_tcached, hog_output,1 );
	   // for(i =0; i<50; i++){
	   // 	printf("%lf\n",hog_output[i]);
	   // }
		double prob;
	    //printf("init svm\n");
		//real_clock_end = get_real_clock_tick();
		//real_clock_timer = real_clock_end - real_clock_start;	 
		//real_clock_start = get_real_clock_tick();   
		prob=predict(hog_output);
		real_clock_end = get_real_clock_tick();
		real_clock_timer2 = real_clock_end - real_clock_start;
		//printf("HOGTIME %d \n", real_clock_timer);
		printf("COMPUATION TIME %d \n", real_clock_timer2);
		//printf("probability:%f\n",prob);
		tcaching_free(input_image_tcached);			
#else	
	    //printf("init hog\n");
	    real_clock_start = get_real_clock_tick();
	    hog_feature(grey_image, hog_output,1);
	   // for(i =0; i<50; i++){
	   // 	printf("%lf\n",hog_output[i]);
	   // }
		double prob;
	    //printf("init svm\n");
		//real_clock_end = get_real_clock_tick();
		//real_clock_timer = real_clock_end - real_clock_start;	 
		//real_clock_start = get_real_clock_tick();   
		prob=predict(hog_output);
		real_clock_end = get_real_clock_tick();
		real_clock_timer2 = real_clock_end - real_clock_start;
		//printf("HOGTIME %d \n", real_clock_timer);
		printf("COMPUATION TIME %d \n", real_clock_timer2);
		//printf("probability:%f\n",prob);

#endif
		if(prob>0.7){
			printf("CAR DETECTED(%f%)\n",prob*100);
		}
		else {
			printf("CAR NOT DETECTED\n");
		}
		printf("----------------------------------\n");
		printf("\n");
				acquire_lock(0);
				image_update = 0;
				release_lock(0);
	}
	// goto	restart ;
	// }
 //    return 0;
}
}
 return 0;
}
