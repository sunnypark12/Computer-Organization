    /**
 * @file my_string.c
 * @author YOUR NAME HERE
 * @collaborators NAMES OF PEOPLE THAT YOU COLLABORATED WITH HERE
 * @brief Your implementation of these famous 3 string.h library functions!
 *
 * NOTE: NO ARRAY NOTATION IS ALLOWED IN THIS FILE
 *
 * @date 2023-03-xx
 */

#include <stddef.h>
#include "my_string.h"
/**
 * @brief Calculate the length of a string
 *
 * @param s a constant C string
 * @return size_t the number of characters in the passed in string
 */
size_t my_strlen(const char *s) {
    size_t len = 0;

    while (*s++) {
        len++;
    }
    return len;
}

/**
 * @brief Compare two strings
 *
 * @param s1 First string to be compared
 * @param s2 Second string to be compared
 * @param n First (at most) n bytes to be compared
 * @return int "less than, equal to, or greater than zero if s1 (or the first n
 * bytes thereof) is found, respectively, to be less than, to match, or be
 * greater than s2"
 */
int my_strncmp(const char *s1, const char *s2, size_t n) {
    size_t count = 0;

    while (*s1 && *s2 && *s1 == *s2 && count < n) {
        count++;
        s1++;
        s2++;
    }

    return (*s1 - *s2);
}

/**
 * @brief Copy a string
 *
 * @param dest The destination buffer
 * @param src The source to copy from
 * @param n maximum number of bytes to copy
 * @return char* a pointer same as dest
 */
char *my_strncpy(char *dest, const char *src, size_t n)
{
    char* pointer = dest;
    size_t k = 0;
    while (k < n) {
        if (*src == '\0') {
            break;
        }

        *pointer = *src;
        pointer++;
        src++;
        k++;
    }

    while (k < n) {
        *pointer = '\0';
        pointer++;
        k++;
    }
    
    return dest;
}

/**
 * @brief Concatenates two strings and stores the result
 * in the destination string
 *
 * @param dest The destination string
 * @param src The source string
 * @param n The maximum number of bytes from src to concatenate
 * @return char* a pointer same as dest
 */
char *my_strncat(char *dest, const char *src, size_t n) {
    // pointer = dest
    char *start = dest;
    
    // pointer = end of the dest
    while (*dest != '\0') {
        dest++;
    }

    // src = dest
    while (*src != '\0' && n-- > 0) {
        *dest++ = *src++;
    }
    
    // dest = null
    *dest = '\0';
    
    return start;
}

/**
 * @brief Copies the character c into the first n
 * bytes of memory starting at *str
 *
 * @param str The pointer to the block of memory to fill
 * @param c The character to fill in memory
 * @param n The number of bytes of memory to fill
 * @return char* a pointer same as str
 */
void *my_memset(void *str, int c, size_t n) {
    // c --> char
    char charC = (char)c; 
    // str = pointer
    char *pointer = str;
    
    // str = c val
    for (size_t k = 0; k < n; k++) {
        *pointer++ = charC;
    }
    return str;
}

/**
 * @brief Finds the first instance of c in str
 * and removes it from str in place
 *
 * @param str The pointer to the string
 * @param c The character we are looking to delete
 */
void remove_first_instance(char *str, char c){
    char *pointer = str;
    while (*pointer != '\0') {
        if (*pointer == c) {
            char *newPointer = pointer + 1;
            while (*newPointer != '\0') {
                *pointer = *newPointer;
                pointer += 1;
                newPointer += 1;
            }
            *pointer = '\0';
            return;
        }
        pointer++;
    }
}

/**
 * @brief Finds the first instance of c in str
 * and replaces it with the contents of replaceStr
 *
 * @param str The pointer to the string
 * @param c The character we are looking to delete
 * @param replaceStr The pointer to the string we are replacing c with
 */
void replace_character_with_string(char *str, char c, char *replaceStr) {
    char *pointer = str;

    if (*replaceStr == '\0') {
        remove_first_instance(str, c);
        return;
    }


    while (*pointer != '\0' && *pointer != c) {
        pointer++;
    }

    if (*pointer == c) {
        int replaceStrLen = my_strlen(replaceStr);
        int strLen = my_strlen(str);
        char *remPointer = str + replaceStrLen + strLen - 1;
        while (*remPointer != '\0') {
            remPointer++;
        }
        while (remPointer >= pointer) {
            *(remPointer + replaceStrLen - 1) = *remPointer;
            remPointer--;
        }
        remPointer = replaceStr;

        while (*remPointer != '\0') {
            *pointer = *remPointer;
            pointer++;
            remPointer++;
        }

        *(str + strLen + replaceStrLen - 1) = '\0';
    }
}






/**
 * @brief Remove the first character of str (ie. str[0]) IN ONE LINE OF CODE.
 * No loops allowed. Assume non-empty string
 * @param str A pointer to a pointer of the string
 */
void remove_first_character(char **str) {
    *str += 1;
}
