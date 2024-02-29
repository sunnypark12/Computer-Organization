;;=============================================================
;; CS 2110 - Spring 2023
;; Homework 5 - buildMaxArray
;;=============================================================
;; Name: Sunho Park
;;=============================================================

;;  Pseudocode (see PDF for explanation)
;;  Pseudocode values are based on the labels' default values.
;;
;;	int A[] = {-2, 2, 1};
;;	int B[] = {1, 0, 3};
;;	int C[3];
;;	int length = 3;
;;
;;	int i = 0;
;;	while (i < length) {
;;		if (A[i] >= B[length - i - 1]) {
;;			C[i] = 1;
;;		}
;;		else {
;;			C[i] = 0;
;;		}
;;		i++;
;;	}

.orig x3000
	; Load address of A into R0
	LD R0, A
	; Load address of B into R1
	LD R1, B
	; Load address of C into R2
	LD R2, C
	; Load the length of the arrays into R3
	LD R3, LENGTH
	; Initialize loop counter in R4 to 0
	AND R4, R4, #0 ;i 
	AND R7, R7, #0 ;return value

W1   ; Begin loop
	NOT		R3, R3
	ADD		R3, R3, #1 ; -length 
	ADD		R4, R4, R3 ; i - length
	BRzp W2 ; when i >= length --> W2
	
	; restore length
	NOT R3, R3
	ADD R3, R3, #1

	; restore i
	ADD R4, R4, R3

	; Value A 
	ADD		R5, R0, R4 ;A + i
	LDR 	R5, R5, #0 ;value in A + i

	; Index of B
	NOT R4, R4 
	ADD R4, R4, #1 ;  -i
	ADD R3, R3, R4 ;  length - i
	ADD R3, R3, #-1;  length - i - 1
	
	;Value B
	ADD R6, R1, R3 ; B + length - i - 1
	LDR R6, R6, #0 ; value in B + length - i - 1

	;restore i
	NOT R4, R4
	ADD R4, R4, #1 ; i

	;restore length
	ADD R3, R3, #1
	ADD R3, R3, R4 ; length - i + i

    ; Compare values in R5 and R6
	NOT R6, R6
	ADD R6, R6, #1 ;-R6
	ADD R5, R5, R6 ; R5 - R6
	BRn ELSE

	; Store 1 in i index of C array 
	ADD R2, R2, R4 ; C + i 
	ADD R7, R7, #1 ; return 1 
	STR R7, R2, #0 ; store 1 in C + i

	;restore C
	NOT R4, R4
	ADD R4, R4, #1
	ADD R2, R2, R4
	;restore i
	NOT R4, R4
	ADD R4, R4, #1

	ADD R4, R4, #1 ; i ++

	;restore R5 and R6
	NOT R6, R6
	ADD R6, R6, #1

	ADD R5, R5, R6

	;restore R7
	AND R7, R7, #0

	BR W1

	ELSE 
		; Store 0 in i index of C array 
		AND R7, R7, #0 ;R7 = 0
		ADD R2, R2, R4 ; C + i
		STR R7, R2, #0 ; store 0 in C + i

		;restore C
		NOT R4, R4
		ADD R4, R4, #1
		ADD R2, R2, R4
		;restore i
		NOT R4, R4
		ADD R4, R4, #1

		ADD R4, R4, #1 ; i ++

		;restore R5 and R6
		NOT R6, R6
		ADD R6, R6, #1

		ADD R5, R5, R6
		BR W1

	;; Halt the program

W2 HALT

;; Do not change these addresses! 
;; We populate A and B and reserve space for C at these specific addresses in the orig statements below.
A 		.fill x3200		
B 		.fill x3300		
C 		.fill x3400		
LENGTH 	.fill 3			;; Change this value if you decide to increase the size of the arrays below.
.end

;; Do not change any of the .orig lines!
;; If you decide to add more values for debugging, make sure to adjust LENGTH and .blkw 3 accordingly.
.orig x3200				;; Array A : Feel free to change or add values for debugging.
	.fill -2
	.fill 2
	.fill 1
.end

.orig x3300				;; Array B : Feel free change or add values for debugging.
	.fill 1
	.fill 0
	.fill 3
.end

.orig x3400
	.blkw 3				;; Array C: Make sure to increase block size if you've added more values to Arrays A and B!
.end