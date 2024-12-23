    .extern trap_handler
    .extern dummy
    .section .text.entry
    .align 2
    .globl _traps 
    .globl __dummy
    .globl __switch_to
_traps:
    addi sp, sp, -256
    sd ra, 0(sp)               # save return address
    sd sp, 8(sp)               # save stack pointer
    sd gp, 16(sp)              # save global pointer
    sd tp, 24(sp)              # save thread pointer
    sd t0, 32(sp)              # save temporary registers
    sd t1, 40(sp)
    sd t2, 48(sp)
    sd s0, 56(sp)              # save saved registers
    sd s1, 64(sp)
    sd a0, 72(sp)              # save argument registers
    sd a1, 80(sp)
    sd a2, 88(sp)
    sd a3, 96(sp)
    sd a4, 104(sp)
    sd a5, 112(sp)
    sd a6, 120(sp)
    sd a7, 128(sp)
    sd s2, 136(sp)             # save saved registers
    sd s3, 144(sp)
    sd s4, 152(sp)
    sd s5, 160(sp)
    sd s6, 168(sp)
    sd s7, 176(sp)
    sd s8, 184(sp)
    sd s9, 192(sp)
    sd s10, 200(sp)
    sd s11, 208(sp)
    sd t3, 216(sp)             # save temporary registers
    sd t4, 224(sp)
    sd t5, 232(sp)
    sd t6, 240(sp)
    csrr t0, sepc              # save sepc
    sd t0, 248(sp)

    csrr a0, scause
    csrr a1, sepc
    call trap_handler          # call trap handler

    ld t0, 248(sp)             # restore sepc
    csrw sepc, t0
    ld ra, 0(sp)               # restore return address
    ld sp, 8(sp)               # restore stack pointer
    ld gp, 16(sp)              # restore global pointer
    ld tp, 24(sp)              # restore thread pointer
    ld t0, 32(sp)              # restore temporary registers
    ld t1, 40(sp)
    ld t2, 48(sp)
    ld s0, 56(sp)              # restore saved registers
    ld s1, 64(sp)
    ld a0, 72(sp)              # restore argument registers
    ld a1, 80(sp)
    ld a2, 88(sp)
    ld a3, 96(sp)
    ld a4, 104(sp)
    ld a5, 112(sp)
    ld a6, 120(sp)
    ld a7, 128(sp)
    ld s2, 136(sp)             # restore saved registers
    ld s3, 144(sp)
    ld s4, 152(sp)
    ld s5, 160(sp)
    ld s6, 168(sp)
    ld s7, 176(sp)
    ld s8, 184(sp)
    ld s9, 192(sp)
    ld s10, 200(sp)
    ld s11, 208(sp)
    ld t3, 216(sp)             # restore temporary registers
    ld t4, 224(sp)
    ld t5, 232(sp)
    ld t6, 240(sp)
    addi sp, sp, 256           # restore stack pointer

    sret                       # return from trap
__dummy:
    la a0, dummy
    csrw sepc, a0

    sret

__switch_to:
    sd ra, 32(a0)
    sd sp, 40(a0)
    sd s0, 48(a0)
    sd s1, 56(a0)
    sd s2, 64(a0)
    sd s3, 72(a0)
    sd s4, 80(a0)
    sd s5, 88(a0)
    sd s6, 96(a0)
    sd s7, 104(a0)
    sd s8, 112(a0)
    sd s9, 120(a0)
    sd s10, 128(a0)
    sd s11, 136(a0)

    ld ra, 32(a1)
    ld sp, 40(a1)
    ld s0, 48(a1)
    ld s1, 56(a1)
    ld s2, 64(a1)
    ld s3, 72(a1)
    ld s4, 80(a1)
    ld s5, 88(a1)
    ld s6, 96(a1)
    ld s7, 104(a1)
    ld s8, 112(a1)
    ld s9, 120(a1)
    ld s10, 128(a1)
    ld s11, 136(a1)

    ret
