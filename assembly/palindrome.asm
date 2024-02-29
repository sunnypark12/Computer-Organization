;;=============================================================
;; CS 2110 - Spring 2023
;; Homework 5 - palindrome
;;=============================================================
;; Name: Sunho Park
;;=============================================================

;;  NOTE: Let's decide to represent "true" as a 1 in memory and "false" as a 0 in memory.
;;
;;  Pseudocode (see PDF for explanation)
;;  Pseudocode values are based on the labels' default values.
;;
;;  String str = "aibohphobia";
;;  boolean isPalindrome = true
;;  int length = 0;
;;  while (str[length] != '\0') {
;;		length++;
;;	}
;; 	
;;	int left = 0
;;  int right = length - 1
;;  while(left < right) {
;;		if (str[left] != str[right]) {
;;			isPalindrome = false;
;;			break;
;;		}
;;		left++;
;;		right--;
;;	}
;;	mem[mem[ANSWERADDR]] = isPalindrome;

.orig x3000

	;str is R1, isPalindrome is R2, length is R0

	;String str = "aibohphobia";
	LD R1, STRING 

	;boolean isPalindrome = true;
	LD R2, ANSWERADDR ;load data from isPalidrome
	AND R2, R2, #1 ; set to true

	;int length = 0;
	AND R0, R0, #0 ; R0 = 0

	W1
		ADD R3, R1, R0 ; address of str[length] --> R3
		LDR R3, R3, #0 ; R3 = str[length]
		BRz W2
		ADD R0, R0, #1 ;length++;
		BRnzp W1
	W2
	AND R4, R4, #0 ; left 
	ADD R5, R0, #-1 ; length - 1 = right

	W3 
		NOT R5, R5
		ADD R5, R5, #1
		ADD R4, R4, R5 ; left - right 
		BRzp W4

		;restore right 
		NOT R5, R5
		ADD R5, R5, #1

		;restore left
		ADD R4, R4, R5

		ADD R6, R1, R4
		LDR R6, R6, #0 ;str[left]

		ADD R7, R1, R5
		LDR R7, R7, #0 ;str[right]

		NOT R7, R7
		ADD R7, R7, #1 ; -str[right]
		ADD R6, R6, R7 ;str[left] - str[right]
		BRz ELSE 

		AND R2, R2, #0
		ADD R2, R2, #0
		BRnzp W4

		ELSE
			ADD R4, R4, #1 ;left++
			ADD R5, R5, #-1 ;right—-
			BR W3
	W4
	STI R2, ANSWERADDR

HALT

;; Do not change these values!
STRING	.fill x4004
ANSWERADDR 	.fill x5005
.end

;; Do not change any of the .orig lines!
.orig x4004				   
	.stringz "aibohphobia" ;; Feel free to change this string for debugging.
.end

.orig x5005
	ANSWER  .blkw 1
.end
