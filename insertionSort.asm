;;=============================================================
;;  CS 2110 - Spring 2023
;;  Homework 6 - Insertion Sort
;;=============================================================
;;  Name: Sunho Park
;;============================================================

;;  In this file, you must implement the 'INSERTION_SORT' subroutine.

;;  Little reminder from your friendly neighborhood 2110 TA staff: don't run
;;  this directly by pressing 'Run' in complx, since there is nothing put at
;;  address x3000. Instead, call the subroutine by doing the following steps:
;;      * 'Debug' -> 'Simulate Subroutine Call'
;;      * Call the subroutine at the 'INSERTION_SORT' label
;;      * Add the [arr (addr), length] params separated by a comma (,) 
;;        (e.g. x4000, 5)
;;      * Proceed to run, step, add breakpoints, etc.
;;      * INSERTION_SORT is an in-place algorithm, so if you go to the address
;;        of the array by going to 'View' -> 'Goto Address' -> 'Address of
;;        the Array', you should see the array (at x4000) successfully 
;;        sorted after running the program (e.g [2,3,1,1,6] -> [1,1,2,3,6])

;;  If you would like to setup a replay string (trace an autograder error),
;;  go to 'Test' -> 'Setup Replay String' -> paste the string (everything
;;  between the apostrophes (')) excluding the initial " b' ". If you are 
;;  using the Docker container, you may need to use the clipboard (found
;;  on the left panel) first to transfer your local copied string over.

.orig x3000
    ;; You do not need to write anything here
    HALT

;;  INSERTION_SORT **RESURSIVE** Pseudocode (see PDF for explanation and examples)
;; 
;;  INSERTION_SORT(int[] arr (addr), int length) {
;;      if (length <= 1) {
;;        return;
;;      }
;;  
;;      INSERTION_SORT(arr, length - 1);
;;  
;;      int last_element = arr[length - 1];
;;      int n = length - 2;
;;  
;;      while (n >= 0 && arr[n] > last_element) {
;;          arr[n + 1] = arr[n];
;;          n--;
;;      }
;;  
;;      arr[n + 1] = last_element;
;;  }

INSERTION_SORT ;; Do not change this label! Treat this as like the name of the function in a function header
    ADD R6, R6, #-4
	STR R7, R6, #2 ; return address in R7
	STR R5, R6, #1 ; R5 old framepoint
	ADD R5, R6, #0 ; move R5 into R6,#0
    ADD R6, R6, #-2 ; number of local variables

	ADD R6, R6, #-5
    STR  R0, R5, #-3 ; Save R0 // R6, #0
    STR  R1, R5, #-4 ; Save R1 // R6, #1
    STR  R2, R5, #-5 ; Save R2 // R6, #2
    STR  R3, R5, #-6 ; Save R3 // R6, #3
    STR  R4, R5, #-7 ; Save R4 // R6, #4

;;      if (length <= 1) {
IF  ; length - 1 <= 0
    LDR R0, R5, #5 ;length
    ADD R0, R0, #-1
    BRp ENDIF
    ;;        return;
        BR TEARDOWN

ENDIF
;;      INSERTION_SORT(arr, length - 1);
    ADD R6, R6, #-2

    LDR R0, R5, #4
    STR R0, R6, #0

    LDR R0, R5, #5
    ADD R0, R0, #-1
    STR R0, R6, #0

    JSR INSERTION_SORT

    ADD R6, R6, #3

;;      int last_element = arr[length - 1];
    LDR R0, R5, #4 ;arr
    LDR R1, R5, #5 ;length 
    ADD R1, R1, #-1 ;length-1
    ADD R0, R0, R1 ;add arr and length-1 index
    LDR R0, R0, #0 ;save arr[length - 1] to arr
    STR R0, R5, #0 ;store value into last_element

;;      int n = length - 2;
    LDR R0, R5, #5 ;length 
    ADD R0, R0, #-2 ;length-2
    STR R0, R5, #-1 ;store length - 2 to n

;;      while (n >= 0 && arr[n] > last_element) {
W1 
    LDR R0, R5, #-1 ;n
    BRn ENDW1 ;n >= 0

    LDR R1, R5, #4 ;arr
    ADD R1, R1, R0 ;arr[n]
    LDR R1, R1, #0 ;arr[n] -> arr

    LDR R2, R5, #0 ;last_element
    NOT R2, R2 ;last_element
    ADD R1, R1, R2 ;arr - last_element
    BRnz ENDW1 ;arr[n] > last_element
    
    ;; arr[n + 1] = arr[n];
    LDR R0, R5, #-1 ;n
    LDR R1, R5, #4 ;arr
    ADD R1, R1, R0 ;arr[n]
    LDR R1, R1, #0 ;arr[n] value

    ADD R0, R0, #1
    LDR R2, R5, #4 ;arr
    ADD R2, R2, R0 ;arr[n+1]
    
    STR R1, R2, #0

    LDR R0, R5, #-1 ;n
    ADD R0, R0, #-1 ;n--
    STR R0, R5, #-1 ; store n--
    BR W1

;;      arr[n + 1] = last_element;

ENDW1
    LDR R0, R5, #-1 ; n
    ADD R0, R0, #1 ; n + 1
    LDR R1, R5, #4 ;arr
    ADD R1, R1, R0 ;arr[n+1]
    
    LDR R2, R5, #0 ;last 

    STR R2, R1, #0 ;store last element to arr[n+1]



TEARDOWN
    LDR R4, R5, #-7 ; Restore R4
    LDR R3, R5, #-6 ; Restore R3
    LDR R2, R5, #-5 ; Restore R2
    LDR R1, R5, #-4 ; Restore R1
    LDR R0, R5, #-3 ; Restore R0
    ADD R6, R5, #0 ; Restore SP
    LDR R5, R6, #1 ; Restore FP
    LDR R7, R6, #2 ; Restore RA
    ADD R6, R6, #3 ; Pop ra,fp,lv1
    RET

; Constants
ARR_ADDR .FILL x4000
ARR_LEN  .FILL #5

;; Needed to Simulate Subroutine Call in Complx
STACK .fill xF000
.end

.orig x4000	;; Array : You can change these values for debugging!
    .fill 2
    .fill 3
    .fill 1
    .fill 1
    .fill 6
.end