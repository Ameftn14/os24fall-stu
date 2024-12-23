#include "stdint.h"
#include "sbi.h"

uint64_t TIMECLOCK = 3000000; // Define time clock, representing the number of cycles in 1 second

// Function to get the current time cycles
uint64_t get_cycles() {
    uint64_t cycles;
    asm volatile ("rdtime %0" : "=r"(cycles): : "memory"); 
    return cycles; // Return the current time cycles
}

// Function to set the next timer interrupt event
void clock_set_next_event() {
    uint64_t next = get_cycles() + TIMECLOCK;
    sbi_set_timer(next); // Call SBI function to set the timer
}
