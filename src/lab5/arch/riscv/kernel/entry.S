    .extern trap_handler
    .section .text.entry
    .align 2
    .globl _traps
    .extern dummy
    .globl __dummy
    .globl __switch_to

_traps:
    csrrw sp, sscratch, sp
    bne sp, x0, _not_recover
    csrrw sp, sscratch, sp

_not_recover:
    # Adjust stack pointer to allocate space for saving registers
    sd sp, -256(sp)
    addi sp, sp, -264

    # Save caller-saved registers
    sd ra, 0(sp)
    sd gp, 16(sp)
    sd tp, 24(sp)
    sd t0, 32(sp)
    sd t1, 40(sp)
    sd t2, 48(sp)
    sd s0, 56(sp)
    sd s1, 64(sp)
    sd a0, 72(sp)
    sd a1, 80(sp)
    sd a2, 88(sp)
    sd a3, 96(sp)
    sd a4, 104(sp)
    sd a5, 112(sp)
    sd a6, 120(sp)
    sd a7, 128(sp)
    sd s2, 136(sp)
    sd s3, 144(sp)
    sd s4, 152(sp)
    sd s5, 160(sp)
    sd s6, 168(sp)
    sd s7, 176(sp)
    sd s8, 184(sp)
    sd s9, 192(sp)
    sd s10, 200(sp)
    sd s11, 208(sp)
    sd t3, 216(sp)
    sd t4, 224(sp)
    sd t5, 232(sp)
    sd t6, 240(sp)
    csrr t0, sepc
    sd t0, 248(sp)
    csrr t0, sstatus
    sd t0, 256(sp)

    # Load trap cause and program counter into a0 and a1
    csrr a0, scause
    csrr a1, sepc
    mv a2, sp

    # Call the trap handler
    call trap_handler

    .globl __ret_from_fork
__ret_from_fork:

    # Restore caller-saved registers
    ld t0, 256(sp)
    csrw sstatus, t0
    ld t0, 248(sp)
    csrw sepc, t0

    ld ra, 0(sp)
    ld gp, 16(sp)
    ld tp, 24(sp)
    ld t0, 32(sp)
    ld t1, 40(sp)
    ld t2, 48(sp)
    ld s0, 56(sp)
    ld s1, 64(sp)
    ld a0, 72(sp)
    ld a1, 80(sp)
    ld a2, 88(sp)
    ld a3, 96(sp)
    ld a4, 104(sp)
    ld a5, 112(sp)
    ld a6, 120(sp)
    ld a7, 128(sp)
    ld s2, 136(sp)
    ld s3, 144(sp)
    ld s4, 152(sp)
    ld s5, 160(sp)
    ld s6, 168(sp)
    ld s7, 176(sp)
    ld s8, 184(sp)
    ld s9, 192(sp)
    ld s10, 200(sp)
    ld s11, 208(sp)
    ld t3, 216(sp)
    ld t4, 224(sp)
    ld t5, 232(sp)
    ld t6, 240(sp)
    # Adjust stack pointer back
    ld sp, 8(sp)

    csrrw sp, sscratch, sp
    bne sp, x0, _traps_sret
    csrrw sp, sscratch, sp

_traps_sret:
    # Return from trap
    sret

__dummy:
    # la a0, dummy
    # csrw sepc, a0
    csrrw sp, sscratch, sp
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

    csrr t1, sepc
    sd t1,144(a0)
    csrr t1, sstatus
    sd t1,152(a0)
    csrr t1, sscratch
    sd t1,160(a0)
    csrr t1, satp
    sd t1, 168(a0)

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

    ld t1,144(a1)
    csrw sepc, t1
    ld t1,152(a1)
    csrw sstatus, t1
    ld t1,160(a1)
    csrw sscratch, t1

    ld t1, 168(a1)
    csrw satp, t1
    sfence.vma zero, zero

    ret