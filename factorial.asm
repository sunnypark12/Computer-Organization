;;=============================================================
;;  CS 2110 - Spring 2023
;;  Homework 6 - Factorial
;;=============================================================
;;  Name: Sunho Park
;;============================================================

;;  In this file, you must implement the 'MULTIPLY' and 'FACTORIAL' subroutines.

;;  Little reminder from your friendly neighborhood 2110 TA staff: don't run
;;  this directly by pressing 'Run' in complx, since there is nothing put at
;;  address x3000. Instead, call the subroutine by doing the following steps:
;;      * 'Debug' -> 'Simulate Subroutine Call'
;;      * Call the subroutine at the 'MULTIPLY' or 'FACTORIAL' labels
;;      * Add the [a, b] or [n] params separated by a comma (,) 
;;        (e.g. 3, 5 for 'MULTIPLY' or 6 for 'FACTORIAL')
;;      * Proceed to run, step, add breakpoints, etc.
;;      * Remember R6 should point at the return value after a subroutine
;;        returns. So if you run the program and then go to 
;;        'View' -> 'Goto Address' -> 'R6 Value', you should find your result
;;        from the subroutine there (e.g. 3 * 5 = 15 or 6! = 720)

;;  If you would like to setup a replay string (trace an autograder error),
;;  go to 'Test' -> 'Setup Replay String' -> paste the string (everything
;;  between the apostrophes (')) excluding the initial " b' ". If you are 
;;  using the Docker container, you may need to use the clipboard (found
;;  on the left panel) first to transfer your local copied string over.

.orig x3000
    ;; You do not need to write anything here
    HALT

;;  MULTIPLY Pseudocode (see PDF for explanation and examples)   
;;  
;;  MULTIPLY(int a, int b) {
;;      int ret = 0;
;;      while (b > 0) {
;;          ret += a;
;;          b--;
;;      }
;;      return ret;
;;  }


MULTIPLY ;; Do not change this label! Treat this as like the name of the function in a function header

    ADD R6, R6, #-4
	STR R7, R6, #2
	STR R5, R6, #1
	ADD R5, R6, #0 
    ADD R6, R6, #-5 ; push 5 words
    STR R0, R5, #-1 ; save SR1
    STR R1, R5, #-2 ; save SR2
    STR R2, R5, #-3 ; save SR3
    STR R3, R5, #-4 ; save SR4
    STR R4, R5, #-5 ; save SR5

    AND R0, R0, #0
    STR R0, R5, #0

    W1 
    LDR R0, R5, #5 ; R0 = b
    BRnz ENDW1
    LDR R0, R5, #0 ; R0 = ret
    LDR R1, R5, #4 ; R1 = a
    ADD R0, R0, R1 ; R0 = ret  + a
    STR R0, R5, #0 ; ret = R0

    LDR R0, R5, #5 ; R0 = b
    ADD R0, R0, #-1 ; R0 = b-1   

    STR R0, R5, #5 ; b = b-1 = R0 
    BR W1  

ENDW1
LDR R0, R5, #0 ; R0 = ret
STR R0, R5, #3 ; set ret val to ret  

LDR R4, R5, #-5 ; restore R4
LDR R3, R5, #-4 ; restore R3
LDR R2, R5, #-3 ; restore R2
LDR R1, R5, #-2 ; restore R1
LDR R0, R5, #-1 ; restore R0
ADD R6, R5, #0  ; pop saved regs and local vars
LDR R7, R5, #2  ; R7 = ret addr
LDR R5, R5, #1  ; FP = Old FP
ADD R6, R6, #3  ; pop 3 words
RET
    
;;  FACTORIAL Pseudocode (see PDF for explanation and examples)
;;
;;  FACTORIAL(int n) {
;;      int ret = 1;
;;      for (int x = 2; x <= n; x++) {
;;          ret = MULTIPLY(ret, x);
;;      }
;;      return ret;
;;  }
FACTORIAL ;; Do not change this label! Treat this as like the name of the function in a function header

ADD R6, R6, #-4 ; Allocate space rv,ra,fp,lv1
STR R7, R6, #2 ; Save Ret Addr
STR R5, R6, #1 ; Save Old FP
ADD R5, R6, #0 ; Copy SP to FP
ADD R6, R6, #-1

ADD R6, R6, #-5 ; Make room for saved regs & l.v. 1-n
STR  R0, R5, #-2 ; Save R0
STR  R1, R5, #-3 ; Save R1
STR  R2, R5, #-4 ; Save R2
STR  R3, R5, #-5 ; Save R3
STR  R4, R5, #-6 ; Save R4

AND R0, R0, #0 ;ret = 1
ADD R0, R0, #1 ;ret = 1

LDR R1, R5, #4 ; R1 = n
NOT R1, R1
ADD R1, R1, #1 ; R1 = -n

AND R2, R2, #0
ADD R2, R2, #2 ; x = 2

FOR 
ADD R3, R1, R2 ; x-n <= 0
BRp ENDFOR

STR R0, R6, #0 ; RET
STR R2, R6, #1 ; X
JSR MULTIPLY

LDR R0, R6, #0 ; ret = MULTIPLY
ADD R2, R2, #1 ; X++ 

BR FOR

ENDFOR
STR R0, R5, #3

LDR R4, R5, #-6 ; Restore R4
LDR R3, R5, #-5 ; Restore R3
LDR R2, R5, #-4 ; Restore R2
LDR R1, R5, #-3 ; Restore R1
LDR R0, R5, #-2 ; Restore R0
ADD R6, R5, #0 ; Restore SP
LDR R5, R6, #1 ; Restore FP
LDR R7, R6, #2 ; Restore RA
ADD R6, R6, #3 ; Pop ra,fp,lv1

RET

;; Needed to Simulate Subroutine Call in Complx
STACK .fill xF000
.end