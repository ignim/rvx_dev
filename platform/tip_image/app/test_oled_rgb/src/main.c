#include "oled_rgb.h"
#include "snake.h"

#include "ervp_delay.h"
#include "ervp_core_id.h"
#include "ervp_printf.h"

#define RECURSION 1

int main()
	{
	int i;
	if(EXCLUSIVE_ID==0)
	{
		oled_rgb_start();

		do
		{
			oled_rgb_clear();

			printf("Draw rectangle\n");
			oled_rgb_draw_rectangle(0, 0, 40, 40, 0xFFFF, 1, RGB(0xFF,0,0));
			delay_ms(1000);

			printf("Copy\n");
			oled_rgb_copy(0, 0, 40, 40, 20, 20);
			delay_ms(1000);

			printf("Dim window\n");
			oled_rgb_dim_window(20, 20, 60, 60);
			delay_ms(1000);

			printf("Draw line\n");
			oled_rgb_draw_line(50, 50, 95, 0, RGB(0,0xFF,0));
			delay_ms(1000);

			printf("Draw pixel\n");
			for(i=0; i<OLEDRGB_WIDTH; i++)
				oled_rgb_draw_pixel(i, OLEDRGB_HEIGHT-1, RGB(0,0,0xFF));
			for(i=0; i<OLEDRGB_HEIGHT; i++)
				oled_rgb_draw_pixel(OLEDRGB_WIDTH-1, i, RGB(0,0,0xFF));
			delay_ms(1000);

			printf("Draw bitmap\n");
			oled_rgb_draw_bitmap(0, 0, OLEDRGB_WIDTH-1, OLEDRGB_HEIGHT-1, snake3);
			delay_ms(1000);
			oled_rgb_draw_bitmap(0, 0, OLEDRGB_WIDTH-1, OLEDRGB_HEIGHT-1, snake4);
			delay_ms(1000);
			oled_rgb_draw_bitmap(0, 0, OLEDRGB_WIDTH-1, OLEDRGB_HEIGHT-1, plugin);
			delay_ms(1000);

			oled_rgb_start_scrolling(OLEDRGB_WIDTH-1, 0, OLEDRGB_HEIGHT, 0, 0);
			delay_ms(1000);

			oled_rgb_stop_scrolling();
			delay_ms(1000);
		} while(RECURSION);
		oled_rgb_end();
	}
	return 0;

}


/* ------------------------------------------------------------ */
/***	ProcName
**
**	Parameters:
**
**	Return Value:
**
**	Errors:
**
**	Description:
**
*/

/* ------------------------------------------------------------ */

/************************************************************************/

