/* Program that converts a binary number to decimal */
           
           .text               // executable code follows
           .global 	_start
_start:
            MOV    	R4, #N		//Has the number to be converted
            MOV    	R5, #Digits  //Has the space allocated
            LDR    	R4, [R4]     // Loading the value into the register
            MOV    	R0, R4       //Copying the value into register 0
            BL     	DIVIDE1000	//Branch label into the sub-routine
			STRB	R9, [R5, #3]	//Storing the thousands digit in register 5
			STRB	R8, [R5, #2]	//Storing the hundreds digit in register 5
			STRB	R7, [R5, #1]	//Storing the tens digit in register 5
			STRB	R0, [R5]		//Storing the ones digit in register 5
END:        B		END		//Infinite Loop

DIVIDE1000:	MOV		R2, #0 		//Setting Register 2 (for remainder) to zero
			B		CONT1000	//Branching to the dividing loop for 1000s
			
CONT1000:	CMP		R0, #1000	//Comparing if the register value is less than 1000
			BLT		DIVEND1000	//If branch less than zero, go to the label where it stores remainder
			SUB		R0, #1000	//If not, subtract 1000
			ADD		R2, #1		//Adding one to register 2 so we can hold the remainder
			B		CONT1000	//Branch back, looping
			
DIVEND1000:	MOV		R9, R2		//Moving the remainder of the 1000s into register 9
			B		DIVIDE100	//Branching to DIVIDE100, to find the remainder of 100s
			
DIVIDE100:	MOV		R2, #0		//Setting Register 2 (for remainder) to zero
			B		CONT100		//Branching to the dividing loop for 100s
			
CONT100:	CMP		R0, #100	//Comparing if the register value is less than 100
			BLT		DIVEND100	//If branch less than zero, go to the label where it stores remainder
			SUB		R0, #100	//If not, subtract 100
			ADD		R2, #1		//Adding one to register 2 so we can hold the remainder
			B		CONT100		//Branch back, looping

DIVEND100:	MOV		R8, R2		//Moving the remainder of the 1000s into register 8
			B		DIVIDE10	//Branching to DIVIDE10, to find the remainder of 10s
			
DIVIDE10:	MOV		R2, #0		//Setting Register 2 (for remainder) to zero
			B		CONT10		//Branching to the dividing loop for 10s
			
CONT10:		CMP		R0, #10		//Comparing if the register value is less than 10
			BLT		DIVEND10	//If branch less than zero, go to the label where it store remainder
			SUB		R0, #10		//If not, subtract 1000
			ADD		R2, #1		//Adding one to register 2 so we can hold the remainder
			B		CONT10		//Branch back, looping
			
DIVEND10:	MOV		R7, R2		//Moving the remainder of the 1000s into register 7
			MOV		PC, LR		//Returning to the next command after the sub-routine was called

N:			.word	4376         // the decimal number to be converted
Digits:     .space	8          // storage space for the decimal digits

            .end
