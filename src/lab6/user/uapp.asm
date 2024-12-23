
uapp:     file format elf64-littleriscv


Disassembly of section .text:

00000000000100e8 <_start>:
   100e8:	0c00006f          	j	101a8 <main>

00000000000100ec <getpid>:
   100ec:	fe010113          	addi	sp,sp,-32
   100f0:	00813c23          	sd	s0,24(sp)
   100f4:	02010413          	addi	s0,sp,32
   100f8:	fe843783          	ld	a5,-24(s0)
   100fc:	0ac00893          	li	a7,172
   10100:	00000073          	ecall
   10104:	00050793          	mv	a5,a0
   10108:	fef43423          	sd	a5,-24(s0)
   1010c:	fe843783          	ld	a5,-24(s0)
   10110:	00078513          	mv	a0,a5
   10114:	01813403          	ld	s0,24(sp)
   10118:	02010113          	addi	sp,sp,32
   1011c:	00008067          	ret

0000000000010120 <fork>:
   10120:	fe010113          	addi	sp,sp,-32
   10124:	00813c23          	sd	s0,24(sp)
   10128:	02010413          	addi	s0,sp,32
   1012c:	fe843783          	ld	a5,-24(s0)
   10130:	0dc00893          	li	a7,220
   10134:	00000073          	ecall
   10138:	00050793          	mv	a5,a0
   1013c:	fef43423          	sd	a5,-24(s0)
   10140:	fe843783          	ld	a5,-24(s0)
   10144:	00078513          	mv	a0,a5
   10148:	01813403          	ld	s0,24(sp)
   1014c:	02010113          	addi	sp,sp,32
   10150:	00008067          	ret

0000000000010154 <wait>:
   10154:	fd010113          	addi	sp,sp,-48
   10158:	02813423          	sd	s0,40(sp)
   1015c:	03010413          	addi	s0,sp,48
   10160:	00050793          	mv	a5,a0
   10164:	fcf42e23          	sw	a5,-36(s0)
   10168:	fe042623          	sw	zero,-20(s0)
   1016c:	0100006f          	j	1017c <wait+0x28>
   10170:	fec42783          	lw	a5,-20(s0)
   10174:	0017879b          	addiw	a5,a5,1
   10178:	fef42623          	sw	a5,-20(s0)
   1017c:	fec42783          	lw	a5,-20(s0)
   10180:	00078713          	mv	a4,a5
   10184:	fdc42783          	lw	a5,-36(s0)
   10188:	0007071b          	sext.w	a4,a4
   1018c:	0007879b          	sext.w	a5,a5
   10190:	fef760e3          	bltu	a4,a5,10170 <wait+0x1c>
   10194:	00000013          	nop
   10198:	00000013          	nop
   1019c:	02813403          	ld	s0,40(sp)
   101a0:	03010113          	addi	sp,sp,48
   101a4:	00008067          	ret

00000000000101a8 <main>:
   101a8:	ff010113          	addi	sp,sp,-16
   101ac:	00113423          	sd	ra,8(sp)
   101b0:	00813023          	sd	s0,0(sp)
   101b4:	01010413          	addi	s0,sp,16
   101b8:	00000097          	auipc	ra,0x0
   101bc:	f34080e7          	jalr	-204(ra) # 100ec <getpid>
   101c0:	00050593          	mv	a1,a0
   101c4:	00002797          	auipc	a5,0x2
   101c8:	e3c78793          	addi	a5,a5,-452 # 12000 <global_variable>
   101cc:	0007a783          	lw	a5,0(a5)
   101d0:	0017871b          	addiw	a4,a5,1
   101d4:	0007069b          	sext.w	a3,a4
   101d8:	00002717          	auipc	a4,0x2
   101dc:	e2870713          	addi	a4,a4,-472 # 12000 <global_variable>
   101e0:	00d72023          	sw	a3,0(a4)
   101e4:	00078613          	mv	a2,a5
   101e8:	00001517          	auipc	a0,0x1
   101ec:	09050513          	addi	a0,a0,144 # 11278 <printf+0x104>
   101f0:	00001097          	auipc	ra,0x1
   101f4:	f84080e7          	jalr	-124(ra) # 11174 <printf>
   101f8:	00000097          	auipc	ra,0x0
   101fc:	f28080e7          	jalr	-216(ra) # 10120 <fork>
   10200:	00000097          	auipc	ra,0x0
   10204:	f20080e7          	jalr	-224(ra) # 10120 <fork>
   10208:	00000097          	auipc	ra,0x0
   1020c:	ee4080e7          	jalr	-284(ra) # 100ec <getpid>
   10210:	00050593          	mv	a1,a0
   10214:	00002797          	auipc	a5,0x2
   10218:	dec78793          	addi	a5,a5,-532 # 12000 <global_variable>
   1021c:	0007a783          	lw	a5,0(a5)
   10220:	0017871b          	addiw	a4,a5,1
   10224:	0007069b          	sext.w	a3,a4
   10228:	00002717          	auipc	a4,0x2
   1022c:	dd870713          	addi	a4,a4,-552 # 12000 <global_variable>
   10230:	00d72023          	sw	a3,0(a4)
   10234:	00078613          	mv	a2,a5
   10238:	00001517          	auipc	a0,0x1
   1023c:	04050513          	addi	a0,a0,64 # 11278 <printf+0x104>
   10240:	00001097          	auipc	ra,0x1
   10244:	f34080e7          	jalr	-204(ra) # 11174 <printf>
   10248:	00000097          	auipc	ra,0x0
   1024c:	ed8080e7          	jalr	-296(ra) # 10120 <fork>
   10250:	00000097          	auipc	ra,0x0
   10254:	e9c080e7          	jalr	-356(ra) # 100ec <getpid>
   10258:	00050593          	mv	a1,a0
   1025c:	00002797          	auipc	a5,0x2
   10260:	da478793          	addi	a5,a5,-604 # 12000 <global_variable>
   10264:	0007a783          	lw	a5,0(a5)
   10268:	0017871b          	addiw	a4,a5,1
   1026c:	0007069b          	sext.w	a3,a4
   10270:	00002717          	auipc	a4,0x2
   10274:	d9070713          	addi	a4,a4,-624 # 12000 <global_variable>
   10278:	00d72023          	sw	a3,0(a4)
   1027c:	00078613          	mv	a2,a5
   10280:	00001517          	auipc	a0,0x1
   10284:	ff850513          	addi	a0,a0,-8 # 11278 <printf+0x104>
   10288:	00001097          	auipc	ra,0x1
   1028c:	eec080e7          	jalr	-276(ra) # 11174 <printf>
   10290:	500007b7          	lui	a5,0x50000
   10294:	fff78513          	addi	a0,a5,-1 # 4fffffff <__global_pointer$+0x4ffed7ff>
   10298:	00000097          	auipc	ra,0x0
   1029c:	ebc080e7          	jalr	-324(ra) # 10154 <wait>
   102a0:	00000013          	nop
   102a4:	fadff06f          	j	10250 <main+0xa8>

00000000000102a8 <putc>:
   102a8:	fe010113          	addi	sp,sp,-32
   102ac:	00813c23          	sd	s0,24(sp)
   102b0:	02010413          	addi	s0,sp,32
   102b4:	00050793          	mv	a5,a0
   102b8:	fef42623          	sw	a5,-20(s0)
   102bc:	00002797          	auipc	a5,0x2
   102c0:	d4878793          	addi	a5,a5,-696 # 12004 <tail>
   102c4:	0007a783          	lw	a5,0(a5)
   102c8:	0017871b          	addiw	a4,a5,1
   102cc:	0007069b          	sext.w	a3,a4
   102d0:	00002717          	auipc	a4,0x2
   102d4:	d3470713          	addi	a4,a4,-716 # 12004 <tail>
   102d8:	00d72023          	sw	a3,0(a4)
   102dc:	fec42703          	lw	a4,-20(s0)
   102e0:	0ff77713          	zext.b	a4,a4
   102e4:	00002697          	auipc	a3,0x2
   102e8:	d2468693          	addi	a3,a3,-732 # 12008 <buffer>
   102ec:	00f687b3          	add	a5,a3,a5
   102f0:	00e78023          	sb	a4,0(a5)
   102f4:	fec42783          	lw	a5,-20(s0)
   102f8:	0ff7f793          	zext.b	a5,a5
   102fc:	0007879b          	sext.w	a5,a5
   10300:	00078513          	mv	a0,a5
   10304:	01813403          	ld	s0,24(sp)
   10308:	02010113          	addi	sp,sp,32
   1030c:	00008067          	ret

0000000000010310 <isspace>:
   10310:	fe010113          	addi	sp,sp,-32
   10314:	00813c23          	sd	s0,24(sp)
   10318:	02010413          	addi	s0,sp,32
   1031c:	00050793          	mv	a5,a0
   10320:	fef42623          	sw	a5,-20(s0)
   10324:	fec42783          	lw	a5,-20(s0)
   10328:	0007871b          	sext.w	a4,a5
   1032c:	02000793          	li	a5,32
   10330:	02f70263          	beq	a4,a5,10354 <isspace+0x44>
   10334:	fec42783          	lw	a5,-20(s0)
   10338:	0007871b          	sext.w	a4,a5
   1033c:	00800793          	li	a5,8
   10340:	00e7de63          	bge	a5,a4,1035c <isspace+0x4c>
   10344:	fec42783          	lw	a5,-20(s0)
   10348:	0007871b          	sext.w	a4,a5
   1034c:	00d00793          	li	a5,13
   10350:	00e7c663          	blt	a5,a4,1035c <isspace+0x4c>
   10354:	00100793          	li	a5,1
   10358:	0080006f          	j	10360 <isspace+0x50>
   1035c:	00000793          	li	a5,0
   10360:	00078513          	mv	a0,a5
   10364:	01813403          	ld	s0,24(sp)
   10368:	02010113          	addi	sp,sp,32
   1036c:	00008067          	ret

0000000000010370 <strtol>:
   10370:	fb010113          	addi	sp,sp,-80
   10374:	04113423          	sd	ra,72(sp)
   10378:	04813023          	sd	s0,64(sp)
   1037c:	05010413          	addi	s0,sp,80
   10380:	fca43423          	sd	a0,-56(s0)
   10384:	fcb43023          	sd	a1,-64(s0)
   10388:	00060793          	mv	a5,a2
   1038c:	faf42e23          	sw	a5,-68(s0)
   10390:	fe043423          	sd	zero,-24(s0)
   10394:	fe0403a3          	sb	zero,-25(s0)
   10398:	fc843783          	ld	a5,-56(s0)
   1039c:	fcf43c23          	sd	a5,-40(s0)
   103a0:	0100006f          	j	103b0 <strtol+0x40>
   103a4:	fd843783          	ld	a5,-40(s0)
   103a8:	00178793          	addi	a5,a5,1
   103ac:	fcf43c23          	sd	a5,-40(s0)
   103b0:	fd843783          	ld	a5,-40(s0)
   103b4:	0007c783          	lbu	a5,0(a5)
   103b8:	0007879b          	sext.w	a5,a5
   103bc:	00078513          	mv	a0,a5
   103c0:	00000097          	auipc	ra,0x0
   103c4:	f50080e7          	jalr	-176(ra) # 10310 <isspace>
   103c8:	00050793          	mv	a5,a0
   103cc:	fc079ce3          	bnez	a5,103a4 <strtol+0x34>
   103d0:	fd843783          	ld	a5,-40(s0)
   103d4:	0007c783          	lbu	a5,0(a5)
   103d8:	00078713          	mv	a4,a5
   103dc:	02d00793          	li	a5,45
   103e0:	00f71e63          	bne	a4,a5,103fc <strtol+0x8c>
   103e4:	00100793          	li	a5,1
   103e8:	fef403a3          	sb	a5,-25(s0)
   103ec:	fd843783          	ld	a5,-40(s0)
   103f0:	00178793          	addi	a5,a5,1
   103f4:	fcf43c23          	sd	a5,-40(s0)
   103f8:	0240006f          	j	1041c <strtol+0xac>
   103fc:	fd843783          	ld	a5,-40(s0)
   10400:	0007c783          	lbu	a5,0(a5)
   10404:	00078713          	mv	a4,a5
   10408:	02b00793          	li	a5,43
   1040c:	00f71863          	bne	a4,a5,1041c <strtol+0xac>
   10410:	fd843783          	ld	a5,-40(s0)
   10414:	00178793          	addi	a5,a5,1
   10418:	fcf43c23          	sd	a5,-40(s0)
   1041c:	fbc42783          	lw	a5,-68(s0)
   10420:	0007879b          	sext.w	a5,a5
   10424:	06079c63          	bnez	a5,1049c <strtol+0x12c>
   10428:	fd843783          	ld	a5,-40(s0)
   1042c:	0007c783          	lbu	a5,0(a5)
   10430:	00078713          	mv	a4,a5
   10434:	03000793          	li	a5,48
   10438:	04f71e63          	bne	a4,a5,10494 <strtol+0x124>
   1043c:	fd843783          	ld	a5,-40(s0)
   10440:	00178793          	addi	a5,a5,1
   10444:	fcf43c23          	sd	a5,-40(s0)
   10448:	fd843783          	ld	a5,-40(s0)
   1044c:	0007c783          	lbu	a5,0(a5)
   10450:	00078713          	mv	a4,a5
   10454:	07800793          	li	a5,120
   10458:	00f70c63          	beq	a4,a5,10470 <strtol+0x100>
   1045c:	fd843783          	ld	a5,-40(s0)
   10460:	0007c783          	lbu	a5,0(a5)
   10464:	00078713          	mv	a4,a5
   10468:	05800793          	li	a5,88
   1046c:	00f71e63          	bne	a4,a5,10488 <strtol+0x118>
   10470:	01000793          	li	a5,16
   10474:	faf42e23          	sw	a5,-68(s0)
   10478:	fd843783          	ld	a5,-40(s0)
   1047c:	00178793          	addi	a5,a5,1
   10480:	fcf43c23          	sd	a5,-40(s0)
   10484:	0180006f          	j	1049c <strtol+0x12c>
   10488:	00800793          	li	a5,8
   1048c:	faf42e23          	sw	a5,-68(s0)
   10490:	00c0006f          	j	1049c <strtol+0x12c>
   10494:	00a00793          	li	a5,10
   10498:	faf42e23          	sw	a5,-68(s0)
   1049c:	fd843783          	ld	a5,-40(s0)
   104a0:	0007c783          	lbu	a5,0(a5)
   104a4:	00078713          	mv	a4,a5
   104a8:	02f00793          	li	a5,47
   104ac:	02e7f863          	bgeu	a5,a4,104dc <strtol+0x16c>
   104b0:	fd843783          	ld	a5,-40(s0)
   104b4:	0007c783          	lbu	a5,0(a5)
   104b8:	00078713          	mv	a4,a5
   104bc:	03900793          	li	a5,57
   104c0:	00e7ee63          	bltu	a5,a4,104dc <strtol+0x16c>
   104c4:	fd843783          	ld	a5,-40(s0)
   104c8:	0007c783          	lbu	a5,0(a5)
   104cc:	0007879b          	sext.w	a5,a5
   104d0:	fd07879b          	addiw	a5,a5,-48
   104d4:	fcf42a23          	sw	a5,-44(s0)
   104d8:	0800006f          	j	10558 <strtol+0x1e8>
   104dc:	fd843783          	ld	a5,-40(s0)
   104e0:	0007c783          	lbu	a5,0(a5)
   104e4:	00078713          	mv	a4,a5
   104e8:	06000793          	li	a5,96
   104ec:	02e7f863          	bgeu	a5,a4,1051c <strtol+0x1ac>
   104f0:	fd843783          	ld	a5,-40(s0)
   104f4:	0007c783          	lbu	a5,0(a5)
   104f8:	00078713          	mv	a4,a5
   104fc:	07a00793          	li	a5,122
   10500:	00e7ee63          	bltu	a5,a4,1051c <strtol+0x1ac>
   10504:	fd843783          	ld	a5,-40(s0)
   10508:	0007c783          	lbu	a5,0(a5)
   1050c:	0007879b          	sext.w	a5,a5
   10510:	fa97879b          	addiw	a5,a5,-87
   10514:	fcf42a23          	sw	a5,-44(s0)
   10518:	0400006f          	j	10558 <strtol+0x1e8>
   1051c:	fd843783          	ld	a5,-40(s0)
   10520:	0007c783          	lbu	a5,0(a5)
   10524:	00078713          	mv	a4,a5
   10528:	04000793          	li	a5,64
   1052c:	06e7f863          	bgeu	a5,a4,1059c <strtol+0x22c>
   10530:	fd843783          	ld	a5,-40(s0)
   10534:	0007c783          	lbu	a5,0(a5)
   10538:	00078713          	mv	a4,a5
   1053c:	05a00793          	li	a5,90
   10540:	04e7ee63          	bltu	a5,a4,1059c <strtol+0x22c>
   10544:	fd843783          	ld	a5,-40(s0)
   10548:	0007c783          	lbu	a5,0(a5)
   1054c:	0007879b          	sext.w	a5,a5
   10550:	fc97879b          	addiw	a5,a5,-55
   10554:	fcf42a23          	sw	a5,-44(s0)
   10558:	fd442783          	lw	a5,-44(s0)
   1055c:	00078713          	mv	a4,a5
   10560:	fbc42783          	lw	a5,-68(s0)
   10564:	0007071b          	sext.w	a4,a4
   10568:	0007879b          	sext.w	a5,a5
   1056c:	02f75663          	bge	a4,a5,10598 <strtol+0x228>
   10570:	fbc42703          	lw	a4,-68(s0)
   10574:	fe843783          	ld	a5,-24(s0)
   10578:	02f70733          	mul	a4,a4,a5
   1057c:	fd442783          	lw	a5,-44(s0)
   10580:	00f707b3          	add	a5,a4,a5
   10584:	fef43423          	sd	a5,-24(s0)
   10588:	fd843783          	ld	a5,-40(s0)
   1058c:	00178793          	addi	a5,a5,1
   10590:	fcf43c23          	sd	a5,-40(s0)
   10594:	f09ff06f          	j	1049c <strtol+0x12c>
   10598:	00000013          	nop
   1059c:	fc043783          	ld	a5,-64(s0)
   105a0:	00078863          	beqz	a5,105b0 <strtol+0x240>
   105a4:	fc043783          	ld	a5,-64(s0)
   105a8:	fd843703          	ld	a4,-40(s0)
   105ac:	00e7b023          	sd	a4,0(a5)
   105b0:	fe744783          	lbu	a5,-25(s0)
   105b4:	0ff7f793          	zext.b	a5,a5
   105b8:	00078863          	beqz	a5,105c8 <strtol+0x258>
   105bc:	fe843783          	ld	a5,-24(s0)
   105c0:	40f007b3          	neg	a5,a5
   105c4:	0080006f          	j	105cc <strtol+0x25c>
   105c8:	fe843783          	ld	a5,-24(s0)
   105cc:	00078513          	mv	a0,a5
   105d0:	04813083          	ld	ra,72(sp)
   105d4:	04013403          	ld	s0,64(sp)
   105d8:	05010113          	addi	sp,sp,80
   105dc:	00008067          	ret

00000000000105e0 <puts_wo_nl>:
   105e0:	fd010113          	addi	sp,sp,-48
   105e4:	02113423          	sd	ra,40(sp)
   105e8:	02813023          	sd	s0,32(sp)
   105ec:	03010413          	addi	s0,sp,48
   105f0:	fca43c23          	sd	a0,-40(s0)
   105f4:	fcb43823          	sd	a1,-48(s0)
   105f8:	fd043783          	ld	a5,-48(s0)
   105fc:	00079863          	bnez	a5,1060c <puts_wo_nl+0x2c>
   10600:	00001797          	auipc	a5,0x1
   10604:	ca878793          	addi	a5,a5,-856 # 112a8 <printf+0x134>
   10608:	fcf43823          	sd	a5,-48(s0)
   1060c:	fd043783          	ld	a5,-48(s0)
   10610:	fef43423          	sd	a5,-24(s0)
   10614:	0240006f          	j	10638 <puts_wo_nl+0x58>
   10618:	fe843783          	ld	a5,-24(s0)
   1061c:	00178713          	addi	a4,a5,1
   10620:	fee43423          	sd	a4,-24(s0)
   10624:	0007c783          	lbu	a5,0(a5)
   10628:	0007871b          	sext.w	a4,a5
   1062c:	fd843783          	ld	a5,-40(s0)
   10630:	00070513          	mv	a0,a4
   10634:	000780e7          	jalr	a5
   10638:	fe843783          	ld	a5,-24(s0)
   1063c:	0007c783          	lbu	a5,0(a5)
   10640:	fc079ce3          	bnez	a5,10618 <puts_wo_nl+0x38>
   10644:	fe843703          	ld	a4,-24(s0)
   10648:	fd043783          	ld	a5,-48(s0)
   1064c:	40f707b3          	sub	a5,a4,a5
   10650:	0007879b          	sext.w	a5,a5
   10654:	00078513          	mv	a0,a5
   10658:	02813083          	ld	ra,40(sp)
   1065c:	02013403          	ld	s0,32(sp)
   10660:	03010113          	addi	sp,sp,48
   10664:	00008067          	ret

0000000000010668 <print_dec_int>:
   10668:	f9010113          	addi	sp,sp,-112
   1066c:	06113423          	sd	ra,104(sp)
   10670:	06813023          	sd	s0,96(sp)
   10674:	07010413          	addi	s0,sp,112
   10678:	faa43423          	sd	a0,-88(s0)
   1067c:	fab43023          	sd	a1,-96(s0)
   10680:	00060793          	mv	a5,a2
   10684:	f8d43823          	sd	a3,-112(s0)
   10688:	f8f40fa3          	sb	a5,-97(s0)
   1068c:	f9f44783          	lbu	a5,-97(s0)
   10690:	0ff7f793          	zext.b	a5,a5
   10694:	02078863          	beqz	a5,106c4 <print_dec_int+0x5c>
   10698:	fa043703          	ld	a4,-96(s0)
   1069c:	fff00793          	li	a5,-1
   106a0:	03f79793          	slli	a5,a5,0x3f
   106a4:	02f71063          	bne	a4,a5,106c4 <print_dec_int+0x5c>
   106a8:	00001597          	auipc	a1,0x1
   106ac:	c0858593          	addi	a1,a1,-1016 # 112b0 <printf+0x13c>
   106b0:	fa843503          	ld	a0,-88(s0)
   106b4:	00000097          	auipc	ra,0x0
   106b8:	f2c080e7          	jalr	-212(ra) # 105e0 <puts_wo_nl>
   106bc:	00050793          	mv	a5,a0
   106c0:	2a00006f          	j	10960 <print_dec_int+0x2f8>
   106c4:	f9043783          	ld	a5,-112(s0)
   106c8:	00c7a783          	lw	a5,12(a5)
   106cc:	00079a63          	bnez	a5,106e0 <print_dec_int+0x78>
   106d0:	fa043783          	ld	a5,-96(s0)
   106d4:	00079663          	bnez	a5,106e0 <print_dec_int+0x78>
   106d8:	00000793          	li	a5,0
   106dc:	2840006f          	j	10960 <print_dec_int+0x2f8>
   106e0:	fe0407a3          	sb	zero,-17(s0)
   106e4:	f9f44783          	lbu	a5,-97(s0)
   106e8:	0ff7f793          	zext.b	a5,a5
   106ec:	02078063          	beqz	a5,1070c <print_dec_int+0xa4>
   106f0:	fa043783          	ld	a5,-96(s0)
   106f4:	0007dc63          	bgez	a5,1070c <print_dec_int+0xa4>
   106f8:	00100793          	li	a5,1
   106fc:	fef407a3          	sb	a5,-17(s0)
   10700:	fa043783          	ld	a5,-96(s0)
   10704:	40f007b3          	neg	a5,a5
   10708:	faf43023          	sd	a5,-96(s0)
   1070c:	fe042423          	sw	zero,-24(s0)
   10710:	f9f44783          	lbu	a5,-97(s0)
   10714:	0ff7f793          	zext.b	a5,a5
   10718:	02078863          	beqz	a5,10748 <print_dec_int+0xe0>
   1071c:	fef44783          	lbu	a5,-17(s0)
   10720:	0ff7f793          	zext.b	a5,a5
   10724:	00079e63          	bnez	a5,10740 <print_dec_int+0xd8>
   10728:	f9043783          	ld	a5,-112(s0)
   1072c:	0057c783          	lbu	a5,5(a5)
   10730:	00079863          	bnez	a5,10740 <print_dec_int+0xd8>
   10734:	f9043783          	ld	a5,-112(s0)
   10738:	0047c783          	lbu	a5,4(a5)
   1073c:	00078663          	beqz	a5,10748 <print_dec_int+0xe0>
   10740:	00100793          	li	a5,1
   10744:	0080006f          	j	1074c <print_dec_int+0xe4>
   10748:	00000793          	li	a5,0
   1074c:	fcf40ba3          	sb	a5,-41(s0)
   10750:	fd744783          	lbu	a5,-41(s0)
   10754:	0017f793          	andi	a5,a5,1
   10758:	fcf40ba3          	sb	a5,-41(s0)
   1075c:	fa043703          	ld	a4,-96(s0)
   10760:	00a00793          	li	a5,10
   10764:	02f777b3          	remu	a5,a4,a5
   10768:	0ff7f713          	zext.b	a4,a5
   1076c:	fe842783          	lw	a5,-24(s0)
   10770:	0017869b          	addiw	a3,a5,1
   10774:	fed42423          	sw	a3,-24(s0)
   10778:	0307071b          	addiw	a4,a4,48
   1077c:	0ff77713          	zext.b	a4,a4
   10780:	ff078793          	addi	a5,a5,-16
   10784:	008787b3          	add	a5,a5,s0
   10788:	fce78423          	sb	a4,-56(a5)
   1078c:	fa043703          	ld	a4,-96(s0)
   10790:	00a00793          	li	a5,10
   10794:	02f757b3          	divu	a5,a4,a5
   10798:	faf43023          	sd	a5,-96(s0)
   1079c:	fa043783          	ld	a5,-96(s0)
   107a0:	fa079ee3          	bnez	a5,1075c <print_dec_int+0xf4>
   107a4:	f9043783          	ld	a5,-112(s0)
   107a8:	00c7a783          	lw	a5,12(a5)
   107ac:	00078713          	mv	a4,a5
   107b0:	fff00793          	li	a5,-1
   107b4:	02f71063          	bne	a4,a5,107d4 <print_dec_int+0x16c>
   107b8:	f9043783          	ld	a5,-112(s0)
   107bc:	0037c783          	lbu	a5,3(a5)
   107c0:	00078a63          	beqz	a5,107d4 <print_dec_int+0x16c>
   107c4:	f9043783          	ld	a5,-112(s0)
   107c8:	0087a703          	lw	a4,8(a5)
   107cc:	f9043783          	ld	a5,-112(s0)
   107d0:	00e7a623          	sw	a4,12(a5)
   107d4:	fe042223          	sw	zero,-28(s0)
   107d8:	f9043783          	ld	a5,-112(s0)
   107dc:	0087a703          	lw	a4,8(a5)
   107e0:	fe842783          	lw	a5,-24(s0)
   107e4:	fcf42823          	sw	a5,-48(s0)
   107e8:	f9043783          	ld	a5,-112(s0)
   107ec:	00c7a783          	lw	a5,12(a5)
   107f0:	fcf42623          	sw	a5,-52(s0)
   107f4:	fd042783          	lw	a5,-48(s0)
   107f8:	00078593          	mv	a1,a5
   107fc:	fcc42783          	lw	a5,-52(s0)
   10800:	00078613          	mv	a2,a5
   10804:	0006069b          	sext.w	a3,a2
   10808:	0005879b          	sext.w	a5,a1
   1080c:	00f6d463          	bge	a3,a5,10814 <print_dec_int+0x1ac>
   10810:	00058613          	mv	a2,a1
   10814:	0006079b          	sext.w	a5,a2
   10818:	40f707bb          	subw	a5,a4,a5
   1081c:	0007871b          	sext.w	a4,a5
   10820:	fd744783          	lbu	a5,-41(s0)
   10824:	0007879b          	sext.w	a5,a5
   10828:	40f707bb          	subw	a5,a4,a5
   1082c:	fef42023          	sw	a5,-32(s0)
   10830:	0280006f          	j	10858 <print_dec_int+0x1f0>
   10834:	fa843783          	ld	a5,-88(s0)
   10838:	02000513          	li	a0,32
   1083c:	000780e7          	jalr	a5
   10840:	fe442783          	lw	a5,-28(s0)
   10844:	0017879b          	addiw	a5,a5,1
   10848:	fef42223          	sw	a5,-28(s0)
   1084c:	fe042783          	lw	a5,-32(s0)
   10850:	fff7879b          	addiw	a5,a5,-1
   10854:	fef42023          	sw	a5,-32(s0)
   10858:	fe042783          	lw	a5,-32(s0)
   1085c:	0007879b          	sext.w	a5,a5
   10860:	fcf04ae3          	bgtz	a5,10834 <print_dec_int+0x1cc>
   10864:	fd744783          	lbu	a5,-41(s0)
   10868:	0ff7f793          	zext.b	a5,a5
   1086c:	04078463          	beqz	a5,108b4 <print_dec_int+0x24c>
   10870:	fef44783          	lbu	a5,-17(s0)
   10874:	0ff7f793          	zext.b	a5,a5
   10878:	00078663          	beqz	a5,10884 <print_dec_int+0x21c>
   1087c:	02d00793          	li	a5,45
   10880:	01c0006f          	j	1089c <print_dec_int+0x234>
   10884:	f9043783          	ld	a5,-112(s0)
   10888:	0057c783          	lbu	a5,5(a5)
   1088c:	00078663          	beqz	a5,10898 <print_dec_int+0x230>
   10890:	02b00793          	li	a5,43
   10894:	0080006f          	j	1089c <print_dec_int+0x234>
   10898:	02000793          	li	a5,32
   1089c:	fa843703          	ld	a4,-88(s0)
   108a0:	00078513          	mv	a0,a5
   108a4:	000700e7          	jalr	a4
   108a8:	fe442783          	lw	a5,-28(s0)
   108ac:	0017879b          	addiw	a5,a5,1
   108b0:	fef42223          	sw	a5,-28(s0)
   108b4:	fe842783          	lw	a5,-24(s0)
   108b8:	fcf42e23          	sw	a5,-36(s0)
   108bc:	0280006f          	j	108e4 <print_dec_int+0x27c>
   108c0:	fa843783          	ld	a5,-88(s0)
   108c4:	03000513          	li	a0,48
   108c8:	000780e7          	jalr	a5
   108cc:	fe442783          	lw	a5,-28(s0)
   108d0:	0017879b          	addiw	a5,a5,1
   108d4:	fef42223          	sw	a5,-28(s0)
   108d8:	fdc42783          	lw	a5,-36(s0)
   108dc:	0017879b          	addiw	a5,a5,1
   108e0:	fcf42e23          	sw	a5,-36(s0)
   108e4:	f9043783          	ld	a5,-112(s0)
   108e8:	00c7a703          	lw	a4,12(a5)
   108ec:	fd744783          	lbu	a5,-41(s0)
   108f0:	0007879b          	sext.w	a5,a5
   108f4:	40f707bb          	subw	a5,a4,a5
   108f8:	0007871b          	sext.w	a4,a5
   108fc:	fdc42783          	lw	a5,-36(s0)
   10900:	0007879b          	sext.w	a5,a5
   10904:	fae7cee3          	blt	a5,a4,108c0 <print_dec_int+0x258>
   10908:	fe842783          	lw	a5,-24(s0)
   1090c:	fff7879b          	addiw	a5,a5,-1
   10910:	fcf42c23          	sw	a5,-40(s0)
   10914:	03c0006f          	j	10950 <print_dec_int+0x2e8>
   10918:	fd842783          	lw	a5,-40(s0)
   1091c:	ff078793          	addi	a5,a5,-16
   10920:	008787b3          	add	a5,a5,s0
   10924:	fc87c783          	lbu	a5,-56(a5)
   10928:	0007871b          	sext.w	a4,a5
   1092c:	fa843783          	ld	a5,-88(s0)
   10930:	00070513          	mv	a0,a4
   10934:	000780e7          	jalr	a5
   10938:	fe442783          	lw	a5,-28(s0)
   1093c:	0017879b          	addiw	a5,a5,1
   10940:	fef42223          	sw	a5,-28(s0)
   10944:	fd842783          	lw	a5,-40(s0)
   10948:	fff7879b          	addiw	a5,a5,-1
   1094c:	fcf42c23          	sw	a5,-40(s0)
   10950:	fd842783          	lw	a5,-40(s0)
   10954:	0007879b          	sext.w	a5,a5
   10958:	fc07d0e3          	bgez	a5,10918 <print_dec_int+0x2b0>
   1095c:	fe442783          	lw	a5,-28(s0)
   10960:	00078513          	mv	a0,a5
   10964:	06813083          	ld	ra,104(sp)
   10968:	06013403          	ld	s0,96(sp)
   1096c:	07010113          	addi	sp,sp,112
   10970:	00008067          	ret

0000000000010974 <vprintfmt>:
   10974:	f4010113          	addi	sp,sp,-192
   10978:	0a113c23          	sd	ra,184(sp)
   1097c:	0a813823          	sd	s0,176(sp)
   10980:	0c010413          	addi	s0,sp,192
   10984:	f4a43c23          	sd	a0,-168(s0)
   10988:	f4b43823          	sd	a1,-176(s0)
   1098c:	f4c43423          	sd	a2,-184(s0)
   10990:	f8043023          	sd	zero,-128(s0)
   10994:	f8043423          	sd	zero,-120(s0)
   10998:	fe042623          	sw	zero,-20(s0)
   1099c:	7b40006f          	j	11150 <vprintfmt+0x7dc>
   109a0:	f8044783          	lbu	a5,-128(s0)
   109a4:	74078663          	beqz	a5,110f0 <vprintfmt+0x77c>
   109a8:	f5043783          	ld	a5,-176(s0)
   109ac:	0007c783          	lbu	a5,0(a5)
   109b0:	00078713          	mv	a4,a5
   109b4:	02300793          	li	a5,35
   109b8:	00f71863          	bne	a4,a5,109c8 <vprintfmt+0x54>
   109bc:	00100793          	li	a5,1
   109c0:	f8f40123          	sb	a5,-126(s0)
   109c4:	7800006f          	j	11144 <vprintfmt+0x7d0>
   109c8:	f5043783          	ld	a5,-176(s0)
   109cc:	0007c783          	lbu	a5,0(a5)
   109d0:	00078713          	mv	a4,a5
   109d4:	03000793          	li	a5,48
   109d8:	00f71863          	bne	a4,a5,109e8 <vprintfmt+0x74>
   109dc:	00100793          	li	a5,1
   109e0:	f8f401a3          	sb	a5,-125(s0)
   109e4:	7600006f          	j	11144 <vprintfmt+0x7d0>
   109e8:	f5043783          	ld	a5,-176(s0)
   109ec:	0007c783          	lbu	a5,0(a5)
   109f0:	00078713          	mv	a4,a5
   109f4:	06c00793          	li	a5,108
   109f8:	04f70063          	beq	a4,a5,10a38 <vprintfmt+0xc4>
   109fc:	f5043783          	ld	a5,-176(s0)
   10a00:	0007c783          	lbu	a5,0(a5)
   10a04:	00078713          	mv	a4,a5
   10a08:	07a00793          	li	a5,122
   10a0c:	02f70663          	beq	a4,a5,10a38 <vprintfmt+0xc4>
   10a10:	f5043783          	ld	a5,-176(s0)
   10a14:	0007c783          	lbu	a5,0(a5)
   10a18:	00078713          	mv	a4,a5
   10a1c:	07400793          	li	a5,116
   10a20:	00f70c63          	beq	a4,a5,10a38 <vprintfmt+0xc4>
   10a24:	f5043783          	ld	a5,-176(s0)
   10a28:	0007c783          	lbu	a5,0(a5)
   10a2c:	00078713          	mv	a4,a5
   10a30:	06a00793          	li	a5,106
   10a34:	00f71863          	bne	a4,a5,10a44 <vprintfmt+0xd0>
   10a38:	00100793          	li	a5,1
   10a3c:	f8f400a3          	sb	a5,-127(s0)
   10a40:	7040006f          	j	11144 <vprintfmt+0x7d0>
   10a44:	f5043783          	ld	a5,-176(s0)
   10a48:	0007c783          	lbu	a5,0(a5)
   10a4c:	00078713          	mv	a4,a5
   10a50:	02b00793          	li	a5,43
   10a54:	00f71863          	bne	a4,a5,10a64 <vprintfmt+0xf0>
   10a58:	00100793          	li	a5,1
   10a5c:	f8f402a3          	sb	a5,-123(s0)
   10a60:	6e40006f          	j	11144 <vprintfmt+0x7d0>
   10a64:	f5043783          	ld	a5,-176(s0)
   10a68:	0007c783          	lbu	a5,0(a5)
   10a6c:	00078713          	mv	a4,a5
   10a70:	02000793          	li	a5,32
   10a74:	00f71863          	bne	a4,a5,10a84 <vprintfmt+0x110>
   10a78:	00100793          	li	a5,1
   10a7c:	f8f40223          	sb	a5,-124(s0)
   10a80:	6c40006f          	j	11144 <vprintfmt+0x7d0>
   10a84:	f5043783          	ld	a5,-176(s0)
   10a88:	0007c783          	lbu	a5,0(a5)
   10a8c:	00078713          	mv	a4,a5
   10a90:	02a00793          	li	a5,42
   10a94:	00f71e63          	bne	a4,a5,10ab0 <vprintfmt+0x13c>
   10a98:	f4843783          	ld	a5,-184(s0)
   10a9c:	00878713          	addi	a4,a5,8
   10aa0:	f4e43423          	sd	a4,-184(s0)
   10aa4:	0007a783          	lw	a5,0(a5)
   10aa8:	f8f42423          	sw	a5,-120(s0)
   10aac:	6980006f          	j	11144 <vprintfmt+0x7d0>
   10ab0:	f5043783          	ld	a5,-176(s0)
   10ab4:	0007c783          	lbu	a5,0(a5)
   10ab8:	00078713          	mv	a4,a5
   10abc:	03000793          	li	a5,48
   10ac0:	04e7f863          	bgeu	a5,a4,10b10 <vprintfmt+0x19c>
   10ac4:	f5043783          	ld	a5,-176(s0)
   10ac8:	0007c783          	lbu	a5,0(a5)
   10acc:	00078713          	mv	a4,a5
   10ad0:	03900793          	li	a5,57
   10ad4:	02e7ee63          	bltu	a5,a4,10b10 <vprintfmt+0x19c>
   10ad8:	f5043783          	ld	a5,-176(s0)
   10adc:	f5040713          	addi	a4,s0,-176
   10ae0:	00a00613          	li	a2,10
   10ae4:	00070593          	mv	a1,a4
   10ae8:	00078513          	mv	a0,a5
   10aec:	00000097          	auipc	ra,0x0
   10af0:	884080e7          	jalr	-1916(ra) # 10370 <strtol>
   10af4:	00050793          	mv	a5,a0
   10af8:	0007879b          	sext.w	a5,a5
   10afc:	f8f42423          	sw	a5,-120(s0)
   10b00:	f5043783          	ld	a5,-176(s0)
   10b04:	fff78793          	addi	a5,a5,-1
   10b08:	f4f43823          	sd	a5,-176(s0)
   10b0c:	6380006f          	j	11144 <vprintfmt+0x7d0>
   10b10:	f5043783          	ld	a5,-176(s0)
   10b14:	0007c783          	lbu	a5,0(a5)
   10b18:	00078713          	mv	a4,a5
   10b1c:	02e00793          	li	a5,46
   10b20:	06f71a63          	bne	a4,a5,10b94 <vprintfmt+0x220>
   10b24:	f5043783          	ld	a5,-176(s0)
   10b28:	00178793          	addi	a5,a5,1
   10b2c:	f4f43823          	sd	a5,-176(s0)
   10b30:	f5043783          	ld	a5,-176(s0)
   10b34:	0007c783          	lbu	a5,0(a5)
   10b38:	00078713          	mv	a4,a5
   10b3c:	02a00793          	li	a5,42
   10b40:	00f71e63          	bne	a4,a5,10b5c <vprintfmt+0x1e8>
   10b44:	f4843783          	ld	a5,-184(s0)
   10b48:	00878713          	addi	a4,a5,8
   10b4c:	f4e43423          	sd	a4,-184(s0)
   10b50:	0007a783          	lw	a5,0(a5)
   10b54:	f8f42623          	sw	a5,-116(s0)
   10b58:	5ec0006f          	j	11144 <vprintfmt+0x7d0>
   10b5c:	f5043783          	ld	a5,-176(s0)
   10b60:	f5040713          	addi	a4,s0,-176
   10b64:	00a00613          	li	a2,10
   10b68:	00070593          	mv	a1,a4
   10b6c:	00078513          	mv	a0,a5
   10b70:	00000097          	auipc	ra,0x0
   10b74:	800080e7          	jalr	-2048(ra) # 10370 <strtol>
   10b78:	00050793          	mv	a5,a0
   10b7c:	0007879b          	sext.w	a5,a5
   10b80:	f8f42623          	sw	a5,-116(s0)
   10b84:	f5043783          	ld	a5,-176(s0)
   10b88:	fff78793          	addi	a5,a5,-1
   10b8c:	f4f43823          	sd	a5,-176(s0)
   10b90:	5b40006f          	j	11144 <vprintfmt+0x7d0>
   10b94:	f5043783          	ld	a5,-176(s0)
   10b98:	0007c783          	lbu	a5,0(a5)
   10b9c:	00078713          	mv	a4,a5
   10ba0:	07800793          	li	a5,120
   10ba4:	02f70663          	beq	a4,a5,10bd0 <vprintfmt+0x25c>
   10ba8:	f5043783          	ld	a5,-176(s0)
   10bac:	0007c783          	lbu	a5,0(a5)
   10bb0:	00078713          	mv	a4,a5
   10bb4:	05800793          	li	a5,88
   10bb8:	00f70c63          	beq	a4,a5,10bd0 <vprintfmt+0x25c>
   10bbc:	f5043783          	ld	a5,-176(s0)
   10bc0:	0007c783          	lbu	a5,0(a5)
   10bc4:	00078713          	mv	a4,a5
   10bc8:	07000793          	li	a5,112
   10bcc:	30f71263          	bne	a4,a5,10ed0 <vprintfmt+0x55c>
   10bd0:	f5043783          	ld	a5,-176(s0)
   10bd4:	0007c783          	lbu	a5,0(a5)
   10bd8:	00078713          	mv	a4,a5
   10bdc:	07000793          	li	a5,112
   10be0:	00f70663          	beq	a4,a5,10bec <vprintfmt+0x278>
   10be4:	f8144783          	lbu	a5,-127(s0)
   10be8:	00078663          	beqz	a5,10bf4 <vprintfmt+0x280>
   10bec:	00100793          	li	a5,1
   10bf0:	0080006f          	j	10bf8 <vprintfmt+0x284>
   10bf4:	00000793          	li	a5,0
   10bf8:	faf403a3          	sb	a5,-89(s0)
   10bfc:	fa744783          	lbu	a5,-89(s0)
   10c00:	0017f793          	andi	a5,a5,1
   10c04:	faf403a3          	sb	a5,-89(s0)
   10c08:	fa744783          	lbu	a5,-89(s0)
   10c0c:	0ff7f793          	zext.b	a5,a5
   10c10:	00078c63          	beqz	a5,10c28 <vprintfmt+0x2b4>
   10c14:	f4843783          	ld	a5,-184(s0)
   10c18:	00878713          	addi	a4,a5,8
   10c1c:	f4e43423          	sd	a4,-184(s0)
   10c20:	0007b783          	ld	a5,0(a5)
   10c24:	01c0006f          	j	10c40 <vprintfmt+0x2cc>
   10c28:	f4843783          	ld	a5,-184(s0)
   10c2c:	00878713          	addi	a4,a5,8
   10c30:	f4e43423          	sd	a4,-184(s0)
   10c34:	0007a783          	lw	a5,0(a5)
   10c38:	02079793          	slli	a5,a5,0x20
   10c3c:	0207d793          	srli	a5,a5,0x20
   10c40:	fef43023          	sd	a5,-32(s0)
   10c44:	f8c42783          	lw	a5,-116(s0)
   10c48:	02079463          	bnez	a5,10c70 <vprintfmt+0x2fc>
   10c4c:	fe043783          	ld	a5,-32(s0)
   10c50:	02079063          	bnez	a5,10c70 <vprintfmt+0x2fc>
   10c54:	f5043783          	ld	a5,-176(s0)
   10c58:	0007c783          	lbu	a5,0(a5)
   10c5c:	00078713          	mv	a4,a5
   10c60:	07000793          	li	a5,112
   10c64:	00f70663          	beq	a4,a5,10c70 <vprintfmt+0x2fc>
   10c68:	f8040023          	sb	zero,-128(s0)
   10c6c:	4d80006f          	j	11144 <vprintfmt+0x7d0>
   10c70:	f5043783          	ld	a5,-176(s0)
   10c74:	0007c783          	lbu	a5,0(a5)
   10c78:	00078713          	mv	a4,a5
   10c7c:	07000793          	li	a5,112
   10c80:	00f70a63          	beq	a4,a5,10c94 <vprintfmt+0x320>
   10c84:	f8244783          	lbu	a5,-126(s0)
   10c88:	00078a63          	beqz	a5,10c9c <vprintfmt+0x328>
   10c8c:	fe043783          	ld	a5,-32(s0)
   10c90:	00078663          	beqz	a5,10c9c <vprintfmt+0x328>
   10c94:	00100793          	li	a5,1
   10c98:	0080006f          	j	10ca0 <vprintfmt+0x32c>
   10c9c:	00000793          	li	a5,0
   10ca0:	faf40323          	sb	a5,-90(s0)
   10ca4:	fa644783          	lbu	a5,-90(s0)
   10ca8:	0017f793          	andi	a5,a5,1
   10cac:	faf40323          	sb	a5,-90(s0)
   10cb0:	fc042e23          	sw	zero,-36(s0)
   10cb4:	f5043783          	ld	a5,-176(s0)
   10cb8:	0007c783          	lbu	a5,0(a5)
   10cbc:	00078713          	mv	a4,a5
   10cc0:	05800793          	li	a5,88
   10cc4:	00f71863          	bne	a4,a5,10cd4 <vprintfmt+0x360>
   10cc8:	00000797          	auipc	a5,0x0
   10ccc:	60078793          	addi	a5,a5,1536 # 112c8 <upperxdigits.1>
   10cd0:	00c0006f          	j	10cdc <vprintfmt+0x368>
   10cd4:	00000797          	auipc	a5,0x0
   10cd8:	60c78793          	addi	a5,a5,1548 # 112e0 <lowerxdigits.0>
   10cdc:	f8f43c23          	sd	a5,-104(s0)
   10ce0:	fe043783          	ld	a5,-32(s0)
   10ce4:	00f7f793          	andi	a5,a5,15
   10ce8:	f9843703          	ld	a4,-104(s0)
   10cec:	00f70733          	add	a4,a4,a5
   10cf0:	fdc42783          	lw	a5,-36(s0)
   10cf4:	0017869b          	addiw	a3,a5,1
   10cf8:	fcd42e23          	sw	a3,-36(s0)
   10cfc:	00074703          	lbu	a4,0(a4)
   10d00:	ff078793          	addi	a5,a5,-16
   10d04:	008787b3          	add	a5,a5,s0
   10d08:	f8e78023          	sb	a4,-128(a5)
   10d0c:	fe043783          	ld	a5,-32(s0)
   10d10:	0047d793          	srli	a5,a5,0x4
   10d14:	fef43023          	sd	a5,-32(s0)
   10d18:	fe043783          	ld	a5,-32(s0)
   10d1c:	fc0792e3          	bnez	a5,10ce0 <vprintfmt+0x36c>
   10d20:	f8c42783          	lw	a5,-116(s0)
   10d24:	00078713          	mv	a4,a5
   10d28:	fff00793          	li	a5,-1
   10d2c:	02f71663          	bne	a4,a5,10d58 <vprintfmt+0x3e4>
   10d30:	f8344783          	lbu	a5,-125(s0)
   10d34:	02078263          	beqz	a5,10d58 <vprintfmt+0x3e4>
   10d38:	f8842703          	lw	a4,-120(s0)
   10d3c:	fa644783          	lbu	a5,-90(s0)
   10d40:	0007879b          	sext.w	a5,a5
   10d44:	0017979b          	slliw	a5,a5,0x1
   10d48:	0007879b          	sext.w	a5,a5
   10d4c:	40f707bb          	subw	a5,a4,a5
   10d50:	0007879b          	sext.w	a5,a5
   10d54:	f8f42623          	sw	a5,-116(s0)
   10d58:	f8842703          	lw	a4,-120(s0)
   10d5c:	fa644783          	lbu	a5,-90(s0)
   10d60:	0007879b          	sext.w	a5,a5
   10d64:	0017979b          	slliw	a5,a5,0x1
   10d68:	0007879b          	sext.w	a5,a5
   10d6c:	40f707bb          	subw	a5,a4,a5
   10d70:	0007871b          	sext.w	a4,a5
   10d74:	fdc42783          	lw	a5,-36(s0)
   10d78:	f8f42a23          	sw	a5,-108(s0)
   10d7c:	f8c42783          	lw	a5,-116(s0)
   10d80:	f8f42823          	sw	a5,-112(s0)
   10d84:	f9442783          	lw	a5,-108(s0)
   10d88:	00078593          	mv	a1,a5
   10d8c:	f9042783          	lw	a5,-112(s0)
   10d90:	00078613          	mv	a2,a5
   10d94:	0006069b          	sext.w	a3,a2
   10d98:	0005879b          	sext.w	a5,a1
   10d9c:	00f6d463          	bge	a3,a5,10da4 <vprintfmt+0x430>
   10da0:	00058613          	mv	a2,a1
   10da4:	0006079b          	sext.w	a5,a2
   10da8:	40f707bb          	subw	a5,a4,a5
   10dac:	fcf42c23          	sw	a5,-40(s0)
   10db0:	0280006f          	j	10dd8 <vprintfmt+0x464>
   10db4:	f5843783          	ld	a5,-168(s0)
   10db8:	02000513          	li	a0,32
   10dbc:	000780e7          	jalr	a5
   10dc0:	fec42783          	lw	a5,-20(s0)
   10dc4:	0017879b          	addiw	a5,a5,1
   10dc8:	fef42623          	sw	a5,-20(s0)
   10dcc:	fd842783          	lw	a5,-40(s0)
   10dd0:	fff7879b          	addiw	a5,a5,-1
   10dd4:	fcf42c23          	sw	a5,-40(s0)
   10dd8:	fd842783          	lw	a5,-40(s0)
   10ddc:	0007879b          	sext.w	a5,a5
   10de0:	fcf04ae3          	bgtz	a5,10db4 <vprintfmt+0x440>
   10de4:	fa644783          	lbu	a5,-90(s0)
   10de8:	0ff7f793          	zext.b	a5,a5
   10dec:	04078463          	beqz	a5,10e34 <vprintfmt+0x4c0>
   10df0:	f5843783          	ld	a5,-168(s0)
   10df4:	03000513          	li	a0,48
   10df8:	000780e7          	jalr	a5
   10dfc:	f5043783          	ld	a5,-176(s0)
   10e00:	0007c783          	lbu	a5,0(a5)
   10e04:	00078713          	mv	a4,a5
   10e08:	05800793          	li	a5,88
   10e0c:	00f71663          	bne	a4,a5,10e18 <vprintfmt+0x4a4>
   10e10:	05800793          	li	a5,88
   10e14:	0080006f          	j	10e1c <vprintfmt+0x4a8>
   10e18:	07800793          	li	a5,120
   10e1c:	f5843703          	ld	a4,-168(s0)
   10e20:	00078513          	mv	a0,a5
   10e24:	000700e7          	jalr	a4
   10e28:	fec42783          	lw	a5,-20(s0)
   10e2c:	0027879b          	addiw	a5,a5,2
   10e30:	fef42623          	sw	a5,-20(s0)
   10e34:	fdc42783          	lw	a5,-36(s0)
   10e38:	fcf42a23          	sw	a5,-44(s0)
   10e3c:	0280006f          	j	10e64 <vprintfmt+0x4f0>
   10e40:	f5843783          	ld	a5,-168(s0)
   10e44:	03000513          	li	a0,48
   10e48:	000780e7          	jalr	a5
   10e4c:	fec42783          	lw	a5,-20(s0)
   10e50:	0017879b          	addiw	a5,a5,1
   10e54:	fef42623          	sw	a5,-20(s0)
   10e58:	fd442783          	lw	a5,-44(s0)
   10e5c:	0017879b          	addiw	a5,a5,1
   10e60:	fcf42a23          	sw	a5,-44(s0)
   10e64:	f8c42703          	lw	a4,-116(s0)
   10e68:	fd442783          	lw	a5,-44(s0)
   10e6c:	0007879b          	sext.w	a5,a5
   10e70:	fce7c8e3          	blt	a5,a4,10e40 <vprintfmt+0x4cc>
   10e74:	fdc42783          	lw	a5,-36(s0)
   10e78:	fff7879b          	addiw	a5,a5,-1
   10e7c:	fcf42823          	sw	a5,-48(s0)
   10e80:	03c0006f          	j	10ebc <vprintfmt+0x548>
   10e84:	fd042783          	lw	a5,-48(s0)
   10e88:	ff078793          	addi	a5,a5,-16
   10e8c:	008787b3          	add	a5,a5,s0
   10e90:	f807c783          	lbu	a5,-128(a5)
   10e94:	0007871b          	sext.w	a4,a5
   10e98:	f5843783          	ld	a5,-168(s0)
   10e9c:	00070513          	mv	a0,a4
   10ea0:	000780e7          	jalr	a5
   10ea4:	fec42783          	lw	a5,-20(s0)
   10ea8:	0017879b          	addiw	a5,a5,1
   10eac:	fef42623          	sw	a5,-20(s0)
   10eb0:	fd042783          	lw	a5,-48(s0)
   10eb4:	fff7879b          	addiw	a5,a5,-1
   10eb8:	fcf42823          	sw	a5,-48(s0)
   10ebc:	fd042783          	lw	a5,-48(s0)
   10ec0:	0007879b          	sext.w	a5,a5
   10ec4:	fc07d0e3          	bgez	a5,10e84 <vprintfmt+0x510>
   10ec8:	f8040023          	sb	zero,-128(s0)
   10ecc:	2780006f          	j	11144 <vprintfmt+0x7d0>
   10ed0:	f5043783          	ld	a5,-176(s0)
   10ed4:	0007c783          	lbu	a5,0(a5)
   10ed8:	00078713          	mv	a4,a5
   10edc:	06400793          	li	a5,100
   10ee0:	02f70663          	beq	a4,a5,10f0c <vprintfmt+0x598>
   10ee4:	f5043783          	ld	a5,-176(s0)
   10ee8:	0007c783          	lbu	a5,0(a5)
   10eec:	00078713          	mv	a4,a5
   10ef0:	06900793          	li	a5,105
   10ef4:	00f70c63          	beq	a4,a5,10f0c <vprintfmt+0x598>
   10ef8:	f5043783          	ld	a5,-176(s0)
   10efc:	0007c783          	lbu	a5,0(a5)
   10f00:	00078713          	mv	a4,a5
   10f04:	07500793          	li	a5,117
   10f08:	08f71263          	bne	a4,a5,10f8c <vprintfmt+0x618>
   10f0c:	f8144783          	lbu	a5,-127(s0)
   10f10:	00078c63          	beqz	a5,10f28 <vprintfmt+0x5b4>
   10f14:	f4843783          	ld	a5,-184(s0)
   10f18:	00878713          	addi	a4,a5,8
   10f1c:	f4e43423          	sd	a4,-184(s0)
   10f20:	0007b783          	ld	a5,0(a5)
   10f24:	0140006f          	j	10f38 <vprintfmt+0x5c4>
   10f28:	f4843783          	ld	a5,-184(s0)
   10f2c:	00878713          	addi	a4,a5,8
   10f30:	f4e43423          	sd	a4,-184(s0)
   10f34:	0007a783          	lw	a5,0(a5)
   10f38:	faf43423          	sd	a5,-88(s0)
   10f3c:	fa843583          	ld	a1,-88(s0)
   10f40:	f5043783          	ld	a5,-176(s0)
   10f44:	0007c783          	lbu	a5,0(a5)
   10f48:	0007871b          	sext.w	a4,a5
   10f4c:	07500793          	li	a5,117
   10f50:	40f707b3          	sub	a5,a4,a5
   10f54:	00f037b3          	snez	a5,a5
   10f58:	0ff7f793          	zext.b	a5,a5
   10f5c:	f8040713          	addi	a4,s0,-128
   10f60:	00070693          	mv	a3,a4
   10f64:	00078613          	mv	a2,a5
   10f68:	f5843503          	ld	a0,-168(s0)
   10f6c:	fffff097          	auipc	ra,0xfffff
   10f70:	6fc080e7          	jalr	1788(ra) # 10668 <print_dec_int>
   10f74:	00050793          	mv	a5,a0
   10f78:	fec42703          	lw	a4,-20(s0)
   10f7c:	00f707bb          	addw	a5,a4,a5
   10f80:	fef42623          	sw	a5,-20(s0)
   10f84:	f8040023          	sb	zero,-128(s0)
   10f88:	1bc0006f          	j	11144 <vprintfmt+0x7d0>
   10f8c:	f5043783          	ld	a5,-176(s0)
   10f90:	0007c783          	lbu	a5,0(a5)
   10f94:	00078713          	mv	a4,a5
   10f98:	06e00793          	li	a5,110
   10f9c:	04f71c63          	bne	a4,a5,10ff4 <vprintfmt+0x680>
   10fa0:	f8144783          	lbu	a5,-127(s0)
   10fa4:	02078463          	beqz	a5,10fcc <vprintfmt+0x658>
   10fa8:	f4843783          	ld	a5,-184(s0)
   10fac:	00878713          	addi	a4,a5,8
   10fb0:	f4e43423          	sd	a4,-184(s0)
   10fb4:	0007b783          	ld	a5,0(a5)
   10fb8:	faf43823          	sd	a5,-80(s0)
   10fbc:	fec42703          	lw	a4,-20(s0)
   10fc0:	fb043783          	ld	a5,-80(s0)
   10fc4:	00e7b023          	sd	a4,0(a5)
   10fc8:	0240006f          	j	10fec <vprintfmt+0x678>
   10fcc:	f4843783          	ld	a5,-184(s0)
   10fd0:	00878713          	addi	a4,a5,8
   10fd4:	f4e43423          	sd	a4,-184(s0)
   10fd8:	0007b783          	ld	a5,0(a5)
   10fdc:	faf43c23          	sd	a5,-72(s0)
   10fe0:	fb843783          	ld	a5,-72(s0)
   10fe4:	fec42703          	lw	a4,-20(s0)
   10fe8:	00e7a023          	sw	a4,0(a5)
   10fec:	f8040023          	sb	zero,-128(s0)
   10ff0:	1540006f          	j	11144 <vprintfmt+0x7d0>
   10ff4:	f5043783          	ld	a5,-176(s0)
   10ff8:	0007c783          	lbu	a5,0(a5)
   10ffc:	00078713          	mv	a4,a5
   11000:	07300793          	li	a5,115
   11004:	04f71063          	bne	a4,a5,11044 <vprintfmt+0x6d0>
   11008:	f4843783          	ld	a5,-184(s0)
   1100c:	00878713          	addi	a4,a5,8
   11010:	f4e43423          	sd	a4,-184(s0)
   11014:	0007b783          	ld	a5,0(a5)
   11018:	fcf43023          	sd	a5,-64(s0)
   1101c:	fc043583          	ld	a1,-64(s0)
   11020:	f5843503          	ld	a0,-168(s0)
   11024:	fffff097          	auipc	ra,0xfffff
   11028:	5bc080e7          	jalr	1468(ra) # 105e0 <puts_wo_nl>
   1102c:	00050793          	mv	a5,a0
   11030:	fec42703          	lw	a4,-20(s0)
   11034:	00f707bb          	addw	a5,a4,a5
   11038:	fef42623          	sw	a5,-20(s0)
   1103c:	f8040023          	sb	zero,-128(s0)
   11040:	1040006f          	j	11144 <vprintfmt+0x7d0>
   11044:	f5043783          	ld	a5,-176(s0)
   11048:	0007c783          	lbu	a5,0(a5)
   1104c:	00078713          	mv	a4,a5
   11050:	06300793          	li	a5,99
   11054:	02f71e63          	bne	a4,a5,11090 <vprintfmt+0x71c>
   11058:	f4843783          	ld	a5,-184(s0)
   1105c:	00878713          	addi	a4,a5,8
   11060:	f4e43423          	sd	a4,-184(s0)
   11064:	0007a783          	lw	a5,0(a5)
   11068:	fcf42623          	sw	a5,-52(s0)
   1106c:	fcc42703          	lw	a4,-52(s0)
   11070:	f5843783          	ld	a5,-168(s0)
   11074:	00070513          	mv	a0,a4
   11078:	000780e7          	jalr	a5
   1107c:	fec42783          	lw	a5,-20(s0)
   11080:	0017879b          	addiw	a5,a5,1
   11084:	fef42623          	sw	a5,-20(s0)
   11088:	f8040023          	sb	zero,-128(s0)
   1108c:	0b80006f          	j	11144 <vprintfmt+0x7d0>
   11090:	f5043783          	ld	a5,-176(s0)
   11094:	0007c783          	lbu	a5,0(a5)
   11098:	00078713          	mv	a4,a5
   1109c:	02500793          	li	a5,37
   110a0:	02f71263          	bne	a4,a5,110c4 <vprintfmt+0x750>
   110a4:	f5843783          	ld	a5,-168(s0)
   110a8:	02500513          	li	a0,37
   110ac:	000780e7          	jalr	a5
   110b0:	fec42783          	lw	a5,-20(s0)
   110b4:	0017879b          	addiw	a5,a5,1
   110b8:	fef42623          	sw	a5,-20(s0)
   110bc:	f8040023          	sb	zero,-128(s0)
   110c0:	0840006f          	j	11144 <vprintfmt+0x7d0>
   110c4:	f5043783          	ld	a5,-176(s0)
   110c8:	0007c783          	lbu	a5,0(a5)
   110cc:	0007871b          	sext.w	a4,a5
   110d0:	f5843783          	ld	a5,-168(s0)
   110d4:	00070513          	mv	a0,a4
   110d8:	000780e7          	jalr	a5
   110dc:	fec42783          	lw	a5,-20(s0)
   110e0:	0017879b          	addiw	a5,a5,1
   110e4:	fef42623          	sw	a5,-20(s0)
   110e8:	f8040023          	sb	zero,-128(s0)
   110ec:	0580006f          	j	11144 <vprintfmt+0x7d0>
   110f0:	f5043783          	ld	a5,-176(s0)
   110f4:	0007c783          	lbu	a5,0(a5)
   110f8:	00078713          	mv	a4,a5
   110fc:	02500793          	li	a5,37
   11100:	02f71063          	bne	a4,a5,11120 <vprintfmt+0x7ac>
   11104:	f8043023          	sd	zero,-128(s0)
   11108:	f8043423          	sd	zero,-120(s0)
   1110c:	00100793          	li	a5,1
   11110:	f8f40023          	sb	a5,-128(s0)
   11114:	fff00793          	li	a5,-1
   11118:	f8f42623          	sw	a5,-116(s0)
   1111c:	0280006f          	j	11144 <vprintfmt+0x7d0>
   11120:	f5043783          	ld	a5,-176(s0)
   11124:	0007c783          	lbu	a5,0(a5)
   11128:	0007871b          	sext.w	a4,a5
   1112c:	f5843783          	ld	a5,-168(s0)
   11130:	00070513          	mv	a0,a4
   11134:	000780e7          	jalr	a5
   11138:	fec42783          	lw	a5,-20(s0)
   1113c:	0017879b          	addiw	a5,a5,1
   11140:	fef42623          	sw	a5,-20(s0)
   11144:	f5043783          	ld	a5,-176(s0)
   11148:	00178793          	addi	a5,a5,1
   1114c:	f4f43823          	sd	a5,-176(s0)
   11150:	f5043783          	ld	a5,-176(s0)
   11154:	0007c783          	lbu	a5,0(a5)
   11158:	840794e3          	bnez	a5,109a0 <vprintfmt+0x2c>
   1115c:	fec42783          	lw	a5,-20(s0)
   11160:	00078513          	mv	a0,a5
   11164:	0b813083          	ld	ra,184(sp)
   11168:	0b013403          	ld	s0,176(sp)
   1116c:	0c010113          	addi	sp,sp,192
   11170:	00008067          	ret

0000000000011174 <printf>:
   11174:	f8010113          	addi	sp,sp,-128
   11178:	02113c23          	sd	ra,56(sp)
   1117c:	02813823          	sd	s0,48(sp)
   11180:	04010413          	addi	s0,sp,64
   11184:	fca43423          	sd	a0,-56(s0)
   11188:	00b43423          	sd	a1,8(s0)
   1118c:	00c43823          	sd	a2,16(s0)
   11190:	00d43c23          	sd	a3,24(s0)
   11194:	02e43023          	sd	a4,32(s0)
   11198:	02f43423          	sd	a5,40(s0)
   1119c:	03043823          	sd	a6,48(s0)
   111a0:	03143c23          	sd	a7,56(s0)
   111a4:	fe042623          	sw	zero,-20(s0)
   111a8:	04040793          	addi	a5,s0,64
   111ac:	fcf43023          	sd	a5,-64(s0)
   111b0:	fc043783          	ld	a5,-64(s0)
   111b4:	fc878793          	addi	a5,a5,-56
   111b8:	fcf43823          	sd	a5,-48(s0)
   111bc:	fd043783          	ld	a5,-48(s0)
   111c0:	00078613          	mv	a2,a5
   111c4:	fc843583          	ld	a1,-56(s0)
   111c8:	fffff517          	auipc	a0,0xfffff
   111cc:	0e050513          	addi	a0,a0,224 # 102a8 <putc>
   111d0:	fffff097          	auipc	ra,0xfffff
   111d4:	7a4080e7          	jalr	1956(ra) # 10974 <vprintfmt>
   111d8:	00050793          	mv	a5,a0
   111dc:	fef42623          	sw	a5,-20(s0)
   111e0:	00100793          	li	a5,1
   111e4:	fef43023          	sd	a5,-32(s0)
   111e8:	00001797          	auipc	a5,0x1
   111ec:	e1c78793          	addi	a5,a5,-484 # 12004 <tail>
   111f0:	0007a783          	lw	a5,0(a5)
   111f4:	0017871b          	addiw	a4,a5,1
   111f8:	0007069b          	sext.w	a3,a4
   111fc:	00001717          	auipc	a4,0x1
   11200:	e0870713          	addi	a4,a4,-504 # 12004 <tail>
   11204:	00d72023          	sw	a3,0(a4)
   11208:	00001717          	auipc	a4,0x1
   1120c:	e0070713          	addi	a4,a4,-512 # 12008 <buffer>
   11210:	00f707b3          	add	a5,a4,a5
   11214:	00078023          	sb	zero,0(a5)
   11218:	00001797          	auipc	a5,0x1
   1121c:	dec78793          	addi	a5,a5,-532 # 12004 <tail>
   11220:	0007a603          	lw	a2,0(a5)
   11224:	fe043703          	ld	a4,-32(s0)
   11228:	00001697          	auipc	a3,0x1
   1122c:	de068693          	addi	a3,a3,-544 # 12008 <buffer>
   11230:	fd843783          	ld	a5,-40(s0)
   11234:	04000893          	li	a7,64
   11238:	00070513          	mv	a0,a4
   1123c:	00068593          	mv	a1,a3
   11240:	00060613          	mv	a2,a2
   11244:	00000073          	ecall
   11248:	00050793          	mv	a5,a0
   1124c:	fcf43c23          	sd	a5,-40(s0)
   11250:	00001797          	auipc	a5,0x1
   11254:	db478793          	addi	a5,a5,-588 # 12004 <tail>
   11258:	0007a023          	sw	zero,0(a5)
   1125c:	fec42783          	lw	a5,-20(s0)
   11260:	00078513          	mv	a0,a5
   11264:	03813083          	ld	ra,56(sp)
   11268:	03013403          	ld	s0,48(sp)
   1126c:	08010113          	addi	sp,sp,128
   11270:	00008067          	ret
