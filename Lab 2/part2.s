/* Program that counts consecutive 1's */

          	.text                   // executable code follows
          	.global _start
			
_start:     MOV     R1, #TEST_NUM	//First list value address is in R1
          	LDR     R1, [R1]		//R1 contains the first list value
			MOV		R3, #TEST_NUM	//First list value address is in R3
          	MOV     R0, #0			//Initializing R0 to 0
			MOV		R4, #0			//Initializing R4 to 0
			MOV		R5, #0			//Initializing R5 to 0
			B		LISTLOOP		//Branching to loop for the list of data
			
LISTLOOP:	BL		ONES			//Branching to the sub-routine of ones
			LDR		R4, [R3]		//Loading value in address of R3 into R4
			CMP		R4, #0			//Checking if the value was 0 by chance
			BEQ		TERMINATE		//If one of the values was equal to zero, we branch to terminate
			ADD		R3, #4			//If not zero, move to next address in list
			LDR		R1, [R3]		//Load value at that address into R1
			B		LISTLOOP		//Rebranching to listloop so that it acts as a loop
			
TERMINATE:	B		TERMINATE		//Infinite loop when terminating value 0 is hit
						  		  
ONES:		CMP     R1, #0        	//Checking if value is equal to zero
          	BEQ     FIVE            //If equal to zero, branch to FIVE
          	LSR     R2, R1, #1     	//Shifting right by one bit
          	AND     R1, R1, R2      //Anding it to determine consecutive ones and replacing with R1
          	ADD     R0, #1     		//Increasing R0 by one; acts as a counter
          	B       ONES			//Rebranching to ONES
			
FIVE:		CMP		R5, R0			//Comparing if new counter value is higher
			BLT		REPLACE			//If it is higher, branch to REPLACE
			MOV		R0, #0			//If not higher, reset R0 to zero
			MOV		PC, LR			//Returning to the next step/address after the subroutine calling

REPLACE:	MOV		R5, R0			//Move new counter value to R5 since higher
			MOV		R0, #0			//Resetting R0 back to zero
			MOV		PC, LR			//Returning to the next step/address after the subroutine calling
         
TEST_NUM: 	.word   0x103fe00f, 0x802010, 0xC02010, 0xC03C10
			.word	0xffffffff, 0x1C0000, 0xC1E00, 0xF9E00
			.word	0x7E0F9E00, 0x0

          	.end
			