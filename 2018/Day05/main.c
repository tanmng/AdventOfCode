/*
 * main.c
 *
 * My main work for day05 problem in AdventOfCode 2018
 */
#include <stdio.h>
#include <stdlib.h>

// Change this to input.h for the real input data or sample.h to use the sample
// data that AoC provided as coding example
#include "input.h"

const int MAX_STRING_LEN = 60000;

// Change the following 2 values to 0 (the number, not the char)
// respectively to use the program for part 1 of our problem
const int TARGET_CHAR_BEGIN = 0;
const int TARGET_CHAR_END = 0;

/* const int TARGET_CHAR_BEGIN = 'A'; */
/* const int TARGET_CHAR_END = 'Z'; */

/*
 * Return whether 2 characters eliminate one another
 *   if can eliminate, return 1
 */
int collapsible(char a, char b){
    if (a + 32 == b || b + 32 == a){
        return 1;
    }
    return 0;
}

int main(){
    char cur_char;
    char *stack = malloc(MAX_STRING_LEN * sizeof(char));
    int min_len = INPUT_STRING_LEN;

    for (char target_char = TARGET_CHAR_BEGIN; target_char < TARGET_CHAR_END + 1; target_char++) {
        // memset(stack, 0, MAX_STRING_LEN);
        int stack_current_size = 0;
        for(int i = 0; i < INPUT_STRING_LEN; i++){
            cur_char = INPUT_STRING[i];
            if (cur_char == target_char || cur_char == target_char + 32){
                // This is a character that we want to eliminate from the very
                // beginning - part 2 of the challen
                continue;
            }
            if (0 == stack_current_size){
                // Nothing in the stack - only push
                stack[stack_current_size++] = cur_char;
            } else {
                // Something is already in the stack
                if (1 == collapsible(stack[stack_current_size - 1], cur_char)){
                    // This can be eliminated
                    stack_current_size--;
                } else {
                    // Cannot eliminate - just push
                    stack[stack_current_size++] = cur_char;
                }
            }
            // printf("%s\n", stack);
        }
        // printf("Char %c, remaining len: %d\n", target_char, stack_current_size);
        // Make sure min_len is the answer value
        min_len = min_len > stack_current_size? stack_current_size : min_len;
    }

    printf("Answer: %d\n", min_len);

    free(stack);
    return 0;
}
