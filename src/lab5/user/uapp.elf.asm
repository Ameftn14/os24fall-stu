
uapp.elf:     file format elf64-littleriscv


Disassembly of section .text.init:

0000000000000000 <_start>:
   0:	0c00006f          	j	c0 <main>

Disassembly of section .text.getpid:

0000000000000004 <getpid>:
   4:	fe010113          	addi	sp,sp,-32
   8:	00813c23          	sd	s0,24(sp)
   c:	02010413          	addi	s0,sp,32
  10:	fe843783          	ld	a5,-24(s0)
  14:	0ac00893          	li	a7,172
  18:	00000073          	ecall
  1c:	00050793          	mv	a5,a0
  20:	fef43423          	sd	a5,-24(s0)
  24:	fe843783          	ld	a5,-24(s0)
  28:	00078513          	mv	a0,a5
  2c:	01813403          	ld	s0,24(sp)
  30:	02010113          	addi	sp,sp,32
  34:	00008067          	ret

Disassembly of section .text.fork:

0000000000000038 <fork>:
  38:	fe010113          	addi	sp,sp,-32
  3c:	00813c23          	sd	s0,24(sp)
  40:	02010413          	addi	s0,sp,32
  44:	fe843783          	ld	a5,-24(s0)
  48:	0dc00893          	li	a7,220
  4c:	00000073          	ecall
  50:	00050793          	mv	a5,a0
  54:	fef43423          	sd	a5,-24(s0)
  58:	fe843783          	ld	a5,-24(s0)
  5c:	00078513          	mv	a0,a5
  60:	01813403          	ld	s0,24(sp)
  64:	02010113          	addi	sp,sp,32
  68:	00008067          	ret

Disassembly of section .text.wait:

000000000000006c <wait>:
  6c:	fd010113          	addi	sp,sp,-48
  70:	02813423          	sd	s0,40(sp)
  74:	03010413          	addi	s0,sp,48
  78:	00050793          	mv	a5,a0
  7c:	fcf42e23          	sw	a5,-36(s0)
  80:	fe042623          	sw	zero,-20(s0)
  84:	0100006f          	j	94 <wait+0x28>
  88:	fec42783          	lw	a5,-20(s0)
  8c:	0017879b          	addiw	a5,a5,1
  90:	fef42623          	sw	a5,-20(s0)
  94:	fec42783          	lw	a5,-20(s0)
  98:	00078713          	mv	a4,a5
  9c:	fdc42783          	lw	a5,-36(s0)
  a0:	0007071b          	sext.w	a4,a4
  a4:	0007879b          	sext.w	a5,a5
  a8:	fef760e3          	bltu	a4,a5,88 <wait+0x1c>
  ac:	00000013          	nop
  b0:	00000013          	nop
  b4:	02813403          	ld	s0,40(sp)
  b8:	03010113          	addi	sp,sp,48
  bc:	00008067          	ret

Disassembly of section .text.main:

00000000000000c0 <main>:
  c0:	ff010113          	addi	sp,sp,-16
  c4:	00113423          	sd	ra,8(sp)
  c8:	00813023          	sd	s0,0(sp)
  cc:	01010413          	addi	s0,sp,16
  d0:	00000097          	auipc	ra,0x0
  d4:	f34080e7          	jalr	-204(ra) # 4 <getpid>
  d8:	00050593          	mv	a1,a0
  dc:	00001797          	auipc	a5,0x1
  e0:	2f078793          	addi	a5,a5,752 # 13cc <global_variable>
  e4:	0007a783          	lw	a5,0(a5)
  e8:	0017871b          	addiw	a4,a5,1
  ec:	0007069b          	sext.w	a3,a4
  f0:	00001717          	auipc	a4,0x1
  f4:	2dc70713          	addi	a4,a4,732 # 13cc <global_variable>
  f8:	00d72023          	sw	a3,0(a4)
  fc:	00078613          	mv	a2,a5
 100:	00001517          	auipc	a0,0x1
 104:	25050513          	addi	a0,a0,592 # 1350 <printf+0x2c4>
 108:	00001097          	auipc	ra,0x1
 10c:	f84080e7          	jalr	-124(ra) # 108c <printf>
 110:	00000097          	auipc	ra,0x0
 114:	f28080e7          	jalr	-216(ra) # 38 <fork>
 118:	00000097          	auipc	ra,0x0
 11c:	f20080e7          	jalr	-224(ra) # 38 <fork>
 120:	00000097          	auipc	ra,0x0
 124:	ee4080e7          	jalr	-284(ra) # 4 <getpid>
 128:	00050593          	mv	a1,a0
 12c:	00001797          	auipc	a5,0x1
 130:	2a078793          	addi	a5,a5,672 # 13cc <global_variable>
 134:	0007a783          	lw	a5,0(a5)
 138:	0017871b          	addiw	a4,a5,1
 13c:	0007069b          	sext.w	a3,a4
 140:	00001717          	auipc	a4,0x1
 144:	28c70713          	addi	a4,a4,652 # 13cc <global_variable>
 148:	00d72023          	sw	a3,0(a4)
 14c:	00078613          	mv	a2,a5
 150:	00001517          	auipc	a0,0x1
 154:	20050513          	addi	a0,a0,512 # 1350 <printf+0x2c4>
 158:	00001097          	auipc	ra,0x1
 15c:	f34080e7          	jalr	-204(ra) # 108c <printf>
 160:	00000097          	auipc	ra,0x0
 164:	ed8080e7          	jalr	-296(ra) # 38 <fork>
 168:	00000097          	auipc	ra,0x0
 16c:	e9c080e7          	jalr	-356(ra) # 4 <getpid>
 170:	00050593          	mv	a1,a0
 174:	00001797          	auipc	a5,0x1
 178:	25878793          	addi	a5,a5,600 # 13cc <global_variable>
 17c:	0007a783          	lw	a5,0(a5)
 180:	0017871b          	addiw	a4,a5,1
 184:	0007069b          	sext.w	a3,a4
 188:	00001717          	auipc	a4,0x1
 18c:	24470713          	addi	a4,a4,580 # 13cc <global_variable>
 190:	00d72023          	sw	a3,0(a4)
 194:	00078613          	mv	a2,a5
 198:	00001517          	auipc	a0,0x1
 19c:	1b850513          	addi	a0,a0,440 # 1350 <printf+0x2c4>
 1a0:	00001097          	auipc	ra,0x1
 1a4:	eec080e7          	jalr	-276(ra) # 108c <printf>
 1a8:	500007b7          	lui	a5,0x50000
 1ac:	fff78513          	addi	a0,a5,-1 # 4fffffff <buffer+0x4fffec27>
 1b0:	00000097          	auipc	ra,0x0
 1b4:	ebc080e7          	jalr	-324(ra) # 6c <wait>
 1b8:	00000013          	nop
 1bc:	fadff06f          	j	168 <main+0xa8>

Disassembly of section .text.putc:

00000000000001c0 <putc>:
 1c0:	fe010113          	addi	sp,sp,-32
 1c4:	00813c23          	sd	s0,24(sp)
 1c8:	02010413          	addi	s0,sp,32
 1cc:	00050793          	mv	a5,a0
 1d0:	fef42623          	sw	a5,-20(s0)
 1d4:	00001797          	auipc	a5,0x1
 1d8:	1fc78793          	addi	a5,a5,508 # 13d0 <tail>
 1dc:	0007a783          	lw	a5,0(a5)
 1e0:	0017871b          	addiw	a4,a5,1
 1e4:	0007069b          	sext.w	a3,a4
 1e8:	00001717          	auipc	a4,0x1
 1ec:	1e870713          	addi	a4,a4,488 # 13d0 <tail>
 1f0:	00d72023          	sw	a3,0(a4)
 1f4:	fec42703          	lw	a4,-20(s0)
 1f8:	0ff77713          	zext.b	a4,a4
 1fc:	00001697          	auipc	a3,0x1
 200:	1dc68693          	addi	a3,a3,476 # 13d8 <buffer>
 204:	00f687b3          	add	a5,a3,a5
 208:	00e78023          	sb	a4,0(a5)
 20c:	fec42783          	lw	a5,-20(s0)
 210:	0ff7f793          	zext.b	a5,a5
 214:	0007879b          	sext.w	a5,a5
 218:	00078513          	mv	a0,a5
 21c:	01813403          	ld	s0,24(sp)
 220:	02010113          	addi	sp,sp,32
 224:	00008067          	ret

Disassembly of section .text.isspace:

0000000000000228 <isspace>:
 228:	fe010113          	addi	sp,sp,-32
 22c:	00813c23          	sd	s0,24(sp)
 230:	02010413          	addi	s0,sp,32
 234:	00050793          	mv	a5,a0
 238:	fef42623          	sw	a5,-20(s0)
 23c:	fec42783          	lw	a5,-20(s0)
 240:	0007871b          	sext.w	a4,a5
 244:	02000793          	li	a5,32
 248:	02f70263          	beq	a4,a5,26c <isspace+0x44>
 24c:	fec42783          	lw	a5,-20(s0)
 250:	0007871b          	sext.w	a4,a5
 254:	00800793          	li	a5,8
 258:	00e7de63          	bge	a5,a4,274 <isspace+0x4c>
 25c:	fec42783          	lw	a5,-20(s0)
 260:	0007871b          	sext.w	a4,a5
 264:	00d00793          	li	a5,13
 268:	00e7c663          	blt	a5,a4,274 <isspace+0x4c>
 26c:	00100793          	li	a5,1
 270:	0080006f          	j	278 <isspace+0x50>
 274:	00000793          	li	a5,0
 278:	00078513          	mv	a0,a5
 27c:	01813403          	ld	s0,24(sp)
 280:	02010113          	addi	sp,sp,32
 284:	00008067          	ret

Disassembly of section .text.strtol:

0000000000000288 <strtol>:
 288:	fb010113          	addi	sp,sp,-80
 28c:	04113423          	sd	ra,72(sp)
 290:	04813023          	sd	s0,64(sp)
 294:	05010413          	addi	s0,sp,80
 298:	fca43423          	sd	a0,-56(s0)
 29c:	fcb43023          	sd	a1,-64(s0)
 2a0:	00060793          	mv	a5,a2
 2a4:	faf42e23          	sw	a5,-68(s0)
 2a8:	fe043423          	sd	zero,-24(s0)
 2ac:	fe0403a3          	sb	zero,-25(s0)
 2b0:	fc843783          	ld	a5,-56(s0)
 2b4:	fcf43c23          	sd	a5,-40(s0)
 2b8:	0100006f          	j	2c8 <strtol+0x40>
 2bc:	fd843783          	ld	a5,-40(s0)
 2c0:	00178793          	addi	a5,a5,1
 2c4:	fcf43c23          	sd	a5,-40(s0)
 2c8:	fd843783          	ld	a5,-40(s0)
 2cc:	0007c783          	lbu	a5,0(a5)
 2d0:	0007879b          	sext.w	a5,a5
 2d4:	00078513          	mv	a0,a5
 2d8:	00000097          	auipc	ra,0x0
 2dc:	f50080e7          	jalr	-176(ra) # 228 <isspace>
 2e0:	00050793          	mv	a5,a0
 2e4:	fc079ce3          	bnez	a5,2bc <strtol+0x34>
 2e8:	fd843783          	ld	a5,-40(s0)
 2ec:	0007c783          	lbu	a5,0(a5)
 2f0:	00078713          	mv	a4,a5
 2f4:	02d00793          	li	a5,45
 2f8:	00f71e63          	bne	a4,a5,314 <strtol+0x8c>
 2fc:	00100793          	li	a5,1
 300:	fef403a3          	sb	a5,-25(s0)
 304:	fd843783          	ld	a5,-40(s0)
 308:	00178793          	addi	a5,a5,1
 30c:	fcf43c23          	sd	a5,-40(s0)
 310:	0240006f          	j	334 <strtol+0xac>
 314:	fd843783          	ld	a5,-40(s0)
 318:	0007c783          	lbu	a5,0(a5)
 31c:	00078713          	mv	a4,a5
 320:	02b00793          	li	a5,43
 324:	00f71863          	bne	a4,a5,334 <strtol+0xac>
 328:	fd843783          	ld	a5,-40(s0)
 32c:	00178793          	addi	a5,a5,1
 330:	fcf43c23          	sd	a5,-40(s0)
 334:	fbc42783          	lw	a5,-68(s0)
 338:	0007879b          	sext.w	a5,a5
 33c:	06079c63          	bnez	a5,3b4 <strtol+0x12c>
 340:	fd843783          	ld	a5,-40(s0)
 344:	0007c783          	lbu	a5,0(a5)
 348:	00078713          	mv	a4,a5
 34c:	03000793          	li	a5,48
 350:	04f71e63          	bne	a4,a5,3ac <strtol+0x124>
 354:	fd843783          	ld	a5,-40(s0)
 358:	00178793          	addi	a5,a5,1
 35c:	fcf43c23          	sd	a5,-40(s0)
 360:	fd843783          	ld	a5,-40(s0)
 364:	0007c783          	lbu	a5,0(a5)
 368:	00078713          	mv	a4,a5
 36c:	07800793          	li	a5,120
 370:	00f70c63          	beq	a4,a5,388 <strtol+0x100>
 374:	fd843783          	ld	a5,-40(s0)
 378:	0007c783          	lbu	a5,0(a5)
 37c:	00078713          	mv	a4,a5
 380:	05800793          	li	a5,88
 384:	00f71e63          	bne	a4,a5,3a0 <strtol+0x118>
 388:	01000793          	li	a5,16
 38c:	faf42e23          	sw	a5,-68(s0)
 390:	fd843783          	ld	a5,-40(s0)
 394:	00178793          	addi	a5,a5,1
 398:	fcf43c23          	sd	a5,-40(s0)
 39c:	0180006f          	j	3b4 <strtol+0x12c>
 3a0:	00800793          	li	a5,8
 3a4:	faf42e23          	sw	a5,-68(s0)
 3a8:	00c0006f          	j	3b4 <strtol+0x12c>
 3ac:	00a00793          	li	a5,10
 3b0:	faf42e23          	sw	a5,-68(s0)
 3b4:	fd843783          	ld	a5,-40(s0)
 3b8:	0007c783          	lbu	a5,0(a5)
 3bc:	00078713          	mv	a4,a5
 3c0:	02f00793          	li	a5,47
 3c4:	02e7f863          	bgeu	a5,a4,3f4 <strtol+0x16c>
 3c8:	fd843783          	ld	a5,-40(s0)
 3cc:	0007c783          	lbu	a5,0(a5)
 3d0:	00078713          	mv	a4,a5
 3d4:	03900793          	li	a5,57
 3d8:	00e7ee63          	bltu	a5,a4,3f4 <strtol+0x16c>
 3dc:	fd843783          	ld	a5,-40(s0)
 3e0:	0007c783          	lbu	a5,0(a5)
 3e4:	0007879b          	sext.w	a5,a5
 3e8:	fd07879b          	addiw	a5,a5,-48
 3ec:	fcf42a23          	sw	a5,-44(s0)
 3f0:	0800006f          	j	470 <strtol+0x1e8>
 3f4:	fd843783          	ld	a5,-40(s0)
 3f8:	0007c783          	lbu	a5,0(a5)
 3fc:	00078713          	mv	a4,a5
 400:	06000793          	li	a5,96
 404:	02e7f863          	bgeu	a5,a4,434 <strtol+0x1ac>
 408:	fd843783          	ld	a5,-40(s0)
 40c:	0007c783          	lbu	a5,0(a5)
 410:	00078713          	mv	a4,a5
 414:	07a00793          	li	a5,122
 418:	00e7ee63          	bltu	a5,a4,434 <strtol+0x1ac>
 41c:	fd843783          	ld	a5,-40(s0)
 420:	0007c783          	lbu	a5,0(a5)
 424:	0007879b          	sext.w	a5,a5
 428:	fa97879b          	addiw	a5,a5,-87
 42c:	fcf42a23          	sw	a5,-44(s0)
 430:	0400006f          	j	470 <strtol+0x1e8>
 434:	fd843783          	ld	a5,-40(s0)
 438:	0007c783          	lbu	a5,0(a5)
 43c:	00078713          	mv	a4,a5
 440:	04000793          	li	a5,64
 444:	06e7f863          	bgeu	a5,a4,4b4 <strtol+0x22c>
 448:	fd843783          	ld	a5,-40(s0)
 44c:	0007c783          	lbu	a5,0(a5)
 450:	00078713          	mv	a4,a5
 454:	05a00793          	li	a5,90
 458:	04e7ee63          	bltu	a5,a4,4b4 <strtol+0x22c>
 45c:	fd843783          	ld	a5,-40(s0)
 460:	0007c783          	lbu	a5,0(a5)
 464:	0007879b          	sext.w	a5,a5
 468:	fc97879b          	addiw	a5,a5,-55
 46c:	fcf42a23          	sw	a5,-44(s0)
 470:	fd442783          	lw	a5,-44(s0)
 474:	00078713          	mv	a4,a5
 478:	fbc42783          	lw	a5,-68(s0)
 47c:	0007071b          	sext.w	a4,a4
 480:	0007879b          	sext.w	a5,a5
 484:	02f75663          	bge	a4,a5,4b0 <strtol+0x228>
 488:	fbc42703          	lw	a4,-68(s0)
 48c:	fe843783          	ld	a5,-24(s0)
 490:	02f70733          	mul	a4,a4,a5
 494:	fd442783          	lw	a5,-44(s0)
 498:	00f707b3          	add	a5,a4,a5
 49c:	fef43423          	sd	a5,-24(s0)
 4a0:	fd843783          	ld	a5,-40(s0)
 4a4:	00178793          	addi	a5,a5,1
 4a8:	fcf43c23          	sd	a5,-40(s0)
 4ac:	f09ff06f          	j	3b4 <strtol+0x12c>
 4b0:	00000013          	nop
 4b4:	fc043783          	ld	a5,-64(s0)
 4b8:	00078863          	beqz	a5,4c8 <strtol+0x240>
 4bc:	fc043783          	ld	a5,-64(s0)
 4c0:	fd843703          	ld	a4,-40(s0)
 4c4:	00e7b023          	sd	a4,0(a5)
 4c8:	fe744783          	lbu	a5,-25(s0)
 4cc:	0ff7f793          	zext.b	a5,a5
 4d0:	00078863          	beqz	a5,4e0 <strtol+0x258>
 4d4:	fe843783          	ld	a5,-24(s0)
 4d8:	40f007b3          	neg	a5,a5
 4dc:	0080006f          	j	4e4 <strtol+0x25c>
 4e0:	fe843783          	ld	a5,-24(s0)
 4e4:	00078513          	mv	a0,a5
 4e8:	04813083          	ld	ra,72(sp)
 4ec:	04013403          	ld	s0,64(sp)
 4f0:	05010113          	addi	sp,sp,80
 4f4:	00008067          	ret

Disassembly of section .text.puts_wo_nl:

00000000000004f8 <puts_wo_nl>:
 4f8:	fd010113          	addi	sp,sp,-48
 4fc:	02113423          	sd	ra,40(sp)
 500:	02813023          	sd	s0,32(sp)
 504:	03010413          	addi	s0,sp,48
 508:	fca43c23          	sd	a0,-40(s0)
 50c:	fcb43823          	sd	a1,-48(s0)
 510:	fd043783          	ld	a5,-48(s0)
 514:	00079863          	bnez	a5,524 <puts_wo_nl+0x2c>
 518:	00001797          	auipc	a5,0x1
 51c:	e6878793          	addi	a5,a5,-408 # 1380 <printf+0x2f4>
 520:	fcf43823          	sd	a5,-48(s0)
 524:	fd043783          	ld	a5,-48(s0)
 528:	fef43423          	sd	a5,-24(s0)
 52c:	0240006f          	j	550 <puts_wo_nl+0x58>
 530:	fe843783          	ld	a5,-24(s0)
 534:	00178713          	addi	a4,a5,1
 538:	fee43423          	sd	a4,-24(s0)
 53c:	0007c783          	lbu	a5,0(a5)
 540:	0007871b          	sext.w	a4,a5
 544:	fd843783          	ld	a5,-40(s0)
 548:	00070513          	mv	a0,a4
 54c:	000780e7          	jalr	a5
 550:	fe843783          	ld	a5,-24(s0)
 554:	0007c783          	lbu	a5,0(a5)
 558:	fc079ce3          	bnez	a5,530 <puts_wo_nl+0x38>
 55c:	fe843703          	ld	a4,-24(s0)
 560:	fd043783          	ld	a5,-48(s0)
 564:	40f707b3          	sub	a5,a4,a5
 568:	0007879b          	sext.w	a5,a5
 56c:	00078513          	mv	a0,a5
 570:	02813083          	ld	ra,40(sp)
 574:	02013403          	ld	s0,32(sp)
 578:	03010113          	addi	sp,sp,48
 57c:	00008067          	ret

Disassembly of section .text.print_dec_int:

0000000000000580 <print_dec_int>:
 580:	f9010113          	addi	sp,sp,-112
 584:	06113423          	sd	ra,104(sp)
 588:	06813023          	sd	s0,96(sp)
 58c:	07010413          	addi	s0,sp,112
 590:	faa43423          	sd	a0,-88(s0)
 594:	fab43023          	sd	a1,-96(s0)
 598:	00060793          	mv	a5,a2
 59c:	f8d43823          	sd	a3,-112(s0)
 5a0:	f8f40fa3          	sb	a5,-97(s0)
 5a4:	f9f44783          	lbu	a5,-97(s0)
 5a8:	0ff7f793          	zext.b	a5,a5
 5ac:	02078863          	beqz	a5,5dc <print_dec_int+0x5c>
 5b0:	fa043703          	ld	a4,-96(s0)
 5b4:	fff00793          	li	a5,-1
 5b8:	03f79793          	slli	a5,a5,0x3f
 5bc:	02f71063          	bne	a4,a5,5dc <print_dec_int+0x5c>
 5c0:	00001597          	auipc	a1,0x1
 5c4:	dc858593          	addi	a1,a1,-568 # 1388 <printf+0x2fc>
 5c8:	fa843503          	ld	a0,-88(s0)
 5cc:	00000097          	auipc	ra,0x0
 5d0:	f2c080e7          	jalr	-212(ra) # 4f8 <puts_wo_nl>
 5d4:	00050793          	mv	a5,a0
 5d8:	2a00006f          	j	878 <print_dec_int+0x2f8>
 5dc:	f9043783          	ld	a5,-112(s0)
 5e0:	00c7a783          	lw	a5,12(a5)
 5e4:	00079a63          	bnez	a5,5f8 <print_dec_int+0x78>
 5e8:	fa043783          	ld	a5,-96(s0)
 5ec:	00079663          	bnez	a5,5f8 <print_dec_int+0x78>
 5f0:	00000793          	li	a5,0
 5f4:	2840006f          	j	878 <print_dec_int+0x2f8>
 5f8:	fe0407a3          	sb	zero,-17(s0)
 5fc:	f9f44783          	lbu	a5,-97(s0)
 600:	0ff7f793          	zext.b	a5,a5
 604:	02078063          	beqz	a5,624 <print_dec_int+0xa4>
 608:	fa043783          	ld	a5,-96(s0)
 60c:	0007dc63          	bgez	a5,624 <print_dec_int+0xa4>
 610:	00100793          	li	a5,1
 614:	fef407a3          	sb	a5,-17(s0)
 618:	fa043783          	ld	a5,-96(s0)
 61c:	40f007b3          	neg	a5,a5
 620:	faf43023          	sd	a5,-96(s0)
 624:	fe042423          	sw	zero,-24(s0)
 628:	f9f44783          	lbu	a5,-97(s0)
 62c:	0ff7f793          	zext.b	a5,a5
 630:	02078863          	beqz	a5,660 <print_dec_int+0xe0>
 634:	fef44783          	lbu	a5,-17(s0)
 638:	0ff7f793          	zext.b	a5,a5
 63c:	00079e63          	bnez	a5,658 <print_dec_int+0xd8>
 640:	f9043783          	ld	a5,-112(s0)
 644:	0057c783          	lbu	a5,5(a5)
 648:	00079863          	bnez	a5,658 <print_dec_int+0xd8>
 64c:	f9043783          	ld	a5,-112(s0)
 650:	0047c783          	lbu	a5,4(a5)
 654:	00078663          	beqz	a5,660 <print_dec_int+0xe0>
 658:	00100793          	li	a5,1
 65c:	0080006f          	j	664 <print_dec_int+0xe4>
 660:	00000793          	li	a5,0
 664:	fcf40ba3          	sb	a5,-41(s0)
 668:	fd744783          	lbu	a5,-41(s0)
 66c:	0017f793          	andi	a5,a5,1
 670:	fcf40ba3          	sb	a5,-41(s0)
 674:	fa043703          	ld	a4,-96(s0)
 678:	00a00793          	li	a5,10
 67c:	02f777b3          	remu	a5,a4,a5
 680:	0ff7f713          	zext.b	a4,a5
 684:	fe842783          	lw	a5,-24(s0)
 688:	0017869b          	addiw	a3,a5,1
 68c:	fed42423          	sw	a3,-24(s0)
 690:	0307071b          	addiw	a4,a4,48
 694:	0ff77713          	zext.b	a4,a4
 698:	ff078793          	addi	a5,a5,-16
 69c:	008787b3          	add	a5,a5,s0
 6a0:	fce78423          	sb	a4,-56(a5)
 6a4:	fa043703          	ld	a4,-96(s0)
 6a8:	00a00793          	li	a5,10
 6ac:	02f757b3          	divu	a5,a4,a5
 6b0:	faf43023          	sd	a5,-96(s0)
 6b4:	fa043783          	ld	a5,-96(s0)
 6b8:	fa079ee3          	bnez	a5,674 <print_dec_int+0xf4>
 6bc:	f9043783          	ld	a5,-112(s0)
 6c0:	00c7a783          	lw	a5,12(a5)
 6c4:	00078713          	mv	a4,a5
 6c8:	fff00793          	li	a5,-1
 6cc:	02f71063          	bne	a4,a5,6ec <print_dec_int+0x16c>
 6d0:	f9043783          	ld	a5,-112(s0)
 6d4:	0037c783          	lbu	a5,3(a5)
 6d8:	00078a63          	beqz	a5,6ec <print_dec_int+0x16c>
 6dc:	f9043783          	ld	a5,-112(s0)
 6e0:	0087a703          	lw	a4,8(a5)
 6e4:	f9043783          	ld	a5,-112(s0)
 6e8:	00e7a623          	sw	a4,12(a5)
 6ec:	fe042223          	sw	zero,-28(s0)
 6f0:	f9043783          	ld	a5,-112(s0)
 6f4:	0087a703          	lw	a4,8(a5)
 6f8:	fe842783          	lw	a5,-24(s0)
 6fc:	fcf42823          	sw	a5,-48(s0)
 700:	f9043783          	ld	a5,-112(s0)
 704:	00c7a783          	lw	a5,12(a5)
 708:	fcf42623          	sw	a5,-52(s0)
 70c:	fd042783          	lw	a5,-48(s0)
 710:	00078593          	mv	a1,a5
 714:	fcc42783          	lw	a5,-52(s0)
 718:	00078613          	mv	a2,a5
 71c:	0006069b          	sext.w	a3,a2
 720:	0005879b          	sext.w	a5,a1
 724:	00f6d463          	bge	a3,a5,72c <print_dec_int+0x1ac>
 728:	00058613          	mv	a2,a1
 72c:	0006079b          	sext.w	a5,a2
 730:	40f707bb          	subw	a5,a4,a5
 734:	0007871b          	sext.w	a4,a5
 738:	fd744783          	lbu	a5,-41(s0)
 73c:	0007879b          	sext.w	a5,a5
 740:	40f707bb          	subw	a5,a4,a5
 744:	fef42023          	sw	a5,-32(s0)
 748:	0280006f          	j	770 <print_dec_int+0x1f0>
 74c:	fa843783          	ld	a5,-88(s0)
 750:	02000513          	li	a0,32
 754:	000780e7          	jalr	a5
 758:	fe442783          	lw	a5,-28(s0)
 75c:	0017879b          	addiw	a5,a5,1
 760:	fef42223          	sw	a5,-28(s0)
 764:	fe042783          	lw	a5,-32(s0)
 768:	fff7879b          	addiw	a5,a5,-1
 76c:	fef42023          	sw	a5,-32(s0)
 770:	fe042783          	lw	a5,-32(s0)
 774:	0007879b          	sext.w	a5,a5
 778:	fcf04ae3          	bgtz	a5,74c <print_dec_int+0x1cc>
 77c:	fd744783          	lbu	a5,-41(s0)
 780:	0ff7f793          	zext.b	a5,a5
 784:	04078463          	beqz	a5,7cc <print_dec_int+0x24c>
 788:	fef44783          	lbu	a5,-17(s0)
 78c:	0ff7f793          	zext.b	a5,a5
 790:	00078663          	beqz	a5,79c <print_dec_int+0x21c>
 794:	02d00793          	li	a5,45
 798:	01c0006f          	j	7b4 <print_dec_int+0x234>
 79c:	f9043783          	ld	a5,-112(s0)
 7a0:	0057c783          	lbu	a5,5(a5)
 7a4:	00078663          	beqz	a5,7b0 <print_dec_int+0x230>
 7a8:	02b00793          	li	a5,43
 7ac:	0080006f          	j	7b4 <print_dec_int+0x234>
 7b0:	02000793          	li	a5,32
 7b4:	fa843703          	ld	a4,-88(s0)
 7b8:	00078513          	mv	a0,a5
 7bc:	000700e7          	jalr	a4
 7c0:	fe442783          	lw	a5,-28(s0)
 7c4:	0017879b          	addiw	a5,a5,1
 7c8:	fef42223          	sw	a5,-28(s0)
 7cc:	fe842783          	lw	a5,-24(s0)
 7d0:	fcf42e23          	sw	a5,-36(s0)
 7d4:	0280006f          	j	7fc <print_dec_int+0x27c>
 7d8:	fa843783          	ld	a5,-88(s0)
 7dc:	03000513          	li	a0,48
 7e0:	000780e7          	jalr	a5
 7e4:	fe442783          	lw	a5,-28(s0)
 7e8:	0017879b          	addiw	a5,a5,1
 7ec:	fef42223          	sw	a5,-28(s0)
 7f0:	fdc42783          	lw	a5,-36(s0)
 7f4:	0017879b          	addiw	a5,a5,1
 7f8:	fcf42e23          	sw	a5,-36(s0)
 7fc:	f9043783          	ld	a5,-112(s0)
 800:	00c7a703          	lw	a4,12(a5)
 804:	fd744783          	lbu	a5,-41(s0)
 808:	0007879b          	sext.w	a5,a5
 80c:	40f707bb          	subw	a5,a4,a5
 810:	0007871b          	sext.w	a4,a5
 814:	fdc42783          	lw	a5,-36(s0)
 818:	0007879b          	sext.w	a5,a5
 81c:	fae7cee3          	blt	a5,a4,7d8 <print_dec_int+0x258>
 820:	fe842783          	lw	a5,-24(s0)
 824:	fff7879b          	addiw	a5,a5,-1
 828:	fcf42c23          	sw	a5,-40(s0)
 82c:	03c0006f          	j	868 <print_dec_int+0x2e8>
 830:	fd842783          	lw	a5,-40(s0)
 834:	ff078793          	addi	a5,a5,-16
 838:	008787b3          	add	a5,a5,s0
 83c:	fc87c783          	lbu	a5,-56(a5)
 840:	0007871b          	sext.w	a4,a5
 844:	fa843783          	ld	a5,-88(s0)
 848:	00070513          	mv	a0,a4
 84c:	000780e7          	jalr	a5
 850:	fe442783          	lw	a5,-28(s0)
 854:	0017879b          	addiw	a5,a5,1
 858:	fef42223          	sw	a5,-28(s0)
 85c:	fd842783          	lw	a5,-40(s0)
 860:	fff7879b          	addiw	a5,a5,-1
 864:	fcf42c23          	sw	a5,-40(s0)
 868:	fd842783          	lw	a5,-40(s0)
 86c:	0007879b          	sext.w	a5,a5
 870:	fc07d0e3          	bgez	a5,830 <print_dec_int+0x2b0>
 874:	fe442783          	lw	a5,-28(s0)
 878:	00078513          	mv	a0,a5
 87c:	06813083          	ld	ra,104(sp)
 880:	06013403          	ld	s0,96(sp)
 884:	07010113          	addi	sp,sp,112
 888:	00008067          	ret

Disassembly of section .text.vprintfmt:

000000000000088c <vprintfmt>:
     88c:	f4010113          	addi	sp,sp,-192
     890:	0a113c23          	sd	ra,184(sp)
     894:	0a813823          	sd	s0,176(sp)
     898:	0c010413          	addi	s0,sp,192
     89c:	f4a43c23          	sd	a0,-168(s0)
     8a0:	f4b43823          	sd	a1,-176(s0)
     8a4:	f4c43423          	sd	a2,-184(s0)
     8a8:	f8043023          	sd	zero,-128(s0)
     8ac:	f8043423          	sd	zero,-120(s0)
     8b0:	fe042623          	sw	zero,-20(s0)
     8b4:	7b40006f          	j	1068 <vprintfmt+0x7dc>
     8b8:	f8044783          	lbu	a5,-128(s0)
     8bc:	74078663          	beqz	a5,1008 <vprintfmt+0x77c>
     8c0:	f5043783          	ld	a5,-176(s0)
     8c4:	0007c783          	lbu	a5,0(a5)
     8c8:	00078713          	mv	a4,a5
     8cc:	02300793          	li	a5,35
     8d0:	00f71863          	bne	a4,a5,8e0 <vprintfmt+0x54>
     8d4:	00100793          	li	a5,1
     8d8:	f8f40123          	sb	a5,-126(s0)
     8dc:	7800006f          	j	105c <vprintfmt+0x7d0>
     8e0:	f5043783          	ld	a5,-176(s0)
     8e4:	0007c783          	lbu	a5,0(a5)
     8e8:	00078713          	mv	a4,a5
     8ec:	03000793          	li	a5,48
     8f0:	00f71863          	bne	a4,a5,900 <vprintfmt+0x74>
     8f4:	00100793          	li	a5,1
     8f8:	f8f401a3          	sb	a5,-125(s0)
     8fc:	7600006f          	j	105c <vprintfmt+0x7d0>
     900:	f5043783          	ld	a5,-176(s0)
     904:	0007c783          	lbu	a5,0(a5)
     908:	00078713          	mv	a4,a5
     90c:	06c00793          	li	a5,108
     910:	04f70063          	beq	a4,a5,950 <vprintfmt+0xc4>
     914:	f5043783          	ld	a5,-176(s0)
     918:	0007c783          	lbu	a5,0(a5)
     91c:	00078713          	mv	a4,a5
     920:	07a00793          	li	a5,122
     924:	02f70663          	beq	a4,a5,950 <vprintfmt+0xc4>
     928:	f5043783          	ld	a5,-176(s0)
     92c:	0007c783          	lbu	a5,0(a5)
     930:	00078713          	mv	a4,a5
     934:	07400793          	li	a5,116
     938:	00f70c63          	beq	a4,a5,950 <vprintfmt+0xc4>
     93c:	f5043783          	ld	a5,-176(s0)
     940:	0007c783          	lbu	a5,0(a5)
     944:	00078713          	mv	a4,a5
     948:	06a00793          	li	a5,106
     94c:	00f71863          	bne	a4,a5,95c <vprintfmt+0xd0>
     950:	00100793          	li	a5,1
     954:	f8f400a3          	sb	a5,-127(s0)
     958:	7040006f          	j	105c <vprintfmt+0x7d0>
     95c:	f5043783          	ld	a5,-176(s0)
     960:	0007c783          	lbu	a5,0(a5)
     964:	00078713          	mv	a4,a5
     968:	02b00793          	li	a5,43
     96c:	00f71863          	bne	a4,a5,97c <vprintfmt+0xf0>
     970:	00100793          	li	a5,1
     974:	f8f402a3          	sb	a5,-123(s0)
     978:	6e40006f          	j	105c <vprintfmt+0x7d0>
     97c:	f5043783          	ld	a5,-176(s0)
     980:	0007c783          	lbu	a5,0(a5)
     984:	00078713          	mv	a4,a5
     988:	02000793          	li	a5,32
     98c:	00f71863          	bne	a4,a5,99c <vprintfmt+0x110>
     990:	00100793          	li	a5,1
     994:	f8f40223          	sb	a5,-124(s0)
     998:	6c40006f          	j	105c <vprintfmt+0x7d0>
     99c:	f5043783          	ld	a5,-176(s0)
     9a0:	0007c783          	lbu	a5,0(a5)
     9a4:	00078713          	mv	a4,a5
     9a8:	02a00793          	li	a5,42
     9ac:	00f71e63          	bne	a4,a5,9c8 <vprintfmt+0x13c>
     9b0:	f4843783          	ld	a5,-184(s0)
     9b4:	00878713          	addi	a4,a5,8
     9b8:	f4e43423          	sd	a4,-184(s0)
     9bc:	0007a783          	lw	a5,0(a5)
     9c0:	f8f42423          	sw	a5,-120(s0)
     9c4:	6980006f          	j	105c <vprintfmt+0x7d0>
     9c8:	f5043783          	ld	a5,-176(s0)
     9cc:	0007c783          	lbu	a5,0(a5)
     9d0:	00078713          	mv	a4,a5
     9d4:	03000793          	li	a5,48
     9d8:	04e7f863          	bgeu	a5,a4,a28 <vprintfmt+0x19c>
     9dc:	f5043783          	ld	a5,-176(s0)
     9e0:	0007c783          	lbu	a5,0(a5)
     9e4:	00078713          	mv	a4,a5
     9e8:	03900793          	li	a5,57
     9ec:	02e7ee63          	bltu	a5,a4,a28 <vprintfmt+0x19c>
     9f0:	f5043783          	ld	a5,-176(s0)
     9f4:	f5040713          	addi	a4,s0,-176
     9f8:	00a00613          	li	a2,10
     9fc:	00070593          	mv	a1,a4
     a00:	00078513          	mv	a0,a5
     a04:	00000097          	auipc	ra,0x0
     a08:	884080e7          	jalr	-1916(ra) # 288 <strtol>
     a0c:	00050793          	mv	a5,a0
     a10:	0007879b          	sext.w	a5,a5
     a14:	f8f42423          	sw	a5,-120(s0)
     a18:	f5043783          	ld	a5,-176(s0)
     a1c:	fff78793          	addi	a5,a5,-1
     a20:	f4f43823          	sd	a5,-176(s0)
     a24:	6380006f          	j	105c <vprintfmt+0x7d0>
     a28:	f5043783          	ld	a5,-176(s0)
     a2c:	0007c783          	lbu	a5,0(a5)
     a30:	00078713          	mv	a4,a5
     a34:	02e00793          	li	a5,46
     a38:	06f71a63          	bne	a4,a5,aac <vprintfmt+0x220>
     a3c:	f5043783          	ld	a5,-176(s0)
     a40:	00178793          	addi	a5,a5,1
     a44:	f4f43823          	sd	a5,-176(s0)
     a48:	f5043783          	ld	a5,-176(s0)
     a4c:	0007c783          	lbu	a5,0(a5)
     a50:	00078713          	mv	a4,a5
     a54:	02a00793          	li	a5,42
     a58:	00f71e63          	bne	a4,a5,a74 <vprintfmt+0x1e8>
     a5c:	f4843783          	ld	a5,-184(s0)
     a60:	00878713          	addi	a4,a5,8
     a64:	f4e43423          	sd	a4,-184(s0)
     a68:	0007a783          	lw	a5,0(a5)
     a6c:	f8f42623          	sw	a5,-116(s0)
     a70:	5ec0006f          	j	105c <vprintfmt+0x7d0>
     a74:	f5043783          	ld	a5,-176(s0)
     a78:	f5040713          	addi	a4,s0,-176
     a7c:	00a00613          	li	a2,10
     a80:	00070593          	mv	a1,a4
     a84:	00078513          	mv	a0,a5
     a88:	00000097          	auipc	ra,0x0
     a8c:	800080e7          	jalr	-2048(ra) # 288 <strtol>
     a90:	00050793          	mv	a5,a0
     a94:	0007879b          	sext.w	a5,a5
     a98:	f8f42623          	sw	a5,-116(s0)
     a9c:	f5043783          	ld	a5,-176(s0)
     aa0:	fff78793          	addi	a5,a5,-1
     aa4:	f4f43823          	sd	a5,-176(s0)
     aa8:	5b40006f          	j	105c <vprintfmt+0x7d0>
     aac:	f5043783          	ld	a5,-176(s0)
     ab0:	0007c783          	lbu	a5,0(a5)
     ab4:	00078713          	mv	a4,a5
     ab8:	07800793          	li	a5,120
     abc:	02f70663          	beq	a4,a5,ae8 <vprintfmt+0x25c>
     ac0:	f5043783          	ld	a5,-176(s0)
     ac4:	0007c783          	lbu	a5,0(a5)
     ac8:	00078713          	mv	a4,a5
     acc:	05800793          	li	a5,88
     ad0:	00f70c63          	beq	a4,a5,ae8 <vprintfmt+0x25c>
     ad4:	f5043783          	ld	a5,-176(s0)
     ad8:	0007c783          	lbu	a5,0(a5)
     adc:	00078713          	mv	a4,a5
     ae0:	07000793          	li	a5,112
     ae4:	30f71263          	bne	a4,a5,de8 <vprintfmt+0x55c>
     ae8:	f5043783          	ld	a5,-176(s0)
     aec:	0007c783          	lbu	a5,0(a5)
     af0:	00078713          	mv	a4,a5
     af4:	07000793          	li	a5,112
     af8:	00f70663          	beq	a4,a5,b04 <vprintfmt+0x278>
     afc:	f8144783          	lbu	a5,-127(s0)
     b00:	00078663          	beqz	a5,b0c <vprintfmt+0x280>
     b04:	00100793          	li	a5,1
     b08:	0080006f          	j	b10 <vprintfmt+0x284>
     b0c:	00000793          	li	a5,0
     b10:	faf403a3          	sb	a5,-89(s0)
     b14:	fa744783          	lbu	a5,-89(s0)
     b18:	0017f793          	andi	a5,a5,1
     b1c:	faf403a3          	sb	a5,-89(s0)
     b20:	fa744783          	lbu	a5,-89(s0)
     b24:	0ff7f793          	zext.b	a5,a5
     b28:	00078c63          	beqz	a5,b40 <vprintfmt+0x2b4>
     b2c:	f4843783          	ld	a5,-184(s0)
     b30:	00878713          	addi	a4,a5,8
     b34:	f4e43423          	sd	a4,-184(s0)
     b38:	0007b783          	ld	a5,0(a5)
     b3c:	01c0006f          	j	b58 <vprintfmt+0x2cc>
     b40:	f4843783          	ld	a5,-184(s0)
     b44:	00878713          	addi	a4,a5,8
     b48:	f4e43423          	sd	a4,-184(s0)
     b4c:	0007a783          	lw	a5,0(a5)
     b50:	02079793          	slli	a5,a5,0x20
     b54:	0207d793          	srli	a5,a5,0x20
     b58:	fef43023          	sd	a5,-32(s0)
     b5c:	f8c42783          	lw	a5,-116(s0)
     b60:	02079463          	bnez	a5,b88 <vprintfmt+0x2fc>
     b64:	fe043783          	ld	a5,-32(s0)
     b68:	02079063          	bnez	a5,b88 <vprintfmt+0x2fc>
     b6c:	f5043783          	ld	a5,-176(s0)
     b70:	0007c783          	lbu	a5,0(a5)
     b74:	00078713          	mv	a4,a5
     b78:	07000793          	li	a5,112
     b7c:	00f70663          	beq	a4,a5,b88 <vprintfmt+0x2fc>
     b80:	f8040023          	sb	zero,-128(s0)
     b84:	4d80006f          	j	105c <vprintfmt+0x7d0>
     b88:	f5043783          	ld	a5,-176(s0)
     b8c:	0007c783          	lbu	a5,0(a5)
     b90:	00078713          	mv	a4,a5
     b94:	07000793          	li	a5,112
     b98:	00f70a63          	beq	a4,a5,bac <vprintfmt+0x320>
     b9c:	f8244783          	lbu	a5,-126(s0)
     ba0:	00078a63          	beqz	a5,bb4 <vprintfmt+0x328>
     ba4:	fe043783          	ld	a5,-32(s0)
     ba8:	00078663          	beqz	a5,bb4 <vprintfmt+0x328>
     bac:	00100793          	li	a5,1
     bb0:	0080006f          	j	bb8 <vprintfmt+0x32c>
     bb4:	00000793          	li	a5,0
     bb8:	faf40323          	sb	a5,-90(s0)
     bbc:	fa644783          	lbu	a5,-90(s0)
     bc0:	0017f793          	andi	a5,a5,1
     bc4:	faf40323          	sb	a5,-90(s0)
     bc8:	fc042e23          	sw	zero,-36(s0)
     bcc:	f5043783          	ld	a5,-176(s0)
     bd0:	0007c783          	lbu	a5,0(a5)
     bd4:	00078713          	mv	a4,a5
     bd8:	05800793          	li	a5,88
     bdc:	00f71863          	bne	a4,a5,bec <vprintfmt+0x360>
     be0:	00000797          	auipc	a5,0x0
     be4:	7c078793          	addi	a5,a5,1984 # 13a0 <upperxdigits.1>
     be8:	00c0006f          	j	bf4 <vprintfmt+0x368>
     bec:	00000797          	auipc	a5,0x0
     bf0:	7cc78793          	addi	a5,a5,1996 # 13b8 <lowerxdigits.0>
     bf4:	f8f43c23          	sd	a5,-104(s0)
     bf8:	fe043783          	ld	a5,-32(s0)
     bfc:	00f7f793          	andi	a5,a5,15
     c00:	f9843703          	ld	a4,-104(s0)
     c04:	00f70733          	add	a4,a4,a5
     c08:	fdc42783          	lw	a5,-36(s0)
     c0c:	0017869b          	addiw	a3,a5,1
     c10:	fcd42e23          	sw	a3,-36(s0)
     c14:	00074703          	lbu	a4,0(a4)
     c18:	ff078793          	addi	a5,a5,-16
     c1c:	008787b3          	add	a5,a5,s0
     c20:	f8e78023          	sb	a4,-128(a5)
     c24:	fe043783          	ld	a5,-32(s0)
     c28:	0047d793          	srli	a5,a5,0x4
     c2c:	fef43023          	sd	a5,-32(s0)
     c30:	fe043783          	ld	a5,-32(s0)
     c34:	fc0792e3          	bnez	a5,bf8 <vprintfmt+0x36c>
     c38:	f8c42783          	lw	a5,-116(s0)
     c3c:	00078713          	mv	a4,a5
     c40:	fff00793          	li	a5,-1
     c44:	02f71663          	bne	a4,a5,c70 <vprintfmt+0x3e4>
     c48:	f8344783          	lbu	a5,-125(s0)
     c4c:	02078263          	beqz	a5,c70 <vprintfmt+0x3e4>
     c50:	f8842703          	lw	a4,-120(s0)
     c54:	fa644783          	lbu	a5,-90(s0)
     c58:	0007879b          	sext.w	a5,a5
     c5c:	0017979b          	slliw	a5,a5,0x1
     c60:	0007879b          	sext.w	a5,a5
     c64:	40f707bb          	subw	a5,a4,a5
     c68:	0007879b          	sext.w	a5,a5
     c6c:	f8f42623          	sw	a5,-116(s0)
     c70:	f8842703          	lw	a4,-120(s0)
     c74:	fa644783          	lbu	a5,-90(s0)
     c78:	0007879b          	sext.w	a5,a5
     c7c:	0017979b          	slliw	a5,a5,0x1
     c80:	0007879b          	sext.w	a5,a5
     c84:	40f707bb          	subw	a5,a4,a5
     c88:	0007871b          	sext.w	a4,a5
     c8c:	fdc42783          	lw	a5,-36(s0)
     c90:	f8f42a23          	sw	a5,-108(s0)
     c94:	f8c42783          	lw	a5,-116(s0)
     c98:	f8f42823          	sw	a5,-112(s0)
     c9c:	f9442783          	lw	a5,-108(s0)
     ca0:	00078593          	mv	a1,a5
     ca4:	f9042783          	lw	a5,-112(s0)
     ca8:	00078613          	mv	a2,a5
     cac:	0006069b          	sext.w	a3,a2
     cb0:	0005879b          	sext.w	a5,a1
     cb4:	00f6d463          	bge	a3,a5,cbc <vprintfmt+0x430>
     cb8:	00058613          	mv	a2,a1
     cbc:	0006079b          	sext.w	a5,a2
     cc0:	40f707bb          	subw	a5,a4,a5
     cc4:	fcf42c23          	sw	a5,-40(s0)
     cc8:	0280006f          	j	cf0 <vprintfmt+0x464>
     ccc:	f5843783          	ld	a5,-168(s0)
     cd0:	02000513          	li	a0,32
     cd4:	000780e7          	jalr	a5
     cd8:	fec42783          	lw	a5,-20(s0)
     cdc:	0017879b          	addiw	a5,a5,1
     ce0:	fef42623          	sw	a5,-20(s0)
     ce4:	fd842783          	lw	a5,-40(s0)
     ce8:	fff7879b          	addiw	a5,a5,-1
     cec:	fcf42c23          	sw	a5,-40(s0)
     cf0:	fd842783          	lw	a5,-40(s0)
     cf4:	0007879b          	sext.w	a5,a5
     cf8:	fcf04ae3          	bgtz	a5,ccc <vprintfmt+0x440>
     cfc:	fa644783          	lbu	a5,-90(s0)
     d00:	0ff7f793          	zext.b	a5,a5
     d04:	04078463          	beqz	a5,d4c <vprintfmt+0x4c0>
     d08:	f5843783          	ld	a5,-168(s0)
     d0c:	03000513          	li	a0,48
     d10:	000780e7          	jalr	a5
     d14:	f5043783          	ld	a5,-176(s0)
     d18:	0007c783          	lbu	a5,0(a5)
     d1c:	00078713          	mv	a4,a5
     d20:	05800793          	li	a5,88
     d24:	00f71663          	bne	a4,a5,d30 <vprintfmt+0x4a4>
     d28:	05800793          	li	a5,88
     d2c:	0080006f          	j	d34 <vprintfmt+0x4a8>
     d30:	07800793          	li	a5,120
     d34:	f5843703          	ld	a4,-168(s0)
     d38:	00078513          	mv	a0,a5
     d3c:	000700e7          	jalr	a4
     d40:	fec42783          	lw	a5,-20(s0)
     d44:	0027879b          	addiw	a5,a5,2
     d48:	fef42623          	sw	a5,-20(s0)
     d4c:	fdc42783          	lw	a5,-36(s0)
     d50:	fcf42a23          	sw	a5,-44(s0)
     d54:	0280006f          	j	d7c <vprintfmt+0x4f0>
     d58:	f5843783          	ld	a5,-168(s0)
     d5c:	03000513          	li	a0,48
     d60:	000780e7          	jalr	a5
     d64:	fec42783          	lw	a5,-20(s0)
     d68:	0017879b          	addiw	a5,a5,1
     d6c:	fef42623          	sw	a5,-20(s0)
     d70:	fd442783          	lw	a5,-44(s0)
     d74:	0017879b          	addiw	a5,a5,1
     d78:	fcf42a23          	sw	a5,-44(s0)
     d7c:	f8c42703          	lw	a4,-116(s0)
     d80:	fd442783          	lw	a5,-44(s0)
     d84:	0007879b          	sext.w	a5,a5
     d88:	fce7c8e3          	blt	a5,a4,d58 <vprintfmt+0x4cc>
     d8c:	fdc42783          	lw	a5,-36(s0)
     d90:	fff7879b          	addiw	a5,a5,-1
     d94:	fcf42823          	sw	a5,-48(s0)
     d98:	03c0006f          	j	dd4 <vprintfmt+0x548>
     d9c:	fd042783          	lw	a5,-48(s0)
     da0:	ff078793          	addi	a5,a5,-16
     da4:	008787b3          	add	a5,a5,s0
     da8:	f807c783          	lbu	a5,-128(a5)
     dac:	0007871b          	sext.w	a4,a5
     db0:	f5843783          	ld	a5,-168(s0)
     db4:	00070513          	mv	a0,a4
     db8:	000780e7          	jalr	a5
     dbc:	fec42783          	lw	a5,-20(s0)
     dc0:	0017879b          	addiw	a5,a5,1
     dc4:	fef42623          	sw	a5,-20(s0)
     dc8:	fd042783          	lw	a5,-48(s0)
     dcc:	fff7879b          	addiw	a5,a5,-1
     dd0:	fcf42823          	sw	a5,-48(s0)
     dd4:	fd042783          	lw	a5,-48(s0)
     dd8:	0007879b          	sext.w	a5,a5
     ddc:	fc07d0e3          	bgez	a5,d9c <vprintfmt+0x510>
     de0:	f8040023          	sb	zero,-128(s0)
     de4:	2780006f          	j	105c <vprintfmt+0x7d0>
     de8:	f5043783          	ld	a5,-176(s0)
     dec:	0007c783          	lbu	a5,0(a5)
     df0:	00078713          	mv	a4,a5
     df4:	06400793          	li	a5,100
     df8:	02f70663          	beq	a4,a5,e24 <vprintfmt+0x598>
     dfc:	f5043783          	ld	a5,-176(s0)
     e00:	0007c783          	lbu	a5,0(a5)
     e04:	00078713          	mv	a4,a5
     e08:	06900793          	li	a5,105
     e0c:	00f70c63          	beq	a4,a5,e24 <vprintfmt+0x598>
     e10:	f5043783          	ld	a5,-176(s0)
     e14:	0007c783          	lbu	a5,0(a5)
     e18:	00078713          	mv	a4,a5
     e1c:	07500793          	li	a5,117
     e20:	08f71263          	bne	a4,a5,ea4 <vprintfmt+0x618>
     e24:	f8144783          	lbu	a5,-127(s0)
     e28:	00078c63          	beqz	a5,e40 <vprintfmt+0x5b4>
     e2c:	f4843783          	ld	a5,-184(s0)
     e30:	00878713          	addi	a4,a5,8
     e34:	f4e43423          	sd	a4,-184(s0)
     e38:	0007b783          	ld	a5,0(a5)
     e3c:	0140006f          	j	e50 <vprintfmt+0x5c4>
     e40:	f4843783          	ld	a5,-184(s0)
     e44:	00878713          	addi	a4,a5,8
     e48:	f4e43423          	sd	a4,-184(s0)
     e4c:	0007a783          	lw	a5,0(a5)
     e50:	faf43423          	sd	a5,-88(s0)
     e54:	fa843583          	ld	a1,-88(s0)
     e58:	f5043783          	ld	a5,-176(s0)
     e5c:	0007c783          	lbu	a5,0(a5)
     e60:	0007871b          	sext.w	a4,a5
     e64:	07500793          	li	a5,117
     e68:	40f707b3          	sub	a5,a4,a5
     e6c:	00f037b3          	snez	a5,a5
     e70:	0ff7f793          	zext.b	a5,a5
     e74:	f8040713          	addi	a4,s0,-128
     e78:	00070693          	mv	a3,a4
     e7c:	00078613          	mv	a2,a5
     e80:	f5843503          	ld	a0,-168(s0)
     e84:	fffff097          	auipc	ra,0xfffff
     e88:	6fc080e7          	jalr	1788(ra) # 580 <print_dec_int>
     e8c:	00050793          	mv	a5,a0
     e90:	fec42703          	lw	a4,-20(s0)
     e94:	00f707bb          	addw	a5,a4,a5
     e98:	fef42623          	sw	a5,-20(s0)
     e9c:	f8040023          	sb	zero,-128(s0)
     ea0:	1bc0006f          	j	105c <vprintfmt+0x7d0>
     ea4:	f5043783          	ld	a5,-176(s0)
     ea8:	0007c783          	lbu	a5,0(a5)
     eac:	00078713          	mv	a4,a5
     eb0:	06e00793          	li	a5,110
     eb4:	04f71c63          	bne	a4,a5,f0c <vprintfmt+0x680>
     eb8:	f8144783          	lbu	a5,-127(s0)
     ebc:	02078463          	beqz	a5,ee4 <vprintfmt+0x658>
     ec0:	f4843783          	ld	a5,-184(s0)
     ec4:	00878713          	addi	a4,a5,8
     ec8:	f4e43423          	sd	a4,-184(s0)
     ecc:	0007b783          	ld	a5,0(a5)
     ed0:	faf43823          	sd	a5,-80(s0)
     ed4:	fec42703          	lw	a4,-20(s0)
     ed8:	fb043783          	ld	a5,-80(s0)
     edc:	00e7b023          	sd	a4,0(a5)
     ee0:	0240006f          	j	f04 <vprintfmt+0x678>
     ee4:	f4843783          	ld	a5,-184(s0)
     ee8:	00878713          	addi	a4,a5,8
     eec:	f4e43423          	sd	a4,-184(s0)
     ef0:	0007b783          	ld	a5,0(a5)
     ef4:	faf43c23          	sd	a5,-72(s0)
     ef8:	fb843783          	ld	a5,-72(s0)
     efc:	fec42703          	lw	a4,-20(s0)
     f00:	00e7a023          	sw	a4,0(a5)
     f04:	f8040023          	sb	zero,-128(s0)
     f08:	1540006f          	j	105c <vprintfmt+0x7d0>
     f0c:	f5043783          	ld	a5,-176(s0)
     f10:	0007c783          	lbu	a5,0(a5)
     f14:	00078713          	mv	a4,a5
     f18:	07300793          	li	a5,115
     f1c:	04f71063          	bne	a4,a5,f5c <vprintfmt+0x6d0>
     f20:	f4843783          	ld	a5,-184(s0)
     f24:	00878713          	addi	a4,a5,8
     f28:	f4e43423          	sd	a4,-184(s0)
     f2c:	0007b783          	ld	a5,0(a5)
     f30:	fcf43023          	sd	a5,-64(s0)
     f34:	fc043583          	ld	a1,-64(s0)
     f38:	f5843503          	ld	a0,-168(s0)
     f3c:	fffff097          	auipc	ra,0xfffff
     f40:	5bc080e7          	jalr	1468(ra) # 4f8 <puts_wo_nl>
     f44:	00050793          	mv	a5,a0
     f48:	fec42703          	lw	a4,-20(s0)
     f4c:	00f707bb          	addw	a5,a4,a5
     f50:	fef42623          	sw	a5,-20(s0)
     f54:	f8040023          	sb	zero,-128(s0)
     f58:	1040006f          	j	105c <vprintfmt+0x7d0>
     f5c:	f5043783          	ld	a5,-176(s0)
     f60:	0007c783          	lbu	a5,0(a5)
     f64:	00078713          	mv	a4,a5
     f68:	06300793          	li	a5,99
     f6c:	02f71e63          	bne	a4,a5,fa8 <vprintfmt+0x71c>
     f70:	f4843783          	ld	a5,-184(s0)
     f74:	00878713          	addi	a4,a5,8
     f78:	f4e43423          	sd	a4,-184(s0)
     f7c:	0007a783          	lw	a5,0(a5)
     f80:	fcf42623          	sw	a5,-52(s0)
     f84:	fcc42703          	lw	a4,-52(s0)
     f88:	f5843783          	ld	a5,-168(s0)
     f8c:	00070513          	mv	a0,a4
     f90:	000780e7          	jalr	a5
     f94:	fec42783          	lw	a5,-20(s0)
     f98:	0017879b          	addiw	a5,a5,1
     f9c:	fef42623          	sw	a5,-20(s0)
     fa0:	f8040023          	sb	zero,-128(s0)
     fa4:	0b80006f          	j	105c <vprintfmt+0x7d0>
     fa8:	f5043783          	ld	a5,-176(s0)
     fac:	0007c783          	lbu	a5,0(a5)
     fb0:	00078713          	mv	a4,a5
     fb4:	02500793          	li	a5,37
     fb8:	02f71263          	bne	a4,a5,fdc <vprintfmt+0x750>
     fbc:	f5843783          	ld	a5,-168(s0)
     fc0:	02500513          	li	a0,37
     fc4:	000780e7          	jalr	a5
     fc8:	fec42783          	lw	a5,-20(s0)
     fcc:	0017879b          	addiw	a5,a5,1
     fd0:	fef42623          	sw	a5,-20(s0)
     fd4:	f8040023          	sb	zero,-128(s0)
     fd8:	0840006f          	j	105c <vprintfmt+0x7d0>
     fdc:	f5043783          	ld	a5,-176(s0)
     fe0:	0007c783          	lbu	a5,0(a5)
     fe4:	0007871b          	sext.w	a4,a5
     fe8:	f5843783          	ld	a5,-168(s0)
     fec:	00070513          	mv	a0,a4
     ff0:	000780e7          	jalr	a5
     ff4:	fec42783          	lw	a5,-20(s0)
     ff8:	0017879b          	addiw	a5,a5,1
     ffc:	fef42623          	sw	a5,-20(s0)
    1000:	f8040023          	sb	zero,-128(s0)
    1004:	0580006f          	j	105c <vprintfmt+0x7d0>
    1008:	f5043783          	ld	a5,-176(s0)
    100c:	0007c783          	lbu	a5,0(a5)
    1010:	00078713          	mv	a4,a5
    1014:	02500793          	li	a5,37
    1018:	02f71063          	bne	a4,a5,1038 <vprintfmt+0x7ac>
    101c:	f8043023          	sd	zero,-128(s0)
    1020:	f8043423          	sd	zero,-120(s0)
    1024:	00100793          	li	a5,1
    1028:	f8f40023          	sb	a5,-128(s0)
    102c:	fff00793          	li	a5,-1
    1030:	f8f42623          	sw	a5,-116(s0)
    1034:	0280006f          	j	105c <vprintfmt+0x7d0>
    1038:	f5043783          	ld	a5,-176(s0)
    103c:	0007c783          	lbu	a5,0(a5)
    1040:	0007871b          	sext.w	a4,a5
    1044:	f5843783          	ld	a5,-168(s0)
    1048:	00070513          	mv	a0,a4
    104c:	000780e7          	jalr	a5
    1050:	fec42783          	lw	a5,-20(s0)
    1054:	0017879b          	addiw	a5,a5,1
    1058:	fef42623          	sw	a5,-20(s0)
    105c:	f5043783          	ld	a5,-176(s0)
    1060:	00178793          	addi	a5,a5,1
    1064:	f4f43823          	sd	a5,-176(s0)
    1068:	f5043783          	ld	a5,-176(s0)
    106c:	0007c783          	lbu	a5,0(a5)
    1070:	840794e3          	bnez	a5,8b8 <vprintfmt+0x2c>
    1074:	fec42783          	lw	a5,-20(s0)
    1078:	00078513          	mv	a0,a5
    107c:	0b813083          	ld	ra,184(sp)
    1080:	0b013403          	ld	s0,176(sp)
    1084:	0c010113          	addi	sp,sp,192
    1088:	00008067          	ret

Disassembly of section .text.printf:

000000000000108c <printf>:
    108c:	f8010113          	addi	sp,sp,-128
    1090:	02113c23          	sd	ra,56(sp)
    1094:	02813823          	sd	s0,48(sp)
    1098:	04010413          	addi	s0,sp,64
    109c:	fca43423          	sd	a0,-56(s0)
    10a0:	00b43423          	sd	a1,8(s0)
    10a4:	00c43823          	sd	a2,16(s0)
    10a8:	00d43c23          	sd	a3,24(s0)
    10ac:	02e43023          	sd	a4,32(s0)
    10b0:	02f43423          	sd	a5,40(s0)
    10b4:	03043823          	sd	a6,48(s0)
    10b8:	03143c23          	sd	a7,56(s0)
    10bc:	fe042623          	sw	zero,-20(s0)
    10c0:	04040793          	addi	a5,s0,64
    10c4:	fcf43023          	sd	a5,-64(s0)
    10c8:	fc043783          	ld	a5,-64(s0)
    10cc:	fc878793          	addi	a5,a5,-56
    10d0:	fcf43823          	sd	a5,-48(s0)
    10d4:	fd043783          	ld	a5,-48(s0)
    10d8:	00078613          	mv	a2,a5
    10dc:	fc843583          	ld	a1,-56(s0)
    10e0:	fffff517          	auipc	a0,0xfffff
    10e4:	0e050513          	addi	a0,a0,224 # 1c0 <putc>
    10e8:	fffff097          	auipc	ra,0xfffff
    10ec:	7a4080e7          	jalr	1956(ra) # 88c <vprintfmt>
    10f0:	00050793          	mv	a5,a0
    10f4:	fef42623          	sw	a5,-20(s0)
    10f8:	00100793          	li	a5,1
    10fc:	fef43023          	sd	a5,-32(s0)
    1100:	00000797          	auipc	a5,0x0
    1104:	2d078793          	addi	a5,a5,720 # 13d0 <tail>
    1108:	0007a783          	lw	a5,0(a5)
    110c:	0017871b          	addiw	a4,a5,1
    1110:	0007069b          	sext.w	a3,a4
    1114:	00000717          	auipc	a4,0x0
    1118:	2bc70713          	addi	a4,a4,700 # 13d0 <tail>
    111c:	00d72023          	sw	a3,0(a4)
    1120:	00000717          	auipc	a4,0x0
    1124:	2b870713          	addi	a4,a4,696 # 13d8 <buffer>
    1128:	00f707b3          	add	a5,a4,a5
    112c:	00078023          	sb	zero,0(a5)
    1130:	00000797          	auipc	a5,0x0
    1134:	2a078793          	addi	a5,a5,672 # 13d0 <tail>
    1138:	0007a603          	lw	a2,0(a5)
    113c:	fe043703          	ld	a4,-32(s0)
    1140:	00000697          	auipc	a3,0x0
    1144:	29868693          	addi	a3,a3,664 # 13d8 <buffer>
    1148:	fd843783          	ld	a5,-40(s0)
    114c:	04000893          	li	a7,64
    1150:	00070513          	mv	a0,a4
    1154:	00068593          	mv	a1,a3
    1158:	00060613          	mv	a2,a2
    115c:	00000073          	ecall
    1160:	00050793          	mv	a5,a0
    1164:	fcf43c23          	sd	a5,-40(s0)
    1168:	00000797          	auipc	a5,0x0
    116c:	26878793          	addi	a5,a5,616 # 13d0 <tail>
    1170:	0007a023          	sw	zero,0(a5)
    1174:	fec42783          	lw	a5,-20(s0)
    1178:	00078513          	mv	a0,a5
    117c:	03813083          	ld	ra,56(sp)
    1180:	03013403          	ld	s0,48(sp)
    1184:	08010113          	addi	sp,sp,128
    1188:	00008067          	ret
