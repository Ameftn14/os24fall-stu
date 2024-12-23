#include "clock.h"
#include "printk.h"
#include "proc.h"
#include "syscall.h"

struct pt_regs
{
    uint64_t regs[31];
    uint64_t sepc;
    uint64_t sstatus;
};

void trap_handler(uint64_t scause, uint64_t sepc, struct pt_regs *regs)
{
    // Check if the interrupt is a timer interrupt
    if ((scause >> 63) && (scause << 1 >> 1) == 5)
    {
        // printk("[S] Supervisor Mode Timer Interrupt\n"); // Print the timer interrupt message
        clock_set_next_event(); // Set the next timer event
        do_timer();
        return; // Exit the handler
    }
    else if (scause >> 3 == 1)
    {
        if (regs->regs[16] == SYS_WRITE)
            regs->regs[9] = sys_write((unsigned int)regs->regs[9], (const char *)regs->regs[10], (uint64_t)regs->regs[11]);
        else if (regs->regs[16] == SYS_GETPID)
            regs->regs[9] = sys_getpid();
        else
            printk("Unsupported exception: scause: %lx, sepc: %lx\n", scause, sepc);
        regs->sepc += 4;
    }
    else
    {
        // printk("Unsupported exception: scause: %lx, sepc: %lx\n", scause, sepc);
    }
}