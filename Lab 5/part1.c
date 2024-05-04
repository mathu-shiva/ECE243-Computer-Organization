	/* This files provides address values that exist in the system */

#define SDRAM_BASE            0xC0000000
#define FPGA_ONCHIP_BASE      0xC8000000
#define FPGA_CHAR_BASE        0xC9000000

/* Cyclone V FPGA devices */
#define LEDR_BASE             0xFF200000
#define HEX3_HEX0_BASE        0xFF200020
#define HEX5_HEX4_BASE        0xFF200030
#define SW_BASE               0xFF200040
#define KEY_BASE              0xFF200050
#define TIMER_BASE            0xFF202000
#define PIXEL_BUF_CTRL_BASE   0xFF203020
#define CHAR_BUF_CTRL_BASE    0xFF203030

/* VGA colors */
#define WHITE 0xFFFF
#define YELLOW 0xFFE0
#define RED 0xF800
#define GREEN 0x07E0
#define BLUE 0x001F
#define CYAN 0x07FF
#define MAGENTA 0xF81F
#define GREY 0xC618
#define PINK 0xFC18
#define ORANGE 0xFC00

#define ABS(x) (((x) > 0) ? (x) : -(x))

/* Screen size. */
#define RESOLUTION_X 320
#define RESOLUTION_Y 240

/* Constants for animation */
#define BOX_LEN 2
#define NUM_BOXES 8

#define FALSE 0
#define TRUE 1

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

// Begin part1.s for Lab 7

volatile int pixel_buffer_start; // global variable

//Function that plots the pixel
void plot_pixel(int x, int y, short int line_color)
{
    *(short int *)(pixel_buffer_start + (y << 10) + (x << 1)) = line_color;
}

//Function that swaps two values
void swap_values(int* a, int* b)
{
    int temp_var = *a;
    *a = *b;
    *b = temp_var;
}

//Function that clears the screen
void clear_screen()
{
	for (int x = 0; x < 320; x++) //Looping through the row elements
	{
		for (int y = 0; y < 240; y++) //Looping through the column elements
		{
			plot_pixel(x, y, 0x0000); //Plotting black to clear the screen
		}
	}
}

//Function that draws a line with the algorithm
void draw_line(int x0, int y0, int x1, int y1, short int line_colour)
{
	//Checking if it is steep, by seeing if the rise or run is higher, if the rise is 
	//higher that means the line is steeper
	bool steep_check = abs(y1 - y0) > abs(x1 - x0);
	
	//Since it is steeper, we need to traverse along the yvalues
	if(steep_check)
	{
	    swap_values(&x0, &y0); //So we swap out the values
	    swap_values(&x1, &y1); //So we swap out the values
	}
	
	//We need the larger value in x1, so in the case that the x0 value is larger,
	//we swap the x values and also the y values
	if (x0 > x1)
	{
	    swap_values(&x0, &x1); //Swapping the x values
	    swap_values(&y0, &y1); //Swapping the y values
	}
	
	int deltax = x1 - x0; //Delta x
	int deltay = abs(y1 - y0); //Delta y
	int error = -(deltax / 2); //Provided pseudocode
	int y = y0;
	
	//IMPLEMENTED PSEUDOCODE
	//Pseodocode checks for a variety of things needed for the algorithm
	//It increments x and also checks if y value should change
	//It also plots the lines
	//The errror variale helps define if the y varaible should be changed
	int y_step = 0;
	if (y0 < y1)
	{
	    y_step = 1;
	}
	else
	{
	    y_step = -1;
	}
	
	for (int x = x0; x < x1; x++)
	{
	    if(steep_check)
	    {
	        plot_pixel(y, x, line_colour);
	    }
	    else
	    {
	        plot_pixel(x, y, line_colour);
	    }
	    
	    error += deltay;
	    
	    if(error >= 0)
	    {
	        y = y + y_step;
	        error -= deltax;
	    }
	}
}

int main(void)
{
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
    /* Read location of the pixel buffer from the pixel buffer controller */
    pixel_buffer_start = *pixel_ctrl_ptr;

    clear_screen();
    draw_line(0, 0, 150, 150, 0x001F);   // this line is blue
    draw_line(150, 150, 319, 0, 0x07E0); // this line is green
    draw_line(0, 239, 319, 239, 0xF800); // this line is red
    draw_line(319, 0, 0, 239, 0xF81F);   // this line is a pink color
	
	return 0;
}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	