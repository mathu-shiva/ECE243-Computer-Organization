/* Program that counts consecutive 1's */

          	.text                   // executable code follows
          	.global _start

//SEE DOCUMENTATION AND COMMENTS FOR THE CODE IN PART3.S
_start:     MOV     R1, #TEST_NUM	
          	LDR     R1, [R1]		
			MOV		R3, #TEST_NUM	
          	MOV     R0, #0			
			MOV		R4, #0			
			MOV		R5, #0			
			MOV		R6, #0
			MOV		R7, #0
			MOV		R8, #PATTERN
			LDR		R8, [R8]
			MOV		R9, #0
			MOV		R10, #0	
			MOV		R11, #0
			B		LISTLOOP
			
LISTLOOP:	BL		ONES
			MVN		R1, R1
			BL		ZEROS
			BL		ALTERNATE
			LDR		R4, [R3]
			CMP		R4, #0
			BEQ		DISPLAY			//If we reach a value of zero, we go to display the final results
			ADD		R3, #4			
			LDR		R1, [R3]	
			B		LISTLOOP		
						  		  
ONES:		CMP     R1, #0        	
          	BEQ     FIVE            
          	LSR     R2, R1, #1     	
          	AND     R1, R1, R2      
          	ADD     R0, #1     		
          	B       ONES			
			
FIVE:		CMP		R5, R0			
			BLT		REPLACE5		
			MOV		R0, #0			
			LDR		R1, [R3]
			MOV		PC, LR		

REPLACE5:	MOV		R5, R0			
			MOV		R0, #0			
			LDR		R1, [R3]
			MOV		PC, LR
		
ZEROS:		CMP		R1, #0
			BEQ		SIX
			LSR		R2, R1, #1
			AND		R1, R1, R2
			ADD		R0, #1
			B		ZEROS
			
SIX:		CMP		R6, R0
			BLT		REPLACE6
			MOV		R0, #0
			LDR		R1, [R3]
			MOV		PC, LR
			
REPLACE6:	MOV		R6, R0
			MOV		R0, #0
			LDR		R1, [R3]
			MOV		PC, LR
			
ALTERNATE:	EOR		R1, R8, R1
			MOV		R11, R1
			B		ALTONES
			
ALTONES:	CMP		R1, #0
			BEQ		NINE
			LSR		R2, R1, #1
			AND		R1, R1, R2
			ADD		R0, #1
			B		ALTONES
			
NINE:		CMP		R9, R0
			BLT		REPLACE9
			MOV		R0, #0
			LDR		R1, [R3]
			MVN		R1, R11
			B		ALTZEROS
			
REPLACE9:	MOV		R9, R0
			MOV		R0, #0
			LDR		R1, [R3]
			MVN		R1, R11
			B		ALTZEROS
			
ALTZEROS:	CMP		R1, #0
			BEQ		TEN
			LSR		R2, R1, #1
			AND		R1, R1, R2
			ADD		R0, #1
			B		ALTZEROS
			
TEN:		CMP		R10, R0
			BLT		REPLACE10
			MOV		R0, #0
			LDR		R1, [R3]
			B		COMPARE
			
REPLACE10:	MOV		R10, R0
			MOV		R0, #0
			LDR		R1, [R3]
			B		COMPARE
			
COMPARE:	CMP		R10, R9
			BLT		SEVENV1
			BGT		SEVENV2
			BEQ		SEVENV3
			
SEVENV1:	MOV		R7, R9
			MOV		PC, LR

SEVENV2:	MOV		R7, R10
			MOV		PC, LR
			
SEVENV3:	MOV 	R7, R9
			MOV		PC, LR
			
//SEE DOCUMENTATION AND COMMENTS FOR THE CODE IN PART3.S

//DIVIDE SUBROUTINE
			
DIVIDE:     MOV    R2, #0

CONT:       CMP    R0, #10
            BLT    DIV_END
            SUB    R0, #10
            ADD    R2, #1
           	B      CONT
			
DIV_END:  	MOV    R1, R2			//R1 has the quotient, the tens digit in it
            MOV    PC, LR
			
//DIVIDE SUBROUTINE

//HEXADECIMAL DISPLAY SUBROUTINE
		
SEG7_CODE:  MOV     R1, #BIT_CODES  
            ADD     R1, R0         	//Index into the BIT_CODES "array"
            LDRB    R0, [R1]		//Returns the bit pattern loaded into R0
            MOV     PC, LR              

BIT_CODES:  .byte   0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
            .byte   0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
            .skip   2      // pad with 2 bytes to maintain word alignment
			
//HEXADECIMAL DISPLAY SUBROUTINE

//DISPLAY SUBROUTINE

/* Display R5 on HEX1-0, R6 on HEX3-2 and R7 on HEX5-4 */
DISPLAY:	LDR     R8, =0xFF200020		//Memory-mapped base address of HEX3-HEX0
            MOV     R0, R5				//Moving the value of R5 into R0
            BL      DIVIDE          	//Branching to the DIVIDE subroutine
            MOV     R9, R1          	//R1 will contain the tens digit, being moved into R9
            BL      SEG7_CODE			//Branching to SEG7_CODE subroutine					
            MOV     R4, R0          	//R0 will contain ones digit bit code, being moved into R4
            MOV     R0, R9          	//Moving tens digit into R0
            BL      SEG7_CODE 			//Branching to SEG7_CODe subroutine
			LSL     R0, #8				//Shifting the tens digit in R0 by 8 for HEX1
            ORR     R4, R0				//ORed the shifted R0 with R4 to display HEX0 - HEX1
					
			MOV		R0, R6				//Moving the value of R6 into R0
			BL		DIVIDE				//Branching to the DIVIDE subroutine
			MOV		R9, R1				//R1 will contain the tens digit, being moved into R9
			BL		SEG7_CODE			//Branching to SEG7_CODE subroutine		
			LSL		R0, #16				//Shifting the ones digit in R0 by 16 for HEX2
			ORR		R4, R0				//ORed the shifted R0 with R4 to display HEX0 - HEX2
			MOV		R0, R9				//Moving tens digit into R0
			BL		SEG7_CODE			//Branching to SEG7_CODE subroutine		
			LSL		R0, #24				//Shifting the tens digit in R0 by 24 for HEX4
			ORR		R4, R0				//ORed the shifted R0 with R4 to display HEX0 - HEX3
				
			STR     R4, [R8]       		//Storing the value at the address of R4 into R8
			
            LDR     R8, =0xFF200030 	//Memory-mapped base address of HEX3-HEX0
			MOV		R0, R7				//Moving the value of R6 into R0
			BL		DIVIDE				//Branching to the DIVIDE subroutine
			MOV     R9, R1          	//R1 will contain the tens digit, being moved into R9
            BL      SEG7_CODE 			//Branching to SEG7_CODE subroutine
			MOV     R4, R0          	//R0 will contain ones digit bit code, being moved into R4
            MOV     R0, R9          	//Moving tens digit into R0
            BL      SEG7_CODE 			//Branching to SEG7_CODE subroutine
			LSL     R0, #8				//Shifting the tens digit in R0 by 8 for HEX4
            ORR     R4, R0				//ORed the shifted R0 with R4 to display HEX4 - HEX5
			
			STR     R4, [R8]        	//Storing the value at the address of R4 into R8
			
			B		TERMINATE
			

//DISPLAY SUBROUTINE
			
TERMINATE:		B		TERMINATE		//An infinite loop to end the program
         
TEST_NUM: 	.word   0x103fe00f, 0x802010, 0xC02010, 0xC03C10
			.word	0xffffffff, 0x1C0000, 0xC1E00, 0xF9E00
			.word	0x7E0F9E00, 0x0
			
PATTERN:	.word	0xAAAAAAAA

          	.end
			