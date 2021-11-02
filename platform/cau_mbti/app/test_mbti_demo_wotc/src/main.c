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
#include "ervp_delay.h"
#include "arducam_driver.h"
//#include "arducam_ch.h"
#include "oled_rgb.h"

#ifdef INCLUDE_JPEG_ENCODER
#include "jpeg_encoder.h"
#endif
#include "math.h"
#include "stdbool.h"

#include "ervp_multicore_synch.h"
#include "ervp_profiling.h"
#include "ervp_memory_util.h"
#include "ervp_barrier.h"
#include "ervp_lock.h"


#define TCACHE 0
#define ROW_NUM_MAX 240
#define COL_NUM_MAX 320
#define C 3
#define TOTAL_PIXEL COL_NUM_MAX*ROW_NUM_MAX
#define ML 1

ErvpImage raw_image, raw_image_temp;
volatile unsigned int image_update = 0;
volatile unsigned int calculate_lbp = 0;
volatile unsigned int bt_transfer = 0;
volatile unsigned int first_pic = 1;
volatile unsigned int tick = 0;
volatile unsigned int picture_save = 0;


volatile unsigned char * image1_rgb888;
volatile unsigned char  * image2_rgb888;
volatile unsigned char * image_a_rgb565;


double calculate_mse(int* image_a_binhist, int* image_b_binhist);
void rgb2hist(unsigned char* image_a_rgb888, unsigned char* image_b_rgb888, int* image_a_binhist, int* image_b_binhist, unsigned char* image_a_r, unsigned char* image_a_g, unsigned char* image_a_b, unsigned char* image_b_r, unsigned char* image_b_g, unsigned char* image_b_b);
char binfinder(int arr);
void lbp(int x, int y, int width, int height, unsigned char * image, int* binhist, int binnum);
void RvxImage2Array(unsigned int addr, unsigned char* image_a_rgb888);
void gaussian_masking_4rgb888(unsigned char* image_a_rgb888);
void grayscale_4rgb888(unsigned char* image_a_rgb888);
void grayscale_4rgb565(unsigned int addr);
void Array2RvxImage(unsigned char* image_a_rgb888, unsigned int addr);
float calculate_psnr(unsigned char* image_a_rgb888, unsigned char* image_b_rgb888, int total_pixel, int first_pic);
void save_frame_rgb565(unsigned char* image_a_rgb565, unsigned char* image_b_rgb565, unsigned int addr, int tick);
void save_frame_rgb888(unsigned char* image_a_rgb888, unsigned char* image_b_rgb888, unsigned int addr, int tick);

void arducam_single_capture_(ErvpImage *image)
{
	uint8_t *data;
	uint32_t fifo_size;
	int stride;
	int height;
	uint8_t *line_data;
	int i,j;
	int hindex_next, sindex_next;
	int width_incr, stride_incr, height_incr;
	int temp;

	int arducam_format_ch = IMAGE_FMT_RGB_565_PACKED;
	int arducam_width_ch = 320;
	int arducam_height_ch = 240;
	int arducam_stride_ch = 640;

	data = (uint8_t *)image->addr[0];

	// flush the fifo
	arducam_spi_write_abyte(regSPICAM_FIFO, CLEAR_WRITE_FIFO_DONE_FLAG);
	// clear the fifo
	arducam_spi_write_abyte(regSPICAM_FIFO, CLEAR_WRITE_FIFO_DONE_FLAG);

	// start the capture
	arducam_spi_write_abyte(regSPICAM_FIFO, START_CAPTURE);
	//printf("capture start\n");

	// check done
	while( (arducam_spi_read_abyte(regSPICAM_STATUS) & CAMERA_WRITE_FIFO_DONE_FLAG) == 0) {
		delay_ms(1);
	}
	//printf("capture done\n");

	fifo_size = arducam_read_fifo_size();
	//printf("fifo size : %d\n", fifo_size);
	if (fifo_size >= ARDUCAM_MAX_FIFO_SIZE ) 
	{
		printf("Over size : %lu\n", fifo_size);
		arducam_spi_write_abyte(regSPICAM_FIFO, CLEAR_WRITE_FIFO_DONE_FLAG);
		return;
	}
	if (fifo_size == 0 ) //0 kb
	{
		printf("Size is 0\n");
		arducam_spi_write_abyte(regSPICAM_FIFO, CLEAR_WRITE_FIFO_DONE_FLAG);
		return;
	}

	stride = image->width<<1;
	if(stride > arducam_stride_ch)
		stride = arducam_stride_ch;
	height = image->height;
	if(height > arducam_height_ch)
		height = arducam_height_ch;

	if(stride==arducam_stride_ch)
	{
		arducam_spi_read_bytes(regSPICAM_BURST_READ, data, stride*height);
	}
	else if((image->width <= arducam_width_ch) && (image->height <= arducam_height_ch))
	{
		width_incr = 1;
		temp = image->width<<1;
		while(temp < arducam_width_ch)
		{
			temp += image->width;
			width_incr++;
		}
		stride_incr = width_incr<<1;
		height_incr = 1;
		temp = image->height<<1;
		while(temp < arducam_height_ch)
		{
			temp += image->height;
			height_incr++;
		}
		//printf("%d\n", stride_incr);
		//printf("%d\n", height_incr);

		for(i=0, hindex_next=0, line_data = data; i<(image->height*height_incr); i++)
		{
			if(i==hindex_next)
			{
				hindex_next += height_incr;
				for(j=0, sindex_next=0; j<(image->width*stride_incr); j+=2)
				{
					if(j==sindex_next)
					{
						sindex_next += stride_incr;
						*line_data++ = arducam_spi_read_abyte(regSPICAM_SINGLE_READ);
						*line_data++ = arducam_spi_read_abyte(regSPICAM_SINGLE_READ);
					}
					else
					{
						arducam_spi_read_abyte(regSPICAM_SINGLE_READ);
						arducam_spi_read_abyte(regSPICAM_SINGLE_READ);
					}
				}
				for(j=(image->width*stride_incr); j<arducam_stride_ch; j++)
				{
					arducam_spi_read_abyte(regSPICAM_SINGLE_READ);
				}
			}
			else
			{
				for(j=0; j<arducam_stride_ch; j++)
				{
					arducam_spi_read_abyte(regSPICAM_SINGLE_READ);
				}
			}
		}
	}
	else
	{
		for(i=0, line_data = data; i<height; i++, line_data+=(image->width<<1))
		{
			for(j=0; j<stride; j++)
			{
				line_data[j] = arducam_spi_read_abyte(regSPICAM_SINGLE_READ);
			}
			for(j=stride; j<arducam_stride_ch; j++)
			{
				arducam_spi_read_abyte(regSPICAM_SINGLE_READ);  // NOT USED
			}
		}
	}

	// clear the fifo done flag
	arducam_spi_write_abyte(regSPICAM_FIFO, CLEAR_WRITE_FIFO_DONE_FLAG);
}

int main()
{	
	ErvpImage *image_to_export = 0;
	char key;
	unsigned int jpeg_addr;
	int jpeg_size;
	
	int real_clock_start = 0, real_clock_end = 0, real_clock_timer = 0;

	int core_id = EXCLUSIVE_ID;	
	
	
	
	if (core_id==0){ 
	
		
		
		/* take picture */

		arducam_init(ARDUCAM_RGB_565_QVGA);
		oled_rgb_start();
		arducam_init_image_structure(&raw_image);
		arducam_init_image_structure(&raw_image_temp);
		acquire_lock(1);
		image1_rgb888= (unsigned char *)malloc(sizeof(char)*TOTAL_PIXEL*C);
		image2_rgb888 =(unsigned char *)malloc(sizeof(char)*TOTAL_PIXEL*C);
		release_lock(1);
		arducam_config_spi();
		oled_rgb_config_spi();
		
		while(1)
		{
			if ( image_update == 0 ) {
				real_clock_start = get_real_clock_tick();
				
				arducam_config_spi();
				arducam_single_capture_(&raw_image);
				
				if (picture_save == 0) arducam_single_capture_(&raw_image_temp);
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
				//printf("\n\tDRAW TIME %d ", real_clock_timer);	
				printf("\n--------------------------------------------------------------------------------------------");
				printf("\nDRAWING   ");
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
		image_a_rgb565 =(unsigned char *)malloc(sizeof(char)*TOTAL_PIXEL*2);
		release_lock(1);
		int addr;	
		float psnr;
		
		#if TCACHE
			volatile unsigned char *a_tcached, *b_tcached, *c_tcached;
		#endif 
		
		while(1)
		{
			if ( image_update == 1 ) {
				//printf("\n\t\t\tPSNR START ");
				addr = raw_image.addr[0];
				
				real_clock_start = get_real_clock_tick();
				
			#if TCACHE
				acquire_lock(1);
				flush_cache();
				a_tcached = tcaching_malloc(image_a_rgb888, sizeof(char)*total_pixel*3);
				b_tcached = tcaching_malloc(image_b_rgb888, sizeof(char)*total_pixel*3);
				save_frame_rgb888(a_tcached, b_tcached, addr, tick);
				
				release_lock(1);
				psnr = calculate_psnr(a_tcached, b_tcached, total_pixel, first_pic);

				tcaching_free((void *)a_tcached);
				tcaching_free((void *)b_tcached);
			#else
				acquire_lock(1);
				save_frame_rgb888(image_a_rgb888, image_b_rgb888, addr, tick);
				release_lock(1);
				psnr = calculate_psnr(image_a_rgb888, image_b_rgb888, total_pixel, first_pic);
			#endif 
				
				real_clock_end = get_real_clock_tick();

				printf("\n\t\tPSNR %.2f", psnr);
					
				real_clock_timer = real_clock_end - real_clock_start;
				printf("\n\t\tTIME %d", real_clock_timer);
				
				if (psnr >= 0 && psnr <= 25) {
					if ( calculate_lbp == 0 ) {
						for ( int i = 0; i < total_pixel * 3; i ++ ){
							image1_rgb888[i] = image_a_rgb888[i];
							image2_rgb888[i] = image_b_rgb888[i];
						}
						acquire_lock(0);
						calculate_lbp = 1;
						release_lock(0);
						//printf("\n\t\t\t\t\tLBP START \t");
					}
					//else if ( calculate_lbp == 1 ) printf("\n\t\t\t\t\tLBP BUSY \t");			
				}
				else if(psnr > 25) {
					printf("\n\t\t\t\t\tLBP PASS \t");
		 		}
		 		if ( picture_save == 0 ) printf("\n\t\t\t\t\t\t\t\tBT2 WAIT \t");
				else if ( picture_save == 1 ) printf("\n\t\t\t\t\t\t\t\tBT2 BUSY \t");
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
				
				if( mse > 100000 ) {
					acquire_lock(0);
					bt_transfer = 1;
					release_lock(0);
				}
				
				real_clock_timer = real_clock_end - real_clock_start;
				printf("\n\t\t\t\t\tLBP  %.2lf \t", mse);
				printf("\n\t\t\t\t\tTIME %d \t", real_clock_timer);
			}
		}
		return 0;
	}
	
	if(core_id == 3) {
		int i, j;
		int index;
		int x, y;
		int org_index;
		int end;
		ErvpImage *rgb565_image;
		/* take picture */
		//bluetooth_init(); // set uart board rate to 921600 Hz
		uart_config(UART_INDEX_FOR_BLUETOOTH, 115200*4);
		printf("\n\t\t\t\t\t\t\t\t\tpress space bar to stop and send\n");
		unsigned int btaddr = raw_image_temp.addr[0];
		volatile unsigned char* image_save_rgb565;
		
		while(1)
		{			
			//while(getc_from_mcom()!=' ');
			if( bt_transfer == 1 ) {
				btaddr = raw_image_temp.addr[0];
				acquire_lock(0);
				picture_save = 1;
				release_lock(0);
				printf("\n\t\t\t\t\t\t\t\tBT2 SEND \t");
	    		#if TCACHE
	    			real_clock_start = get_real_clock_tick();
				acquire_lock(1);
				flush_cache();
				image_save_rgb565 = tcaching_malloc(btaddr, sizeof(char)*ROW_NUM_MAX*COL_NUM_MAX*2);
				release_lock(1);
				bluetooth_send(image_save_rgb565, ROW_NUM_MAX*COL_NUM_MAX*2);
				tcaching_free((void *)image_save_rgb565);
	    			real_clock_end = get_real_clock_tick();
	    			int real_clock_timer1 = real_clock_end - real_clock_start;
			#else
				real_clock_start = get_real_clock_tick();
				bluetooth_send(btaddr, ROW_NUM_MAX*COL_NUM_MAX*2);
	    			real_clock_end = get_real_clock_tick();
	    			int real_clock_timer2 = real_clock_end - real_clock_start;
			#endif
				acquire_lock(0); 
				bt_transfer = 0; 
				picture_save = 0;
				release_lock(0);
				
				real_clock_timer = real_clock_end - real_clock_start;
				//printf("\n\t\t\t\t\t\t\tBT2 TIME %d \t", real_clock_timer);
				printf("\n\t\t\t\t\t\t\t\tBT2 END \t", real_clock_timer);
			}
		}

	}
	
	
	
}
