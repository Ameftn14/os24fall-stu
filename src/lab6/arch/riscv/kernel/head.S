    .extern start_kernel
    .extern _traps
    .extern sbi_set_timer
    .section .text.init
    .globl _start

_start: 
    # Set stack pointer to the top of boot stack
    la sp, boot_stack_top

    # csrs sstatus, 1 << 1

    call setup_vm
    call relocate

    call mm_init
    call setup_vm_final
    call task_init

    # Load the trap handler address and set it in stvec register
    la a0, _traps
    csrw stvec, a0
    
    # Enable timer interrupt by setting STIE (bit 5) in the SIE register
    li a0, 1 << 5
    csrs sie, a0
    
    # Set the first timer interrupt
    rdtime a0
    li t0, 10000000
    add a0, a0, t0
    call sbi_set_timer
    
    # Enable S-mode interrupts by setting SIE (bit 1) in the sstatus register
    # csrs sstatus, 1 << 1
  
    # Jump to start_kernel to continue the main boot process
    j start_kernel

relocate:
    # set ra = ra + PA2VA_OFFSET
    # set sp = sp + PA2VA_OFFSET (If you have set the sp before)

    li t0, 0xffffffdf80000000 # PA2VA_OFFSET
    add ra, ra, t0
    add sp, sp, t0

    # la a0, 1f
    # add a0, a0, t0
    # csrw stvec, a0

    # need a fence to ensure the new translations are in use
    sfence.vma zero, zero

    # set satp with early_pgtbl

    la t0, early_pgtbl
    li t1, 8
    srli t0, t0, 12     # PPN 部分设置为页表物理地址右移 12 位
    slli t1, t1, 60     # mode 部分设置为 8
    or t0, t0, t1
    csrw satp, t0

    ret

# 1:
    # csrw sepc, ra
    # sret

    .section .bss.stack
    .globl boot_stack

boot_stack:
    .space 4096
    .globl boot_stack_top

boot_stack_top:
