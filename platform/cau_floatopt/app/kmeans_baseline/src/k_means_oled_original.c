/* K-means Algorithm, kjbyun, 2020.08.07 */

#include "platform_info.h"
#include "ervp_printf.h"
#include "ervp_core_id.h"
#include "ervp_delay.h"
#include "ervp_profiling.h"
#include "oled_rgb.h"

#define OLED_W 96
#define OLED_H 64

#define k 3           
#define num_data 120   // has to be multiple of 4!!!!!!!!!!!

//#include "data_20.h"   // 2 dimension input data : data[num_data][2]
#include "data_150.h"   // 2 dimension input data : data[num_data][2]

#include "data_500_lcd_small.h"
#include "data_500_lcd_small_float.h"

#define data data_150

#define sqr(x) 	((x)*(x))
#define ABS(x)  (((x) < 0) ? -(x) : (x))

#include "platform_info.h"
#include "ervp_printf.h"
#include "ervp_reg_util.h"

#define OFFSET_MEAN_0X 0x0
#define OFFSET_MEAN_0Y 0x4
#define OFFSET_MEAN_1X 0x8
#define OFFSET_MEAN_1Y 0xC
#define OFFSET_MEAN_2X 0x10
#define OFFSET_MEAN_2Y 0x14
#define OFFSET_OUTSTART 0x18

#define OFFSET_START_SIGNAL_PRE 0x1C
#define OFFSET_START_SIGNAL 0x20
#define OFFSET_DATA_0X 0x24
#define OFFSET_DATA_0Y 0x28
#define OFFSET_DATA_1X 0x2C
#define OFFSET_DATA_1Y 0x30
#define OFFSET_DATA_2X 0x34
#define OFFSET_DATA_2Y 0x38
#define OFFSET_DATA_3X 0x3C
#define OFFSET_DATA_3Y 0x40
#define OFFSET_K0 0x44
#define OFFSET_K1 0x48
#define OFFSET_K2 0x4C
#define OFFSET_K3 0x50
#define OFFSET_K0_count 0x54
#define OFFSET_K1_count 0x58
#define OFFSET_K2_count 0x5C
#define OFFSET_K0_SUM_X 0x60
#define OFFSET_K0_SUM_Y 0x64
#define OFFSET_K1_SUM_X 0x68
#define OFFSET_K1_SUM_Y 0x6C
#define OFFSET_K2_SUM_X 0x70
#define OFFSET_K2_SUM_Y 0x74

#define OFFSET_diff00 0x78
#define OFFSET_diff01 0x7C
#define OFFSET_diff10 0x80
#define OFFSET_diff11 0x84
#define OFFSET_diff20 0x88
#define OFFSET_diff21 0x8C

#define OFFSET_flag 0x90


#define OFFSET_k0_count_float 0x94
#define OFFSET_k1_count_float 0x98
#define OFFSET_k2_count_float 0x9C

#define OFFSET_START_SIGNAL_CHECK 0xA0

#define REG32_fl(add) *((volatile float *)(add))
#define one_time_num 4





static inline unsigned int get_test1_addr(unsigned int offset)
{
	return (I_TEST1_SLAVE_BASEADDR + offset);
}


//set addr
void set_mean_0x(float value)
{
	REG32_fl(get_test1_addr(OFFSET_MEAN_0X)) = value;
}
void set_mean_0y(float value)
{
	REG32_fl(get_test1_addr(OFFSET_MEAN_0Y)) = value;
}
void set_mean_1x(float value)
{
	REG32_fl(get_test1_addr(OFFSET_MEAN_1X)) = value;
}
void set_mean_1y(float value)
{
	REG32_fl(get_test1_addr(OFFSET_MEAN_1Y)) = value;
}
void set_mean_2x(float value)
{
	REG32_fl(get_test1_addr(OFFSET_MEAN_2X)) = value;
}
void set_mean_2y(float value)
{
	REG32_fl(get_test1_addr(OFFSET_MEAN_2Y)) = value;
}

//get addr
float get_mean_0x()
{
	return REG32_fl(get_test1_addr(OFFSET_MEAN_0X));
}
float get_mean_0y()
{
	return REG32_fl(get_test1_addr(OFFSET_MEAN_0Y));
}
float get_mean_1x()
{
	return REG32_fl(get_test1_addr(OFFSET_MEAN_1X));
}
float get_mean_1y()
{
	return REG32_fl(get_test1_addr(OFFSET_MEAN_1Y));
}
float get_mean_2x()
{
	return REG32_fl(get_test1_addr(OFFSET_MEAN_2X));
}
float get_mean_2y()
{
	return REG32_fl(get_test1_addr(OFFSET_MEAN_2Y));
}

//flag
int get_outstart()
{
	return REG32(get_test1_addr(OFFSET_OUTSTART));
}



//start_signal

void set_start_signal_pre(int value)
{
	REG32(get_test1_addr(OFFSET_START_SIGNAL_PRE)) = value;
}

void set_start_signal(int value)
{
	REG32(get_test1_addr(OFFSET_START_SIGNAL)) = value;
}

int get_start_signal_pre()
{
	return REG32(get_test1_addr(OFFSET_START_SIGNAL_PRE));
}


//set data
void set_DATA_0X(float value)
{
	REG32_fl(get_test1_addr(OFFSET_DATA_0X)) = value;
}
void set_DATA_0Y(float value)
{
	REG32_fl(get_test1_addr(OFFSET_DATA_0Y)) = value;
}
void set_DATA_1X(float value)
{
	REG32_fl(get_test1_addr(OFFSET_DATA_1X)) = value;
}
void set_DATA_1Y(float value)
{
	REG32_fl(get_test1_addr(OFFSET_DATA_1Y)) = value;
}
void set_DATA_2X(float value)
{
	REG32_fl(get_test1_addr(OFFSET_DATA_2X)) = value;
}
void set_DATA_2Y(float value)
{
	REG32_fl(get_test1_addr(OFFSET_DATA_2Y)) = value;
}
void set_DATA_3X(float value)
{
	REG32_fl(get_test1_addr(OFFSET_DATA_3X)) = value;
}
void set_DATA_3Y(float value)
{
	REG32_fl(get_test1_addr(OFFSET_DATA_3Y)) = value;
}

float get_DATA_0X()
{
	return REG32_fl(get_test1_addr(OFFSET_DATA_0X));
}
float get_DATA_1X()
{
	return REG32_fl(get_test1_addr(OFFSET_DATA_1X));
}
float get_DATA_2X()
{
	return REG32_fl(get_test1_addr(OFFSET_DATA_2X));
}
float get_DATA_0Y()
{
	return REG32_fl(get_test1_addr(OFFSET_DATA_0Y));
}
float get_DATA_1Y()
{
	return REG32_fl(get_test1_addr(OFFSET_DATA_1Y));
}
float get_DATA_2Y()
{
	return REG32_fl(get_test1_addr(OFFSET_DATA_2Y));
}


// set k data ( only for test )
void set_k0(int value)
{
	REG32(get_test1_addr(OFFSET_K0)) = value;
}
void set_k1(int value)
{
	REG32(get_test1_addr(OFFSET_K1)) = value;
}
void set_k2(int value)
{
	REG32(get_test1_addr(OFFSET_K2)) = value;
}
void set_k3(int value)
{
	REG32(get_test1_addr(OFFSET_K3)) = value;
}


//get data

unsigned int get_k0()
{
	return REG32(get_test1_addr(OFFSET_K0));
}
unsigned int get_k1()
{
	return REG32(get_test1_addr(OFFSET_K1));
}
unsigned int get_k2()
{
	return REG32(get_test1_addr(OFFSET_K2));
}
unsigned int get_k3()
{
	return REG32(get_test1_addr(OFFSET_K3));
}

// set k count

void set_k0_count(int value)
{
	REG32(get_test1_addr(OFFSET_K0_count)) = value;
}
void set_k1_count(int value)
{
	REG32(get_test1_addr(OFFSET_K1_count)) = value;
}
void set_k2_count(int value)
{
	REG32(get_test1_addr(OFFSET_K2_count)) = value;
}




// get k count

unsigned int get_k0_count()
{
	return REG32(get_test1_addr(OFFSET_K0_count));
}
unsigned int get_k1_count()
{
	return REG32(get_test1_addr(OFFSET_K1_count));
}
unsigned int get_k2_count()
{
	return REG32(get_test1_addr(OFFSET_K2_count));
}


// set sum(float)

void set_k0_sum_x(float value)
{
	REG32_fl(get_test1_addr(OFFSET_K0_SUM_X)) = value;
}
void set_k1_sum_x(float value)
{
	REG32_fl(get_test1_addr(OFFSET_K1_SUM_X)) = value;
}
void set_k2_sum_x(float value)
{
	REG32_fl(get_test1_addr(OFFSET_K2_SUM_X)) = value;
}
void set_k0_sum_y(float value)
{
	REG32_fl(get_test1_addr(OFFSET_K0_SUM_Y)) = value;
}
void set_k1_sum_y(float value)
{
	REG32_fl(get_test1_addr(OFFSET_K1_SUM_Y)) = value;
}
void set_k2_sum_y(float value)
{
	REG32_fl(get_test1_addr(OFFSET_K2_SUM_Y)) = value;
}

// get sum (float)

float get_k0_sum_x()
{
	return REG32_fl(get_test1_addr(OFFSET_K0_SUM_X));
}
float get_k1_sum_x()
{
	return REG32_fl(get_test1_addr(OFFSET_K1_SUM_X));
}
float get_k2_sum_x()
{
	return REG32_fl(get_test1_addr(OFFSET_K2_SUM_X));
}
float get_k0_sum_y()
{
	return REG32_fl(get_test1_addr(OFFSET_K0_SUM_Y));
}
float get_k1_sum_y()
{
	return REG32_fl(get_test1_addr(OFFSET_K1_SUM_Y));
}
float get_k2_sum_y()
{
	return REG32_fl(get_test1_addr(OFFSET_K2_SUM_Y));
}


// get diff
float get_diff00()
{
	return REG32_fl(get_test1_addr(OFFSET_diff00));
}
float get_diff01()
{
	return REG32_fl(get_test1_addr(OFFSET_diff01));
}
float get_diff10()
{
	return REG32_fl(get_test1_addr(OFFSET_diff10));
}
float get_diff11()
{
	return REG32_fl(get_test1_addr(OFFSET_diff11));
}
float get_diff20()
{
	return REG32_fl(get_test1_addr(OFFSET_diff20));
}
float get_diff21()
{
	return REG32_fl(get_test1_addr(OFFSET_diff21));
}


// set k count float

void set_k0_count_float(float value)
{
	REG32_fl(get_test1_addr(OFFSET_K0_count)) = value;
}
void set_k1_count_float(float value)
{
	REG32_fl(get_test1_addr(OFFSET_K1_count)) = value;
}
void set_k2_count_float(float value)
{
	REG32_fl(get_test1_addr(OFFSET_K2_count)) = value;
}

float get_k0_count_float()
{
	return REG32_fl(get_test1_addr(OFFSET_k0_count_float));
}
float get_k1_count_float()
{
	return REG32_fl(get_test1_addr(OFFSET_k1_count_float));
}
float get_k2_count_float()
{
	return REG32_fl(get_test1_addr(OFFSET_k2_count_float));
}

void set_start_signal_check(unsigned int value)
{
	REG32(get_test1_addr(OFFSET_START_SIGNAL_CHECK)) = value;
}

unsigned int get_start_signal_check()
{
	return REG32(get_test1_addr(OFFSET_START_SIGNAL_CHECK));
}


volatile int real_clock_start;
volatile int real_clock_end;
volatile int real_clock_timer;


void k_means_verilog(int num0, int num1, int num2, float threshold)
{
	printf("total_data_num : %d\n\n", num_data);
	
	real_clock_start = get_real_clock_tick();

	volatile int group_num = num_data / one_time_num;
	volatile int put_num = 0;
	volatile int out_start_check = 0;
	volatile int iteration = 0;
	volatile float means[k][2];
	volatile float temp[k][2];

	volatile int last_data_num = num_data % one_time_num;
	volatile int flag = 0;

	volatile int count[k];
	volatile int group[num_data];
	
	
	///  set initial means  ///
	means[0][0] = (float)data[num0][0];
	means[0][1] = (float)data[num0][1];
	means[1][0] = (float)data[num1][0];
	means[1][1] = (float)data[num1][1];
	means[2][0] = (float)data[num2][0];
	means[2][1] = (float)data[num2][1];
		

	/*
		//draw
		printf("Draw the input data and initial means for K-means clustering!\n");

		oled_rgb_start();

		oled_rgb_clear();

		// Draw axis
		for (int i = 0; i < OLEDRGB_HEIGHT; i++)
			oled_rgb_draw_pixel(OLEDRGB_WIDTH + 1, i, RGB(0xFF, 0xFF, 0xFF));

		for (int i = 1; i < OLEDRGB_WIDTH; i++)
			oled_rgb_draw_pixel(i, OLEDRGB_HEIGHT - 1, RGB(0xFF, 0xFF, 0xFF));

		delay_ms(1000);

		// Draw input data : gray color
		for (int i = 0; i < num_data; i++)
			oled_rgb_draw_pixel(data[i][0], OLEDRGB_HEIGHT - data[i][1], RGB(0x60, 0x60, 0x60));

		delay_ms(1000);

		// Draw means initial means
		for (int i = 0; i < 3; i++)
		{
			oled_rgb_draw_pixel((int)means[i][0], OLEDRGB_HEIGHT - (int)means[i][1], RGB(0xFF, 0xFF, 0xFF));
			oled_rgb_draw_pixel((int)means[i][0] + 1, OLEDRGB_HEIGHT - (int)means[i][1], RGB(0xFF, 0xFF, 0xFF));
			oled_rgb_draw_pixel((int)means[i][0], OLEDRGB_HEIGHT - (int)means[i][1] + 1, RGB(0xFF, 0xFF, 0xFF));
			oled_rgb_draw_pixel((int)means[i][0] + 1, OLEDRGB_HEIGHT - (int)means[i][1] + 1, RGB(0xFF, 0xFF, 0xFF));
		}

		delay_ms(1000);*/
		//

	while (out_start_check == 0)
	{

		if (put_num < group_num)
		{

			for (volatile int i = 0; i < 4; i++)
			{
				volatile float min_dis = 99999999;
				volatile int min = -1;

				// calculating distances //
				for (volatile int j = 0; j < k; j++)
				{
					volatile float dis = 0;

					for (volatile int l = 0; l < 2; l++)
						dis += sqr((float)data[put_num * one_time_num + i][l] - means[j][l]);

					if (dis < min_dis) {
						min_dis = dis;
						min = j;
					}
				}

				// set groups //
				group[put_num * one_time_num + i] = min;
			}
			put_num += 1;
		}


		else if (put_num == group_num)
			{
				if (last_data_num == 1)
				{	
					for (volatile int i = 0; i < 1; i++)
					{
						volatile float min_dis = 99999999;
						volatile int min = -1;

						// calculating distances //
						for (volatile int j = 0; j < k; j++)
						{
							volatile float dis = 0;

							for (volatile int l = 0; l < 2; l++)
								dis += sqr((float)data[put_num * one_time_num + i][l] - means[j][l]);

							if (dis < min_dis) {
								min_dis = dis;
								min = j;
							}
						}

						// set groups //
						group[put_num * one_time_num + i] = min;
					}
					put_num += 1;
				}
				
				else if (last_data_num == 2)
				{	
					for (volatile int i = 0; i < 2; i++)
					{
						volatile float min_dis = 99999999;
						volatile int min = -1;

						// calculating distances //
						for (volatile int j = 0; j < k; j++)
						{
							volatile float dis = 0;

							for (volatile int l = 0; l < 2; l++)
								dis += sqr((float)data[put_num * one_time_num + i][l] - means[j][l]);

							if (dis < min_dis) {
								min_dis = dis;
								min = j;
							}
						}

						// set groups //
						group[put_num * one_time_num + i] = min;
					}
					put_num += 1;
				}
				else if (last_data_num == 3)
				{	
					for (volatile int i = 0; i < 3; i++)
					{
						volatile float min_dis = 99999999;
						volatile int min = -1;

						// calculating distances //
						for (volatile int j = 0; j < k; j++)
						{
							volatile float dis = 0;

							for (volatile int l = 0; l < 2; l++)
								dis += sqr((float)data[put_num * one_time_num + i][l] - means[j][l]);

							if (dis < min_dis) {
								min_dis = dis;
								min = j;
							}
						}

						// set groups //
						group[put_num * one_time_num + i] = min;
					}
					put_num += 1;
				}
				
				else put_num += 1;
			}

		else if (put_num > group_num)
		{

			for (volatile int i = 0; i < k; i++)
			{
				count[i] = 0;
				for (int j = 0; j < 2; j++)
					temp[i][j] = 0.f;
			}

			// calculating new means //
			for (volatile int i = 0; i < num_data; i++)
			{
				count[group[i]]++;
				for (volatile int j = 0; j < 2; j++)
					temp[group[i]][j] += (float)data[i][j];
			}
			flag = 0;
			for (volatile int i = 0; i < k; i++)
			{
				for (volatile int j = 0; j < 2; j++)
				{
					temp[i][j] = temp[i][j] / count[i];
					if (ABS(temp[i][j] - means[i][j]) > threshold)
					{
						flag++;
					}
					means[i][j] = temp[i][j];
				}
			}

			iteration += 1;
			if (flag == 0) out_start_check = 1;


			if (out_start_check == 1)
			{
				//printf("**********break***********\n\n");
				break;
			}
			else if (out_start_check == 0)
			{

				//printf("\t\t **********loooppp**********\t\t\n\n");


				/*
				printf("iteration number = %d \n", iteration);
				printf("(C) \nnew means 0x : %f \n", means[0][0]);
				printf("new means 0y : %f \n", means[0][1]);
				printf("new means 1x : %f \n", means[1][0]);
				printf("new means 1y : %f \n", means[1][1]);
				printf("new means 2x : %f \n", means[2][0]);
				printf("new means 2y : %f \n", means[2][1]);   


				printf("\t\t **********loooppp**********\t\t\n\n");*/


				put_num = 0;
			}
		}
	}

	real_clock_end = get_real_clock_tick();
	real_clock_timer = real_clock_end - real_clock_start;


	printf("clock time = %d\n\n", real_clock_timer);

	//printf("iteration number = %d \n", iteration);


	///  get final means  ///
	printf("final 1st mean = (%.2f, %.2f) \n", means[0][0], means[0][1]);
	printf("final 2nd mean = (%.2f, %.2f) \n", means[1][0], means[1][1]);
	printf("final 3rd mean = (%.2f, %.2f) \n", means[2][0], means[2][1]);


	/* draw

		int clust_data[num_data][2];
		int ii = 0, g[k];

		for (int i = 0; i < k; i++)
		{
			g[i] = 0;
			for (int j = 0; j < num_data; j++)
			{
				if (k_number[j] == i)
				{
					clust_data[ii][0] = data[j][0];
					clust_data[ii][1] = data[j][1];
					g[i] += 1;
					ii++;
				}
			}
		}


			oled_rgb_clear();

			printf("Draw the result of clustering for iteration %d!\n", iteration);

			// Draw axis
			for (int i = 0; i < OLEDRGB_HEIGHT; i++)
				oled_rgb_draw_pixel(OLEDRGB_WIDTH + 1, i, RGB(0xFF, 0xFF, 0xFF));

			for (int i = 1; i < OLEDRGB_WIDTH; i++)
				oled_rgb_draw_pixel(i, OLEDRGB_HEIGHT - 1, RGB(0xFF, 0xFF, 0xFF));

			delay_ms(1000);

			// Draw clusted data for each iteration
			int i, j = 0;

			for (i = 0; i < g[0]; i++)
				oled_rgb_draw_pixel(clust_data[i][0], OLEDRGB_HEIGHT - clust_data[i][1], RGB(0xFF, 0, 0));

			for (j = i; j < g[0] + g[1]; j++)
				oled_rgb_draw_pixel(clust_data[j][0], OLEDRGB_HEIGHT - clust_data[j][1], RGB(0, 0xd2, 0));

			for (i = j; i < g[0] + g[1] + g[2]; i++)
				oled_rgb_draw_pixel(clust_data[i][0], OLEDRGB_HEIGHT - clust_data[i][1], RGB(0, 0, 0xFF));

			delay_ms(1000);

			// Draw means of each clusters
			for (i = 0; i < 3; i++)
			{
				oled_rgb_draw_pixel((int)means[i][0], OLEDRGB_HEIGHT - (int)means[i][1], RGB(0xFF, 0xFF, 0xFF));
				oled_rgb_draw_pixel((int)means[i][0] + 1, OLEDRGB_HEIGHT - (int)means[i][1], RGB(0xFF, 0xFF, 0xFF));
				oled_rgb_draw_pixel((int)means[i][0], OLEDRGB_HEIGHT - (int)means[i][1] + 1, RGB(0xFF, 0xFF, 0xFF));
				oled_rgb_draw_pixel((int)means[i][0] + 1, OLEDRGB_HEIGHT - (int)means[i][1] + 1, RGB(0xFF, 0xFF, 0xFF));
			}

			delay_ms(1000);*/

	printf("\nEnd of K-means clustering! iteration : %d\n", iteration);
}


int main()
{

	k_means_verilog(4, 5, 6, 0.0001);

}


