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


double calculate_mse(int* image_a_binhist, int* image_b_binhist){
	
	unsigned int sum_r = 0, sum_g = 0, sum_b = 0;
	int sub = 0;
	
	for (int i = 0; i < 10; i++)
	{
		sub = image_a_binhist[i] - image_b_binhist[i];
		sum_r += (unsigned int) (sub * sub);
		sub = image_a_binhist[i+10] - image_b_binhist[i+10];
		sum_g += (unsigned int) (sub * sub);
		sub = image_a_binhist[i+20] - image_b_binhist[i+20];
		sum_b += (unsigned int) (sub * sub);
	}
	//printf("sum_r %u  sum_g %u  sum_b %u \n", sum_r, sum_g, sum_b);
	//unsigned int sum = sum_r + sum_g + sum_b;
	double mse = (double) (sum_r + sum_g + sum_b) * (double) 0.0333333333;

	//printf("sum %u  mse %f\n", sum, mse);
	
	return mse;

}

void rgb2hist(unsigned char* image_a_rgb888, unsigned char* image_b_rgb888, int* image_a_binhist, int* image_b_binhist, unsigned char* image_a_r, unsigned char* image_a_g, unsigned char* image_a_b, unsigned char* image_b_r, unsigned char* image_b_g, unsigned char* image_b_b) {
	int width = COL_NUM_MAX;
	int height = ROW_NUM_MAX;
	int total_pixel = TOTAL_PIXEL;
	
	//unsigned char* image_a_r = (unsigned char*)malloc(sizeof(char) * total_pixel);
	//unsigned char* image_a_g = (unsigned char*)malloc(sizeof(char) * total_pixel);
	//unsigned char* image_a_b = (unsigned char*)malloc(sizeof(char) * total_pixel);
	//unsigned char* image_b_r = (unsigned char*)malloc(sizeof(char) * total_pixel);
	//unsigned char* image_b_g = (unsigned char*)malloc(sizeof(char) * total_pixel);
	//unsigned char* image_b_b = (unsigned char*)malloc(sizeof(char) * total_pixel);
	
	int image_a_r_binhist[10] = { 0 };
	int image_a_g_binhist[10] = { 0 };
	int image_a_b_binhist[10] = { 0 };
	int image_b_r_binhist[10] = { 0 };
	int image_b_g_binhist[10] = { 0 };
	int image_b_b_binhist[10] = { 0 };
	
	#if TCACHE
		volatile char *a_tcached, *b_tcached, *c_tcached;
	#endif
	
	for (int i = 0; i < total_pixel; i++) {
		image_a_r[i] = image_a_rgb888[i*3+0];
		image_a_g[i] = image_a_rgb888[i*3+1];
		image_a_b[i] = image_a_rgb888[i*3+2];	
	}
	
	#if TCACHE
		acquire_lock(1);
		flush_cache();
		a_tcached = tcaching_malloc(image_a_r, sizeof(char)*total_pixel);
		b_tcached = tcaching_malloc(image_a_g, sizeof(char)*total_pixel);
		c_tcached = tcaching_malloc(image_a_b, sizeof(char)*total_pixel);
		release_lock(1);		
				
		lbp(0, 0, width, height, a_tcached, image_a_r_binhist, 0);
		lbp(0, 0, width, height, b_tcached, image_a_g_binhist, 0);
		lbp(0, 0, width, height, c_tcached, image_a_b_binhist, 0);
		
		tcaching_free((void *)a_tcached);
		tcaching_free((void *)b_tcached);
		tcaching_free((void *)c_tcached);
	#else
		lbp(0, 0, width, height, image_a_r, image_a_r_binhist, 0);
		lbp(0, 0, width, height, image_a_g, image_a_g_binhist, 0);
		lbp(0, 0, width, height, image_a_b, image_a_b_binhist, 0);
	#endif
	
	for (int i = 0; i < 10; i++) {
		image_a_binhist[i] = image_a_r_binhist[i];
		image_a_binhist[i+10] = image_a_g_binhist[i];
		image_a_binhist[i+20] = image_a_b_binhist[i];
	}

	for (int i = 0; i < total_pixel; i++) {
		image_b_r[i] = image_b_rgb888[i*3+0];
		image_b_g[i] = image_b_rgb888[i*3+1];
		image_b_b[i] = image_b_rgb888[i*3+2];	
	}
	
	#if TCACHE
		acquire_lock(1);
		flush_cache();
		a_tcached = tcaching_malloc(image_b_r, sizeof(char)*total_pixel);
		b_tcached = tcaching_malloc(image_b_g, sizeof(char)*total_pixel);
		c_tcached = tcaching_malloc(image_b_b, sizeof(char)*total_pixel);
		release_lock(1);
		lbp(0, 0, width, height, a_tcached, image_b_r_binhist, 0);
		lbp(0, 0, width, height, b_tcached, image_b_g_binhist, 0);
		lbp(0, 0, width, height, c_tcached, image_b_b_binhist, 0);
		
		tcaching_free((void *)a_tcached);
		tcaching_free((void *)b_tcached);
		tcaching_free((void *)c_tcached);
	#else
		lbp(0, 0, width, height, image_b_r, image_b_r_binhist, 0);
		lbp(0, 0, width, height, image_b_g, image_b_g_binhist, 0);
		lbp(0, 0, width, height, image_b_b, image_b_b_binhist, 0);
	#endif

	for (int i = 0; i < 10; i++) {
		image_b_binhist[i] = image_b_r_binhist[i];
		image_b_binhist[i+10] = image_b_g_binhist[i];
		image_b_binhist[i+20] = image_b_b_binhist[i];
	}

	free(image_a_r);
	free(image_a_g);
	free(image_a_b);
	free(image_b_r);
	free(image_b_g);
	free(image_b_b);

}

char binfinder(int arr)
{
	char idx;

	switch (arr)
	{
		case 0:
			idx = 0;
			break; 
		case 1: 
		case 2:
		case 4:
		case 8:
		case 16:
		case 32:
		case 64:
		case 128:
			idx = 1;
			break;
		case 3:
		case 6:
		case 12:
		case 24:
		case 48:
		case 96:
		case 192:
		case 129:
			idx = 2;
			break;
		case 7:
		case 14:
		case 28:
		case 56:
		case 112:
		case 224:
		case 131:
		case 193:
			idx = 3;
			break;
		case 15:
		case 30:
		case 60:
		case 120:
		case 240:
		case 135:
		case 195:
		case 225:
			idx = 4;
			break;
		case 31:
		case 62:
		case 124:
		case 248:
		case 143:
		case 199:
		case 227:
		case 241:
			idx = 5;
			break;
		case 63:
		case 126:
		case 252:
		case 159:
		case 207:
		case 231:
		case 243:
		case 249:
			idx = 6;
			break;
		case 127:
		case 254:
		case 191:
		case 223:
		case 239:
		case 247:
		case 251:
		case 253:
			idx = 7;
			break;
		case 255:
			idx = 8;
			break;
		default:
			idx = 9;
			break;
	}

	return idx;
}

void lbp(int x, int y, int width, int height, unsigned char * image, int* binhist, int binnum)
{
	int arr;
	int idx;

	for (int i = x + 1; i < (x + height - 1); i++)
	{
		for (int j = y + 1; j < (y + width - 1); j++)
		{
			arr = 0;
			if ( image[width * (i - 1) + j - 1] >= image[width * i + j] ) 
				arr += 1;
			if ( image[width * (i - 1) + j] >= image[width * i + j] ) 
				arr += 2;
			if ( image[width * (i - 1) + j + 1] >= image[width * i + j] ) 
				arr += 4;
			if ( image[width * i + j + 1] >= image[width * i + j] ) 
				arr += 8;
			if ( image[width * (i + 1) + j + 1] >= image[width * i + j] ) 
				arr += 16;
			if ( image[width * (i + 1) + j] >= image[width * i + j] ) 
				arr += 32;
			if ( image[width * (i + 1) + j - 1] >= image[width * i + j] ) 
				arr += 64;
			if ( image[width * i + j - 1] >= image[width * i + j] ) 
				arr += 128;
			idx = binfinder(arr);
			*(binhist + binnum + idx) += 1;
		}
	}
}


void RvxImage2Array(unsigned int addr, unsigned char* image_a_rgb888){

	int temp, temp1, temp2;
	unsigned int total_pixel = TOTAL_PIXEL;
	
	for ( int i = 0; i < total_pixel/2; i ++ ){
		temp = REG32(addr + i*4);
		temp1 = temp & 0x0000FFFF;
		temp2 = (temp & 0xFFFF0000) >> 16;
		image_a_rgb888[i*6+0] = (unsigned char)((temp1 & 0x001F)*527+23 >> 6);
		image_a_rgb888[i*6+1] = (unsigned char)(((temp1 & 0x07E0) >> 5)*259+33 >> 6);
		image_a_rgb888[i*6+2] = (unsigned char)(((temp1 & 0xF800) >> 11)*527+23 >> 6);
		image_a_rgb888[i*6+3] = (unsigned char)((temp2 & 0x001F)*527+23 >> 6);
		image_a_rgb888[i*6+4] = (unsigned char)(((temp2 & 0x07E0) >> 5)*259+33 >> 6);
		image_a_rgb888[i*6+5] = (unsigned char)(((temp2 & 0xF800) >> 11)*527+23 >> 6);
	}

}

void gaussian_masking_4rgb888(unsigned char* image_a_rgb888){
	unsigned int gaussianMask_array[25] = { 1, 4, 7, 4, 1, 4, 16, 26, 16, 4, 7, 26, 41, 26, 7, 4, 16, 26, 16, 4, 1, 4, 7, 4, 1 };
	unsigned int gaussian_constant = 273;
	unsigned int W = COL_NUM_MAX, H = ROW_NUM_MAX;
	unsigned int total_pixel = TOTAL_PIXEL;
	int row, col;
	long iOffset;
	int rowOffset;
	int colOffset;
	int rowTotal = 0;
	int colTotal = 0;
	
	unsigned int rgb, i, temp;
	int pixel_site;
	unsigned long newPixel = 0;
	
	//unsigned char *image_temp_rgb888 = (unsigned char *)malloc((sizeof(char)*total_pixel*3));
	unsigned char image_temp_rgb888[TOTAL_PIXEL*3];
	int wrong = 0;
	for (int i = 2; i < (H - 2); i++) {
		for (int j = 2; j < (W - 2); j++) {
			for (rgb = 0; rgb < 3; rgb++) {
				newPixel = 0;
				for (rowOffset = -2; rowOffset <= 2; rowOffset++) {
					for (colOffset = -2; colOffset <= 2; colOffset++) {
						rowTotal = i + rowOffset;
						colTotal = j + colOffset;
						iOffset = rowTotal * 3 * W + colTotal * 3 + rgb;
						newPixel += image_a_rgb888[iOffset] * gaussianMask_array[(rowOffset + 2) * 5 + colOffset + 2] ;				
					}
				}
				pixel_site = i  * 320 * 3 + j * 3 + rgb;
				image_temp_rgb888[pixel_site] = newPixel / gaussian_constant;	
			}
		}
	}
	for (int i = 0; i < total_pixel*3; i++) {
		image_a_rgb888[i] = image_temp_rgb888[i];
	}
	//free(image_temp_rgb888);
}
void grayscale_4rgb888(unsigned char* image_a_rgb888){
	
	unsigned int total_pixel = TOTAL_PIXEL;
	unsigned int avg;
	for ( int i = 0; i < total_pixel; i ++ ){
		avg = (image_a_rgb888[i * 3 + 0]+image_a_rgb888[i * 3 + 1]+image_a_rgb888[i * 3 + 2]) / 3;
		image_a_rgb888[i * 3 + 0] = avg;
		image_a_rgb888[i * 3 + 1] = avg;
		image_a_rgb888[i * 3 + 2] = avg;
	}
}

void grayscale_4rgb565(unsigned int addr){
	
	unsigned int temp, temp1, temp2;
	unsigned int avg, avg_5bit;
	unsigned int draw_in;
	unsigned int total_pixel = TOTAL_PIXEL;
	unsigned int r, g, b;
	
	for ( int i = 0; i < total_pixel/2; i ++ ){			
		temp = REG32(addr + i*4);
		temp1 = temp & 0x0000FFFF;
		temp2 = (temp & 0xFFFF0000) >> 16;
		
		r = (unsigned int)(((temp1 & 0x0000F800) >> 11) * 2);
		g = (unsigned int)((temp1 & 0x000007E0) >> 5);
		b = (unsigned int)(temp1 & 0x0000001F) * 2;
		avg = (unsigned int)((r + g + b) / 3);
		avg_5bit = (unsigned int)(avg >> 1);
		draw_in = (avg_5bit) | (avg << 5) | (avg_5bit << 11);
		
		r = (unsigned int)(((temp2 & 0x0000F800) >> 11) * 2);
		g = (unsigned int)((temp2 & 0x000007E0) >> 5);
		b = (unsigned int)(temp2 & 0x0000001F) * 2;
		avg = (unsigned int)((r + g + b) / 3);
		avg_5bit = (unsigned int)(avg >> 1);
		temp = (avg_5bit) | (avg << 5) | (avg_5bit << 11);
		draw_in = draw_in | (temp << 16);
		
		REG32(addr + i*4) = draw_in;
	}
}

void Array2RvxImage(unsigned char* image_a_rgb888, unsigned int addr){

	unsigned int temp, temp1, temp2;
	unsigned int total_pixel = TOTAL_PIXEL;
	unsigned int draw = 0;
	
	for ( int i = 0; i < total_pixel/2; i ++ ){
		draw = ((image_a_rgb888[i*6+2] << 8 ) & 0xF800) | ((image_a_rgb888[i*6+1] << 3 ) & 0x07E0) | (image_a_rgb888[i*6+0] >> 3 );
		temp = ((image_a_rgb888[i*6+5] << 8 ) & 0xF800) | ((image_a_rgb888[i*6+4] << 3 ) & 0x07E0) | (image_a_rgb888[i*6+3] >> 3 );
		draw = (temp << 16) | draw;
		REG32(addr + i*4) = draw;
	}
}

float calculate_psnr(char* image_a_rgb888, char* image_b_rgb888, int addr, int total_pixel, int tick, int first_pic){


	int sum = 0, sum_r = 0, sum_g = 0, sum_b = 0;
	int mse  = 0; 
	float psnr = 0;
	
	int temp, temp1, temp2, sub;	
	
	if ( tick == 0 ) 
		RvxImage2Array(addr, image_a_rgb888);
	else if ( tick == 1 ) 
		RvxImage2Array(addr, image_b_rgb888);
	
	if( first_pic == 0 ) {
		for ( int i = 0; i < total_pixel; i ++ ){
			sub = (signed int)(image_a_rgb888[3*i+0])-(signed int)(image_b_rgb888[3*i+0]);
			sum_b += sub*sub;
			sub = (signed int)(image_a_rgb888[3*i+1])-(signed int)(image_b_rgb888[3*i+1]);
			sum_g += sub*sub;
			sub = (signed int)(image_a_rgb888[3*i+2])-(signed int)(image_b_rgb888[3*i+2]);
			sum_r += sub*sub;	
		}
		sum = sum_r + sum_g + sum_b;
		mse = sum / (total_pixel * 3);
		
		if ( sum <= 1e-10 )
			psnr = 0;
		else {
			psnr = 10*log10((256*256)/mse);
		}
	}
	else if( first_pic == 1) {
		psnr = 0;
	}

	return psnr;
}
