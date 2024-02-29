;;=============================================================
;; CS 2110 - Spring 2023
;; Homework 5 - modulus
;;=============================================================
;; Name: Sunho Park
;;=============================================================

;;  Pseudocode (see PDF for explanation)
;;  Pseudocode values are based on the labels' default values.
;;
;;  int x = 17;
;;  int mod = 5;
;;  while (x >= mod) {
;;      x -= mod;
;;  }
;;  mem[ANSWER] = x;


.orig x3000
;  x is R0, mod is R1, ANSWER is R2
;  int x = 17;

    ; initialize variables
    LD      R0, X
    LD      R1, MOD
    LEA     R2, ANSWER

W1  ;loop while x >= mod
    NOT     R1, R1
    ADD     R1, R1, #1
    ADD     R3, R0, R1 ; x - mod >= 0
    BRn     W2

    ADD     R0, R0, R1  ; x - mod
    NOT     R1, R1
    ADD     R1, R1, #1  ; + mod
    BR      W1 ;Iterate W1

W2  ;out of while loop
    ST      R0, ANSWER ;store ANSWER in R0
    
HALT

    ;; Feel free to change the below values for debugging. We will vary these values when testing your code.
    X      .fill 17
    MOD    .fill 5     
    ANSWER .blkw 1
.end

