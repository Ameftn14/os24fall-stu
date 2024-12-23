#ifndef _SYSCALL_H_
#define _SYSCALL_H_

#include "printk.h"
#include "stdint.h"

#define SYS_WRITE 64
#define SYS_GETPID 172
#define SYS_CLONE 220

struct pt_regs
{
    uint64_t regs[31];
    uint64_t sepc;
    uint64_t sstatus;
};

uint64_t sys_write(unsigned int fd, const char *buf, size_t count);

uint64_t sys_getpid();

uint64_t do_fork(struct pt_regs *regs);

#endif