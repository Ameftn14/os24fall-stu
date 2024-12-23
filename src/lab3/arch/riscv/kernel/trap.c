#include "clock.h"
#include "printk.h"
#include "proc.h"

void trap_handler(uint64_t scause, uint64_t sepc) {
    // Check if the interrupt is a timer interrupt
    if ((scause >> 63) && (scause << 1 >> 1) == 5) {
        printk("[S] Supervisor Mode Timer Interrupt\n"); // Print the timer interrupt message
        clock_set_next_event(); // Set the next timer event
        do_timer();
        return; // Exit the handler
    }
}