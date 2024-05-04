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

//Function that waits a 60th of a second
void wait_60th()
{
	//Registers of the status register and the pixel control
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
    volatile int * status = (int *)0xFF20302C;
    
	//Putting in a 1 into the pixel controller to start the swapping
    *pixel_ctrl_ptr = 1;
    
	//While the status register is 1 do nothing, only leaves when 
	//status register becomes zero and we swap
    while (*status & 0x01)
    {
        ;
    }
}

int main(void)
{
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
    //Declaring variables for each of the 8 boxes
    int x[8], y[8], x_diagonal[8], y_diagonal[8], colour[8];
	//List of colours for each line (did it for funzies)
	short int colourList[] = {CYAN, BLUE, GREEN, PINK, MAGENTA, RED, ORANGE, YELLOW};

    /* set front pixel buffer to start of FPGA On-chip memory */
	//Setting a random intial position
	//Looping eight times for eight different box positions
    for (int position = 0; position < 8; position++)
    {
        x[position] = rand() % 319; //Random x position (320 pixels)
        y[position] = rand() % 239; //Random y position (239 pixels)
		//Next two lines are random diagonal movements as mentioned in class
        x_diagonal[position] = rand() % 2 * 2 - 1;
        y_diagonal[position] = rand() % 2 * 2 - 1;
    }
    
	//Address of the back buffer
    *(pixel_ctrl_ptr + 1) = 0xC8000000; 

    //Waiting 60th second before swapping front and back buffer
    wait_60th();
    /* initialize a pointer to the pixel buffer, used by drawing functions */
    pixel_buffer_start = *pixel_ctrl_ptr;
    clear_screen(); // pixel_buffer_start points to the pixel buffer
    /* set back pixel buffer to start of SDRAM memory */
    *(pixel_ctrl_ptr + 1) = 0xC0000000;
    pixel_buffer_start = *(pixel_ctrl_ptr + 1); // we draw on the back buffer
    clear_screen(); // pixel_buffer_start points to the pixel buffer

    while (1) //Infinite loop
    {
        /* Erase any boxes and lines that were drawn in the last iteration */
        clear_screen();
        
		//Looping through the eight boxes and drawing them
        for (int box = 0; box < 8; box++)
        {
			//Drawing all the white boxes
            plot_pixel(x[box], y[box], 0xFFFF); //Drawing one bottom left corner
            plot_pixel(x[box] + 1, y[box], 0xFFFF); //Drawing corner bottom right corner
            plot_pixel(x[box], y[box] + 1, 0xFFFF); //Drawing top left corner
            plot_pixel(x[box] + 1, y[box] + 1, 0xFFFF); //Drawing top right corner
            
			//If we are below seven indicating we are not at the last box
            if (box < 7)
            {
				//We draw a line from the box we are at to the next box
                draw_line(x[box], y[box], x[box + 1], y[box + 1], colourList[box]);
            }
			//If we are equal to seven indicating we are at the last boc
            else if (box == 7)
            {
				//We draw a line from the last box back to the first box
                draw_line(x[box], y[box], x[0], y[0], colour[box]);
            }
            
			//These are bound checkers to ensure we move in the correct directions
			//In the case that we are at the edge and can only move in one direction
            if (x[box] == 0) //If we hit the left edge
            {
                x_diagonal[box] = 1; //Move right diagonal
            }
            else if (x[box] == 319) //If we hit the right edge
            {
                x_diagonal[box] = -1; //Move left diagonal
            }
            
            if (y[box] == 0) //If we hit the top edge
            {
                y_diagonal[box] = 1; //Move down diagonal
            }
            else if (y[box] == 239) //If we hit the bottom edge
            {
                y_diagonal[box] = -1; //Moveup diagonal
            }
            
            x[box] += x_diagonal[box];
            y[box] += y_diagonal[box];
        }

        // code for drawing the boxes and lines (not shown)
        // code for updating the locations of boxes (not shown)

        wait_60th(); // swap front and back buffers on VGA vertical sync
        pixel_buffer_start = *(pixel_ctrl_ptr + 1); // new back buffer
    }
}

// code for subroutines (not shown)
