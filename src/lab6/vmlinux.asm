
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

ffffffe000200000 <_skernel>:
    .section .text.init
    .globl _start

_start: 
    # Set stack pointer to the top of boot stack
    la sp, boot_stack_top
ffffffe000200000:	00009117          	auipc	sp,0x9
ffffffe000200004:	00010113          	mv	sp,sp

    # csrs sstatus, 1 << 1

    call setup_vm
ffffffe000200008:	009020ef          	jal	ffffffe000202810 <setup_vm>
    call relocate
ffffffe00020000c:	03c000ef          	jal	ffffffe000200048 <relocate>

    call mm_init
ffffffe000200010:	24d000ef          	jal	ffffffe000200a5c <mm_init>
    call setup_vm_final
ffffffe000200014:	2c8020ef          	jal	ffffffe0002022dc <setup_vm_final>
    call task_init
ffffffe000200018:	279000ef          	jal	ffffffe000200a90 <task_init>

    # Load the trap handler address and set it in stvec register
    la a0, _traps
ffffffe00020001c:	00000517          	auipc	a0,0x0
ffffffe000200020:	06050513          	addi	a0,a0,96 # ffffffe00020007c <_traps>
    csrw stvec, a0
ffffffe000200024:	10551073          	csrw	stvec,a0
    
    # Enable timer interrupt by setting STIE (bit 5) in the SIE register
    li a0, 1 << 5
ffffffe000200028:	02000513          	li	a0,32
    csrs sie, a0
ffffffe00020002c:	10452073          	csrs	sie,a0
    
    # Set the first timer interrupt
    rdtime a0
ffffffe000200030:	c0102573          	rdtime	a0
    li t0, 10000000
ffffffe000200034:	009892b7          	lui	t0,0x989
ffffffe000200038:	6802829b          	addiw	t0,t0,1664 # 989680 <OPENSBI_SIZE+0x789680>
    add a0, a0, t0
ffffffe00020003c:	00550533          	add	a0,a0,t0
    call sbi_set_timer
ffffffe000200040:	7f8010ef          	jal	ffffffe000201838 <sbi_set_timer>
    
    # Enable S-mode interrupts by setting SIE (bit 1) in the sstatus register
    # csrs sstatus, 1 << 1
  
    # Jump to start_kernel to continue the main boot process
    j start_kernel
ffffffe000200044:	1e90206f          	j	ffffffe000202a2c <start_kernel>

ffffffe000200048 <relocate>:

relocate:
    # set ra = ra + PA2VA_OFFSET
    # set sp = sp + PA2VA_OFFSET (If you have set the sp before)

    li t0, 0xffffffdf80000000 # PA2VA_OFFSET
ffffffe000200048:	fbf0029b          	addiw	t0,zero,-65
ffffffe00020004c:	01f29293          	slli	t0,t0,0x1f
    add ra, ra, t0
ffffffe000200050:	005080b3          	add	ra,ra,t0
    add sp, sp, t0
ffffffe000200054:	00510133          	add	sp,sp,t0
    # la a0, 1f
    # add a0, a0, t0
    # csrw stvec, a0

    # need a fence to ensure the new translations are in use
    sfence.vma zero, zero
ffffffe000200058:	12000073          	sfence.vma

    # set satp with early_pgtbl

    la t0, early_pgtbl
ffffffe00020005c:	0000a297          	auipc	t0,0xa
ffffffe000200060:	fa428293          	addi	t0,t0,-92 # ffffffe00020a000 <early_pgtbl>
    li t1, 8
ffffffe000200064:	00800313          	li	t1,8
    srli t0, t0, 12     # PPN 部分设置为页表物理地址右移 12 位
ffffffe000200068:	00c2d293          	srli	t0,t0,0xc
    slli t1, t1, 60     # mode 部分设置为 8
ffffffe00020006c:	03c31313          	slli	t1,t1,0x3c
    or t0, t0, t1
ffffffe000200070:	0062e2b3          	or	t0,t0,t1
    csrw satp, t0
ffffffe000200074:	18029073          	csrw	satp,t0

    ret
ffffffe000200078:	00008067          	ret

ffffffe00020007c <_traps>:
    .extern dummy
    .globl __dummy
    .globl __switch_to

_traps:
    csrrw sp, sscratch, sp
ffffffe00020007c:	14011173          	csrrw	sp,sscratch,sp
    bne sp, x0, _not_recover
ffffffe000200080:	00011463          	bnez	sp,ffffffe000200088 <_not_recover>
    csrrw sp, sscratch, sp
ffffffe000200084:	14011173          	csrrw	sp,sscratch,sp

ffffffe000200088 <_not_recover>:

_not_recover:
    # Adjust stack pointer to allocate space for saving registers
    sd sp, -256(sp)
ffffffe000200088:	f0213023          	sd	sp,-256(sp) # ffffffe000208f00 <_sbss+0xf00>
    addi sp, sp, -264
ffffffe00020008c:	ef810113          	addi	sp,sp,-264

    # Save caller-saved registers
    sd ra, 0(sp)
ffffffe000200090:	00113023          	sd	ra,0(sp)
    sd gp, 16(sp)
ffffffe000200094:	00313823          	sd	gp,16(sp)
    sd tp, 24(sp)
ffffffe000200098:	00413c23          	sd	tp,24(sp)
    sd t0, 32(sp)
ffffffe00020009c:	02513023          	sd	t0,32(sp)
    sd t1, 40(sp)
ffffffe0002000a0:	02613423          	sd	t1,40(sp)
    sd t2, 48(sp)
ffffffe0002000a4:	02713823          	sd	t2,48(sp)
    sd s0, 56(sp)
ffffffe0002000a8:	02813c23          	sd	s0,56(sp)
    sd s1, 64(sp)
ffffffe0002000ac:	04913023          	sd	s1,64(sp)
    sd a0, 72(sp)
ffffffe0002000b0:	04a13423          	sd	a0,72(sp)
    sd a1, 80(sp)
ffffffe0002000b4:	04b13823          	sd	a1,80(sp)
    sd a2, 88(sp)
ffffffe0002000b8:	04c13c23          	sd	a2,88(sp)
    sd a3, 96(sp)
ffffffe0002000bc:	06d13023          	sd	a3,96(sp)
    sd a4, 104(sp)
ffffffe0002000c0:	06e13423          	sd	a4,104(sp)
    sd a5, 112(sp)
ffffffe0002000c4:	06f13823          	sd	a5,112(sp)
    sd a6, 120(sp)
ffffffe0002000c8:	07013c23          	sd	a6,120(sp)
    sd a7, 128(sp)
ffffffe0002000cc:	09113023          	sd	a7,128(sp)
    sd s2, 136(sp)
ffffffe0002000d0:	09213423          	sd	s2,136(sp)
    sd s3, 144(sp)
ffffffe0002000d4:	09313823          	sd	s3,144(sp)
    sd s4, 152(sp)
ffffffe0002000d8:	09413c23          	sd	s4,152(sp)
    sd s5, 160(sp)
ffffffe0002000dc:	0b513023          	sd	s5,160(sp)
    sd s6, 168(sp)
ffffffe0002000e0:	0b613423          	sd	s6,168(sp)
    sd s7, 176(sp)
ffffffe0002000e4:	0b713823          	sd	s7,176(sp)
    sd s8, 184(sp)
ffffffe0002000e8:	0b813c23          	sd	s8,184(sp)
    sd s9, 192(sp)
ffffffe0002000ec:	0d913023          	sd	s9,192(sp)
    sd s10, 200(sp)
ffffffe0002000f0:	0da13423          	sd	s10,200(sp)
    sd s11, 208(sp)
ffffffe0002000f4:	0db13823          	sd	s11,208(sp)
    sd t3, 216(sp)
ffffffe0002000f8:	0dc13c23          	sd	t3,216(sp)
    sd t4, 224(sp)
ffffffe0002000fc:	0fd13023          	sd	t4,224(sp)
    sd t5, 232(sp)
ffffffe000200100:	0fe13423          	sd	t5,232(sp)
    sd t6, 240(sp)
ffffffe000200104:	0ff13823          	sd	t6,240(sp)
    csrr t0, sepc
ffffffe000200108:	141022f3          	csrr	t0,sepc
    sd t0, 248(sp)
ffffffe00020010c:	0e513c23          	sd	t0,248(sp)
    csrr t0, sstatus
ffffffe000200110:	100022f3          	csrr	t0,sstatus
    sd t0, 256(sp)
ffffffe000200114:	10513023          	sd	t0,256(sp)

    # Load trap cause and program counter into a0 and a1
    csrr a0, scause
ffffffe000200118:	14202573          	csrr	a0,scause
    csrr a1, sepc
ffffffe00020011c:	141025f3          	csrr	a1,sepc
    mv a2, sp
ffffffe000200120:	00010613          	mv	a2,sp

    # Call the trap handler
    call trap_handler
ffffffe000200124:	014020ef          	jal	ffffffe000202138 <trap_handler>

ffffffe000200128 <__ret_from_fork>:

    .globl __ret_from_fork
__ret_from_fork:

    # Restore caller-saved registers
    ld t0, 256(sp)
ffffffe000200128:	10013283          	ld	t0,256(sp)
    csrw sstatus, t0
ffffffe00020012c:	10029073          	csrw	sstatus,t0
    ld t0, 248(sp)
ffffffe000200130:	0f813283          	ld	t0,248(sp)
    csrw sepc, t0
ffffffe000200134:	14129073          	csrw	sepc,t0

    ld ra, 0(sp)
ffffffe000200138:	00013083          	ld	ra,0(sp)
    ld gp, 16(sp)
ffffffe00020013c:	01013183          	ld	gp,16(sp)
    ld tp, 24(sp)
ffffffe000200140:	01813203          	ld	tp,24(sp)
    ld t0, 32(sp)
ffffffe000200144:	02013283          	ld	t0,32(sp)
    ld t1, 40(sp)
ffffffe000200148:	02813303          	ld	t1,40(sp)
    ld t2, 48(sp)
ffffffe00020014c:	03013383          	ld	t2,48(sp)
    ld s0, 56(sp)
ffffffe000200150:	03813403          	ld	s0,56(sp)
    ld s1, 64(sp)
ffffffe000200154:	04013483          	ld	s1,64(sp)
    ld a0, 72(sp)
ffffffe000200158:	04813503          	ld	a0,72(sp)
    ld a1, 80(sp)
ffffffe00020015c:	05013583          	ld	a1,80(sp)
    ld a2, 88(sp)
ffffffe000200160:	05813603          	ld	a2,88(sp)
    ld a3, 96(sp)
ffffffe000200164:	06013683          	ld	a3,96(sp)
    ld a4, 104(sp)
ffffffe000200168:	06813703          	ld	a4,104(sp)
    ld a5, 112(sp)
ffffffe00020016c:	07013783          	ld	a5,112(sp)
    ld a6, 120(sp)
ffffffe000200170:	07813803          	ld	a6,120(sp)
    ld a7, 128(sp)
ffffffe000200174:	08013883          	ld	a7,128(sp)
    ld s2, 136(sp)
ffffffe000200178:	08813903          	ld	s2,136(sp)
    ld s3, 144(sp)
ffffffe00020017c:	09013983          	ld	s3,144(sp)
    ld s4, 152(sp)
ffffffe000200180:	09813a03          	ld	s4,152(sp)
    ld s5, 160(sp)
ffffffe000200184:	0a013a83          	ld	s5,160(sp)
    ld s6, 168(sp)
ffffffe000200188:	0a813b03          	ld	s6,168(sp)
    ld s7, 176(sp)
ffffffe00020018c:	0b013b83          	ld	s7,176(sp)
    ld s8, 184(sp)
ffffffe000200190:	0b813c03          	ld	s8,184(sp)
    ld s9, 192(sp)
ffffffe000200194:	0c013c83          	ld	s9,192(sp)
    ld s10, 200(sp)
ffffffe000200198:	0c813d03          	ld	s10,200(sp)
    ld s11, 208(sp)
ffffffe00020019c:	0d013d83          	ld	s11,208(sp)
    ld t3, 216(sp)
ffffffe0002001a0:	0d813e03          	ld	t3,216(sp)
    ld t4, 224(sp)
ffffffe0002001a4:	0e013e83          	ld	t4,224(sp)
    ld t5, 232(sp)
ffffffe0002001a8:	0e813f03          	ld	t5,232(sp)
    ld t6, 240(sp)
ffffffe0002001ac:	0f013f83          	ld	t6,240(sp)
    # Adjust stack pointer back
    ld sp, 8(sp)
ffffffe0002001b0:	00813103          	ld	sp,8(sp)

    csrrw sp, sscratch, sp
ffffffe0002001b4:	14011173          	csrrw	sp,sscratch,sp
    bne sp, x0, _traps_sret
ffffffe0002001b8:	00011463          	bnez	sp,ffffffe0002001c0 <_traps_sret>
    csrrw sp, sscratch, sp
ffffffe0002001bc:	14011173          	csrrw	sp,sscratch,sp

ffffffe0002001c0 <_traps_sret>:

_traps_sret:
    # Return from trap
    sret
ffffffe0002001c0:	10200073          	sret

ffffffe0002001c4 <__dummy>:

__dummy:
    # la a0, dummy
    # csrw sepc, a0
    csrrw sp, sscratch, sp
ffffffe0002001c4:	14011173          	csrrw	sp,sscratch,sp
    sret
ffffffe0002001c8:	10200073          	sret

ffffffe0002001cc <__switch_to>:

__switch_to:
    sd ra, 32(a0)
ffffffe0002001cc:	02153023          	sd	ra,32(a0)
    sd sp, 40(a0)
ffffffe0002001d0:	02253423          	sd	sp,40(a0)
    sd s0, 48(a0)
ffffffe0002001d4:	02853823          	sd	s0,48(a0)
    sd s1, 56(a0)
ffffffe0002001d8:	02953c23          	sd	s1,56(a0)
    sd s2, 64(a0)
ffffffe0002001dc:	05253023          	sd	s2,64(a0)
    sd s3, 72(a0)
ffffffe0002001e0:	05353423          	sd	s3,72(a0)
    sd s4, 80(a0)
ffffffe0002001e4:	05453823          	sd	s4,80(a0)
    sd s5, 88(a0)
ffffffe0002001e8:	05553c23          	sd	s5,88(a0)
    sd s6, 96(a0)
ffffffe0002001ec:	07653023          	sd	s6,96(a0)
    sd s7, 104(a0)
ffffffe0002001f0:	07753423          	sd	s7,104(a0)
    sd s8, 112(a0)
ffffffe0002001f4:	07853823          	sd	s8,112(a0)
    sd s9, 120(a0)
ffffffe0002001f8:	07953c23          	sd	s9,120(a0)
    sd s10, 128(a0)
ffffffe0002001fc:	09a53023          	sd	s10,128(a0)
    sd s11, 136(a0)
ffffffe000200200:	09b53423          	sd	s11,136(a0)

    csrr t1, sepc
ffffffe000200204:	14102373          	csrr	t1,sepc
    sd t1,144(a0)
ffffffe000200208:	08653823          	sd	t1,144(a0)
    csrr t1, sstatus
ffffffe00020020c:	10002373          	csrr	t1,sstatus
    sd t1,152(a0)
ffffffe000200210:	08653c23          	sd	t1,152(a0)
    csrr t1, sscratch
ffffffe000200214:	14002373          	csrr	t1,sscratch
    sd t1,160(a0)
ffffffe000200218:	0a653023          	sd	t1,160(a0)
    csrr t1, satp
ffffffe00020021c:	18002373          	csrr	t1,satp
    sd t1, 168(a0)
ffffffe000200220:	0a653423          	sd	t1,168(a0)

    ld ra, 32(a1)
ffffffe000200224:	0205b083          	ld	ra,32(a1)
    ld sp, 40(a1)
ffffffe000200228:	0285b103          	ld	sp,40(a1)
    ld s0, 48(a1)
ffffffe00020022c:	0305b403          	ld	s0,48(a1)
    ld s1, 56(a1)
ffffffe000200230:	0385b483          	ld	s1,56(a1)
    ld s2, 64(a1)
ffffffe000200234:	0405b903          	ld	s2,64(a1)
    ld s3, 72(a1)
ffffffe000200238:	0485b983          	ld	s3,72(a1)
    ld s4, 80(a1)
ffffffe00020023c:	0505ba03          	ld	s4,80(a1)
    ld s5, 88(a1)
ffffffe000200240:	0585ba83          	ld	s5,88(a1)
    ld s6, 96(a1)
ffffffe000200244:	0605bb03          	ld	s6,96(a1)
    ld s7, 104(a1)
ffffffe000200248:	0685bb83          	ld	s7,104(a1)
    ld s8, 112(a1)
ffffffe00020024c:	0705bc03          	ld	s8,112(a1)
    ld s9, 120(a1)
ffffffe000200250:	0785bc83          	ld	s9,120(a1)
    ld s10, 128(a1)
ffffffe000200254:	0805bd03          	ld	s10,128(a1)
    ld s11, 136(a1)
ffffffe000200258:	0885bd83          	ld	s11,136(a1)

    ld t1,144(a1)
ffffffe00020025c:	0905b303          	ld	t1,144(a1)
    csrw sepc, t1
ffffffe000200260:	14131073          	csrw	sepc,t1
    ld t1,152(a1)
ffffffe000200264:	0985b303          	ld	t1,152(a1)
    csrw sstatus, t1
ffffffe000200268:	10031073          	csrw	sstatus,t1
    ld t1,160(a1)
ffffffe00020026c:	0a05b303          	ld	t1,160(a1)
    csrw sscratch, t1
ffffffe000200270:	14031073          	csrw	sscratch,t1

    ld t1, 168(a1)
ffffffe000200274:	0a85b303          	ld	t1,168(a1)
    csrw satp, t1
ffffffe000200278:	18031073          	csrw	satp,t1
    sfence.vma zero, zero
ffffffe00020027c:	12000073          	sfence.vma

ffffffe000200280:	00008067          	ret

ffffffe000200284 <get_cycles>:
#include "sbi.h"

uint64_t TIMECLOCK = 10000000; // Define time clock, representing the number of cycles in 1 second

// Function to get the current time cycles
uint64_t get_cycles() {
ffffffe000200284:	fe010113          	addi	sp,sp,-32
ffffffe000200288:	00813c23          	sd	s0,24(sp)
ffffffe00020028c:	02010413          	addi	s0,sp,32
    uint64_t cycles;
    asm volatile ("rdtime %0" : "=r"(cycles): : "memory"); 
ffffffe000200290:	c01027f3          	rdtime	a5
ffffffe000200294:	fef43423          	sd	a5,-24(s0)
    return cycles; // Return the current time cycles
ffffffe000200298:	fe843783          	ld	a5,-24(s0)
}
ffffffe00020029c:	00078513          	mv	a0,a5
ffffffe0002002a0:	01813403          	ld	s0,24(sp)
ffffffe0002002a4:	02010113          	addi	sp,sp,32
ffffffe0002002a8:	00008067          	ret

ffffffe0002002ac <clock_set_next_event>:

// Function to set the next timer interrupt event
void clock_set_next_event() {
ffffffe0002002ac:	fe010113          	addi	sp,sp,-32
ffffffe0002002b0:	00113c23          	sd	ra,24(sp)
ffffffe0002002b4:	00813823          	sd	s0,16(sp)
ffffffe0002002b8:	02010413          	addi	s0,sp,32
    uint64_t next = get_cycles() + TIMECLOCK;
ffffffe0002002bc:	fc9ff0ef          	jal	ffffffe000200284 <get_cycles>
ffffffe0002002c0:	00050713          	mv	a4,a0
ffffffe0002002c4:	00005797          	auipc	a5,0x5
ffffffe0002002c8:	d3c78793          	addi	a5,a5,-708 # ffffffe000205000 <TIMECLOCK>
ffffffe0002002cc:	0007b783          	ld	a5,0(a5)
ffffffe0002002d0:	00f707b3          	add	a5,a4,a5
ffffffe0002002d4:	fef43423          	sd	a5,-24(s0)
    sbi_set_timer(next); // Call SBI function to set the timer
ffffffe0002002d8:	fe843503          	ld	a0,-24(s0)
ffffffe0002002dc:	55c010ef          	jal	ffffffe000201838 <sbi_set_timer>
}
ffffffe0002002e0:	00000013          	nop
ffffffe0002002e4:	01813083          	ld	ra,24(sp)
ffffffe0002002e8:	01013403          	ld	s0,16(sp)
ffffffe0002002ec:	02010113          	addi	sp,sp,32
ffffffe0002002f0:	00008067          	ret

ffffffe0002002f4 <fixsize>:

void *free_page_start = &_ekernel;
struct buddy buddy;

static uint64_t fixsize(uint64_t size)
{
ffffffe0002002f4:	fe010113          	addi	sp,sp,-32
ffffffe0002002f8:	00813c23          	sd	s0,24(sp)
ffffffe0002002fc:	02010413          	addi	s0,sp,32
ffffffe000200300:	fea43423          	sd	a0,-24(s0)
    size--;
ffffffe000200304:	fe843783          	ld	a5,-24(s0)
ffffffe000200308:	fff78793          	addi	a5,a5,-1
ffffffe00020030c:	fef43423          	sd	a5,-24(s0)
    size |= size >> 1;
ffffffe000200310:	fe843783          	ld	a5,-24(s0)
ffffffe000200314:	0017d793          	srli	a5,a5,0x1
ffffffe000200318:	fe843703          	ld	a4,-24(s0)
ffffffe00020031c:	00f767b3          	or	a5,a4,a5
ffffffe000200320:	fef43423          	sd	a5,-24(s0)
    size |= size >> 2;
ffffffe000200324:	fe843783          	ld	a5,-24(s0)
ffffffe000200328:	0027d793          	srli	a5,a5,0x2
ffffffe00020032c:	fe843703          	ld	a4,-24(s0)
ffffffe000200330:	00f767b3          	or	a5,a4,a5
ffffffe000200334:	fef43423          	sd	a5,-24(s0)
    size |= size >> 4;
ffffffe000200338:	fe843783          	ld	a5,-24(s0)
ffffffe00020033c:	0047d793          	srli	a5,a5,0x4
ffffffe000200340:	fe843703          	ld	a4,-24(s0)
ffffffe000200344:	00f767b3          	or	a5,a4,a5
ffffffe000200348:	fef43423          	sd	a5,-24(s0)
    size |= size >> 8;
ffffffe00020034c:	fe843783          	ld	a5,-24(s0)
ffffffe000200350:	0087d793          	srli	a5,a5,0x8
ffffffe000200354:	fe843703          	ld	a4,-24(s0)
ffffffe000200358:	00f767b3          	or	a5,a4,a5
ffffffe00020035c:	fef43423          	sd	a5,-24(s0)
    size |= size >> 16;
ffffffe000200360:	fe843783          	ld	a5,-24(s0)
ffffffe000200364:	0107d793          	srli	a5,a5,0x10
ffffffe000200368:	fe843703          	ld	a4,-24(s0)
ffffffe00020036c:	00f767b3          	or	a5,a4,a5
ffffffe000200370:	fef43423          	sd	a5,-24(s0)
    size |= size >> 32;
ffffffe000200374:	fe843783          	ld	a5,-24(s0)
ffffffe000200378:	0207d793          	srli	a5,a5,0x20
ffffffe00020037c:	fe843703          	ld	a4,-24(s0)
ffffffe000200380:	00f767b3          	or	a5,a4,a5
ffffffe000200384:	fef43423          	sd	a5,-24(s0)
    return size + 1;
ffffffe000200388:	fe843783          	ld	a5,-24(s0)
ffffffe00020038c:	00178793          	addi	a5,a5,1
}
ffffffe000200390:	00078513          	mv	a0,a5
ffffffe000200394:	01813403          	ld	s0,24(sp)
ffffffe000200398:	02010113          	addi	sp,sp,32
ffffffe00020039c:	00008067          	ret

ffffffe0002003a0 <buddy_init>:

void buddy_init()
{
ffffffe0002003a0:	fd010113          	addi	sp,sp,-48
ffffffe0002003a4:	02113423          	sd	ra,40(sp)
ffffffe0002003a8:	02813023          	sd	s0,32(sp)
ffffffe0002003ac:	03010413          	addi	s0,sp,48
    uint64_t buddy_size = (uint64_t)PHY_SIZE / PGSIZE;
ffffffe0002003b0:	000087b7          	lui	a5,0x8
ffffffe0002003b4:	fef43423          	sd	a5,-24(s0)

    if (!IS_POWER_OF_2(buddy_size))
ffffffe0002003b8:	fe843783          	ld	a5,-24(s0)
ffffffe0002003bc:	fff78713          	addi	a4,a5,-1 # 7fff <PGSIZE+0x6fff>
ffffffe0002003c0:	fe843783          	ld	a5,-24(s0)
ffffffe0002003c4:	00f777b3          	and	a5,a4,a5
ffffffe0002003c8:	00078863          	beqz	a5,ffffffe0002003d8 <buddy_init+0x38>
        buddy_size = fixsize(buddy_size);
ffffffe0002003cc:	fe843503          	ld	a0,-24(s0)
ffffffe0002003d0:	f25ff0ef          	jal	ffffffe0002002f4 <fixsize>
ffffffe0002003d4:	fea43423          	sd	a0,-24(s0)

    buddy.size = buddy_size;
ffffffe0002003d8:	00009797          	auipc	a5,0x9
ffffffe0002003dc:	c5078793          	addi	a5,a5,-944 # ffffffe000209028 <buddy>
ffffffe0002003e0:	fe843703          	ld	a4,-24(s0)
ffffffe0002003e4:	00e7b023          	sd	a4,0(a5)
    buddy.bitmap = free_page_start;
ffffffe0002003e8:	00005797          	auipc	a5,0x5
ffffffe0002003ec:	c2078793          	addi	a5,a5,-992 # ffffffe000205008 <free_page_start>
ffffffe0002003f0:	0007b703          	ld	a4,0(a5)
ffffffe0002003f4:	00009797          	auipc	a5,0x9
ffffffe0002003f8:	c3478793          	addi	a5,a5,-972 # ffffffe000209028 <buddy>
ffffffe0002003fc:	00e7b423          	sd	a4,8(a5)
    free_page_start += 2 * buddy.size * sizeof(*buddy.bitmap);
ffffffe000200400:	00005797          	auipc	a5,0x5
ffffffe000200404:	c0878793          	addi	a5,a5,-1016 # ffffffe000205008 <free_page_start>
ffffffe000200408:	0007b703          	ld	a4,0(a5)
ffffffe00020040c:	00009797          	auipc	a5,0x9
ffffffe000200410:	c1c78793          	addi	a5,a5,-996 # ffffffe000209028 <buddy>
ffffffe000200414:	0007b783          	ld	a5,0(a5)
ffffffe000200418:	00479793          	slli	a5,a5,0x4
ffffffe00020041c:	00f70733          	add	a4,a4,a5
ffffffe000200420:	00005797          	auipc	a5,0x5
ffffffe000200424:	be878793          	addi	a5,a5,-1048 # ffffffe000205008 <free_page_start>
ffffffe000200428:	00e7b023          	sd	a4,0(a5)
    memset(buddy.bitmap, 0, 2 * buddy.size * sizeof(*buddy.bitmap));
ffffffe00020042c:	00009797          	auipc	a5,0x9
ffffffe000200430:	bfc78793          	addi	a5,a5,-1028 # ffffffe000209028 <buddy>
ffffffe000200434:	0087b703          	ld	a4,8(a5)
ffffffe000200438:	00009797          	auipc	a5,0x9
ffffffe00020043c:	bf078793          	addi	a5,a5,-1040 # ffffffe000209028 <buddy>
ffffffe000200440:	0007b783          	ld	a5,0(a5)
ffffffe000200444:	00479793          	slli	a5,a5,0x4
ffffffe000200448:	00078613          	mv	a2,a5
ffffffe00020044c:	00000593          	li	a1,0
ffffffe000200450:	00070513          	mv	a0,a4
ffffffe000200454:	624030ef          	jal	ffffffe000203a78 <memset>

    uint64_t node_size = buddy.size * 2;
ffffffe000200458:	00009797          	auipc	a5,0x9
ffffffe00020045c:	bd078793          	addi	a5,a5,-1072 # ffffffe000209028 <buddy>
ffffffe000200460:	0007b783          	ld	a5,0(a5)
ffffffe000200464:	00179793          	slli	a5,a5,0x1
ffffffe000200468:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < 2 * buddy.size - 1; ++i)
ffffffe00020046c:	fc043c23          	sd	zero,-40(s0)
ffffffe000200470:	0500006f          	j	ffffffe0002004c0 <buddy_init+0x120>
    {
        if (IS_POWER_OF_2(i + 1))
ffffffe000200474:	fd843783          	ld	a5,-40(s0)
ffffffe000200478:	00178713          	addi	a4,a5,1
ffffffe00020047c:	fd843783          	ld	a5,-40(s0)
ffffffe000200480:	00f777b3          	and	a5,a4,a5
ffffffe000200484:	00079863          	bnez	a5,ffffffe000200494 <buddy_init+0xf4>
            node_size /= 2;
ffffffe000200488:	fe043783          	ld	a5,-32(s0)
ffffffe00020048c:	0017d793          	srli	a5,a5,0x1
ffffffe000200490:	fef43023          	sd	a5,-32(s0)
        buddy.bitmap[i] = node_size;
ffffffe000200494:	00009797          	auipc	a5,0x9
ffffffe000200498:	b9478793          	addi	a5,a5,-1132 # ffffffe000209028 <buddy>
ffffffe00020049c:	0087b703          	ld	a4,8(a5)
ffffffe0002004a0:	fd843783          	ld	a5,-40(s0)
ffffffe0002004a4:	00379793          	slli	a5,a5,0x3
ffffffe0002004a8:	00f707b3          	add	a5,a4,a5
ffffffe0002004ac:	fe043703          	ld	a4,-32(s0)
ffffffe0002004b0:	00e7b023          	sd	a4,0(a5)
    for (uint64_t i = 0; i < 2 * buddy.size - 1; ++i)
ffffffe0002004b4:	fd843783          	ld	a5,-40(s0)
ffffffe0002004b8:	00178793          	addi	a5,a5,1
ffffffe0002004bc:	fcf43c23          	sd	a5,-40(s0)
ffffffe0002004c0:	00009797          	auipc	a5,0x9
ffffffe0002004c4:	b6878793          	addi	a5,a5,-1176 # ffffffe000209028 <buddy>
ffffffe0002004c8:	0007b783          	ld	a5,0(a5)
ffffffe0002004cc:	00179793          	slli	a5,a5,0x1
ffffffe0002004d0:	fff78793          	addi	a5,a5,-1
ffffffe0002004d4:	fd843703          	ld	a4,-40(s0)
ffffffe0002004d8:	f8f76ee3          	bltu	a4,a5,ffffffe000200474 <buddy_init+0xd4>
    }

    for (uint64_t pfn = 0; (uint64_t)PFN2PHYS(pfn) < VA2PA((uint64_t)free_page_start); ++pfn)
ffffffe0002004dc:	fc043823          	sd	zero,-48(s0)
ffffffe0002004e0:	0180006f          	j	ffffffe0002004f8 <buddy_init+0x158>
    {
        buddy_alloc(1);
ffffffe0002004e4:	00100513          	li	a0,1
ffffffe0002004e8:	1fc000ef          	jal	ffffffe0002006e4 <buddy_alloc>
    for (uint64_t pfn = 0; (uint64_t)PFN2PHYS(pfn) < VA2PA((uint64_t)free_page_start); ++pfn)
ffffffe0002004ec:	fd043783          	ld	a5,-48(s0)
ffffffe0002004f0:	00178793          	addi	a5,a5,1
ffffffe0002004f4:	fcf43823          	sd	a5,-48(s0)
ffffffe0002004f8:	fd043783          	ld	a5,-48(s0)
ffffffe0002004fc:	00c79713          	slli	a4,a5,0xc
ffffffe000200500:	00100793          	li	a5,1
ffffffe000200504:	01f79793          	slli	a5,a5,0x1f
ffffffe000200508:	00f70733          	add	a4,a4,a5
ffffffe00020050c:	00005797          	auipc	a5,0x5
ffffffe000200510:	afc78793          	addi	a5,a5,-1284 # ffffffe000205008 <free_page_start>
ffffffe000200514:	0007b783          	ld	a5,0(a5)
ffffffe000200518:	00078693          	mv	a3,a5
ffffffe00020051c:	04100793          	li	a5,65
ffffffe000200520:	01f79793          	slli	a5,a5,0x1f
ffffffe000200524:	00f687b3          	add	a5,a3,a5
ffffffe000200528:	faf76ee3          	bltu	a4,a5,ffffffe0002004e4 <buddy_init+0x144>
    }

    printk("...buddy_init done!\n");
ffffffe00020052c:	00004517          	auipc	a0,0x4
ffffffe000200530:	adc50513          	addi	a0,a0,-1316 # ffffffe000204008 <__func__.0+0x8>
ffffffe000200534:	424030ef          	jal	ffffffe000203958 <printk>
    return;
ffffffe000200538:	00000013          	nop
}
ffffffe00020053c:	02813083          	ld	ra,40(sp)
ffffffe000200540:	02013403          	ld	s0,32(sp)
ffffffe000200544:	03010113          	addi	sp,sp,48
ffffffe000200548:	00008067          	ret

ffffffe00020054c <buddy_free>:

void buddy_free(uint64_t pfn)
{
ffffffe00020054c:	fc010113          	addi	sp,sp,-64
ffffffe000200550:	02813c23          	sd	s0,56(sp)
ffffffe000200554:	04010413          	addi	s0,sp,64
ffffffe000200558:	fca43423          	sd	a0,-56(s0)
    uint64_t node_size, index = 0;
ffffffe00020055c:	fe043023          	sd	zero,-32(s0)
    uint64_t left_longest, right_longest;

    node_size = 1;
ffffffe000200560:	00100793          	li	a5,1
ffffffe000200564:	fef43423          	sd	a5,-24(s0)
    index = pfn + buddy.size - 1;
ffffffe000200568:	00009797          	auipc	a5,0x9
ffffffe00020056c:	ac078793          	addi	a5,a5,-1344 # ffffffe000209028 <buddy>
ffffffe000200570:	0007b703          	ld	a4,0(a5)
ffffffe000200574:	fc843783          	ld	a5,-56(s0)
ffffffe000200578:	00f707b3          	add	a5,a4,a5
ffffffe00020057c:	fff78793          	addi	a5,a5,-1
ffffffe000200580:	fef43023          	sd	a5,-32(s0)

    for (; buddy.bitmap[index]; index = PARENT(index))
ffffffe000200584:	02c0006f          	j	ffffffe0002005b0 <buddy_free+0x64>
    {
        node_size *= 2;
ffffffe000200588:	fe843783          	ld	a5,-24(s0)
ffffffe00020058c:	00179793          	slli	a5,a5,0x1
ffffffe000200590:	fef43423          	sd	a5,-24(s0)
        if (index == 0)
ffffffe000200594:	fe043783          	ld	a5,-32(s0)
ffffffe000200598:	02078e63          	beqz	a5,ffffffe0002005d4 <buddy_free+0x88>
    for (; buddy.bitmap[index]; index = PARENT(index))
ffffffe00020059c:	fe043783          	ld	a5,-32(s0)
ffffffe0002005a0:	00178793          	addi	a5,a5,1
ffffffe0002005a4:	0017d793          	srli	a5,a5,0x1
ffffffe0002005a8:	fff78793          	addi	a5,a5,-1
ffffffe0002005ac:	fef43023          	sd	a5,-32(s0)
ffffffe0002005b0:	00009797          	auipc	a5,0x9
ffffffe0002005b4:	a7878793          	addi	a5,a5,-1416 # ffffffe000209028 <buddy>
ffffffe0002005b8:	0087b703          	ld	a4,8(a5)
ffffffe0002005bc:	fe043783          	ld	a5,-32(s0)
ffffffe0002005c0:	00379793          	slli	a5,a5,0x3
ffffffe0002005c4:	00f707b3          	add	a5,a4,a5
ffffffe0002005c8:	0007b783          	ld	a5,0(a5)
ffffffe0002005cc:	fa079ee3          	bnez	a5,ffffffe000200588 <buddy_free+0x3c>
ffffffe0002005d0:	0080006f          	j	ffffffe0002005d8 <buddy_free+0x8c>
            break;
ffffffe0002005d4:	00000013          	nop
    }

    buddy.bitmap[index] = node_size;
ffffffe0002005d8:	00009797          	auipc	a5,0x9
ffffffe0002005dc:	a5078793          	addi	a5,a5,-1456 # ffffffe000209028 <buddy>
ffffffe0002005e0:	0087b703          	ld	a4,8(a5)
ffffffe0002005e4:	fe043783          	ld	a5,-32(s0)
ffffffe0002005e8:	00379793          	slli	a5,a5,0x3
ffffffe0002005ec:	00f707b3          	add	a5,a4,a5
ffffffe0002005f0:	fe843703          	ld	a4,-24(s0)
ffffffe0002005f4:	00e7b023          	sd	a4,0(a5)

    while (index)
ffffffe0002005f8:	0d00006f          	j	ffffffe0002006c8 <buddy_free+0x17c>
    {
        index = PARENT(index);
ffffffe0002005fc:	fe043783          	ld	a5,-32(s0)
ffffffe000200600:	00178793          	addi	a5,a5,1
ffffffe000200604:	0017d793          	srli	a5,a5,0x1
ffffffe000200608:	fff78793          	addi	a5,a5,-1
ffffffe00020060c:	fef43023          	sd	a5,-32(s0)
        node_size *= 2;
ffffffe000200610:	fe843783          	ld	a5,-24(s0)
ffffffe000200614:	00179793          	slli	a5,a5,0x1
ffffffe000200618:	fef43423          	sd	a5,-24(s0)

        left_longest = buddy.bitmap[LEFT_LEAF(index)];
ffffffe00020061c:	00009797          	auipc	a5,0x9
ffffffe000200620:	a0c78793          	addi	a5,a5,-1524 # ffffffe000209028 <buddy>
ffffffe000200624:	0087b703          	ld	a4,8(a5)
ffffffe000200628:	fe043783          	ld	a5,-32(s0)
ffffffe00020062c:	00479793          	slli	a5,a5,0x4
ffffffe000200630:	00878793          	addi	a5,a5,8
ffffffe000200634:	00f707b3          	add	a5,a4,a5
ffffffe000200638:	0007b783          	ld	a5,0(a5)
ffffffe00020063c:	fcf43c23          	sd	a5,-40(s0)
        right_longest = buddy.bitmap[RIGHT_LEAF(index)];
ffffffe000200640:	00009797          	auipc	a5,0x9
ffffffe000200644:	9e878793          	addi	a5,a5,-1560 # ffffffe000209028 <buddy>
ffffffe000200648:	0087b703          	ld	a4,8(a5)
ffffffe00020064c:	fe043783          	ld	a5,-32(s0)
ffffffe000200650:	00178793          	addi	a5,a5,1
ffffffe000200654:	00479793          	slli	a5,a5,0x4
ffffffe000200658:	00f707b3          	add	a5,a4,a5
ffffffe00020065c:	0007b783          	ld	a5,0(a5)
ffffffe000200660:	fcf43823          	sd	a5,-48(s0)

        if (left_longest + right_longest == node_size)
ffffffe000200664:	fd843703          	ld	a4,-40(s0)
ffffffe000200668:	fd043783          	ld	a5,-48(s0)
ffffffe00020066c:	00f707b3          	add	a5,a4,a5
ffffffe000200670:	fe843703          	ld	a4,-24(s0)
ffffffe000200674:	02f71463          	bne	a4,a5,ffffffe00020069c <buddy_free+0x150>
            buddy.bitmap[index] = node_size;
ffffffe000200678:	00009797          	auipc	a5,0x9
ffffffe00020067c:	9b078793          	addi	a5,a5,-1616 # ffffffe000209028 <buddy>
ffffffe000200680:	0087b703          	ld	a4,8(a5)
ffffffe000200684:	fe043783          	ld	a5,-32(s0)
ffffffe000200688:	00379793          	slli	a5,a5,0x3
ffffffe00020068c:	00f707b3          	add	a5,a4,a5
ffffffe000200690:	fe843703          	ld	a4,-24(s0)
ffffffe000200694:	00e7b023          	sd	a4,0(a5)
ffffffe000200698:	0300006f          	j	ffffffe0002006c8 <buddy_free+0x17c>
        else
            buddy.bitmap[index] = MAX(left_longest, right_longest);
ffffffe00020069c:	00009797          	auipc	a5,0x9
ffffffe0002006a0:	98c78793          	addi	a5,a5,-1652 # ffffffe000209028 <buddy>
ffffffe0002006a4:	0087b703          	ld	a4,8(a5)
ffffffe0002006a8:	fe043783          	ld	a5,-32(s0)
ffffffe0002006ac:	00379793          	slli	a5,a5,0x3
ffffffe0002006b0:	00f706b3          	add	a3,a4,a5
ffffffe0002006b4:	fd843703          	ld	a4,-40(s0)
ffffffe0002006b8:	fd043783          	ld	a5,-48(s0)
ffffffe0002006bc:	00e7f463          	bgeu	a5,a4,ffffffe0002006c4 <buddy_free+0x178>
ffffffe0002006c0:	00070793          	mv	a5,a4
ffffffe0002006c4:	00f6b023          	sd	a5,0(a3)
    while (index)
ffffffe0002006c8:	fe043783          	ld	a5,-32(s0)
ffffffe0002006cc:	f20798e3          	bnez	a5,ffffffe0002005fc <buddy_free+0xb0>
    }
}
ffffffe0002006d0:	00000013          	nop
ffffffe0002006d4:	00000013          	nop
ffffffe0002006d8:	03813403          	ld	s0,56(sp)
ffffffe0002006dc:	04010113          	addi	sp,sp,64
ffffffe0002006e0:	00008067          	ret

ffffffe0002006e4 <buddy_alloc>:

uint64_t buddy_alloc(uint64_t nrpages)
{
ffffffe0002006e4:	fc010113          	addi	sp,sp,-64
ffffffe0002006e8:	02113c23          	sd	ra,56(sp)
ffffffe0002006ec:	02813823          	sd	s0,48(sp)
ffffffe0002006f0:	04010413          	addi	s0,sp,64
ffffffe0002006f4:	fca43423          	sd	a0,-56(s0)
    uint64_t index = 0;
ffffffe0002006f8:	fe043423          	sd	zero,-24(s0)
    uint64_t node_size;
    uint64_t pfn = 0;
ffffffe0002006fc:	fc043c23          	sd	zero,-40(s0)

    if (nrpages <= 0)
ffffffe000200700:	fc843783          	ld	a5,-56(s0)
ffffffe000200704:	00079863          	bnez	a5,ffffffe000200714 <buddy_alloc+0x30>
        nrpages = 1;
ffffffe000200708:	00100793          	li	a5,1
ffffffe00020070c:	fcf43423          	sd	a5,-56(s0)
ffffffe000200710:	0240006f          	j	ffffffe000200734 <buddy_alloc+0x50>
    else if (!IS_POWER_OF_2(nrpages))
ffffffe000200714:	fc843783          	ld	a5,-56(s0)
ffffffe000200718:	fff78713          	addi	a4,a5,-1
ffffffe00020071c:	fc843783          	ld	a5,-56(s0)
ffffffe000200720:	00f777b3          	and	a5,a4,a5
ffffffe000200724:	00078863          	beqz	a5,ffffffe000200734 <buddy_alloc+0x50>
        nrpages = fixsize(nrpages);
ffffffe000200728:	fc843503          	ld	a0,-56(s0)
ffffffe00020072c:	bc9ff0ef          	jal	ffffffe0002002f4 <fixsize>
ffffffe000200730:	fca43423          	sd	a0,-56(s0)

    if (buddy.bitmap[index] < nrpages)
ffffffe000200734:	00009797          	auipc	a5,0x9
ffffffe000200738:	8f478793          	addi	a5,a5,-1804 # ffffffe000209028 <buddy>
ffffffe00020073c:	0087b703          	ld	a4,8(a5)
ffffffe000200740:	fe843783          	ld	a5,-24(s0)
ffffffe000200744:	00379793          	slli	a5,a5,0x3
ffffffe000200748:	00f707b3          	add	a5,a4,a5
ffffffe00020074c:	0007b783          	ld	a5,0(a5)
ffffffe000200750:	fc843703          	ld	a4,-56(s0)
ffffffe000200754:	00e7f663          	bgeu	a5,a4,ffffffe000200760 <buddy_alloc+0x7c>
        return 0;
ffffffe000200758:	00000793          	li	a5,0
ffffffe00020075c:	1480006f          	j	ffffffe0002008a4 <buddy_alloc+0x1c0>

    for (node_size = buddy.size; node_size != nrpages; node_size /= 2)
ffffffe000200760:	00009797          	auipc	a5,0x9
ffffffe000200764:	8c878793          	addi	a5,a5,-1848 # ffffffe000209028 <buddy>
ffffffe000200768:	0007b783          	ld	a5,0(a5)
ffffffe00020076c:	fef43023          	sd	a5,-32(s0)
ffffffe000200770:	05c0006f          	j	ffffffe0002007cc <buddy_alloc+0xe8>
    {
        if (buddy.bitmap[LEFT_LEAF(index)] >= nrpages)
ffffffe000200774:	00009797          	auipc	a5,0x9
ffffffe000200778:	8b478793          	addi	a5,a5,-1868 # ffffffe000209028 <buddy>
ffffffe00020077c:	0087b703          	ld	a4,8(a5)
ffffffe000200780:	fe843783          	ld	a5,-24(s0)
ffffffe000200784:	00479793          	slli	a5,a5,0x4
ffffffe000200788:	00878793          	addi	a5,a5,8
ffffffe00020078c:	00f707b3          	add	a5,a4,a5
ffffffe000200790:	0007b783          	ld	a5,0(a5)
ffffffe000200794:	fc843703          	ld	a4,-56(s0)
ffffffe000200798:	00e7ec63          	bltu	a5,a4,ffffffe0002007b0 <buddy_alloc+0xcc>
            index = LEFT_LEAF(index);
ffffffe00020079c:	fe843783          	ld	a5,-24(s0)
ffffffe0002007a0:	00179793          	slli	a5,a5,0x1
ffffffe0002007a4:	00178793          	addi	a5,a5,1
ffffffe0002007a8:	fef43423          	sd	a5,-24(s0)
ffffffe0002007ac:	0140006f          	j	ffffffe0002007c0 <buddy_alloc+0xdc>
        else
            index = RIGHT_LEAF(index);
ffffffe0002007b0:	fe843783          	ld	a5,-24(s0)
ffffffe0002007b4:	00178793          	addi	a5,a5,1
ffffffe0002007b8:	00179793          	slli	a5,a5,0x1
ffffffe0002007bc:	fef43423          	sd	a5,-24(s0)
    for (node_size = buddy.size; node_size != nrpages; node_size /= 2)
ffffffe0002007c0:	fe043783          	ld	a5,-32(s0)
ffffffe0002007c4:	0017d793          	srli	a5,a5,0x1
ffffffe0002007c8:	fef43023          	sd	a5,-32(s0)
ffffffe0002007cc:	fe043703          	ld	a4,-32(s0)
ffffffe0002007d0:	fc843783          	ld	a5,-56(s0)
ffffffe0002007d4:	faf710e3          	bne	a4,a5,ffffffe000200774 <buddy_alloc+0x90>
    }

    buddy.bitmap[index] = 0;
ffffffe0002007d8:	00009797          	auipc	a5,0x9
ffffffe0002007dc:	85078793          	addi	a5,a5,-1968 # ffffffe000209028 <buddy>
ffffffe0002007e0:	0087b703          	ld	a4,8(a5)
ffffffe0002007e4:	fe843783          	ld	a5,-24(s0)
ffffffe0002007e8:	00379793          	slli	a5,a5,0x3
ffffffe0002007ec:	00f707b3          	add	a5,a4,a5
ffffffe0002007f0:	0007b023          	sd	zero,0(a5)
    pfn = (index + 1) * node_size - buddy.size;
ffffffe0002007f4:	fe843783          	ld	a5,-24(s0)
ffffffe0002007f8:	00178713          	addi	a4,a5,1
ffffffe0002007fc:	fe043783          	ld	a5,-32(s0)
ffffffe000200800:	02f70733          	mul	a4,a4,a5
ffffffe000200804:	00009797          	auipc	a5,0x9
ffffffe000200808:	82478793          	addi	a5,a5,-2012 # ffffffe000209028 <buddy>
ffffffe00020080c:	0007b783          	ld	a5,0(a5)
ffffffe000200810:	40f707b3          	sub	a5,a4,a5
ffffffe000200814:	fcf43c23          	sd	a5,-40(s0)

    while (index)
ffffffe000200818:	0800006f          	j	ffffffe000200898 <buddy_alloc+0x1b4>
    {
        index = PARENT(index);
ffffffe00020081c:	fe843783          	ld	a5,-24(s0)
ffffffe000200820:	00178793          	addi	a5,a5,1
ffffffe000200824:	0017d793          	srli	a5,a5,0x1
ffffffe000200828:	fff78793          	addi	a5,a5,-1
ffffffe00020082c:	fef43423          	sd	a5,-24(s0)
        buddy.bitmap[index] =
            MAX(buddy.bitmap[LEFT_LEAF(index)], buddy.bitmap[RIGHT_LEAF(index)]);
ffffffe000200830:	00008797          	auipc	a5,0x8
ffffffe000200834:	7f878793          	addi	a5,a5,2040 # ffffffe000209028 <buddy>
ffffffe000200838:	0087b703          	ld	a4,8(a5)
ffffffe00020083c:	fe843783          	ld	a5,-24(s0)
ffffffe000200840:	00178793          	addi	a5,a5,1
ffffffe000200844:	00479793          	slli	a5,a5,0x4
ffffffe000200848:	00f707b3          	add	a5,a4,a5
ffffffe00020084c:	0007b603          	ld	a2,0(a5)
ffffffe000200850:	00008797          	auipc	a5,0x8
ffffffe000200854:	7d878793          	addi	a5,a5,2008 # ffffffe000209028 <buddy>
ffffffe000200858:	0087b703          	ld	a4,8(a5)
ffffffe00020085c:	fe843783          	ld	a5,-24(s0)
ffffffe000200860:	00479793          	slli	a5,a5,0x4
ffffffe000200864:	00878793          	addi	a5,a5,8
ffffffe000200868:	00f707b3          	add	a5,a4,a5
ffffffe00020086c:	0007b703          	ld	a4,0(a5)
        buddy.bitmap[index] =
ffffffe000200870:	00008797          	auipc	a5,0x8
ffffffe000200874:	7b878793          	addi	a5,a5,1976 # ffffffe000209028 <buddy>
ffffffe000200878:	0087b683          	ld	a3,8(a5)
ffffffe00020087c:	fe843783          	ld	a5,-24(s0)
ffffffe000200880:	00379793          	slli	a5,a5,0x3
ffffffe000200884:	00f686b3          	add	a3,a3,a5
            MAX(buddy.bitmap[LEFT_LEAF(index)], buddy.bitmap[RIGHT_LEAF(index)]);
ffffffe000200888:	00060793          	mv	a5,a2
ffffffe00020088c:	00e7f463          	bgeu	a5,a4,ffffffe000200894 <buddy_alloc+0x1b0>
ffffffe000200890:	00070793          	mv	a5,a4
        buddy.bitmap[index] =
ffffffe000200894:	00f6b023          	sd	a5,0(a3)
    while (index)
ffffffe000200898:	fe843783          	ld	a5,-24(s0)
ffffffe00020089c:	f80790e3          	bnez	a5,ffffffe00020081c <buddy_alloc+0x138>
    }

    return pfn;
ffffffe0002008a0:	fd843783          	ld	a5,-40(s0)
}
ffffffe0002008a4:	00078513          	mv	a0,a5
ffffffe0002008a8:	03813083          	ld	ra,56(sp)
ffffffe0002008ac:	03013403          	ld	s0,48(sp)
ffffffe0002008b0:	04010113          	addi	sp,sp,64
ffffffe0002008b4:	00008067          	ret

ffffffe0002008b8 <alloc_pages>:

void *alloc_pages(uint64_t nrpages)
{
ffffffe0002008b8:	fd010113          	addi	sp,sp,-48
ffffffe0002008bc:	02113423          	sd	ra,40(sp)
ffffffe0002008c0:	02813023          	sd	s0,32(sp)
ffffffe0002008c4:	03010413          	addi	s0,sp,48
ffffffe0002008c8:	fca43c23          	sd	a0,-40(s0)
    uint64_t pfn = buddy_alloc(nrpages);
ffffffe0002008cc:	fd843503          	ld	a0,-40(s0)
ffffffe0002008d0:	e15ff0ef          	jal	ffffffe0002006e4 <buddy_alloc>
ffffffe0002008d4:	fea43423          	sd	a0,-24(s0)
    if (pfn == 0)
ffffffe0002008d8:	fe843783          	ld	a5,-24(s0)
ffffffe0002008dc:	00079663          	bnez	a5,ffffffe0002008e8 <alloc_pages+0x30>
        return 0;
ffffffe0002008e0:	00000793          	li	a5,0
ffffffe0002008e4:	0180006f          	j	ffffffe0002008fc <alloc_pages+0x44>
    return (void *)(PA2VA(PFN2PHYS(pfn)));
ffffffe0002008e8:	fe843783          	ld	a5,-24(s0)
ffffffe0002008ec:	00c79713          	slli	a4,a5,0xc
ffffffe0002008f0:	fff00793          	li	a5,-1
ffffffe0002008f4:	02579793          	slli	a5,a5,0x25
ffffffe0002008f8:	00f707b3          	add	a5,a4,a5
}
ffffffe0002008fc:	00078513          	mv	a0,a5
ffffffe000200900:	02813083          	ld	ra,40(sp)
ffffffe000200904:	02013403          	ld	s0,32(sp)
ffffffe000200908:	03010113          	addi	sp,sp,48
ffffffe00020090c:	00008067          	ret

ffffffe000200910 <alloc_page>:

void *alloc_page()
{
ffffffe000200910:	ff010113          	addi	sp,sp,-16
ffffffe000200914:	00113423          	sd	ra,8(sp)
ffffffe000200918:	00813023          	sd	s0,0(sp)
ffffffe00020091c:	01010413          	addi	s0,sp,16
    return alloc_pages(1);
ffffffe000200920:	00100513          	li	a0,1
ffffffe000200924:	f95ff0ef          	jal	ffffffe0002008b8 <alloc_pages>
ffffffe000200928:	00050793          	mv	a5,a0
}
ffffffe00020092c:	00078513          	mv	a0,a5
ffffffe000200930:	00813083          	ld	ra,8(sp)
ffffffe000200934:	00013403          	ld	s0,0(sp)
ffffffe000200938:	01010113          	addi	sp,sp,16
ffffffe00020093c:	00008067          	ret

ffffffe000200940 <free_pages>:

void free_pages(void *va)
{
ffffffe000200940:	fe010113          	addi	sp,sp,-32
ffffffe000200944:	00113c23          	sd	ra,24(sp)
ffffffe000200948:	00813823          	sd	s0,16(sp)
ffffffe00020094c:	02010413          	addi	s0,sp,32
ffffffe000200950:	fea43423          	sd	a0,-24(s0)
    buddy_free(PHYS2PFN(VA2PA((uint64_t)va)));
ffffffe000200954:	fe843703          	ld	a4,-24(s0)
ffffffe000200958:	00100793          	li	a5,1
ffffffe00020095c:	02579793          	slli	a5,a5,0x25
ffffffe000200960:	00f707b3          	add	a5,a4,a5
ffffffe000200964:	00c7d793          	srli	a5,a5,0xc
ffffffe000200968:	00078513          	mv	a0,a5
ffffffe00020096c:	be1ff0ef          	jal	ffffffe00020054c <buddy_free>
}
ffffffe000200970:	00000013          	nop
ffffffe000200974:	01813083          	ld	ra,24(sp)
ffffffe000200978:	01013403          	ld	s0,16(sp)
ffffffe00020097c:	02010113          	addi	sp,sp,32
ffffffe000200980:	00008067          	ret

ffffffe000200984 <kalloc>:

void *kalloc()
{
ffffffe000200984:	ff010113          	addi	sp,sp,-16
ffffffe000200988:	00113423          	sd	ra,8(sp)
ffffffe00020098c:	00813023          	sd	s0,0(sp)
ffffffe000200990:	01010413          	addi	s0,sp,16
    // r = kmem.freelist;
    // kmem.freelist = r->next;

    // memset((void *)r, 0x0, PGSIZE);
    // return (void *)r;
    return alloc_page();
ffffffe000200994:	f7dff0ef          	jal	ffffffe000200910 <alloc_page>
ffffffe000200998:	00050793          	mv	a5,a0
}
ffffffe00020099c:	00078513          	mv	a0,a5
ffffffe0002009a0:	00813083          	ld	ra,8(sp)
ffffffe0002009a4:	00013403          	ld	s0,0(sp)
ffffffe0002009a8:	01010113          	addi	sp,sp,16
ffffffe0002009ac:	00008067          	ret

ffffffe0002009b0 <kfree>:

void kfree(void *addr)
{
ffffffe0002009b0:	fe010113          	addi	sp,sp,-32
ffffffe0002009b4:	00113c23          	sd	ra,24(sp)
ffffffe0002009b8:	00813823          	sd	s0,16(sp)
ffffffe0002009bc:	02010413          	addi	s0,sp,32
ffffffe0002009c0:	fea43423          	sd	a0,-24(s0)
    // memset(addr, 0x0, (uint64_t)PGSIZE);

    // r = (struct run *)addr;
    // r->next = kmem.freelist;
    // kmem.freelist = r;
    free_pages(addr);
ffffffe0002009c4:	fe843503          	ld	a0,-24(s0)
ffffffe0002009c8:	f79ff0ef          	jal	ffffffe000200940 <free_pages>

    return;
ffffffe0002009cc:	00000013          	nop
}
ffffffe0002009d0:	01813083          	ld	ra,24(sp)
ffffffe0002009d4:	01013403          	ld	s0,16(sp)
ffffffe0002009d8:	02010113          	addi	sp,sp,32
ffffffe0002009dc:	00008067          	ret

ffffffe0002009e0 <kfreerange>:

void kfreerange(char *start, char *end)
{
ffffffe0002009e0:	fd010113          	addi	sp,sp,-48
ffffffe0002009e4:	02113423          	sd	ra,40(sp)
ffffffe0002009e8:	02813023          	sd	s0,32(sp)
ffffffe0002009ec:	03010413          	addi	s0,sp,48
ffffffe0002009f0:	fca43c23          	sd	a0,-40(s0)
ffffffe0002009f4:	fcb43823          	sd	a1,-48(s0)
    char *addr = (char *)PGROUNDUP((uintptr_t)start);
ffffffe0002009f8:	fd843703          	ld	a4,-40(s0)
ffffffe0002009fc:	000017b7          	lui	a5,0x1
ffffffe000200a00:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200a04:	00f70733          	add	a4,a4,a5
ffffffe000200a08:	fffff7b7          	lui	a5,0xfffff
ffffffe000200a0c:	00f777b3          	and	a5,a4,a5
ffffffe000200a10:	fef43423          	sd	a5,-24(s0)
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE)
ffffffe000200a14:	01c0006f          	j	ffffffe000200a30 <kfreerange+0x50>
    {
        kfree((void *)addr);
ffffffe000200a18:	fe843503          	ld	a0,-24(s0)
ffffffe000200a1c:	f95ff0ef          	jal	ffffffe0002009b0 <kfree>
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE)
ffffffe000200a20:	fe843703          	ld	a4,-24(s0)
ffffffe000200a24:	000017b7          	lui	a5,0x1
ffffffe000200a28:	00f707b3          	add	a5,a4,a5
ffffffe000200a2c:	fef43423          	sd	a5,-24(s0)
ffffffe000200a30:	fe843703          	ld	a4,-24(s0)
ffffffe000200a34:	000017b7          	lui	a5,0x1
ffffffe000200a38:	00f70733          	add	a4,a4,a5
ffffffe000200a3c:	fd043783          	ld	a5,-48(s0)
ffffffe000200a40:	fce7fce3          	bgeu	a5,a4,ffffffe000200a18 <kfreerange+0x38>
    }
}
ffffffe000200a44:	00000013          	nop
ffffffe000200a48:	00000013          	nop
ffffffe000200a4c:	02813083          	ld	ra,40(sp)
ffffffe000200a50:	02013403          	ld	s0,32(sp)
ffffffe000200a54:	03010113          	addi	sp,sp,48
ffffffe000200a58:	00008067          	ret

ffffffe000200a5c <mm_init>:

void mm_init(void)
{
ffffffe000200a5c:	ff010113          	addi	sp,sp,-16
ffffffe000200a60:	00113423          	sd	ra,8(sp)
ffffffe000200a64:	00813023          	sd	s0,0(sp)
ffffffe000200a68:	01010413          	addi	s0,sp,16
    // kfreerange(_ekernel, (char *)PHY_END+PA2VA_OFFSET);
    buddy_init();
ffffffe000200a6c:	935ff0ef          	jal	ffffffe0002003a0 <buddy_init>
    printk("...mm_init done!\n");
ffffffe000200a70:	00003517          	auipc	a0,0x3
ffffffe000200a74:	5b050513          	addi	a0,a0,1456 # ffffffe000204020 <__func__.0+0x20>
ffffffe000200a78:	6e1020ef          	jal	ffffffe000203958 <printk>
}
ffffffe000200a7c:	00000013          	nop
ffffffe000200a80:	00813083          	ld	ra,8(sp)
ffffffe000200a84:	00013403          	ld	s0,0(sp)
ffffffe000200a88:	01010113          	addi	sp,sp,16
ffffffe000200a8c:	00008067          	ret

ffffffe000200a90 <task_init>:
extern char _eramdisk[];

uint64_t nr_tasks = 0;

void task_init()
{
ffffffe000200a90:	fb010113          	addi	sp,sp,-80
ffffffe000200a94:	04113423          	sd	ra,72(sp)
ffffffe000200a98:	04813023          	sd	s0,64(sp)
ffffffe000200a9c:	02913c23          	sd	s1,56(sp)
ffffffe000200aa0:	05010413          	addi	s0,sp,80
    srand(2024);
ffffffe000200aa4:	7e800513          	li	a0,2024
ffffffe000200aa8:	731020ef          	jal	ffffffe0002039d8 <srand>

    // 1. 为 idle 分配一个物理页
    idle = (struct task_struct *)kalloc();
ffffffe000200aac:	ed9ff0ef          	jal	ffffffe000200984 <kalloc>
ffffffe000200ab0:	00050713          	mv	a4,a0
ffffffe000200ab4:	00008797          	auipc	a5,0x8
ffffffe000200ab8:	55478793          	addi	a5,a5,1364 # ffffffe000209008 <idle>
ffffffe000200abc:	00e7b023          	sd	a4,0(a5)

    // 2. 设置 state 为 TASK_RUNNING
    idle->state = TASK_RUNNING;
ffffffe000200ac0:	00008797          	auipc	a5,0x8
ffffffe000200ac4:	54878793          	addi	a5,a5,1352 # ffffffe000209008 <idle>
ffffffe000200ac8:	0007b783          	ld	a5,0(a5)
ffffffe000200acc:	0007b023          	sd	zero,0(a5)

    // 3. counter 和 priority 设置为 0
    idle->counter = 0;
ffffffe000200ad0:	00008797          	auipc	a5,0x8
ffffffe000200ad4:	53878793          	addi	a5,a5,1336 # ffffffe000209008 <idle>
ffffffe000200ad8:	0007b783          	ld	a5,0(a5)
ffffffe000200adc:	0007b423          	sd	zero,8(a5)
    idle->priority = 0;
ffffffe000200ae0:	00008797          	auipc	a5,0x8
ffffffe000200ae4:	52878793          	addi	a5,a5,1320 # ffffffe000209008 <idle>
ffffffe000200ae8:	0007b783          	ld	a5,0(a5)
ffffffe000200aec:	0007b823          	sd	zero,16(a5)

    // 4. 设置 idle 的 pid 为 0
    idle->pid = 0;
ffffffe000200af0:	00008797          	auipc	a5,0x8
ffffffe000200af4:	51878793          	addi	a5,a5,1304 # ffffffe000209008 <idle>
ffffffe000200af8:	0007b783          	ld	a5,0(a5)
ffffffe000200afc:	0007bc23          	sd	zero,24(a5)

    // 5. 将 current 和 task[0] 指向 idle
    current = idle;
ffffffe000200b00:	00008797          	auipc	a5,0x8
ffffffe000200b04:	50878793          	addi	a5,a5,1288 # ffffffe000209008 <idle>
ffffffe000200b08:	0007b703          	ld	a4,0(a5)
ffffffe000200b0c:	00008797          	auipc	a5,0x8
ffffffe000200b10:	50478793          	addi	a5,a5,1284 # ffffffe000209010 <current>
ffffffe000200b14:	00e7b023          	sd	a4,0(a5)
    task[nr_tasks++] = idle;
ffffffe000200b18:	00008797          	auipc	a5,0x8
ffffffe000200b1c:	50078793          	addi	a5,a5,1280 # ffffffe000209018 <nr_tasks>
ffffffe000200b20:	0007b783          	ld	a5,0(a5)
ffffffe000200b24:	00178693          	addi	a3,a5,1
ffffffe000200b28:	00008717          	auipc	a4,0x8
ffffffe000200b2c:	4f070713          	addi	a4,a4,1264 # ffffffe000209018 <nr_tasks>
ffffffe000200b30:	00d73023          	sd	a3,0(a4)
ffffffe000200b34:	00008717          	auipc	a4,0x8
ffffffe000200b38:	4d470713          	addi	a4,a4,1236 # ffffffe000209008 <idle>
ffffffe000200b3c:	00073703          	ld	a4,0(a4)
ffffffe000200b40:	00008697          	auipc	a3,0x8
ffffffe000200b44:	4f868693          	addi	a3,a3,1272 # ffffffe000209038 <task>
ffffffe000200b48:	00379793          	slli	a5,a5,0x3
ffffffe000200b4c:	00f687b3          	add	a5,a3,a5
ffffffe000200b50:	00e7b023          	sd	a4,0(a5)

    // 参考 idle 的设置，为 task[1] ~ task[NR_TASKS - 1] 进行初始化
    for (int i = 1; i < 2; i++)
ffffffe000200b54:	00100793          	li	a5,1
ffffffe000200b58:	fcf42e23          	sw	a5,-36(s0)
ffffffe000200b5c:	3600006f          	j	ffffffe000200ebc <task_init+0x42c>
    {
        task[i] = (struct task_struct *)kalloc();
ffffffe000200b60:	e25ff0ef          	jal	ffffffe000200984 <kalloc>
ffffffe000200b64:	00050693          	mv	a3,a0
ffffffe000200b68:	00008717          	auipc	a4,0x8
ffffffe000200b6c:	4d070713          	addi	a4,a4,1232 # ffffffe000209038 <task>
ffffffe000200b70:	fdc42783          	lw	a5,-36(s0)
ffffffe000200b74:	00379793          	slli	a5,a5,0x3
ffffffe000200b78:	00f707b3          	add	a5,a4,a5
ffffffe000200b7c:	00d7b023          	sd	a3,0(a5)

        // 2. 设置 state 为 TASK_RUNNING
        task[i]->state = TASK_RUNNING;
ffffffe000200b80:	00008717          	auipc	a4,0x8
ffffffe000200b84:	4b870713          	addi	a4,a4,1208 # ffffffe000209038 <task>
ffffffe000200b88:	fdc42783          	lw	a5,-36(s0)
ffffffe000200b8c:	00379793          	slli	a5,a5,0x3
ffffffe000200b90:	00f707b3          	add	a5,a4,a5
ffffffe000200b94:	0007b783          	ld	a5,0(a5)
ffffffe000200b98:	0007b023          	sd	zero,0(a5)

        // 3. 设置 counter 和 priority
        task[i]->priority = (uint64_t)rand() % (PRIORITY_MAX - PRIORITY_MIN + 1) + PRIORITY_MIN;
ffffffe000200b9c:	681020ef          	jal	ffffffe000203a1c <rand>
ffffffe000200ba0:	00050793          	mv	a5,a0
ffffffe000200ba4:	00078713          	mv	a4,a5
ffffffe000200ba8:	00a00793          	li	a5,10
ffffffe000200bac:	02f77733          	remu	a4,a4,a5
ffffffe000200bb0:	00008697          	auipc	a3,0x8
ffffffe000200bb4:	48868693          	addi	a3,a3,1160 # ffffffe000209038 <task>
ffffffe000200bb8:	fdc42783          	lw	a5,-36(s0)
ffffffe000200bbc:	00379793          	slli	a5,a5,0x3
ffffffe000200bc0:	00f687b3          	add	a5,a3,a5
ffffffe000200bc4:	0007b783          	ld	a5,0(a5)
ffffffe000200bc8:	00170713          	addi	a4,a4,1
ffffffe000200bcc:	00e7b823          	sd	a4,16(a5)
        task[i]->counter = task[i]->priority;
ffffffe000200bd0:	00008717          	auipc	a4,0x8
ffffffe000200bd4:	46870713          	addi	a4,a4,1128 # ffffffe000209038 <task>
ffffffe000200bd8:	fdc42783          	lw	a5,-36(s0)
ffffffe000200bdc:	00379793          	slli	a5,a5,0x3
ffffffe000200be0:	00f707b3          	add	a5,a4,a5
ffffffe000200be4:	0007b703          	ld	a4,0(a5)
ffffffe000200be8:	00008697          	auipc	a3,0x8
ffffffe000200bec:	45068693          	addi	a3,a3,1104 # ffffffe000209038 <task>
ffffffe000200bf0:	fdc42783          	lw	a5,-36(s0)
ffffffe000200bf4:	00379793          	slli	a5,a5,0x3
ffffffe000200bf8:	00f687b3          	add	a5,a3,a5
ffffffe000200bfc:	0007b783          	ld	a5,0(a5)
ffffffe000200c00:	01073703          	ld	a4,16(a4)
ffffffe000200c04:	00e7b423          	sd	a4,8(a5)
        task[i]->pid = i;
ffffffe000200c08:	00008717          	auipc	a4,0x8
ffffffe000200c0c:	43070713          	addi	a4,a4,1072 # ffffffe000209038 <task>
ffffffe000200c10:	fdc42783          	lw	a5,-36(s0)
ffffffe000200c14:	00379793          	slli	a5,a5,0x3
ffffffe000200c18:	00f707b3          	add	a5,a4,a5
ffffffe000200c1c:	0007b783          	ld	a5,0(a5)
ffffffe000200c20:	fdc42703          	lw	a4,-36(s0)
ffffffe000200c24:	00e7bc23          	sd	a4,24(a5)

        // 4. 设置 thread_struct 中的 ra 和 sp
        task[i]->thread.ra = (uintptr_t)__dummy;          // ra 设置为 __dummy 的地址
ffffffe000200c28:	00008717          	auipc	a4,0x8
ffffffe000200c2c:	41070713          	addi	a4,a4,1040 # ffffffe000209038 <task>
ffffffe000200c30:	fdc42783          	lw	a5,-36(s0)
ffffffe000200c34:	00379793          	slli	a5,a5,0x3
ffffffe000200c38:	00f707b3          	add	a5,a4,a5
ffffffe000200c3c:	0007b783          	ld	a5,0(a5)
ffffffe000200c40:	fffff717          	auipc	a4,0xfffff
ffffffe000200c44:	58470713          	addi	a4,a4,1412 # ffffffe0002001c4 <__dummy>
ffffffe000200c48:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.sp = (uintptr_t)task[i] + PGSIZE; // sp 指向该页的高地址
ffffffe000200c4c:	00008717          	auipc	a4,0x8
ffffffe000200c50:	3ec70713          	addi	a4,a4,1004 # ffffffe000209038 <task>
ffffffe000200c54:	fdc42783          	lw	a5,-36(s0)
ffffffe000200c58:	00379793          	slli	a5,a5,0x3
ffffffe000200c5c:	00f707b3          	add	a5,a4,a5
ffffffe000200c60:	0007b783          	ld	a5,0(a5)
ffffffe000200c64:	00078693          	mv	a3,a5
ffffffe000200c68:	00008717          	auipc	a4,0x8
ffffffe000200c6c:	3d070713          	addi	a4,a4,976 # ffffffe000209038 <task>
ffffffe000200c70:	fdc42783          	lw	a5,-36(s0)
ffffffe000200c74:	00379793          	slli	a5,a5,0x3
ffffffe000200c78:	00f707b3          	add	a5,a4,a5
ffffffe000200c7c:	0007b783          	ld	a5,0(a5)
ffffffe000200c80:	00001737          	lui	a4,0x1
ffffffe000200c84:	00e68733          	add	a4,a3,a4
ffffffe000200c88:	02e7b423          	sd	a4,40(a5)
        task[i]->thread.sepc = USER_START;                // sepc 设置为用户态的入口地址
ffffffe000200c8c:	00008717          	auipc	a4,0x8
ffffffe000200c90:	3ac70713          	addi	a4,a4,940 # ffffffe000209038 <task>
ffffffe000200c94:	fdc42783          	lw	a5,-36(s0)
ffffffe000200c98:	00379793          	slli	a5,a5,0x3
ffffffe000200c9c:	00f707b3          	add	a5,a4,a5
ffffffe000200ca0:	0007b783          	ld	a5,0(a5)
ffffffe000200ca4:	0807b823          	sd	zero,144(a5)

        uint64_t _sstatus = csr_read(sstatus);
ffffffe000200ca8:	100027f3          	csrr	a5,sstatus
ffffffe000200cac:	fcf43823          	sd	a5,-48(s0)
ffffffe000200cb0:	fd043783          	ld	a5,-48(s0)
ffffffe000200cb4:	fcf43423          	sd	a5,-56(s0)
        _sstatus &= ~(1 << 8); // set sstatus[SPP] = 0
ffffffe000200cb8:	fc843783          	ld	a5,-56(s0)
ffffffe000200cbc:	eff7f793          	andi	a5,a5,-257
ffffffe000200cc0:	fcf43423          	sd	a5,-56(s0)
        _sstatus |= 1 << 18;   // set sstatus[SUM] = 1
ffffffe000200cc4:	fc843703          	ld	a4,-56(s0)
ffffffe000200cc8:	000407b7          	lui	a5,0x40
ffffffe000200ccc:	00f767b3          	or	a5,a4,a5
ffffffe000200cd0:	fcf43423          	sd	a5,-56(s0)
        task[i]->thread.sstatus = _sstatus;
ffffffe000200cd4:	00008717          	auipc	a4,0x8
ffffffe000200cd8:	36470713          	addi	a4,a4,868 # ffffffe000209038 <task>
ffffffe000200cdc:	fdc42783          	lw	a5,-36(s0)
ffffffe000200ce0:	00379793          	slli	a5,a5,0x3
ffffffe000200ce4:	00f707b3          	add	a5,a4,a5
ffffffe000200ce8:	0007b783          	ld	a5,0(a5) # 40000 <PGSIZE+0x3f000>
ffffffe000200cec:	fc843703          	ld	a4,-56(s0)
ffffffe000200cf0:	08e7bc23          	sd	a4,152(a5)

        // sscratch 设置为 U-Mode 的 sp，其值为 USER_END
        task[i]->thread.sscratch = USER_END;
ffffffe000200cf4:	00008717          	auipc	a4,0x8
ffffffe000200cf8:	34470713          	addi	a4,a4,836 # ffffffe000209038 <task>
ffffffe000200cfc:	fdc42783          	lw	a5,-36(s0)
ffffffe000200d00:	00379793          	slli	a5,a5,0x3
ffffffe000200d04:	00f707b3          	add	a5,a4,a5
ffffffe000200d08:	0007b783          	ld	a5,0(a5)
ffffffe000200d0c:	00100713          	li	a4,1
ffffffe000200d10:	02671713          	slli	a4,a4,0x26
ffffffe000200d14:	0ae7b023          	sd	a4,160(a5)

        // 创建页表,复制内核页表
        task[i]->pgd = (uint64_t *)kalloc();
ffffffe000200d18:	00008717          	auipc	a4,0x8
ffffffe000200d1c:	32070713          	addi	a4,a4,800 # ffffffe000209038 <task>
ffffffe000200d20:	fdc42783          	lw	a5,-36(s0)
ffffffe000200d24:	00379793          	slli	a5,a5,0x3
ffffffe000200d28:	00f707b3          	add	a5,a4,a5
ffffffe000200d2c:	0007b483          	ld	s1,0(a5)
ffffffe000200d30:	c55ff0ef          	jal	ffffffe000200984 <kalloc>
ffffffe000200d34:	00050793          	mv	a5,a0
ffffffe000200d38:	0af4b823          	sd	a5,176(s1)
        memcpy(task[i]->pgd, swapper_pg_dir, PGSIZE);
ffffffe000200d3c:	00008717          	auipc	a4,0x8
ffffffe000200d40:	2fc70713          	addi	a4,a4,764 # ffffffe000209038 <task>
ffffffe000200d44:	fdc42783          	lw	a5,-36(s0)
ffffffe000200d48:	00379793          	slli	a5,a5,0x3
ffffffe000200d4c:	00f707b3          	add	a5,a4,a5
ffffffe000200d50:	0007b783          	ld	a5,0(a5)
ffffffe000200d54:	0b07b783          	ld	a5,176(a5)
ffffffe000200d58:	00001637          	lui	a2,0x1
ffffffe000200d5c:	0000a597          	auipc	a1,0xa
ffffffe000200d60:	2a458593          	addi	a1,a1,676 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000200d64:	00078513          	mv	a0,a5
ffffffe000200d68:	581020ef          	jal	ffffffe000203ae8 <memcpy>
        page_deep_copy(task[i]->pgd);
ffffffe000200d6c:	00008717          	auipc	a4,0x8
ffffffe000200d70:	2cc70713          	addi	a4,a4,716 # ffffffe000209038 <task>
ffffffe000200d74:	fdc42783          	lw	a5,-36(s0)
ffffffe000200d78:	00379793          	slli	a5,a5,0x3
ffffffe000200d7c:	00f707b3          	add	a5,a4,a5
ffffffe000200d80:	0007b783          	ld	a5,0(a5)
ffffffe000200d84:	0b07b783          	ld	a5,176(a5)
ffffffe000200d88:	00078513          	mv	a0,a5
ffffffe000200d8c:	46d010ef          	jal	ffffffe0002029f8 <page_deep_copy>

        task[i]->mm = *(struct mm_struct *)kalloc();
ffffffe000200d90:	bf5ff0ef          	jal	ffffffe000200984 <kalloc>
ffffffe000200d94:	00050693          	mv	a3,a0
ffffffe000200d98:	00008717          	auipc	a4,0x8
ffffffe000200d9c:	2a070713          	addi	a4,a4,672 # ffffffe000209038 <task>
ffffffe000200da0:	fdc42783          	lw	a5,-36(s0)
ffffffe000200da4:	00379793          	slli	a5,a5,0x3
ffffffe000200da8:	00f707b3          	add	a5,a4,a5
ffffffe000200dac:	0007b783          	ld	a5,0(a5)
ffffffe000200db0:	0006b703          	ld	a4,0(a3)
ffffffe000200db4:	0ae7bc23          	sd	a4,184(a5)
        task[i]->mm.mmap = NULL;
ffffffe000200db8:	00008717          	auipc	a4,0x8
ffffffe000200dbc:	28070713          	addi	a4,a4,640 # ffffffe000209038 <task>
ffffffe000200dc0:	fdc42783          	lw	a5,-36(s0)
ffffffe000200dc4:	00379793          	slli	a5,a5,0x3
ffffffe000200dc8:	00f707b3          	add	a5,a4,a5
ffffffe000200dcc:	0007b783          	ld	a5,0(a5)
ffffffe000200dd0:	0a07bc23          	sd	zero,184(a5)
        // uint64_t* uapp_start = alloc_pages(uapp_pages);
        //  memcpy(uapp_start, _sramdisk, uapp_size);

        // create_mapping(task[i]->pgd, (uint64_t)USER_START, (uint64_t)(uapp_start) - PA2VA_OFFSET, (uint64_t)(uapp_pages * PGSIZE), 0x1f);

        load_program(task[i]);
ffffffe000200dd4:	00008717          	auipc	a4,0x8
ffffffe000200dd8:	26470713          	addi	a4,a4,612 # ffffffe000209038 <task>
ffffffe000200ddc:	fdc42783          	lw	a5,-36(s0)
ffffffe000200de0:	00379793          	slli	a5,a5,0x3
ffffffe000200de4:	00f707b3          	add	a5,a4,a5
ffffffe000200de8:	0007b783          	ld	a5,0(a5)
ffffffe000200dec:	00078513          	mv	a0,a5
ffffffe000200df0:	280000ef          	jal	ffffffe000201070 <load_program>

        // uint64_t *u_stack = kalloc();
        // create_mapping(task[i]->pgd, (uint64_t)(USER_END)-PGSIZE, (uint64_t)(u_stack)-PA2VA_OFFSET, PGSIZE, 0x17);
        do_mmap(&task[i]->mm, USER_END - PGSIZE, PGSIZE, 0, 0, VM_READ | VM_WRITE | VM_ANON);
ffffffe000200df4:	00008717          	auipc	a4,0x8
ffffffe000200df8:	24470713          	addi	a4,a4,580 # ffffffe000209038 <task>
ffffffe000200dfc:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e00:	00379793          	slli	a5,a5,0x3
ffffffe000200e04:	00f707b3          	add	a5,a4,a5
ffffffe000200e08:	0007b783          	ld	a5,0(a5)
ffffffe000200e0c:	0b878513          	addi	a0,a5,184
ffffffe000200e10:	00700793          	li	a5,7
ffffffe000200e14:	00000713          	li	a4,0
ffffffe000200e18:	00000693          	li	a3,0
ffffffe000200e1c:	00001637          	lui	a2,0x1
ffffffe000200e20:	040005b7          	lui	a1,0x4000
ffffffe000200e24:	fff58593          	addi	a1,a1,-1 # 3ffffff <OPENSBI_SIZE+0x3dfffff>
ffffffe000200e28:	00c59593          	slli	a1,a1,0xc
ffffffe000200e2c:	148000ef          	jal	ffffffe000200f74 <do_mmap>

        uint64_t _satp = csr_read(satp);
ffffffe000200e30:	180027f3          	csrr	a5,satp
ffffffe000200e34:	fcf43023          	sd	a5,-64(s0)
ffffffe000200e38:	fc043783          	ld	a5,-64(s0)
ffffffe000200e3c:	faf43c23          	sd	a5,-72(s0)
        _satp = (_satp >> 44) << 44;
ffffffe000200e40:	fb843703          	ld	a4,-72(s0)
ffffffe000200e44:	fff00793          	li	a5,-1
ffffffe000200e48:	02c79793          	slli	a5,a5,0x2c
ffffffe000200e4c:	00f777b3          	and	a5,a4,a5
ffffffe000200e50:	faf43c23          	sd	a5,-72(s0)
        _satp |= (((uint64_t)(task[i]->pgd) - PA2VA_OFFSET) >> 12);
ffffffe000200e54:	00008717          	auipc	a4,0x8
ffffffe000200e58:	1e470713          	addi	a4,a4,484 # ffffffe000209038 <task>
ffffffe000200e5c:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e60:	00379793          	slli	a5,a5,0x3
ffffffe000200e64:	00f707b3          	add	a5,a4,a5
ffffffe000200e68:	0007b783          	ld	a5,0(a5)
ffffffe000200e6c:	0b07b783          	ld	a5,176(a5)
ffffffe000200e70:	00078713          	mv	a4,a5
ffffffe000200e74:	04100793          	li	a5,65
ffffffe000200e78:	01f79793          	slli	a5,a5,0x1f
ffffffe000200e7c:	00f707b3          	add	a5,a4,a5
ffffffe000200e80:	00c7d793          	srli	a5,a5,0xc
ffffffe000200e84:	fb843703          	ld	a4,-72(s0)
ffffffe000200e88:	00f767b3          	or	a5,a4,a5
ffffffe000200e8c:	faf43c23          	sd	a5,-72(s0)
        task[i]->thread.satp = _satp;
ffffffe000200e90:	00008717          	auipc	a4,0x8
ffffffe000200e94:	1a870713          	addi	a4,a4,424 # ffffffe000209038 <task>
ffffffe000200e98:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e9c:	00379793          	slli	a5,a5,0x3
ffffffe000200ea0:	00f707b3          	add	a5,a4,a5
ffffffe000200ea4:	0007b783          	ld	a5,0(a5)
ffffffe000200ea8:	fb843703          	ld	a4,-72(s0)
ffffffe000200eac:	0ae7b423          	sd	a4,168(a5)
    for (int i = 1; i < 2; i++)
ffffffe000200eb0:	fdc42783          	lw	a5,-36(s0)
ffffffe000200eb4:	0017879b          	addiw	a5,a5,1
ffffffe000200eb8:	fcf42e23          	sw	a5,-36(s0)
ffffffe000200ebc:	fdc42783          	lw	a5,-36(s0)
ffffffe000200ec0:	0007871b          	sext.w	a4,a5
ffffffe000200ec4:	00100793          	li	a5,1
ffffffe000200ec8:	c8e7dce3          	bge	a5,a4,ffffffe000200b60 <task_init+0xd0>
    }
    nr_tasks = 2;
ffffffe000200ecc:	00008797          	auipc	a5,0x8
ffffffe000200ed0:	14c78793          	addi	a5,a5,332 # ffffffe000209018 <nr_tasks>
ffffffe000200ed4:	00200713          	li	a4,2
ffffffe000200ed8:	00e7b023          	sd	a4,0(a5)

    printk("...task_init done!\n");
ffffffe000200edc:	00003517          	auipc	a0,0x3
ffffffe000200ee0:	15c50513          	addi	a0,a0,348 # ffffffe000204038 <__func__.0+0x38>
ffffffe000200ee4:	275020ef          	jal	ffffffe000203958 <printk>
}
ffffffe000200ee8:	00000013          	nop
ffffffe000200eec:	04813083          	ld	ra,72(sp)
ffffffe000200ef0:	04013403          	ld	s0,64(sp)
ffffffe000200ef4:	03813483          	ld	s1,56(sp)
ffffffe000200ef8:	05010113          	addi	sp,sp,80
ffffffe000200efc:	00008067          	ret

ffffffe000200f00 <find_vma>:

struct vm_area_struct *find_vma(struct mm_struct *mm, uint64_t addr)
{
ffffffe000200f00:	fd010113          	addi	sp,sp,-48
ffffffe000200f04:	02813423          	sd	s0,40(sp)
ffffffe000200f08:	03010413          	addi	s0,sp,48
ffffffe000200f0c:	fca43c23          	sd	a0,-40(s0)
ffffffe000200f10:	fcb43823          	sd	a1,-48(s0)
    struct vm_area_struct *vma = mm->mmap;
ffffffe000200f14:	fd843783          	ld	a5,-40(s0)
ffffffe000200f18:	0007b783          	ld	a5,0(a5)
ffffffe000200f1c:	fef43423          	sd	a5,-24(s0)
    while (vma)
ffffffe000200f20:	0380006f          	j	ffffffe000200f58 <find_vma+0x58>
    {
        if (addr >= vma->vm_start && addr < vma->vm_end)
ffffffe000200f24:	fe843783          	ld	a5,-24(s0)
ffffffe000200f28:	0087b783          	ld	a5,8(a5)
ffffffe000200f2c:	fd043703          	ld	a4,-48(s0)
ffffffe000200f30:	00f76e63          	bltu	a4,a5,ffffffe000200f4c <find_vma+0x4c>
ffffffe000200f34:	fe843783          	ld	a5,-24(s0)
ffffffe000200f38:	0107b783          	ld	a5,16(a5)
ffffffe000200f3c:	fd043703          	ld	a4,-48(s0)
ffffffe000200f40:	00f77663          	bgeu	a4,a5,ffffffe000200f4c <find_vma+0x4c>
        {
            return vma;
ffffffe000200f44:	fe843783          	ld	a5,-24(s0)
ffffffe000200f48:	01c0006f          	j	ffffffe000200f64 <find_vma+0x64>
        }
        vma = vma->vm_next;
ffffffe000200f4c:	fe843783          	ld	a5,-24(s0)
ffffffe000200f50:	0187b783          	ld	a5,24(a5)
ffffffe000200f54:	fef43423          	sd	a5,-24(s0)
    while (vma)
ffffffe000200f58:	fe843783          	ld	a5,-24(s0)
ffffffe000200f5c:	fc0794e3          	bnez	a5,ffffffe000200f24 <find_vma+0x24>
    }
    return NULL;
ffffffe000200f60:	00000793          	li	a5,0
}
ffffffe000200f64:	00078513          	mv	a0,a5
ffffffe000200f68:	02813403          	ld	s0,40(sp)
ffffffe000200f6c:	03010113          	addi	sp,sp,48
ffffffe000200f70:	00008067          	ret

ffffffe000200f74 <do_mmap>:

uint64_t do_mmap(struct mm_struct *mm, uint64_t addr, uint64_t len, uint64_t vm_pgoff, uint64_t vm_filesz, uint64_t flags)
{
ffffffe000200f74:	fa010113          	addi	sp,sp,-96
ffffffe000200f78:	04113c23          	sd	ra,88(sp)
ffffffe000200f7c:	04813823          	sd	s0,80(sp)
ffffffe000200f80:	06010413          	addi	s0,sp,96
ffffffe000200f84:	fca43423          	sd	a0,-56(s0)
ffffffe000200f88:	fcb43023          	sd	a1,-64(s0)
ffffffe000200f8c:	fac43c23          	sd	a2,-72(s0)
ffffffe000200f90:	fad43823          	sd	a3,-80(s0)
ffffffe000200f94:	fae43423          	sd	a4,-88(s0)
ffffffe000200f98:	faf43023          	sd	a5,-96(s0)
    uint64_t start = PGROUNDDOWN(addr);
ffffffe000200f9c:	fc043703          	ld	a4,-64(s0)
ffffffe000200fa0:	fffff7b7          	lui	a5,0xfffff
ffffffe000200fa4:	00f777b3          	and	a5,a4,a5
ffffffe000200fa8:	fef43423          	sd	a5,-24(s0)
    uint64_t end = PGROUNDUP(start + len);
ffffffe000200fac:	fe843703          	ld	a4,-24(s0)
ffffffe000200fb0:	fb843783          	ld	a5,-72(s0)
ffffffe000200fb4:	00f70733          	add	a4,a4,a5
ffffffe000200fb8:	000017b7          	lui	a5,0x1
ffffffe000200fbc:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200fc0:	00f70733          	add	a4,a4,a5
ffffffe000200fc4:	fffff7b7          	lui	a5,0xfffff
ffffffe000200fc8:	00f777b3          	and	a5,a4,a5
ffffffe000200fcc:	fef43023          	sd	a5,-32(s0)
    //         end = PGROUNDUP(start + len);
    //         break;
    //     }
    // }

    struct vm_area_struct *vma = (struct vm_area_struct *)kalloc();
ffffffe000200fd0:	9b5ff0ef          	jal	ffffffe000200984 <kalloc>
ffffffe000200fd4:	fca43c23          	sd	a0,-40(s0)
    vma->vm_mm = mm;
ffffffe000200fd8:	fd843783          	ld	a5,-40(s0)
ffffffe000200fdc:	fc843703          	ld	a4,-56(s0)
ffffffe000200fe0:	00e7b023          	sd	a4,0(a5) # fffffffffffff000 <VM_END+0xfffff000>
    vma->vm_start = start;
ffffffe000200fe4:	fd843783          	ld	a5,-40(s0)
ffffffe000200fe8:	fe843703          	ld	a4,-24(s0)
ffffffe000200fec:	00e7b423          	sd	a4,8(a5)
    // vma->vm_start = addr;
    vma->vm_end = end;
ffffffe000200ff0:	fd843783          	ld	a5,-40(s0)
ffffffe000200ff4:	fe043703          	ld	a4,-32(s0)
ffffffe000200ff8:	00e7b823          	sd	a4,16(a5)
    // vma->vm_end = addr + len;
    vma->vm_next = mm->mmap;
ffffffe000200ffc:	fc843783          	ld	a5,-56(s0)
ffffffe000201000:	0007b703          	ld	a4,0(a5)
ffffffe000201004:	fd843783          	ld	a5,-40(s0)
ffffffe000201008:	00e7bc23          	sd	a4,24(a5)
    vma->vm_flags = flags;
ffffffe00020100c:	fd843783          	ld	a5,-40(s0)
ffffffe000201010:	fa043703          	ld	a4,-96(s0)
ffffffe000201014:	02e7b423          	sd	a4,40(a5)
    vma->vm_pgoff = vm_pgoff;
ffffffe000201018:	fd843783          	ld	a5,-40(s0)
ffffffe00020101c:	fb043703          	ld	a4,-80(s0)
ffffffe000201020:	02e7b823          	sd	a4,48(a5)
    vma->vm_filesz = vm_filesz;
ffffffe000201024:	fd843783          	ld	a5,-40(s0)
ffffffe000201028:	fa843703          	ld	a4,-88(s0)
ffffffe00020102c:	02e7bc23          	sd	a4,56(a5)
    if (mm->mmap != NULL)
ffffffe000201030:	fc843783          	ld	a5,-56(s0)
ffffffe000201034:	0007b783          	ld	a5,0(a5)
ffffffe000201038:	00078a63          	beqz	a5,ffffffe00020104c <do_mmap+0xd8>
        mm->mmap->vm_prev = vma;
ffffffe00020103c:	fc843783          	ld	a5,-56(s0)
ffffffe000201040:	0007b783          	ld	a5,0(a5)
ffffffe000201044:	fd843703          	ld	a4,-40(s0)
ffffffe000201048:	02e7b023          	sd	a4,32(a5)
    mm->mmap = vma;
ffffffe00020104c:	fc843783          	ld	a5,-56(s0)
ffffffe000201050:	fd843703          	ld	a4,-40(s0)
ffffffe000201054:	00e7b023          	sd	a4,0(a5)
    return addr;
ffffffe000201058:	fc043783          	ld	a5,-64(s0)
}
ffffffe00020105c:	00078513          	mv	a0,a5
ffffffe000201060:	05813083          	ld	ra,88(sp)
ffffffe000201064:	05013403          	ld	s0,80(sp)
ffffffe000201068:	06010113          	addi	sp,sp,96
ffffffe00020106c:	00008067          	ret

ffffffe000201070 <load_program>:
//     // 如果没有找到合适的地址范围，返回失败值
//     return 0;
// }

void load_program(struct task_struct *task)
{
ffffffe000201070:	f8010113          	addi	sp,sp,-128
ffffffe000201074:	06113c23          	sd	ra,120(sp)
ffffffe000201078:	06813823          	sd	s0,112(sp)
ffffffe00020107c:	08010413          	addi	s0,sp,128
ffffffe000201080:	f8a43c23          	sd	a0,-104(s0)
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)_sramdisk;
ffffffe000201084:	00005797          	auipc	a5,0x5
ffffffe000201088:	f7c78793          	addi	a5,a5,-132 # ffffffe000206000 <_sramdisk>
ffffffe00020108c:	fef43023          	sd	a5,-32(s0)
    Elf64_Phdr *phdrs = (Elf64_Phdr *)(_sramdisk + ehdr->e_phoff);
ffffffe000201090:	fe043783          	ld	a5,-32(s0)
ffffffe000201094:	0207b703          	ld	a4,32(a5)
ffffffe000201098:	00005797          	auipc	a5,0x5
ffffffe00020109c:	f6878793          	addi	a5,a5,-152 # ffffffe000206000 <_sramdisk>
ffffffe0002010a0:	00f707b3          	add	a5,a4,a5
ffffffe0002010a4:	fcf43c23          	sd	a5,-40(s0)
    for (int i = 0; i < ehdr->e_phnum; ++i)
ffffffe0002010a8:	fe042623          	sw	zero,-20(s0)
ffffffe0002010ac:	10c0006f          	j	ffffffe0002011b8 <load_program+0x148>
    {
        Elf64_Phdr *phdr = phdrs + i;
ffffffe0002010b0:	fec42703          	lw	a4,-20(s0)
ffffffe0002010b4:	00070793          	mv	a5,a4
ffffffe0002010b8:	00379793          	slli	a5,a5,0x3
ffffffe0002010bc:	40e787b3          	sub	a5,a5,a4
ffffffe0002010c0:	00379793          	slli	a5,a5,0x3
ffffffe0002010c4:	00078713          	mv	a4,a5
ffffffe0002010c8:	fd843783          	ld	a5,-40(s0)
ffffffe0002010cc:	00e787b3          	add	a5,a5,a4
ffffffe0002010d0:	fcf43823          	sd	a5,-48(s0)
        if (phdr->p_type == PT_LOAD)
ffffffe0002010d4:	fd043783          	ld	a5,-48(s0)
ffffffe0002010d8:	0007a783          	lw	a5,0(a5)
ffffffe0002010dc:	00078713          	mv	a4,a5
ffffffe0002010e0:	00100793          	li	a5,1
ffffffe0002010e4:	0cf71463          	bne	a4,a5,ffffffe0002011ac <load_program+0x13c>
        {
            uint64_t va = phdr->p_vaddr;
ffffffe0002010e8:	fd043783          	ld	a5,-48(s0)
ffffffe0002010ec:	0107b783          	ld	a5,16(a5)
ffffffe0002010f0:	fcf43423          	sd	a5,-56(s0)
            uint64_t offset = phdr->p_offset;
ffffffe0002010f4:	fd043783          	ld	a5,-48(s0)
ffffffe0002010f8:	0087b783          	ld	a5,8(a5)
ffffffe0002010fc:	fcf43023          	sd	a5,-64(s0)
            uint64_t fileSize = phdr->p_filesz;
ffffffe000201100:	fd043783          	ld	a5,-48(s0)
ffffffe000201104:	0207b783          	ld	a5,32(a5)
ffffffe000201108:	faf43c23          	sd	a5,-72(s0)
            uint64_t memSize = phdr->p_memsz;
ffffffe00020110c:	fd043783          	ld	a5,-48(s0)
ffffffe000201110:	0287b783          	ld	a5,40(a5)
ffffffe000201114:	faf43823          	sd	a5,-80(s0)
            // uint64_t flags = (phdr->p_flags << 1) | 0x11;
            uint64_t flags = phdr->p_flags;
ffffffe000201118:	fd043783          	ld	a5,-48(s0)
ffffffe00020111c:	0047a783          	lw	a5,4(a5)
ffffffe000201120:	02079793          	slli	a5,a5,0x20
ffffffe000201124:	0207d793          	srli	a5,a5,0x20
ffffffe000201128:	faf43423          	sd	a5,-88(s0)
            uint64_t pageOffset = va & (PGSIZE - 1);
ffffffe00020112c:	fc843703          	ld	a4,-56(s0)
ffffffe000201130:	000017b7          	lui	a5,0x1
ffffffe000201134:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000201138:	00f777b3          	and	a5,a4,a5
ffffffe00020113c:	faf43023          	sd	a5,-96(s0)

            // memset(copyPages, 0, (pageOffset + memSize + PGSIZE - 1) / PGSIZE * PGSIZE);
            // memcpy((uint64_t *)(copyPages + pageOffset), segmentStart, fileSize);

            // create_mapping(task->pgd, va, copyPages + pageOffset - PA2VA_OFFSET, memSize, flags);
            Log("va: %lx, offset: %lx, fileSize: %lx, memSize: %lx, flags: %lx", va, offset, fileSize, memSize, flags);
ffffffe000201140:	fa843783          	ld	a5,-88(s0)
ffffffe000201144:	00f13023          	sd	a5,0(sp)
ffffffe000201148:	fb043883          	ld	a7,-80(s0)
ffffffe00020114c:	fb843803          	ld	a6,-72(s0)
ffffffe000201150:	fc043783          	ld	a5,-64(s0)
ffffffe000201154:	fc843703          	ld	a4,-56(s0)
ffffffe000201158:	00003697          	auipc	a3,0x3
ffffffe00020115c:	fd868693          	addi	a3,a3,-40 # ffffffe000204130 <__func__.0>
ffffffe000201160:	0cf00613          	li	a2,207
ffffffe000201164:	00003597          	auipc	a1,0x3
ffffffe000201168:	eec58593          	addi	a1,a1,-276 # ffffffe000204050 <__func__.0+0x50>
ffffffe00020116c:	00003517          	auipc	a0,0x3
ffffffe000201170:	eec50513          	addi	a0,a0,-276 # ffffffe000204058 <__func__.0+0x58>
ffffffe000201174:	7e4020ef          	jal	ffffffe000203958 <printk>
            do_mmap(&task->mm, va, memSize, offset - pageOffset, fileSize + pageOffset, flags << 1);
ffffffe000201178:	f9843783          	ld	a5,-104(s0)
ffffffe00020117c:	0b878513          	addi	a0,a5,184
ffffffe000201180:	fc043703          	ld	a4,-64(s0)
ffffffe000201184:	fa043783          	ld	a5,-96(s0)
ffffffe000201188:	40f706b3          	sub	a3,a4,a5
ffffffe00020118c:	fb843703          	ld	a4,-72(s0)
ffffffe000201190:	fa043783          	ld	a5,-96(s0)
ffffffe000201194:	00f70733          	add	a4,a4,a5
ffffffe000201198:	fa843783          	ld	a5,-88(s0)
ffffffe00020119c:	00179793          	slli	a5,a5,0x1
ffffffe0002011a0:	fb043603          	ld	a2,-80(s0)
ffffffe0002011a4:	fc843583          	ld	a1,-56(s0)
ffffffe0002011a8:	dcdff0ef          	jal	ffffffe000200f74 <do_mmap>
    for (int i = 0; i < ehdr->e_phnum; ++i)
ffffffe0002011ac:	fec42783          	lw	a5,-20(s0)
ffffffe0002011b0:	0017879b          	addiw	a5,a5,1
ffffffe0002011b4:	fef42623          	sw	a5,-20(s0)
ffffffe0002011b8:	fe043783          	ld	a5,-32(s0)
ffffffe0002011bc:	0387d783          	lhu	a5,56(a5)
ffffffe0002011c0:	0007871b          	sext.w	a4,a5
ffffffe0002011c4:	fec42783          	lw	a5,-20(s0)
ffffffe0002011c8:	0007879b          	sext.w	a5,a5
ffffffe0002011cc:	eee7c2e3          	blt	a5,a4,ffffffe0002010b0 <load_program+0x40>
        }
    }
    task->thread.sepc = ehdr->e_entry;
ffffffe0002011d0:	fe043783          	ld	a5,-32(s0)
ffffffe0002011d4:	0187b703          	ld	a4,24(a5)
ffffffe0002011d8:	f9843783          	ld	a5,-104(s0)
ffffffe0002011dc:	08e7b823          	sd	a4,144(a5)
    printk("load program done!\n");
ffffffe0002011e0:	00003517          	auipc	a0,0x3
ffffffe0002011e4:	ed050513          	addi	a0,a0,-304 # ffffffe0002040b0 <__func__.0+0xb0>
ffffffe0002011e8:	770020ef          	jal	ffffffe000203958 <printk>
}
ffffffe0002011ec:	00000013          	nop
ffffffe0002011f0:	07813083          	ld	ra,120(sp)
ffffffe0002011f4:	07013403          	ld	s0,112(sp)
ffffffe0002011f8:	08010113          	addi	sp,sp,128
ffffffe0002011fc:	00008067          	ret

ffffffe000201200 <switch_to>:

void switch_to(struct task_struct *next)
{
ffffffe000201200:	fd010113          	addi	sp,sp,-48
ffffffe000201204:	02113423          	sd	ra,40(sp)
ffffffe000201208:	02813023          	sd	s0,32(sp)
ffffffe00020120c:	03010413          	addi	s0,sp,48
ffffffe000201210:	fca43c23          	sd	a0,-40(s0)
    // 判断 next 是否与当前线程 current 相同
    if (next != current)
ffffffe000201214:	00008797          	auipc	a5,0x8
ffffffe000201218:	dfc78793          	addi	a5,a5,-516 # ffffffe000209010 <current>
ffffffe00020121c:	0007b783          	ld	a5,0(a5)
ffffffe000201220:	fd843703          	ld	a4,-40(s0)
ffffffe000201224:	04f70e63          	beq	a4,a5,ffffffe000201280 <switch_to+0x80>
    {

        // 调用 __switch_to 进行线程切换
        struct task_struct *prev = current; // 保存当前线程
ffffffe000201228:	00008797          	auipc	a5,0x8
ffffffe00020122c:	de878793          	addi	a5,a5,-536 # ffffffe000209010 <current>
ffffffe000201230:	0007b783          	ld	a5,0(a5)
ffffffe000201234:	fef43423          	sd	a5,-24(s0)
        current = next;                     // 更新当前线程为 next
ffffffe000201238:	00008797          	auipc	a5,0x8
ffffffe00020123c:	dd878793          	addi	a5,a5,-552 # ffffffe000209010 <current>
ffffffe000201240:	fd843703          	ld	a4,-40(s0)
ffffffe000201244:	00e7b023          	sd	a4,0(a5)
        printk("\nswitch to [PID = %d PRIORITY = %d COUNTER = %d]\n", next->pid, next->priority, next->counter);
ffffffe000201248:	fd843783          	ld	a5,-40(s0)
ffffffe00020124c:	0187b703          	ld	a4,24(a5)
ffffffe000201250:	fd843783          	ld	a5,-40(s0)
ffffffe000201254:	0107b603          	ld	a2,16(a5)
ffffffe000201258:	fd843783          	ld	a5,-40(s0)
ffffffe00020125c:	0087b783          	ld	a5,8(a5)
ffffffe000201260:	00078693          	mv	a3,a5
ffffffe000201264:	00070593          	mv	a1,a4
ffffffe000201268:	00003517          	auipc	a0,0x3
ffffffe00020126c:	e6050513          	addi	a0,a0,-416 # ffffffe0002040c8 <__func__.0+0xc8>
ffffffe000201270:	6e8020ef          	jal	ffffffe000203958 <printk>
        __switch_to(prev, next); // 执行线程切换
ffffffe000201274:	fd843583          	ld	a1,-40(s0)
ffffffe000201278:	fe843503          	ld	a0,-24(s0)
ffffffe00020127c:	f51fe0ef          	jal	ffffffe0002001cc <__switch_to>
    }
}
ffffffe000201280:	00000013          	nop
ffffffe000201284:	02813083          	ld	ra,40(sp)
ffffffe000201288:	02013403          	ld	s0,32(sp)
ffffffe00020128c:	03010113          	addi	sp,sp,48
ffffffe000201290:	00008067          	ret

ffffffe000201294 <do_timer>:

void do_timer()
{
ffffffe000201294:	ff010113          	addi	sp,sp,-16
ffffffe000201298:	00113423          	sd	ra,8(sp)
ffffffe00020129c:	00813023          	sd	s0,0(sp)
ffffffe0002012a0:	01010413          	addi	s0,sp,16
    if (current == idle || current->counter <= 0)
ffffffe0002012a4:	00008797          	auipc	a5,0x8
ffffffe0002012a8:	d6c78793          	addi	a5,a5,-660 # ffffffe000209010 <current>
ffffffe0002012ac:	0007b703          	ld	a4,0(a5)
ffffffe0002012b0:	00008797          	auipc	a5,0x8
ffffffe0002012b4:	d5878793          	addi	a5,a5,-680 # ffffffe000209008 <idle>
ffffffe0002012b8:	0007b783          	ld	a5,0(a5)
ffffffe0002012bc:	00f70c63          	beq	a4,a5,ffffffe0002012d4 <do_timer+0x40>
ffffffe0002012c0:	00008797          	auipc	a5,0x8
ffffffe0002012c4:	d5078793          	addi	a5,a5,-688 # ffffffe000209010 <current>
ffffffe0002012c8:	0007b783          	ld	a5,0(a5)
ffffffe0002012cc:	0087b783          	ld	a5,8(a5)
ffffffe0002012d0:	00079663          	bnez	a5,ffffffe0002012dc <do_timer+0x48>
    {
        schedule();
ffffffe0002012d4:	04c000ef          	jal	ffffffe000201320 <schedule>
        if (current->counter <= 0)
        {
            schedule();
        }
    }
}
ffffffe0002012d8:	0340006f          	j	ffffffe00020130c <do_timer+0x78>
        current->counter--;
ffffffe0002012dc:	00008797          	auipc	a5,0x8
ffffffe0002012e0:	d3478793          	addi	a5,a5,-716 # ffffffe000209010 <current>
ffffffe0002012e4:	0007b783          	ld	a5,0(a5)
ffffffe0002012e8:	0087b703          	ld	a4,8(a5)
ffffffe0002012ec:	fff70713          	addi	a4,a4,-1
ffffffe0002012f0:	00e7b423          	sd	a4,8(a5)
        if (current->counter <= 0)
ffffffe0002012f4:	00008797          	auipc	a5,0x8
ffffffe0002012f8:	d1c78793          	addi	a5,a5,-740 # ffffffe000209010 <current>
ffffffe0002012fc:	0007b783          	ld	a5,0(a5)
ffffffe000201300:	0087b783          	ld	a5,8(a5)
ffffffe000201304:	00079463          	bnez	a5,ffffffe00020130c <do_timer+0x78>
            schedule();
ffffffe000201308:	018000ef          	jal	ffffffe000201320 <schedule>
}
ffffffe00020130c:	00000013          	nop
ffffffe000201310:	00813083          	ld	ra,8(sp)
ffffffe000201314:	00013403          	ld	s0,0(sp)
ffffffe000201318:	01010113          	addi	sp,sp,16
ffffffe00020131c:	00008067          	ret

ffffffe000201320 <schedule>:

void schedule()
{
ffffffe000201320:	fd010113          	addi	sp,sp,-48
ffffffe000201324:	02113423          	sd	ra,40(sp)
ffffffe000201328:	02813023          	sd	s0,32(sp)
ffffffe00020132c:	03010413          	addi	s0,sp,48
    struct task_struct *next = NULL;
ffffffe000201330:	fe043423          	sd	zero,-24(s0)
    uint64_t max_counter = 0;
ffffffe000201334:	fe043023          	sd	zero,-32(s0)
    // 调度时选择 counter 最大的线程运行
    for (int i = 1; i < nr_tasks; i++)
ffffffe000201338:	00100793          	li	a5,1
ffffffe00020133c:	fcf42e23          	sw	a5,-36(s0)
ffffffe000201340:	08c0006f          	j	ffffffe0002013cc <schedule+0xac>
    {
        if (task[i] != NULL)
ffffffe000201344:	00008717          	auipc	a4,0x8
ffffffe000201348:	cf470713          	addi	a4,a4,-780 # ffffffe000209038 <task>
ffffffe00020134c:	fdc42783          	lw	a5,-36(s0)
ffffffe000201350:	00379793          	slli	a5,a5,0x3
ffffffe000201354:	00f707b3          	add	a5,a4,a5
ffffffe000201358:	0007b783          	ld	a5,0(a5)
ffffffe00020135c:	06078263          	beqz	a5,ffffffe0002013c0 <schedule+0xa0>
        {
            if (task[i]->counter > max_counter)
ffffffe000201360:	00008717          	auipc	a4,0x8
ffffffe000201364:	cd870713          	addi	a4,a4,-808 # ffffffe000209038 <task>
ffffffe000201368:	fdc42783          	lw	a5,-36(s0)
ffffffe00020136c:	00379793          	slli	a5,a5,0x3
ffffffe000201370:	00f707b3          	add	a5,a4,a5
ffffffe000201374:	0007b783          	ld	a5,0(a5)
ffffffe000201378:	0087b783          	ld	a5,8(a5)
ffffffe00020137c:	fe043703          	ld	a4,-32(s0)
ffffffe000201380:	04f77063          	bgeu	a4,a5,ffffffe0002013c0 <schedule+0xa0>
            {
                max_counter = task[i]->counter;
ffffffe000201384:	00008717          	auipc	a4,0x8
ffffffe000201388:	cb470713          	addi	a4,a4,-844 # ffffffe000209038 <task>
ffffffe00020138c:	fdc42783          	lw	a5,-36(s0)
ffffffe000201390:	00379793          	slli	a5,a5,0x3
ffffffe000201394:	00f707b3          	add	a5,a4,a5
ffffffe000201398:	0007b783          	ld	a5,0(a5)
ffffffe00020139c:	0087b783          	ld	a5,8(a5)
ffffffe0002013a0:	fef43023          	sd	a5,-32(s0)
                next = task[i];
ffffffe0002013a4:	00008717          	auipc	a4,0x8
ffffffe0002013a8:	c9470713          	addi	a4,a4,-876 # ffffffe000209038 <task>
ffffffe0002013ac:	fdc42783          	lw	a5,-36(s0)
ffffffe0002013b0:	00379793          	slli	a5,a5,0x3
ffffffe0002013b4:	00f707b3          	add	a5,a4,a5
ffffffe0002013b8:	0007b783          	ld	a5,0(a5)
ffffffe0002013bc:	fef43423          	sd	a5,-24(s0)
    for (int i = 1; i < nr_tasks; i++)
ffffffe0002013c0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002013c4:	0017879b          	addiw	a5,a5,1
ffffffe0002013c8:	fcf42e23          	sw	a5,-36(s0)
ffffffe0002013cc:	fdc42703          	lw	a4,-36(s0)
ffffffe0002013d0:	00008797          	auipc	a5,0x8
ffffffe0002013d4:	c4878793          	addi	a5,a5,-952 # ffffffe000209018 <nr_tasks>
ffffffe0002013d8:	0007b783          	ld	a5,0(a5)
ffffffe0002013dc:	f6f764e3          	bltu	a4,a5,ffffffe000201344 <schedule+0x24>
            }
        }
    }
    // 如果所有线程 counter 都为 0，则令所有线程 counter = priority
    if (next == NULL || max_counter <= 0)
ffffffe0002013e0:	fe843783          	ld	a5,-24(s0)
ffffffe0002013e4:	00078663          	beqz	a5,ffffffe0002013f0 <schedule+0xd0>
ffffffe0002013e8:	fe043783          	ld	a5,-32(s0)
ffffffe0002013ec:	12079863          	bnez	a5,ffffffe00020151c <schedule+0x1fc>
    {
        for (int i = 1; i < nr_tasks; i++)
ffffffe0002013f0:	00100793          	li	a5,1
ffffffe0002013f4:	fcf42c23          	sw	a5,-40(s0)
ffffffe0002013f8:	0640006f          	j	ffffffe00020145c <schedule+0x13c>
        {
            if (task[i] != NULL)
ffffffe0002013fc:	00008717          	auipc	a4,0x8
ffffffe000201400:	c3c70713          	addi	a4,a4,-964 # ffffffe000209038 <task>
ffffffe000201404:	fd842783          	lw	a5,-40(s0)
ffffffe000201408:	00379793          	slli	a5,a5,0x3
ffffffe00020140c:	00f707b3          	add	a5,a4,a5
ffffffe000201410:	0007b783          	ld	a5,0(a5)
ffffffe000201414:	02078e63          	beqz	a5,ffffffe000201450 <schedule+0x130>
            {
                task[i]->counter = task[i]->priority;
ffffffe000201418:	00008717          	auipc	a4,0x8
ffffffe00020141c:	c2070713          	addi	a4,a4,-992 # ffffffe000209038 <task>
ffffffe000201420:	fd842783          	lw	a5,-40(s0)
ffffffe000201424:	00379793          	slli	a5,a5,0x3
ffffffe000201428:	00f707b3          	add	a5,a4,a5
ffffffe00020142c:	0007b703          	ld	a4,0(a5)
ffffffe000201430:	00008697          	auipc	a3,0x8
ffffffe000201434:	c0868693          	addi	a3,a3,-1016 # ffffffe000209038 <task>
ffffffe000201438:	fd842783          	lw	a5,-40(s0)
ffffffe00020143c:	00379793          	slli	a5,a5,0x3
ffffffe000201440:	00f687b3          	add	a5,a3,a5
ffffffe000201444:	0007b783          	ld	a5,0(a5)
ffffffe000201448:	01073703          	ld	a4,16(a4)
ffffffe00020144c:	00e7b423          	sd	a4,8(a5)
        for (int i = 1; i < nr_tasks; i++)
ffffffe000201450:	fd842783          	lw	a5,-40(s0)
ffffffe000201454:	0017879b          	addiw	a5,a5,1
ffffffe000201458:	fcf42c23          	sw	a5,-40(s0)
ffffffe00020145c:	fd842703          	lw	a4,-40(s0)
ffffffe000201460:	00008797          	auipc	a5,0x8
ffffffe000201464:	bb878793          	addi	a5,a5,-1096 # ffffffe000209018 <nr_tasks>
ffffffe000201468:	0007b783          	ld	a5,0(a5)
ffffffe00020146c:	f8f768e3          	bltu	a4,a5,ffffffe0002013fc <schedule+0xdc>
            }
        }
        max_counter = 0;
ffffffe000201470:	fe043023          	sd	zero,-32(s0)
        // 设置完后需要重新进行调度
        for (int i = 1; i < nr_tasks; i++)
ffffffe000201474:	00100793          	li	a5,1
ffffffe000201478:	fcf42a23          	sw	a5,-44(s0)
ffffffe00020147c:	08c0006f          	j	ffffffe000201508 <schedule+0x1e8>
        {
            if (task[i] != NULL && task[i]->counter > max_counter)
ffffffe000201480:	00008717          	auipc	a4,0x8
ffffffe000201484:	bb870713          	addi	a4,a4,-1096 # ffffffe000209038 <task>
ffffffe000201488:	fd442783          	lw	a5,-44(s0)
ffffffe00020148c:	00379793          	slli	a5,a5,0x3
ffffffe000201490:	00f707b3          	add	a5,a4,a5
ffffffe000201494:	0007b783          	ld	a5,0(a5)
ffffffe000201498:	06078263          	beqz	a5,ffffffe0002014fc <schedule+0x1dc>
ffffffe00020149c:	00008717          	auipc	a4,0x8
ffffffe0002014a0:	b9c70713          	addi	a4,a4,-1124 # ffffffe000209038 <task>
ffffffe0002014a4:	fd442783          	lw	a5,-44(s0)
ffffffe0002014a8:	00379793          	slli	a5,a5,0x3
ffffffe0002014ac:	00f707b3          	add	a5,a4,a5
ffffffe0002014b0:	0007b783          	ld	a5,0(a5)
ffffffe0002014b4:	0087b783          	ld	a5,8(a5)
ffffffe0002014b8:	fe043703          	ld	a4,-32(s0)
ffffffe0002014bc:	04f77063          	bgeu	a4,a5,ffffffe0002014fc <schedule+0x1dc>
            {
                max_counter = task[i]->counter;
ffffffe0002014c0:	00008717          	auipc	a4,0x8
ffffffe0002014c4:	b7870713          	addi	a4,a4,-1160 # ffffffe000209038 <task>
ffffffe0002014c8:	fd442783          	lw	a5,-44(s0)
ffffffe0002014cc:	00379793          	slli	a5,a5,0x3
ffffffe0002014d0:	00f707b3          	add	a5,a4,a5
ffffffe0002014d4:	0007b783          	ld	a5,0(a5)
ffffffe0002014d8:	0087b783          	ld	a5,8(a5)
ffffffe0002014dc:	fef43023          	sd	a5,-32(s0)
                next = task[i];
ffffffe0002014e0:	00008717          	auipc	a4,0x8
ffffffe0002014e4:	b5870713          	addi	a4,a4,-1192 # ffffffe000209038 <task>
ffffffe0002014e8:	fd442783          	lw	a5,-44(s0)
ffffffe0002014ec:	00379793          	slli	a5,a5,0x3
ffffffe0002014f0:	00f707b3          	add	a5,a4,a5
ffffffe0002014f4:	0007b783          	ld	a5,0(a5)
ffffffe0002014f8:	fef43423          	sd	a5,-24(s0)
        for (int i = 1; i < nr_tasks; i++)
ffffffe0002014fc:	fd442783          	lw	a5,-44(s0)
ffffffe000201500:	0017879b          	addiw	a5,a5,1
ffffffe000201504:	fcf42a23          	sw	a5,-44(s0)
ffffffe000201508:	fd442703          	lw	a4,-44(s0)
ffffffe00020150c:	00008797          	auipc	a5,0x8
ffffffe000201510:	b0c78793          	addi	a5,a5,-1268 # ffffffe000209018 <nr_tasks>
ffffffe000201514:	0007b783          	ld	a5,0(a5)
ffffffe000201518:	f6f764e3          	bltu	a4,a5,ffffffe000201480 <schedule+0x160>
            }
        }
    }
    // 最后通过 switch_to 切换到下一个线程
    if (next != NULL && next != current)
ffffffe00020151c:	fe843783          	ld	a5,-24(s0)
ffffffe000201520:	02078063          	beqz	a5,ffffffe000201540 <schedule+0x220>
ffffffe000201524:	00008797          	auipc	a5,0x8
ffffffe000201528:	aec78793          	addi	a5,a5,-1300 # ffffffe000209010 <current>
ffffffe00020152c:	0007b783          	ld	a5,0(a5)
ffffffe000201530:	fe843703          	ld	a4,-24(s0)
ffffffe000201534:	00f70663          	beq	a4,a5,ffffffe000201540 <schedule+0x220>
    {
        switch_to(next);
ffffffe000201538:	fe843503          	ld	a0,-24(s0)
ffffffe00020153c:	cc5ff0ef          	jal	ffffffe000201200 <switch_to>
    }
}
ffffffe000201540:	00000013          	nop
ffffffe000201544:	02813083          	ld	ra,40(sp)
ffffffe000201548:	02013403          	ld	s0,32(sp)
ffffffe00020154c:	03010113          	addi	sp,sp,48
ffffffe000201550:	00008067          	ret

ffffffe000201554 <dummy>:
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy()
{
ffffffe000201554:	fd010113          	addi	sp,sp,-48
ffffffe000201558:	02113423          	sd	ra,40(sp)
ffffffe00020155c:	02813023          	sd	s0,32(sp)
ffffffe000201560:	03010413          	addi	s0,sp,48
    uint64_t MOD = 1000000007;
ffffffe000201564:	3b9ad7b7          	lui	a5,0x3b9ad
ffffffe000201568:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <PHY_SIZE+0x339aca07>
ffffffe00020156c:	fcf43c23          	sd	a5,-40(s0)
    uint64_t auto_inc_local_var = 0;
ffffffe000201570:	fe043423          	sd	zero,-24(s0)
    int last_counter = -1;
ffffffe000201574:	fff00793          	li	a5,-1
ffffffe000201578:	fef42223          	sw	a5,-28(s0)
    while (1)
    {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0)
ffffffe00020157c:	fe442783          	lw	a5,-28(s0)
ffffffe000201580:	0007871b          	sext.w	a4,a5
ffffffe000201584:	fff00793          	li	a5,-1
ffffffe000201588:	00f70e63          	beq	a4,a5,ffffffe0002015a4 <dummy+0x50>
ffffffe00020158c:	00008797          	auipc	a5,0x8
ffffffe000201590:	a8478793          	addi	a5,a5,-1404 # ffffffe000209010 <current>
ffffffe000201594:	0007b783          	ld	a5,0(a5)
ffffffe000201598:	0087b703          	ld	a4,8(a5)
ffffffe00020159c:	fe442783          	lw	a5,-28(s0)
ffffffe0002015a0:	fcf70ee3          	beq	a4,a5,ffffffe00020157c <dummy+0x28>
ffffffe0002015a4:	00008797          	auipc	a5,0x8
ffffffe0002015a8:	a6c78793          	addi	a5,a5,-1428 # ffffffe000209010 <current>
ffffffe0002015ac:	0007b783          	ld	a5,0(a5)
ffffffe0002015b0:	0087b783          	ld	a5,8(a5)
ffffffe0002015b4:	fc0784e3          	beqz	a5,ffffffe00020157c <dummy+0x28>
        {
            if (current->counter == 1)
ffffffe0002015b8:	00008797          	auipc	a5,0x8
ffffffe0002015bc:	a5878793          	addi	a5,a5,-1448 # ffffffe000209010 <current>
ffffffe0002015c0:	0007b783          	ld	a5,0(a5)
ffffffe0002015c4:	0087b703          	ld	a4,8(a5)
ffffffe0002015c8:	00100793          	li	a5,1
ffffffe0002015cc:	00f71e63          	bne	a4,a5,ffffffe0002015e8 <dummy+0x94>
            {
                --(current->counter); // forced the counter to be zero if this thread is going to be scheduled
ffffffe0002015d0:	00008797          	auipc	a5,0x8
ffffffe0002015d4:	a4078793          	addi	a5,a5,-1472 # ffffffe000209010 <current>
ffffffe0002015d8:	0007b783          	ld	a5,0(a5)
ffffffe0002015dc:	0087b703          	ld	a4,8(a5)
ffffffe0002015e0:	fff70713          	addi	a4,a4,-1
ffffffe0002015e4:	00e7b423          	sd	a4,8(a5)
            } // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
ffffffe0002015e8:	00008797          	auipc	a5,0x8
ffffffe0002015ec:	a2878793          	addi	a5,a5,-1496 # ffffffe000209010 <current>
ffffffe0002015f0:	0007b783          	ld	a5,0(a5)
ffffffe0002015f4:	0087b783          	ld	a5,8(a5)
ffffffe0002015f8:	fef42223          	sw	a5,-28(s0)
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
ffffffe0002015fc:	fe843783          	ld	a5,-24(s0)
ffffffe000201600:	00178713          	addi	a4,a5,1
ffffffe000201604:	fd843783          	ld	a5,-40(s0)
ffffffe000201608:	02f777b3          	remu	a5,a4,a5
ffffffe00020160c:	fef43423          	sd	a5,-24(s0)
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
ffffffe000201610:	00008797          	auipc	a5,0x8
ffffffe000201614:	a0078793          	addi	a5,a5,-1536 # ffffffe000209010 <current>
ffffffe000201618:	0007b783          	ld	a5,0(a5)
ffffffe00020161c:	0187b783          	ld	a5,24(a5)
ffffffe000201620:	fe843603          	ld	a2,-24(s0)
ffffffe000201624:	00078593          	mv	a1,a5
ffffffe000201628:	00003517          	auipc	a0,0x3
ffffffe00020162c:	ad850513          	addi	a0,a0,-1320 # ffffffe000204100 <__func__.0+0x100>
ffffffe000201630:	328020ef          	jal	ffffffe000203958 <printk>
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0)
ffffffe000201634:	f49ff06f          	j	ffffffe00020157c <dummy+0x28>

ffffffe000201638 <sbi_ecall>:
#include "sbi.h"

// Function to perform an SBI (Supervisor Binary Interface) system call
struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
ffffffe000201638:	f8010113          	addi	sp,sp,-128
ffffffe00020163c:	06813c23          	sd	s0,120(sp)
ffffffe000201640:	06913823          	sd	s1,112(sp)
ffffffe000201644:	07213423          	sd	s2,104(sp)
ffffffe000201648:	07313023          	sd	s3,96(sp)
ffffffe00020164c:	08010413          	addi	s0,sp,128
ffffffe000201650:	faa43c23          	sd	a0,-72(s0)
ffffffe000201654:	fab43823          	sd	a1,-80(s0)
ffffffe000201658:	fac43423          	sd	a2,-88(s0)
ffffffe00020165c:	fad43023          	sd	a3,-96(s0)
ffffffe000201660:	f8e43c23          	sd	a4,-104(s0)
ffffffe000201664:	f8f43823          	sd	a5,-112(s0)
ffffffe000201668:	f9043423          	sd	a6,-120(s0)
ffffffe00020166c:	f9143023          	sd	a7,-128(s0)
    struct sbiret ret;
    asm volatile (
ffffffe000201670:	fb843e03          	ld	t3,-72(s0)
ffffffe000201674:	fb043e83          	ld	t4,-80(s0)
ffffffe000201678:	fa843f03          	ld	t5,-88(s0)
ffffffe00020167c:	fa043f83          	ld	t6,-96(s0)
ffffffe000201680:	f9843283          	ld	t0,-104(s0)
ffffffe000201684:	f9043483          	ld	s1,-112(s0)
ffffffe000201688:	f8843903          	ld	s2,-120(s0)
ffffffe00020168c:	f8043983          	ld	s3,-128(s0)
ffffffe000201690:	000e0893          	mv	a7,t3
ffffffe000201694:	000e8813          	mv	a6,t4
ffffffe000201698:	000f0513          	mv	a0,t5
ffffffe00020169c:	000f8593          	mv	a1,t6
ffffffe0002016a0:	00028613          	mv	a2,t0
ffffffe0002016a4:	00048693          	mv	a3,s1
ffffffe0002016a8:	00090713          	mv	a4,s2
ffffffe0002016ac:	00098793          	mv	a5,s3
ffffffe0002016b0:	00000073          	ecall
ffffffe0002016b4:	00050e93          	mv	t4,a0
ffffffe0002016b8:	00058e13          	mv	t3,a1
ffffffe0002016bc:	fdd43023          	sd	t4,-64(s0)
ffffffe0002016c0:	fdc43423          	sd	t3,-56(s0)
        : [error] "=r" (ret.error), [value] "=r" (ret.value) 
        : [eid] "r" (eid), [fid] "r" (fid), [arg0] "r" (arg0), [arg1] "r" (arg1),
          [arg2] "r" (arg2), [arg3] "r" (arg3), [arg4] "r" (arg4), [arg5] "r" (arg5) 
        : "memory", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7" // Clobbered registers
    );
    return ret; // Return the result structure containing error and value
ffffffe0002016c4:	fc043783          	ld	a5,-64(s0)
ffffffe0002016c8:	fcf43823          	sd	a5,-48(s0)
ffffffe0002016cc:	fc843783          	ld	a5,-56(s0)
ffffffe0002016d0:	fcf43c23          	sd	a5,-40(s0)
ffffffe0002016d4:	fd043703          	ld	a4,-48(s0)
ffffffe0002016d8:	fd843783          	ld	a5,-40(s0)
ffffffe0002016dc:	00070313          	mv	t1,a4
ffffffe0002016e0:	00078393          	mv	t2,a5
ffffffe0002016e4:	00030713          	mv	a4,t1
ffffffe0002016e8:	00038793          	mv	a5,t2
}
ffffffe0002016ec:	00070513          	mv	a0,a4
ffffffe0002016f0:	00078593          	mv	a1,a5
ffffffe0002016f4:	07813403          	ld	s0,120(sp)
ffffffe0002016f8:	07013483          	ld	s1,112(sp)
ffffffe0002016fc:	06813903          	ld	s2,104(sp)
ffffffe000201700:	06013983          	ld	s3,96(sp)
ffffffe000201704:	08010113          	addi	sp,sp,128
ffffffe000201708:	00008067          	ret

ffffffe00020170c <sbi_debug_console_write_byte>:

// Function to write a byte to the debug console using SBI
struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
ffffffe00020170c:	fc010113          	addi	sp,sp,-64
ffffffe000201710:	02113c23          	sd	ra,56(sp)
ffffffe000201714:	02813823          	sd	s0,48(sp)
ffffffe000201718:	03213423          	sd	s2,40(sp)
ffffffe00020171c:	03313023          	sd	s3,32(sp)
ffffffe000201720:	04010413          	addi	s0,sp,64
ffffffe000201724:	00050793          	mv	a5,a0
ffffffe000201728:	fcf407a3          	sb	a5,-49(s0)
    return sbi_ecall(0x4442434E, 0x2, byte, 0, 0, 0, 0, 0); // Call with specific IDs for writing a byte
ffffffe00020172c:	fcf44603          	lbu	a2,-49(s0)
ffffffe000201730:	00000893          	li	a7,0
ffffffe000201734:	00000813          	li	a6,0
ffffffe000201738:	00000793          	li	a5,0
ffffffe00020173c:	00000713          	li	a4,0
ffffffe000201740:	00000693          	li	a3,0
ffffffe000201744:	00200593          	li	a1,2
ffffffe000201748:	44424537          	lui	a0,0x44424
ffffffe00020174c:	34e50513          	addi	a0,a0,846 # 4442434e <PHY_SIZE+0x3c42434e>
ffffffe000201750:	ee9ff0ef          	jal	ffffffe000201638 <sbi_ecall>
ffffffe000201754:	00050713          	mv	a4,a0
ffffffe000201758:	00058793          	mv	a5,a1
ffffffe00020175c:	fce43823          	sd	a4,-48(s0)
ffffffe000201760:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201764:	fd043703          	ld	a4,-48(s0)
ffffffe000201768:	fd843783          	ld	a5,-40(s0)
ffffffe00020176c:	00070913          	mv	s2,a4
ffffffe000201770:	00078993          	mv	s3,a5
ffffffe000201774:	00090713          	mv	a4,s2
ffffffe000201778:	00098793          	mv	a5,s3
}
ffffffe00020177c:	00070513          	mv	a0,a4
ffffffe000201780:	00078593          	mv	a1,a5
ffffffe000201784:	03813083          	ld	ra,56(sp)
ffffffe000201788:	03013403          	ld	s0,48(sp)
ffffffe00020178c:	02813903          	ld	s2,40(sp)
ffffffe000201790:	02013983          	ld	s3,32(sp)
ffffffe000201794:	04010113          	addi	sp,sp,64
ffffffe000201798:	00008067          	ret

ffffffe00020179c <sbi_system_reset>:

// Function to reset the system using SBI
struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
ffffffe00020179c:	fc010113          	addi	sp,sp,-64
ffffffe0002017a0:	02113c23          	sd	ra,56(sp)
ffffffe0002017a4:	02813823          	sd	s0,48(sp)
ffffffe0002017a8:	03213423          	sd	s2,40(sp)
ffffffe0002017ac:	03313023          	sd	s3,32(sp)
ffffffe0002017b0:	04010413          	addi	s0,sp,64
ffffffe0002017b4:	00050793          	mv	a5,a0
ffffffe0002017b8:	00058713          	mv	a4,a1
ffffffe0002017bc:	fcf42623          	sw	a5,-52(s0)
ffffffe0002017c0:	00070793          	mv	a5,a4
ffffffe0002017c4:	fcf42423          	sw	a5,-56(s0)
    return sbi_ecall(0x53525354, 0, reset_type, reset_reason, 0, 0, 0, 0); // Call with specific IDs for system reset
ffffffe0002017c8:	fcc46603          	lwu	a2,-52(s0)
ffffffe0002017cc:	fc846683          	lwu	a3,-56(s0)
ffffffe0002017d0:	00000893          	li	a7,0
ffffffe0002017d4:	00000813          	li	a6,0
ffffffe0002017d8:	00000793          	li	a5,0
ffffffe0002017dc:	00000713          	li	a4,0
ffffffe0002017e0:	00000593          	li	a1,0
ffffffe0002017e4:	53525537          	lui	a0,0x53525
ffffffe0002017e8:	35450513          	addi	a0,a0,852 # 53525354 <PHY_SIZE+0x4b525354>
ffffffe0002017ec:	e4dff0ef          	jal	ffffffe000201638 <sbi_ecall>
ffffffe0002017f0:	00050713          	mv	a4,a0
ffffffe0002017f4:	00058793          	mv	a5,a1
ffffffe0002017f8:	fce43823          	sd	a4,-48(s0)
ffffffe0002017fc:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201800:	fd043703          	ld	a4,-48(s0)
ffffffe000201804:	fd843783          	ld	a5,-40(s0)
ffffffe000201808:	00070913          	mv	s2,a4
ffffffe00020180c:	00078993          	mv	s3,a5
ffffffe000201810:	00090713          	mv	a4,s2
ffffffe000201814:	00098793          	mv	a5,s3
}
ffffffe000201818:	00070513          	mv	a0,a4
ffffffe00020181c:	00078593          	mv	a1,a5
ffffffe000201820:	03813083          	ld	ra,56(sp)
ffffffe000201824:	03013403          	ld	s0,48(sp)
ffffffe000201828:	02813903          	ld	s2,40(sp)
ffffffe00020182c:	02013983          	ld	s3,32(sp)
ffffffe000201830:	04010113          	addi	sp,sp,64
ffffffe000201834:	00008067          	ret

ffffffe000201838 <sbi_set_timer>:

// Function to set a timer using SBI
struct sbiret sbi_set_timer(uint64_t stime_value) {
ffffffe000201838:	fc010113          	addi	sp,sp,-64
ffffffe00020183c:	02113c23          	sd	ra,56(sp)
ffffffe000201840:	02813823          	sd	s0,48(sp)
ffffffe000201844:	03213423          	sd	s2,40(sp)
ffffffe000201848:	03313023          	sd	s3,32(sp)
ffffffe00020184c:	04010413          	addi	s0,sp,64
ffffffe000201850:	fca43423          	sd	a0,-56(s0)
    return sbi_ecall(0x54494d45, 0, stime_value, 0, 0, 0, 0, 0); // Call with specific IDs for setting the timer
ffffffe000201854:	00000893          	li	a7,0
ffffffe000201858:	00000813          	li	a6,0
ffffffe00020185c:	00000793          	li	a5,0
ffffffe000201860:	00000713          	li	a4,0
ffffffe000201864:	00000693          	li	a3,0
ffffffe000201868:	fc843603          	ld	a2,-56(s0)
ffffffe00020186c:	00000593          	li	a1,0
ffffffe000201870:	54495537          	lui	a0,0x54495
ffffffe000201874:	d4550513          	addi	a0,a0,-699 # 54494d45 <PHY_SIZE+0x4c494d45>
ffffffe000201878:	dc1ff0ef          	jal	ffffffe000201638 <sbi_ecall>
ffffffe00020187c:	00050713          	mv	a4,a0
ffffffe000201880:	00058793          	mv	a5,a1
ffffffe000201884:	fce43823          	sd	a4,-48(s0)
ffffffe000201888:	fcf43c23          	sd	a5,-40(s0)
ffffffe00020188c:	fd043703          	ld	a4,-48(s0)
ffffffe000201890:	fd843783          	ld	a5,-40(s0)
ffffffe000201894:	00070913          	mv	s2,a4
ffffffe000201898:	00078993          	mv	s3,a5
ffffffe00020189c:	00090713          	mv	a4,s2
ffffffe0002018a0:	00098793          	mv	a5,s3
}
ffffffe0002018a4:	00070513          	mv	a0,a4
ffffffe0002018a8:	00078593          	mv	a1,a5
ffffffe0002018ac:	03813083          	ld	ra,56(sp)
ffffffe0002018b0:	03013403          	ld	s0,48(sp)
ffffffe0002018b4:	02813903          	ld	s2,40(sp)
ffffffe0002018b8:	02013983          	ld	s3,32(sp)
ffffffe0002018bc:	04010113          	addi	sp,sp,64
ffffffe0002018c0:	00008067          	ret

ffffffe0002018c4 <sys_write>:
extern struct task_struct *current;

extern void __ret_from_fork();

uint64_t sys_write(unsigned int fd, const char *buf, size_t count)
{
ffffffe0002018c4:	fc010113          	addi	sp,sp,-64
ffffffe0002018c8:	02113c23          	sd	ra,56(sp)
ffffffe0002018cc:	02813823          	sd	s0,48(sp)
ffffffe0002018d0:	04010413          	addi	s0,sp,64
ffffffe0002018d4:	00050793          	mv	a5,a0
ffffffe0002018d8:	fcb43823          	sd	a1,-48(s0)
ffffffe0002018dc:	fcc43423          	sd	a2,-56(s0)
ffffffe0002018e0:	fcf42e23          	sw	a5,-36(s0)
    if (fd == 1)
ffffffe0002018e4:	fdc42783          	lw	a5,-36(s0)
ffffffe0002018e8:	0007871b          	sext.w	a4,a5
ffffffe0002018ec:	00100793          	li	a5,1
ffffffe0002018f0:	04f71863          	bne	a4,a5,ffffffe000201940 <sys_write+0x7c>
    {
        for (uint64_t i = 0; i < count; i++)
ffffffe0002018f4:	fe043423          	sd	zero,-24(s0)
ffffffe0002018f8:	0340006f          	j	ffffffe00020192c <sys_write+0x68>
        {
            printk("%c", buf[i]);
ffffffe0002018fc:	fd043703          	ld	a4,-48(s0)
ffffffe000201900:	fe843783          	ld	a5,-24(s0)
ffffffe000201904:	00f707b3          	add	a5,a4,a5
ffffffe000201908:	0007c783          	lbu	a5,0(a5)
ffffffe00020190c:	0007879b          	sext.w	a5,a5
ffffffe000201910:	00078593          	mv	a1,a5
ffffffe000201914:	00003517          	auipc	a0,0x3
ffffffe000201918:	82c50513          	addi	a0,a0,-2004 # ffffffe000204140 <__func__.0+0x10>
ffffffe00020191c:	03c020ef          	jal	ffffffe000203958 <printk>
        for (uint64_t i = 0; i < count; i++)
ffffffe000201920:	fe843783          	ld	a5,-24(s0)
ffffffe000201924:	00178793          	addi	a5,a5,1
ffffffe000201928:	fef43423          	sd	a5,-24(s0)
ffffffe00020192c:	fe843703          	ld	a4,-24(s0)
ffffffe000201930:	fc843783          	ld	a5,-56(s0)
ffffffe000201934:	fcf764e3          	bltu	a4,a5,ffffffe0002018fc <sys_write+0x38>
        }
        return count;
ffffffe000201938:	fc843783          	ld	a5,-56(s0)
ffffffe00020193c:	01c0006f          	j	ffffffe000201958 <sys_write+0x94>
    }
    else
    {
        printk("Unsupported file descriptor: %d\n", fd);
ffffffe000201940:	fdc42783          	lw	a5,-36(s0)
ffffffe000201944:	00078593          	mv	a1,a5
ffffffe000201948:	00003517          	auipc	a0,0x3
ffffffe00020194c:	80050513          	addi	a0,a0,-2048 # ffffffe000204148 <__func__.0+0x18>
ffffffe000201950:	008020ef          	jal	ffffffe000203958 <printk>
    }
    return -1;
ffffffe000201954:	fff00793          	li	a5,-1
}
ffffffe000201958:	00078513          	mv	a0,a5
ffffffe00020195c:	03813083          	ld	ra,56(sp)
ffffffe000201960:	03013403          	ld	s0,48(sp)
ffffffe000201964:	04010113          	addi	sp,sp,64
ffffffe000201968:	00008067          	ret

ffffffe00020196c <sys_getpid>:

uint64_t sys_getpid()
{
ffffffe00020196c:	ff010113          	addi	sp,sp,-16
ffffffe000201970:	00813423          	sd	s0,8(sp)
ffffffe000201974:	01010413          	addi	s0,sp,16
    return current->pid;
ffffffe000201978:	00007797          	auipc	a5,0x7
ffffffe00020197c:	69878793          	addi	a5,a5,1688 # ffffffe000209010 <current>
ffffffe000201980:	0007b783          	ld	a5,0(a5)
ffffffe000201984:	0187b783          	ld	a5,24(a5)
}
ffffffe000201988:	00078513          	mv	a0,a5
ffffffe00020198c:	00813403          	ld	s0,8(sp)
ffffffe000201990:	01010113          	addi	sp,sp,16
ffffffe000201994:	00008067          	ret

ffffffe000201998 <do_fork>:

uint64_t do_fork(struct pt_regs *regs)
{
ffffffe000201998:	f7010113          	addi	sp,sp,-144
ffffffe00020199c:	08113423          	sd	ra,136(sp)
ffffffe0002019a0:	08813023          	sd	s0,128(sp)
ffffffe0002019a4:	06913c23          	sd	s1,120(sp)
ffffffe0002019a8:	09010413          	addi	s0,sp,144
ffffffe0002019ac:	f6a43c23          	sd	a0,-136(s0)
    // 1. 为新的 task_struct 分配内存并复制当前 task_struct 的内容
    struct task_struct *_task = (struct task_struct *)kalloc();
ffffffe0002019b0:	fd5fe0ef          	jal	ffffffe000200984 <kalloc>
ffffffe0002019b4:	00050793          	mv	a5,a0
ffffffe0002019b8:	fcf43423          	sd	a5,-56(s0)
    if (_task == NULL)
ffffffe0002019bc:	fc843783          	ld	a5,-56(s0)
ffffffe0002019c0:	02079663          	bnez	a5,ffffffe0002019ec <do_fork+0x54>
    {
        Log("do_fork: failed to kalloc task_struct\n");
ffffffe0002019c4:	00002697          	auipc	a3,0x2
ffffffe0002019c8:	63c68693          	addi	a3,a3,1596 # ffffffe000204000 <__func__.0>
ffffffe0002019cc:	02e00613          	li	a2,46
ffffffe0002019d0:	00002597          	auipc	a1,0x2
ffffffe0002019d4:	7a058593          	addi	a1,a1,1952 # ffffffe000204170 <__func__.0+0x40>
ffffffe0002019d8:	00002517          	auipc	a0,0x2
ffffffe0002019dc:	7a850513          	addi	a0,a0,1960 # ffffffe000204180 <__func__.0+0x50>
ffffffe0002019e0:	779010ef          	jal	ffffffe000203958 <printk>
        return -1;
ffffffe0002019e4:	fff00793          	li	a5,-1
ffffffe0002019e8:	3e80006f          	j	ffffffe000201dd0 <do_fork+0x438>
    }

    memcpy(_task, current, PGSIZE);
ffffffe0002019ec:	00007797          	auipc	a5,0x7
ffffffe0002019f0:	62478793          	addi	a5,a5,1572 # ffffffe000209010 <current>
ffffffe0002019f4:	0007b783          	ld	a5,0(a5)
ffffffe0002019f8:	00001637          	lui	a2,0x1
ffffffe0002019fc:	00078593          	mv	a1,a5
ffffffe000201a00:	fc843503          	ld	a0,-56(s0)
ffffffe000201a04:	0e4020ef          	jal	ffffffe000203ae8 <memcpy>
    // 2. 修改新的 task_struct 的 pid
    _task->pid = nr_tasks;
ffffffe000201a08:	00007797          	auipc	a5,0x7
ffffffe000201a0c:	61078793          	addi	a5,a5,1552 # ffffffe000209018 <nr_tasks>
ffffffe000201a10:	0007b703          	ld	a4,0(a5)
ffffffe000201a14:	fc843783          	ld	a5,-56(s0)
ffffffe000201a18:	00e7bc23          	sd	a4,24(a5)

    // 3. 修改新的 task_struct 的 pgd
    _task->pgd = (uint64_t *)kalloc();
ffffffe000201a1c:	f69fe0ef          	jal	ffffffe000200984 <kalloc>
ffffffe000201a20:	00050793          	mv	a5,a0
ffffffe000201a24:	00078713          	mv	a4,a5
ffffffe000201a28:	fc843783          	ld	a5,-56(s0)
ffffffe000201a2c:	0ae7b823          	sd	a4,176(a5)
    if (_task->pgd == NULL)
ffffffe000201a30:	fc843783          	ld	a5,-56(s0)
ffffffe000201a34:	0b07b783          	ld	a5,176(a5)
ffffffe000201a38:	02079a63          	bnez	a5,ffffffe000201a6c <do_fork+0xd4>
    {
        kfree(_task);
ffffffe000201a3c:	fc843503          	ld	a0,-56(s0)
ffffffe000201a40:	f71fe0ef          	jal	ffffffe0002009b0 <kfree>
        Log("do_fork: failed to kalloc pgd\n");
ffffffe000201a44:	00002697          	auipc	a3,0x2
ffffffe000201a48:	5bc68693          	addi	a3,a3,1468 # ffffffe000204000 <__func__.0>
ffffffe000201a4c:	03b00613          	li	a2,59
ffffffe000201a50:	00002597          	auipc	a1,0x2
ffffffe000201a54:	72058593          	addi	a1,a1,1824 # ffffffe000204170 <__func__.0+0x40>
ffffffe000201a58:	00002517          	auipc	a0,0x2
ffffffe000201a5c:	76850513          	addi	a0,a0,1896 # ffffffe0002041c0 <__func__.0+0x90>
ffffffe000201a60:	6f9010ef          	jal	ffffffe000203958 <printk>
        return -1;
ffffffe000201a64:	fff00793          	li	a5,-1
ffffffe000201a68:	3680006f          	j	ffffffe000201dd0 <do_fork+0x438>
    }
    memcpy(_task->pgd, swapper_pg_dir, PGSIZE);
ffffffe000201a6c:	fc843783          	ld	a5,-56(s0)
ffffffe000201a70:	0b07b783          	ld	a5,176(a5)
ffffffe000201a74:	00001637          	lui	a2,0x1
ffffffe000201a78:	00009597          	auipc	a1,0x9
ffffffe000201a7c:	58858593          	addi	a1,a1,1416 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000201a80:	00078513          	mv	a0,a5
ffffffe000201a84:	064020ef          	jal	ffffffe000203ae8 <memcpy>
    page_deep_copy(_task->pgd);
ffffffe000201a88:	fc843783          	ld	a5,-56(s0)
ffffffe000201a8c:	0b07b783          	ld	a5,176(a5)
ffffffe000201a90:	00078513          	mv	a0,a5
ffffffe000201a94:	765000ef          	jal	ffffffe0002029f8 <page_deep_copy>

    _task->thread.satp = (current->thread.satp >> 44) << 44;
ffffffe000201a98:	00007797          	auipc	a5,0x7
ffffffe000201a9c:	57878793          	addi	a5,a5,1400 # ffffffe000209010 <current>
ffffffe000201aa0:	0007b783          	ld	a5,0(a5)
ffffffe000201aa4:	0a87b703          	ld	a4,168(a5)
ffffffe000201aa8:	fff00793          	li	a5,-1
ffffffe000201aac:	02c79793          	slli	a5,a5,0x2c
ffffffe000201ab0:	00f77733          	and	a4,a4,a5
ffffffe000201ab4:	fc843783          	ld	a5,-56(s0)
ffffffe000201ab8:	0ae7b423          	sd	a4,168(a5)
    _task->thread.satp |= (((uint64_t)(_task->pgd) - PA2VA_OFFSET) >> 12);
ffffffe000201abc:	fc843783          	ld	a5,-56(s0)
ffffffe000201ac0:	0a87b703          	ld	a4,168(a5)
ffffffe000201ac4:	fc843783          	ld	a5,-56(s0)
ffffffe000201ac8:	0b07b783          	ld	a5,176(a5)
ffffffe000201acc:	00078693          	mv	a3,a5
ffffffe000201ad0:	04100793          	li	a5,65
ffffffe000201ad4:	01f79793          	slli	a5,a5,0x1f
ffffffe000201ad8:	00f687b3          	add	a5,a3,a5
ffffffe000201adc:	00c7d793          	srli	a5,a5,0xc
ffffffe000201ae0:	00f76733          	or	a4,a4,a5
ffffffe000201ae4:	fc843783          	ld	a5,-56(s0)
ffffffe000201ae8:	0ae7b423          	sd	a4,168(a5)
    // 4. 清空新的 task_struct 的 mm_struct
    _task->mm.mmap = NULL;
ffffffe000201aec:	fc843783          	ld	a5,-56(s0)
ffffffe000201af0:	0a07bc23          	sd	zero,184(a5)
    // 5. 遍历父进程 vma 链表，为子进程创建 vma
    struct vm_area_struct *vma = current->mm.mmap;
ffffffe000201af4:	00007797          	auipc	a5,0x7
ffffffe000201af8:	51c78793          	addi	a5,a5,1308 # ffffffe000209010 <current>
ffffffe000201afc:	0007b783          	ld	a5,0(a5)
ffffffe000201b00:	0b87b783          	ld	a5,184(a5)
ffffffe000201b04:	fcf43c23          	sd	a5,-40(s0)
    while (vma)
ffffffe000201b08:	1ec0006f          	j	ffffffe000201cf4 <do_fork+0x35c>
    {
        do_mmap(&_task->mm, vma->vm_start, vma->vm_end - vma->vm_start, vma->vm_pgoff, vma->vm_filesz, vma->vm_flags);
ffffffe000201b0c:	fc843783          	ld	a5,-56(s0)
ffffffe000201b10:	0b878513          	addi	a0,a5,184
ffffffe000201b14:	fd843783          	ld	a5,-40(s0)
ffffffe000201b18:	0087b583          	ld	a1,8(a5)
ffffffe000201b1c:	fd843783          	ld	a5,-40(s0)
ffffffe000201b20:	0107b703          	ld	a4,16(a5)
ffffffe000201b24:	fd843783          	ld	a5,-40(s0)
ffffffe000201b28:	0087b783          	ld	a5,8(a5)
ffffffe000201b2c:	40f70633          	sub	a2,a4,a5
ffffffe000201b30:	fd843783          	ld	a5,-40(s0)
ffffffe000201b34:	0307b683          	ld	a3,48(a5)
ffffffe000201b38:	fd843783          	ld	a5,-40(s0)
ffffffe000201b3c:	0387b703          	ld	a4,56(a5)
ffffffe000201b40:	fd843783          	ld	a5,-40(s0)
ffffffe000201b44:	0287b783          	ld	a5,40(a5)
ffffffe000201b48:	c2cff0ef          	jal	ffffffe000200f74 <do_mmap>
        uint64_t va = vma->vm_start;
ffffffe000201b4c:	fd843783          	ld	a5,-40(s0)
ffffffe000201b50:	0087b783          	ld	a5,8(a5)
ffffffe000201b54:	fcf43823          	sd	a5,-48(s0)
        uint64_t offset = vma->vm_pgoff;
ffffffe000201b58:	fd843783          	ld	a5,-40(s0)
ffffffe000201b5c:	0307b783          	ld	a5,48(a5)
ffffffe000201b60:	faf43823          	sd	a5,-80(s0)
        uint64_t fileSize = vma->vm_filesz;
ffffffe000201b64:	fd843783          	ld	a5,-40(s0)
ffffffe000201b68:	0387b783          	ld	a5,56(a5)
ffffffe000201b6c:	faf43423          	sd	a5,-88(s0)
        uint64_t memSize = vma->vm_end - vma->vm_start;
ffffffe000201b70:	fd843783          	ld	a5,-40(s0)
ffffffe000201b74:	0107b703          	ld	a4,16(a5)
ffffffe000201b78:	fd843783          	ld	a5,-40(s0)
ffffffe000201b7c:	0087b783          	ld	a5,8(a5)
ffffffe000201b80:	40f707b3          	sub	a5,a4,a5
ffffffe000201b84:	faf43023          	sd	a5,-96(s0)
        uint64_t flags = vma->vm_flags;
ffffffe000201b88:	fd843783          	ld	a5,-40(s0)
ffffffe000201b8c:	0287b783          	ld	a5,40(a5)
ffffffe000201b90:	f8f43c23          	sd	a5,-104(s0)
        while (va < vma->vm_end)
ffffffe000201b94:	1440006f          	j	ffffffe000201cd8 <do_fork+0x340>
        {
            uint64_t pa = get_pa(current->pgd, va);
ffffffe000201b98:	00007797          	auipc	a5,0x7
ffffffe000201b9c:	47878793          	addi	a5,a5,1144 # ffffffe000209010 <current>
ffffffe000201ba0:	0007b783          	ld	a5,0(a5)
ffffffe000201ba4:	0b07b783          	ld	a5,176(a5)
ffffffe000201ba8:	fd043583          	ld	a1,-48(s0)
ffffffe000201bac:	00078513          	mv	a0,a5
ffffffe000201bb0:	30d000ef          	jal	ffffffe0002026bc <get_pa>
ffffffe000201bb4:	f8a43823          	sd	a0,-112(s0)
            if (pa == 0)
ffffffe000201bb8:	f9043783          	ld	a5,-112(s0)
ffffffe000201bbc:	00079c63          	bnez	a5,ffffffe000201bd4 <do_fork+0x23c>
            {
                va += PGSIZE;
ffffffe000201bc0:	fd043703          	ld	a4,-48(s0)
ffffffe000201bc4:	000017b7          	lui	a5,0x1
ffffffe000201bc8:	00f707b3          	add	a5,a4,a5
ffffffe000201bcc:	fcf43823          	sd	a5,-48(s0)
                continue;
ffffffe000201bd0:	1080006f          	j	ffffffe000201cd8 <do_fork+0x340>
            }
            uint64_t *page = (uint64_t *)kalloc();
ffffffe000201bd4:	db1fe0ef          	jal	ffffffe000200984 <kalloc>
ffffffe000201bd8:	00050793          	mv	a5,a0
ffffffe000201bdc:	f8f43423          	sd	a5,-120(s0)
            if (page == NULL)
ffffffe000201be0:	f8843783          	ld	a5,-120(s0)
ffffffe000201be4:	02079663          	bnez	a5,ffffffe000201c10 <do_fork+0x278>
            {
                Log("do_fork: failed to kalloc page\n");
ffffffe000201be8:	00002697          	auipc	a3,0x2
ffffffe000201bec:	41868693          	addi	a3,a3,1048 # ffffffe000204000 <__func__.0>
ffffffe000201bf0:	05a00613          	li	a2,90
ffffffe000201bf4:	00002597          	auipc	a1,0x2
ffffffe000201bf8:	57c58593          	addi	a1,a1,1404 # ffffffe000204170 <__func__.0+0x40>
ffffffe000201bfc:	00002517          	auipc	a0,0x2
ffffffe000201c00:	5fc50513          	addi	a0,a0,1532 # ffffffe0002041f8 <__func__.0+0xc8>
ffffffe000201c04:	555010ef          	jal	ffffffe000203958 <printk>
                return -1;
ffffffe000201c08:	fff00793          	li	a5,-1
ffffffe000201c0c:	1c40006f          	j	ffffffe000201dd0 <do_fork+0x438>
            }
            memcpy(page, (void *)(pa + PA2VA_OFFSET), PGSIZE);
ffffffe000201c10:	f9043703          	ld	a4,-112(s0)
ffffffe000201c14:	fbf00793          	li	a5,-65
ffffffe000201c18:	01f79793          	slli	a5,a5,0x1f
ffffffe000201c1c:	00f707b3          	add	a5,a4,a5
ffffffe000201c20:	00001637          	lui	a2,0x1
ffffffe000201c24:	00078593          	mv	a1,a5
ffffffe000201c28:	f8843503          	ld	a0,-120(s0)
ffffffe000201c2c:	6bd010ef          	jal	ffffffe000203ae8 <memcpy>
            uint64_t perm = (vma->vm_flags) | 0xd1;
ffffffe000201c30:	fd843783          	ld	a5,-40(s0)
ffffffe000201c34:	0287b783          	ld	a5,40(a5) # 1028 <PGSIZE+0x28>
ffffffe000201c38:	0d17e793          	ori	a5,a5,209
ffffffe000201c3c:	f8f43023          	sd	a5,-128(s0)
            create_mapping(_task->pgd, va, (uint64_t)page - PA2VA_OFFSET, PGSIZE, perm);
ffffffe000201c40:	fc843783          	ld	a5,-56(s0)
ffffffe000201c44:	0b07b503          	ld	a0,176(a5)
ffffffe000201c48:	f8843703          	ld	a4,-120(s0)
ffffffe000201c4c:	04100793          	li	a5,65
ffffffe000201c50:	01f79793          	slli	a5,a5,0x1f
ffffffe000201c54:	00f707b3          	add	a5,a4,a5
ffffffe000201c58:	f8043703          	ld	a4,-128(s0)
ffffffe000201c5c:	000016b7          	lui	a3,0x1
ffffffe000201c60:	00078613          	mv	a2,a5
ffffffe000201c64:	fd043583          	ld	a1,-48(s0)
ffffffe000201c68:	7c8000ef          	jal	ffffffe000202430 <create_mapping>
            Log("current pa: %lx, new pa: %lx\n", get_pa(current->pgd, va), get_pa(_task->pgd, va));
ffffffe000201c6c:	00007797          	auipc	a5,0x7
ffffffe000201c70:	3a478793          	addi	a5,a5,932 # ffffffe000209010 <current>
ffffffe000201c74:	0007b783          	ld	a5,0(a5)
ffffffe000201c78:	0b07b783          	ld	a5,176(a5)
ffffffe000201c7c:	fd043583          	ld	a1,-48(s0)
ffffffe000201c80:	00078513          	mv	a0,a5
ffffffe000201c84:	239000ef          	jal	ffffffe0002026bc <get_pa>
ffffffe000201c88:	00050493          	mv	s1,a0
ffffffe000201c8c:	fc843783          	ld	a5,-56(s0)
ffffffe000201c90:	0b07b783          	ld	a5,176(a5)
ffffffe000201c94:	fd043583          	ld	a1,-48(s0)
ffffffe000201c98:	00078513          	mv	a0,a5
ffffffe000201c9c:	221000ef          	jal	ffffffe0002026bc <get_pa>
ffffffe000201ca0:	00050793          	mv	a5,a0
ffffffe000201ca4:	00048713          	mv	a4,s1
ffffffe000201ca8:	00002697          	auipc	a3,0x2
ffffffe000201cac:	35868693          	addi	a3,a3,856 # ffffffe000204000 <__func__.0>
ffffffe000201cb0:	06000613          	li	a2,96
ffffffe000201cb4:	00002597          	auipc	a1,0x2
ffffffe000201cb8:	4bc58593          	addi	a1,a1,1212 # ffffffe000204170 <__func__.0+0x40>
ffffffe000201cbc:	00002517          	auipc	a0,0x2
ffffffe000201cc0:	57450513          	addi	a0,a0,1396 # ffffffe000204230 <__func__.0+0x100>
ffffffe000201cc4:	495010ef          	jal	ffffffe000203958 <printk>
            va += PGSIZE;
ffffffe000201cc8:	fd043703          	ld	a4,-48(s0)
ffffffe000201ccc:	000017b7          	lui	a5,0x1
ffffffe000201cd0:	00f707b3          	add	a5,a4,a5
ffffffe000201cd4:	fcf43823          	sd	a5,-48(s0)
        while (va < vma->vm_end)
ffffffe000201cd8:	fd843783          	ld	a5,-40(s0)
ffffffe000201cdc:	0107b783          	ld	a5,16(a5) # 1010 <PGSIZE+0x10>
ffffffe000201ce0:	fd043703          	ld	a4,-48(s0)
ffffffe000201ce4:	eaf76ae3          	bltu	a4,a5,ffffffe000201b98 <do_fork+0x200>
        }
        vma = vma->vm_next;
ffffffe000201ce8:	fd843783          	ld	a5,-40(s0)
ffffffe000201cec:	0187b783          	ld	a5,24(a5)
ffffffe000201cf0:	fcf43c23          	sd	a5,-40(s0)
    while (vma)
ffffffe000201cf4:	fd843783          	ld	a5,-40(s0)
ffffffe000201cf8:	e0079ae3          	bnez	a5,ffffffe000201b0c <do_fork+0x174>
    }
    // 6. 处理返回逻辑

    // 修改子进程的返回值用于__switch_to调度
    _task->thread.ra = __ret_from_fork;
ffffffe000201cfc:	ffffe717          	auipc	a4,0xffffe
ffffffe000201d00:	42c70713          	addi	a4,a4,1068 # ffffffe000200128 <__ret_from_fork>
ffffffe000201d04:	fc843783          	ld	a5,-56(s0)
ffffffe000201d08:	02e7b023          	sd	a4,32(a5)
    // 修改子进程用户的寄存器中的值
    struct pt_regs *regs_child = (struct pt_regs *)((uint64_t)regs + ((uint64_t)_task - (uint64_t)current));
ffffffe000201d0c:	fc843783          	ld	a5,-56(s0)
ffffffe000201d10:	00007717          	auipc	a4,0x7
ffffffe000201d14:	30070713          	addi	a4,a4,768 # ffffffe000209010 <current>
ffffffe000201d18:	00073703          	ld	a4,0(a4)
ffffffe000201d1c:	40e78733          	sub	a4,a5,a4
ffffffe000201d20:	f7843783          	ld	a5,-136(s0)
ffffffe000201d24:	00f707b3          	add	a5,a4,a5
ffffffe000201d28:	fcf43023          	sd	a5,-64(s0)
    // 子进程的系统调用返回值 a0 为 0
    regs_child->regs[9] = 0;
ffffffe000201d2c:	fc043783          	ld	a5,-64(s0)
ffffffe000201d30:	0407b423          	sd	zero,72(a5)

    // 子进程系统的栈指针 sp 也要更新
    regs_child->regs[1] = regs->regs[1] + ((uint64_t)_task - (uint64_t)current);
ffffffe000201d34:	f7843783          	ld	a5,-136(s0)
ffffffe000201d38:	0087b703          	ld	a4,8(a5)
ffffffe000201d3c:	fc843783          	ld	a5,-56(s0)
ffffffe000201d40:	00007697          	auipc	a3,0x7
ffffffe000201d44:	2d068693          	addi	a3,a3,720 # ffffffe000209010 <current>
ffffffe000201d48:	0006b683          	ld	a3,0(a3)
ffffffe000201d4c:	40d787b3          	sub	a5,a5,a3
ffffffe000201d50:	00f70733          	add	a4,a4,a5
ffffffe000201d54:	fc043783          	ld	a5,-64(s0)
ffffffe000201d58:	00e7b423          	sd	a4,8(a5)

    // 映射子进程上下文切换的系统栈
    _task->thread.sp = (uint64_t)regs + ((uint64_t)_task - (uint64_t)current);
ffffffe000201d5c:	fc843783          	ld	a5,-56(s0)
ffffffe000201d60:	00007717          	auipc	a4,0x7
ffffffe000201d64:	2b070713          	addi	a4,a4,688 # ffffffe000209010 <current>
ffffffe000201d68:	00073703          	ld	a4,0(a4)
ffffffe000201d6c:	40e78733          	sub	a4,a5,a4
ffffffe000201d70:	f7843783          	ld	a5,-136(s0)
ffffffe000201d74:	00f70733          	add	a4,a4,a5
ffffffe000201d78:	fc843783          	ld	a5,-56(s0)
ffffffe000201d7c:	02e7b423          	sd	a4,40(a5)

    // 修改子进程的 sscratch 和 当前线程的 sscratch 同步
    _task->thread.sscratch = csr_read(sscratch);
ffffffe000201d80:	140027f3          	csrr	a5,sscratch
ffffffe000201d84:	faf43c23          	sd	a5,-72(s0)
ffffffe000201d88:	fb843703          	ld	a4,-72(s0)
ffffffe000201d8c:	fc843783          	ld	a5,-56(s0)
ffffffe000201d90:	0ae7b023          	sd	a4,160(a5)

    task[nr_tasks++] = _task;
ffffffe000201d94:	00007797          	auipc	a5,0x7
ffffffe000201d98:	28478793          	addi	a5,a5,644 # ffffffe000209018 <nr_tasks>
ffffffe000201d9c:	0007b783          	ld	a5,0(a5)
ffffffe000201da0:	00178693          	addi	a3,a5,1
ffffffe000201da4:	00007717          	auipc	a4,0x7
ffffffe000201da8:	27470713          	addi	a4,a4,628 # ffffffe000209018 <nr_tasks>
ffffffe000201dac:	00d73023          	sd	a3,0(a4)
ffffffe000201db0:	00007717          	auipc	a4,0x7
ffffffe000201db4:	28870713          	addi	a4,a4,648 # ffffffe000209038 <task>
ffffffe000201db8:	00379793          	slli	a5,a5,0x3
ffffffe000201dbc:	00f707b3          	add	a5,a4,a5
ffffffe000201dc0:	fc843703          	ld	a4,-56(s0)
ffffffe000201dc4:	00e7b023          	sd	a4,0(a5)
    return _task->pid;
ffffffe000201dc8:	fc843783          	ld	a5,-56(s0)
ffffffe000201dcc:	0187b783          	ld	a5,24(a5)
ffffffe000201dd0:	00078513          	mv	a0,a5
ffffffe000201dd4:	08813083          	ld	ra,136(sp)
ffffffe000201dd8:	08013403          	ld	s0,128(sp)
ffffffe000201ddc:	07813483          	ld	s1,120(sp)
ffffffe000201de0:	09010113          	addi	sp,sp,144
ffffffe000201de4:	00008067          	ret

ffffffe000201de8 <do_page_fault>:
extern struct task_struct *current;
extern char _sramdisk[];
extern char _eramdisk[];

void do_page_fault(struct pt_regs *regs)
{
ffffffe000201de8:	f6010113          	addi	sp,sp,-160
ffffffe000201dec:	08113c23          	sd	ra,152(sp)
ffffffe000201df0:	08813823          	sd	s0,144(sp)
ffffffe000201df4:	0a010413          	addi	s0,sp,160
ffffffe000201df8:	f6a43423          	sd	a0,-152(s0)
    uint64_t scause = csr_read(scause);
ffffffe000201dfc:	142027f3          	csrr	a5,scause
ffffffe000201e00:	fef43423          	sd	a5,-24(s0)
ffffffe000201e04:	fe843783          	ld	a5,-24(s0)
ffffffe000201e08:	fef43023          	sd	a5,-32(s0)
    uint64_t stval = csr_read(stval);
ffffffe000201e0c:	143027f3          	csrr	a5,stval
ffffffe000201e10:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201e14:	fd843783          	ld	a5,-40(s0)
ffffffe000201e18:	fcf43823          	sd	a5,-48(s0)
    uint64_t sepc = regs->sepc;
ffffffe000201e1c:	f6843783          	ld	a5,-152(s0)
ffffffe000201e20:	0f87b783          	ld	a5,248(a5)
ffffffe000201e24:	fcf43423          	sd	a5,-56(s0)
    struct vm_area_struct *vma = find_vma(&current->mm, stval);
ffffffe000201e28:	00007797          	auipc	a5,0x7
ffffffe000201e2c:	1e878793          	addi	a5,a5,488 # ffffffe000209010 <current>
ffffffe000201e30:	0007b783          	ld	a5,0(a5)
ffffffe000201e34:	0b878793          	addi	a5,a5,184
ffffffe000201e38:	fd043583          	ld	a1,-48(s0)
ffffffe000201e3c:	00078513          	mv	a0,a5
ffffffe000201e40:	8c0ff0ef          	jal	ffffffe000200f00 <find_vma>
ffffffe000201e44:	fca43023          	sd	a0,-64(s0)
    //[PID = 4 PC = 0x100e8] valid page fault at `0x100e8` with cause 12
    Log("[PID = %d PC = %lx] valid page fault at `%lx` with cause %lx", current->pid, sepc, stval, scause);
ffffffe000201e48:	00007797          	auipc	a5,0x7
ffffffe000201e4c:	1c878793          	addi	a5,a5,456 # ffffffe000209010 <current>
ffffffe000201e50:	0007b783          	ld	a5,0(a5)
ffffffe000201e54:	0187b703          	ld	a4,24(a5)
ffffffe000201e58:	fe043883          	ld	a7,-32(s0)
ffffffe000201e5c:	fd043803          	ld	a6,-48(s0)
ffffffe000201e60:	fc843783          	ld	a5,-56(s0)
ffffffe000201e64:	00002697          	auipc	a3,0x2
ffffffe000201e68:	58468693          	addi	a3,a3,1412 # ffffffe0002043e8 <__func__.1>
ffffffe000201e6c:	01400613          	li	a2,20
ffffffe000201e70:	00002597          	auipc	a1,0x2
ffffffe000201e74:	3f858593          	addi	a1,a1,1016 # ffffffe000204268 <__func__.0+0x138>
ffffffe000201e78:	00002517          	auipc	a0,0x2
ffffffe000201e7c:	3f850513          	addi	a0,a0,1016 # ffffffe000204270 <__func__.0+0x140>
ffffffe000201e80:	2d9010ef          	jal	ffffffe000203958 <printk>
    if (vma == NULL)
ffffffe000201e84:	fc043783          	ld	a5,-64(s0)
ffffffe000201e88:	02079a63          	bnez	a5,ffffffe000201ebc <do_page_fault+0xd4>
    {
        Err("Page fault at addr %lx,scause %lx but no mapping found", stval, scause);
ffffffe000201e8c:	fe043783          	ld	a5,-32(s0)
ffffffe000201e90:	fd043703          	ld	a4,-48(s0)
ffffffe000201e94:	00002697          	auipc	a3,0x2
ffffffe000201e98:	55468693          	addi	a3,a3,1364 # ffffffe0002043e8 <__func__.1>
ffffffe000201e9c:	01700613          	li	a2,23
ffffffe000201ea0:	00002597          	auipc	a1,0x2
ffffffe000201ea4:	3c858593          	addi	a1,a1,968 # ffffffe000204268 <__func__.0+0x138>
ffffffe000201ea8:	00002517          	auipc	a0,0x2
ffffffe000201eac:	42050513          	addi	a0,a0,1056 # ffffffe0002042c8 <__func__.0+0x198>
ffffffe000201eb0:	2a9010ef          	jal	ffffffe000203958 <printk>
ffffffe000201eb4:	00000013          	nop
ffffffe000201eb8:	ffdff06f          	j	ffffffe000201eb4 <do_page_fault+0xcc>
    }
    if ((scause == 12 && !(vma->vm_flags & VM_EXEC)) ||
ffffffe000201ebc:	fe043703          	ld	a4,-32(s0)
ffffffe000201ec0:	00c00793          	li	a5,12
ffffffe000201ec4:	00f71a63          	bne	a4,a5,ffffffe000201ed8 <do_page_fault+0xf0>
ffffffe000201ec8:	fc043783          	ld	a5,-64(s0)
ffffffe000201ecc:	0287b783          	ld	a5,40(a5)
ffffffe000201ed0:	0087f793          	andi	a5,a5,8
ffffffe000201ed4:	02078e63          	beqz	a5,ffffffe000201f10 <do_page_fault+0x128>
ffffffe000201ed8:	fe043703          	ld	a4,-32(s0)
ffffffe000201edc:	00d00793          	li	a5,13
ffffffe000201ee0:	00f71a63          	bne	a4,a5,ffffffe000201ef4 <do_page_fault+0x10c>
        (scause == 13 && !(vma->vm_flags & VM_READ)) ||
ffffffe000201ee4:	fc043783          	ld	a5,-64(s0)
ffffffe000201ee8:	0287b783          	ld	a5,40(a5)
ffffffe000201eec:	0027f793          	andi	a5,a5,2
ffffffe000201ef0:	02078063          	beqz	a5,ffffffe000201f10 <do_page_fault+0x128>
ffffffe000201ef4:	fe043703          	ld	a4,-32(s0)
ffffffe000201ef8:	00f00793          	li	a5,15
ffffffe000201efc:	04f71063          	bne	a4,a5,ffffffe000201f3c <do_page_fault+0x154>
        (scause == 15 && !(vma->vm_flags & VM_WRITE)))
ffffffe000201f00:	fc043783          	ld	a5,-64(s0)
ffffffe000201f04:	0287b783          	ld	a5,40(a5)
ffffffe000201f08:	0047f793          	andi	a5,a5,4
ffffffe000201f0c:	02079863          	bnez	a5,ffffffe000201f3c <do_page_fault+0x154>
    {
        Err("Page fault at addr %lx: permission denied", stval);
ffffffe000201f10:	fd043703          	ld	a4,-48(s0)
ffffffe000201f14:	00002697          	auipc	a3,0x2
ffffffe000201f18:	4d468693          	addi	a3,a3,1236 # ffffffe0002043e8 <__func__.1>
ffffffe000201f1c:	01d00613          	li	a2,29
ffffffe000201f20:	00002597          	auipc	a1,0x2
ffffffe000201f24:	34858593          	addi	a1,a1,840 # ffffffe000204268 <__func__.0+0x138>
ffffffe000201f28:	00002517          	auipc	a0,0x2
ffffffe000201f2c:	3f050513          	addi	a0,a0,1008 # ffffffe000204318 <__func__.0+0x1e8>
ffffffe000201f30:	229010ef          	jal	ffffffe000203958 <printk>
ffffffe000201f34:	00000013          	nop
ffffffe000201f38:	ffdff06f          	j	ffffffe000201f34 <do_page_fault+0x14c>
        return;
    }
    uint64_t aligned_addr = PGROUNDDOWN(stval);
ffffffe000201f3c:	fd043703          	ld	a4,-48(s0)
ffffffe000201f40:	fffff7b7          	lui	a5,0xfffff
ffffffe000201f44:	00f777b3          	and	a5,a4,a5
ffffffe000201f48:	faf43c23          	sd	a5,-72(s0)

    uint64_t *page = (uint64_t *)kalloc();
ffffffe000201f4c:	a39fe0ef          	jal	ffffffe000200984 <kalloc>
ffffffe000201f50:	00050793          	mv	a5,a0
ffffffe000201f54:	faf43823          	sd	a5,-80(s0)
    if (page == NULL)
ffffffe000201f58:	fb043783          	ld	a5,-80(s0)
ffffffe000201f5c:	02079863          	bnez	a5,ffffffe000201f8c <do_page_fault+0x1a4>
    {
        Err("Page allocation failed for addr %lx", aligned_addr);
ffffffe000201f60:	fb843703          	ld	a4,-72(s0)
ffffffe000201f64:	00002697          	auipc	a3,0x2
ffffffe000201f68:	48468693          	addi	a3,a3,1156 # ffffffe0002043e8 <__func__.1>
ffffffe000201f6c:	02500613          	li	a2,37
ffffffe000201f70:	00002597          	auipc	a1,0x2
ffffffe000201f74:	2f858593          	addi	a1,a1,760 # ffffffe000204268 <__func__.0+0x138>
ffffffe000201f78:	00002517          	auipc	a0,0x2
ffffffe000201f7c:	3e850513          	addi	a0,a0,1000 # ffffffe000204360 <__func__.0+0x230>
ffffffe000201f80:	1d9010ef          	jal	ffffffe000203958 <printk>
ffffffe000201f84:	00000013          	nop
ffffffe000201f88:	ffdff06f          	j	ffffffe000201f84 <do_page_fault+0x19c>
        return;
    }

    memset(page, 0, PGSIZE);
ffffffe000201f8c:	00001637          	lui	a2,0x1
ffffffe000201f90:	00000593          	li	a1,0
ffffffe000201f94:	fb043503          	ld	a0,-80(s0)
ffffffe000201f98:	2e1010ef          	jal	ffffffe000203a78 <memset>

    if (vma->vm_flags & VM_ANON)
ffffffe000201f9c:	fc043783          	ld	a5,-64(s0)
ffffffe000201fa0:	0287b783          	ld	a5,40(a5) # fffffffffffff028 <VM_END+0xfffff028>
ffffffe000201fa4:	0017f793          	andi	a5,a5,1
ffffffe000201fa8:	04078663          	beqz	a5,ffffffe000201ff4 <do_page_fault+0x20c>
    {
        uint64_t perm = vma->vm_flags;
ffffffe000201fac:	fc043783          	ld	a5,-64(s0)
ffffffe000201fb0:	0287b783          	ld	a5,40(a5)
ffffffe000201fb4:	f6f43823          	sd	a5,-144(s0)
        create_mapping(current->pgd, aligned_addr, (uint64_t)page - PA2VA_OFFSET, PGSIZE, perm | 0xd1);
ffffffe000201fb8:	00007797          	auipc	a5,0x7
ffffffe000201fbc:	05878793          	addi	a5,a5,88 # ffffffe000209010 <current>
ffffffe000201fc0:	0007b783          	ld	a5,0(a5)
ffffffe000201fc4:	0b07b503          	ld	a0,176(a5)
ffffffe000201fc8:	fb043703          	ld	a4,-80(s0)
ffffffe000201fcc:	04100793          	li	a5,65
ffffffe000201fd0:	01f79793          	slli	a5,a5,0x1f
ffffffe000201fd4:	00f70633          	add	a2,a4,a5
ffffffe000201fd8:	f7043783          	ld	a5,-144(s0)
ffffffe000201fdc:	0d17e793          	ori	a5,a5,209
ffffffe000201fe0:	00078713          	mv	a4,a5
ffffffe000201fe4:	000016b7          	lui	a3,0x1
ffffffe000201fe8:	fb843583          	ld	a1,-72(s0)
ffffffe000201fec:	444000ef          	jal	ffffffe000202430 <create_mapping>
ffffffe000201ff0:	1380006f          	j	ffffffe000202128 <do_page_fault+0x340>
    }
    else
    {
        uint64_t va_start = vma->vm_start;
ffffffe000201ff4:	fc043783          	ld	a5,-64(s0)
ffffffe000201ff8:	0087b783          	ld	a5,8(a5)
ffffffe000201ffc:	faf43423          	sd	a5,-88(s0)
        uint64_t va_end = vma->vm_end;
ffffffe000202000:	fc043783          	ld	a5,-64(s0)
ffffffe000202004:	0107b783          	ld	a5,16(a5)
ffffffe000202008:	faf43023          	sd	a5,-96(s0)
        // 非匿名页：从文件拷贝数据

        uint64_t file_offset = aligned_addr - va_start + vma->vm_pgoff;
ffffffe00020200c:	fb843703          	ld	a4,-72(s0)
ffffffe000202010:	fa843783          	ld	a5,-88(s0)
ffffffe000202014:	40f70733          	sub	a4,a4,a5
ffffffe000202018:	fc043783          	ld	a5,-64(s0)
ffffffe00020201c:	0307b783          	ld	a5,48(a5)
ffffffe000202020:	00f707b3          	add	a5,a4,a5
ffffffe000202024:	f8f43c23          	sd	a5,-104(s0)
        uint64_t file_size = vma->vm_filesz;
ffffffe000202028:	fc043783          	ld	a5,-64(s0)
ffffffe00020202c:	0387b783          	ld	a5,56(a5)
ffffffe000202030:	f8f43823          	sd	a5,-112(s0)

        // 计算需要拷贝的大小
        uint64_t copy_size = PGSIZE;
ffffffe000202034:	000017b7          	lui	a5,0x1
ffffffe000202038:	f8f43423          	sd	a5,-120(s0)
        // 从文件中读取数据到分配的物理页
        if (copy_size > 0)
ffffffe00020203c:	f8843783          	ld	a5,-120(s0)
ffffffe000202040:	02078263          	beqz	a5,ffffffe000202064 <do_page_fault+0x27c>
        {
            memcpy(page, (uint64_t *)(_sramdisk + file_offset), copy_size);
ffffffe000202044:	f9843703          	ld	a4,-104(s0)
ffffffe000202048:	00004797          	auipc	a5,0x4
ffffffe00020204c:	fb878793          	addi	a5,a5,-72 # ffffffe000206000 <_sramdisk>
ffffffe000202050:	00f707b3          	add	a5,a4,a5
ffffffe000202054:	f8843603          	ld	a2,-120(s0)
ffffffe000202058:	00078593          	mv	a1,a5
ffffffe00020205c:	fb043503          	ld	a0,-80(s0)
ffffffe000202060:	289010ef          	jal	ffffffe000203ae8 <memcpy>
        }
        // 大于filesz小于memsz的地方要清零
        if (aligned_addr + PGSIZE - va_start > file_size)
ffffffe000202064:	fb843703          	ld	a4,-72(s0)
ffffffe000202068:	fa843783          	ld	a5,-88(s0)
ffffffe00020206c:	40f70733          	sub	a4,a4,a5
ffffffe000202070:	000017b7          	lui	a5,0x1
ffffffe000202074:	00f707b3          	add	a5,a4,a5
ffffffe000202078:	f9043703          	ld	a4,-112(s0)
ffffffe00020207c:	06f77463          	bgeu	a4,a5,ffffffe0002020e4 <do_page_fault+0x2fc>
        {
            uint64_t setsize = (file_size > (aligned_addr - va_start)) ? PGSIZE - (file_size - (aligned_addr - va_start)) : PGSIZE;
ffffffe000202080:	fb843703          	ld	a4,-72(s0)
ffffffe000202084:	fa843783          	ld	a5,-88(s0)
ffffffe000202088:	40f707b3          	sub	a5,a4,a5
ffffffe00020208c:	f9043703          	ld	a4,-112(s0)
ffffffe000202090:	02e7f263          	bgeu	a5,a4,ffffffe0002020b4 <do_page_fault+0x2cc>
ffffffe000202094:	fb843703          	ld	a4,-72(s0)
ffffffe000202098:	fa843783          	ld	a5,-88(s0)
ffffffe00020209c:	40f70733          	sub	a4,a4,a5
ffffffe0002020a0:	f9043783          	ld	a5,-112(s0)
ffffffe0002020a4:	40f70733          	sub	a4,a4,a5
ffffffe0002020a8:	000017b7          	lui	a5,0x1
ffffffe0002020ac:	00f707b3          	add	a5,a4,a5
ffffffe0002020b0:	0080006f          	j	ffffffe0002020b8 <do_page_fault+0x2d0>
ffffffe0002020b4:	000017b7          	lui	a5,0x1
ffffffe0002020b8:	f8f43023          	sd	a5,-128(s0)
            memset(page + PGSIZE - setsize, 0, setsize);
ffffffe0002020bc:	00001737          	lui	a4,0x1
ffffffe0002020c0:	f8043783          	ld	a5,-128(s0)
ffffffe0002020c4:	40f707b3          	sub	a5,a4,a5
ffffffe0002020c8:	00379793          	slli	a5,a5,0x3
ffffffe0002020cc:	fb043703          	ld	a4,-80(s0)
ffffffe0002020d0:	00f707b3          	add	a5,a4,a5
ffffffe0002020d4:	f8043603          	ld	a2,-128(s0)
ffffffe0002020d8:	00000593          	li	a1,0
ffffffe0002020dc:	00078513          	mv	a0,a5
ffffffe0002020e0:	199010ef          	jal	ffffffe000203a78 <memset>
        }

        // 设置页面权限
        uint64_t perm = (vma->vm_flags) | 0xd1;
ffffffe0002020e4:	fc043783          	ld	a5,-64(s0)
ffffffe0002020e8:	0287b783          	ld	a5,40(a5) # 1028 <PGSIZE+0x28>
ffffffe0002020ec:	0d17e793          	ori	a5,a5,209
ffffffe0002020f0:	f6f43c23          	sd	a5,-136(s0)
        create_mapping(current->pgd, aligned_addr, (uint64_t)page - PA2VA_OFFSET, copy_size, perm);
ffffffe0002020f4:	00007797          	auipc	a5,0x7
ffffffe0002020f8:	f1c78793          	addi	a5,a5,-228 # ffffffe000209010 <current>
ffffffe0002020fc:	0007b783          	ld	a5,0(a5)
ffffffe000202100:	0b07b503          	ld	a0,176(a5)
ffffffe000202104:	fb043703          	ld	a4,-80(s0)
ffffffe000202108:	04100793          	li	a5,65
ffffffe00020210c:	01f79793          	slli	a5,a5,0x1f
ffffffe000202110:	00f707b3          	add	a5,a4,a5
ffffffe000202114:	f7843703          	ld	a4,-136(s0)
ffffffe000202118:	f8843683          	ld	a3,-120(s0)
ffffffe00020211c:	00078613          	mv	a2,a5
ffffffe000202120:	fb843583          	ld	a1,-72(s0)
ffffffe000202124:	30c000ef          	jal	ffffffe000202430 <create_mapping>
    }
}
ffffffe000202128:	09813083          	ld	ra,152(sp)
ffffffe00020212c:	09013403          	ld	s0,144(sp)
ffffffe000202130:	0a010113          	addi	sp,sp,160
ffffffe000202134:	00008067          	ret

ffffffe000202138 <trap_handler>:

void trap_handler(uint64_t scause, uint64_t sepc, struct pt_regs *regs)
{
ffffffe000202138:	fd010113          	addi	sp,sp,-48
ffffffe00020213c:	02113423          	sd	ra,40(sp)
ffffffe000202140:	02813023          	sd	s0,32(sp)
ffffffe000202144:	03010413          	addi	s0,sp,48
ffffffe000202148:	fea43423          	sd	a0,-24(s0)
ffffffe00020214c:	feb43023          	sd	a1,-32(s0)
ffffffe000202150:	fcc43c23          	sd	a2,-40(s0)
    // Check if the interrupt is a timer interrupt
    if ((scause >> 63) && (scause << 1 >> 1) == 5)
ffffffe000202154:	fe843783          	ld	a5,-24(s0)
ffffffe000202158:	0207d463          	bgez	a5,ffffffe000202180 <trap_handler+0x48>
ffffffe00020215c:	fe843703          	ld	a4,-24(s0)
ffffffe000202160:	fff00793          	li	a5,-1
ffffffe000202164:	0017d793          	srli	a5,a5,0x1
ffffffe000202168:	00f77733          	and	a4,a4,a5
ffffffe00020216c:	00500793          	li	a5,5
ffffffe000202170:	00f71863          	bne	a4,a5,ffffffe000202180 <trap_handler+0x48>
    {
        // printk("[S] Supervisor Mode Timer Interrupt\n"); // Print the timer interrupt message
        clock_set_next_event(); // Set the next timer event
ffffffe000202174:	938fe0ef          	jal	ffffffe0002002ac <clock_set_next_event>
        do_timer();
ffffffe000202178:	91cff0ef          	jal	ffffffe000201294 <do_timer>
        return; // Exit the handler
ffffffe00020217c:	1500006f          	j	ffffffe0002022cc <trap_handler+0x194>
    }
    else if (scause == 8)
ffffffe000202180:	fe843703          	ld	a4,-24(s0)
ffffffe000202184:	00800793          	li	a5,8
ffffffe000202188:	0ef71263          	bne	a4,a5,ffffffe00020226c <trap_handler+0x134>
    {
        regs->sepc += 4;
ffffffe00020218c:	fd843783          	ld	a5,-40(s0)
ffffffe000202190:	0f87b783          	ld	a5,248(a5)
ffffffe000202194:	00478713          	addi	a4,a5,4
ffffffe000202198:	fd843783          	ld	a5,-40(s0)
ffffffe00020219c:	0ee7bc23          	sd	a4,248(a5)
        if (regs->regs[16] == SYS_WRITE)
ffffffe0002021a0:	fd843783          	ld	a5,-40(s0)
ffffffe0002021a4:	0807b703          	ld	a4,128(a5)
ffffffe0002021a8:	04000793          	li	a5,64
ffffffe0002021ac:	04f71263          	bne	a4,a5,ffffffe0002021f0 <trap_handler+0xb8>
            regs->regs[9] = sys_write((unsigned int)regs->regs[9], (const char *)regs->regs[10], (uint64_t)regs->regs[11]);
ffffffe0002021b0:	fd843783          	ld	a5,-40(s0)
ffffffe0002021b4:	0487b783          	ld	a5,72(a5)
ffffffe0002021b8:	0007871b          	sext.w	a4,a5
ffffffe0002021bc:	fd843783          	ld	a5,-40(s0)
ffffffe0002021c0:	0507b783          	ld	a5,80(a5)
ffffffe0002021c4:	00078693          	mv	a3,a5
ffffffe0002021c8:	fd843783          	ld	a5,-40(s0)
ffffffe0002021cc:	0587b783          	ld	a5,88(a5)
ffffffe0002021d0:	00078613          	mv	a2,a5
ffffffe0002021d4:	00068593          	mv	a1,a3
ffffffe0002021d8:	00070513          	mv	a0,a4
ffffffe0002021dc:	ee8ff0ef          	jal	ffffffe0002018c4 <sys_write>
ffffffe0002021e0:	00050713          	mv	a4,a0
ffffffe0002021e4:	fd843783          	ld	a5,-40(s0)
ffffffe0002021e8:	04e7b423          	sd	a4,72(a5)
ffffffe0002021ec:	0e00006f          	j	ffffffe0002022cc <trap_handler+0x194>
        else if (regs->regs[16] == SYS_GETPID)
ffffffe0002021f0:	fd843783          	ld	a5,-40(s0)
ffffffe0002021f4:	0807b703          	ld	a4,128(a5)
ffffffe0002021f8:	0ac00793          	li	a5,172
ffffffe0002021fc:	00f71c63          	bne	a4,a5,ffffffe000202214 <trap_handler+0xdc>
            regs->regs[9] = sys_getpid();
ffffffe000202200:	f6cff0ef          	jal	ffffffe00020196c <sys_getpid>
ffffffe000202204:	00050713          	mv	a4,a0
ffffffe000202208:	fd843783          	ld	a5,-40(s0)
ffffffe00020220c:	04e7b423          	sd	a4,72(a5)
ffffffe000202210:	0bc0006f          	j	ffffffe0002022cc <trap_handler+0x194>
        else if (regs->regs[16] == SYS_CLONE)
ffffffe000202214:	fd843783          	ld	a5,-40(s0)
ffffffe000202218:	0807b703          	ld	a4,128(a5)
ffffffe00020221c:	0dc00793          	li	a5,220
ffffffe000202220:	00f71e63          	bne	a4,a5,ffffffe00020223c <trap_handler+0x104>
            regs->regs[9] = do_fork(regs);
ffffffe000202224:	fd843503          	ld	a0,-40(s0)
ffffffe000202228:	f70ff0ef          	jal	ffffffe000201998 <do_fork>
ffffffe00020222c:	00050713          	mv	a4,a0
ffffffe000202230:	fd843783          	ld	a5,-40(s0)
ffffffe000202234:	04e7b423          	sd	a4,72(a5)
ffffffe000202238:	0940006f          	j	ffffffe0002022cc <trap_handler+0x194>
        else
        {
            Err("Unsupported exception: scause: %lx, sepc: %lx\n", scause, sepc);
ffffffe00020223c:	fe043783          	ld	a5,-32(s0)
ffffffe000202240:	fe843703          	ld	a4,-24(s0)
ffffffe000202244:	00002697          	auipc	a3,0x2
ffffffe000202248:	1b468693          	addi	a3,a3,436 # ffffffe0002043f8 <__func__.0>
ffffffe00020224c:	06200613          	li	a2,98
ffffffe000202250:	00002597          	auipc	a1,0x2
ffffffe000202254:	01858593          	addi	a1,a1,24 # ffffffe000204268 <__func__.0+0x138>
ffffffe000202258:	00002517          	auipc	a0,0x2
ffffffe00020225c:	14850513          	addi	a0,a0,328 # ffffffe0002043a0 <__func__.0+0x270>
ffffffe000202260:	6f8010ef          	jal	ffffffe000203958 <printk>
ffffffe000202264:	00000013          	nop
ffffffe000202268:	ffdff06f          	j	ffffffe000202264 <trap_handler+0x12c>
        }
    }
    else if (scause == 12 || scause == 13 || scause == 15)
ffffffe00020226c:	fe843703          	ld	a4,-24(s0)
ffffffe000202270:	00c00793          	li	a5,12
ffffffe000202274:	00f70e63          	beq	a4,a5,ffffffe000202290 <trap_handler+0x158>
ffffffe000202278:	fe843703          	ld	a4,-24(s0)
ffffffe00020227c:	00d00793          	li	a5,13
ffffffe000202280:	00f70863          	beq	a4,a5,ffffffe000202290 <trap_handler+0x158>
ffffffe000202284:	fe843703          	ld	a4,-24(s0)
ffffffe000202288:	00f00793          	li	a5,15
ffffffe00020228c:	00f71863          	bne	a4,a5,ffffffe00020229c <trap_handler+0x164>
    {
        do_page_fault(regs);
ffffffe000202290:	fd843503          	ld	a0,-40(s0)
ffffffe000202294:	b55ff0ef          	jal	ffffffe000201de8 <do_page_fault>
        return;
ffffffe000202298:	0340006f          	j	ffffffe0002022cc <trap_handler+0x194>
    }
    else
    {
        Err("Unsupported exception: scause: %lx, sepc: %lx\n", scause, sepc);
ffffffe00020229c:	fe043783          	ld	a5,-32(s0)
ffffffe0002022a0:	fe843703          	ld	a4,-24(s0)
ffffffe0002022a4:	00002697          	auipc	a3,0x2
ffffffe0002022a8:	15468693          	addi	a3,a3,340 # ffffffe0002043f8 <__func__.0>
ffffffe0002022ac:	06c00613          	li	a2,108
ffffffe0002022b0:	00002597          	auipc	a1,0x2
ffffffe0002022b4:	fb858593          	addi	a1,a1,-72 # ffffffe000204268 <__func__.0+0x138>
ffffffe0002022b8:	00002517          	auipc	a0,0x2
ffffffe0002022bc:	0e850513          	addi	a0,a0,232 # ffffffe0002043a0 <__func__.0+0x270>
ffffffe0002022c0:	698010ef          	jal	ffffffe000203958 <printk>
ffffffe0002022c4:	00000013          	nop
ffffffe0002022c8:	ffdff06f          	j	ffffffe0002022c4 <trap_handler+0x18c>
    }
}
ffffffe0002022cc:	02813083          	ld	ra,40(sp)
ffffffe0002022d0:	02013403          	ld	s0,32(sp)
ffffffe0002022d4:	03010113          	addi	sp,sp,48
ffffffe0002022d8:	00008067          	ret

ffffffe0002022dc <setup_vm_final>:
extern char _etext[];   // 指向 .text 段结束位置
extern char _erodata[]; // 指向 .rodata 段结束位置
extern char _sdata[];   // 指向 .data 段起始位置

void setup_vm_final()
{
ffffffe0002022dc:	fe010113          	addi	sp,sp,-32
ffffffe0002022e0:	00113c23          	sd	ra,24(sp)
ffffffe0002022e4:	00813823          	sd	s0,16(sp)
ffffffe0002022e8:	02010413          	addi	s0,sp,32
    memset(swapper_pg_dir, 0x0, PGSIZE);
ffffffe0002022ec:	00001637          	lui	a2,0x1
ffffffe0002022f0:	00000593          	li	a1,0
ffffffe0002022f4:	00009517          	auipc	a0,0x9
ffffffe0002022f8:	d0c50513          	addi	a0,a0,-756 # ffffffe00020b000 <swapper_pg_dir>
ffffffe0002022fc:	77c010ef          	jal	ffffffe000203a78 <memset>

    // No OpenSBI mapping required

    // mapping kernel text X|-|R|V
    create_mapping(swapper_pg_dir, (uint64_t)_stext, (uint64_t)_stext - PA2VA_OFFSET, (uint64_t)(_etext - _stext), 11);
ffffffe000202300:	ffffe597          	auipc	a1,0xffffe
ffffffe000202304:	d0058593          	addi	a1,a1,-768 # ffffffe000200000 <_skernel>
ffffffe000202308:	ffffe717          	auipc	a4,0xffffe
ffffffe00020230c:	cf870713          	addi	a4,a4,-776 # ffffffe000200000 <_skernel>
ffffffe000202310:	04100793          	li	a5,65
ffffffe000202314:	01f79793          	slli	a5,a5,0x1f
ffffffe000202318:	00f70633          	add	a2,a4,a5
ffffffe00020231c:	00002717          	auipc	a4,0x2
ffffffe000202320:	84870713          	addi	a4,a4,-1976 # ffffffe000203b64 <_etext>
ffffffe000202324:	ffffe797          	auipc	a5,0xffffe
ffffffe000202328:	cdc78793          	addi	a5,a5,-804 # ffffffe000200000 <_skernel>
ffffffe00020232c:	40f707b3          	sub	a5,a4,a5
ffffffe000202330:	00b00713          	li	a4,11
ffffffe000202334:	00078693          	mv	a3,a5
ffffffe000202338:	00009517          	auipc	a0,0x9
ffffffe00020233c:	cc850513          	addi	a0,a0,-824 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000202340:	0f0000ef          	jal	ffffffe000202430 <create_mapping>

    // mapping kernel rodata -|-|R|V
    create_mapping(swapper_pg_dir, (uint64_t)_srodata, (uint64_t)_srodata - PA2VA_OFFSET, (uint64_t)(_erodata - _srodata), 3);
ffffffe000202344:	00002597          	auipc	a1,0x2
ffffffe000202348:	cbc58593          	addi	a1,a1,-836 # ffffffe000204000 <__func__.0>
ffffffe00020234c:	00002717          	auipc	a4,0x2
ffffffe000202350:	cb470713          	addi	a4,a4,-844 # ffffffe000204000 <__func__.0>
ffffffe000202354:	04100793          	li	a5,65
ffffffe000202358:	01f79793          	slli	a5,a5,0x1f
ffffffe00020235c:	00f70633          	add	a2,a4,a5
ffffffe000202360:	00002717          	auipc	a4,0x2
ffffffe000202364:	20870713          	addi	a4,a4,520 # ffffffe000204568 <_erodata>
ffffffe000202368:	00002797          	auipc	a5,0x2
ffffffe00020236c:	c9878793          	addi	a5,a5,-872 # ffffffe000204000 <__func__.0>
ffffffe000202370:	40f707b3          	sub	a5,a4,a5
ffffffe000202374:	00300713          	li	a4,3
ffffffe000202378:	00078693          	mv	a3,a5
ffffffe00020237c:	00009517          	auipc	a0,0x9
ffffffe000202380:	c8450513          	addi	a0,a0,-892 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000202384:	0ac000ef          	jal	ffffffe000202430 <create_mapping>

    // mapping other memory -|W|R|V
    create_mapping(swapper_pg_dir, (uint64_t)_sdata, (uint64_t)_sdata - PA2VA_OFFSET, PHY_SIZE - (_sdata - _stext), 7);
ffffffe000202388:	00003597          	auipc	a1,0x3
ffffffe00020238c:	c7858593          	addi	a1,a1,-904 # ffffffe000205000 <TIMECLOCK>
ffffffe000202390:	00003717          	auipc	a4,0x3
ffffffe000202394:	c7070713          	addi	a4,a4,-912 # ffffffe000205000 <TIMECLOCK>
ffffffe000202398:	04100793          	li	a5,65
ffffffe00020239c:	01f79793          	slli	a5,a5,0x1f
ffffffe0002023a0:	00f70633          	add	a2,a4,a5
ffffffe0002023a4:	00003717          	auipc	a4,0x3
ffffffe0002023a8:	c5c70713          	addi	a4,a4,-932 # ffffffe000205000 <TIMECLOCK>
ffffffe0002023ac:	ffffe797          	auipc	a5,0xffffe
ffffffe0002023b0:	c5478793          	addi	a5,a5,-940 # ffffffe000200000 <_skernel>
ffffffe0002023b4:	40f707b3          	sub	a5,a4,a5
ffffffe0002023b8:	08000737          	lui	a4,0x8000
ffffffe0002023bc:	40f707b3          	sub	a5,a4,a5
ffffffe0002023c0:	00700713          	li	a4,7
ffffffe0002023c4:	00078693          	mv	a3,a5
ffffffe0002023c8:	00009517          	auipc	a0,0x9
ffffffe0002023cc:	c3850513          	addi	a0,a0,-968 # ffffffe00020b000 <swapper_pg_dir>
ffffffe0002023d0:	060000ef          	jal	ffffffe000202430 <create_mapping>

    // set satp with swapper_pg_dir
    uint64_t _satp = (((uint64_t)(swapper_pg_dir)-PA2VA_OFFSET) >> 12) | (8ULL << 60);
ffffffe0002023d4:	00009717          	auipc	a4,0x9
ffffffe0002023d8:	c2c70713          	addi	a4,a4,-980 # ffffffe00020b000 <swapper_pg_dir>
ffffffe0002023dc:	04100793          	li	a5,65
ffffffe0002023e0:	01f79793          	slli	a5,a5,0x1f
ffffffe0002023e4:	00f707b3          	add	a5,a4,a5
ffffffe0002023e8:	00c7d713          	srli	a4,a5,0xc
ffffffe0002023ec:	fff00793          	li	a5,-1
ffffffe0002023f0:	03f79793          	slli	a5,a5,0x3f
ffffffe0002023f4:	00f767b3          	or	a5,a4,a5
ffffffe0002023f8:	fef43423          	sd	a5,-24(s0)
    csr_write(satp, _satp);
ffffffe0002023fc:	fe843783          	ld	a5,-24(s0)
ffffffe000202400:	fef43023          	sd	a5,-32(s0)
ffffffe000202404:	fe043783          	ld	a5,-32(s0)
ffffffe000202408:	18079073          	csrw	satp,a5
    // flush TLB
    asm volatile("sfence.vma zero, zero");
ffffffe00020240c:	12000073          	sfence.vma
    printk("setup_vm_final done!\n");
ffffffe000202410:	00002517          	auipc	a0,0x2
ffffffe000202414:	ff850513          	addi	a0,a0,-8 # ffffffe000204408 <__func__.0+0x10>
ffffffe000202418:	540010ef          	jal	ffffffe000203958 <printk>
    return;
ffffffe00020241c:	00000013          	nop
}
ffffffe000202420:	01813083          	ld	ra,24(sp)
ffffffe000202424:	01013403          	ld	s0,16(sp)
ffffffe000202428:	02010113          	addi	sp,sp,32
ffffffe00020242c:	00008067          	ret

ffffffe000202430 <create_mapping>:

/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
// 为指定的虚拟地址范围创建映射到物理地址的页表项
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm)
{
ffffffe000202430:	f6010113          	addi	sp,sp,-160
ffffffe000202434:	08113c23          	sd	ra,152(sp)
ffffffe000202438:	08813823          	sd	s0,144(sp)
ffffffe00020243c:	0a010413          	addi	s0,sp,160
ffffffe000202440:	f8a43c23          	sd	a0,-104(s0)
ffffffe000202444:	f8b43823          	sd	a1,-112(s0)
ffffffe000202448:	f8c43423          	sd	a2,-120(s0)
ffffffe00020244c:	f8d43023          	sd	a3,-128(s0)
ffffffe000202450:	f6e43c23          	sd	a4,-136(s0)
    uint64_t va_cur = va;
ffffffe000202454:	f9043783          	ld	a5,-112(s0)
ffffffe000202458:	fef43423          	sd	a5,-24(s0)
    uint64_t va_end = va + sz;
ffffffe00020245c:	f9043703          	ld	a4,-112(s0)
ffffffe000202460:	f8043783          	ld	a5,-128(s0)
ffffffe000202464:	00f707b3          	add	a5,a4,a5
ffffffe000202468:	fcf43423          	sd	a5,-56(s0)
    uint64_t pa_cur = pa;
ffffffe00020246c:	f8843783          	ld	a5,-120(s0)
ffffffe000202470:	fef43023          	sd	a5,-32(s0)
    uint64_t *tbl2_ad, *tbl3_ad;     // 二级和三级页表的指针
    uint64_t *tbl2_pa, *tbl3_pa;     // 物理地址映射的二级和三级页表
    uint64_t index1, index2, index3; // 索引值用于查找各级页表

    // 遍历每一页
    while (va_cur < va_end)
ffffffe000202474:	1dc0006f          	j	ffffffe000202650 <create_mapping+0x220>
    {
        // 计算虚拟地址的各级页表索引
        index1 = (va_cur >> 30) & 0x1FF; // 一级页表索引
ffffffe000202478:	fe843783          	ld	a5,-24(s0)
ffffffe00020247c:	01e7d793          	srli	a5,a5,0x1e
ffffffe000202480:	1ff7f793          	andi	a5,a5,511
ffffffe000202484:	fcf43023          	sd	a5,-64(s0)
        index2 = (va_cur >> 21) & 0x1FF; // 二级页表索引
ffffffe000202488:	fe843783          	ld	a5,-24(s0)
ffffffe00020248c:	0157d793          	srli	a5,a5,0x15
ffffffe000202490:	1ff7f793          	andi	a5,a5,511
ffffffe000202494:	faf43c23          	sd	a5,-72(s0)
        index3 = (va_cur >> 12) & 0x1FF; // 三级页表索引
ffffffe000202498:	fe843783          	ld	a5,-24(s0)
ffffffe00020249c:	00c7d793          	srli	a5,a5,0xc
ffffffe0002024a0:	1ff7f793          	andi	a5,a5,511
ffffffe0002024a4:	faf43823          	sd	a5,-80(s0)

        // 处理一级页表
        if (!(pgtbl[index1] & 0x1))
ffffffe0002024a8:	fc043783          	ld	a5,-64(s0)
ffffffe0002024ac:	00379793          	slli	a5,a5,0x3
ffffffe0002024b0:	f9843703          	ld	a4,-104(s0)
ffffffe0002024b4:	00f707b3          	add	a5,a4,a5
ffffffe0002024b8:	0007b783          	ld	a5,0(a5)
ffffffe0002024bc:	0017f793          	andi	a5,a5,1
ffffffe0002024c0:	04079463          	bnez	a5,ffffffe000202508 <create_mapping+0xd8>
        {
            // 如果一级页表项为空，分配一个新的二级页表
            tbl2_ad = (uint64_t *)kalloc();
ffffffe0002024c4:	cc0fe0ef          	jal	ffffffe000200984 <kalloc>
ffffffe0002024c8:	fca43c23          	sd	a0,-40(s0)
            tbl2_pa = (uint64_t *)((uint64_t)tbl2_ad - PA2VA_OFFSET); // 转换为物理地址
ffffffe0002024cc:	fd843703          	ld	a4,-40(s0)
ffffffe0002024d0:	04100793          	li	a5,65
ffffffe0002024d4:	01f79793          	slli	a5,a5,0x1f
ffffffe0002024d8:	00f707b3          	add	a5,a4,a5
ffffffe0002024dc:	faf43423          	sd	a5,-88(s0)
            pgtbl[index1] = (((uint64_t)tbl2_pa >> 12) << 10) | 0x1;  // 设置页表项
ffffffe0002024e0:	fa843783          	ld	a5,-88(s0)
ffffffe0002024e4:	00c7d793          	srli	a5,a5,0xc
ffffffe0002024e8:	00a79713          	slli	a4,a5,0xa
ffffffe0002024ec:	fc043783          	ld	a5,-64(s0)
ffffffe0002024f0:	00379793          	slli	a5,a5,0x3
ffffffe0002024f4:	f9843683          	ld	a3,-104(s0)
ffffffe0002024f8:	00f687b3          	add	a5,a3,a5
ffffffe0002024fc:	00176713          	ori	a4,a4,1
ffffffe000202500:	00e7b023          	sd	a4,0(a5)
ffffffe000202504:	0300006f          	j	ffffffe000202534 <create_mapping+0x104>
        }
        else
        {
            // 如果一级页表项已存在，使用它指向的二级页表
            tbl2_ad = (uint64_t *)(((pgtbl[index1] >> 10) << 12) + PA2VA_OFFSET);
ffffffe000202508:	fc043783          	ld	a5,-64(s0)
ffffffe00020250c:	00379793          	slli	a5,a5,0x3
ffffffe000202510:	f9843703          	ld	a4,-104(s0)
ffffffe000202514:	00f707b3          	add	a5,a4,a5
ffffffe000202518:	0007b783          	ld	a5,0(a5)
ffffffe00020251c:	00a7d793          	srli	a5,a5,0xa
ffffffe000202520:	00c79713          	slli	a4,a5,0xc
ffffffe000202524:	fbf00793          	li	a5,-65
ffffffe000202528:	01f79793          	slli	a5,a5,0x1f
ffffffe00020252c:	00f707b3          	add	a5,a4,a5
ffffffe000202530:	fcf43c23          	sd	a5,-40(s0)
        }

        // 处理二级页表
        if (!(tbl2_ad[index2] & 0x1))
ffffffe000202534:	fb843783          	ld	a5,-72(s0)
ffffffe000202538:	00379793          	slli	a5,a5,0x3
ffffffe00020253c:	fd843703          	ld	a4,-40(s0)
ffffffe000202540:	00f707b3          	add	a5,a4,a5
ffffffe000202544:	0007b783          	ld	a5,0(a5)
ffffffe000202548:	0017f793          	andi	a5,a5,1
ffffffe00020254c:	04079463          	bnez	a5,ffffffe000202594 <create_mapping+0x164>
        {
            // 如果二级页表项为空，分配一个新的三级页表
            tbl3_ad = (uint64_t *)kalloc();
ffffffe000202550:	c34fe0ef          	jal	ffffffe000200984 <kalloc>
ffffffe000202554:	fca43823          	sd	a0,-48(s0)
            tbl3_pa = (uint64_t *)((uint64_t)tbl3_ad - PA2VA_OFFSET); // 转换为物理地址
ffffffe000202558:	fd043703          	ld	a4,-48(s0)
ffffffe00020255c:	04100793          	li	a5,65
ffffffe000202560:	01f79793          	slli	a5,a5,0x1f
ffffffe000202564:	00f707b3          	add	a5,a4,a5
ffffffe000202568:	faf43023          	sd	a5,-96(s0)
            tbl2_ad[index2] = ((uint64_t)tbl3_pa >> 12) << 10 | 0x1;  // 设置页表项
ffffffe00020256c:	fa043783          	ld	a5,-96(s0)
ffffffe000202570:	00c7d793          	srli	a5,a5,0xc
ffffffe000202574:	00a79713          	slli	a4,a5,0xa
ffffffe000202578:	fb843783          	ld	a5,-72(s0)
ffffffe00020257c:	00379793          	slli	a5,a5,0x3
ffffffe000202580:	fd843683          	ld	a3,-40(s0)
ffffffe000202584:	00f687b3          	add	a5,a3,a5
ffffffe000202588:	00176713          	ori	a4,a4,1
ffffffe00020258c:	00e7b023          	sd	a4,0(a5)
ffffffe000202590:	0300006f          	j	ffffffe0002025c0 <create_mapping+0x190>
        }
        else
        {
            // 如果二级页表项已存在，使用它指向的三级页表
            tbl3_ad = (uint64_t *)(((tbl2_ad[index2] >> 10) << 12) + PA2VA_OFFSET);
ffffffe000202594:	fb843783          	ld	a5,-72(s0)
ffffffe000202598:	00379793          	slli	a5,a5,0x3
ffffffe00020259c:	fd843703          	ld	a4,-40(s0)
ffffffe0002025a0:	00f707b3          	add	a5,a4,a5
ffffffe0002025a4:	0007b783          	ld	a5,0(a5)
ffffffe0002025a8:	00a7d793          	srli	a5,a5,0xa
ffffffe0002025ac:	00c79713          	slli	a4,a5,0xc
ffffffe0002025b0:	fbf00793          	li	a5,-65
ffffffe0002025b4:	01f79793          	slli	a5,a5,0x1f
ffffffe0002025b8:	00f707b3          	add	a5,a4,a5
ffffffe0002025bc:	fcf43823          	sd	a5,-48(s0)
        }

        // 处理三级页表，创建虚拟地址到物理地址的映射
        if (!(tbl3_ad[index3] & 0x1))
ffffffe0002025c0:	fb043783          	ld	a5,-80(s0)
ffffffe0002025c4:	00379793          	slli	a5,a5,0x3
ffffffe0002025c8:	fd043703          	ld	a4,-48(s0)
ffffffe0002025cc:	00f707b3          	add	a5,a4,a5
ffffffe0002025d0:	0007b783          	ld	a5,0(a5)
ffffffe0002025d4:	0017f793          	andi	a5,a5,1
ffffffe0002025d8:	02079863          	bnez	a5,ffffffe000202608 <create_mapping+0x1d8>
        {
            tbl3_ad[index3] = (pa_cur >> 12) << 10 | perm; // 设置页表项，加入权限
ffffffe0002025dc:	fe043783          	ld	a5,-32(s0)
ffffffe0002025e0:	00c7d793          	srli	a5,a5,0xc
ffffffe0002025e4:	00a79693          	slli	a3,a5,0xa
ffffffe0002025e8:	fb043783          	ld	a5,-80(s0)
ffffffe0002025ec:	00379793          	slli	a5,a5,0x3
ffffffe0002025f0:	fd043703          	ld	a4,-48(s0)
ffffffe0002025f4:	00f707b3          	add	a5,a4,a5
ffffffe0002025f8:	f7843703          	ld	a4,-136(s0)
ffffffe0002025fc:	00e6e733          	or	a4,a3,a4
ffffffe000202600:	00e7b023          	sd	a4,0(a5)
ffffffe000202604:	02c0006f          	j	ffffffe000202630 <create_mapping+0x200>
        }
        else
        {
            // 如果三级页表项已存在，报错
            Err("create_mapping: mapping already exists!\n");
ffffffe000202608:	00002697          	auipc	a3,0x2
ffffffe00020260c:	ec068693          	addi	a3,a3,-320 # ffffffe0002044c8 <__func__.0>
ffffffe000202610:	06500613          	li	a2,101
ffffffe000202614:	00002597          	auipc	a1,0x2
ffffffe000202618:	e0c58593          	addi	a1,a1,-500 # ffffffe000204420 <__func__.0+0x28>
ffffffe00020261c:	00002517          	auipc	a0,0x2
ffffffe000202620:	e0c50513          	addi	a0,a0,-500 # ffffffe000204428 <__func__.0+0x30>
ffffffe000202624:	334010ef          	jal	ffffffe000203958 <printk>
ffffffe000202628:	00000013          	nop
ffffffe00020262c:	ffdff06f          	j	ffffffe000202628 <create_mapping+0x1f8>
        }

        // 移动到下一页
        va_cur += PGSIZE;
ffffffe000202630:	fe843703          	ld	a4,-24(s0)
ffffffe000202634:	000017b7          	lui	a5,0x1
ffffffe000202638:	00f707b3          	add	a5,a4,a5
ffffffe00020263c:	fef43423          	sd	a5,-24(s0)
        pa_cur += PGSIZE;
ffffffe000202640:	fe043703          	ld	a4,-32(s0)
ffffffe000202644:	000017b7          	lui	a5,0x1
ffffffe000202648:	00f707b3          	add	a5,a4,a5
ffffffe00020264c:	fef43023          	sd	a5,-32(s0)
    while (va_cur < va_end)
ffffffe000202650:	fe843703          	ld	a4,-24(s0)
ffffffe000202654:	fc843783          	ld	a5,-56(s0)
ffffffe000202658:	e2f760e3          	bltu	a4,a5,ffffffe000202478 <create_mapping+0x48>
    }

    // 完成映射
    // printk("create_mapping done!\n");
    // root: ffffffe00020b000, [80200000, 80204000) -> [ffffffe000200000, ffffffe000204000), perm: cb
    Log("root: %lx, [%lx, %lx) -> [%lx, %lx), perm: %lx", pgtbl, pa, pa + sz, va, va_end, perm);
ffffffe00020265c:	f8843703          	ld	a4,-120(s0)
ffffffe000202660:	f8043783          	ld	a5,-128(s0)
ffffffe000202664:	00f70733          	add	a4,a4,a5
ffffffe000202668:	f7843783          	ld	a5,-136(s0)
ffffffe00020266c:	00f13423          	sd	a5,8(sp)
ffffffe000202670:	fc843783          	ld	a5,-56(s0)
ffffffe000202674:	00f13023          	sd	a5,0(sp)
ffffffe000202678:	f9043883          	ld	a7,-112(s0)
ffffffe00020267c:	00070813          	mv	a6,a4
ffffffe000202680:	f8843783          	ld	a5,-120(s0)
ffffffe000202684:	f9843703          	ld	a4,-104(s0)
ffffffe000202688:	00002697          	auipc	a3,0x2
ffffffe00020268c:	e4068693          	addi	a3,a3,-448 # ffffffe0002044c8 <__func__.0>
ffffffe000202690:	07000613          	li	a2,112
ffffffe000202694:	00002597          	auipc	a1,0x2
ffffffe000202698:	d8c58593          	addi	a1,a1,-628 # ffffffe000204420 <__func__.0+0x28>
ffffffe00020269c:	00002517          	auipc	a0,0x2
ffffffe0002026a0:	dcc50513          	addi	a0,a0,-564 # ffffffe000204468 <__func__.0+0x70>
ffffffe0002026a4:	2b4010ef          	jal	ffffffe000203958 <printk>
}
ffffffe0002026a8:	00000013          	nop
ffffffe0002026ac:	09813083          	ld	ra,152(sp)
ffffffe0002026b0:	09013403          	ld	s0,144(sp)
ffffffe0002026b4:	0a010113          	addi	sp,sp,160
ffffffe0002026b8:	00008067          	ret

ffffffe0002026bc <get_pa>:

uint64_t get_pa(uint64_t *pgtbl, uint64_t va)
{
ffffffe0002026bc:	fb010113          	addi	sp,sp,-80
ffffffe0002026c0:	04813423          	sd	s0,72(sp)
ffffffe0002026c4:	05010413          	addi	s0,sp,80
ffffffe0002026c8:	faa43c23          	sd	a0,-72(s0)
ffffffe0002026cc:	fab43823          	sd	a1,-80(s0)
    uint64_t pa = 0;
ffffffe0002026d0:	fe043423          	sd	zero,-24(s0)
    uint64_t *tbl2_ad, *tbl3_ad;     // 二级和三级页表的指针
    uint64_t *tbl2_pa, *tbl3_pa;     // 物理地址映射的二级和三级页表
    uint64_t index1, index2, index3; // 索引值用于查找各级页表

    // 计算虚拟地址的各级页表索引
    index1 = (va >> 30) & 0x1FF; // 一级页表索引
ffffffe0002026d4:	fb043783          	ld	a5,-80(s0)
ffffffe0002026d8:	01e7d793          	srli	a5,a5,0x1e
ffffffe0002026dc:	1ff7f793          	andi	a5,a5,511
ffffffe0002026e0:	fef43023          	sd	a5,-32(s0)
    index2 = (va >> 21) & 0x1FF; // 二级页表索引
ffffffe0002026e4:	fb043783          	ld	a5,-80(s0)
ffffffe0002026e8:	0157d793          	srli	a5,a5,0x15
ffffffe0002026ec:	1ff7f793          	andi	a5,a5,511
ffffffe0002026f0:	fcf43c23          	sd	a5,-40(s0)
    index3 = (va >> 12) & 0x1FF; // 三级页表索引
ffffffe0002026f4:	fb043783          	ld	a5,-80(s0)
ffffffe0002026f8:	00c7d793          	srli	a5,a5,0xc
ffffffe0002026fc:	1ff7f793          	andi	a5,a5,511
ffffffe000202700:	fcf43823          	sd	a5,-48(s0)

    // 如果一级页表项为空，返回空指针
    // 如果一级页表项已存在，使用它指向的二级页表
    if (!(pgtbl[index1] & 0x1))
ffffffe000202704:	fe043783          	ld	a5,-32(s0)
ffffffe000202708:	00379793          	slli	a5,a5,0x3
ffffffe00020270c:	fb843703          	ld	a4,-72(s0)
ffffffe000202710:	00f707b3          	add	a5,a4,a5
ffffffe000202714:	0007b783          	ld	a5,0(a5) # 1000 <PGSIZE>
ffffffe000202718:	0017f793          	andi	a5,a5,1
ffffffe00020271c:	00079663          	bnez	a5,ffffffe000202728 <get_pa+0x6c>
        return 0;
ffffffe000202720:	00000793          	li	a5,0
ffffffe000202724:	0dc0006f          	j	ffffffe000202800 <get_pa+0x144>
    else
        tbl2_ad = (uint64_t *)(((pgtbl[index1] >> 10) << 12) + PA2VA_OFFSET);
ffffffe000202728:	fe043783          	ld	a5,-32(s0)
ffffffe00020272c:	00379793          	slli	a5,a5,0x3
ffffffe000202730:	fb843703          	ld	a4,-72(s0)
ffffffe000202734:	00f707b3          	add	a5,a4,a5
ffffffe000202738:	0007b783          	ld	a5,0(a5)
ffffffe00020273c:	00a7d793          	srli	a5,a5,0xa
ffffffe000202740:	00c79713          	slli	a4,a5,0xc
ffffffe000202744:	fbf00793          	li	a5,-65
ffffffe000202748:	01f79793          	slli	a5,a5,0x1f
ffffffe00020274c:	00f707b3          	add	a5,a4,a5
ffffffe000202750:	fcf43423          	sd	a5,-56(s0)

    // 如果二级页表项为空，返回空指针
    // 如果二级页表项已存在，使用它指向的三级页表
    if (!(tbl2_ad[index2] & 0x1))
ffffffe000202754:	fd843783          	ld	a5,-40(s0)
ffffffe000202758:	00379793          	slli	a5,a5,0x3
ffffffe00020275c:	fc843703          	ld	a4,-56(s0)
ffffffe000202760:	00f707b3          	add	a5,a4,a5
ffffffe000202764:	0007b783          	ld	a5,0(a5)
ffffffe000202768:	0017f793          	andi	a5,a5,1
ffffffe00020276c:	00079663          	bnez	a5,ffffffe000202778 <get_pa+0xbc>
        return 0;
ffffffe000202770:	00000793          	li	a5,0
ffffffe000202774:	08c0006f          	j	ffffffe000202800 <get_pa+0x144>
    else
        tbl3_ad = (uint64_t *)(((tbl2_ad[index2] >> 10) << 12) + PA2VA_OFFSET);
ffffffe000202778:	fd843783          	ld	a5,-40(s0)
ffffffe00020277c:	00379793          	slli	a5,a5,0x3
ffffffe000202780:	fc843703          	ld	a4,-56(s0)
ffffffe000202784:	00f707b3          	add	a5,a4,a5
ffffffe000202788:	0007b783          	ld	a5,0(a5)
ffffffe00020278c:	00a7d793          	srli	a5,a5,0xa
ffffffe000202790:	00c79713          	slli	a4,a5,0xc
ffffffe000202794:	fbf00793          	li	a5,-65
ffffffe000202798:	01f79793          	slli	a5,a5,0x1f
ffffffe00020279c:	00f707b3          	add	a5,a4,a5
ffffffe0002027a0:	fcf43023          	sd	a5,-64(s0)

    // 如果三级页表项为空，返回空指针
    // 如果三级页表项已存在，使用它指向的物理页
    if (!(tbl3_ad[index3] & 0x1))
ffffffe0002027a4:	fd043783          	ld	a5,-48(s0)
ffffffe0002027a8:	00379793          	slli	a5,a5,0x3
ffffffe0002027ac:	fc043703          	ld	a4,-64(s0)
ffffffe0002027b0:	00f707b3          	add	a5,a4,a5
ffffffe0002027b4:	0007b783          	ld	a5,0(a5)
ffffffe0002027b8:	0017f793          	andi	a5,a5,1
ffffffe0002027bc:	00079663          	bnez	a5,ffffffe0002027c8 <get_pa+0x10c>
        return 0;
ffffffe0002027c0:	00000793          	li	a5,0
ffffffe0002027c4:	03c0006f          	j	ffffffe000202800 <get_pa+0x144>
    else
        pa = ((tbl3_ad[index3] >> 10) << 12) | (va & 0xFFF);
ffffffe0002027c8:	fd043783          	ld	a5,-48(s0)
ffffffe0002027cc:	00379793          	slli	a5,a5,0x3
ffffffe0002027d0:	fc043703          	ld	a4,-64(s0)
ffffffe0002027d4:	00f707b3          	add	a5,a4,a5
ffffffe0002027d8:	0007b783          	ld	a5,0(a5)
ffffffe0002027dc:	00a7d793          	srli	a5,a5,0xa
ffffffe0002027e0:	00c79713          	slli	a4,a5,0xc
ffffffe0002027e4:	fb043683          	ld	a3,-80(s0)
ffffffe0002027e8:	000017b7          	lui	a5,0x1
ffffffe0002027ec:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe0002027f0:	00f6f7b3          	and	a5,a3,a5
ffffffe0002027f4:	00f767b3          	or	a5,a4,a5
ffffffe0002027f8:	fef43423          	sd	a5,-24(s0)
    return pa;
ffffffe0002027fc:	fe843783          	ld	a5,-24(s0)
}
ffffffe000202800:	00078513          	mv	a0,a5
ffffffe000202804:	04813403          	ld	s0,72(sp)
ffffffe000202808:	05010113          	addi	sp,sp,80
ffffffe00020280c:	00008067          	ret

ffffffe000202810 <setup_vm>:

void setup_vm(void)
{
ffffffe000202810:	fd010113          	addi	sp,sp,-48
ffffffe000202814:	02113423          	sd	ra,40(sp)
ffffffe000202818:	02813023          	sd	s0,32(sp)
ffffffe00020281c:	03010413          	addi	s0,sp,48
    uint64_t pa = PHY_START;
ffffffe000202820:	00100793          	li	a5,1
ffffffe000202824:	01f79793          	slli	a5,a5,0x1f
ffffffe000202828:	fef43423          	sd	a5,-24(s0)
    // 等值映射
    uint64_t va1 = pa;
ffffffe00020282c:	fe843783          	ld	a5,-24(s0)
ffffffe000202830:	fef43023          	sd	a5,-32(s0)
    // 映射至高位
    uint64_t va2 = VM_START;
ffffffe000202834:	fff00793          	li	a5,-1
ffffffe000202838:	02579793          	slli	a5,a5,0x25
ffffffe00020283c:	fcf43c23          	sd	a5,-40(s0)
    uint64_t index;
    // 页表的虚拟页号 9位
    index = (va1 >> 30) & 0x1ff;
ffffffe000202840:	fe043783          	ld	a5,-32(s0)
ffffffe000202844:	01e7d793          	srli	a5,a5,0x1e
ffffffe000202848:	1ff7f793          	andi	a5,a5,511
ffffffe00020284c:	fcf43823          	sd	a5,-48(s0)
    early_pgtbl[index] = ((pa >> 12) << 10) | 0xf;
ffffffe000202850:	fe843783          	ld	a5,-24(s0)
ffffffe000202854:	00c7d793          	srli	a5,a5,0xc
ffffffe000202858:	00a79793          	slli	a5,a5,0xa
ffffffe00020285c:	00f7e713          	ori	a4,a5,15
ffffffe000202860:	00007697          	auipc	a3,0x7
ffffffe000202864:	7a068693          	addi	a3,a3,1952 # ffffffe00020a000 <early_pgtbl>
ffffffe000202868:	fd043783          	ld	a5,-48(s0)
ffffffe00020286c:	00379793          	slli	a5,a5,0x3
ffffffe000202870:	00f687b3          	add	a5,a3,a5
ffffffe000202874:	00e7b023          	sd	a4,0(a5)

    // 同理
    index = (va2 >> 30) & 0x1ff;
ffffffe000202878:	fd843783          	ld	a5,-40(s0)
ffffffe00020287c:	01e7d793          	srli	a5,a5,0x1e
ffffffe000202880:	1ff7f793          	andi	a5,a5,511
ffffffe000202884:	fcf43823          	sd	a5,-48(s0)
    early_pgtbl[index] = ((pa >> 12) << 10) | 0xf;
ffffffe000202888:	fe843783          	ld	a5,-24(s0)
ffffffe00020288c:	00c7d793          	srli	a5,a5,0xc
ffffffe000202890:	00a79793          	slli	a5,a5,0xa
ffffffe000202894:	00f7e713          	ori	a4,a5,15
ffffffe000202898:	00007697          	auipc	a3,0x7
ffffffe00020289c:	76868693          	addi	a3,a3,1896 # ffffffe00020a000 <early_pgtbl>
ffffffe0002028a0:	fd043783          	ld	a5,-48(s0)
ffffffe0002028a4:	00379793          	slli	a5,a5,0x3
ffffffe0002028a8:	00f687b3          	add	a5,a3,a5
ffffffe0002028ac:	00e7b023          	sd	a4,0(a5)

    printk("...setup_vm done!\n");
ffffffe0002028b0:	00002517          	auipc	a0,0x2
ffffffe0002028b4:	c0050513          	addi	a0,a0,-1024 # ffffffe0002044b0 <__func__.0+0xb8>
ffffffe0002028b8:	0a0010ef          	jal	ffffffe000203958 <printk>
}
ffffffe0002028bc:	00000013          	nop
ffffffe0002028c0:	02813083          	ld	ra,40(sp)
ffffffe0002028c4:	02013403          	ld	s0,32(sp)
ffffffe0002028c8:	03010113          	addi	sp,sp,48
ffffffe0002028cc:	00008067          	ret

ffffffe0002028d0 <page_deep_copy_rec>:

void page_deep_copy_rec(uint64_t *pgtbl, int level)
{
ffffffe0002028d0:	fb010113          	addi	sp,sp,-80
ffffffe0002028d4:	04113423          	sd	ra,72(sp)
ffffffe0002028d8:	04813023          	sd	s0,64(sp)
ffffffe0002028dc:	05010413          	addi	s0,sp,80
ffffffe0002028e0:	faa43c23          	sd	a0,-72(s0)
ffffffe0002028e4:	00058793          	mv	a5,a1
ffffffe0002028e8:	faf42a23          	sw	a5,-76(s0)
    if (level == 3)
ffffffe0002028ec:	fb442783          	lw	a5,-76(s0)
ffffffe0002028f0:	0007871b          	sext.w	a4,a5
ffffffe0002028f4:	00300793          	li	a5,3
ffffffe0002028f8:	0ef70663          	beq	a4,a5,ffffffe0002029e4 <page_deep_copy_rec+0x114>
        return;
    for (int i = 0; i < 512; i++)
ffffffe0002028fc:	fe042623          	sw	zero,-20(s0)
ffffffe000202900:	0d00006f          	j	ffffffe0002029d0 <page_deep_copy_rec+0x100>
    {
        if (!(pgtbl[i] & 0x1))
ffffffe000202904:	fec42783          	lw	a5,-20(s0)
ffffffe000202908:	00379793          	slli	a5,a5,0x3
ffffffe00020290c:	fb843703          	ld	a4,-72(s0)
ffffffe000202910:	00f707b3          	add	a5,a4,a5
ffffffe000202914:	0007b783          	ld	a5,0(a5)
ffffffe000202918:	0017f793          	andi	a5,a5,1
ffffffe00020291c:	0a078263          	beqz	a5,ffffffe0002029c0 <page_deep_copy_rec+0xf0>
            continue;
        uint64_t *tbl2_ad = (uint64_t *)alloc_page();         // 新复制次级页表的地址
ffffffe000202920:	ff1fd0ef          	jal	ffffffe000200910 <alloc_page>
ffffffe000202924:	fea43023          	sd	a0,-32(s0)
        uint64_t *tbl2_pa = (uint64_t)tbl2_ad - PA2VA_OFFSET; // 物理地址
ffffffe000202928:	fe043703          	ld	a4,-32(s0)
ffffffe00020292c:	04100793          	li	a5,65
ffffffe000202930:	01f79793          	slli	a5,a5,0x1f
ffffffe000202934:	00f707b3          	add	a5,a4,a5
ffffffe000202938:	fcf43c23          	sd	a5,-40(s0)
        uint64_t *oldtbl_pa = (pgtbl[i] >> 10) << 12;
ffffffe00020293c:	fec42783          	lw	a5,-20(s0)
ffffffe000202940:	00379793          	slli	a5,a5,0x3
ffffffe000202944:	fb843703          	ld	a4,-72(s0)
ffffffe000202948:	00f707b3          	add	a5,a4,a5
ffffffe00020294c:	0007b783          	ld	a5,0(a5)
ffffffe000202950:	00a7d793          	srli	a5,a5,0xa
ffffffe000202954:	00c79793          	slli	a5,a5,0xc
ffffffe000202958:	fcf43823          	sd	a5,-48(s0)
        uint64_t *oldtbl_ad = (uint64_t)oldtbl_pa + PA2VA_OFFSET;
ffffffe00020295c:	fd043703          	ld	a4,-48(s0)
ffffffe000202960:	fbf00793          	li	a5,-65
ffffffe000202964:	01f79793          	slli	a5,a5,0x1f
ffffffe000202968:	00f707b3          	add	a5,a4,a5
ffffffe00020296c:	fcf43423          	sd	a5,-56(s0)
        memcpy((void *)tbl2_ad, (void *)oldtbl_ad, PGSIZE); // 复制次级页表
ffffffe000202970:	00001637          	lui	a2,0x1
ffffffe000202974:	fc843583          	ld	a1,-56(s0)
ffffffe000202978:	fe043503          	ld	a0,-32(s0)
ffffffe00020297c:	16c010ef          	jal	ffffffe000203ae8 <memcpy>
        pgtbl[i] = (((uint64_t)tbl2_pa >> 12) << 10) | 0x1; // 保存拷贝的页表
ffffffe000202980:	fd843783          	ld	a5,-40(s0)
ffffffe000202984:	00c7d793          	srli	a5,a5,0xc
ffffffe000202988:	00a79713          	slli	a4,a5,0xa
ffffffe00020298c:	fec42783          	lw	a5,-20(s0)
ffffffe000202990:	00379793          	slli	a5,a5,0x3
ffffffe000202994:	fb843683          	ld	a3,-72(s0)
ffffffe000202998:	00f687b3          	add	a5,a3,a5
ffffffe00020299c:	00176713          	ori	a4,a4,1
ffffffe0002029a0:	00e7b023          	sd	a4,0(a5)
        page_deep_copy_rec((uint64_t *)tbl2_ad, level + 1);
ffffffe0002029a4:	fb442783          	lw	a5,-76(s0)
ffffffe0002029a8:	0017879b          	addiw	a5,a5,1
ffffffe0002029ac:	0007879b          	sext.w	a5,a5
ffffffe0002029b0:	00078593          	mv	a1,a5
ffffffe0002029b4:	fe043503          	ld	a0,-32(s0)
ffffffe0002029b8:	f19ff0ef          	jal	ffffffe0002028d0 <page_deep_copy_rec>
ffffffe0002029bc:	0080006f          	j	ffffffe0002029c4 <page_deep_copy_rec+0xf4>
            continue;
ffffffe0002029c0:	00000013          	nop
    for (int i = 0; i < 512; i++)
ffffffe0002029c4:	fec42783          	lw	a5,-20(s0)
ffffffe0002029c8:	0017879b          	addiw	a5,a5,1
ffffffe0002029cc:	fef42623          	sw	a5,-20(s0)
ffffffe0002029d0:	fec42783          	lw	a5,-20(s0)
ffffffe0002029d4:	0007871b          	sext.w	a4,a5
ffffffe0002029d8:	1ff00793          	li	a5,511
ffffffe0002029dc:	f2e7d4e3          	bge	a5,a4,ffffffe000202904 <page_deep_copy_rec+0x34>
ffffffe0002029e0:	0080006f          	j	ffffffe0002029e8 <page_deep_copy_rec+0x118>
        return;
ffffffe0002029e4:	00000013          	nop
    }
}
ffffffe0002029e8:	04813083          	ld	ra,72(sp)
ffffffe0002029ec:	04013403          	ld	s0,64(sp)
ffffffe0002029f0:	05010113          	addi	sp,sp,80
ffffffe0002029f4:	00008067          	ret

ffffffe0002029f8 <page_deep_copy>:

void page_deep_copy(uint64_t *pgtbl)
{
ffffffe0002029f8:	fe010113          	addi	sp,sp,-32
ffffffe0002029fc:	00113c23          	sd	ra,24(sp)
ffffffe000202a00:	00813823          	sd	s0,16(sp)
ffffffe000202a04:	02010413          	addi	s0,sp,32
ffffffe000202a08:	fea43423          	sd	a0,-24(s0)
    page_deep_copy_rec(pgtbl, 1);
ffffffe000202a0c:	00100593          	li	a1,1
ffffffe000202a10:	fe843503          	ld	a0,-24(s0)
ffffffe000202a14:	ebdff0ef          	jal	ffffffe0002028d0 <page_deep_copy_rec>
ffffffe000202a18:	00000013          	nop
ffffffe000202a1c:	01813083          	ld	ra,24(sp)
ffffffe000202a20:	01013403          	ld	s0,16(sp)
ffffffe000202a24:	02010113          	addi	sp,sp,32
ffffffe000202a28:	00008067          	ret

ffffffe000202a2c <start_kernel>:
#include "printk.h"
#include "proc.h"

extern void test();

int start_kernel() {
ffffffe000202a2c:	ff010113          	addi	sp,sp,-16
ffffffe000202a30:	00113423          	sd	ra,8(sp)
ffffffe000202a34:	00813023          	sd	s0,0(sp)
ffffffe000202a38:	01010413          	addi	s0,sp,16
    printk("2024");
ffffffe000202a3c:	00002517          	auipc	a0,0x2
ffffffe000202a40:	a9c50513          	addi	a0,a0,-1380 # ffffffe0002044d8 <__func__.0+0x10>
ffffffe000202a44:	715000ef          	jal	ffffffe000203958 <printk>
    printk(" ZJU Operating System\n");
ffffffe000202a48:	00002517          	auipc	a0,0x2
ffffffe000202a4c:	a9850513          	addi	a0,a0,-1384 # ffffffe0002044e0 <__func__.0+0x18>
ffffffe000202a50:	709000ef          	jal	ffffffe000203958 <printk>

    schedule();
ffffffe000202a54:	8cdfe0ef          	jal	ffffffe000201320 <schedule>
    test();
ffffffe000202a58:	01c000ef          	jal	ffffffe000202a74 <test>
    return 0;
ffffffe000202a5c:	00000793          	li	a5,0
}
ffffffe000202a60:	00078513          	mv	a0,a5
ffffffe000202a64:	00813083          	ld	ra,8(sp)
ffffffe000202a68:	00013403          	ld	s0,0(sp)
ffffffe000202a6c:	01010113          	addi	sp,sp,16
ffffffe000202a70:	00008067          	ret

ffffffe000202a74 <test>:
#include "sbi.h"
#include "printk.h"
#include "defs.h"

void test() {
ffffffe000202a74:	fe010113          	addi	sp,sp,-32
ffffffe000202a78:	00113c23          	sd	ra,24(sp)
ffffffe000202a7c:	00813823          	sd	s0,16(sp)
ffffffe000202a80:	02010413          	addi	s0,sp,32
    int i = 0;
ffffffe000202a84:	fe042623          	sw	zero,-20(s0)
    //     printk("sscratch write failed: write=0x%lx, read=0x%lx\n", data_to_write, read_value);
    // }


    while (1) {
        if ((++i) % 100000000 == 0) {
ffffffe000202a88:	fec42783          	lw	a5,-20(s0)
ffffffe000202a8c:	0017879b          	addiw	a5,a5,1
ffffffe000202a90:	fef42623          	sw	a5,-20(s0)
ffffffe000202a94:	fec42783          	lw	a5,-20(s0)
ffffffe000202a98:	00078713          	mv	a4,a5
ffffffe000202a9c:	05f5e7b7          	lui	a5,0x5f5e
ffffffe000202aa0:	1007879b          	addiw	a5,a5,256 # 5f5e100 <OPENSBI_SIZE+0x5d5e100>
ffffffe000202aa4:	02f767bb          	remw	a5,a4,a5
ffffffe000202aa8:	0007879b          	sext.w	a5,a5
ffffffe000202aac:	fc079ee3          	bnez	a5,ffffffe000202a88 <test+0x14>
            printk("kernel is running!\n");
ffffffe000202ab0:	00002517          	auipc	a0,0x2
ffffffe000202ab4:	a4850513          	addi	a0,a0,-1464 # ffffffe0002044f8 <__func__.0+0x30>
ffffffe000202ab8:	6a1000ef          	jal	ffffffe000203958 <printk>
            i = 0;
ffffffe000202abc:	fe042623          	sw	zero,-20(s0)
        if ((++i) % 100000000 == 0) {
ffffffe000202ac0:	fc9ff06f          	j	ffffffe000202a88 <test+0x14>

ffffffe000202ac4 <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
ffffffe000202ac4:	fe010113          	addi	sp,sp,-32
ffffffe000202ac8:	00113c23          	sd	ra,24(sp)
ffffffe000202acc:	00813823          	sd	s0,16(sp)
ffffffe000202ad0:	02010413          	addi	s0,sp,32
ffffffe000202ad4:	00050793          	mv	a5,a0
ffffffe000202ad8:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
ffffffe000202adc:	fec42783          	lw	a5,-20(s0)
ffffffe000202ae0:	0ff7f793          	zext.b	a5,a5
ffffffe000202ae4:	00078513          	mv	a0,a5
ffffffe000202ae8:	c25fe0ef          	jal	ffffffe00020170c <sbi_debug_console_write_byte>
    return (char)c;
ffffffe000202aec:	fec42783          	lw	a5,-20(s0)
ffffffe000202af0:	0ff7f793          	zext.b	a5,a5
ffffffe000202af4:	0007879b          	sext.w	a5,a5
}
ffffffe000202af8:	00078513          	mv	a0,a5
ffffffe000202afc:	01813083          	ld	ra,24(sp)
ffffffe000202b00:	01013403          	ld	s0,16(sp)
ffffffe000202b04:	02010113          	addi	sp,sp,32
ffffffe000202b08:	00008067          	ret

ffffffe000202b0c <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
ffffffe000202b0c:	fe010113          	addi	sp,sp,-32
ffffffe000202b10:	00813c23          	sd	s0,24(sp)
ffffffe000202b14:	02010413          	addi	s0,sp,32
ffffffe000202b18:	00050793          	mv	a5,a0
ffffffe000202b1c:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
ffffffe000202b20:	fec42783          	lw	a5,-20(s0)
ffffffe000202b24:	0007871b          	sext.w	a4,a5
ffffffe000202b28:	02000793          	li	a5,32
ffffffe000202b2c:	02f70263          	beq	a4,a5,ffffffe000202b50 <isspace+0x44>
ffffffe000202b30:	fec42783          	lw	a5,-20(s0)
ffffffe000202b34:	0007871b          	sext.w	a4,a5
ffffffe000202b38:	00800793          	li	a5,8
ffffffe000202b3c:	00e7de63          	bge	a5,a4,ffffffe000202b58 <isspace+0x4c>
ffffffe000202b40:	fec42783          	lw	a5,-20(s0)
ffffffe000202b44:	0007871b          	sext.w	a4,a5
ffffffe000202b48:	00d00793          	li	a5,13
ffffffe000202b4c:	00e7c663          	blt	a5,a4,ffffffe000202b58 <isspace+0x4c>
ffffffe000202b50:	00100793          	li	a5,1
ffffffe000202b54:	0080006f          	j	ffffffe000202b5c <isspace+0x50>
ffffffe000202b58:	00000793          	li	a5,0
}
ffffffe000202b5c:	00078513          	mv	a0,a5
ffffffe000202b60:	01813403          	ld	s0,24(sp)
ffffffe000202b64:	02010113          	addi	sp,sp,32
ffffffe000202b68:	00008067          	ret

ffffffe000202b6c <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
ffffffe000202b6c:	fb010113          	addi	sp,sp,-80
ffffffe000202b70:	04113423          	sd	ra,72(sp)
ffffffe000202b74:	04813023          	sd	s0,64(sp)
ffffffe000202b78:	05010413          	addi	s0,sp,80
ffffffe000202b7c:	fca43423          	sd	a0,-56(s0)
ffffffe000202b80:	fcb43023          	sd	a1,-64(s0)
ffffffe000202b84:	00060793          	mv	a5,a2
ffffffe000202b88:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
ffffffe000202b8c:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
ffffffe000202b90:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
ffffffe000202b94:	fc843783          	ld	a5,-56(s0)
ffffffe000202b98:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
ffffffe000202b9c:	0100006f          	j	ffffffe000202bac <strtol+0x40>
        p++;
ffffffe000202ba0:	fd843783          	ld	a5,-40(s0)
ffffffe000202ba4:	00178793          	addi	a5,a5,1
ffffffe000202ba8:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
ffffffe000202bac:	fd843783          	ld	a5,-40(s0)
ffffffe000202bb0:	0007c783          	lbu	a5,0(a5)
ffffffe000202bb4:	0007879b          	sext.w	a5,a5
ffffffe000202bb8:	00078513          	mv	a0,a5
ffffffe000202bbc:	f51ff0ef          	jal	ffffffe000202b0c <isspace>
ffffffe000202bc0:	00050793          	mv	a5,a0
ffffffe000202bc4:	fc079ee3          	bnez	a5,ffffffe000202ba0 <strtol+0x34>
    }

    if (*p == '-') {
ffffffe000202bc8:	fd843783          	ld	a5,-40(s0)
ffffffe000202bcc:	0007c783          	lbu	a5,0(a5)
ffffffe000202bd0:	00078713          	mv	a4,a5
ffffffe000202bd4:	02d00793          	li	a5,45
ffffffe000202bd8:	00f71e63          	bne	a4,a5,ffffffe000202bf4 <strtol+0x88>
        neg = true;
ffffffe000202bdc:	00100793          	li	a5,1
ffffffe000202be0:	fef403a3          	sb	a5,-25(s0)
        p++;
ffffffe000202be4:	fd843783          	ld	a5,-40(s0)
ffffffe000202be8:	00178793          	addi	a5,a5,1
ffffffe000202bec:	fcf43c23          	sd	a5,-40(s0)
ffffffe000202bf0:	0240006f          	j	ffffffe000202c14 <strtol+0xa8>
    } else if (*p == '+') {
ffffffe000202bf4:	fd843783          	ld	a5,-40(s0)
ffffffe000202bf8:	0007c783          	lbu	a5,0(a5)
ffffffe000202bfc:	00078713          	mv	a4,a5
ffffffe000202c00:	02b00793          	li	a5,43
ffffffe000202c04:	00f71863          	bne	a4,a5,ffffffe000202c14 <strtol+0xa8>
        p++;
ffffffe000202c08:	fd843783          	ld	a5,-40(s0)
ffffffe000202c0c:	00178793          	addi	a5,a5,1
ffffffe000202c10:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
ffffffe000202c14:	fbc42783          	lw	a5,-68(s0)
ffffffe000202c18:	0007879b          	sext.w	a5,a5
ffffffe000202c1c:	06079c63          	bnez	a5,ffffffe000202c94 <strtol+0x128>
        if (*p == '0') {
ffffffe000202c20:	fd843783          	ld	a5,-40(s0)
ffffffe000202c24:	0007c783          	lbu	a5,0(a5)
ffffffe000202c28:	00078713          	mv	a4,a5
ffffffe000202c2c:	03000793          	li	a5,48
ffffffe000202c30:	04f71e63          	bne	a4,a5,ffffffe000202c8c <strtol+0x120>
            p++;
ffffffe000202c34:	fd843783          	ld	a5,-40(s0)
ffffffe000202c38:	00178793          	addi	a5,a5,1
ffffffe000202c3c:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
ffffffe000202c40:	fd843783          	ld	a5,-40(s0)
ffffffe000202c44:	0007c783          	lbu	a5,0(a5)
ffffffe000202c48:	00078713          	mv	a4,a5
ffffffe000202c4c:	07800793          	li	a5,120
ffffffe000202c50:	00f70c63          	beq	a4,a5,ffffffe000202c68 <strtol+0xfc>
ffffffe000202c54:	fd843783          	ld	a5,-40(s0)
ffffffe000202c58:	0007c783          	lbu	a5,0(a5)
ffffffe000202c5c:	00078713          	mv	a4,a5
ffffffe000202c60:	05800793          	li	a5,88
ffffffe000202c64:	00f71e63          	bne	a4,a5,ffffffe000202c80 <strtol+0x114>
                base = 16;
ffffffe000202c68:	01000793          	li	a5,16
ffffffe000202c6c:	faf42e23          	sw	a5,-68(s0)
                p++;
ffffffe000202c70:	fd843783          	ld	a5,-40(s0)
ffffffe000202c74:	00178793          	addi	a5,a5,1
ffffffe000202c78:	fcf43c23          	sd	a5,-40(s0)
ffffffe000202c7c:	0180006f          	j	ffffffe000202c94 <strtol+0x128>
            } else {
                base = 8;
ffffffe000202c80:	00800793          	li	a5,8
ffffffe000202c84:	faf42e23          	sw	a5,-68(s0)
ffffffe000202c88:	00c0006f          	j	ffffffe000202c94 <strtol+0x128>
            }
        } else {
            base = 10;
ffffffe000202c8c:	00a00793          	li	a5,10
ffffffe000202c90:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
ffffffe000202c94:	fd843783          	ld	a5,-40(s0)
ffffffe000202c98:	0007c783          	lbu	a5,0(a5)
ffffffe000202c9c:	00078713          	mv	a4,a5
ffffffe000202ca0:	02f00793          	li	a5,47
ffffffe000202ca4:	02e7f863          	bgeu	a5,a4,ffffffe000202cd4 <strtol+0x168>
ffffffe000202ca8:	fd843783          	ld	a5,-40(s0)
ffffffe000202cac:	0007c783          	lbu	a5,0(a5)
ffffffe000202cb0:	00078713          	mv	a4,a5
ffffffe000202cb4:	03900793          	li	a5,57
ffffffe000202cb8:	00e7ee63          	bltu	a5,a4,ffffffe000202cd4 <strtol+0x168>
            digit = *p - '0';
ffffffe000202cbc:	fd843783          	ld	a5,-40(s0)
ffffffe000202cc0:	0007c783          	lbu	a5,0(a5)
ffffffe000202cc4:	0007879b          	sext.w	a5,a5
ffffffe000202cc8:	fd07879b          	addiw	a5,a5,-48
ffffffe000202ccc:	fcf42a23          	sw	a5,-44(s0)
ffffffe000202cd0:	0800006f          	j	ffffffe000202d50 <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
ffffffe000202cd4:	fd843783          	ld	a5,-40(s0)
ffffffe000202cd8:	0007c783          	lbu	a5,0(a5)
ffffffe000202cdc:	00078713          	mv	a4,a5
ffffffe000202ce0:	06000793          	li	a5,96
ffffffe000202ce4:	02e7f863          	bgeu	a5,a4,ffffffe000202d14 <strtol+0x1a8>
ffffffe000202ce8:	fd843783          	ld	a5,-40(s0)
ffffffe000202cec:	0007c783          	lbu	a5,0(a5)
ffffffe000202cf0:	00078713          	mv	a4,a5
ffffffe000202cf4:	07a00793          	li	a5,122
ffffffe000202cf8:	00e7ee63          	bltu	a5,a4,ffffffe000202d14 <strtol+0x1a8>
            digit = *p - ('a' - 10);
ffffffe000202cfc:	fd843783          	ld	a5,-40(s0)
ffffffe000202d00:	0007c783          	lbu	a5,0(a5)
ffffffe000202d04:	0007879b          	sext.w	a5,a5
ffffffe000202d08:	fa97879b          	addiw	a5,a5,-87
ffffffe000202d0c:	fcf42a23          	sw	a5,-44(s0)
ffffffe000202d10:	0400006f          	j	ffffffe000202d50 <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
ffffffe000202d14:	fd843783          	ld	a5,-40(s0)
ffffffe000202d18:	0007c783          	lbu	a5,0(a5)
ffffffe000202d1c:	00078713          	mv	a4,a5
ffffffe000202d20:	04000793          	li	a5,64
ffffffe000202d24:	06e7f863          	bgeu	a5,a4,ffffffe000202d94 <strtol+0x228>
ffffffe000202d28:	fd843783          	ld	a5,-40(s0)
ffffffe000202d2c:	0007c783          	lbu	a5,0(a5)
ffffffe000202d30:	00078713          	mv	a4,a5
ffffffe000202d34:	05a00793          	li	a5,90
ffffffe000202d38:	04e7ee63          	bltu	a5,a4,ffffffe000202d94 <strtol+0x228>
            digit = *p - ('A' - 10);
ffffffe000202d3c:	fd843783          	ld	a5,-40(s0)
ffffffe000202d40:	0007c783          	lbu	a5,0(a5)
ffffffe000202d44:	0007879b          	sext.w	a5,a5
ffffffe000202d48:	fc97879b          	addiw	a5,a5,-55
ffffffe000202d4c:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
ffffffe000202d50:	fd442783          	lw	a5,-44(s0)
ffffffe000202d54:	00078713          	mv	a4,a5
ffffffe000202d58:	fbc42783          	lw	a5,-68(s0)
ffffffe000202d5c:	0007071b          	sext.w	a4,a4
ffffffe000202d60:	0007879b          	sext.w	a5,a5
ffffffe000202d64:	02f75663          	bge	a4,a5,ffffffe000202d90 <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
ffffffe000202d68:	fbc42703          	lw	a4,-68(s0)
ffffffe000202d6c:	fe843783          	ld	a5,-24(s0)
ffffffe000202d70:	02f70733          	mul	a4,a4,a5
ffffffe000202d74:	fd442783          	lw	a5,-44(s0)
ffffffe000202d78:	00f707b3          	add	a5,a4,a5
ffffffe000202d7c:	fef43423          	sd	a5,-24(s0)
        p++;
ffffffe000202d80:	fd843783          	ld	a5,-40(s0)
ffffffe000202d84:	00178793          	addi	a5,a5,1
ffffffe000202d88:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
ffffffe000202d8c:	f09ff06f          	j	ffffffe000202c94 <strtol+0x128>
            break;
ffffffe000202d90:	00000013          	nop
    }

    if (endptr) {
ffffffe000202d94:	fc043783          	ld	a5,-64(s0)
ffffffe000202d98:	00078863          	beqz	a5,ffffffe000202da8 <strtol+0x23c>
        *endptr = (char *)p;
ffffffe000202d9c:	fc043783          	ld	a5,-64(s0)
ffffffe000202da0:	fd843703          	ld	a4,-40(s0)
ffffffe000202da4:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
ffffffe000202da8:	fe744783          	lbu	a5,-25(s0)
ffffffe000202dac:	0ff7f793          	zext.b	a5,a5
ffffffe000202db0:	00078863          	beqz	a5,ffffffe000202dc0 <strtol+0x254>
ffffffe000202db4:	fe843783          	ld	a5,-24(s0)
ffffffe000202db8:	40f007b3          	neg	a5,a5
ffffffe000202dbc:	0080006f          	j	ffffffe000202dc4 <strtol+0x258>
ffffffe000202dc0:	fe843783          	ld	a5,-24(s0)
}
ffffffe000202dc4:	00078513          	mv	a0,a5
ffffffe000202dc8:	04813083          	ld	ra,72(sp)
ffffffe000202dcc:	04013403          	ld	s0,64(sp)
ffffffe000202dd0:	05010113          	addi	sp,sp,80
ffffffe000202dd4:	00008067          	ret

ffffffe000202dd8 <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
ffffffe000202dd8:	fd010113          	addi	sp,sp,-48
ffffffe000202ddc:	02113423          	sd	ra,40(sp)
ffffffe000202de0:	02813023          	sd	s0,32(sp)
ffffffe000202de4:	03010413          	addi	s0,sp,48
ffffffe000202de8:	fca43c23          	sd	a0,-40(s0)
ffffffe000202dec:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
ffffffe000202df0:	fd043783          	ld	a5,-48(s0)
ffffffe000202df4:	00079863          	bnez	a5,ffffffe000202e04 <puts_wo_nl+0x2c>
        s = "(null)";
ffffffe000202df8:	00001797          	auipc	a5,0x1
ffffffe000202dfc:	71878793          	addi	a5,a5,1816 # ffffffe000204510 <__func__.0+0x48>
ffffffe000202e00:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
ffffffe000202e04:	fd043783          	ld	a5,-48(s0)
ffffffe000202e08:	fef43423          	sd	a5,-24(s0)
    while (*p) {
ffffffe000202e0c:	0240006f          	j	ffffffe000202e30 <puts_wo_nl+0x58>
        putch(*p++);
ffffffe000202e10:	fe843783          	ld	a5,-24(s0)
ffffffe000202e14:	00178713          	addi	a4,a5,1
ffffffe000202e18:	fee43423          	sd	a4,-24(s0)
ffffffe000202e1c:	0007c783          	lbu	a5,0(a5)
ffffffe000202e20:	0007871b          	sext.w	a4,a5
ffffffe000202e24:	fd843783          	ld	a5,-40(s0)
ffffffe000202e28:	00070513          	mv	a0,a4
ffffffe000202e2c:	000780e7          	jalr	a5
    while (*p) {
ffffffe000202e30:	fe843783          	ld	a5,-24(s0)
ffffffe000202e34:	0007c783          	lbu	a5,0(a5)
ffffffe000202e38:	fc079ce3          	bnez	a5,ffffffe000202e10 <puts_wo_nl+0x38>
    }
    return p - s;
ffffffe000202e3c:	fe843703          	ld	a4,-24(s0)
ffffffe000202e40:	fd043783          	ld	a5,-48(s0)
ffffffe000202e44:	40f707b3          	sub	a5,a4,a5
ffffffe000202e48:	0007879b          	sext.w	a5,a5
}
ffffffe000202e4c:	00078513          	mv	a0,a5
ffffffe000202e50:	02813083          	ld	ra,40(sp)
ffffffe000202e54:	02013403          	ld	s0,32(sp)
ffffffe000202e58:	03010113          	addi	sp,sp,48
ffffffe000202e5c:	00008067          	ret

ffffffe000202e60 <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
ffffffe000202e60:	f9010113          	addi	sp,sp,-112
ffffffe000202e64:	06113423          	sd	ra,104(sp)
ffffffe000202e68:	06813023          	sd	s0,96(sp)
ffffffe000202e6c:	07010413          	addi	s0,sp,112
ffffffe000202e70:	faa43423          	sd	a0,-88(s0)
ffffffe000202e74:	fab43023          	sd	a1,-96(s0)
ffffffe000202e78:	00060793          	mv	a5,a2
ffffffe000202e7c:	f8d43823          	sd	a3,-112(s0)
ffffffe000202e80:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
ffffffe000202e84:	f9f44783          	lbu	a5,-97(s0)
ffffffe000202e88:	0ff7f793          	zext.b	a5,a5
ffffffe000202e8c:	02078663          	beqz	a5,ffffffe000202eb8 <print_dec_int+0x58>
ffffffe000202e90:	fa043703          	ld	a4,-96(s0)
ffffffe000202e94:	fff00793          	li	a5,-1
ffffffe000202e98:	03f79793          	slli	a5,a5,0x3f
ffffffe000202e9c:	00f71e63          	bne	a4,a5,ffffffe000202eb8 <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
ffffffe000202ea0:	00001597          	auipc	a1,0x1
ffffffe000202ea4:	67858593          	addi	a1,a1,1656 # ffffffe000204518 <__func__.0+0x50>
ffffffe000202ea8:	fa843503          	ld	a0,-88(s0)
ffffffe000202eac:	f2dff0ef          	jal	ffffffe000202dd8 <puts_wo_nl>
ffffffe000202eb0:	00050793          	mv	a5,a0
ffffffe000202eb4:	2a00006f          	j	ffffffe000203154 <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
ffffffe000202eb8:	f9043783          	ld	a5,-112(s0)
ffffffe000202ebc:	00c7a783          	lw	a5,12(a5)
ffffffe000202ec0:	00079a63          	bnez	a5,ffffffe000202ed4 <print_dec_int+0x74>
ffffffe000202ec4:	fa043783          	ld	a5,-96(s0)
ffffffe000202ec8:	00079663          	bnez	a5,ffffffe000202ed4 <print_dec_int+0x74>
        return 0;
ffffffe000202ecc:	00000793          	li	a5,0
ffffffe000202ed0:	2840006f          	j	ffffffe000203154 <print_dec_int+0x2f4>
    }

    bool neg = false;
ffffffe000202ed4:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
ffffffe000202ed8:	f9f44783          	lbu	a5,-97(s0)
ffffffe000202edc:	0ff7f793          	zext.b	a5,a5
ffffffe000202ee0:	02078063          	beqz	a5,ffffffe000202f00 <print_dec_int+0xa0>
ffffffe000202ee4:	fa043783          	ld	a5,-96(s0)
ffffffe000202ee8:	0007dc63          	bgez	a5,ffffffe000202f00 <print_dec_int+0xa0>
        neg = true;
ffffffe000202eec:	00100793          	li	a5,1
ffffffe000202ef0:	fef407a3          	sb	a5,-17(s0)
        num = -num;
ffffffe000202ef4:	fa043783          	ld	a5,-96(s0)
ffffffe000202ef8:	40f007b3          	neg	a5,a5
ffffffe000202efc:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
ffffffe000202f00:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
ffffffe000202f04:	f9f44783          	lbu	a5,-97(s0)
ffffffe000202f08:	0ff7f793          	zext.b	a5,a5
ffffffe000202f0c:	02078863          	beqz	a5,ffffffe000202f3c <print_dec_int+0xdc>
ffffffe000202f10:	fef44783          	lbu	a5,-17(s0)
ffffffe000202f14:	0ff7f793          	zext.b	a5,a5
ffffffe000202f18:	00079e63          	bnez	a5,ffffffe000202f34 <print_dec_int+0xd4>
ffffffe000202f1c:	f9043783          	ld	a5,-112(s0)
ffffffe000202f20:	0057c783          	lbu	a5,5(a5)
ffffffe000202f24:	00079863          	bnez	a5,ffffffe000202f34 <print_dec_int+0xd4>
ffffffe000202f28:	f9043783          	ld	a5,-112(s0)
ffffffe000202f2c:	0047c783          	lbu	a5,4(a5)
ffffffe000202f30:	00078663          	beqz	a5,ffffffe000202f3c <print_dec_int+0xdc>
ffffffe000202f34:	00100793          	li	a5,1
ffffffe000202f38:	0080006f          	j	ffffffe000202f40 <print_dec_int+0xe0>
ffffffe000202f3c:	00000793          	li	a5,0
ffffffe000202f40:	fcf40ba3          	sb	a5,-41(s0)
ffffffe000202f44:	fd744783          	lbu	a5,-41(s0)
ffffffe000202f48:	0017f793          	andi	a5,a5,1
ffffffe000202f4c:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
ffffffe000202f50:	fa043703          	ld	a4,-96(s0)
ffffffe000202f54:	00a00793          	li	a5,10
ffffffe000202f58:	02f777b3          	remu	a5,a4,a5
ffffffe000202f5c:	0ff7f713          	zext.b	a4,a5
ffffffe000202f60:	fe842783          	lw	a5,-24(s0)
ffffffe000202f64:	0017869b          	addiw	a3,a5,1
ffffffe000202f68:	fed42423          	sw	a3,-24(s0)
ffffffe000202f6c:	0307071b          	addiw	a4,a4,48
ffffffe000202f70:	0ff77713          	zext.b	a4,a4
ffffffe000202f74:	ff078793          	addi	a5,a5,-16
ffffffe000202f78:	008787b3          	add	a5,a5,s0
ffffffe000202f7c:	fce78423          	sb	a4,-56(a5)
        num /= 10;
ffffffe000202f80:	fa043703          	ld	a4,-96(s0)
ffffffe000202f84:	00a00793          	li	a5,10
ffffffe000202f88:	02f757b3          	divu	a5,a4,a5
ffffffe000202f8c:	faf43023          	sd	a5,-96(s0)
    } while (num);
ffffffe000202f90:	fa043783          	ld	a5,-96(s0)
ffffffe000202f94:	fa079ee3          	bnez	a5,ffffffe000202f50 <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
ffffffe000202f98:	f9043783          	ld	a5,-112(s0)
ffffffe000202f9c:	00c7a783          	lw	a5,12(a5)
ffffffe000202fa0:	00078713          	mv	a4,a5
ffffffe000202fa4:	fff00793          	li	a5,-1
ffffffe000202fa8:	02f71063          	bne	a4,a5,ffffffe000202fc8 <print_dec_int+0x168>
ffffffe000202fac:	f9043783          	ld	a5,-112(s0)
ffffffe000202fb0:	0037c783          	lbu	a5,3(a5)
ffffffe000202fb4:	00078a63          	beqz	a5,ffffffe000202fc8 <print_dec_int+0x168>
        flags->prec = flags->width;
ffffffe000202fb8:	f9043783          	ld	a5,-112(s0)
ffffffe000202fbc:	0087a703          	lw	a4,8(a5)
ffffffe000202fc0:	f9043783          	ld	a5,-112(s0)
ffffffe000202fc4:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
ffffffe000202fc8:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000202fcc:	f9043783          	ld	a5,-112(s0)
ffffffe000202fd0:	0087a703          	lw	a4,8(a5)
ffffffe000202fd4:	fe842783          	lw	a5,-24(s0)
ffffffe000202fd8:	fcf42823          	sw	a5,-48(s0)
ffffffe000202fdc:	f9043783          	ld	a5,-112(s0)
ffffffe000202fe0:	00c7a783          	lw	a5,12(a5)
ffffffe000202fe4:	fcf42623          	sw	a5,-52(s0)
ffffffe000202fe8:	fd042783          	lw	a5,-48(s0)
ffffffe000202fec:	00078593          	mv	a1,a5
ffffffe000202ff0:	fcc42783          	lw	a5,-52(s0)
ffffffe000202ff4:	00078613          	mv	a2,a5
ffffffe000202ff8:	0006069b          	sext.w	a3,a2
ffffffe000202ffc:	0005879b          	sext.w	a5,a1
ffffffe000203000:	00f6d463          	bge	a3,a5,ffffffe000203008 <print_dec_int+0x1a8>
ffffffe000203004:	00058613          	mv	a2,a1
ffffffe000203008:	0006079b          	sext.w	a5,a2
ffffffe00020300c:	40f707bb          	subw	a5,a4,a5
ffffffe000203010:	0007871b          	sext.w	a4,a5
ffffffe000203014:	fd744783          	lbu	a5,-41(s0)
ffffffe000203018:	0007879b          	sext.w	a5,a5
ffffffe00020301c:	40f707bb          	subw	a5,a4,a5
ffffffe000203020:	fef42023          	sw	a5,-32(s0)
ffffffe000203024:	0280006f          	j	ffffffe00020304c <print_dec_int+0x1ec>
        putch(' ');
ffffffe000203028:	fa843783          	ld	a5,-88(s0)
ffffffe00020302c:	02000513          	li	a0,32
ffffffe000203030:	000780e7          	jalr	a5
        ++written;
ffffffe000203034:	fe442783          	lw	a5,-28(s0)
ffffffe000203038:	0017879b          	addiw	a5,a5,1
ffffffe00020303c:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000203040:	fe042783          	lw	a5,-32(s0)
ffffffe000203044:	fff7879b          	addiw	a5,a5,-1
ffffffe000203048:	fef42023          	sw	a5,-32(s0)
ffffffe00020304c:	fe042783          	lw	a5,-32(s0)
ffffffe000203050:	0007879b          	sext.w	a5,a5
ffffffe000203054:	fcf04ae3          	bgtz	a5,ffffffe000203028 <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
ffffffe000203058:	fd744783          	lbu	a5,-41(s0)
ffffffe00020305c:	0ff7f793          	zext.b	a5,a5
ffffffe000203060:	04078463          	beqz	a5,ffffffe0002030a8 <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
ffffffe000203064:	fef44783          	lbu	a5,-17(s0)
ffffffe000203068:	0ff7f793          	zext.b	a5,a5
ffffffe00020306c:	00078663          	beqz	a5,ffffffe000203078 <print_dec_int+0x218>
ffffffe000203070:	02d00793          	li	a5,45
ffffffe000203074:	01c0006f          	j	ffffffe000203090 <print_dec_int+0x230>
ffffffe000203078:	f9043783          	ld	a5,-112(s0)
ffffffe00020307c:	0057c783          	lbu	a5,5(a5)
ffffffe000203080:	00078663          	beqz	a5,ffffffe00020308c <print_dec_int+0x22c>
ffffffe000203084:	02b00793          	li	a5,43
ffffffe000203088:	0080006f          	j	ffffffe000203090 <print_dec_int+0x230>
ffffffe00020308c:	02000793          	li	a5,32
ffffffe000203090:	fa843703          	ld	a4,-88(s0)
ffffffe000203094:	00078513          	mv	a0,a5
ffffffe000203098:	000700e7          	jalr	a4
        ++written;
ffffffe00020309c:	fe442783          	lw	a5,-28(s0)
ffffffe0002030a0:	0017879b          	addiw	a5,a5,1
ffffffe0002030a4:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe0002030a8:	fe842783          	lw	a5,-24(s0)
ffffffe0002030ac:	fcf42e23          	sw	a5,-36(s0)
ffffffe0002030b0:	0280006f          	j	ffffffe0002030d8 <print_dec_int+0x278>
        putch('0');
ffffffe0002030b4:	fa843783          	ld	a5,-88(s0)
ffffffe0002030b8:	03000513          	li	a0,48
ffffffe0002030bc:	000780e7          	jalr	a5
        ++written;
ffffffe0002030c0:	fe442783          	lw	a5,-28(s0)
ffffffe0002030c4:	0017879b          	addiw	a5,a5,1
ffffffe0002030c8:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe0002030cc:	fdc42783          	lw	a5,-36(s0)
ffffffe0002030d0:	0017879b          	addiw	a5,a5,1
ffffffe0002030d4:	fcf42e23          	sw	a5,-36(s0)
ffffffe0002030d8:	f9043783          	ld	a5,-112(s0)
ffffffe0002030dc:	00c7a703          	lw	a4,12(a5)
ffffffe0002030e0:	fd744783          	lbu	a5,-41(s0)
ffffffe0002030e4:	0007879b          	sext.w	a5,a5
ffffffe0002030e8:	40f707bb          	subw	a5,a4,a5
ffffffe0002030ec:	0007871b          	sext.w	a4,a5
ffffffe0002030f0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002030f4:	0007879b          	sext.w	a5,a5
ffffffe0002030f8:	fae7cee3          	blt	a5,a4,ffffffe0002030b4 <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe0002030fc:	fe842783          	lw	a5,-24(s0)
ffffffe000203100:	fff7879b          	addiw	a5,a5,-1
ffffffe000203104:	fcf42c23          	sw	a5,-40(s0)
ffffffe000203108:	03c0006f          	j	ffffffe000203144 <print_dec_int+0x2e4>
        putch(buf[i]);
ffffffe00020310c:	fd842783          	lw	a5,-40(s0)
ffffffe000203110:	ff078793          	addi	a5,a5,-16
ffffffe000203114:	008787b3          	add	a5,a5,s0
ffffffe000203118:	fc87c783          	lbu	a5,-56(a5)
ffffffe00020311c:	0007871b          	sext.w	a4,a5
ffffffe000203120:	fa843783          	ld	a5,-88(s0)
ffffffe000203124:	00070513          	mv	a0,a4
ffffffe000203128:	000780e7          	jalr	a5
        ++written;
ffffffe00020312c:	fe442783          	lw	a5,-28(s0)
ffffffe000203130:	0017879b          	addiw	a5,a5,1
ffffffe000203134:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000203138:	fd842783          	lw	a5,-40(s0)
ffffffe00020313c:	fff7879b          	addiw	a5,a5,-1
ffffffe000203140:	fcf42c23          	sw	a5,-40(s0)
ffffffe000203144:	fd842783          	lw	a5,-40(s0)
ffffffe000203148:	0007879b          	sext.w	a5,a5
ffffffe00020314c:	fc07d0e3          	bgez	a5,ffffffe00020310c <print_dec_int+0x2ac>
    }

    return written;
ffffffe000203150:	fe442783          	lw	a5,-28(s0)
}
ffffffe000203154:	00078513          	mv	a0,a5
ffffffe000203158:	06813083          	ld	ra,104(sp)
ffffffe00020315c:	06013403          	ld	s0,96(sp)
ffffffe000203160:	07010113          	addi	sp,sp,112
ffffffe000203164:	00008067          	ret

ffffffe000203168 <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
ffffffe000203168:	f4010113          	addi	sp,sp,-192
ffffffe00020316c:	0a113c23          	sd	ra,184(sp)
ffffffe000203170:	0a813823          	sd	s0,176(sp)
ffffffe000203174:	0c010413          	addi	s0,sp,192
ffffffe000203178:	f4a43c23          	sd	a0,-168(s0)
ffffffe00020317c:	f4b43823          	sd	a1,-176(s0)
ffffffe000203180:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
ffffffe000203184:	f8043023          	sd	zero,-128(s0)
ffffffe000203188:	f8043423          	sd	zero,-120(s0)

    int written = 0;
ffffffe00020318c:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
ffffffe000203190:	7a40006f          	j	ffffffe000203934 <vprintfmt+0x7cc>
        if (flags.in_format) {
ffffffe000203194:	f8044783          	lbu	a5,-128(s0)
ffffffe000203198:	72078e63          	beqz	a5,ffffffe0002038d4 <vprintfmt+0x76c>
            if (*fmt == '#') {
ffffffe00020319c:	f5043783          	ld	a5,-176(s0)
ffffffe0002031a0:	0007c783          	lbu	a5,0(a5)
ffffffe0002031a4:	00078713          	mv	a4,a5
ffffffe0002031a8:	02300793          	li	a5,35
ffffffe0002031ac:	00f71863          	bne	a4,a5,ffffffe0002031bc <vprintfmt+0x54>
                flags.sharpflag = true;
ffffffe0002031b0:	00100793          	li	a5,1
ffffffe0002031b4:	f8f40123          	sb	a5,-126(s0)
ffffffe0002031b8:	7700006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
ffffffe0002031bc:	f5043783          	ld	a5,-176(s0)
ffffffe0002031c0:	0007c783          	lbu	a5,0(a5)
ffffffe0002031c4:	00078713          	mv	a4,a5
ffffffe0002031c8:	03000793          	li	a5,48
ffffffe0002031cc:	00f71863          	bne	a4,a5,ffffffe0002031dc <vprintfmt+0x74>
                flags.zeroflag = true;
ffffffe0002031d0:	00100793          	li	a5,1
ffffffe0002031d4:	f8f401a3          	sb	a5,-125(s0)
ffffffe0002031d8:	7500006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
ffffffe0002031dc:	f5043783          	ld	a5,-176(s0)
ffffffe0002031e0:	0007c783          	lbu	a5,0(a5)
ffffffe0002031e4:	00078713          	mv	a4,a5
ffffffe0002031e8:	06c00793          	li	a5,108
ffffffe0002031ec:	04f70063          	beq	a4,a5,ffffffe00020322c <vprintfmt+0xc4>
ffffffe0002031f0:	f5043783          	ld	a5,-176(s0)
ffffffe0002031f4:	0007c783          	lbu	a5,0(a5)
ffffffe0002031f8:	00078713          	mv	a4,a5
ffffffe0002031fc:	07a00793          	li	a5,122
ffffffe000203200:	02f70663          	beq	a4,a5,ffffffe00020322c <vprintfmt+0xc4>
ffffffe000203204:	f5043783          	ld	a5,-176(s0)
ffffffe000203208:	0007c783          	lbu	a5,0(a5)
ffffffe00020320c:	00078713          	mv	a4,a5
ffffffe000203210:	07400793          	li	a5,116
ffffffe000203214:	00f70c63          	beq	a4,a5,ffffffe00020322c <vprintfmt+0xc4>
ffffffe000203218:	f5043783          	ld	a5,-176(s0)
ffffffe00020321c:	0007c783          	lbu	a5,0(a5)
ffffffe000203220:	00078713          	mv	a4,a5
ffffffe000203224:	06a00793          	li	a5,106
ffffffe000203228:	00f71863          	bne	a4,a5,ffffffe000203238 <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
ffffffe00020322c:	00100793          	li	a5,1
ffffffe000203230:	f8f400a3          	sb	a5,-127(s0)
ffffffe000203234:	6f40006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
ffffffe000203238:	f5043783          	ld	a5,-176(s0)
ffffffe00020323c:	0007c783          	lbu	a5,0(a5)
ffffffe000203240:	00078713          	mv	a4,a5
ffffffe000203244:	02b00793          	li	a5,43
ffffffe000203248:	00f71863          	bne	a4,a5,ffffffe000203258 <vprintfmt+0xf0>
                flags.sign = true;
ffffffe00020324c:	00100793          	li	a5,1
ffffffe000203250:	f8f402a3          	sb	a5,-123(s0)
ffffffe000203254:	6d40006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
ffffffe000203258:	f5043783          	ld	a5,-176(s0)
ffffffe00020325c:	0007c783          	lbu	a5,0(a5)
ffffffe000203260:	00078713          	mv	a4,a5
ffffffe000203264:	02000793          	li	a5,32
ffffffe000203268:	00f71863          	bne	a4,a5,ffffffe000203278 <vprintfmt+0x110>
                flags.spaceflag = true;
ffffffe00020326c:	00100793          	li	a5,1
ffffffe000203270:	f8f40223          	sb	a5,-124(s0)
ffffffe000203274:	6b40006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
ffffffe000203278:	f5043783          	ld	a5,-176(s0)
ffffffe00020327c:	0007c783          	lbu	a5,0(a5)
ffffffe000203280:	00078713          	mv	a4,a5
ffffffe000203284:	02a00793          	li	a5,42
ffffffe000203288:	00f71e63          	bne	a4,a5,ffffffe0002032a4 <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
ffffffe00020328c:	f4843783          	ld	a5,-184(s0)
ffffffe000203290:	00878713          	addi	a4,a5,8
ffffffe000203294:	f4e43423          	sd	a4,-184(s0)
ffffffe000203298:	0007a783          	lw	a5,0(a5)
ffffffe00020329c:	f8f42423          	sw	a5,-120(s0)
ffffffe0002032a0:	6880006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
ffffffe0002032a4:	f5043783          	ld	a5,-176(s0)
ffffffe0002032a8:	0007c783          	lbu	a5,0(a5)
ffffffe0002032ac:	00078713          	mv	a4,a5
ffffffe0002032b0:	03000793          	li	a5,48
ffffffe0002032b4:	04e7f663          	bgeu	a5,a4,ffffffe000203300 <vprintfmt+0x198>
ffffffe0002032b8:	f5043783          	ld	a5,-176(s0)
ffffffe0002032bc:	0007c783          	lbu	a5,0(a5)
ffffffe0002032c0:	00078713          	mv	a4,a5
ffffffe0002032c4:	03900793          	li	a5,57
ffffffe0002032c8:	02e7ec63          	bltu	a5,a4,ffffffe000203300 <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
ffffffe0002032cc:	f5043783          	ld	a5,-176(s0)
ffffffe0002032d0:	f5040713          	addi	a4,s0,-176
ffffffe0002032d4:	00a00613          	li	a2,10
ffffffe0002032d8:	00070593          	mv	a1,a4
ffffffe0002032dc:	00078513          	mv	a0,a5
ffffffe0002032e0:	88dff0ef          	jal	ffffffe000202b6c <strtol>
ffffffe0002032e4:	00050793          	mv	a5,a0
ffffffe0002032e8:	0007879b          	sext.w	a5,a5
ffffffe0002032ec:	f8f42423          	sw	a5,-120(s0)
                fmt--;
ffffffe0002032f0:	f5043783          	ld	a5,-176(s0)
ffffffe0002032f4:	fff78793          	addi	a5,a5,-1
ffffffe0002032f8:	f4f43823          	sd	a5,-176(s0)
ffffffe0002032fc:	62c0006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
ffffffe000203300:	f5043783          	ld	a5,-176(s0)
ffffffe000203304:	0007c783          	lbu	a5,0(a5)
ffffffe000203308:	00078713          	mv	a4,a5
ffffffe00020330c:	02e00793          	li	a5,46
ffffffe000203310:	06f71863          	bne	a4,a5,ffffffe000203380 <vprintfmt+0x218>
                fmt++;
ffffffe000203314:	f5043783          	ld	a5,-176(s0)
ffffffe000203318:	00178793          	addi	a5,a5,1
ffffffe00020331c:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
ffffffe000203320:	f5043783          	ld	a5,-176(s0)
ffffffe000203324:	0007c783          	lbu	a5,0(a5)
ffffffe000203328:	00078713          	mv	a4,a5
ffffffe00020332c:	02a00793          	li	a5,42
ffffffe000203330:	00f71e63          	bne	a4,a5,ffffffe00020334c <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
ffffffe000203334:	f4843783          	ld	a5,-184(s0)
ffffffe000203338:	00878713          	addi	a4,a5,8
ffffffe00020333c:	f4e43423          	sd	a4,-184(s0)
ffffffe000203340:	0007a783          	lw	a5,0(a5)
ffffffe000203344:	f8f42623          	sw	a5,-116(s0)
ffffffe000203348:	5e00006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
ffffffe00020334c:	f5043783          	ld	a5,-176(s0)
ffffffe000203350:	f5040713          	addi	a4,s0,-176
ffffffe000203354:	00a00613          	li	a2,10
ffffffe000203358:	00070593          	mv	a1,a4
ffffffe00020335c:	00078513          	mv	a0,a5
ffffffe000203360:	80dff0ef          	jal	ffffffe000202b6c <strtol>
ffffffe000203364:	00050793          	mv	a5,a0
ffffffe000203368:	0007879b          	sext.w	a5,a5
ffffffe00020336c:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
ffffffe000203370:	f5043783          	ld	a5,-176(s0)
ffffffe000203374:	fff78793          	addi	a5,a5,-1
ffffffe000203378:	f4f43823          	sd	a5,-176(s0)
ffffffe00020337c:	5ac0006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000203380:	f5043783          	ld	a5,-176(s0)
ffffffe000203384:	0007c783          	lbu	a5,0(a5)
ffffffe000203388:	00078713          	mv	a4,a5
ffffffe00020338c:	07800793          	li	a5,120
ffffffe000203390:	02f70663          	beq	a4,a5,ffffffe0002033bc <vprintfmt+0x254>
ffffffe000203394:	f5043783          	ld	a5,-176(s0)
ffffffe000203398:	0007c783          	lbu	a5,0(a5)
ffffffe00020339c:	00078713          	mv	a4,a5
ffffffe0002033a0:	05800793          	li	a5,88
ffffffe0002033a4:	00f70c63          	beq	a4,a5,ffffffe0002033bc <vprintfmt+0x254>
ffffffe0002033a8:	f5043783          	ld	a5,-176(s0)
ffffffe0002033ac:	0007c783          	lbu	a5,0(a5)
ffffffe0002033b0:	00078713          	mv	a4,a5
ffffffe0002033b4:	07000793          	li	a5,112
ffffffe0002033b8:	30f71263          	bne	a4,a5,ffffffe0002036bc <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
ffffffe0002033bc:	f5043783          	ld	a5,-176(s0)
ffffffe0002033c0:	0007c783          	lbu	a5,0(a5)
ffffffe0002033c4:	00078713          	mv	a4,a5
ffffffe0002033c8:	07000793          	li	a5,112
ffffffe0002033cc:	00f70663          	beq	a4,a5,ffffffe0002033d8 <vprintfmt+0x270>
ffffffe0002033d0:	f8144783          	lbu	a5,-127(s0)
ffffffe0002033d4:	00078663          	beqz	a5,ffffffe0002033e0 <vprintfmt+0x278>
ffffffe0002033d8:	00100793          	li	a5,1
ffffffe0002033dc:	0080006f          	j	ffffffe0002033e4 <vprintfmt+0x27c>
ffffffe0002033e0:	00000793          	li	a5,0
ffffffe0002033e4:	faf403a3          	sb	a5,-89(s0)
ffffffe0002033e8:	fa744783          	lbu	a5,-89(s0)
ffffffe0002033ec:	0017f793          	andi	a5,a5,1
ffffffe0002033f0:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
ffffffe0002033f4:	fa744783          	lbu	a5,-89(s0)
ffffffe0002033f8:	0ff7f793          	zext.b	a5,a5
ffffffe0002033fc:	00078c63          	beqz	a5,ffffffe000203414 <vprintfmt+0x2ac>
ffffffe000203400:	f4843783          	ld	a5,-184(s0)
ffffffe000203404:	00878713          	addi	a4,a5,8
ffffffe000203408:	f4e43423          	sd	a4,-184(s0)
ffffffe00020340c:	0007b783          	ld	a5,0(a5)
ffffffe000203410:	01c0006f          	j	ffffffe00020342c <vprintfmt+0x2c4>
ffffffe000203414:	f4843783          	ld	a5,-184(s0)
ffffffe000203418:	00878713          	addi	a4,a5,8
ffffffe00020341c:	f4e43423          	sd	a4,-184(s0)
ffffffe000203420:	0007a783          	lw	a5,0(a5)
ffffffe000203424:	02079793          	slli	a5,a5,0x20
ffffffe000203428:	0207d793          	srli	a5,a5,0x20
ffffffe00020342c:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
ffffffe000203430:	f8c42783          	lw	a5,-116(s0)
ffffffe000203434:	02079463          	bnez	a5,ffffffe00020345c <vprintfmt+0x2f4>
ffffffe000203438:	fe043783          	ld	a5,-32(s0)
ffffffe00020343c:	02079063          	bnez	a5,ffffffe00020345c <vprintfmt+0x2f4>
ffffffe000203440:	f5043783          	ld	a5,-176(s0)
ffffffe000203444:	0007c783          	lbu	a5,0(a5)
ffffffe000203448:	00078713          	mv	a4,a5
ffffffe00020344c:	07000793          	li	a5,112
ffffffe000203450:	00f70663          	beq	a4,a5,ffffffe00020345c <vprintfmt+0x2f4>
                    flags.in_format = false;
ffffffe000203454:	f8040023          	sb	zero,-128(s0)
ffffffe000203458:	4d00006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
ffffffe00020345c:	f5043783          	ld	a5,-176(s0)
ffffffe000203460:	0007c783          	lbu	a5,0(a5)
ffffffe000203464:	00078713          	mv	a4,a5
ffffffe000203468:	07000793          	li	a5,112
ffffffe00020346c:	00f70a63          	beq	a4,a5,ffffffe000203480 <vprintfmt+0x318>
ffffffe000203470:	f8244783          	lbu	a5,-126(s0)
ffffffe000203474:	00078a63          	beqz	a5,ffffffe000203488 <vprintfmt+0x320>
ffffffe000203478:	fe043783          	ld	a5,-32(s0)
ffffffe00020347c:	00078663          	beqz	a5,ffffffe000203488 <vprintfmt+0x320>
ffffffe000203480:	00100793          	li	a5,1
ffffffe000203484:	0080006f          	j	ffffffe00020348c <vprintfmt+0x324>
ffffffe000203488:	00000793          	li	a5,0
ffffffe00020348c:	faf40323          	sb	a5,-90(s0)
ffffffe000203490:	fa644783          	lbu	a5,-90(s0)
ffffffe000203494:	0017f793          	andi	a5,a5,1
ffffffe000203498:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
ffffffe00020349c:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
ffffffe0002034a0:	f5043783          	ld	a5,-176(s0)
ffffffe0002034a4:	0007c783          	lbu	a5,0(a5)
ffffffe0002034a8:	00078713          	mv	a4,a5
ffffffe0002034ac:	05800793          	li	a5,88
ffffffe0002034b0:	00f71863          	bne	a4,a5,ffffffe0002034c0 <vprintfmt+0x358>
ffffffe0002034b4:	00001797          	auipc	a5,0x1
ffffffe0002034b8:	07c78793          	addi	a5,a5,124 # ffffffe000204530 <upperxdigits.1>
ffffffe0002034bc:	00c0006f          	j	ffffffe0002034c8 <vprintfmt+0x360>
ffffffe0002034c0:	00001797          	auipc	a5,0x1
ffffffe0002034c4:	08878793          	addi	a5,a5,136 # ffffffe000204548 <lowerxdigits.0>
ffffffe0002034c8:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
ffffffe0002034cc:	fe043783          	ld	a5,-32(s0)
ffffffe0002034d0:	00f7f793          	andi	a5,a5,15
ffffffe0002034d4:	f9843703          	ld	a4,-104(s0)
ffffffe0002034d8:	00f70733          	add	a4,a4,a5
ffffffe0002034dc:	fdc42783          	lw	a5,-36(s0)
ffffffe0002034e0:	0017869b          	addiw	a3,a5,1
ffffffe0002034e4:	fcd42e23          	sw	a3,-36(s0)
ffffffe0002034e8:	00074703          	lbu	a4,0(a4)
ffffffe0002034ec:	ff078793          	addi	a5,a5,-16
ffffffe0002034f0:	008787b3          	add	a5,a5,s0
ffffffe0002034f4:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
ffffffe0002034f8:	fe043783          	ld	a5,-32(s0)
ffffffe0002034fc:	0047d793          	srli	a5,a5,0x4
ffffffe000203500:	fef43023          	sd	a5,-32(s0)
                } while (num);
ffffffe000203504:	fe043783          	ld	a5,-32(s0)
ffffffe000203508:	fc0792e3          	bnez	a5,ffffffe0002034cc <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
ffffffe00020350c:	f8c42783          	lw	a5,-116(s0)
ffffffe000203510:	00078713          	mv	a4,a5
ffffffe000203514:	fff00793          	li	a5,-1
ffffffe000203518:	02f71663          	bne	a4,a5,ffffffe000203544 <vprintfmt+0x3dc>
ffffffe00020351c:	f8344783          	lbu	a5,-125(s0)
ffffffe000203520:	02078263          	beqz	a5,ffffffe000203544 <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
ffffffe000203524:	f8842703          	lw	a4,-120(s0)
ffffffe000203528:	fa644783          	lbu	a5,-90(s0)
ffffffe00020352c:	0007879b          	sext.w	a5,a5
ffffffe000203530:	0017979b          	slliw	a5,a5,0x1
ffffffe000203534:	0007879b          	sext.w	a5,a5
ffffffe000203538:	40f707bb          	subw	a5,a4,a5
ffffffe00020353c:	0007879b          	sext.w	a5,a5
ffffffe000203540:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000203544:	f8842703          	lw	a4,-120(s0)
ffffffe000203548:	fa644783          	lbu	a5,-90(s0)
ffffffe00020354c:	0007879b          	sext.w	a5,a5
ffffffe000203550:	0017979b          	slliw	a5,a5,0x1
ffffffe000203554:	0007879b          	sext.w	a5,a5
ffffffe000203558:	40f707bb          	subw	a5,a4,a5
ffffffe00020355c:	0007871b          	sext.w	a4,a5
ffffffe000203560:	fdc42783          	lw	a5,-36(s0)
ffffffe000203564:	f8f42a23          	sw	a5,-108(s0)
ffffffe000203568:	f8c42783          	lw	a5,-116(s0)
ffffffe00020356c:	f8f42823          	sw	a5,-112(s0)
ffffffe000203570:	f9442783          	lw	a5,-108(s0)
ffffffe000203574:	00078593          	mv	a1,a5
ffffffe000203578:	f9042783          	lw	a5,-112(s0)
ffffffe00020357c:	00078613          	mv	a2,a5
ffffffe000203580:	0006069b          	sext.w	a3,a2
ffffffe000203584:	0005879b          	sext.w	a5,a1
ffffffe000203588:	00f6d463          	bge	a3,a5,ffffffe000203590 <vprintfmt+0x428>
ffffffe00020358c:	00058613          	mv	a2,a1
ffffffe000203590:	0006079b          	sext.w	a5,a2
ffffffe000203594:	40f707bb          	subw	a5,a4,a5
ffffffe000203598:	fcf42c23          	sw	a5,-40(s0)
ffffffe00020359c:	0280006f          	j	ffffffe0002035c4 <vprintfmt+0x45c>
                    putch(' ');
ffffffe0002035a0:	f5843783          	ld	a5,-168(s0)
ffffffe0002035a4:	02000513          	li	a0,32
ffffffe0002035a8:	000780e7          	jalr	a5
                    ++written;
ffffffe0002035ac:	fec42783          	lw	a5,-20(s0)
ffffffe0002035b0:	0017879b          	addiw	a5,a5,1
ffffffe0002035b4:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe0002035b8:	fd842783          	lw	a5,-40(s0)
ffffffe0002035bc:	fff7879b          	addiw	a5,a5,-1
ffffffe0002035c0:	fcf42c23          	sw	a5,-40(s0)
ffffffe0002035c4:	fd842783          	lw	a5,-40(s0)
ffffffe0002035c8:	0007879b          	sext.w	a5,a5
ffffffe0002035cc:	fcf04ae3          	bgtz	a5,ffffffe0002035a0 <vprintfmt+0x438>
                }

                if (prefix) {
ffffffe0002035d0:	fa644783          	lbu	a5,-90(s0)
ffffffe0002035d4:	0ff7f793          	zext.b	a5,a5
ffffffe0002035d8:	04078463          	beqz	a5,ffffffe000203620 <vprintfmt+0x4b8>
                    putch('0');
ffffffe0002035dc:	f5843783          	ld	a5,-168(s0)
ffffffe0002035e0:	03000513          	li	a0,48
ffffffe0002035e4:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
ffffffe0002035e8:	f5043783          	ld	a5,-176(s0)
ffffffe0002035ec:	0007c783          	lbu	a5,0(a5)
ffffffe0002035f0:	00078713          	mv	a4,a5
ffffffe0002035f4:	05800793          	li	a5,88
ffffffe0002035f8:	00f71663          	bne	a4,a5,ffffffe000203604 <vprintfmt+0x49c>
ffffffe0002035fc:	05800793          	li	a5,88
ffffffe000203600:	0080006f          	j	ffffffe000203608 <vprintfmt+0x4a0>
ffffffe000203604:	07800793          	li	a5,120
ffffffe000203608:	f5843703          	ld	a4,-168(s0)
ffffffe00020360c:	00078513          	mv	a0,a5
ffffffe000203610:	000700e7          	jalr	a4
                    written += 2;
ffffffe000203614:	fec42783          	lw	a5,-20(s0)
ffffffe000203618:	0027879b          	addiw	a5,a5,2
ffffffe00020361c:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000203620:	fdc42783          	lw	a5,-36(s0)
ffffffe000203624:	fcf42a23          	sw	a5,-44(s0)
ffffffe000203628:	0280006f          	j	ffffffe000203650 <vprintfmt+0x4e8>
                    putch('0');
ffffffe00020362c:	f5843783          	ld	a5,-168(s0)
ffffffe000203630:	03000513          	li	a0,48
ffffffe000203634:	000780e7          	jalr	a5
                    ++written;
ffffffe000203638:	fec42783          	lw	a5,-20(s0)
ffffffe00020363c:	0017879b          	addiw	a5,a5,1
ffffffe000203640:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000203644:	fd442783          	lw	a5,-44(s0)
ffffffe000203648:	0017879b          	addiw	a5,a5,1
ffffffe00020364c:	fcf42a23          	sw	a5,-44(s0)
ffffffe000203650:	f8c42703          	lw	a4,-116(s0)
ffffffe000203654:	fd442783          	lw	a5,-44(s0)
ffffffe000203658:	0007879b          	sext.w	a5,a5
ffffffe00020365c:	fce7c8e3          	blt	a5,a4,ffffffe00020362c <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000203660:	fdc42783          	lw	a5,-36(s0)
ffffffe000203664:	fff7879b          	addiw	a5,a5,-1
ffffffe000203668:	fcf42823          	sw	a5,-48(s0)
ffffffe00020366c:	03c0006f          	j	ffffffe0002036a8 <vprintfmt+0x540>
                    putch(buf[i]);
ffffffe000203670:	fd042783          	lw	a5,-48(s0)
ffffffe000203674:	ff078793          	addi	a5,a5,-16
ffffffe000203678:	008787b3          	add	a5,a5,s0
ffffffe00020367c:	f807c783          	lbu	a5,-128(a5)
ffffffe000203680:	0007871b          	sext.w	a4,a5
ffffffe000203684:	f5843783          	ld	a5,-168(s0)
ffffffe000203688:	00070513          	mv	a0,a4
ffffffe00020368c:	000780e7          	jalr	a5
                    ++written;
ffffffe000203690:	fec42783          	lw	a5,-20(s0)
ffffffe000203694:	0017879b          	addiw	a5,a5,1
ffffffe000203698:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe00020369c:	fd042783          	lw	a5,-48(s0)
ffffffe0002036a0:	fff7879b          	addiw	a5,a5,-1
ffffffe0002036a4:	fcf42823          	sw	a5,-48(s0)
ffffffe0002036a8:	fd042783          	lw	a5,-48(s0)
ffffffe0002036ac:	0007879b          	sext.w	a5,a5
ffffffe0002036b0:	fc07d0e3          	bgez	a5,ffffffe000203670 <vprintfmt+0x508>
                }

                flags.in_format = false;
ffffffe0002036b4:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe0002036b8:	2700006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe0002036bc:	f5043783          	ld	a5,-176(s0)
ffffffe0002036c0:	0007c783          	lbu	a5,0(a5)
ffffffe0002036c4:	00078713          	mv	a4,a5
ffffffe0002036c8:	06400793          	li	a5,100
ffffffe0002036cc:	02f70663          	beq	a4,a5,ffffffe0002036f8 <vprintfmt+0x590>
ffffffe0002036d0:	f5043783          	ld	a5,-176(s0)
ffffffe0002036d4:	0007c783          	lbu	a5,0(a5)
ffffffe0002036d8:	00078713          	mv	a4,a5
ffffffe0002036dc:	06900793          	li	a5,105
ffffffe0002036e0:	00f70c63          	beq	a4,a5,ffffffe0002036f8 <vprintfmt+0x590>
ffffffe0002036e4:	f5043783          	ld	a5,-176(s0)
ffffffe0002036e8:	0007c783          	lbu	a5,0(a5)
ffffffe0002036ec:	00078713          	mv	a4,a5
ffffffe0002036f0:	07500793          	li	a5,117
ffffffe0002036f4:	08f71063          	bne	a4,a5,ffffffe000203774 <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
ffffffe0002036f8:	f8144783          	lbu	a5,-127(s0)
ffffffe0002036fc:	00078c63          	beqz	a5,ffffffe000203714 <vprintfmt+0x5ac>
ffffffe000203700:	f4843783          	ld	a5,-184(s0)
ffffffe000203704:	00878713          	addi	a4,a5,8
ffffffe000203708:	f4e43423          	sd	a4,-184(s0)
ffffffe00020370c:	0007b783          	ld	a5,0(a5)
ffffffe000203710:	0140006f          	j	ffffffe000203724 <vprintfmt+0x5bc>
ffffffe000203714:	f4843783          	ld	a5,-184(s0)
ffffffe000203718:	00878713          	addi	a4,a5,8
ffffffe00020371c:	f4e43423          	sd	a4,-184(s0)
ffffffe000203720:	0007a783          	lw	a5,0(a5)
ffffffe000203724:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
ffffffe000203728:	fa843583          	ld	a1,-88(s0)
ffffffe00020372c:	f5043783          	ld	a5,-176(s0)
ffffffe000203730:	0007c783          	lbu	a5,0(a5)
ffffffe000203734:	0007871b          	sext.w	a4,a5
ffffffe000203738:	07500793          	li	a5,117
ffffffe00020373c:	40f707b3          	sub	a5,a4,a5
ffffffe000203740:	00f037b3          	snez	a5,a5
ffffffe000203744:	0ff7f793          	zext.b	a5,a5
ffffffe000203748:	f8040713          	addi	a4,s0,-128
ffffffe00020374c:	00070693          	mv	a3,a4
ffffffe000203750:	00078613          	mv	a2,a5
ffffffe000203754:	f5843503          	ld	a0,-168(s0)
ffffffe000203758:	f08ff0ef          	jal	ffffffe000202e60 <print_dec_int>
ffffffe00020375c:	00050793          	mv	a5,a0
ffffffe000203760:	fec42703          	lw	a4,-20(s0)
ffffffe000203764:	00f707bb          	addw	a5,a4,a5
ffffffe000203768:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe00020376c:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000203770:	1b80006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
ffffffe000203774:	f5043783          	ld	a5,-176(s0)
ffffffe000203778:	0007c783          	lbu	a5,0(a5)
ffffffe00020377c:	00078713          	mv	a4,a5
ffffffe000203780:	06e00793          	li	a5,110
ffffffe000203784:	04f71c63          	bne	a4,a5,ffffffe0002037dc <vprintfmt+0x674>
                if (flags.longflag) {
ffffffe000203788:	f8144783          	lbu	a5,-127(s0)
ffffffe00020378c:	02078463          	beqz	a5,ffffffe0002037b4 <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
ffffffe000203790:	f4843783          	ld	a5,-184(s0)
ffffffe000203794:	00878713          	addi	a4,a5,8
ffffffe000203798:	f4e43423          	sd	a4,-184(s0)
ffffffe00020379c:	0007b783          	ld	a5,0(a5)
ffffffe0002037a0:	faf43823          	sd	a5,-80(s0)
                    *n = written;
ffffffe0002037a4:	fec42703          	lw	a4,-20(s0)
ffffffe0002037a8:	fb043783          	ld	a5,-80(s0)
ffffffe0002037ac:	00e7b023          	sd	a4,0(a5)
ffffffe0002037b0:	0240006f          	j	ffffffe0002037d4 <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
ffffffe0002037b4:	f4843783          	ld	a5,-184(s0)
ffffffe0002037b8:	00878713          	addi	a4,a5,8
ffffffe0002037bc:	f4e43423          	sd	a4,-184(s0)
ffffffe0002037c0:	0007b783          	ld	a5,0(a5)
ffffffe0002037c4:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
ffffffe0002037c8:	fb843783          	ld	a5,-72(s0)
ffffffe0002037cc:	fec42703          	lw	a4,-20(s0)
ffffffe0002037d0:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
ffffffe0002037d4:	f8040023          	sb	zero,-128(s0)
ffffffe0002037d8:	1500006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
ffffffe0002037dc:	f5043783          	ld	a5,-176(s0)
ffffffe0002037e0:	0007c783          	lbu	a5,0(a5)
ffffffe0002037e4:	00078713          	mv	a4,a5
ffffffe0002037e8:	07300793          	li	a5,115
ffffffe0002037ec:	02f71e63          	bne	a4,a5,ffffffe000203828 <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
ffffffe0002037f0:	f4843783          	ld	a5,-184(s0)
ffffffe0002037f4:	00878713          	addi	a4,a5,8
ffffffe0002037f8:	f4e43423          	sd	a4,-184(s0)
ffffffe0002037fc:	0007b783          	ld	a5,0(a5)
ffffffe000203800:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
ffffffe000203804:	fc043583          	ld	a1,-64(s0)
ffffffe000203808:	f5843503          	ld	a0,-168(s0)
ffffffe00020380c:	dccff0ef          	jal	ffffffe000202dd8 <puts_wo_nl>
ffffffe000203810:	00050793          	mv	a5,a0
ffffffe000203814:	fec42703          	lw	a4,-20(s0)
ffffffe000203818:	00f707bb          	addw	a5,a4,a5
ffffffe00020381c:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203820:	f8040023          	sb	zero,-128(s0)
ffffffe000203824:	1040006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
ffffffe000203828:	f5043783          	ld	a5,-176(s0)
ffffffe00020382c:	0007c783          	lbu	a5,0(a5)
ffffffe000203830:	00078713          	mv	a4,a5
ffffffe000203834:	06300793          	li	a5,99
ffffffe000203838:	02f71e63          	bne	a4,a5,ffffffe000203874 <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
ffffffe00020383c:	f4843783          	ld	a5,-184(s0)
ffffffe000203840:	00878713          	addi	a4,a5,8
ffffffe000203844:	f4e43423          	sd	a4,-184(s0)
ffffffe000203848:	0007a783          	lw	a5,0(a5)
ffffffe00020384c:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
ffffffe000203850:	fcc42703          	lw	a4,-52(s0)
ffffffe000203854:	f5843783          	ld	a5,-168(s0)
ffffffe000203858:	00070513          	mv	a0,a4
ffffffe00020385c:	000780e7          	jalr	a5
                ++written;
ffffffe000203860:	fec42783          	lw	a5,-20(s0)
ffffffe000203864:	0017879b          	addiw	a5,a5,1
ffffffe000203868:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe00020386c:	f8040023          	sb	zero,-128(s0)
ffffffe000203870:	0b80006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
ffffffe000203874:	f5043783          	ld	a5,-176(s0)
ffffffe000203878:	0007c783          	lbu	a5,0(a5)
ffffffe00020387c:	00078713          	mv	a4,a5
ffffffe000203880:	02500793          	li	a5,37
ffffffe000203884:	02f71263          	bne	a4,a5,ffffffe0002038a8 <vprintfmt+0x740>
                putch('%');
ffffffe000203888:	f5843783          	ld	a5,-168(s0)
ffffffe00020388c:	02500513          	li	a0,37
ffffffe000203890:	000780e7          	jalr	a5
                ++written;
ffffffe000203894:	fec42783          	lw	a5,-20(s0)
ffffffe000203898:	0017879b          	addiw	a5,a5,1
ffffffe00020389c:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe0002038a0:	f8040023          	sb	zero,-128(s0)
ffffffe0002038a4:	0840006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
ffffffe0002038a8:	f5043783          	ld	a5,-176(s0)
ffffffe0002038ac:	0007c783          	lbu	a5,0(a5)
ffffffe0002038b0:	0007871b          	sext.w	a4,a5
ffffffe0002038b4:	f5843783          	ld	a5,-168(s0)
ffffffe0002038b8:	00070513          	mv	a0,a4
ffffffe0002038bc:	000780e7          	jalr	a5
                ++written;
ffffffe0002038c0:	fec42783          	lw	a5,-20(s0)
ffffffe0002038c4:	0017879b          	addiw	a5,a5,1
ffffffe0002038c8:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe0002038cc:	f8040023          	sb	zero,-128(s0)
ffffffe0002038d0:	0580006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
ffffffe0002038d4:	f5043783          	ld	a5,-176(s0)
ffffffe0002038d8:	0007c783          	lbu	a5,0(a5)
ffffffe0002038dc:	00078713          	mv	a4,a5
ffffffe0002038e0:	02500793          	li	a5,37
ffffffe0002038e4:	02f71063          	bne	a4,a5,ffffffe000203904 <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
ffffffe0002038e8:	f8043023          	sd	zero,-128(s0)
ffffffe0002038ec:	f8043423          	sd	zero,-120(s0)
ffffffe0002038f0:	00100793          	li	a5,1
ffffffe0002038f4:	f8f40023          	sb	a5,-128(s0)
ffffffe0002038f8:	fff00793          	li	a5,-1
ffffffe0002038fc:	f8f42623          	sw	a5,-116(s0)
ffffffe000203900:	0280006f          	j	ffffffe000203928 <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
ffffffe000203904:	f5043783          	ld	a5,-176(s0)
ffffffe000203908:	0007c783          	lbu	a5,0(a5)
ffffffe00020390c:	0007871b          	sext.w	a4,a5
ffffffe000203910:	f5843783          	ld	a5,-168(s0)
ffffffe000203914:	00070513          	mv	a0,a4
ffffffe000203918:	000780e7          	jalr	a5
            ++written;
ffffffe00020391c:	fec42783          	lw	a5,-20(s0)
ffffffe000203920:	0017879b          	addiw	a5,a5,1
ffffffe000203924:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
ffffffe000203928:	f5043783          	ld	a5,-176(s0)
ffffffe00020392c:	00178793          	addi	a5,a5,1
ffffffe000203930:	f4f43823          	sd	a5,-176(s0)
ffffffe000203934:	f5043783          	ld	a5,-176(s0)
ffffffe000203938:	0007c783          	lbu	a5,0(a5)
ffffffe00020393c:	84079ce3          	bnez	a5,ffffffe000203194 <vprintfmt+0x2c>
        }
    }

    return written;
ffffffe000203940:	fec42783          	lw	a5,-20(s0)
}
ffffffe000203944:	00078513          	mv	a0,a5
ffffffe000203948:	0b813083          	ld	ra,184(sp)
ffffffe00020394c:	0b013403          	ld	s0,176(sp)
ffffffe000203950:	0c010113          	addi	sp,sp,192
ffffffe000203954:	00008067          	ret

ffffffe000203958 <printk>:

int printk(const char* s, ...) {
ffffffe000203958:	f9010113          	addi	sp,sp,-112
ffffffe00020395c:	02113423          	sd	ra,40(sp)
ffffffe000203960:	02813023          	sd	s0,32(sp)
ffffffe000203964:	03010413          	addi	s0,sp,48
ffffffe000203968:	fca43c23          	sd	a0,-40(s0)
ffffffe00020396c:	00b43423          	sd	a1,8(s0)
ffffffe000203970:	00c43823          	sd	a2,16(s0)
ffffffe000203974:	00d43c23          	sd	a3,24(s0)
ffffffe000203978:	02e43023          	sd	a4,32(s0)
ffffffe00020397c:	02f43423          	sd	a5,40(s0)
ffffffe000203980:	03043823          	sd	a6,48(s0)
ffffffe000203984:	03143c23          	sd	a7,56(s0)
    int res = 0;
ffffffe000203988:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
ffffffe00020398c:	04040793          	addi	a5,s0,64
ffffffe000203990:	fcf43823          	sd	a5,-48(s0)
ffffffe000203994:	fd043783          	ld	a5,-48(s0)
ffffffe000203998:	fc878793          	addi	a5,a5,-56
ffffffe00020399c:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
ffffffe0002039a0:	fe043783          	ld	a5,-32(s0)
ffffffe0002039a4:	00078613          	mv	a2,a5
ffffffe0002039a8:	fd843583          	ld	a1,-40(s0)
ffffffe0002039ac:	fffff517          	auipc	a0,0xfffff
ffffffe0002039b0:	11850513          	addi	a0,a0,280 # ffffffe000202ac4 <putc>
ffffffe0002039b4:	fb4ff0ef          	jal	ffffffe000203168 <vprintfmt>
ffffffe0002039b8:	00050793          	mv	a5,a0
ffffffe0002039bc:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
ffffffe0002039c0:	fec42783          	lw	a5,-20(s0)
}
ffffffe0002039c4:	00078513          	mv	a0,a5
ffffffe0002039c8:	02813083          	ld	ra,40(sp)
ffffffe0002039cc:	02013403          	ld	s0,32(sp)
ffffffe0002039d0:	07010113          	addi	sp,sp,112
ffffffe0002039d4:	00008067          	ret

ffffffe0002039d8 <srand>:
#include "stdint.h"
#include "stdlib.h"

static uint64_t seed;

void srand(unsigned s) {
ffffffe0002039d8:	fe010113          	addi	sp,sp,-32
ffffffe0002039dc:	00813c23          	sd	s0,24(sp)
ffffffe0002039e0:	02010413          	addi	s0,sp,32
ffffffe0002039e4:	00050793          	mv	a5,a0
ffffffe0002039e8:	fef42623          	sw	a5,-20(s0)
    seed = s - 1;
ffffffe0002039ec:	fec42783          	lw	a5,-20(s0)
ffffffe0002039f0:	fff7879b          	addiw	a5,a5,-1
ffffffe0002039f4:	0007879b          	sext.w	a5,a5
ffffffe0002039f8:	02079713          	slli	a4,a5,0x20
ffffffe0002039fc:	02075713          	srli	a4,a4,0x20
ffffffe000203a00:	00005797          	auipc	a5,0x5
ffffffe000203a04:	62078793          	addi	a5,a5,1568 # ffffffe000209020 <seed>
ffffffe000203a08:	00e7b023          	sd	a4,0(a5)
}
ffffffe000203a0c:	00000013          	nop
ffffffe000203a10:	01813403          	ld	s0,24(sp)
ffffffe000203a14:	02010113          	addi	sp,sp,32
ffffffe000203a18:	00008067          	ret

ffffffe000203a1c <rand>:

int rand(void) {
ffffffe000203a1c:	ff010113          	addi	sp,sp,-16
ffffffe000203a20:	00813423          	sd	s0,8(sp)
ffffffe000203a24:	01010413          	addi	s0,sp,16
    seed = 6364136223846793005ULL * seed + 1;
ffffffe000203a28:	00005797          	auipc	a5,0x5
ffffffe000203a2c:	5f878793          	addi	a5,a5,1528 # ffffffe000209020 <seed>
ffffffe000203a30:	0007b703          	ld	a4,0(a5)
ffffffe000203a34:	00001797          	auipc	a5,0x1
ffffffe000203a38:	b2c78793          	addi	a5,a5,-1236 # ffffffe000204560 <lowerxdigits.0+0x18>
ffffffe000203a3c:	0007b783          	ld	a5,0(a5)
ffffffe000203a40:	02f707b3          	mul	a5,a4,a5
ffffffe000203a44:	00178713          	addi	a4,a5,1
ffffffe000203a48:	00005797          	auipc	a5,0x5
ffffffe000203a4c:	5d878793          	addi	a5,a5,1496 # ffffffe000209020 <seed>
ffffffe000203a50:	00e7b023          	sd	a4,0(a5)
    return seed >> 33;
ffffffe000203a54:	00005797          	auipc	a5,0x5
ffffffe000203a58:	5cc78793          	addi	a5,a5,1484 # ffffffe000209020 <seed>
ffffffe000203a5c:	0007b783          	ld	a5,0(a5)
ffffffe000203a60:	0217d793          	srli	a5,a5,0x21
ffffffe000203a64:	0007879b          	sext.w	a5,a5
}
ffffffe000203a68:	00078513          	mv	a0,a5
ffffffe000203a6c:	00813403          	ld	s0,8(sp)
ffffffe000203a70:	01010113          	addi	sp,sp,16
ffffffe000203a74:	00008067          	ret

ffffffe000203a78 <memset>:
#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n)
{
ffffffe000203a78:	fc010113          	addi	sp,sp,-64
ffffffe000203a7c:	02813c23          	sd	s0,56(sp)
ffffffe000203a80:	04010413          	addi	s0,sp,64
ffffffe000203a84:	fca43c23          	sd	a0,-40(s0)
ffffffe000203a88:	00058793          	mv	a5,a1
ffffffe000203a8c:	fcc43423          	sd	a2,-56(s0)
ffffffe000203a90:	fcf42a23          	sw	a5,-44(s0)
    char *s = (char *)dest;
ffffffe000203a94:	fd843783          	ld	a5,-40(s0)
ffffffe000203a98:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < n; ++i)
ffffffe000203a9c:	fe043423          	sd	zero,-24(s0)
ffffffe000203aa0:	0280006f          	j	ffffffe000203ac8 <memset+0x50>
    {
        s[i] = c;
ffffffe000203aa4:	fe043703          	ld	a4,-32(s0)
ffffffe000203aa8:	fe843783          	ld	a5,-24(s0)
ffffffe000203aac:	00f707b3          	add	a5,a4,a5
ffffffe000203ab0:	fd442703          	lw	a4,-44(s0)
ffffffe000203ab4:	0ff77713          	zext.b	a4,a4
ffffffe000203ab8:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i)
ffffffe000203abc:	fe843783          	ld	a5,-24(s0)
ffffffe000203ac0:	00178793          	addi	a5,a5,1
ffffffe000203ac4:	fef43423          	sd	a5,-24(s0)
ffffffe000203ac8:	fe843703          	ld	a4,-24(s0)
ffffffe000203acc:	fc843783          	ld	a5,-56(s0)
ffffffe000203ad0:	fcf76ae3          	bltu	a4,a5,ffffffe000203aa4 <memset+0x2c>
    }
    return dest;
ffffffe000203ad4:	fd843783          	ld	a5,-40(s0)
}
ffffffe000203ad8:	00078513          	mv	a0,a5
ffffffe000203adc:	03813403          	ld	s0,56(sp)
ffffffe000203ae0:	04010113          	addi	sp,sp,64
ffffffe000203ae4:	00008067          	ret

ffffffe000203ae8 <memcpy>:

void *memcpy(void *dest, const void *src, uint64_t n)
{
ffffffe000203ae8:	fb010113          	addi	sp,sp,-80
ffffffe000203aec:	04813423          	sd	s0,72(sp)
ffffffe000203af0:	05010413          	addi	s0,sp,80
ffffffe000203af4:	fca43423          	sd	a0,-56(s0)
ffffffe000203af8:	fcb43023          	sd	a1,-64(s0)
ffffffe000203afc:	fac43c23          	sd	a2,-72(s0)
    // 将void指针转换为char指针，以便可以通过指针算术进行操作
    char *d = (char *)dest;
ffffffe000203b00:	fc843783          	ld	a5,-56(s0)
ffffffe000203b04:	fef43023          	sd	a5,-32(s0)
    const char *s = (const char *)src;
ffffffe000203b08:	fc043783          	ld	a5,-64(s0)
ffffffe000203b0c:	fcf43c23          	sd	a5,-40(s0)

    // 循环复制每个字节，直到复制了n个字节
    for (uint64_t i = 0; i < n; i++)
ffffffe000203b10:	fe043423          	sd	zero,-24(s0)
ffffffe000203b14:	0300006f          	j	ffffffe000203b44 <memcpy+0x5c>
    {
        d[i] = s[i];
ffffffe000203b18:	fd843703          	ld	a4,-40(s0)
ffffffe000203b1c:	fe843783          	ld	a5,-24(s0)
ffffffe000203b20:	00f70733          	add	a4,a4,a5
ffffffe000203b24:	fe043683          	ld	a3,-32(s0)
ffffffe000203b28:	fe843783          	ld	a5,-24(s0)
ffffffe000203b2c:	00f687b3          	add	a5,a3,a5
ffffffe000203b30:	00074703          	lbu	a4,0(a4)
ffffffe000203b34:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; i++)
ffffffe000203b38:	fe843783          	ld	a5,-24(s0)
ffffffe000203b3c:	00178793          	addi	a5,a5,1
ffffffe000203b40:	fef43423          	sd	a5,-24(s0)
ffffffe000203b44:	fe843703          	ld	a4,-24(s0)
ffffffe000203b48:	fb843783          	ld	a5,-72(s0)
ffffffe000203b4c:	fcf766e3          	bltu	a4,a5,ffffffe000203b18 <memcpy+0x30>
    }
    return dest;
ffffffe000203b50:	fc843783          	ld	a5,-56(s0)
}
ffffffe000203b54:	00078513          	mv	a0,a5
ffffffe000203b58:	04813403          	ld	s0,72(sp)
ffffffe000203b5c:	05010113          	addi	sp,sp,80
ffffffe000203b60:	00008067          	ret
