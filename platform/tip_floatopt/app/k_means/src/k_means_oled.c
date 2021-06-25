
/* K-means Algorithm, kjbyun, 2020.08.07 */ 

#include "platform_info.h"
#include "ervp_printf.h"
#include "ervp_core_id.h"
#include "ervp_delay.h"
#include "ervp_profiling.h"
#include "oled_rgb.h"

#define OLED_W 96
#define OLED_H 64

#define k 3				// # of cluster
//#define num_data 20		// # of input data
#define num_data 130		// # of input data
#define sqr(x) 	((x)*(x))
#define ABS(x)  (((x) < 0) ? -(x) : (x))

//#include "data_20.h"	// 2 dimension input data : data[num_data][2]
#include "data_150.h"	// 2 dimension input data : data[num_data][2]


int main() 
{
	if(EXCLUSIVE_ID==0)
	{
		float means[k][2];
		int group[num_data];
		int iteration = 0;
		int clust_data[num_data][2];
		int ii = 0, g[k];

		///  set initial means  ///
		for(int i = 0; i < k; i++) 
			for(int j = 0; j < 2; j++)
				means[i][j] = (float)data[i+4][j]; 

		printf("Start computing K-means algorithm : initial means\n");

		for (int i = 0; i < k; i++)
			printf("means[%d] = (%.2f, %.2f)\n", i, means[i][0], means[i][1]);

		/// display input data and initial means  ///
		// oled_display_init_mean(data, means);

		printf("Draw the input data and initial means for K-means clustering!\n");

		oled_rgb_start();

		oled_rgb_clear();

		// Draw axis
		for(int i = 0; i < OLEDRGB_HEIGHT; i++)
			oled_rgb_draw_pixel(OLEDRGB_WIDTH+1, i, RGB(0xFF,0xFF,0xFF));

		for(int i = 1; i < OLEDRGB_WIDTH; i++)
			oled_rgb_draw_pixel(i, OLEDRGB_HEIGHT-1, RGB(0xFF,0xFF,0xFF));

		delay_ms(1000);

		// Draw input data : gray color
		for(int i = 0; i < num_data; i++)
			oled_rgb_draw_pixel(data[i][0], OLEDRGB_HEIGHT-data[i][1], RGB(0x60, 0x60, 0x60));

		delay_ms(1000);

		// Draw means initial means
		for(int i = 0; i < 3; i++)
		{
			oled_rgb_draw_pixel((int)means[i][0], OLEDRGB_HEIGHT-(int)means[i][1], RGB(0xFF,0xFF,0xFF));
			oled_rgb_draw_pixel((int)means[i][0]+1, OLEDRGB_HEIGHT-(int)means[i][1], RGB(0xFF,0xFF,0xFF));
			oled_rgb_draw_pixel((int)means[i][0], OLEDRGB_HEIGHT-(int)means[i][1]+1, RGB(0xFF,0xFF,0xFF));
			oled_rgb_draw_pixel((int)means[i][0]+1, OLEDRGB_HEIGHT-(int)means[i][1]+1, RGB(0xFF,0xFF,0xFF));
		}

		delay_ms(1000);

		///  k-means clustering  ///
		for(;;)
		{
			int flag = 0;

			for(int i = 0; i < num_data; i++)
			{
				float min_dis = 9999;
				int min = -1;

				// calculating distances //
				for(int j = 0; j < k; j++)
				{
					float dis = 0;

					for(int l = 0; l < 2; l++)
						dis += sqr((float)data[i][l] - means[j][l]);

					if(dis < min_dis) {
						min_dis = dis;
						min = j;
					}
				}

				// set groups //
				group[i] = min;
			}

			// calculating new means for each cluster //
			float temp[k][2];
			int	count[k];

			for(int i = 0; i < k; i++)
			{
				count[i] = 0;
				for(int j = 0; j < 2; j++)
					temp[i][j] = 0.f;
			}

			// calculating new means //
			for(int i = 0; i < num_data; i++)
			{
				count[group[i]]++;
				for(int j = 0; j < 2; j++)
					temp[group[i]][j] += (float)data[i][j];
			}

			for(int i = 0; i < k; i++)
			{
				for(int j = 0; j < 2; j++)
				{
					temp[i][j] /= count[i];

					if(ABS(temp[i][j] - means[i][j]) > 0.0001)
					{
						flag++;
						means[i][j] = temp[i][j];
					}
				}
			}
			iteration++;
			printf("\niteration = %d\n", iteration);

			// print the result of clustering : clustering point of view

			ii = 0;
			for(int i = 0; i < k; i++)
			{
				g[i] = 0;
				for(int j = 0; j < num_data; j++)
				{
					if (group[j] == i)
					{
						clust_data[ii][0] = data[j][0]; 
						clust_data[ii][1] = data[j][1]; 
						g[i] += 1;
						ii++;
					}
				}
			}

			ii = 0; 
			for(int i = 0; i < k; i++)
			{
				printf("# of group %d data : %d\n", i, g[i]);
				for(int j = 0; j < g[i]; j++)
				{
					//				printf("%2d %2d\n",clust_data[ii][0], clust_data[ii][1]);
					ii++;
				}
			}

			for(int i = 0; i < k; i++)
				printf("means[%d] = (%.2f, %.2f)\n", i, means[i][0], means[i][1]);

			// display result of clustering for each iteration //
			//	oled_display(clust_data, means, g);
			if (iteration % 2 == 0) {

				oled_rgb_clear();

				printf("Draw the result of clustering for iteration %d!\n", iteration);

				// Draw axis
				for(int i = 0; i < OLEDRGB_HEIGHT; i++)
					oled_rgb_draw_pixel(OLEDRGB_WIDTH+1, i, RGB(0xFF,0xFF,0xFF));

				for(int i = 1; i < OLEDRGB_WIDTH; i++)
					oled_rgb_draw_pixel(i, OLEDRGB_HEIGHT-1, RGB(0xFF,0xFF,0xFF));

				delay_ms(1000);

				// Draw clusted data for each iteration
				int i, j = 0;

				for(i =0; i < g[0]; i++)
					oled_rgb_draw_pixel(clust_data[i][0], OLEDRGB_HEIGHT-clust_data[i][1], RGB(0xFF, 0, 0));

				for(j =i; j < g[0]+g[1]; j++)
					oled_rgb_draw_pixel(clust_data[j][0], OLEDRGB_HEIGHT-clust_data[j][1], RGB(0, 0xd2, 0));

				for(i =j; i < g[0]+g[1]+g[2]; i++)
					oled_rgb_draw_pixel(clust_data[i][0], OLEDRGB_HEIGHT-clust_data[i][1], RGB(0, 0, 0xFF));

				delay_ms(1000);

				// Draw means of each clusters
				for(i = 0; i < 3; i++)
				{
					oled_rgb_draw_pixel((int)means[i][0], OLEDRGB_HEIGHT-(int)means[i][1], RGB(0xFF,0xFF,0xFF));
					oled_rgb_draw_pixel((int)means[i][0]+1, OLEDRGB_HEIGHT-(int)means[i][1], RGB(0xFF,0xFF,0xFF));
					oled_rgb_draw_pixel((int)means[i][0], OLEDRGB_HEIGHT-(int)means[i][1]+1, RGB(0xFF,0xFF,0xFF));
					oled_rgb_draw_pixel((int)means[i][0]+1, OLEDRGB_HEIGHT-(int)means[i][1]+1, RGB(0xFF,0xFF,0xFF));
				}

				delay_ms(1000);
			}

			// Termination //
			if(flag == 0)
				break;
		}

		printf("\nEnd of K=means clustering! iteration : %d\n", iteration);
	}
	return 0;
}
