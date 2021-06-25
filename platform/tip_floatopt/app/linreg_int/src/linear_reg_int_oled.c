#include "platform_info.h"
#include "ervp_printf.h"
#include "ervp_core_id.h"
#include "ervp_delay.h"
#include "ervp_profiling.h"
#include "oled_rgb.h"

#include "input_data.h"

#define	INT_MAX	2147483647
#define OLED_W 96
#define OLED_H 64

int	theta_0, theta_1;
int	hypo_size[NUM_DATA+40], hypo_price[NUM_DATA+40];

int getLinearHypothesis(const int x)
{
	return theta_0 + theta_1 * x;
}

int getMeanSquareError()
{
	profiling_start("mean_square");
	int error_sum = 0;
	int error_average;
	for (int e = 0; e < NUM_DATA; e++)
	{   
		const int error = price[e] - getLinearHypothesis(size[e]);
		error_sum += error*error;
	}   
	if (error_sum > INT_MAX)    printf("Overflow!! err_sum = %d\n", error_sum);
	error_average = error_sum / (NUM_DATA*2);
	profiling_end("mean_square");
	return error_average;
}

int main() {
	if(EXCLUSIVE_ID==0)
	{
		printf("Start computing Linear Regression!: Integer full search\n");

		theta_0 = 0;
		theta_1 = 0;

		const int num_theta0_samples = 250;
		const int num_theta1_samples = 30;

		const int d_theta_0 = 500 / num_theta0_samples;
		const int d_theta_1 = 10 / num_theta1_samples;

		int theta_0_min = 0, theta_1_min = 0;
		int theta_0_max = 0, theta_1_max = 0;
		int min_error = INT_MAX - 1;
		int max_error = 0;

		int	 t0, t1;
		for (t1 = 0; t1 < num_theta1_samples; t1++)
		{
			theta_1 = d_theta_1 * t1;

			for (t0 = 0; t0 < num_theta0_samples; t0++)
			{
				theta_0 = d_theta_0 * t0;

				int error =  getMeanSquareError();

				if (error < min_error)
				{
					min_error = error;
					theta_0_min = theta_0;
					theta_1_min = theta_1;

					printf("Iteration = %d\n", (t1*num_theta0_samples+t0+1));
					printf("Min_Err(%d, %d) = %d\n", theta_0_min, theta_1_min, min_error);
				}
				if (error > max_error)
				{
					max_error = error;
					theta_0_max = theta_0;
					theta_1_max = theta_1;
				}
			}
		}

		printf("\nTotal iteration = %d\n", (t1*num_theta0_samples));
		printf("Min_Err(%d, %d) = %d\n", theta_0_min, theta_1_min, min_error);
		printf("Max_Err(%d, %d) = %d\n\n", theta_0_max, theta_1_max, max_error);

		theta_0 = theta_0_min;
		theta_1 = theta_1_min;
		// Store Linear Hypothesis

		int i;

		for(i = 0; i < 140; i++)
		{
			hypo_size[i] = (float)i;
			hypo_price[i] = getLinearHypothesis((float)i);
			//			printf("%d %d\n", size, hypo[size]);
		}
		printf("End of Linear Hypothesis: Integer Version!\n");

		// Sclaing Input data for OLED display
		for (i = 0; i < NUM_DATA; i++)
		{
			float size_tmp = (float)size[i]*OLED_W/140 + 0.5f;
			size[i] = (int)size_tmp;
			float price_tmp = ((float)price[i]-100.0f)*OLED_H/350 + 0.5f;
			price[i] = (int)price_tmp;
			//          printf("%d %d\n", (int)size[i], (int)price[i]);
		}

		// Sclaing Hypothesis data for OLED display
		for (i = 0; i < NUM_DATA+40; i++)
		{
			hypo_size[i] = (hypo_size[i]*OLED_W/140 + 0.5f);
			hypo_price[i] = ((hypo_price[i]-100.0f)*OLED_H/350 + 0.5f);
			//          printf("%d %d\n", (int)hypo_size[i], (int)hypo_price[i]);
		}

		printf("Draw Result of Hypothesis!\n");

		// OLED Display

		oled_rgb_start();

		oled_rgb_clear();

		// Draw axis
		for(i = 0; i < OLEDRGB_HEIGHT; i++)
			oled_rgb_draw_pixel(OLEDRGB_WIDTH+1, i, RGB(0xFF,0xFF,0xFF));

		for(i = 1; i < OLEDRGB_WIDTH; i++)
			oled_rgb_draw_pixel(i, OLEDRGB_HEIGHT-1, RGB(0xFF,0xFF,0xFF));

		delay_ms(1000);

		// Draw Input data
		for(i =2; i < 100; i++)
			oled_rgb_draw_pixel(size[i], (OLEDRGB_HEIGHT-price[i]), RGB(0,0xFF,0));

		delay_ms(1000);

		// Draw Result of Hypothesis
		for(i =5; i < 140; i++)
			oled_rgb_draw_pixel((int)hypo_size[i], (OLEDRGB_HEIGHT-(int)hypo_price[i]), RGB(0xFF,0x99,0));
	}
	return 0;
}



