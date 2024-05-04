/* Program that counts consecutive 1's */

          	.text                   // executable code follows
          	.global _start
			
_start:     MOV     R1, #TEST_NUM	//First list value address is in R1
          	LDR     R1, [R1]		//R1 contains the first list value
			MOV		R3, #TEST_NUM	//First list value address is in R3
          	MOV     R0, #0			//Initializing R0 to 0
			MOV		R4, #0			//Initializing R4 to 0
			MOV		R5, #0			//Initializing R5 to 0
			MOV		R6, #0			//Initializing R6 to 0
			MOV		R7, #0			//Initializing R7 to 0
			MOV		R8, #PATTERN	//Moving the address of alternating string of 1s and 0s into R8
			LDR		R8, [R8]		//Loading the alternating string into R8
			MOV		R9, #0			//Initializing R9 to 0
			MOV		R10, #0			//Initializing R10 to 0
			MOV		R11, #0			//Initializing R11 to 0
			B		LISTLOOP		//Branching to loop for the list of data
			
LISTLOOP:	BL		ONES			//Branching to the sub-routine of ones
			MVN		R1, R1			//Inverting the value of R1 and moving to R1
			BL		ZEROS			//Branching to the sub-routine of zeros
			BL		ALTERNATE		//Branching to the sub-routine of alternate
			LDR		R4, [R3]		//Loading the value at address of R3 into R4
			CMP		R4, #0			//Checking if that value is zero
			BEQ		TERMINATE		//If the value is zero, the program ends
			ADD		R3, #4			//If not, we move to the next value	
			LDR		R1, [R3]		//Load R1 with the new value at the address in R3
			B		LISTLOOP		//Rebranching to listloop so that it acts as a loop

TERMINATE:	B		TERMINATE		//Infinite loop when terminating value 0 is hit
						  		  
ONES:		CMP     R1, #0        	//Checking if value is equal to zero
          	BEQ     FIVE            //If equal to zero, branch to FIVE
          	LSR     R2, R1, #1     	//Shifting right by one bit
          	AND     R1, R1, R2      //Anding it to determine consecutive ones
          	ADD     R0, #1     		//Increasing R0 by one; acts as a counter
          	B       ONES			//Rebranching to ONES
			
FIVE:		CMP		R5, R0			//Comparing if new counter value is higher
			BLT		REPLACE5		//If it is higher, we branch to REPLACE5
			MOV		R0, #0			//If not higher, reset R0 to zero
			LDR		R1, [R3]		//Reload R1 with the value for the next subroutine ZEROS
			MOV		PC, LR			//Return to where the subroutine was called

REPLACE5:	MOV		R5, R0			//Move new counter value to R5 since higher
			MOV		R0, #0			//Resetting R0 back to zero
			LDR		R1, [R3]		//Reload R1 with the value for the next subroutine ZEROS
			MOV		PC, LR			//Return to where the subroutine was called

		
ZEROS:		CMP		R1, #0			//Checking if value is equal to zero
			BEQ		SIX				//If equal to zero, branch to SIX
			LSR		R2, R1, #1		//Shifting right by one bit
			AND		R1, R1, R2		//Anding it to determine consecutive ones
			ADD		R0, #1			//Increasing R0 by one; acts as a counter
			B		ZEROS			//Rebranching to ZEROS
			
SIX:		CMP		R6, R0			//Comparing if new counter value is higher
			BLT		REPLACE6		//If it is higher, we branch to REPLACE6
			MOV		R0, #0			//If not higher, reset R0 to zero
			LDR		R1, [R3]		//Reload R1 with the value for the next subroutine ALTERNATE
			MOV		PC, LR			//Return to where the subroutine was called
			
REPLACE6:	MOV		R6, R0			//Move new counter value to R6 since higher
			MOV		R0, #0			//Resetting R0 back to zero
			LDR		R1, [R3]		//Reload R1 with the value for the next subroutine ALTERNATE
			MOV		PC, LR			//Return to where the subroutine was called
			
ALTERNATE:	EOR		R1, R8, R1		//Exclusive Or Gate the value with the alternating string
			MOV		R11, R1			//Saving this XORed value into R11 as well
			B		ALTONES			//Branching to ALTONES
			
ALTONES:	CMP		R1, #0			//Checking if the value is zero, meaning no alternating
			BEQ		NINE			//If zero, branch to NINE
			LSR		R2, R1, #1		//Shifting right by one bit
			AND		R1, R1, R2		//Anding it to determine consecutive ones
			ADD		R0, #1			//Increasing R0 by one; acts as a counter
			B		ALTONES			//Rebranching to ALTONES
			
NINE:		CMP		R9, R0			//Comparing if new counter value is higher
			BLT		REPLACE9		//If it is higher, we branch to REPLACE9
			MOV		R0, #0			//If not higher, reset R0 to zero
			LDR		R1, [R3]		//Reload R1 with the value //NOT NEEDED
			MVN		R1, R11			//Inverting the XORed value and moving into R1
			B		ALTZEROS		//Branching to ALTZEROS
			
REPLACE9:	MOV		R9, R0			//Move new counter value to R6 since higher
			MOV		R0, #0			//Resetting R0 back to zero
			LDR		R1, [R3]		//Reload R1 with the value //NOT NEEDED
			MVN		R1, R11			//Inverting the XORed value and moving into R1
			B		ALTZEROS		//Branching to ALTZEROS
			
ALTZEROS:	CMP		R1, #0			//Checking if the value is zero, meaning no alternating
			BEQ		TEN				//If zero, branch to TEN
			LSR		R2, R1, #1		//Shifting right by one bit
			AND		R1, R1, R2		//Anding it to determine consecutive ones
			ADD		R0, #1			//Increasing R0 by one; acts as a counter
			B		ALTZEROS		//Rebranching to ALTZEROS
			
TEN:		CMP		R10, R0			//Comparing if new counter value is higher
			BLT		REPLACE10		//If it is higher, we branch to REPLACE10
			MOV		R0, #0			//If not higher, reset R0 to zero
			LDR		R1, [R3]		//Reload R1 with the value //NOT NEEDED
			B		COMPARE			//Branching to COMPARE
			
REPLACE10:	MOV		R10, R0			//Comparing if new counter value is higher
			MOV		R0, #0			//Resetting R0 back to zero
			LDR		R1, [R3]		//Reload R1 with the value //NOT NEEDED
			B		COMPARE			//Branching to COMPARE
			
COMPARE:	CMP		R10, R9			//Comparing the longest consecutives 1s with longest consecutive 0s
			BLT		SEVENV1			//If R9 > R10 (consecutive 1s > consecutive 0s), branch to SEVENV1
			BGT		SEVENV2			//If R9 < R10 (consecutive 1s < consecutive 0s), branch to SEVENV2
			BEQ		SEVENV3			//If R9 = R10 (consecutive 1s = consecutive 0s), branch to SEVENV3
			
SEVENV1:	MOV		R7, R9			//Move value in R9 into R7
			MOV		PC, LR			//Return to where subroutine was called

SEVENV2:	MOV		R7, R10			//Move value in R10 into R7
			MOV		PC, LR			//Return to where subroutine was called
			
SEVENV3:	MOV		R7, R9			//Move value in R9 into R7 (doesn't matter if it is R9 or R10)
			MOV		PC, LR			//Return to where subroutine was called
         
TEST_NUM: 	.word   0x103fe00f, 0x802010, 0xC02010, 0xC03C10
			.word	0xffffffff, 0x1C0000, 0xC1E00, 0xF9E00
			.word	0x7E0F9E00, 0x0
			
PATTERN:	.word	0xAAAAAAAA

          	.end
			