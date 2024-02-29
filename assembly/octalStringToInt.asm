;;=============================================================
;; CS 2110 - Spring 2023
;; Homework 5 - octalStringToInt
;;=============================================================
;; Name: Sunho Park
;;=============================================================

;;  Pseudocode (see PDF for explanation)
;;  Pseudocode values are based on the labels' default values.
;;
;;  String octalString = "2110";
;;  int length = 4;
;;  int value = 0;
;;  int i = 0;
;;  while (i < length) {
;;      int leftShifts = 3;
;;      while (leftShifts > 0) {
;;          value += value;
;;          leftShifts--;
;;      }
;;      int digit = octalString[i] - 48;
;;      value += digit;
;;      i++;
;;  }
;;  mem[mem[RESULTADDR]] = value;

.orig x3000

    ; initialize variables
    LD      R0, OCTALSTRING  ; loading address of the octal string
    LD      R1, LENGTH       ; loading length of the string
    AND     R2, R2, #0       ; initialize value to 0
    AND     R3, R3, #0       ; initialize i to 0
    LD      R7, ASCII        ; load ASCII value to R7

W1  ; loop while i < length
    NOT R1, R1          ; i - length 
    ADD R1, R1, #1
    ADD R4, R3, R1      ; i - length < 0

    BRzp     W4         ; exit the loop if i >= length
    LD      R5, #3      ; leftshift value 
    
    NOT R1, R1
    ADD R1, R1, #1      ; restore length to + length
    
    W2 ;inner while loop
        ADD R5, R5, #0  ; leftshift > 0 
        BRnz W3
        ADD R2, R2, R2  ; leftshift three times
        ADD R2, R2, R2
        ADD R2, R2, R2 
        BR W3           ; Continue

    W3
        ; get the next digit and add it to value
        ADD R6, R0, R3  ; OCTALSTRING + i --> index ; address
        LDR R6, R6, #0  ; value of OctalString in R6
        ADD R6, R6, R7  ; Value - 48 = digit
        ADD R2, R2, R6  ; value = digit 
        ADD R3, R3, #1  ; i++; 
        BR   W1

W4 ; Out of W1
    STI     R2, RESULTADDR ; store value at RESULTADDR
HALT
    
;; Do not change these values! 
;; Notice we wrote some values in hex this time. Maybe those values should be treated as addresses?
ASCII           .fill -48
OCTALSTRING     .fill x5000
LENGTH          .fill 4
RESULTADDR      .fill x4000
.end

.orig x5000                    ;;  Don't change the .orig statement
    .stringz "2110"            ;;  You can change this string for debugging!
.end
