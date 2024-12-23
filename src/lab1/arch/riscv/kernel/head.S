    .extern start_kernel
    .section .text.init
    .globl _start
_start:
    la sp, boot_stack_top

    la a0, _traps
    csrw stvec, a0

    li a0, 1 << 5
    csrs sie, a0
    
    rdtime a0
    li t0, 10000000
    add a0, a0, t0
    call sbi_set_timer

    li a0, 1 << 1
    csrs sstatus, a0

    j start_kernel

    .section .bss.stack
    .globl boot_stack
boot_stack:
    .space 4096

    .globl boot_stack_top
boot_stack_top: