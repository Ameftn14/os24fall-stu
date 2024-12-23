#include "syscall.h"
#include "stdint.h"
#include "printk.h"
#include "proc.h"

extern struct task_struct *current;

uint64_t sys_write(unsigned int fd, const char* buf, size_t count) {
    if (fd == 1) {
        for (uint64_t i = 0; i < count; i++) {
            printk("%c", buf[i]);
        }
        return count;
    }
    else {
        printk("Unsupported file descriptor: %d\n", fd);
    }
    return -1;
}

uint64_t sys_getpid() {
    return current->pid;
}