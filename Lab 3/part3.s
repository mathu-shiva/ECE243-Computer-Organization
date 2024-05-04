.text 
.global _start

_start:		MOV    R0, #0				//Holds the value to display 
			MOV    R1, #0           	//Register that detects if a button is pushed and released
		 	MOV    R2, #0				//Register that checks which button has been pushed
			LDR    R7, =0xFF200050  	//Base addresses for the push buttons
		 	LDR    R8, =0xFF200020  	//Base address for the seven-segment displays
		 
WHILE_KEY_IS_PRESSED:
	     	LDR		R1, [R7]         	//Loading in R1 with the base address for push buttons
	     	CMP		R1, #0           	//Checking if the key value is zero
	     	BEQ		FIND_KEY         	//If it is zero, we go and check if any keys are pressed
	     	MOV 	R2, R1           	//If it is not zero, ie. one, we loop till button is released
		 	B      	WHILE_KEY_IS_PRESSED//Looping through until the button is released

FIND_KEY:	CMP    	R2, #1             	//Comparing R2 with Push Button 0
		 	MOVEQ 	R0, #0			  	//If it is zero, meaning PB0 was 1, then R0 is 0
		 
		 	CMP		R2, #2             	//Comparing R2 with the address of Push Button 1
		 	ADDEQ 	R0, #1			   	//If it is zero, meaning PB1 was 1, then we increment R0
		 
		 	CMP 	R2, #4             	//Comparing R2 with the address of Push Button 3
		 	SUBEQ 	R0, #1			   	//If it is zero, meaning PB2 was 1, then we decrement R0
		 
         	CMP		R2, #8             	//Comparing R2 with the address of Push Button 4
		 	BEQ		BLANK			   	//If it is zero, then branch to BLANK
		 
CHECK_COUNT:
			CMP		R0, #10				//Comparing R0 to 10 to check if we have reached nine
		 	MOVEQ	R0, #9				//If we have reached nine, then we move nine back into R0 to ensure value does not change
		 
		 	CMP		R0, #-1				//Comparing R0 
		 	MOVEQ	R0, #0				//If we have reached zero, then we move zero back into R0 to ensure value does not change
		 
SEG7_CODE:	MOV     R1, #BIT_CODES  	//Moving the address of the Bit codes into R1
            ADD     R1, R0         
            LDRB    R2, [R1]       		//R2 has the bit code
            MOV     R3, R2    			//This bit code in R2 is moved into R3      
			STR     R3, [R8]			//Now this is stored into R8, which holds the base address for the displays
			B       WHILE_KEY_IS_PRESSED//Branch back to the polling 
			
BLANK:		MOV 	R3, #0b00000000     //Set the register value of R3 to 0
	     	STR		R3, [R8]            //Store zero into R8, which causes the base address to be 0 and blank display
		 
	     	LDR		R2, [R7]            //Loading the state of the push button into R2
	     	CMP		R2, #0              //If R2 is zero, meaning a button has not been pushed
	    	BEQ		BLANK				//Continuously branch into blank
		 	MOV 	R0, #9             //Reset the counter
		 	B		WHILE_KEY_IS_PRESSED//Branch back to the polling

BIT_CODES:  .byte   0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
            .byte   0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
            .skip   2
.end 