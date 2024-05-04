/* Program that finds the largest number in a list of integers	*/
            
            .text                   // executable code follows
            .global _start                  
_start:                             
            MOV     R4, #RESULT     // R4 points to the result location
            LDR     R0, [R4, #4]    // R0 holds the number of elements in the list
            MOV     R1, #NUMBERS    // R1 points to the start of the list, holds the address of first element
			LDR		R5, [R1]		//Loading the first value of the list into register 5	
            BL      LARGE			//Branch label into the sub-routine
            STR     R0, [R4]        // R0 holds the subroutine return value

END:        B       END             //Infinite loop

/* Subroutine to find the largest integer in a list
 * Parameters: R0 has the number of elements in the list
 *             R1 has the address of the start of the list
 * Returns: R0 returns the largest item in the list */
LARGE:      SUBS	R0, #1			//Subtracting by 1 the number of elements, like a for loop
			BEQ		LABEL			//If we branch equal to zero, go to the label
			ADD		R1, #4			//If not equal to zero, add 4 to go to the next adress and element of list
			LDR		R2, [R1]		//Load the value at the register 1 into register 2
			CMP		R5, R2			//Compare the value stored in register 5 and register 2
			BGE		LARGE			//If branch greater than, then register 5 is larger than register 2
			MOV		R5, R2			//If R5 is not larger than R2, then move R2 value into R%
			B		LARGE			//Rebranch, looping
			
LABEL:		MOV		R0, R5			//Move the value in R5 into R0
			MOV		PC, LR			//Going back to the next command where the sub-routine was called

RESULT:     .word   0 			//Initialization of the result value          
N:          .word   7           // number of entries in the list
NUMBERS:    .word   4, 5, 3, 6  // the data
            .word   1, 8, 2  	//remainder of the data               

            .end                            
