#ifndef _SYSCALL_H_
#define _SYSCALL_H_

#include "printk.h"
#include "stdint.h"

#define SYS_WRITE   64
#define SYS_GETPID  172

uint64_t sys_write(unsigned int fd, const char* buf, size_t count);


uint64_t sys_getpid();

#endif