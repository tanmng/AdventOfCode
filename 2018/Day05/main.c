/*
 * main.c
 *
 * My main work for day05 problem in AdventOfCode 2018
 */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Change this to input.h for the real input data or sample.h to use the sample
// data that AoC provided as coding example
#include "input.h"

const int MAX_STRING_LEN = 9240;

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
    return abs(a - b) == 32;
}

int main(){
    char cur_char;
    char stack[MAX_STRING_LEN];
    stack[0] = ' ';
    int min_len = INPUT_STRING_LEN;
    clock_t tv1, tv2;
    tv1=clock();
    int stack_current_size = 1;
    for(int i = 0; i < INPUT_STRING_LEN; i++){
        cur_char = INPUT_STRING[i];
        // Something is already in the stack
        if (1 == collapsible(stack[stack_current_size - 1], cur_char)){
            // This can be eliminated
            stack_current_size--;
        } else {
            // Cannot eliminate - just push
            stack[stack_current_size++] = cur_char;
        }
        // printf("%s\n", stack);
    }

    printf("Answer: %d\n", stack_current_size - 1);
    tv2=clock();
    printf("Execution time: %f seconds\n", (double) (tv2 - tv1) / CLOCKS_PER_SEC);

    return 0;
}
