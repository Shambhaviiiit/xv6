
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	b9813103          	ld	sp,-1128(sp) # 80009b98 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	ra,8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid"
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	0000a717          	auipc	a4,0xa
    80000054:	ba070713          	addi	a4,a4,-1120 # 80009bf0 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0"
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0"
    80000062:	00007797          	auipc	a5,0x7
    80000066:	80e78793          	addi	a5,a5,-2034 # 80006870 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus"
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0"
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie"
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0"
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus"
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdb79b7>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0"
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0"
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	eea78793          	addi	a5,a5,-278 # 80000f96 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0"
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0"
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0"
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie"
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0"
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0"
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0"
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid"
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0"
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	fc26                	sd	s1,56(sp)
    80000108:	f84a                	sd	s2,48(sp)
    8000010a:	f44e                	sd	s3,40(sp)
    8000010c:	f052                	sd	s4,32(sp)
    8000010e:	ec56                	sd	s5,24(sp)
    80000110:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000112:	04c05763          	blez	a2,80000160 <consolewrite+0x60>
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	7b2080e7          	jalr	1970(ra) # 800028dc <either_copyin>
    80000132:	01550d63          	beq	a0,s5,8000014c <consolewrite+0x4c>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	784080e7          	jalr	1924(ra) # 800008be <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4c>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7159                	addi	sp,sp,-112
    80000166:	f486                	sd	ra,104(sp)
    80000168:	f0a2                	sd	s0,96(sp)
    8000016a:	eca6                	sd	s1,88(sp)
    8000016c:	e8ca                	sd	s2,80(sp)
    8000016e:	e4ce                	sd	s3,72(sp)
    80000170:	e0d2                	sd	s4,64(sp)
    80000172:	fc56                	sd	s5,56(sp)
    80000174:	f85a                	sd	s6,48(sp)
    80000176:	f45e                	sd	s7,40(sp)
    80000178:	f062                	sd	s8,32(sp)
    8000017a:	ec66                	sd	s9,24(sp)
    8000017c:	e86a                	sd	s10,16(sp)
    8000017e:	1880                	addi	s0,sp,112
    80000180:	8aaa                	mv	s5,a0
    80000182:	8a2e                	mv	s4,a1
    80000184:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00012517          	auipc	a0,0x12
    8000018e:	ba650513          	addi	a0,a0,-1114 # 80011d30 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	b62080e7          	jalr	-1182(ra) # 80000cf4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00012497          	auipc	s1,0x12
    8000019e:	b9648493          	addi	s1,s1,-1130 # 80011d30 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00012917          	auipc	s2,0x12
    800001a6:	c2690913          	addi	s2,s2,-986 # 80011dc8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800001aa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ac:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ae:	4ca9                	li	s9,10
  while(n > 0){
    800001b0:	07305b63          	blez	s3,80000226 <consoleread+0xc2>
    while(cons.r == cons.w){
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71763          	bne	a4,a5,800001ea <consoleread+0x86>
      if(killed(myproc())){
    800001c0:	00002097          	auipc	ra,0x2
    800001c4:	950080e7          	jalr	-1712(ra) # 80001b10 <myproc>
    800001c8:	00002097          	auipc	ra,0x2
    800001cc:	55e080e7          	jalr	1374(ra) # 80002726 <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	2ce080e7          	jalr	718(ra) # 800024a4 <sleep>
    while(cons.r == cons.w){
    800001de:	0984a783          	lw	a5,152(s1)
    800001e2:	09c4a703          	lw	a4,156(s1)
    800001e6:	fcf70de3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ea:	0017871b          	addiw	a4,a5,1
    800001ee:	08e4ac23          	sw	a4,152(s1)
    800001f2:	07f7f713          	andi	a4,a5,127
    800001f6:	9726                	add	a4,a4,s1
    800001f8:	01874703          	lbu	a4,24(a4)
    800001fc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000200:	077d0563          	beq	s10,s7,8000026a <consoleread+0x106>
    cbuf = c;
    80000204:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000208:	4685                	li	a3,1
    8000020a:	f9f40613          	addi	a2,s0,-97
    8000020e:	85d2                	mv	a1,s4
    80000210:	8556                	mv	a0,s5
    80000212:	00002097          	auipc	ra,0x2
    80000216:	674080e7          	jalr	1652(ra) # 80002886 <either_copyout>
    8000021a:	01850663          	beq	a0,s8,80000226 <consoleread+0xc2>
    dst++;
    8000021e:	0a05                	addi	s4,s4,1
    --n;
    80000220:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000222:	f99d17e3          	bne	s10,s9,800001b0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000226:	00012517          	auipc	a0,0x12
    8000022a:	b0a50513          	addi	a0,a0,-1270 # 80011d30 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	b7a080e7          	jalr	-1158(ra) # 80000da8 <release>

  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
        release(&cons.lock);
    8000023c:	00012517          	auipc	a0,0x12
    80000240:	af450513          	addi	a0,a0,-1292 # 80011d30 <cons>
    80000244:	00001097          	auipc	ra,0x1
    80000248:	b64080e7          	jalr	-1180(ra) # 80000da8 <release>
        return -1;
    8000024c:	557d                	li	a0,-1
}
    8000024e:	70a6                	ld	ra,104(sp)
    80000250:	7406                	ld	s0,96(sp)
    80000252:	64e6                	ld	s1,88(sp)
    80000254:	6946                	ld	s2,80(sp)
    80000256:	69a6                	ld	s3,72(sp)
    80000258:	6a06                	ld	s4,64(sp)
    8000025a:	7ae2                	ld	s5,56(sp)
    8000025c:	7b42                	ld	s6,48(sp)
    8000025e:	7ba2                	ld	s7,40(sp)
    80000260:	7c02                	ld	s8,32(sp)
    80000262:	6ce2                	ld	s9,24(sp)
    80000264:	6d42                	ld	s10,16(sp)
    80000266:	6165                	addi	sp,sp,112
    80000268:	8082                	ret
      if(n < target){
    8000026a:	0009871b          	sext.w	a4,s3
    8000026e:	fb677ce3          	bgeu	a4,s6,80000226 <consoleread+0xc2>
        cons.r--;
    80000272:	00012717          	auipc	a4,0x12
    80000276:	b4f72b23          	sw	a5,-1194(a4) # 80011dc8 <cons+0x98>
    8000027a:	b775                	j	80000226 <consoleread+0xc2>

000000008000027c <consputc>:
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000284:	10000793          	li	a5,256
    80000288:	00f50a63          	beq	a0,a5,8000029c <consputc+0x20>
    uartputc_sync(c);
    8000028c:	00000097          	auipc	ra,0x0
    80000290:	560080e7          	jalr	1376(ra) # 800007ec <uartputc_sync>
}
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000029c:	4521                	li	a0,8
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	54e080e7          	jalr	1358(ra) # 800007ec <uartputc_sync>
    800002a6:	02000513          	li	a0,32
    800002aa:	00000097          	auipc	ra,0x0
    800002ae:	542080e7          	jalr	1346(ra) # 800007ec <uartputc_sync>
    800002b2:	4521                	li	a0,8
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	538080e7          	jalr	1336(ra) # 800007ec <uartputc_sync>
    800002bc:	bfe1                	j	80000294 <consputc+0x18>

00000000800002be <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002be:	1101                	addi	sp,sp,-32
    800002c0:	ec06                	sd	ra,24(sp)
    800002c2:	e822                	sd	s0,16(sp)
    800002c4:	e426                	sd	s1,8(sp)
    800002c6:	e04a                	sd	s2,0(sp)
    800002c8:	1000                	addi	s0,sp,32
    800002ca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002cc:	00012517          	auipc	a0,0x12
    800002d0:	a6450513          	addi	a0,a0,-1436 # 80011d30 <cons>
    800002d4:	00001097          	auipc	ra,0x1
    800002d8:	a20080e7          	jalr	-1504(ra) # 80000cf4 <acquire>

  switch(c){
    800002dc:	47d5                	li	a5,21
    800002de:	0af48663          	beq	s1,a5,8000038a <consoleintr+0xcc>
    800002e2:	0297ca63          	blt	a5,s1,80000316 <consoleintr+0x58>
    800002e6:	47a1                	li	a5,8
    800002e8:	0ef48763          	beq	s1,a5,800003d6 <consoleintr+0x118>
    800002ec:	47c1                	li	a5,16
    800002ee:	10f49a63          	bne	s1,a5,80000402 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f2:	00002097          	auipc	ra,0x2
    800002f6:	640080e7          	jalr	1600(ra) # 80002932 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fa:	00012517          	auipc	a0,0x12
    800002fe:	a3650513          	addi	a0,a0,-1482 # 80011d30 <cons>
    80000302:	00001097          	auipc	ra,0x1
    80000306:	aa6080e7          	jalr	-1370(ra) # 80000da8 <release>
}
    8000030a:	60e2                	ld	ra,24(sp)
    8000030c:	6442                	ld	s0,16(sp)
    8000030e:	64a2                	ld	s1,8(sp)
    80000310:	6902                	ld	s2,0(sp)
    80000312:	6105                	addi	sp,sp,32
    80000314:	8082                	ret
  switch(c){
    80000316:	07f00793          	li	a5,127
    8000031a:	0af48e63          	beq	s1,a5,800003d6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031e:	00012717          	auipc	a4,0x12
    80000322:	a1270713          	addi	a4,a4,-1518 # 80011d30 <cons>
    80000326:	0a072783          	lw	a5,160(a4)
    8000032a:	09872703          	lw	a4,152(a4)
    8000032e:	9f99                	subw	a5,a5,a4
    80000330:	07f00713          	li	a4,127
    80000334:	fcf763e3          	bltu	a4,a5,800002fa <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000338:	47b5                	li	a5,13
    8000033a:	0cf48763          	beq	s1,a5,80000408 <consoleintr+0x14a>
      consputc(c);
    8000033e:	8526                	mv	a0,s1
    80000340:	00000097          	auipc	ra,0x0
    80000344:	f3c080e7          	jalr	-196(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000348:	00012797          	auipc	a5,0x12
    8000034c:	9e878793          	addi	a5,a5,-1560 # 80011d30 <cons>
    80000350:	0a07a683          	lw	a3,160(a5)
    80000354:	0016871b          	addiw	a4,a3,1
    80000358:	0007061b          	sext.w	a2,a4
    8000035c:	0ae7a023          	sw	a4,160(a5)
    80000360:	07f6f693          	andi	a3,a3,127
    80000364:	97b6                	add	a5,a5,a3
    80000366:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000036a:	47a9                	li	a5,10
    8000036c:	0cf48563          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000370:	4791                	li	a5,4
    80000372:	0cf48263          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000376:	00012797          	auipc	a5,0x12
    8000037a:	a527a783          	lw	a5,-1454(a5) # 80011dc8 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038a:	00012717          	auipc	a4,0x12
    8000038e:	9a670713          	addi	a4,a4,-1626 # 80011d30 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000039a:	00012497          	auipc	s1,0x12
    8000039e:	99648493          	addi	s1,s1,-1642 # 80011d30 <cons>
    while(cons.e != cons.w &&
    800003a2:	4929                	li	s2,10
    800003a4:	f4f70be3          	beq	a4,a5,800002fa <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	07f7f713          	andi	a4,a5,127
    800003ae:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b0:	01874703          	lbu	a4,24(a4)
    800003b4:	f52703e3          	beq	a4,s2,800002fa <consoleintr+0x3c>
      cons.e--;
    800003b8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003bc:	10000513          	li	a0,256
    800003c0:	00000097          	auipc	ra,0x0
    800003c4:	ebc080e7          	jalr	-324(ra) # 8000027c <consputc>
    while(cons.e != cons.w &&
    800003c8:	0a04a783          	lw	a5,160(s1)
    800003cc:	09c4a703          	lw	a4,156(s1)
    800003d0:	fcf71ce3          	bne	a4,a5,800003a8 <consoleintr+0xea>
    800003d4:	b71d                	j	800002fa <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d6:	00012717          	auipc	a4,0x12
    800003da:	95a70713          	addi	a4,a4,-1702 # 80011d30 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
      cons.e--;
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00012717          	auipc	a4,0x12
    800003f0:	9ef72223          	sw	a5,-1564(a4) # 80011dd0 <cons+0xa0>
      consputc(BACKSPACE);
    800003f4:	10000513          	li	a0,256
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	e84080e7          	jalr	-380(ra) # 8000027c <consputc>
    80000400:	bded                	j	800002fa <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000402:	ee048ce3          	beqz	s1,800002fa <consoleintr+0x3c>
    80000406:	bf21                	j	8000031e <consoleintr+0x60>
      consputc(c);
    80000408:	4529                	li	a0,10
    8000040a:	00000097          	auipc	ra,0x0
    8000040e:	e72080e7          	jalr	-398(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000412:	00012797          	auipc	a5,0x12
    80000416:	91e78793          	addi	a5,a5,-1762 # 80011d30 <cons>
    8000041a:	0a07a703          	lw	a4,160(a5)
    8000041e:	0017069b          	addiw	a3,a4,1
    80000422:	0006861b          	sext.w	a2,a3
    80000426:	0ad7a023          	sw	a3,160(a5)
    8000042a:	07f77713          	andi	a4,a4,127
    8000042e:	97ba                	add	a5,a5,a4
    80000430:	4729                	li	a4,10
    80000432:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000436:	00012797          	auipc	a5,0x12
    8000043a:	98c7ab23          	sw	a2,-1642(a5) # 80011dcc <cons+0x9c>
        wakeup(&cons.r);
    8000043e:	00012517          	auipc	a0,0x12
    80000442:	98a50513          	addi	a0,a0,-1654 # 80011dc8 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	0c2080e7          	jalr	194(ra) # 80002508 <wakeup>
    8000044e:	b575                	j	800002fa <consoleintr+0x3c>

0000000080000450 <consoleinit>:

void
consoleinit(void)
{
    80000450:	1141                	addi	sp,sp,-16
    80000452:	e406                	sd	ra,8(sp)
    80000454:	e022                	sd	s0,0(sp)
    80000456:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000458:	00009597          	auipc	a1,0x9
    8000045c:	bb858593          	addi	a1,a1,-1096 # 80009010 <etext+0x10>
    80000460:	00012517          	auipc	a0,0x12
    80000464:	8d050513          	addi	a0,a0,-1840 # 80011d30 <cons>
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	7fc080e7          	jalr	2044(ra) # 80000c64 <initlock>

  uartinit();
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32c080e7          	jalr	812(ra) # 8000079c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000478:	00244797          	auipc	a5,0x244
    8000047c:	4b878793          	addi	a5,a5,1208 # 80244930 <devsw>
    80000480:	00000717          	auipc	a4,0x0
    80000484:	ce470713          	addi	a4,a4,-796 # 80000164 <consoleread>
    80000488:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	c7670713          	addi	a4,a4,-906 # 80000100 <consolewrite>
    80000492:	ef98                	sd	a4,24(a5)
}
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000049c:	7179                	addi	sp,sp,-48
    8000049e:	f406                	sd	ra,40(sp)
    800004a0:	f022                	sd	s0,32(sp)
    800004a2:	ec26                	sd	s1,24(sp)
    800004a4:	e84a                	sd	s2,16(sp)
    800004a6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    800004a8:	c219                	beqz	a2,800004ae <printint+0x12>
    800004aa:	08054763          	bltz	a0,80000538 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004ae:	2501                	sext.w	a0,a0
    800004b0:	4881                	li	a7,0
    800004b2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b6:	4701                	li	a4,0
  do
  {
    buf[i++] = digits[x % base];
    800004b8:	2581                	sext.w	a1,a1
    800004ba:	00009617          	auipc	a2,0x9
    800004be:	b8660613          	addi	a2,a2,-1146 # 80009040 <digits>
    800004c2:	883a                	mv	a6,a4
    800004c4:	2705                	addiw	a4,a4,1
    800004c6:	02b577bb          	remuw	a5,a0,a1
    800004ca:	1782                	slli	a5,a5,0x20
    800004cc:	9381                	srli	a5,a5,0x20
    800004ce:	97b2                	add	a5,a5,a2
    800004d0:	0007c783          	lbu	a5,0(a5)
    800004d4:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    800004d8:	0005079b          	sext.w	a5,a0
    800004dc:	02b5553b          	divuw	a0,a0,a1
    800004e0:	0685                	addi	a3,a3,1
    800004e2:	feb7f0e3          	bgeu	a5,a1,800004c2 <printint+0x26>

  if (sign)
    800004e6:	00088c63          	beqz	a7,800004fe <printint+0x62>
    buf[i++] = '-';
    800004ea:	fe070793          	addi	a5,a4,-32
    800004ee:	00878733          	add	a4,a5,s0
    800004f2:	02d00793          	li	a5,45
    800004f6:	fef70823          	sb	a5,-16(a4)
    800004fa:	0028071b          	addiw	a4,a6,2

  while (--i >= 0)
    800004fe:	02e05763          	blez	a4,8000052c <printint+0x90>
    80000502:	fd040793          	addi	a5,s0,-48
    80000506:	00e784b3          	add	s1,a5,a4
    8000050a:	fff78913          	addi	s2,a5,-1
    8000050e:	993a                	add	s2,s2,a4
    80000510:	377d                	addiw	a4,a4,-1
    80000512:	1702                	slli	a4,a4,0x20
    80000514:	9301                	srli	a4,a4,0x20
    80000516:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000051a:	fff4c503          	lbu	a0,-1(s1)
    8000051e:	00000097          	auipc	ra,0x0
    80000522:	d5e080e7          	jalr	-674(ra) # 8000027c <consputc>
  while (--i >= 0)
    80000526:	14fd                	addi	s1,s1,-1
    80000528:	ff2499e3          	bne	s1,s2,8000051a <printint+0x7e>
}
    8000052c:	70a2                	ld	ra,40(sp)
    8000052e:	7402                	ld	s0,32(sp)
    80000530:	64e2                	ld	s1,24(sp)
    80000532:	6942                	ld	s2,16(sp)
    80000534:	6145                	addi	sp,sp,48
    80000536:	8082                	ret
    x = -xx;
    80000538:	40a0053b          	negw	a0,a0
  if (sign && (sign = xx < 0))
    8000053c:	4885                	li	a7,1
    x = -xx;
    8000053e:	bf95                	j	800004b2 <printint+0x16>

0000000080000540 <panic>:
  if (locking)
    release(&pr.lock);
}

void panic(char *s)
{
    80000540:	1101                	addi	sp,sp,-32
    80000542:	ec06                	sd	ra,24(sp)
    80000544:	e822                	sd	s0,16(sp)
    80000546:	e426                	sd	s1,8(sp)
    80000548:	1000                	addi	s0,sp,32
    8000054a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000054c:	00012797          	auipc	a5,0x12
    80000550:	8a07a223          	sw	zero,-1884(a5) # 80011df0 <pr+0x18>
  printf("panic: ");
    80000554:	00009517          	auipc	a0,0x9
    80000558:	ac450513          	addi	a0,a0,-1340 # 80009018 <etext+0x18>
    8000055c:	00000097          	auipc	ra,0x0
    80000560:	02e080e7          	jalr	46(ra) # 8000058a <printf>
  printf(s);
    80000564:	8526                	mv	a0,s1
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	024080e7          	jalr	36(ra) # 8000058a <printf>
  printf("\n");
    8000056e:	00009517          	auipc	a0,0x9
    80000572:	b7a50513          	addi	a0,a0,-1158 # 800090e8 <digits+0xa8>
    80000576:	00000097          	auipc	ra,0x0
    8000057a:	014080e7          	jalr	20(ra) # 8000058a <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057e:	4785                	li	a5,1
    80000580:	00009717          	auipc	a4,0x9
    80000584:	62f72823          	sw	a5,1584(a4) # 80009bb0 <panicked>
  for (;;)
    80000588:	a001                	j	80000588 <panic+0x48>

000000008000058a <printf>:
{
    8000058a:	7131                	addi	sp,sp,-192
    8000058c:	fc86                	sd	ra,120(sp)
    8000058e:	f8a2                	sd	s0,112(sp)
    80000590:	f4a6                	sd	s1,104(sp)
    80000592:	f0ca                	sd	s2,96(sp)
    80000594:	ecce                	sd	s3,88(sp)
    80000596:	e8d2                	sd	s4,80(sp)
    80000598:	e4d6                	sd	s5,72(sp)
    8000059a:	e0da                	sd	s6,64(sp)
    8000059c:	fc5e                	sd	s7,56(sp)
    8000059e:	f862                	sd	s8,48(sp)
    800005a0:	f466                	sd	s9,40(sp)
    800005a2:	f06a                	sd	s10,32(sp)
    800005a4:	ec6e                	sd	s11,24(sp)
    800005a6:	0100                	addi	s0,sp,128
    800005a8:	8a2a                	mv	s4,a0
    800005aa:	e40c                	sd	a1,8(s0)
    800005ac:	e810                	sd	a2,16(s0)
    800005ae:	ec14                	sd	a3,24(s0)
    800005b0:	f018                	sd	a4,32(s0)
    800005b2:	f41c                	sd	a5,40(s0)
    800005b4:	03043823          	sd	a6,48(s0)
    800005b8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005bc:	00012d97          	auipc	s11,0x12
    800005c0:	834dad83          	lw	s11,-1996(s11) # 80011df0 <pr+0x18>
  if (locking)
    800005c4:	020d9b63          	bnez	s11,800005fa <printf+0x70>
  if (fmt == 0)
    800005c8:	040a0263          	beqz	s4,8000060c <printf+0x82>
  va_start(ap, fmt);
    800005cc:	00840793          	addi	a5,s0,8
    800005d0:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    800005d4:	000a4503          	lbu	a0,0(s4)
    800005d8:	14050f63          	beqz	a0,80000736 <printf+0x1ac>
    800005dc:	4981                	li	s3,0
    if (c != '%')
    800005de:	02500a93          	li	s5,37
    switch (c)
    800005e2:	07000b93          	li	s7,112
  consputc('x');
    800005e6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e8:	00009b17          	auipc	s6,0x9
    800005ec:	a58b0b13          	addi	s6,s6,-1448 # 80009040 <digits>
    switch (c)
    800005f0:	07300c93          	li	s9,115
    800005f4:	06400c13          	li	s8,100
    800005f8:	a82d                	j	80000632 <printf+0xa8>
    acquire(&pr.lock);
    800005fa:	00011517          	auipc	a0,0x11
    800005fe:	7de50513          	addi	a0,a0,2014 # 80011dd8 <pr>
    80000602:	00000097          	auipc	ra,0x0
    80000606:	6f2080e7          	jalr	1778(ra) # 80000cf4 <acquire>
    8000060a:	bf7d                	j	800005c8 <printf+0x3e>
    panic("null fmt");
    8000060c:	00009517          	auipc	a0,0x9
    80000610:	a1c50513          	addi	a0,a0,-1508 # 80009028 <etext+0x28>
    80000614:	00000097          	auipc	ra,0x0
    80000618:	f2c080e7          	jalr	-212(ra) # 80000540 <panic>
      consputc(c);
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	c60080e7          	jalr	-928(ra) # 8000027c <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    80000624:	2985                	addiw	s3,s3,1
    80000626:	013a07b3          	add	a5,s4,s3
    8000062a:	0007c503          	lbu	a0,0(a5)
    8000062e:	10050463          	beqz	a0,80000736 <printf+0x1ac>
    if (c != '%')
    80000632:	ff5515e3          	bne	a0,s5,8000061c <printf+0x92>
    c = fmt[++i] & 0xff;
    80000636:	2985                	addiw	s3,s3,1
    80000638:	013a07b3          	add	a5,s4,s3
    8000063c:	0007c783          	lbu	a5,0(a5)
    80000640:	0007849b          	sext.w	s1,a5
    if (c == 0)
    80000644:	cbed                	beqz	a5,80000736 <printf+0x1ac>
    switch (c)
    80000646:	05778a63          	beq	a5,s7,8000069a <printf+0x110>
    8000064a:	02fbf663          	bgeu	s7,a5,80000676 <printf+0xec>
    8000064e:	09978863          	beq	a5,s9,800006de <printf+0x154>
    80000652:	07800713          	li	a4,120
    80000656:	0ce79563          	bne	a5,a4,80000720 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000065a:	f8843783          	ld	a5,-120(s0)
    8000065e:	00878713          	addi	a4,a5,8
    80000662:	f8e43423          	sd	a4,-120(s0)
    80000666:	4605                	li	a2,1
    80000668:	85ea                	mv	a1,s10
    8000066a:	4388                	lw	a0,0(a5)
    8000066c:	00000097          	auipc	ra,0x0
    80000670:	e30080e7          	jalr	-464(ra) # 8000049c <printint>
      break;
    80000674:	bf45                	j	80000624 <printf+0x9a>
    switch (c)
    80000676:	09578f63          	beq	a5,s5,80000714 <printf+0x18a>
    8000067a:	0b879363          	bne	a5,s8,80000720 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067e:	f8843783          	ld	a5,-120(s0)
    80000682:	00878713          	addi	a4,a5,8
    80000686:	f8e43423          	sd	a4,-120(s0)
    8000068a:	4605                	li	a2,1
    8000068c:	45a9                	li	a1,10
    8000068e:	4388                	lw	a0,0(a5)
    80000690:	00000097          	auipc	ra,0x0
    80000694:	e0c080e7          	jalr	-500(ra) # 8000049c <printint>
      break;
    80000698:	b771                	j	80000624 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000069a:	f8843783          	ld	a5,-120(s0)
    8000069e:	00878713          	addi	a4,a5,8
    800006a2:	f8e43423          	sd	a4,-120(s0)
    800006a6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006aa:	03000513          	li	a0,48
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	bce080e7          	jalr	-1074(ra) # 8000027c <consputc>
  consputc('x');
    800006b6:	07800513          	li	a0,120
    800006ba:	00000097          	auipc	ra,0x0
    800006be:	bc2080e7          	jalr	-1086(ra) # 8000027c <consputc>
    800006c2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c4:	03c95793          	srli	a5,s2,0x3c
    800006c8:	97da                	add	a5,a5,s6
    800006ca:	0007c503          	lbu	a0,0(a5)
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	bae080e7          	jalr	-1106(ra) # 8000027c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d6:	0912                	slli	s2,s2,0x4
    800006d8:	34fd                	addiw	s1,s1,-1
    800006da:	f4ed                	bnez	s1,800006c4 <printf+0x13a>
    800006dc:	b7a1                	j	80000624 <printf+0x9a>
      if ((s = va_arg(ap, char *)) == 0)
    800006de:	f8843783          	ld	a5,-120(s0)
    800006e2:	00878713          	addi	a4,a5,8
    800006e6:	f8e43423          	sd	a4,-120(s0)
    800006ea:	6384                	ld	s1,0(a5)
    800006ec:	cc89                	beqz	s1,80000706 <printf+0x17c>
      for (; *s; s++)
    800006ee:	0004c503          	lbu	a0,0(s1)
    800006f2:	d90d                	beqz	a0,80000624 <printf+0x9a>
        consputc(*s);
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	b88080e7          	jalr	-1144(ra) # 8000027c <consputc>
      for (; *s; s++)
    800006fc:	0485                	addi	s1,s1,1
    800006fe:	0004c503          	lbu	a0,0(s1)
    80000702:	f96d                	bnez	a0,800006f4 <printf+0x16a>
    80000704:	b705                	j	80000624 <printf+0x9a>
        s = "(null)";
    80000706:	00009497          	auipc	s1,0x9
    8000070a:	91a48493          	addi	s1,s1,-1766 # 80009020 <etext+0x20>
      for (; *s; s++)
    8000070e:	02800513          	li	a0,40
    80000712:	b7cd                	j	800006f4 <printf+0x16a>
      consputc('%');
    80000714:	8556                	mv	a0,s5
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	b66080e7          	jalr	-1178(ra) # 8000027c <consputc>
      break;
    8000071e:	b719                	j	80000624 <printf+0x9a>
      consputc('%');
    80000720:	8556                	mv	a0,s5
    80000722:	00000097          	auipc	ra,0x0
    80000726:	b5a080e7          	jalr	-1190(ra) # 8000027c <consputc>
      consputc(c);
    8000072a:	8526                	mv	a0,s1
    8000072c:	00000097          	auipc	ra,0x0
    80000730:	b50080e7          	jalr	-1200(ra) # 8000027c <consputc>
      break;
    80000734:	bdc5                	j	80000624 <printf+0x9a>
  if (locking)
    80000736:	020d9163          	bnez	s11,80000758 <printf+0x1ce>
}
    8000073a:	70e6                	ld	ra,120(sp)
    8000073c:	7446                	ld	s0,112(sp)
    8000073e:	74a6                	ld	s1,104(sp)
    80000740:	7906                	ld	s2,96(sp)
    80000742:	69e6                	ld	s3,88(sp)
    80000744:	6a46                	ld	s4,80(sp)
    80000746:	6aa6                	ld	s5,72(sp)
    80000748:	6b06                	ld	s6,64(sp)
    8000074a:	7be2                	ld	s7,56(sp)
    8000074c:	7c42                	ld	s8,48(sp)
    8000074e:	7ca2                	ld	s9,40(sp)
    80000750:	7d02                	ld	s10,32(sp)
    80000752:	6de2                	ld	s11,24(sp)
    80000754:	6129                	addi	sp,sp,192
    80000756:	8082                	ret
    release(&pr.lock);
    80000758:	00011517          	auipc	a0,0x11
    8000075c:	68050513          	addi	a0,a0,1664 # 80011dd8 <pr>
    80000760:	00000097          	auipc	ra,0x0
    80000764:	648080e7          	jalr	1608(ra) # 80000da8 <release>
}
    80000768:	bfc9                	j	8000073a <printf+0x1b0>

000000008000076a <printfinit>:
    ;
}

void printfinit(void)
{
    8000076a:	1101                	addi	sp,sp,-32
    8000076c:	ec06                	sd	ra,24(sp)
    8000076e:	e822                	sd	s0,16(sp)
    80000770:	e426                	sd	s1,8(sp)
    80000772:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000774:	00011497          	auipc	s1,0x11
    80000778:	66448493          	addi	s1,s1,1636 # 80011dd8 <pr>
    8000077c:	00009597          	auipc	a1,0x9
    80000780:	8bc58593          	addi	a1,a1,-1860 # 80009038 <etext+0x38>
    80000784:	8526                	mv	a0,s1
    80000786:	00000097          	auipc	ra,0x0
    8000078a:	4de080e7          	jalr	1246(ra) # 80000c64 <initlock>
  pr.locking = 1;
    8000078e:	4785                	li	a5,1
    80000790:	cc9c                	sw	a5,24(s1)
}
    80000792:	60e2                	ld	ra,24(sp)
    80000794:	6442                	ld	s0,16(sp)
    80000796:	64a2                	ld	s1,8(sp)
    80000798:	6105                	addi	sp,sp,32
    8000079a:	8082                	ret

000000008000079c <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000079c:	1141                	addi	sp,sp,-16
    8000079e:	e406                	sd	ra,8(sp)
    800007a0:	e022                	sd	s0,0(sp)
    800007a2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a4:	100007b7          	lui	a5,0x10000
    800007a8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ac:	f8000713          	li	a4,-128
    800007b0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b4:	470d                	li	a4,3
    800007b6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007ba:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007be:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c2:	469d                	li	a3,7
    800007c4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007cc:	00009597          	auipc	a1,0x9
    800007d0:	88c58593          	addi	a1,a1,-1908 # 80009058 <digits+0x18>
    800007d4:	00011517          	auipc	a0,0x11
    800007d8:	62450513          	addi	a0,a0,1572 # 80011df8 <uart_tx_lock>
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	488080e7          	jalr	1160(ra) # 80000c64 <initlock>
}
    800007e4:	60a2                	ld	ra,8(sp)
    800007e6:	6402                	ld	s0,0(sp)
    800007e8:	0141                	addi	sp,sp,16
    800007ea:	8082                	ret

00000000800007ec <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007ec:	1101                	addi	sp,sp,-32
    800007ee:	ec06                	sd	ra,24(sp)
    800007f0:	e822                	sd	s0,16(sp)
    800007f2:	e426                	sd	s1,8(sp)
    800007f4:	1000                	addi	s0,sp,32
    800007f6:	84aa                	mv	s1,a0
  push_off();
    800007f8:	00000097          	auipc	ra,0x0
    800007fc:	4b0080e7          	jalr	1200(ra) # 80000ca8 <push_off>

  if(panicked){
    80000800:	00009797          	auipc	a5,0x9
    80000804:	3b07a783          	lw	a5,944(a5) # 80009bb0 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000808:	10000737          	lui	a4,0x10000
  if(panicked){
    8000080c:	c391                	beqz	a5,80000810 <uartputc_sync+0x24>
    for(;;)
    8000080e:	a001                	j	8000080e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000810:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000814:	0207f793          	andi	a5,a5,32
    80000818:	dfe5                	beqz	a5,80000810 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000081a:	0ff4f513          	zext.b	a0,s1
    8000081e:	100007b7          	lui	a5,0x10000
    80000822:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	522080e7          	jalr	1314(ra) # 80000d48 <pop_off>
}
    8000082e:	60e2                	ld	ra,24(sp)
    80000830:	6442                	ld	s0,16(sp)
    80000832:	64a2                	ld	s1,8(sp)
    80000834:	6105                	addi	sp,sp,32
    80000836:	8082                	ret

0000000080000838 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000838:	00009797          	auipc	a5,0x9
    8000083c:	3807b783          	ld	a5,896(a5) # 80009bb8 <uart_tx_r>
    80000840:	00009717          	auipc	a4,0x9
    80000844:	38073703          	ld	a4,896(a4) # 80009bc0 <uart_tx_w>
    80000848:	06f70a63          	beq	a4,a5,800008bc <uartstart+0x84>
{
    8000084c:	7139                	addi	sp,sp,-64
    8000084e:	fc06                	sd	ra,56(sp)
    80000850:	f822                	sd	s0,48(sp)
    80000852:	f426                	sd	s1,40(sp)
    80000854:	f04a                	sd	s2,32(sp)
    80000856:	ec4e                	sd	s3,24(sp)
    80000858:	e852                	sd	s4,16(sp)
    8000085a:	e456                	sd	s5,8(sp)
    8000085c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000862:	00011a17          	auipc	s4,0x11
    80000866:	596a0a13          	addi	s4,s4,1430 # 80011df8 <uart_tx_lock>
    uart_tx_r += 1;
    8000086a:	00009497          	auipc	s1,0x9
    8000086e:	34e48493          	addi	s1,s1,846 # 80009bb8 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000872:	00009997          	auipc	s3,0x9
    80000876:	34e98993          	addi	s3,s3,846 # 80009bc0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000087a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087e:	02077713          	andi	a4,a4,32
    80000882:	c705                	beqz	a4,800008aa <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000884:	01f7f713          	andi	a4,a5,31
    80000888:	9752                	add	a4,a4,s4
    8000088a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088e:	0785                	addi	a5,a5,1
    80000890:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000892:	8526                	mv	a0,s1
    80000894:	00002097          	auipc	ra,0x2
    80000898:	c74080e7          	jalr	-908(ra) # 80002508 <wakeup>
    
    WriteReg(THR, c);
    8000089c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008a0:	609c                	ld	a5,0(s1)
    800008a2:	0009b703          	ld	a4,0(s3)
    800008a6:	fcf71ae3          	bne	a4,a5,8000087a <uartstart+0x42>
  }
}
    800008aa:	70e2                	ld	ra,56(sp)
    800008ac:	7442                	ld	s0,48(sp)
    800008ae:	74a2                	ld	s1,40(sp)
    800008b0:	7902                	ld	s2,32(sp)
    800008b2:	69e2                	ld	s3,24(sp)
    800008b4:	6a42                	ld	s4,16(sp)
    800008b6:	6aa2                	ld	s5,8(sp)
    800008b8:	6121                	addi	sp,sp,64
    800008ba:	8082                	ret
    800008bc:	8082                	ret

00000000800008be <uartputc>:
{
    800008be:	7179                	addi	sp,sp,-48
    800008c0:	f406                	sd	ra,40(sp)
    800008c2:	f022                	sd	s0,32(sp)
    800008c4:	ec26                	sd	s1,24(sp)
    800008c6:	e84a                	sd	s2,16(sp)
    800008c8:	e44e                	sd	s3,8(sp)
    800008ca:	e052                	sd	s4,0(sp)
    800008cc:	1800                	addi	s0,sp,48
    800008ce:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008d0:	00011517          	auipc	a0,0x11
    800008d4:	52850513          	addi	a0,a0,1320 # 80011df8 <uart_tx_lock>
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	41c080e7          	jalr	1052(ra) # 80000cf4 <acquire>
  if(panicked){
    800008e0:	00009797          	auipc	a5,0x9
    800008e4:	2d07a783          	lw	a5,720(a5) # 80009bb0 <panicked>
    800008e8:	e7c9                	bnez	a5,80000972 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008ea:	00009717          	auipc	a4,0x9
    800008ee:	2d673703          	ld	a4,726(a4) # 80009bc0 <uart_tx_w>
    800008f2:	00009797          	auipc	a5,0x9
    800008f6:	2c67b783          	ld	a5,710(a5) # 80009bb8 <uart_tx_r>
    800008fa:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fe:	00011997          	auipc	s3,0x11
    80000902:	4fa98993          	addi	s3,s3,1274 # 80011df8 <uart_tx_lock>
    80000906:	00009497          	auipc	s1,0x9
    8000090a:	2b248493          	addi	s1,s1,690 # 80009bb8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090e:	00009917          	auipc	s2,0x9
    80000912:	2b290913          	addi	s2,s2,690 # 80009bc0 <uart_tx_w>
    80000916:	00e79f63          	bne	a5,a4,80000934 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000091a:	85ce                	mv	a1,s3
    8000091c:	8526                	mv	a0,s1
    8000091e:	00002097          	auipc	ra,0x2
    80000922:	b86080e7          	jalr	-1146(ra) # 800024a4 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000926:	00093703          	ld	a4,0(s2)
    8000092a:	609c                	ld	a5,0(s1)
    8000092c:	02078793          	addi	a5,a5,32
    80000930:	fee785e3          	beq	a5,a4,8000091a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000934:	00011497          	auipc	s1,0x11
    80000938:	4c448493          	addi	s1,s1,1220 # 80011df8 <uart_tx_lock>
    8000093c:	01f77793          	andi	a5,a4,31
    80000940:	97a6                	add	a5,a5,s1
    80000942:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000946:	0705                	addi	a4,a4,1
    80000948:	00009797          	auipc	a5,0x9
    8000094c:	26e7bc23          	sd	a4,632(a5) # 80009bc0 <uart_tx_w>
  uartstart();
    80000950:	00000097          	auipc	ra,0x0
    80000954:	ee8080e7          	jalr	-280(ra) # 80000838 <uartstart>
  release(&uart_tx_lock);
    80000958:	8526                	mv	a0,s1
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	44e080e7          	jalr	1102(ra) # 80000da8 <release>
}
    80000962:	70a2                	ld	ra,40(sp)
    80000964:	7402                	ld	s0,32(sp)
    80000966:	64e2                	ld	s1,24(sp)
    80000968:	6942                	ld	s2,16(sp)
    8000096a:	69a2                	ld	s3,8(sp)
    8000096c:	6a02                	ld	s4,0(sp)
    8000096e:	6145                	addi	sp,sp,48
    80000970:	8082                	ret
    for(;;)
    80000972:	a001                	j	80000972 <uartputc+0xb4>

0000000080000974 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000974:	1141                	addi	sp,sp,-16
    80000976:	e422                	sd	s0,8(sp)
    80000978:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000097a:	100007b7          	lui	a5,0x10000
    8000097e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000982:	8b85                	andi	a5,a5,1
    80000984:	cb81                	beqz	a5,80000994 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80000986:	100007b7          	lui	a5,0x10000
    8000098a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000098e:	6422                	ld	s0,8(sp)
    80000990:	0141                	addi	sp,sp,16
    80000992:	8082                	ret
    return -1;
    80000994:	557d                	li	a0,-1
    80000996:	bfe5                	j	8000098e <uartgetc+0x1a>

0000000080000998 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000998:	1101                	addi	sp,sp,-32
    8000099a:	ec06                	sd	ra,24(sp)
    8000099c:	e822                	sd	s0,16(sp)
    8000099e:	e426                	sd	s1,8(sp)
    800009a0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009a2:	54fd                	li	s1,-1
    800009a4:	a029                	j	800009ae <uartintr+0x16>
      break;
    consoleintr(c);
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	918080e7          	jalr	-1768(ra) # 800002be <consoleintr>
    int c = uartgetc();
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	fc6080e7          	jalr	-58(ra) # 80000974 <uartgetc>
    if(c == -1)
    800009b6:	fe9518e3          	bne	a0,s1,800009a6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009ba:	00011497          	auipc	s1,0x11
    800009be:	43e48493          	addi	s1,s1,1086 # 80011df8 <uart_tx_lock>
    800009c2:	8526                	mv	a0,s1
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	330080e7          	jalr	816(ra) # 80000cf4 <acquire>
  uartstart();
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	e6c080e7          	jalr	-404(ra) # 80000838 <uartstart>
  release(&uart_tx_lock);
    800009d4:	8526                	mv	a0,s1
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	3d2080e7          	jalr	978(ra) # 80000da8 <release>
}
    800009de:	60e2                	ld	ra,24(sp)
    800009e0:	6442                	ld	s0,16(sp)
    800009e2:	64a2                	ld	s1,8(sp)
    800009e4:	6105                	addi	sp,sp,32
    800009e6:	8082                	ret

00000000800009e8 <inc_page_ref>:
//   }
//   cow_.count[(uint64)pa/PGSIZE]-=1;
//   release(&cow_.lock);
// }

void inc_page_ref(void*pa){
    800009e8:	1101                	addi	sp,sp,-32
    800009ea:	ec06                	sd	ra,24(sp)
    800009ec:	e822                	sd	s0,16(sp)
    800009ee:	e426                	sd	s1,8(sp)
    800009f0:	1000                	addi	s0,sp,32
    800009f2:	84aa                	mv	s1,a0
  acquire(&cow_.lock);
    800009f4:	00011517          	auipc	a0,0x11
    800009f8:	45c50513          	addi	a0,a0,1116 # 80011e50 <cow_>
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	2f8080e7          	jalr	760(ra) # 80000cf4 <acquire>
  if(cow_.count[(uint64)pa/PGSIZE]<0){
    80000a04:	00c4d793          	srli	a5,s1,0xc
    80000a08:	00478693          	addi	a3,a5,4
    80000a0c:	068a                	slli	a3,a3,0x2
    80000a0e:	00011717          	auipc	a4,0x11
    80000a12:	44270713          	addi	a4,a4,1090 # 80011e50 <cow_>
    80000a16:	9736                	add	a4,a4,a3
    80000a18:	4718                	lw	a4,8(a4)
    80000a1a:	02074463          	bltz	a4,80000a42 <inc_page_ref+0x5a>
    panic("inc_page_ref");
  }
  cow_.count[(uint64)pa/PGSIZE]+=1;
    80000a1e:	00011517          	auipc	a0,0x11
    80000a22:	43250513          	addi	a0,a0,1074 # 80011e50 <cow_>
    80000a26:	0791                	addi	a5,a5,4
    80000a28:	078a                	slli	a5,a5,0x2
    80000a2a:	97aa                	add	a5,a5,a0
    80000a2c:	2705                	addiw	a4,a4,1
    80000a2e:	c798                	sw	a4,8(a5)
  release(&cow_.lock);
    80000a30:	00000097          	auipc	ra,0x0
    80000a34:	378080e7          	jalr	888(ra) # 80000da8 <release>
}
    80000a38:	60e2                	ld	ra,24(sp)
    80000a3a:	6442                	ld	s0,16(sp)
    80000a3c:	64a2                	ld	s1,8(sp)
    80000a3e:	6105                	addi	sp,sp,32
    80000a40:	8082                	ret
    panic("inc_page_ref");
    80000a42:	00008517          	auipc	a0,0x8
    80000a46:	61e50513          	addi	a0,a0,1566 # 80009060 <digits+0x20>
    80000a4a:	00000097          	auipc	ra,0x0
    80000a4e:	af6080e7          	jalr	-1290(ra) # 80000540 <panic>

0000000080000a52 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a52:	1101                	addi	sp,sp,-32
    80000a54:	ec06                	sd	ra,24(sp)
    80000a56:	e822                	sd	s0,16(sp)
    80000a58:	e426                	sd	s1,8(sp)
    80000a5a:	e04a                	sd	s2,0(sp)
    80000a5c:	1000                	addi	s0,sp,32
    80000a5e:	84aa                	mv	s1,a0
  struct run *r;

  // if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
  //   panic("kfree");

  acquire(&cow_.lock);
    80000a60:	00011517          	auipc	a0,0x11
    80000a64:	3f050513          	addi	a0,a0,1008 # 80011e50 <cow_>
    80000a68:	00000097          	auipc	ra,0x0
    80000a6c:	28c080e7          	jalr	652(ra) # 80000cf4 <acquire>
  if(cow_.count[(uint64)pa/PGSIZE]<=0){
    80000a70:	00c4d793          	srli	a5,s1,0xc
    80000a74:	00478693          	addi	a3,a5,4
    80000a78:	068a                	slli	a3,a3,0x2
    80000a7a:	00011717          	auipc	a4,0x11
    80000a7e:	3d670713          	addi	a4,a4,982 # 80011e50 <cow_>
    80000a82:	9736                	add	a4,a4,a3
    80000a84:	4718                	lw	a4,8(a4)
    80000a86:	06e05763          	blez	a4,80000af4 <kfree+0xa2>
    panic("dec_page_ref");
  }
  cow_.count[(uint64)pa/PGSIZE]-=1;
    80000a8a:	377d                	addiw	a4,a4,-1
    80000a8c:	0007061b          	sext.w	a2,a4
    80000a90:	0791                	addi	a5,a5,4
    80000a92:	078a                	slli	a5,a5,0x2
    80000a94:	00011697          	auipc	a3,0x11
    80000a98:	3bc68693          	addi	a3,a3,956 # 80011e50 <cow_>
    80000a9c:	97b6                	add	a5,a5,a3
    80000a9e:	c798                	sw	a4,8(a5)
  if(cow_.count[(uint64)pa/PGSIZE]>0){
    80000aa0:	06c04263          	bgtz	a2,80000b04 <kfree+0xb2>
    release(&cow_.lock);
    return;
  }
  release(&cow_.lock);
    80000aa4:	00011517          	auipc	a0,0x11
    80000aa8:	3ac50513          	addi	a0,a0,940 # 80011e50 <cow_>
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	2fc080e7          	jalr	764(ra) # 80000da8 <release>
  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000ab4:	6605                	lui	a2,0x1
    80000ab6:	4585                	li	a1,1
    80000ab8:	8526                	mv	a0,s1
    80000aba:	00000097          	auipc	ra,0x0
    80000abe:	336080e7          	jalr	822(ra) # 80000df0 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000ac2:	00011917          	auipc	s2,0x11
    80000ac6:	36e90913          	addi	s2,s2,878 # 80011e30 <kmem>
    80000aca:	854a                	mv	a0,s2
    80000acc:	00000097          	auipc	ra,0x0
    80000ad0:	228080e7          	jalr	552(ra) # 80000cf4 <acquire>
  r->next = kmem.freelist;
    80000ad4:	01893783          	ld	a5,24(s2)
    80000ad8:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000ada:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000ade:	854a                	mv	a0,s2
    80000ae0:	00000097          	auipc	ra,0x0
    80000ae4:	2c8080e7          	jalr	712(ra) # 80000da8 <release>
}
    80000ae8:	60e2                	ld	ra,24(sp)
    80000aea:	6442                	ld	s0,16(sp)
    80000aec:	64a2                	ld	s1,8(sp)
    80000aee:	6902                	ld	s2,0(sp)
    80000af0:	6105                	addi	sp,sp,32
    80000af2:	8082                	ret
    panic("dec_page_ref");
    80000af4:	00008517          	auipc	a0,0x8
    80000af8:	57c50513          	addi	a0,a0,1404 # 80009070 <digits+0x30>
    80000afc:	00000097          	auipc	ra,0x0
    80000b00:	a44080e7          	jalr	-1468(ra) # 80000540 <panic>
    release(&cow_.lock);
    80000b04:	8536                	mv	a0,a3
    80000b06:	00000097          	auipc	ra,0x0
    80000b0a:	2a2080e7          	jalr	674(ra) # 80000da8 <release>
    return;
    80000b0e:	bfe9                	j	80000ae8 <kfree+0x96>

0000000080000b10 <freerange>:
{
    80000b10:	7139                	addi	sp,sp,-64
    80000b12:	fc06                	sd	ra,56(sp)
    80000b14:	f822                	sd	s0,48(sp)
    80000b16:	f426                	sd	s1,40(sp)
    80000b18:	f04a                	sd	s2,32(sp)
    80000b1a:	ec4e                	sd	s3,24(sp)
    80000b1c:	e852                	sd	s4,16(sp)
    80000b1e:	e456                	sd	s5,8(sp)
    80000b20:	0080                	addi	s0,sp,64
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000b22:	6785                	lui	a5,0x1
    80000b24:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000b28:	00e504b3          	add	s1,a0,a4
    80000b2c:	777d                	lui	a4,0xfffff
    80000b2e:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000b30:	94be                	add	s1,s1,a5
    80000b32:	0295e463          	bltu	a1,s1,80000b5a <freerange+0x4a>
    80000b36:	89ae                	mv	s3,a1
    80000b38:	7afd                	lui	s5,0xfffff
    80000b3a:	6a05                	lui	s4,0x1
    80000b3c:	01548933          	add	s2,s1,s5
    inc_page_ref(p);
    80000b40:	854a                	mv	a0,s2
    80000b42:	00000097          	auipc	ra,0x0
    80000b46:	ea6080e7          	jalr	-346(ra) # 800009e8 <inc_page_ref>
    kfree(p);
    80000b4a:	854a                	mv	a0,s2
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	f06080e7          	jalr	-250(ra) # 80000a52 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000b54:	94d2                	add	s1,s1,s4
    80000b56:	fe99f3e3          	bgeu	s3,s1,80000b3c <freerange+0x2c>
}
    80000b5a:	70e2                	ld	ra,56(sp)
    80000b5c:	7442                	ld	s0,48(sp)
    80000b5e:	74a2                	ld	s1,40(sp)
    80000b60:	7902                	ld	s2,32(sp)
    80000b62:	69e2                	ld	s3,24(sp)
    80000b64:	6a42                	ld	s4,16(sp)
    80000b66:	6aa2                	ld	s5,8(sp)
    80000b68:	6121                	addi	sp,sp,64
    80000b6a:	8082                	ret

0000000080000b6c <kinit>:
{
    80000b6c:	1141                	addi	sp,sp,-16
    80000b6e:	e406                	sd	ra,8(sp)
    80000b70:	e022                	sd	s0,0(sp)
    80000b72:	0800                	addi	s0,sp,16
  initlock(&cow_.lock, "cow_");
    80000b74:	00008597          	auipc	a1,0x8
    80000b78:	50c58593          	addi	a1,a1,1292 # 80009080 <digits+0x40>
    80000b7c:	00011517          	auipc	a0,0x11
    80000b80:	2d450513          	addi	a0,a0,724 # 80011e50 <cow_>
    80000b84:	00000097          	auipc	ra,0x0
    80000b88:	0e0080e7          	jalr	224(ra) # 80000c64 <initlock>
  acquire(&cow_.lock);
    80000b8c:	00011517          	auipc	a0,0x11
    80000b90:	2c450513          	addi	a0,a0,708 # 80011e50 <cow_>
    80000b94:	00000097          	auipc	ra,0x0
    80000b98:	160080e7          	jalr	352(ra) # 80000cf4 <acquire>
  for(int i=0;i<(PGROUNDUP(PHYSTOP)/PGSIZE);++i)
    80000b9c:	00011797          	auipc	a5,0x11
    80000ba0:	2cc78793          	addi	a5,a5,716 # 80011e68 <cow_+0x18>
    80000ba4:	00231717          	auipc	a4,0x231
    80000ba8:	2c470713          	addi	a4,a4,708 # 80231e68 <pid_lock>
    cow_.count[i]=0;
    80000bac:	0007a023          	sw	zero,0(a5)
  for(int i=0;i<(PGROUNDUP(PHYSTOP)/PGSIZE);++i)
    80000bb0:	0791                	addi	a5,a5,4
    80000bb2:	fee79de3          	bne	a5,a4,80000bac <kinit+0x40>
  release(&cow_.lock);
    80000bb6:	00011517          	auipc	a0,0x11
    80000bba:	29a50513          	addi	a0,a0,666 # 80011e50 <cow_>
    80000bbe:	00000097          	auipc	ra,0x0
    80000bc2:	1ea080e7          	jalr	490(ra) # 80000da8 <release>
  initlock(&kmem.lock, "kmem");
    80000bc6:	00008597          	auipc	a1,0x8
    80000bca:	4c258593          	addi	a1,a1,1218 # 80009088 <digits+0x48>
    80000bce:	00011517          	auipc	a0,0x11
    80000bd2:	26250513          	addi	a0,a0,610 # 80011e30 <kmem>
    80000bd6:	00000097          	auipc	ra,0x0
    80000bda:	08e080e7          	jalr	142(ra) # 80000c64 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000bde:	45c5                	li	a1,17
    80000be0:	05ee                	slli	a1,a1,0x1b
    80000be2:	00246517          	auipc	a0,0x246
    80000be6:	26650513          	addi	a0,a0,614 # 80246e48 <end>
    80000bea:	00000097          	auipc	ra,0x0
    80000bee:	f26080e7          	jalr	-218(ra) # 80000b10 <freerange>
}
    80000bf2:	60a2                	ld	ra,8(sp)
    80000bf4:	6402                	ld	s0,0(sp)
    80000bf6:	0141                	addi	sp,sp,16
    80000bf8:	8082                	ret

0000000080000bfa <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000bfa:	1101                	addi	sp,sp,-32
    80000bfc:	ec06                	sd	ra,24(sp)
    80000bfe:	e822                	sd	s0,16(sp)
    80000c00:	e426                	sd	s1,8(sp)
    80000c02:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000c04:	00011497          	auipc	s1,0x11
    80000c08:	22c48493          	addi	s1,s1,556 # 80011e30 <kmem>
    80000c0c:	8526                	mv	a0,s1
    80000c0e:	00000097          	auipc	ra,0x0
    80000c12:	0e6080e7          	jalr	230(ra) # 80000cf4 <acquire>
  r = kmem.freelist;
    80000c16:	6c84                	ld	s1,24(s1)
  if(r)
    80000c18:	cc8d                	beqz	s1,80000c52 <kalloc+0x58>
    kmem.freelist = r->next;
    80000c1a:	609c                	ld	a5,0(s1)
    80000c1c:	00011517          	auipc	a0,0x11
    80000c20:	21450513          	addi	a0,a0,532 # 80011e30 <kmem>
    80000c24:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000c26:	00000097          	auipc	ra,0x0
    80000c2a:	182080e7          	jalr	386(ra) # 80000da8 <release>

  if(r){
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000c2e:	6605                	lui	a2,0x1
    80000c30:	4595                	li	a1,5
    80000c32:	8526                	mv	a0,s1
    80000c34:	00000097          	auipc	ra,0x0
    80000c38:	1bc080e7          	jalr	444(ra) # 80000df0 <memset>
    inc_page_ref((void*)r);
    80000c3c:	8526                	mv	a0,s1
    80000c3e:	00000097          	auipc	ra,0x0
    80000c42:	daa080e7          	jalr	-598(ra) # 800009e8 <inc_page_ref>
  }  
  return (void*)r;
}
    80000c46:	8526                	mv	a0,s1
    80000c48:	60e2                	ld	ra,24(sp)
    80000c4a:	6442                	ld	s0,16(sp)
    80000c4c:	64a2                	ld	s1,8(sp)
    80000c4e:	6105                	addi	sp,sp,32
    80000c50:	8082                	ret
  release(&kmem.lock);
    80000c52:	00011517          	auipc	a0,0x11
    80000c56:	1de50513          	addi	a0,a0,478 # 80011e30 <kmem>
    80000c5a:	00000097          	auipc	ra,0x0
    80000c5e:	14e080e7          	jalr	334(ra) # 80000da8 <release>
  if(r){
    80000c62:	b7d5                	j	80000c46 <kalloc+0x4c>

0000000080000c64 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000c64:	1141                	addi	sp,sp,-16
    80000c66:	e422                	sd	s0,8(sp)
    80000c68:	0800                	addi	s0,sp,16
  lk->name = name;
    80000c6a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000c6c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000c70:	00053823          	sd	zero,16(a0)
}
    80000c74:	6422                	ld	s0,8(sp)
    80000c76:	0141                	addi	sp,sp,16
    80000c78:	8082                	ret

0000000080000c7a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000c7a:	411c                	lw	a5,0(a0)
    80000c7c:	e399                	bnez	a5,80000c82 <holding+0x8>
    80000c7e:	4501                	li	a0,0
  return r;
}
    80000c80:	8082                	ret
{
    80000c82:	1101                	addi	sp,sp,-32
    80000c84:	ec06                	sd	ra,24(sp)
    80000c86:	e822                	sd	s0,16(sp)
    80000c88:	e426                	sd	s1,8(sp)
    80000c8a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000c8c:	6904                	ld	s1,16(a0)
    80000c8e:	00001097          	auipc	ra,0x1
    80000c92:	e66080e7          	jalr	-410(ra) # 80001af4 <mycpu>
    80000c96:	40a48533          	sub	a0,s1,a0
    80000c9a:	00153513          	seqz	a0,a0
}
    80000c9e:	60e2                	ld	ra,24(sp)
    80000ca0:	6442                	ld	s0,16(sp)
    80000ca2:	64a2                	ld	s1,8(sp)
    80000ca4:	6105                	addi	sp,sp,32
    80000ca6:	8082                	ret

0000000080000ca8 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000ca8:	1101                	addi	sp,sp,-32
    80000caa:	ec06                	sd	ra,24(sp)
    80000cac:	e822                	sd	s0,16(sp)
    80000cae:	e426                	sd	s1,8(sp)
    80000cb0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus"
    80000cb2:	100024f3          	csrr	s1,sstatus
    80000cb6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000cba:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0"
    80000cbc:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000cc0:	00001097          	auipc	ra,0x1
    80000cc4:	e34080e7          	jalr	-460(ra) # 80001af4 <mycpu>
    80000cc8:	5d3c                	lw	a5,120(a0)
    80000cca:	cf89                	beqz	a5,80000ce4 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000ccc:	00001097          	auipc	ra,0x1
    80000cd0:	e28080e7          	jalr	-472(ra) # 80001af4 <mycpu>
    80000cd4:	5d3c                	lw	a5,120(a0)
    80000cd6:	2785                	addiw	a5,a5,1
    80000cd8:	dd3c                	sw	a5,120(a0)
}
    80000cda:	60e2                	ld	ra,24(sp)
    80000cdc:	6442                	ld	s0,16(sp)
    80000cde:	64a2                	ld	s1,8(sp)
    80000ce0:	6105                	addi	sp,sp,32
    80000ce2:	8082                	ret
    mycpu()->intena = old;
    80000ce4:	00001097          	auipc	ra,0x1
    80000ce8:	e10080e7          	jalr	-496(ra) # 80001af4 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000cec:	8085                	srli	s1,s1,0x1
    80000cee:	8885                	andi	s1,s1,1
    80000cf0:	dd64                	sw	s1,124(a0)
    80000cf2:	bfe9                	j	80000ccc <push_off+0x24>

0000000080000cf4 <acquire>:
{
    80000cf4:	1101                	addi	sp,sp,-32
    80000cf6:	ec06                	sd	ra,24(sp)
    80000cf8:	e822                	sd	s0,16(sp)
    80000cfa:	e426                	sd	s1,8(sp)
    80000cfc:	1000                	addi	s0,sp,32
    80000cfe:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000d00:	00000097          	auipc	ra,0x0
    80000d04:	fa8080e7          	jalr	-88(ra) # 80000ca8 <push_off>
  if(holding(lk))
    80000d08:	8526                	mv	a0,s1
    80000d0a:	00000097          	auipc	ra,0x0
    80000d0e:	f70080e7          	jalr	-144(ra) # 80000c7a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d12:	4705                	li	a4,1
  if(holding(lk))
    80000d14:	e115                	bnez	a0,80000d38 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d16:	87ba                	mv	a5,a4
    80000d18:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000d1c:	2781                	sext.w	a5,a5
    80000d1e:	ffe5                	bnez	a5,80000d16 <acquire+0x22>
  __sync_synchronize();
    80000d20:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000d24:	00001097          	auipc	ra,0x1
    80000d28:	dd0080e7          	jalr	-560(ra) # 80001af4 <mycpu>
    80000d2c:	e888                	sd	a0,16(s1)
}
    80000d2e:	60e2                	ld	ra,24(sp)
    80000d30:	6442                	ld	s0,16(sp)
    80000d32:	64a2                	ld	s1,8(sp)
    80000d34:	6105                	addi	sp,sp,32
    80000d36:	8082                	ret
    panic("acquire");
    80000d38:	00008517          	auipc	a0,0x8
    80000d3c:	35850513          	addi	a0,a0,856 # 80009090 <digits+0x50>
    80000d40:	00000097          	auipc	ra,0x0
    80000d44:	800080e7          	jalr	-2048(ra) # 80000540 <panic>

0000000080000d48 <pop_off>:

void
pop_off(void)
{
    80000d48:	1141                	addi	sp,sp,-16
    80000d4a:	e406                	sd	ra,8(sp)
    80000d4c:	e022                	sd	s0,0(sp)
    80000d4e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000d50:	00001097          	auipc	ra,0x1
    80000d54:	da4080e7          	jalr	-604(ra) # 80001af4 <mycpu>
  asm volatile("csrr %0, sstatus"
    80000d58:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000d5c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000d5e:	e78d                	bnez	a5,80000d88 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000d60:	5d3c                	lw	a5,120(a0)
    80000d62:	02f05b63          	blez	a5,80000d98 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000d66:	37fd                	addiw	a5,a5,-1
    80000d68:	0007871b          	sext.w	a4,a5
    80000d6c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000d6e:	eb09                	bnez	a4,80000d80 <pop_off+0x38>
    80000d70:	5d7c                	lw	a5,124(a0)
    80000d72:	c799                	beqz	a5,80000d80 <pop_off+0x38>
  asm volatile("csrr %0, sstatus"
    80000d74:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000d78:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0"
    80000d7c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000d80:	60a2                	ld	ra,8(sp)
    80000d82:	6402                	ld	s0,0(sp)
    80000d84:	0141                	addi	sp,sp,16
    80000d86:	8082                	ret
    panic("pop_off - interruptible");
    80000d88:	00008517          	auipc	a0,0x8
    80000d8c:	31050513          	addi	a0,a0,784 # 80009098 <digits+0x58>
    80000d90:	fffff097          	auipc	ra,0xfffff
    80000d94:	7b0080e7          	jalr	1968(ra) # 80000540 <panic>
    panic("pop_off");
    80000d98:	00008517          	auipc	a0,0x8
    80000d9c:	31850513          	addi	a0,a0,792 # 800090b0 <digits+0x70>
    80000da0:	fffff097          	auipc	ra,0xfffff
    80000da4:	7a0080e7          	jalr	1952(ra) # 80000540 <panic>

0000000080000da8 <release>:
{
    80000da8:	1101                	addi	sp,sp,-32
    80000daa:	ec06                	sd	ra,24(sp)
    80000dac:	e822                	sd	s0,16(sp)
    80000dae:	e426                	sd	s1,8(sp)
    80000db0:	1000                	addi	s0,sp,32
    80000db2:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000db4:	00000097          	auipc	ra,0x0
    80000db8:	ec6080e7          	jalr	-314(ra) # 80000c7a <holding>
    80000dbc:	c115                	beqz	a0,80000de0 <release+0x38>
  lk->cpu = 0;
    80000dbe:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000dc2:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000dc6:	0f50000f          	fence	iorw,ow
    80000dca:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000dce:	00000097          	auipc	ra,0x0
    80000dd2:	f7a080e7          	jalr	-134(ra) # 80000d48 <pop_off>
}
    80000dd6:	60e2                	ld	ra,24(sp)
    80000dd8:	6442                	ld	s0,16(sp)
    80000dda:	64a2                	ld	s1,8(sp)
    80000ddc:	6105                	addi	sp,sp,32
    80000dde:	8082                	ret
    panic("release");
    80000de0:	00008517          	auipc	a0,0x8
    80000de4:	2d850513          	addi	a0,a0,728 # 800090b8 <digits+0x78>
    80000de8:	fffff097          	auipc	ra,0xfffff
    80000dec:	758080e7          	jalr	1880(ra) # 80000540 <panic>

0000000080000df0 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000df0:	1141                	addi	sp,sp,-16
    80000df2:	e422                	sd	s0,8(sp)
    80000df4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000df6:	ca19                	beqz	a2,80000e0c <memset+0x1c>
    80000df8:	87aa                	mv	a5,a0
    80000dfa:	1602                	slli	a2,a2,0x20
    80000dfc:	9201                	srli	a2,a2,0x20
    80000dfe:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000e02:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000e06:	0785                	addi	a5,a5,1
    80000e08:	fee79de3          	bne	a5,a4,80000e02 <memset+0x12>
  }
  return dst;
}
    80000e0c:	6422                	ld	s0,8(sp)
    80000e0e:	0141                	addi	sp,sp,16
    80000e10:	8082                	ret

0000000080000e12 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000e12:	1141                	addi	sp,sp,-16
    80000e14:	e422                	sd	s0,8(sp)
    80000e16:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000e18:	ca05                	beqz	a2,80000e48 <memcmp+0x36>
    80000e1a:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000e1e:	1682                	slli	a3,a3,0x20
    80000e20:	9281                	srli	a3,a3,0x20
    80000e22:	0685                	addi	a3,a3,1
    80000e24:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000e26:	00054783          	lbu	a5,0(a0)
    80000e2a:	0005c703          	lbu	a4,0(a1)
    80000e2e:	00e79863          	bne	a5,a4,80000e3e <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000e32:	0505                	addi	a0,a0,1
    80000e34:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000e36:	fed518e3          	bne	a0,a3,80000e26 <memcmp+0x14>
  }

  return 0;
    80000e3a:	4501                	li	a0,0
    80000e3c:	a019                	j	80000e42 <memcmp+0x30>
      return *s1 - *s2;
    80000e3e:	40e7853b          	subw	a0,a5,a4
}
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	addi	sp,sp,16
    80000e46:	8082                	ret
  return 0;
    80000e48:	4501                	li	a0,0
    80000e4a:	bfe5                	j	80000e42 <memcmp+0x30>

0000000080000e4c <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000e4c:	1141                	addi	sp,sp,-16
    80000e4e:	e422                	sd	s0,8(sp)
    80000e50:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000e52:	c205                	beqz	a2,80000e72 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000e54:	02a5e263          	bltu	a1,a0,80000e78 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000e58:	1602                	slli	a2,a2,0x20
    80000e5a:	9201                	srli	a2,a2,0x20
    80000e5c:	00c587b3          	add	a5,a1,a2
{
    80000e60:	872a                	mv	a4,a0
      *d++ = *s++;
    80000e62:	0585                	addi	a1,a1,1
    80000e64:	0705                	addi	a4,a4,1
    80000e66:	fff5c683          	lbu	a3,-1(a1)
    80000e6a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000e6e:	fef59ae3          	bne	a1,a5,80000e62 <memmove+0x16>

  return dst;
}
    80000e72:	6422                	ld	s0,8(sp)
    80000e74:	0141                	addi	sp,sp,16
    80000e76:	8082                	ret
  if(s < d && s + n > d){
    80000e78:	02061693          	slli	a3,a2,0x20
    80000e7c:	9281                	srli	a3,a3,0x20
    80000e7e:	00d58733          	add	a4,a1,a3
    80000e82:	fce57be3          	bgeu	a0,a4,80000e58 <memmove+0xc>
    d += n;
    80000e86:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000e88:	fff6079b          	addiw	a5,a2,-1
    80000e8c:	1782                	slli	a5,a5,0x20
    80000e8e:	9381                	srli	a5,a5,0x20
    80000e90:	fff7c793          	not	a5,a5
    80000e94:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000e96:	177d                	addi	a4,a4,-1
    80000e98:	16fd                	addi	a3,a3,-1
    80000e9a:	00074603          	lbu	a2,0(a4)
    80000e9e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000ea2:	fee79ae3          	bne	a5,a4,80000e96 <memmove+0x4a>
    80000ea6:	b7f1                	j	80000e72 <memmove+0x26>

0000000080000ea8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000ea8:	1141                	addi	sp,sp,-16
    80000eaa:	e406                	sd	ra,8(sp)
    80000eac:	e022                	sd	s0,0(sp)
    80000eae:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000eb0:	00000097          	auipc	ra,0x0
    80000eb4:	f9c080e7          	jalr	-100(ra) # 80000e4c <memmove>
}
    80000eb8:	60a2                	ld	ra,8(sp)
    80000eba:	6402                	ld	s0,0(sp)
    80000ebc:	0141                	addi	sp,sp,16
    80000ebe:	8082                	ret

0000000080000ec0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000ec0:	1141                	addi	sp,sp,-16
    80000ec2:	e422                	sd	s0,8(sp)
    80000ec4:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000ec6:	ce11                	beqz	a2,80000ee2 <strncmp+0x22>
    80000ec8:	00054783          	lbu	a5,0(a0)
    80000ecc:	cf89                	beqz	a5,80000ee6 <strncmp+0x26>
    80000ece:	0005c703          	lbu	a4,0(a1)
    80000ed2:	00f71a63          	bne	a4,a5,80000ee6 <strncmp+0x26>
    n--, p++, q++;
    80000ed6:	367d                	addiw	a2,a2,-1
    80000ed8:	0505                	addi	a0,a0,1
    80000eda:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000edc:	f675                	bnez	a2,80000ec8 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000ede:	4501                	li	a0,0
    80000ee0:	a809                	j	80000ef2 <strncmp+0x32>
    80000ee2:	4501                	li	a0,0
    80000ee4:	a039                	j	80000ef2 <strncmp+0x32>
  if(n == 0)
    80000ee6:	ca09                	beqz	a2,80000ef8 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000ee8:	00054503          	lbu	a0,0(a0)
    80000eec:	0005c783          	lbu	a5,0(a1)
    80000ef0:	9d1d                	subw	a0,a0,a5
}
    80000ef2:	6422                	ld	s0,8(sp)
    80000ef4:	0141                	addi	sp,sp,16
    80000ef6:	8082                	ret
    return 0;
    80000ef8:	4501                	li	a0,0
    80000efa:	bfe5                	j	80000ef2 <strncmp+0x32>

0000000080000efc <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000efc:	1141                	addi	sp,sp,-16
    80000efe:	e422                	sd	s0,8(sp)
    80000f00:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000f02:	872a                	mv	a4,a0
    80000f04:	8832                	mv	a6,a2
    80000f06:	367d                	addiw	a2,a2,-1
    80000f08:	01005963          	blez	a6,80000f1a <strncpy+0x1e>
    80000f0c:	0705                	addi	a4,a4,1
    80000f0e:	0005c783          	lbu	a5,0(a1)
    80000f12:	fef70fa3          	sb	a5,-1(a4)
    80000f16:	0585                	addi	a1,a1,1
    80000f18:	f7f5                	bnez	a5,80000f04 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000f1a:	86ba                	mv	a3,a4
    80000f1c:	00c05c63          	blez	a2,80000f34 <strncpy+0x38>
    *s++ = 0;
    80000f20:	0685                	addi	a3,a3,1
    80000f22:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000f26:	40d707bb          	subw	a5,a4,a3
    80000f2a:	37fd                	addiw	a5,a5,-1
    80000f2c:	010787bb          	addw	a5,a5,a6
    80000f30:	fef048e3          	bgtz	a5,80000f20 <strncpy+0x24>
  return os;
}
    80000f34:	6422                	ld	s0,8(sp)
    80000f36:	0141                	addi	sp,sp,16
    80000f38:	8082                	ret

0000000080000f3a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000f3a:	1141                	addi	sp,sp,-16
    80000f3c:	e422                	sd	s0,8(sp)
    80000f3e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000f40:	02c05363          	blez	a2,80000f66 <safestrcpy+0x2c>
    80000f44:	fff6069b          	addiw	a3,a2,-1
    80000f48:	1682                	slli	a3,a3,0x20
    80000f4a:	9281                	srli	a3,a3,0x20
    80000f4c:	96ae                	add	a3,a3,a1
    80000f4e:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000f50:	00d58963          	beq	a1,a3,80000f62 <safestrcpy+0x28>
    80000f54:	0585                	addi	a1,a1,1
    80000f56:	0785                	addi	a5,a5,1
    80000f58:	fff5c703          	lbu	a4,-1(a1)
    80000f5c:	fee78fa3          	sb	a4,-1(a5)
    80000f60:	fb65                	bnez	a4,80000f50 <safestrcpy+0x16>
    ;
  *s = 0;
    80000f62:	00078023          	sb	zero,0(a5)
  return os;
}
    80000f66:	6422                	ld	s0,8(sp)
    80000f68:	0141                	addi	sp,sp,16
    80000f6a:	8082                	ret

0000000080000f6c <strlen>:

int
strlen(const char *s)
{
    80000f6c:	1141                	addi	sp,sp,-16
    80000f6e:	e422                	sd	s0,8(sp)
    80000f70:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000f72:	00054783          	lbu	a5,0(a0)
    80000f76:	cf91                	beqz	a5,80000f92 <strlen+0x26>
    80000f78:	0505                	addi	a0,a0,1
    80000f7a:	87aa                	mv	a5,a0
    80000f7c:	4685                	li	a3,1
    80000f7e:	9e89                	subw	a3,a3,a0
    80000f80:	00f6853b          	addw	a0,a3,a5
    80000f84:	0785                	addi	a5,a5,1
    80000f86:	fff7c703          	lbu	a4,-1(a5)
    80000f8a:	fb7d                	bnez	a4,80000f80 <strlen+0x14>
    ;
  return n;
}
    80000f8c:	6422                	ld	s0,8(sp)
    80000f8e:	0141                	addi	sp,sp,16
    80000f90:	8082                	ret
  for(n = 0; s[n]; n++)
    80000f92:	4501                	li	a0,0
    80000f94:	bfe5                	j	80000f8c <strlen+0x20>

0000000080000f96 <main>:

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void main()
{
    80000f96:	1141                	addi	sp,sp,-16
    80000f98:	e406                	sd	ra,8(sp)
    80000f9a:	e022                	sd	s0,0(sp)
    80000f9c:	0800                	addi	s0,sp,16
  if (cpuid() == 0)
    80000f9e:	00001097          	auipc	ra,0x1
    80000fa2:	b46080e7          	jalr	-1210(ra) # 80001ae4 <cpuid>
    __sync_synchronize();
    started = 1;
  }
  else
  {
    while (started == 0)
    80000fa6:	00009717          	auipc	a4,0x9
    80000faa:	c2270713          	addi	a4,a4,-990 # 80009bc8 <started>
  if (cpuid() == 0)
    80000fae:	c139                	beqz	a0,80000ff4 <main+0x5e>
    while (started == 0)
    80000fb0:	431c                	lw	a5,0(a4)
    80000fb2:	2781                	sext.w	a5,a5
    80000fb4:	dff5                	beqz	a5,80000fb0 <main+0x1a>
      ;
    __sync_synchronize();
    80000fb6:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000fba:	00001097          	auipc	ra,0x1
    80000fbe:	b2a080e7          	jalr	-1238(ra) # 80001ae4 <cpuid>
    80000fc2:	85aa                	mv	a1,a0
    80000fc4:	00008517          	auipc	a0,0x8
    80000fc8:	11450513          	addi	a0,a0,276 # 800090d8 <digits+0x98>
    80000fcc:	fffff097          	auipc	ra,0xfffff
    80000fd0:	5be080e7          	jalr	1470(ra) # 8000058a <printf>
    kvminithart();  // turn on paging
    80000fd4:	00000097          	auipc	ra,0x0
    80000fd8:	0e0080e7          	jalr	224(ra) # 800010b4 <kvminithart>
    trapinithart(); // install kernel trap vector
    80000fdc:	00002097          	auipc	ra,0x2
    80000fe0:	ff0080e7          	jalr	-16(ra) # 80002fcc <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80000fe4:	00006097          	auipc	ra,0x6
    80000fe8:	8cc080e7          	jalr	-1844(ra) # 800068b0 <plicinithart>
  }

  scheduler();
    80000fec:	00001097          	auipc	ra,0x1
    80000ff0:	156080e7          	jalr	342(ra) # 80002142 <scheduler>
    consoleinit();
    80000ff4:	fffff097          	auipc	ra,0xfffff
    80000ff8:	45c080e7          	jalr	1116(ra) # 80000450 <consoleinit>
    printfinit();
    80000ffc:	fffff097          	auipc	ra,0xfffff
    80001000:	76e080e7          	jalr	1902(ra) # 8000076a <printfinit>
    printf("\n");
    80001004:	00008517          	auipc	a0,0x8
    80001008:	0e450513          	addi	a0,a0,228 # 800090e8 <digits+0xa8>
    8000100c:	fffff097          	auipc	ra,0xfffff
    80001010:	57e080e7          	jalr	1406(ra) # 8000058a <printf>
    printf("xv6 kernel is booting\n");
    80001014:	00008517          	auipc	a0,0x8
    80001018:	0ac50513          	addi	a0,a0,172 # 800090c0 <digits+0x80>
    8000101c:	fffff097          	auipc	ra,0xfffff
    80001020:	56e080e7          	jalr	1390(ra) # 8000058a <printf>
    printf("\n");
    80001024:	00008517          	auipc	a0,0x8
    80001028:	0c450513          	addi	a0,a0,196 # 800090e8 <digits+0xa8>
    8000102c:	fffff097          	auipc	ra,0xfffff
    80001030:	55e080e7          	jalr	1374(ra) # 8000058a <printf>
    kinit();            // physical page allocator
    80001034:	00000097          	auipc	ra,0x0
    80001038:	b38080e7          	jalr	-1224(ra) # 80000b6c <kinit>
    kvminit();          // create kernel page table
    8000103c:	00000097          	auipc	ra,0x0
    80001040:	32e080e7          	jalr	814(ra) # 8000136a <kvminit>
    kvminithart();      // turn on paging
    80001044:	00000097          	auipc	ra,0x0
    80001048:	070080e7          	jalr	112(ra) # 800010b4 <kvminithart>
    procinit();         // process table
    8000104c:	00001097          	auipc	ra,0x1
    80001050:	9e4080e7          	jalr	-1564(ra) # 80001a30 <procinit>
    trapinit();         // trap vectors
    80001054:	00002097          	auipc	ra,0x2
    80001058:	f50080e7          	jalr	-176(ra) # 80002fa4 <trapinit>
    trapinithart();     // install kernel trap vector
    8000105c:	00002097          	auipc	ra,0x2
    80001060:	f70080e7          	jalr	-144(ra) # 80002fcc <trapinithart>
    plicinit();         // set up interrupt controller
    80001064:	00006097          	auipc	ra,0x6
    80001068:	836080e7          	jalr	-1994(ra) # 8000689a <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    8000106c:	00006097          	auipc	ra,0x6
    80001070:	844080e7          	jalr	-1980(ra) # 800068b0 <plicinithart>
    binit();            // buffer cache
    80001074:	00003097          	auipc	ra,0x3
    80001078:	9dc080e7          	jalr	-1572(ra) # 80003a50 <binit>
    iinit();            // inode table
    8000107c:	00003097          	auipc	ra,0x3
    80001080:	07c080e7          	jalr	124(ra) # 800040f8 <iinit>
    queuetableinit();
    80001084:	00002097          	auipc	ra,0x2
    80001088:	962080e7          	jalr	-1694(ra) # 800029e6 <queuetableinit>
    fileinit();         // file table
    8000108c:	00004097          	auipc	ra,0x4
    80001090:	01a080e7          	jalr	26(ra) # 800050a6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001094:	00006097          	auipc	ra,0x6
    80001098:	c2a080e7          	jalr	-982(ra) # 80006cbe <virtio_disk_init>
    userinit();         // first user process
    8000109c:	00001097          	auipc	ra,0x1
    800010a0:	dd8080e7          	jalr	-552(ra) # 80001e74 <userinit>
    __sync_synchronize();
    800010a4:	0ff0000f          	fence
    started = 1;
    800010a8:	4785                	li	a5,1
    800010aa:	00009717          	auipc	a4,0x9
    800010ae:	b0f72f23          	sw	a5,-1250(a4) # 80009bc8 <started>
    800010b2:	bf2d                	j	80000fec <main+0x56>

00000000800010b4 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800010b4:	1141                	addi	sp,sp,-16
    800010b6:	e422                	sd	s0,8(sp)
    800010b8:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800010ba:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800010be:	00009797          	auipc	a5,0x9
    800010c2:	b127b783          	ld	a5,-1262(a5) # 80009bd0 <kernel_pagetable>
    800010c6:	83b1                	srli	a5,a5,0xc
    800010c8:	577d                	li	a4,-1
    800010ca:	177e                	slli	a4,a4,0x3f
    800010cc:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0"
    800010ce:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800010d2:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800010d6:	6422                	ld	s0,8(sp)
    800010d8:	0141                	addi	sp,sp,16
    800010da:	8082                	ret

00000000800010dc <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800010dc:	7139                	addi	sp,sp,-64
    800010de:	fc06                	sd	ra,56(sp)
    800010e0:	f822                	sd	s0,48(sp)
    800010e2:	f426                	sd	s1,40(sp)
    800010e4:	f04a                	sd	s2,32(sp)
    800010e6:	ec4e                	sd	s3,24(sp)
    800010e8:	e852                	sd	s4,16(sp)
    800010ea:	e456                	sd	s5,8(sp)
    800010ec:	e05a                	sd	s6,0(sp)
    800010ee:	0080                	addi	s0,sp,64
    800010f0:	84aa                	mv	s1,a0
    800010f2:	89ae                	mv	s3,a1
    800010f4:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800010f6:	57fd                	li	a5,-1
    800010f8:	83e9                	srli	a5,a5,0x1a
    800010fa:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800010fc:	4b31                	li	s6,12
  if(va >= MAXVA)
    800010fe:	04b7f263          	bgeu	a5,a1,80001142 <walk+0x66>
    panic("walk");
    80001102:	00008517          	auipc	a0,0x8
    80001106:	fee50513          	addi	a0,a0,-18 # 800090f0 <digits+0xb0>
    8000110a:	fffff097          	auipc	ra,0xfffff
    8000110e:	436080e7          	jalr	1078(ra) # 80000540 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001112:	060a8663          	beqz	s5,8000117e <walk+0xa2>
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	ae4080e7          	jalr	-1308(ra) # 80000bfa <kalloc>
    8000111e:	84aa                	mv	s1,a0
    80001120:	c529                	beqz	a0,8000116a <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001122:	6605                	lui	a2,0x1
    80001124:	4581                	li	a1,0
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	cca080e7          	jalr	-822(ra) # 80000df0 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000112e:	00c4d793          	srli	a5,s1,0xc
    80001132:	07aa                	slli	a5,a5,0xa
    80001134:	0017e793          	ori	a5,a5,1
    80001138:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000113c:	3a5d                	addiw	s4,s4,-9 # ff7 <_entry-0x7ffff009>
    8000113e:	036a0063          	beq	s4,s6,8000115e <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001142:	0149d933          	srl	s2,s3,s4
    80001146:	1ff97913          	andi	s2,s2,511
    8000114a:	090e                	slli	s2,s2,0x3
    8000114c:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000114e:	00093483          	ld	s1,0(s2)
    80001152:	0014f793          	andi	a5,s1,1
    80001156:	dfd5                	beqz	a5,80001112 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001158:	80a9                	srli	s1,s1,0xa
    8000115a:	04b2                	slli	s1,s1,0xc
    8000115c:	b7c5                	j	8000113c <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000115e:	00c9d513          	srli	a0,s3,0xc
    80001162:	1ff57513          	andi	a0,a0,511
    80001166:	050e                	slli	a0,a0,0x3
    80001168:	9526                	add	a0,a0,s1
}
    8000116a:	70e2                	ld	ra,56(sp)
    8000116c:	7442                	ld	s0,48(sp)
    8000116e:	74a2                	ld	s1,40(sp)
    80001170:	7902                	ld	s2,32(sp)
    80001172:	69e2                	ld	s3,24(sp)
    80001174:	6a42                	ld	s4,16(sp)
    80001176:	6aa2                	ld	s5,8(sp)
    80001178:	6b02                	ld	s6,0(sp)
    8000117a:	6121                	addi	sp,sp,64
    8000117c:	8082                	ret
        return 0;
    8000117e:	4501                	li	a0,0
    80001180:	b7ed                	j	8000116a <walk+0x8e>

0000000080001182 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001182:	57fd                	li	a5,-1
    80001184:	83e9                	srli	a5,a5,0x1a
    80001186:	00b7f463          	bgeu	a5,a1,8000118e <walkaddr+0xc>
    return 0;
    8000118a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000118c:	8082                	ret
{
    8000118e:	1141                	addi	sp,sp,-16
    80001190:	e406                	sd	ra,8(sp)
    80001192:	e022                	sd	s0,0(sp)
    80001194:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001196:	4601                	li	a2,0
    80001198:	00000097          	auipc	ra,0x0
    8000119c:	f44080e7          	jalr	-188(ra) # 800010dc <walk>
  if(pte == 0)
    800011a0:	c105                	beqz	a0,800011c0 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800011a2:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800011a4:	0117f693          	andi	a3,a5,17
    800011a8:	4745                	li	a4,17
    return 0;
    800011aa:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800011ac:	00e68663          	beq	a3,a4,800011b8 <walkaddr+0x36>
}
    800011b0:	60a2                	ld	ra,8(sp)
    800011b2:	6402                	ld	s0,0(sp)
    800011b4:	0141                	addi	sp,sp,16
    800011b6:	8082                	ret
  pa = PTE2PA(*pte);
    800011b8:	83a9                	srli	a5,a5,0xa
    800011ba:	00c79513          	slli	a0,a5,0xc
  return pa;
    800011be:	bfcd                	j	800011b0 <walkaddr+0x2e>
    return 0;
    800011c0:	4501                	li	a0,0
    800011c2:	b7fd                	j	800011b0 <walkaddr+0x2e>

00000000800011c4 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800011c4:	715d                	addi	sp,sp,-80
    800011c6:	e486                	sd	ra,72(sp)
    800011c8:	e0a2                	sd	s0,64(sp)
    800011ca:	fc26                	sd	s1,56(sp)
    800011cc:	f84a                	sd	s2,48(sp)
    800011ce:	f44e                	sd	s3,40(sp)
    800011d0:	f052                	sd	s4,32(sp)
    800011d2:	ec56                	sd	s5,24(sp)
    800011d4:	e85a                	sd	s6,16(sp)
    800011d6:	e45e                	sd	s7,8(sp)
    800011d8:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800011da:	c639                	beqz	a2,80001228 <mappages+0x64>
    800011dc:	8aaa                	mv	s5,a0
    800011de:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800011e0:	777d                	lui	a4,0xfffff
    800011e2:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800011e6:	fff58993          	addi	s3,a1,-1
    800011ea:	99b2                	add	s3,s3,a2
    800011ec:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800011f0:	893e                	mv	s2,a5
    800011f2:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800011f6:	6b85                	lui	s7,0x1
    800011f8:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800011fc:	4605                	li	a2,1
    800011fe:	85ca                	mv	a1,s2
    80001200:	8556                	mv	a0,s5
    80001202:	00000097          	auipc	ra,0x0
    80001206:	eda080e7          	jalr	-294(ra) # 800010dc <walk>
    8000120a:	cd1d                	beqz	a0,80001248 <mappages+0x84>
    if(*pte & PTE_V)
    8000120c:	611c                	ld	a5,0(a0)
    8000120e:	8b85                	andi	a5,a5,1
    80001210:	e785                	bnez	a5,80001238 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001212:	80b1                	srli	s1,s1,0xc
    80001214:	04aa                	slli	s1,s1,0xa
    80001216:	0164e4b3          	or	s1,s1,s6
    8000121a:	0014e493          	ori	s1,s1,1
    8000121e:	e104                	sd	s1,0(a0)
    if(a == last)
    80001220:	05390063          	beq	s2,s3,80001260 <mappages+0x9c>
    a += PGSIZE;
    80001224:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001226:	bfc9                	j	800011f8 <mappages+0x34>
    panic("mappages: size");
    80001228:	00008517          	auipc	a0,0x8
    8000122c:	ed050513          	addi	a0,a0,-304 # 800090f8 <digits+0xb8>
    80001230:	fffff097          	auipc	ra,0xfffff
    80001234:	310080e7          	jalr	784(ra) # 80000540 <panic>
      panic("mappages: remap");
    80001238:	00008517          	auipc	a0,0x8
    8000123c:	ed050513          	addi	a0,a0,-304 # 80009108 <digits+0xc8>
    80001240:	fffff097          	auipc	ra,0xfffff
    80001244:	300080e7          	jalr	768(ra) # 80000540 <panic>
      return -1;
    80001248:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000124a:	60a6                	ld	ra,72(sp)
    8000124c:	6406                	ld	s0,64(sp)
    8000124e:	74e2                	ld	s1,56(sp)
    80001250:	7942                	ld	s2,48(sp)
    80001252:	79a2                	ld	s3,40(sp)
    80001254:	7a02                	ld	s4,32(sp)
    80001256:	6ae2                	ld	s5,24(sp)
    80001258:	6b42                	ld	s6,16(sp)
    8000125a:	6ba2                	ld	s7,8(sp)
    8000125c:	6161                	addi	sp,sp,80
    8000125e:	8082                	ret
  return 0;
    80001260:	4501                	li	a0,0
    80001262:	b7e5                	j	8000124a <mappages+0x86>

0000000080001264 <kvmmap>:
{
    80001264:	1141                	addi	sp,sp,-16
    80001266:	e406                	sd	ra,8(sp)
    80001268:	e022                	sd	s0,0(sp)
    8000126a:	0800                	addi	s0,sp,16
    8000126c:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000126e:	86b2                	mv	a3,a2
    80001270:	863e                	mv	a2,a5
    80001272:	00000097          	auipc	ra,0x0
    80001276:	f52080e7          	jalr	-174(ra) # 800011c4 <mappages>
    8000127a:	e509                	bnez	a0,80001284 <kvmmap+0x20>
}
    8000127c:	60a2                	ld	ra,8(sp)
    8000127e:	6402                	ld	s0,0(sp)
    80001280:	0141                	addi	sp,sp,16
    80001282:	8082                	ret
    panic("kvmmap");
    80001284:	00008517          	auipc	a0,0x8
    80001288:	e9450513          	addi	a0,a0,-364 # 80009118 <digits+0xd8>
    8000128c:	fffff097          	auipc	ra,0xfffff
    80001290:	2b4080e7          	jalr	692(ra) # 80000540 <panic>

0000000080001294 <kvmmake>:
{
    80001294:	1101                	addi	sp,sp,-32
    80001296:	ec06                	sd	ra,24(sp)
    80001298:	e822                	sd	s0,16(sp)
    8000129a:	e426                	sd	s1,8(sp)
    8000129c:	e04a                	sd	s2,0(sp)
    8000129e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800012a0:	00000097          	auipc	ra,0x0
    800012a4:	95a080e7          	jalr	-1702(ra) # 80000bfa <kalloc>
    800012a8:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800012aa:	6605                	lui	a2,0x1
    800012ac:	4581                	li	a1,0
    800012ae:	00000097          	auipc	ra,0x0
    800012b2:	b42080e7          	jalr	-1214(ra) # 80000df0 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800012b6:	4719                	li	a4,6
    800012b8:	6685                	lui	a3,0x1
    800012ba:	10000637          	lui	a2,0x10000
    800012be:	100005b7          	lui	a1,0x10000
    800012c2:	8526                	mv	a0,s1
    800012c4:	00000097          	auipc	ra,0x0
    800012c8:	fa0080e7          	jalr	-96(ra) # 80001264 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800012cc:	4719                	li	a4,6
    800012ce:	6685                	lui	a3,0x1
    800012d0:	10001637          	lui	a2,0x10001
    800012d4:	100015b7          	lui	a1,0x10001
    800012d8:	8526                	mv	a0,s1
    800012da:	00000097          	auipc	ra,0x0
    800012de:	f8a080e7          	jalr	-118(ra) # 80001264 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800012e2:	4719                	li	a4,6
    800012e4:	004006b7          	lui	a3,0x400
    800012e8:	0c000637          	lui	a2,0xc000
    800012ec:	0c0005b7          	lui	a1,0xc000
    800012f0:	8526                	mv	a0,s1
    800012f2:	00000097          	auipc	ra,0x0
    800012f6:	f72080e7          	jalr	-142(ra) # 80001264 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800012fa:	00008917          	auipc	s2,0x8
    800012fe:	d0690913          	addi	s2,s2,-762 # 80009000 <etext>
    80001302:	4729                	li	a4,10
    80001304:	80008697          	auipc	a3,0x80008
    80001308:	cfc68693          	addi	a3,a3,-772 # 9000 <_entry-0x7fff7000>
    8000130c:	4605                	li	a2,1
    8000130e:	067e                	slli	a2,a2,0x1f
    80001310:	85b2                	mv	a1,a2
    80001312:	8526                	mv	a0,s1
    80001314:	00000097          	auipc	ra,0x0
    80001318:	f50080e7          	jalr	-176(ra) # 80001264 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000131c:	4719                	li	a4,6
    8000131e:	46c5                	li	a3,17
    80001320:	06ee                	slli	a3,a3,0x1b
    80001322:	412686b3          	sub	a3,a3,s2
    80001326:	864a                	mv	a2,s2
    80001328:	85ca                	mv	a1,s2
    8000132a:	8526                	mv	a0,s1
    8000132c:	00000097          	auipc	ra,0x0
    80001330:	f38080e7          	jalr	-200(ra) # 80001264 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001334:	4729                	li	a4,10
    80001336:	6685                	lui	a3,0x1
    80001338:	00007617          	auipc	a2,0x7
    8000133c:	cc860613          	addi	a2,a2,-824 # 80008000 <_trampoline>
    80001340:	040005b7          	lui	a1,0x4000
    80001344:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001346:	05b2                	slli	a1,a1,0xc
    80001348:	8526                	mv	a0,s1
    8000134a:	00000097          	auipc	ra,0x0
    8000134e:	f1a080e7          	jalr	-230(ra) # 80001264 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001352:	8526                	mv	a0,s1
    80001354:	00000097          	auipc	ra,0x0
    80001358:	646080e7          	jalr	1606(ra) # 8000199a <proc_mapstacks>
}
    8000135c:	8526                	mv	a0,s1
    8000135e:	60e2                	ld	ra,24(sp)
    80001360:	6442                	ld	s0,16(sp)
    80001362:	64a2                	ld	s1,8(sp)
    80001364:	6902                	ld	s2,0(sp)
    80001366:	6105                	addi	sp,sp,32
    80001368:	8082                	ret

000000008000136a <kvminit>:
{
    8000136a:	1141                	addi	sp,sp,-16
    8000136c:	e406                	sd	ra,8(sp)
    8000136e:	e022                	sd	s0,0(sp)
    80001370:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001372:	00000097          	auipc	ra,0x0
    80001376:	f22080e7          	jalr	-222(ra) # 80001294 <kvmmake>
    8000137a:	00009797          	auipc	a5,0x9
    8000137e:	84a7bb23          	sd	a0,-1962(a5) # 80009bd0 <kernel_pagetable>
}
    80001382:	60a2                	ld	ra,8(sp)
    80001384:	6402                	ld	s0,0(sp)
    80001386:	0141                	addi	sp,sp,16
    80001388:	8082                	ret

000000008000138a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000138a:	715d                	addi	sp,sp,-80
    8000138c:	e486                	sd	ra,72(sp)
    8000138e:	e0a2                	sd	s0,64(sp)
    80001390:	fc26                	sd	s1,56(sp)
    80001392:	f84a                	sd	s2,48(sp)
    80001394:	f44e                	sd	s3,40(sp)
    80001396:	f052                	sd	s4,32(sp)
    80001398:	ec56                	sd	s5,24(sp)
    8000139a:	e85a                	sd	s6,16(sp)
    8000139c:	e45e                	sd	s7,8(sp)
    8000139e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800013a0:	03459793          	slli	a5,a1,0x34
    800013a4:	e795                	bnez	a5,800013d0 <uvmunmap+0x46>
    800013a6:	8a2a                	mv	s4,a0
    800013a8:	892e                	mv	s2,a1
    800013aa:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013ac:	0632                	slli	a2,a2,0xc
    800013ae:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800013b2:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013b4:	6b05                	lui	s6,0x1
    800013b6:	0735e263          	bltu	a1,s3,8000141a <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800013ba:	60a6                	ld	ra,72(sp)
    800013bc:	6406                	ld	s0,64(sp)
    800013be:	74e2                	ld	s1,56(sp)
    800013c0:	7942                	ld	s2,48(sp)
    800013c2:	79a2                	ld	s3,40(sp)
    800013c4:	7a02                	ld	s4,32(sp)
    800013c6:	6ae2                	ld	s5,24(sp)
    800013c8:	6b42                	ld	s6,16(sp)
    800013ca:	6ba2                	ld	s7,8(sp)
    800013cc:	6161                	addi	sp,sp,80
    800013ce:	8082                	ret
    panic("uvmunmap: not aligned");
    800013d0:	00008517          	auipc	a0,0x8
    800013d4:	d5050513          	addi	a0,a0,-688 # 80009120 <digits+0xe0>
    800013d8:	fffff097          	auipc	ra,0xfffff
    800013dc:	168080e7          	jalr	360(ra) # 80000540 <panic>
      panic("uvmunmap: walk");
    800013e0:	00008517          	auipc	a0,0x8
    800013e4:	d5850513          	addi	a0,a0,-680 # 80009138 <digits+0xf8>
    800013e8:	fffff097          	auipc	ra,0xfffff
    800013ec:	158080e7          	jalr	344(ra) # 80000540 <panic>
      panic("uvmunmap: not mapped");
    800013f0:	00008517          	auipc	a0,0x8
    800013f4:	d5850513          	addi	a0,a0,-680 # 80009148 <digits+0x108>
    800013f8:	fffff097          	auipc	ra,0xfffff
    800013fc:	148080e7          	jalr	328(ra) # 80000540 <panic>
      panic("uvmunmap: not a leaf");
    80001400:	00008517          	auipc	a0,0x8
    80001404:	d6050513          	addi	a0,a0,-672 # 80009160 <digits+0x120>
    80001408:	fffff097          	auipc	ra,0xfffff
    8000140c:	138080e7          	jalr	312(ra) # 80000540 <panic>
    *pte = 0;
    80001410:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001414:	995a                	add	s2,s2,s6
    80001416:	fb3972e3          	bgeu	s2,s3,800013ba <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000141a:	4601                	li	a2,0
    8000141c:	85ca                	mv	a1,s2
    8000141e:	8552                	mv	a0,s4
    80001420:	00000097          	auipc	ra,0x0
    80001424:	cbc080e7          	jalr	-836(ra) # 800010dc <walk>
    80001428:	84aa                	mv	s1,a0
    8000142a:	d95d                	beqz	a0,800013e0 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000142c:	6108                	ld	a0,0(a0)
    8000142e:	00157793          	andi	a5,a0,1
    80001432:	dfdd                	beqz	a5,800013f0 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001434:	3ff57793          	andi	a5,a0,1023
    80001438:	fd7784e3          	beq	a5,s7,80001400 <uvmunmap+0x76>
    if(do_free){
    8000143c:	fc0a8ae3          	beqz	s5,80001410 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001440:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001442:	0532                	slli	a0,a0,0xc
    80001444:	fffff097          	auipc	ra,0xfffff
    80001448:	60e080e7          	jalr	1550(ra) # 80000a52 <kfree>
    8000144c:	b7d1                	j	80001410 <uvmunmap+0x86>

000000008000144e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000144e:	1101                	addi	sp,sp,-32
    80001450:	ec06                	sd	ra,24(sp)
    80001452:	e822                	sd	s0,16(sp)
    80001454:	e426                	sd	s1,8(sp)
    80001456:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001458:	fffff097          	auipc	ra,0xfffff
    8000145c:	7a2080e7          	jalr	1954(ra) # 80000bfa <kalloc>
    80001460:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001462:	c519                	beqz	a0,80001470 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001464:	6605                	lui	a2,0x1
    80001466:	4581                	li	a1,0
    80001468:	00000097          	auipc	ra,0x0
    8000146c:	988080e7          	jalr	-1656(ra) # 80000df0 <memset>
  return pagetable;
}
    80001470:	8526                	mv	a0,s1
    80001472:	60e2                	ld	ra,24(sp)
    80001474:	6442                	ld	s0,16(sp)
    80001476:	64a2                	ld	s1,8(sp)
    80001478:	6105                	addi	sp,sp,32
    8000147a:	8082                	ret

000000008000147c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000147c:	7179                	addi	sp,sp,-48
    8000147e:	f406                	sd	ra,40(sp)
    80001480:	f022                	sd	s0,32(sp)
    80001482:	ec26                	sd	s1,24(sp)
    80001484:	e84a                	sd	s2,16(sp)
    80001486:	e44e                	sd	s3,8(sp)
    80001488:	e052                	sd	s4,0(sp)
    8000148a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000148c:	6785                	lui	a5,0x1
    8000148e:	04f67863          	bgeu	a2,a5,800014de <uvmfirst+0x62>
    80001492:	8a2a                	mv	s4,a0
    80001494:	89ae                	mv	s3,a1
    80001496:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001498:	fffff097          	auipc	ra,0xfffff
    8000149c:	762080e7          	jalr	1890(ra) # 80000bfa <kalloc>
    800014a0:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800014a2:	6605                	lui	a2,0x1
    800014a4:	4581                	li	a1,0
    800014a6:	00000097          	auipc	ra,0x0
    800014aa:	94a080e7          	jalr	-1718(ra) # 80000df0 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800014ae:	4779                	li	a4,30
    800014b0:	86ca                	mv	a3,s2
    800014b2:	6605                	lui	a2,0x1
    800014b4:	4581                	li	a1,0
    800014b6:	8552                	mv	a0,s4
    800014b8:	00000097          	auipc	ra,0x0
    800014bc:	d0c080e7          	jalr	-756(ra) # 800011c4 <mappages>
  memmove(mem, src, sz);
    800014c0:	8626                	mv	a2,s1
    800014c2:	85ce                	mv	a1,s3
    800014c4:	854a                	mv	a0,s2
    800014c6:	00000097          	auipc	ra,0x0
    800014ca:	986080e7          	jalr	-1658(ra) # 80000e4c <memmove>
}
    800014ce:	70a2                	ld	ra,40(sp)
    800014d0:	7402                	ld	s0,32(sp)
    800014d2:	64e2                	ld	s1,24(sp)
    800014d4:	6942                	ld	s2,16(sp)
    800014d6:	69a2                	ld	s3,8(sp)
    800014d8:	6a02                	ld	s4,0(sp)
    800014da:	6145                	addi	sp,sp,48
    800014dc:	8082                	ret
    panic("uvmfirst: more than a page");
    800014de:	00008517          	auipc	a0,0x8
    800014e2:	c9a50513          	addi	a0,a0,-870 # 80009178 <digits+0x138>
    800014e6:	fffff097          	auipc	ra,0xfffff
    800014ea:	05a080e7          	jalr	90(ra) # 80000540 <panic>

00000000800014ee <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800014ee:	1101                	addi	sp,sp,-32
    800014f0:	ec06                	sd	ra,24(sp)
    800014f2:	e822                	sd	s0,16(sp)
    800014f4:	e426                	sd	s1,8(sp)
    800014f6:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800014f8:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800014fa:	00b67d63          	bgeu	a2,a1,80001514 <uvmdealloc+0x26>
    800014fe:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001500:	6785                	lui	a5,0x1
    80001502:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001504:	00f60733          	add	a4,a2,a5
    80001508:	76fd                	lui	a3,0xfffff
    8000150a:	8f75                	and	a4,a4,a3
    8000150c:	97ae                	add	a5,a5,a1
    8000150e:	8ff5                	and	a5,a5,a3
    80001510:	00f76863          	bltu	a4,a5,80001520 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001514:	8526                	mv	a0,s1
    80001516:	60e2                	ld	ra,24(sp)
    80001518:	6442                	ld	s0,16(sp)
    8000151a:	64a2                	ld	s1,8(sp)
    8000151c:	6105                	addi	sp,sp,32
    8000151e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001520:	8f99                	sub	a5,a5,a4
    80001522:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001524:	4685                	li	a3,1
    80001526:	0007861b          	sext.w	a2,a5
    8000152a:	85ba                	mv	a1,a4
    8000152c:	00000097          	auipc	ra,0x0
    80001530:	e5e080e7          	jalr	-418(ra) # 8000138a <uvmunmap>
    80001534:	b7c5                	j	80001514 <uvmdealloc+0x26>

0000000080001536 <uvmalloc>:
  if(newsz < oldsz)
    80001536:	0ab66563          	bltu	a2,a1,800015e0 <uvmalloc+0xaa>
{
    8000153a:	7139                	addi	sp,sp,-64
    8000153c:	fc06                	sd	ra,56(sp)
    8000153e:	f822                	sd	s0,48(sp)
    80001540:	f426                	sd	s1,40(sp)
    80001542:	f04a                	sd	s2,32(sp)
    80001544:	ec4e                	sd	s3,24(sp)
    80001546:	e852                	sd	s4,16(sp)
    80001548:	e456                	sd	s5,8(sp)
    8000154a:	e05a                	sd	s6,0(sp)
    8000154c:	0080                	addi	s0,sp,64
    8000154e:	8aaa                	mv	s5,a0
    80001550:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001552:	6785                	lui	a5,0x1
    80001554:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001556:	95be                	add	a1,a1,a5
    80001558:	77fd                	lui	a5,0xfffff
    8000155a:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000155e:	08c9f363          	bgeu	s3,a2,800015e4 <uvmalloc+0xae>
    80001562:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001564:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001568:	fffff097          	auipc	ra,0xfffff
    8000156c:	692080e7          	jalr	1682(ra) # 80000bfa <kalloc>
    80001570:	84aa                	mv	s1,a0
    if(mem == 0){
    80001572:	c51d                	beqz	a0,800015a0 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80001574:	6605                	lui	a2,0x1
    80001576:	4581                	li	a1,0
    80001578:	00000097          	auipc	ra,0x0
    8000157c:	878080e7          	jalr	-1928(ra) # 80000df0 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001580:	875a                	mv	a4,s6
    80001582:	86a6                	mv	a3,s1
    80001584:	6605                	lui	a2,0x1
    80001586:	85ca                	mv	a1,s2
    80001588:	8556                	mv	a0,s5
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	c3a080e7          	jalr	-966(ra) # 800011c4 <mappages>
    80001592:	e90d                	bnez	a0,800015c4 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001594:	6785                	lui	a5,0x1
    80001596:	993e                	add	s2,s2,a5
    80001598:	fd4968e3          	bltu	s2,s4,80001568 <uvmalloc+0x32>
  return newsz;
    8000159c:	8552                	mv	a0,s4
    8000159e:	a809                	j	800015b0 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    800015a0:	864e                	mv	a2,s3
    800015a2:	85ca                	mv	a1,s2
    800015a4:	8556                	mv	a0,s5
    800015a6:	00000097          	auipc	ra,0x0
    800015aa:	f48080e7          	jalr	-184(ra) # 800014ee <uvmdealloc>
      return 0;
    800015ae:	4501                	li	a0,0
}
    800015b0:	70e2                	ld	ra,56(sp)
    800015b2:	7442                	ld	s0,48(sp)
    800015b4:	74a2                	ld	s1,40(sp)
    800015b6:	7902                	ld	s2,32(sp)
    800015b8:	69e2                	ld	s3,24(sp)
    800015ba:	6a42                	ld	s4,16(sp)
    800015bc:	6aa2                	ld	s5,8(sp)
    800015be:	6b02                	ld	s6,0(sp)
    800015c0:	6121                	addi	sp,sp,64
    800015c2:	8082                	ret
      kfree(mem);
    800015c4:	8526                	mv	a0,s1
    800015c6:	fffff097          	auipc	ra,0xfffff
    800015ca:	48c080e7          	jalr	1164(ra) # 80000a52 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800015ce:	864e                	mv	a2,s3
    800015d0:	85ca                	mv	a1,s2
    800015d2:	8556                	mv	a0,s5
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	f1a080e7          	jalr	-230(ra) # 800014ee <uvmdealloc>
      return 0;
    800015dc:	4501                	li	a0,0
    800015de:	bfc9                	j	800015b0 <uvmalloc+0x7a>
    return oldsz;
    800015e0:	852e                	mv	a0,a1
}
    800015e2:	8082                	ret
  return newsz;
    800015e4:	8532                	mv	a0,a2
    800015e6:	b7e9                	j	800015b0 <uvmalloc+0x7a>

00000000800015e8 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800015e8:	7179                	addi	sp,sp,-48
    800015ea:	f406                	sd	ra,40(sp)
    800015ec:	f022                	sd	s0,32(sp)
    800015ee:	ec26                	sd	s1,24(sp)
    800015f0:	e84a                	sd	s2,16(sp)
    800015f2:	e44e                	sd	s3,8(sp)
    800015f4:	e052                	sd	s4,0(sp)
    800015f6:	1800                	addi	s0,sp,48
    800015f8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800015fa:	84aa                	mv	s1,a0
    800015fc:	6905                	lui	s2,0x1
    800015fe:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001600:	4985                	li	s3,1
    80001602:	a829                	j	8000161c <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001604:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001606:	00c79513          	slli	a0,a5,0xc
    8000160a:	00000097          	auipc	ra,0x0
    8000160e:	fde080e7          	jalr	-34(ra) # 800015e8 <freewalk>
      pagetable[i] = 0;
    80001612:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001616:	04a1                	addi	s1,s1,8
    80001618:	03248163          	beq	s1,s2,8000163a <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000161c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000161e:	00f7f713          	andi	a4,a5,15
    80001622:	ff3701e3          	beq	a4,s3,80001604 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001626:	8b85                	andi	a5,a5,1
    80001628:	d7fd                	beqz	a5,80001616 <freewalk+0x2e>
      panic("freewalk: leaf");
    8000162a:	00008517          	auipc	a0,0x8
    8000162e:	b6e50513          	addi	a0,a0,-1170 # 80009198 <digits+0x158>
    80001632:	fffff097          	auipc	ra,0xfffff
    80001636:	f0e080e7          	jalr	-242(ra) # 80000540 <panic>
    }
  }
  kfree((void*)pagetable);
    8000163a:	8552                	mv	a0,s4
    8000163c:	fffff097          	auipc	ra,0xfffff
    80001640:	416080e7          	jalr	1046(ra) # 80000a52 <kfree>
}
    80001644:	70a2                	ld	ra,40(sp)
    80001646:	7402                	ld	s0,32(sp)
    80001648:	64e2                	ld	s1,24(sp)
    8000164a:	6942                	ld	s2,16(sp)
    8000164c:	69a2                	ld	s3,8(sp)
    8000164e:	6a02                	ld	s4,0(sp)
    80001650:	6145                	addi	sp,sp,48
    80001652:	8082                	ret

0000000080001654 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001654:	1101                	addi	sp,sp,-32
    80001656:	ec06                	sd	ra,24(sp)
    80001658:	e822                	sd	s0,16(sp)
    8000165a:	e426                	sd	s1,8(sp)
    8000165c:	1000                	addi	s0,sp,32
    8000165e:	84aa                	mv	s1,a0
  if(sz > 0)
    80001660:	e999                	bnez	a1,80001676 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001662:	8526                	mv	a0,s1
    80001664:	00000097          	auipc	ra,0x0
    80001668:	f84080e7          	jalr	-124(ra) # 800015e8 <freewalk>
}
    8000166c:	60e2                	ld	ra,24(sp)
    8000166e:	6442                	ld	s0,16(sp)
    80001670:	64a2                	ld	s1,8(sp)
    80001672:	6105                	addi	sp,sp,32
    80001674:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001676:	6785                	lui	a5,0x1
    80001678:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000167a:	95be                	add	a1,a1,a5
    8000167c:	4685                	li	a3,1
    8000167e:	00c5d613          	srli	a2,a1,0xc
    80001682:	4581                	li	a1,0
    80001684:	00000097          	auipc	ra,0x0
    80001688:	d06080e7          	jalr	-762(ra) # 8000138a <uvmunmap>
    8000168c:	bfd9                	j	80001662 <uvmfree+0xe>

000000008000168e <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    8000168e:	715d                	addi	sp,sp,-80
    80001690:	e486                	sd	ra,72(sp)
    80001692:	e0a2                	sd	s0,64(sp)
    80001694:	fc26                	sd	s1,56(sp)
    80001696:	f84a                	sd	s2,48(sp)
    80001698:	f44e                	sd	s3,40(sp)
    8000169a:	f052                	sd	s4,32(sp)
    8000169c:	ec56                	sd	s5,24(sp)
    8000169e:	e85a                	sd	s6,16(sp)
    800016a0:	e45e                	sd	s7,8(sp)
    800016a2:	0880                	addi	s0,sp,80
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  // char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800016a4:	ce5d                	beqz	a2,80001762 <uvmcopy+0xd4>
    800016a6:	8aaa                	mv	s5,a0
    800016a8:	8a2e                	mv	s4,a1
    800016aa:	89b2                	mv	s3,a2
    800016ac:	4481                	li	s1,0
      // goto err;
    // }
    if( flags & PTE_W )
    {
      flags = (flags & (~PTE_W) ) | PTE_C;
      *pte = PA2PTE(pa) | flags;
    800016ae:	7b7d                	lui	s6,0xfffff
    800016b0:	002b5b13          	srli	s6,s6,0x2
    800016b4:	a0a1                	j	800016fc <uvmcopy+0x6e>
      panic("uvmcopy: pte should exist");
    800016b6:	00008517          	auipc	a0,0x8
    800016ba:	af250513          	addi	a0,a0,-1294 # 800091a8 <digits+0x168>
    800016be:	fffff097          	auipc	ra,0xfffff
    800016c2:	e82080e7          	jalr	-382(ra) # 80000540 <panic>
      panic("uvmcopy: page not present");
    800016c6:	00008517          	auipc	a0,0x8
    800016ca:	b0250513          	addi	a0,a0,-1278 # 800091c8 <digits+0x188>
    800016ce:	fffff097          	auipc	ra,0xfffff
    800016d2:	e72080e7          	jalr	-398(ra) # 80000540 <panic>
    }
    if( mappages(new,i, PGSIZE,pa, flags) != 0 )
    800016d6:	86ca                	mv	a3,s2
    800016d8:	6605                	lui	a2,0x1
    800016da:	85a6                	mv	a1,s1
    800016dc:	8552                	mv	a0,s4
    800016de:	00000097          	auipc	ra,0x0
    800016e2:	ae6080e7          	jalr	-1306(ra) # 800011c4 <mappages>
    800016e6:	8baa                	mv	s7,a0
    800016e8:	e539                	bnez	a0,80001736 <uvmcopy+0xa8>
      goto err;

    inc_page_ref((void*)pa);  
    800016ea:	854a                	mv	a0,s2
    800016ec:	fffff097          	auipc	ra,0xfffff
    800016f0:	2fc080e7          	jalr	764(ra) # 800009e8 <inc_page_ref>
  for(i = 0; i < sz; i += PGSIZE){
    800016f4:	6785                	lui	a5,0x1
    800016f6:	94be                	add	s1,s1,a5
    800016f8:	0534f963          	bgeu	s1,s3,8000174a <uvmcopy+0xbc>
    if((pte = walk(old, i, 0)) == 0)
    800016fc:	4601                	li	a2,0
    800016fe:	85a6                	mv	a1,s1
    80001700:	8556                	mv	a0,s5
    80001702:	00000097          	auipc	ra,0x0
    80001706:	9da080e7          	jalr	-1574(ra) # 800010dc <walk>
    8000170a:	d555                	beqz	a0,800016b6 <uvmcopy+0x28>
    if((*pte & PTE_V) == 0)
    8000170c:	611c                	ld	a5,0(a0)
    8000170e:	0017f713          	andi	a4,a5,1
    80001712:	db55                	beqz	a4,800016c6 <uvmcopy+0x38>
    pa = PTE2PA(*pte);
    80001714:	00a7d913          	srli	s2,a5,0xa
    80001718:	0932                	slli	s2,s2,0xc
    flags = PTE_FLAGS(*pte);
    8000171a:	3ff7f713          	andi	a4,a5,1023
    if( flags & PTE_W )
    8000171e:	0047f693          	andi	a3,a5,4
    80001722:	dad5                	beqz	a3,800016d6 <uvmcopy+0x48>
      flags = (flags & (~PTE_W) ) | PTE_C;
    80001724:	fdb77693          	andi	a3,a4,-37
    80001728:	0206e713          	ori	a4,a3,32
      *pte = PA2PTE(pa) | flags;
    8000172c:	0167f7b3          	and	a5,a5,s6
    80001730:	8fd9                	or	a5,a5,a4
    80001732:	e11c                	sd	a5,0(a0)
    80001734:	b74d                	j	800016d6 <uvmcopy+0x48>
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001736:	4685                	li	a3,1
    80001738:	00c4d613          	srli	a2,s1,0xc
    8000173c:	4581                	li	a1,0
    8000173e:	8552                	mv	a0,s4
    80001740:	00000097          	auipc	ra,0x0
    80001744:	c4a080e7          	jalr	-950(ra) # 8000138a <uvmunmap>
  return -1;
    80001748:	5bfd                	li	s7,-1
}
    8000174a:	855e                	mv	a0,s7
    8000174c:	60a6                	ld	ra,72(sp)
    8000174e:	6406                	ld	s0,64(sp)
    80001750:	74e2                	ld	s1,56(sp)
    80001752:	7942                	ld	s2,48(sp)
    80001754:	79a2                	ld	s3,40(sp)
    80001756:	7a02                	ld	s4,32(sp)
    80001758:	6ae2                	ld	s5,24(sp)
    8000175a:	6b42                	ld	s6,16(sp)
    8000175c:	6ba2                	ld	s7,8(sp)
    8000175e:	6161                	addi	sp,sp,80
    80001760:	8082                	ret
  return 0;
    80001762:	4b81                	li	s7,0
    80001764:	b7dd                	j	8000174a <uvmcopy+0xbc>

0000000080001766 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001766:	1141                	addi	sp,sp,-16
    80001768:	e406                	sd	ra,8(sp)
    8000176a:	e022                	sd	s0,0(sp)
    8000176c:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000176e:	4601                	li	a2,0
    80001770:	00000097          	auipc	ra,0x0
    80001774:	96c080e7          	jalr	-1684(ra) # 800010dc <walk>
  if(pte == 0)
    80001778:	c901                	beqz	a0,80001788 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000177a:	611c                	ld	a5,0(a0)
    8000177c:	9bbd                	andi	a5,a5,-17
    8000177e:	e11c                	sd	a5,0(a0)
}
    80001780:	60a2                	ld	ra,8(sp)
    80001782:	6402                	ld	s0,0(sp)
    80001784:	0141                	addi	sp,sp,16
    80001786:	8082                	ret
    panic("uvmclear");
    80001788:	00008517          	auipc	a0,0x8
    8000178c:	a6050513          	addi	a0,a0,-1440 # 800091e8 <digits+0x1a8>
    80001790:	fffff097          	auipc	ra,0xfffff
    80001794:	db0080e7          	jalr	-592(ra) # 80000540 <panic>

0000000080001798 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0, flags;
  pte_t *pte;

  while(len > 0){
    80001798:	c2d5                	beqz	a3,8000183c <copyout+0xa4>
{
    8000179a:	711d                	addi	sp,sp,-96
    8000179c:	ec86                	sd	ra,88(sp)
    8000179e:	e8a2                	sd	s0,80(sp)
    800017a0:	e4a6                	sd	s1,72(sp)
    800017a2:	e0ca                	sd	s2,64(sp)
    800017a4:	fc4e                	sd	s3,56(sp)
    800017a6:	f852                	sd	s4,48(sp)
    800017a8:	f456                	sd	s5,40(sp)
    800017aa:	f05a                	sd	s6,32(sp)
    800017ac:	ec5e                	sd	s7,24(sp)
    800017ae:	e862                	sd	s8,16(sp)
    800017b0:	e466                	sd	s9,8(sp)
    800017b2:	1080                	addi	s0,sp,96
    800017b4:	8baa                	mv	s7,a0
    800017b6:	89ae                	mv	s3,a1
    800017b8:	8b32                	mv	s6,a2
    800017ba:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    800017bc:	7cfd                	lui	s9,0xfffff
    if( flags & PTE_C )
    {
      cow_trap_handler((void*)va0,pagetable);
      pa0 = walkaddr(pagetable, va0);
    } 
    n = PGSIZE - (dstva - va0);
    800017be:	6c05                	lui	s8,0x1
    800017c0:	a081                	j	80001800 <copyout+0x68>
      cow_trap_handler((void*)va0,pagetable);
    800017c2:	85de                	mv	a1,s7
    800017c4:	854a                	mv	a0,s2
    800017c6:	00001097          	auipc	ra,0x1
    800017ca:	71e080e7          	jalr	1822(ra) # 80002ee4 <cow_trap_handler>
      pa0 = walkaddr(pagetable, va0);
    800017ce:	85ca                	mv	a1,s2
    800017d0:	855e                	mv	a0,s7
    800017d2:	00000097          	auipc	ra,0x0
    800017d6:	9b0080e7          	jalr	-1616(ra) # 80001182 <walkaddr>
    800017da:	8a2a                	mv	s4,a0
    800017dc:	a0b9                	j	8000182a <copyout+0x92>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800017de:	41298533          	sub	a0,s3,s2
    800017e2:	0004861b          	sext.w	a2,s1
    800017e6:	85da                	mv	a1,s6
    800017e8:	9552                	add	a0,a0,s4
    800017ea:	fffff097          	auipc	ra,0xfffff
    800017ee:	662080e7          	jalr	1634(ra) # 80000e4c <memmove>

    len -= n;
    800017f2:	409a8ab3          	sub	s5,s5,s1
    src += n;
    800017f6:	9b26                	add	s6,s6,s1
    dstva = va0 + PGSIZE;
    800017f8:	018909b3          	add	s3,s2,s8
  while(len > 0){
    800017fc:	020a8e63          	beqz	s5,80001838 <copyout+0xa0>
    va0 = PGROUNDDOWN(dstva);
    80001800:	0199f933          	and	s2,s3,s9
    pa0 = walkaddr(pagetable, va0);
    80001804:	85ca                	mv	a1,s2
    80001806:	855e                	mv	a0,s7
    80001808:	00000097          	auipc	ra,0x0
    8000180c:	97a080e7          	jalr	-1670(ra) # 80001182 <walkaddr>
    80001810:	8a2a                	mv	s4,a0
    if(pa0 == 0)
    80001812:	c51d                	beqz	a0,80001840 <copyout+0xa8>
    pte = walk(pagetable, va0,  0); 
    80001814:	4601                	li	a2,0
    80001816:	85ca                	mv	a1,s2
    80001818:	855e                	mv	a0,s7
    8000181a:	00000097          	auipc	ra,0x0
    8000181e:	8c2080e7          	jalr	-1854(ra) # 800010dc <walk>
    if( flags & PTE_C )
    80001822:	611c                	ld	a5,0(a0)
    80001824:	0207f793          	andi	a5,a5,32
    80001828:	ffc9                	bnez	a5,800017c2 <copyout+0x2a>
    n = PGSIZE - (dstva - va0);
    8000182a:	413904b3          	sub	s1,s2,s3
    8000182e:	94e2                	add	s1,s1,s8
    80001830:	fa9af7e3          	bgeu	s5,s1,800017de <copyout+0x46>
    80001834:	84d6                	mv	s1,s5
    80001836:	b765                	j	800017de <copyout+0x46>
  }
  return 0;
    80001838:	4501                	li	a0,0
    8000183a:	a021                	j	80001842 <copyout+0xaa>
    8000183c:	4501                	li	a0,0
}
    8000183e:	8082                	ret
      return -1;
    80001840:	557d                	li	a0,-1
}
    80001842:	60e6                	ld	ra,88(sp)
    80001844:	6446                	ld	s0,80(sp)
    80001846:	64a6                	ld	s1,72(sp)
    80001848:	6906                	ld	s2,64(sp)
    8000184a:	79e2                	ld	s3,56(sp)
    8000184c:	7a42                	ld	s4,48(sp)
    8000184e:	7aa2                	ld	s5,40(sp)
    80001850:	7b02                	ld	s6,32(sp)
    80001852:	6be2                	ld	s7,24(sp)
    80001854:	6c42                	ld	s8,16(sp)
    80001856:	6ca2                	ld	s9,8(sp)
    80001858:	6125                	addi	sp,sp,96
    8000185a:	8082                	ret

000000008000185c <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000185c:	caa5                	beqz	a3,800018cc <copyin+0x70>
{
    8000185e:	715d                	addi	sp,sp,-80
    80001860:	e486                	sd	ra,72(sp)
    80001862:	e0a2                	sd	s0,64(sp)
    80001864:	fc26                	sd	s1,56(sp)
    80001866:	f84a                	sd	s2,48(sp)
    80001868:	f44e                	sd	s3,40(sp)
    8000186a:	f052                	sd	s4,32(sp)
    8000186c:	ec56                	sd	s5,24(sp)
    8000186e:	e85a                	sd	s6,16(sp)
    80001870:	e45e                	sd	s7,8(sp)
    80001872:	e062                	sd	s8,0(sp)
    80001874:	0880                	addi	s0,sp,80
    80001876:	8b2a                	mv	s6,a0
    80001878:	8a2e                	mv	s4,a1
    8000187a:	8c32                	mv	s8,a2
    8000187c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000187e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001880:	6a85                	lui	s5,0x1
    80001882:	a01d                	j	800018a8 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001884:	018505b3          	add	a1,a0,s8
    80001888:	0004861b          	sext.w	a2,s1
    8000188c:	412585b3          	sub	a1,a1,s2
    80001890:	8552                	mv	a0,s4
    80001892:	fffff097          	auipc	ra,0xfffff
    80001896:	5ba080e7          	jalr	1466(ra) # 80000e4c <memmove>

    len -= n;
    8000189a:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000189e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800018a0:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800018a4:	02098263          	beqz	s3,800018c8 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800018a8:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800018ac:	85ca                	mv	a1,s2
    800018ae:	855a                	mv	a0,s6
    800018b0:	00000097          	auipc	ra,0x0
    800018b4:	8d2080e7          	jalr	-1838(ra) # 80001182 <walkaddr>
    if(pa0 == 0)
    800018b8:	cd01                	beqz	a0,800018d0 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800018ba:	418904b3          	sub	s1,s2,s8
    800018be:	94d6                	add	s1,s1,s5
    800018c0:	fc99f2e3          	bgeu	s3,s1,80001884 <copyin+0x28>
    800018c4:	84ce                	mv	s1,s3
    800018c6:	bf7d                	j	80001884 <copyin+0x28>
  }
  return 0;
    800018c8:	4501                	li	a0,0
    800018ca:	a021                	j	800018d2 <copyin+0x76>
    800018cc:	4501                	li	a0,0
}
    800018ce:	8082                	ret
      return -1;
    800018d0:	557d                	li	a0,-1
}
    800018d2:	60a6                	ld	ra,72(sp)
    800018d4:	6406                	ld	s0,64(sp)
    800018d6:	74e2                	ld	s1,56(sp)
    800018d8:	7942                	ld	s2,48(sp)
    800018da:	79a2                	ld	s3,40(sp)
    800018dc:	7a02                	ld	s4,32(sp)
    800018de:	6ae2                	ld	s5,24(sp)
    800018e0:	6b42                	ld	s6,16(sp)
    800018e2:	6ba2                	ld	s7,8(sp)
    800018e4:	6c02                	ld	s8,0(sp)
    800018e6:	6161                	addi	sp,sp,80
    800018e8:	8082                	ret

00000000800018ea <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800018ea:	c2dd                	beqz	a3,80001990 <copyinstr+0xa6>
{
    800018ec:	715d                	addi	sp,sp,-80
    800018ee:	e486                	sd	ra,72(sp)
    800018f0:	e0a2                	sd	s0,64(sp)
    800018f2:	fc26                	sd	s1,56(sp)
    800018f4:	f84a                	sd	s2,48(sp)
    800018f6:	f44e                	sd	s3,40(sp)
    800018f8:	f052                	sd	s4,32(sp)
    800018fa:	ec56                	sd	s5,24(sp)
    800018fc:	e85a                	sd	s6,16(sp)
    800018fe:	e45e                	sd	s7,8(sp)
    80001900:	0880                	addi	s0,sp,80
    80001902:	8a2a                	mv	s4,a0
    80001904:	8b2e                	mv	s6,a1
    80001906:	8bb2                	mv	s7,a2
    80001908:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    8000190a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000190c:	6985                	lui	s3,0x1
    8000190e:	a02d                	j	80001938 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001910:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001914:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001916:	37fd                	addiw	a5,a5,-1
    80001918:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000191c:	60a6                	ld	ra,72(sp)
    8000191e:	6406                	ld	s0,64(sp)
    80001920:	74e2                	ld	s1,56(sp)
    80001922:	7942                	ld	s2,48(sp)
    80001924:	79a2                	ld	s3,40(sp)
    80001926:	7a02                	ld	s4,32(sp)
    80001928:	6ae2                	ld	s5,24(sp)
    8000192a:	6b42                	ld	s6,16(sp)
    8000192c:	6ba2                	ld	s7,8(sp)
    8000192e:	6161                	addi	sp,sp,80
    80001930:	8082                	ret
    srcva = va0 + PGSIZE;
    80001932:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001936:	c8a9                	beqz	s1,80001988 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80001938:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000193c:	85ca                	mv	a1,s2
    8000193e:	8552                	mv	a0,s4
    80001940:	00000097          	auipc	ra,0x0
    80001944:	842080e7          	jalr	-1982(ra) # 80001182 <walkaddr>
    if(pa0 == 0)
    80001948:	c131                	beqz	a0,8000198c <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    8000194a:	417906b3          	sub	a3,s2,s7
    8000194e:	96ce                	add	a3,a3,s3
    80001950:	00d4f363          	bgeu	s1,a3,80001956 <copyinstr+0x6c>
    80001954:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001956:	955e                	add	a0,a0,s7
    80001958:	41250533          	sub	a0,a0,s2
    while(n > 0){
    8000195c:	daf9                	beqz	a3,80001932 <copyinstr+0x48>
    8000195e:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001960:	41650633          	sub	a2,a0,s6
    80001964:	fff48593          	addi	a1,s1,-1
    80001968:	95da                	add	a1,a1,s6
    while(n > 0){
    8000196a:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    8000196c:	00f60733          	add	a4,a2,a5
    80001970:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7fdb81b8>
    80001974:	df51                	beqz	a4,80001910 <copyinstr+0x26>
        *dst = *p;
    80001976:	00e78023          	sb	a4,0(a5)
      --max;
    8000197a:	40f584b3          	sub	s1,a1,a5
      dst++;
    8000197e:	0785                	addi	a5,a5,1
    while(n > 0){
    80001980:	fed796e3          	bne	a5,a3,8000196c <copyinstr+0x82>
      dst++;
    80001984:	8b3e                	mv	s6,a5
    80001986:	b775                	j	80001932 <copyinstr+0x48>
    80001988:	4781                	li	a5,0
    8000198a:	b771                	j	80001916 <copyinstr+0x2c>
      return -1;
    8000198c:	557d                	li	a0,-1
    8000198e:	b779                	j	8000191c <copyinstr+0x32>
  int got_null = 0;
    80001990:	4781                	li	a5,0
  if(got_null){
    80001992:	37fd                	addiw	a5,a5,-1
    80001994:	0007851b          	sext.w	a0,a5
}
    80001998:	8082                	ret

000000008000199a <proc_mapstacks>:
// }
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    8000199a:	7139                	addi	sp,sp,-64
    8000199c:	fc06                	sd	ra,56(sp)
    8000199e:	f822                	sd	s0,48(sp)
    800019a0:	f426                	sd	s1,40(sp)
    800019a2:	f04a                	sd	s2,32(sp)
    800019a4:	ec4e                	sd	s3,24(sp)
    800019a6:	e852                	sd	s4,16(sp)
    800019a8:	e456                	sd	s5,8(sp)
    800019aa:	e05a                	sd	s6,0(sp)
    800019ac:	0080                	addi	s0,sp,64
    800019ae:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    800019b0:	00231497          	auipc	s1,0x231
    800019b4:	8e848493          	addi	s1,s1,-1816 # 80232298 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    800019b8:	8b26                	mv	s6,s1
    800019ba:	00007a97          	auipc	s5,0x7
    800019be:	646a8a93          	addi	s5,s5,1606 # 80009000 <etext>
    800019c2:	04000937          	lui	s2,0x4000
    800019c6:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    800019c8:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    800019ca:	00238a17          	auipc	s4,0x238
    800019ce:	2cea0a13          	addi	s4,s4,718 # 80239c98 <queuetable>
    char *pa = kalloc();
    800019d2:	fffff097          	auipc	ra,0xfffff
    800019d6:	228080e7          	jalr	552(ra) # 80000bfa <kalloc>
    800019da:	862a                	mv	a2,a0
    if (pa == 0)
    800019dc:	c131                	beqz	a0,80001a20 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    800019de:	416485b3          	sub	a1,s1,s6
    800019e2:	858d                	srai	a1,a1,0x3
    800019e4:	000ab783          	ld	a5,0(s5)
    800019e8:	02f585b3          	mul	a1,a1,a5
    800019ec:	2585                	addiw	a1,a1,1
    800019ee:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019f2:	4719                	li	a4,6
    800019f4:	6685                	lui	a3,0x1
    800019f6:	40b905b3          	sub	a1,s2,a1
    800019fa:	854e                	mv	a0,s3
    800019fc:	00000097          	auipc	ra,0x0
    80001a00:	868080e7          	jalr	-1944(ra) # 80001264 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a04:	1e848493          	addi	s1,s1,488
    80001a08:	fd4495e3          	bne	s1,s4,800019d2 <proc_mapstacks+0x38>
  }
}
    80001a0c:	70e2                	ld	ra,56(sp)
    80001a0e:	7442                	ld	s0,48(sp)
    80001a10:	74a2                	ld	s1,40(sp)
    80001a12:	7902                	ld	s2,32(sp)
    80001a14:	69e2                	ld	s3,24(sp)
    80001a16:	6a42                	ld	s4,16(sp)
    80001a18:	6aa2                	ld	s5,8(sp)
    80001a1a:	6b02                	ld	s6,0(sp)
    80001a1c:	6121                	addi	sp,sp,64
    80001a1e:	8082                	ret
      panic("kalloc");
    80001a20:	00007517          	auipc	a0,0x7
    80001a24:	7d850513          	addi	a0,a0,2008 # 800091f8 <digits+0x1b8>
    80001a28:	fffff097          	auipc	ra,0xfffff
    80001a2c:	b18080e7          	jalr	-1256(ra) # 80000540 <panic>

0000000080001a30 <procinit>:

// initialize the proc table.
void procinit(void)
{
    80001a30:	7139                	addi	sp,sp,-64
    80001a32:	fc06                	sd	ra,56(sp)
    80001a34:	f822                	sd	s0,48(sp)
    80001a36:	f426                	sd	s1,40(sp)
    80001a38:	f04a                	sd	s2,32(sp)
    80001a3a:	ec4e                	sd	s3,24(sp)
    80001a3c:	e852                	sd	s4,16(sp)
    80001a3e:	e456                	sd	s5,8(sp)
    80001a40:	e05a                	sd	s6,0(sp)
    80001a42:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001a44:	00007597          	auipc	a1,0x7
    80001a48:	7bc58593          	addi	a1,a1,1980 # 80009200 <digits+0x1c0>
    80001a4c:	00230517          	auipc	a0,0x230
    80001a50:	41c50513          	addi	a0,a0,1052 # 80231e68 <pid_lock>
    80001a54:	fffff097          	auipc	ra,0xfffff
    80001a58:	210080e7          	jalr	528(ra) # 80000c64 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001a5c:	00007597          	auipc	a1,0x7
    80001a60:	7ac58593          	addi	a1,a1,1964 # 80009208 <digits+0x1c8>
    80001a64:	00230517          	auipc	a0,0x230
    80001a68:	41c50513          	addi	a0,a0,1052 # 80231e80 <wait_lock>
    80001a6c:	fffff097          	auipc	ra,0xfffff
    80001a70:	1f8080e7          	jalr	504(ra) # 80000c64 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a74:	00231497          	auipc	s1,0x231
    80001a78:	82448493          	addi	s1,s1,-2012 # 80232298 <proc>
  {
    initlock(&p->lock, "proc");
    80001a7c:	00007b17          	auipc	s6,0x7
    80001a80:	79cb0b13          	addi	s6,s6,1948 # 80009218 <digits+0x1d8>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001a84:	8aa6                	mv	s5,s1
    80001a86:	00007a17          	auipc	s4,0x7
    80001a8a:	57aa0a13          	addi	s4,s4,1402 # 80009000 <etext>
    80001a8e:	04000937          	lui	s2,0x4000
    80001a92:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001a94:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001a96:	00238997          	auipc	s3,0x238
    80001a9a:	20298993          	addi	s3,s3,514 # 80239c98 <queuetable>
    initlock(&p->lock, "proc");
    80001a9e:	85da                	mv	a1,s6
    80001aa0:	8526                	mv	a0,s1
    80001aa2:	fffff097          	auipc	ra,0xfffff
    80001aa6:	1c2080e7          	jalr	450(ra) # 80000c64 <initlock>
    p->state = UNUSED;
    80001aaa:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001aae:	415487b3          	sub	a5,s1,s5
    80001ab2:	878d                	srai	a5,a5,0x3
    80001ab4:	000a3703          	ld	a4,0(s4)
    80001ab8:	02e787b3          	mul	a5,a5,a4
    80001abc:	2785                	addiw	a5,a5,1
    80001abe:	00d7979b          	slliw	a5,a5,0xd
    80001ac2:	40f907b3          	sub	a5,s2,a5
    80001ac6:	e4dc                	sd	a5,136(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80001ac8:	1e848493          	addi	s1,s1,488
    80001acc:	fd3499e3          	bne	s1,s3,80001a9e <procinit+0x6e>
  }
}
    80001ad0:	70e2                	ld	ra,56(sp)
    80001ad2:	7442                	ld	s0,48(sp)
    80001ad4:	74a2                	ld	s1,40(sp)
    80001ad6:	7902                	ld	s2,32(sp)
    80001ad8:	69e2                	ld	s3,24(sp)
    80001ada:	6a42                	ld	s4,16(sp)
    80001adc:	6aa2                	ld	s5,8(sp)
    80001ade:	6b02                	ld	s6,0(sp)
    80001ae0:	6121                	addi	sp,sp,64
    80001ae2:	8082                	ret

0000000080001ae4 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80001ae4:	1141                	addi	sp,sp,-16
    80001ae6:	e422                	sd	s0,8(sp)
    80001ae8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp"
    80001aea:	8512                	mv	a0,tp
  return r_tp();
  // return id;
}
    80001aec:	2501                	sext.w	a0,a0
    80001aee:	6422                	ld	s0,8(sp)
    80001af0:	0141                	addi	sp,sp,16
    80001af2:	8082                	ret

0000000080001af4 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001af4:	1141                	addi	sp,sp,-16
    80001af6:	e422                	sd	s0,8(sp)
    80001af8:	0800                	addi	s0,sp,16
    80001afa:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001afc:	2781                	sext.w	a5,a5
    80001afe:	079e                	slli	a5,a5,0x7
  return c;
}
    80001b00:	00230517          	auipc	a0,0x230
    80001b04:	39850513          	addi	a0,a0,920 # 80231e98 <cpus>
    80001b08:	953e                	add	a0,a0,a5
    80001b0a:	6422                	ld	s0,8(sp)
    80001b0c:	0141                	addi	sp,sp,16
    80001b0e:	8082                	ret

0000000080001b10 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001b10:	1101                	addi	sp,sp,-32
    80001b12:	ec06                	sd	ra,24(sp)
    80001b14:	e822                	sd	s0,16(sp)
    80001b16:	e426                	sd	s1,8(sp)
    80001b18:	1000                	addi	s0,sp,32
  push_off();
    80001b1a:	fffff097          	auipc	ra,0xfffff
    80001b1e:	18e080e7          	jalr	398(ra) # 80000ca8 <push_off>
    80001b22:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001b24:	2781                	sext.w	a5,a5
    80001b26:	079e                	slli	a5,a5,0x7
    80001b28:	00230717          	auipc	a4,0x230
    80001b2c:	34070713          	addi	a4,a4,832 # 80231e68 <pid_lock>
    80001b30:	97ba                	add	a5,a5,a4
    80001b32:	7b84                	ld	s1,48(a5)
  pop_off();
    80001b34:	fffff097          	auipc	ra,0xfffff
    80001b38:	214080e7          	jalr	532(ra) # 80000d48 <pop_off>
  return p;
}
    80001b3c:	8526                	mv	a0,s1
    80001b3e:	60e2                	ld	ra,24(sp)
    80001b40:	6442                	ld	s0,16(sp)
    80001b42:	64a2                	ld	s1,8(sp)
    80001b44:	6105                	addi	sp,sp,32
    80001b46:	8082                	ret

0000000080001b48 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001b48:	1141                	addi	sp,sp,-16
    80001b4a:	e406                	sd	ra,8(sp)
    80001b4c:	e022                	sd	s0,0(sp)
    80001b4e:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001b50:	00000097          	auipc	ra,0x0
    80001b54:	fc0080e7          	jalr	-64(ra) # 80001b10 <myproc>
    80001b58:	fffff097          	auipc	ra,0xfffff
    80001b5c:	250080e7          	jalr	592(ra) # 80000da8 <release>

  if (first)
    80001b60:	00008797          	auipc	a5,0x8
    80001b64:	e807a783          	lw	a5,-384(a5) # 800099e0 <first.1>
    80001b68:	eb89                	bnez	a5,80001b7a <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001b6a:	00001097          	auipc	ra,0x1
    80001b6e:	47a080e7          	jalr	1146(ra) # 80002fe4 <usertrapret>
}
    80001b72:	60a2                	ld	ra,8(sp)
    80001b74:	6402                	ld	s0,0(sp)
    80001b76:	0141                	addi	sp,sp,16
    80001b78:	8082                	ret
    first = 0;
    80001b7a:	00008797          	auipc	a5,0x8
    80001b7e:	e607a323          	sw	zero,-410(a5) # 800099e0 <first.1>
    fsinit(ROOTDEV);
    80001b82:	4505                	li	a0,1
    80001b84:	00002097          	auipc	ra,0x2
    80001b88:	4f4080e7          	jalr	1268(ra) # 80004078 <fsinit>
    80001b8c:	bff9                	j	80001b6a <forkret+0x22>

0000000080001b8e <allocpid>:
{
    80001b8e:	1101                	addi	sp,sp,-32
    80001b90:	ec06                	sd	ra,24(sp)
    80001b92:	e822                	sd	s0,16(sp)
    80001b94:	e426                	sd	s1,8(sp)
    80001b96:	e04a                	sd	s2,0(sp)
    80001b98:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001b9a:	00230917          	auipc	s2,0x230
    80001b9e:	2ce90913          	addi	s2,s2,718 # 80231e68 <pid_lock>
    80001ba2:	854a                	mv	a0,s2
    80001ba4:	fffff097          	auipc	ra,0xfffff
    80001ba8:	150080e7          	jalr	336(ra) # 80000cf4 <acquire>
  pid = nextpid;
    80001bac:	00008797          	auipc	a5,0x8
    80001bb0:	e3878793          	addi	a5,a5,-456 # 800099e4 <nextpid>
    80001bb4:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001bb6:	0014871b          	addiw	a4,s1,1
    80001bba:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001bbc:	854a                	mv	a0,s2
    80001bbe:	fffff097          	auipc	ra,0xfffff
    80001bc2:	1ea080e7          	jalr	490(ra) # 80000da8 <release>
}
    80001bc6:	8526                	mv	a0,s1
    80001bc8:	60e2                	ld	ra,24(sp)
    80001bca:	6442                	ld	s0,16(sp)
    80001bcc:	64a2                	ld	s1,8(sp)
    80001bce:	6902                	ld	s2,0(sp)
    80001bd0:	6105                	addi	sp,sp,32
    80001bd2:	8082                	ret

0000000080001bd4 <proc_pagetable>:
{
    80001bd4:	1101                	addi	sp,sp,-32
    80001bd6:	ec06                	sd	ra,24(sp)
    80001bd8:	e822                	sd	s0,16(sp)
    80001bda:	e426                	sd	s1,8(sp)
    80001bdc:	e04a                	sd	s2,0(sp)
    80001bde:	1000                	addi	s0,sp,32
    80001be0:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001be2:	00000097          	auipc	ra,0x0
    80001be6:	86c080e7          	jalr	-1940(ra) # 8000144e <uvmcreate>
    80001bea:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001bec:	c121                	beqz	a0,80001c2c <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001bee:	4729                	li	a4,10
    80001bf0:	00006697          	auipc	a3,0x6
    80001bf4:	41068693          	addi	a3,a3,1040 # 80008000 <_trampoline>
    80001bf8:	6605                	lui	a2,0x1
    80001bfa:	040005b7          	lui	a1,0x4000
    80001bfe:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c00:	05b2                	slli	a1,a1,0xc
    80001c02:	fffff097          	auipc	ra,0xfffff
    80001c06:	5c2080e7          	jalr	1474(ra) # 800011c4 <mappages>
    80001c0a:	02054863          	bltz	a0,80001c3a <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001c0e:	4719                	li	a4,6
    80001c10:	0a093683          	ld	a3,160(s2)
    80001c14:	6605                	lui	a2,0x1
    80001c16:	020005b7          	lui	a1,0x2000
    80001c1a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c1c:	05b6                	slli	a1,a1,0xd
    80001c1e:	8526                	mv	a0,s1
    80001c20:	fffff097          	auipc	ra,0xfffff
    80001c24:	5a4080e7          	jalr	1444(ra) # 800011c4 <mappages>
    80001c28:	02054163          	bltz	a0,80001c4a <proc_pagetable+0x76>
}
    80001c2c:	8526                	mv	a0,s1
    80001c2e:	60e2                	ld	ra,24(sp)
    80001c30:	6442                	ld	s0,16(sp)
    80001c32:	64a2                	ld	s1,8(sp)
    80001c34:	6902                	ld	s2,0(sp)
    80001c36:	6105                	addi	sp,sp,32
    80001c38:	8082                	ret
    uvmfree(pagetable, 0);
    80001c3a:	4581                	li	a1,0
    80001c3c:	8526                	mv	a0,s1
    80001c3e:	00000097          	auipc	ra,0x0
    80001c42:	a16080e7          	jalr	-1514(ra) # 80001654 <uvmfree>
    return 0;
    80001c46:	4481                	li	s1,0
    80001c48:	b7d5                	j	80001c2c <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c4a:	4681                	li	a3,0
    80001c4c:	4605                	li	a2,1
    80001c4e:	040005b7          	lui	a1,0x4000
    80001c52:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c54:	05b2                	slli	a1,a1,0xc
    80001c56:	8526                	mv	a0,s1
    80001c58:	fffff097          	auipc	ra,0xfffff
    80001c5c:	732080e7          	jalr	1842(ra) # 8000138a <uvmunmap>
    uvmfree(pagetable, 0);
    80001c60:	4581                	li	a1,0
    80001c62:	8526                	mv	a0,s1
    80001c64:	00000097          	auipc	ra,0x0
    80001c68:	9f0080e7          	jalr	-1552(ra) # 80001654 <uvmfree>
    return 0;
    80001c6c:	4481                	li	s1,0
    80001c6e:	bf7d                	j	80001c2c <proc_pagetable+0x58>

0000000080001c70 <proc_freepagetable>:
{
    80001c70:	1101                	addi	sp,sp,-32
    80001c72:	ec06                	sd	ra,24(sp)
    80001c74:	e822                	sd	s0,16(sp)
    80001c76:	e426                	sd	s1,8(sp)
    80001c78:	e04a                	sd	s2,0(sp)
    80001c7a:	1000                	addi	s0,sp,32
    80001c7c:	84aa                	mv	s1,a0
    80001c7e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c80:	4681                	li	a3,0
    80001c82:	4605                	li	a2,1
    80001c84:	040005b7          	lui	a1,0x4000
    80001c88:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c8a:	05b2                	slli	a1,a1,0xc
    80001c8c:	fffff097          	auipc	ra,0xfffff
    80001c90:	6fe080e7          	jalr	1790(ra) # 8000138a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001c94:	4681                	li	a3,0
    80001c96:	4605                	li	a2,1
    80001c98:	020005b7          	lui	a1,0x2000
    80001c9c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c9e:	05b6                	slli	a1,a1,0xd
    80001ca0:	8526                	mv	a0,s1
    80001ca2:	fffff097          	auipc	ra,0xfffff
    80001ca6:	6e8080e7          	jalr	1768(ra) # 8000138a <uvmunmap>
  uvmfree(pagetable, sz);
    80001caa:	85ca                	mv	a1,s2
    80001cac:	8526                	mv	a0,s1
    80001cae:	00000097          	auipc	ra,0x0
    80001cb2:	9a6080e7          	jalr	-1626(ra) # 80001654 <uvmfree>
}
    80001cb6:	60e2                	ld	ra,24(sp)
    80001cb8:	6442                	ld	s0,16(sp)
    80001cba:	64a2                	ld	s1,8(sp)
    80001cbc:	6902                	ld	s2,0(sp)
    80001cbe:	6105                	addi	sp,sp,32
    80001cc0:	8082                	ret

0000000080001cc2 <freeproc>:
{
    80001cc2:	1101                	addi	sp,sp,-32
    80001cc4:	ec06                	sd	ra,24(sp)
    80001cc6:	e822                	sd	s0,16(sp)
    80001cc8:	e426                	sd	s1,8(sp)
    80001cca:	1000                	addi	s0,sp,32
    80001ccc:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001cce:	7148                	ld	a0,160(a0)
    80001cd0:	c509                	beqz	a0,80001cda <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001cd2:	fffff097          	auipc	ra,0xfffff
    80001cd6:	d80080e7          	jalr	-640(ra) # 80000a52 <kfree>
  if (p->trapframe_copy)
    80001cda:	6ca8                	ld	a0,88(s1)
    80001cdc:	c509                	beqz	a0,80001ce6 <freeproc+0x24>
    kfree((void *)p->trapframe_copy);
    80001cde:	fffff097          	auipc	ra,0xfffff
    80001ce2:	d74080e7          	jalr	-652(ra) # 80000a52 <kfree>
  p->trapframe = 0;
    80001ce6:	0a04b023          	sd	zero,160(s1)
  if (p->pagetable)
    80001cea:	6cc8                	ld	a0,152(s1)
    80001cec:	c511                	beqz	a0,80001cf8 <freeproc+0x36>
    proc_freepagetable(p->pagetable, p->sz);
    80001cee:	68cc                	ld	a1,144(s1)
    80001cf0:	00000097          	auipc	ra,0x0
    80001cf4:	f80080e7          	jalr	-128(ra) # 80001c70 <proc_freepagetable>
  p->pagetable = 0;
    80001cf8:	0804bc23          	sd	zero,152(s1)
  p->sz = 0;
    80001cfc:	0804b823          	sd	zero,144(s1)
  p->pid = 0;
    80001d00:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001d04:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001d08:	1a048023          	sb	zero,416(s1)
  p->chan = 0;
    80001d0c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001d10:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001d14:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001d18:	0004ac23          	sw	zero,24(s1)
}
    80001d1c:	60e2                	ld	ra,24(sp)
    80001d1e:	6442                	ld	s0,16(sp)
    80001d20:	64a2                	ld	s1,8(sp)
    80001d22:	6105                	addi	sp,sp,32
    80001d24:	8082                	ret

0000000080001d26 <allocproc>:
{
    80001d26:	1101                	addi	sp,sp,-32
    80001d28:	ec06                	sd	ra,24(sp)
    80001d2a:	e822                	sd	s0,16(sp)
    80001d2c:	e426                	sd	s1,8(sp)
    80001d2e:	e04a                	sd	s2,0(sp)
    80001d30:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) // iterating over all processes
    80001d32:	00230497          	auipc	s1,0x230
    80001d36:	56648493          	addi	s1,s1,1382 # 80232298 <proc>
    80001d3a:	00238917          	auipc	s2,0x238
    80001d3e:	f5e90913          	addi	s2,s2,-162 # 80239c98 <queuetable>
    acquire(&p->lock);
    80001d42:	8526                	mv	a0,s1
    80001d44:	fffff097          	auipc	ra,0xfffff
    80001d48:	fb0080e7          	jalr	-80(ra) # 80000cf4 <acquire>
    if (p->state == UNUSED)
    80001d4c:	4c9c                	lw	a5,24(s1)
    80001d4e:	cf81                	beqz	a5,80001d66 <allocproc+0x40>
      release(&p->lock);
    80001d50:	8526                	mv	a0,s1
    80001d52:	fffff097          	auipc	ra,0xfffff
    80001d56:	056080e7          	jalr	86(ra) # 80000da8 <release>
  for (p = proc; p < &proc[NPROC]; p++) // iterating over all processes
    80001d5a:	1e848493          	addi	s1,s1,488
    80001d5e:	ff2492e3          	bne	s1,s2,80001d42 <allocproc+0x1c>
  return 0;
    80001d62:	4481                	li	s1,0
    80001d64:	a0d1                	j	80001e28 <allocproc+0x102>
  p->pid = allocpid();
    80001d66:	00000097          	auipc	ra,0x0
    80001d6a:	e28080e7          	jalr	-472(ra) # 80001b8e <allocpid>
    80001d6e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001d70:	4785                	li	a5,1
    80001d72:	cc9c                	sw	a5,24(s1)
  p->createtime = ticks; // FCFS
    80001d74:	00008717          	auipc	a4,0x8
    80001d78:	e6c72703          	lw	a4,-404(a4) # 80009be0 <ticks>
    80001d7c:	d0f8                	sw	a4,100(s1)
  p->runTime = 0;
    80001d7e:	0604a823          	sw	zero,112(s1)
  p->sleepTime = 0;
    80001d82:	0604ac23          	sw	zero,120(s1)
  p->totalRunTime = 0;
    80001d86:	0604ae23          	sw	zero,124(s1)
  p->num_runs = 0;
    80001d8a:	0804a023          	sw	zero,128(s1)
  p->ticket = 1;
    80001d8e:	d8dc                	sw	a5,52(s1)
  p->schedulecount = 0;
    80001d90:	1c04a023          	sw	zero,448(s1)
  p->scheduletick = 0;
    80001d94:	1a04a823          	sw	zero,432(s1)
  p->sleepingticks = 0;
    80001d98:	1a04ac23          	sw	zero,440(s1)
  p->totalrtime = 0;
    80001d9c:	1a04ae23          	sw	zero,444(s1)
  p->qstate = NOTQUEUED;
    80001da0:	1cf4a223          	sw	a5,452(s1)
  p->q_entertime = 0;
    80001da4:	1c04a823          	sw	zero,464(s1)
  p->qlevel = 0;
    80001da8:	1c04a423          	sw	zero,456(s1)
  p->runningticks = 0;
    80001dac:	1a04aa23          	sw	zero,436(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001db0:	fffff097          	auipc	ra,0xfffff
    80001db4:	e4a080e7          	jalr	-438(ra) # 80000bfa <kalloc>
    80001db8:	892a                	mv	s2,a0
    80001dba:	f0c8                	sd	a0,160(s1)
    80001dbc:	cd2d                	beqz	a0,80001e36 <allocproc+0x110>
  if ((p->trapframe_copy = (struct trapframe *)kalloc()) == 0)
    80001dbe:	fffff097          	auipc	ra,0xfffff
    80001dc2:	e3c080e7          	jalr	-452(ra) # 80000bfa <kalloc>
    80001dc6:	892a                	mv	s2,a0
    80001dc8:	eca8                	sd	a0,88(s1)
    80001dca:	c151                	beqz	a0,80001e4e <allocproc+0x128>
  p->is_sigalarm = 0;
    80001dcc:	0404a023          	sw	zero,64(s1)
  p->ticks = 0;
    80001dd0:	0404a223          	sw	zero,68(s1)
  p->now_ticks = 0;
    80001dd4:	0404a423          	sw	zero,72(s1)
  p->handler = 0;
    80001dd8:	0404b823          	sd	zero,80(s1)
  p->queue_number = 0;
    80001ddc:	0804a223          	sw	zero,132(s1)
  p->pagetable = proc_pagetable(p);
    80001de0:	8526                	mv	a0,s1
    80001de2:	00000097          	auipc	ra,0x0
    80001de6:	df2080e7          	jalr	-526(ra) # 80001bd4 <proc_pagetable>
    80001dea:	892a                	mv	s2,a0
    80001dec:	ecc8                	sd	a0,152(s1)
  if (p->pagetable == 0)
    80001dee:	c53d                	beqz	a0,80001e5c <allocproc+0x136>
    p->q[i] = 0;
    80001df0:	1c04aa23          	sw	zero,468(s1)
    80001df4:	1c04ac23          	sw	zero,472(s1)
    80001df8:	1c04ae23          	sw	zero,476(s1)
    80001dfc:	1e04a023          	sw	zero,480(s1)
    80001e00:	1e04a223          	sw	zero,484(s1)
  memset(&p->context, 0, sizeof(p->context));
    80001e04:	07000613          	li	a2,112
    80001e08:	4581                	li	a1,0
    80001e0a:	0a848513          	addi	a0,s1,168
    80001e0e:	fffff097          	auipc	ra,0xfffff
    80001e12:	fe2080e7          	jalr	-30(ra) # 80000df0 <memset>
  p->context.ra = (uint64)forkret;
    80001e16:	00000797          	auipc	a5,0x0
    80001e1a:	d3278793          	addi	a5,a5,-718 # 80001b48 <forkret>
    80001e1e:	f4dc                	sd	a5,168(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001e20:	64dc                	ld	a5,136(s1)
    80001e22:	6705                	lui	a4,0x1
    80001e24:	97ba                	add	a5,a5,a4
    80001e26:	f8dc                	sd	a5,176(s1)
}
    80001e28:	8526                	mv	a0,s1
    80001e2a:	60e2                	ld	ra,24(sp)
    80001e2c:	6442                	ld	s0,16(sp)
    80001e2e:	64a2                	ld	s1,8(sp)
    80001e30:	6902                	ld	s2,0(sp)
    80001e32:	6105                	addi	sp,sp,32
    80001e34:	8082                	ret
    freeproc(p);
    80001e36:	8526                	mv	a0,s1
    80001e38:	00000097          	auipc	ra,0x0
    80001e3c:	e8a080e7          	jalr	-374(ra) # 80001cc2 <freeproc>
    release(&p->lock);
    80001e40:	8526                	mv	a0,s1
    80001e42:	fffff097          	auipc	ra,0xfffff
    80001e46:	f66080e7          	jalr	-154(ra) # 80000da8 <release>
    return 0;
    80001e4a:	84ca                	mv	s1,s2
    80001e4c:	bff1                	j	80001e28 <allocproc+0x102>
    release(&p->lock);
    80001e4e:	8526                	mv	a0,s1
    80001e50:	fffff097          	auipc	ra,0xfffff
    80001e54:	f58080e7          	jalr	-168(ra) # 80000da8 <release>
    return 0;
    80001e58:	84ca                	mv	s1,s2
    80001e5a:	b7f9                	j	80001e28 <allocproc+0x102>
    freeproc(p);
    80001e5c:	8526                	mv	a0,s1
    80001e5e:	00000097          	auipc	ra,0x0
    80001e62:	e64080e7          	jalr	-412(ra) # 80001cc2 <freeproc>
    release(&p->lock);
    80001e66:	8526                	mv	a0,s1
    80001e68:	fffff097          	auipc	ra,0xfffff
    80001e6c:	f40080e7          	jalr	-192(ra) # 80000da8 <release>
    return 0;
    80001e70:	84ca                	mv	s1,s2
    80001e72:	bf5d                	j	80001e28 <allocproc+0x102>

0000000080001e74 <userinit>:
{
    80001e74:	1101                	addi	sp,sp,-32
    80001e76:	ec06                	sd	ra,24(sp)
    80001e78:	e822                	sd	s0,16(sp)
    80001e7a:	e426                	sd	s1,8(sp)
    80001e7c:	1000                	addi	s0,sp,32
  p = allocproc();
    80001e7e:	00000097          	auipc	ra,0x0
    80001e82:	ea8080e7          	jalr	-344(ra) # 80001d26 <allocproc>
    80001e86:	84aa                	mv	s1,a0
  initproc = p;
    80001e88:	00008797          	auipc	a5,0x8
    80001e8c:	d4a7b823          	sd	a0,-688(a5) # 80009bd8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001e90:	03400613          	li	a2,52
    80001e94:	00008597          	auipc	a1,0x8
    80001e98:	b5c58593          	addi	a1,a1,-1188 # 800099f0 <initcode>
    80001e9c:	6d48                	ld	a0,152(a0)
    80001e9e:	fffff097          	auipc	ra,0xfffff
    80001ea2:	5de080e7          	jalr	1502(ra) # 8000147c <uvmfirst>
  p->sz = PGSIZE;
    80001ea6:	6785                	lui	a5,0x1
    80001ea8:	e8dc                	sd	a5,144(s1)
  p->trapframe->epc = 0;     // user program counter
    80001eaa:	70d8                	ld	a4,160(s1)
    80001eac:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80001eb0:	70d8                	ld	a4,160(s1)
    80001eb2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001eb4:	4641                	li	a2,16
    80001eb6:	00007597          	auipc	a1,0x7
    80001eba:	36a58593          	addi	a1,a1,874 # 80009220 <digits+0x1e0>
    80001ebe:	1a048513          	addi	a0,s1,416
    80001ec2:	fffff097          	auipc	ra,0xfffff
    80001ec6:	078080e7          	jalr	120(ra) # 80000f3a <safestrcpy>
  p->cwd = namei("/");
    80001eca:	00007517          	auipc	a0,0x7
    80001ece:	36650513          	addi	a0,a0,870 # 80009230 <digits+0x1f0>
    80001ed2:	00003097          	auipc	ra,0x3
    80001ed6:	bd0080e7          	jalr	-1072(ra) # 80004aa2 <namei>
    80001eda:	18a4bc23          	sd	a0,408(s1)
  p->state = RUNNABLE;
    80001ede:	478d                	li	a5,3
    80001ee0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001ee2:	8526                	mv	a0,s1
    80001ee4:	fffff097          	auipc	ra,0xfffff
    80001ee8:	ec4080e7          	jalr	-316(ra) # 80000da8 <release>
}
    80001eec:	60e2                	ld	ra,24(sp)
    80001eee:	6442                	ld	s0,16(sp)
    80001ef0:	64a2                	ld	s1,8(sp)
    80001ef2:	6105                	addi	sp,sp,32
    80001ef4:	8082                	ret

0000000080001ef6 <growproc>:
{
    80001ef6:	1101                	addi	sp,sp,-32
    80001ef8:	ec06                	sd	ra,24(sp)
    80001efa:	e822                	sd	s0,16(sp)
    80001efc:	e426                	sd	s1,8(sp)
    80001efe:	e04a                	sd	s2,0(sp)
    80001f00:	1000                	addi	s0,sp,32
    80001f02:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001f04:	00000097          	auipc	ra,0x0
    80001f08:	c0c080e7          	jalr	-1012(ra) # 80001b10 <myproc>
    80001f0c:	84aa                	mv	s1,a0
  sz = p->sz;
    80001f0e:	694c                	ld	a1,144(a0)
  if (n > 0)
    80001f10:	01204c63          	bgtz	s2,80001f28 <growproc+0x32>
  else if (n < 0)
    80001f14:	02094663          	bltz	s2,80001f40 <growproc+0x4a>
  p->sz = sz;
    80001f18:	e8cc                	sd	a1,144(s1)
  return 0;
    80001f1a:	4501                	li	a0,0
}
    80001f1c:	60e2                	ld	ra,24(sp)
    80001f1e:	6442                	ld	s0,16(sp)
    80001f20:	64a2                	ld	s1,8(sp)
    80001f22:	6902                	ld	s2,0(sp)
    80001f24:	6105                	addi	sp,sp,32
    80001f26:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80001f28:	4691                	li	a3,4
    80001f2a:	00b90633          	add	a2,s2,a1
    80001f2e:	6d48                	ld	a0,152(a0)
    80001f30:	fffff097          	auipc	ra,0xfffff
    80001f34:	606080e7          	jalr	1542(ra) # 80001536 <uvmalloc>
    80001f38:	85aa                	mv	a1,a0
    80001f3a:	fd79                	bnez	a0,80001f18 <growproc+0x22>
      return -1;
    80001f3c:	557d                	li	a0,-1
    80001f3e:	bff9                	j	80001f1c <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001f40:	00b90633          	add	a2,s2,a1
    80001f44:	6d48                	ld	a0,152(a0)
    80001f46:	fffff097          	auipc	ra,0xfffff
    80001f4a:	5a8080e7          	jalr	1448(ra) # 800014ee <uvmdealloc>
    80001f4e:	85aa                	mv	a1,a0
    80001f50:	b7e1                	j	80001f18 <growproc+0x22>

0000000080001f52 <fork>:
{
    80001f52:	7139                	addi	sp,sp,-64
    80001f54:	fc06                	sd	ra,56(sp)
    80001f56:	f822                	sd	s0,48(sp)
    80001f58:	f426                	sd	s1,40(sp)
    80001f5a:	f04a                	sd	s2,32(sp)
    80001f5c:	ec4e                	sd	s3,24(sp)
    80001f5e:	e852                	sd	s4,16(sp)
    80001f60:	e456                	sd	s5,8(sp)
    80001f62:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001f64:	00000097          	auipc	ra,0x0
    80001f68:	bac080e7          	jalr	-1108(ra) # 80001b10 <myproc>
    80001f6c:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    80001f6e:	00000097          	auipc	ra,0x0
    80001f72:	db8080e7          	jalr	-584(ra) # 80001d26 <allocproc>
    80001f76:	12050463          	beqz	a0,8000209e <fork+0x14c>
    80001f7a:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80001f7c:	090ab603          	ld	a2,144(s5)
    80001f80:	6d4c                	ld	a1,152(a0)
    80001f82:	098ab503          	ld	a0,152(s5)
    80001f86:	fffff097          	auipc	ra,0xfffff
    80001f8a:	708080e7          	jalr	1800(ra) # 8000168e <uvmcopy>
    80001f8e:	06054063          	bltz	a0,80001fee <fork+0x9c>
  np->sz = p->sz;
    80001f92:	090ab783          	ld	a5,144(s5)
    80001f96:	08f9b823          	sd	a5,144(s3)
  *(np->trapframe) = *(p->trapframe);
    80001f9a:	0a0ab683          	ld	a3,160(s5)
    80001f9e:	87b6                	mv	a5,a3
    80001fa0:	0a09b703          	ld	a4,160(s3)
    80001fa4:	12068693          	addi	a3,a3,288
    80001fa8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001fac:	6788                	ld	a0,8(a5)
    80001fae:	6b8c                	ld	a1,16(a5)
    80001fb0:	6f90                	ld	a2,24(a5)
    80001fb2:	01073023          	sd	a6,0(a4)
    80001fb6:	e708                	sd	a0,8(a4)
    80001fb8:	eb0c                	sd	a1,16(a4)
    80001fba:	ef10                	sd	a2,24(a4)
    80001fbc:	02078793          	addi	a5,a5,32
    80001fc0:	02070713          	addi	a4,a4,32
    80001fc4:	fed792e3          	bne	a5,a3,80001fa8 <fork+0x56>
  np->tracemask = p->tracemask;
    80001fc8:	060aa783          	lw	a5,96(s5)
    80001fcc:	06f9a023          	sw	a5,96(s3)
  np->trapframe->a0 = 0;
    80001fd0:	0a09b783          	ld	a5,160(s3)
    80001fd4:	0607b823          	sd	zero,112(a5)
  np->ticket = p->ticket;
    80001fd8:	034aa783          	lw	a5,52(s5)
    80001fdc:	02f9aa23          	sw	a5,52(s3)
  for (i = 0; i < NOFILE; i++)
    80001fe0:	118a8493          	addi	s1,s5,280
    80001fe4:	11898913          	addi	s2,s3,280
    80001fe8:	198a8a13          	addi	s4,s5,408
    80001fec:	a00d                	j	8000200e <fork+0xbc>
    freeproc(np);
    80001fee:	854e                	mv	a0,s3
    80001ff0:	00000097          	auipc	ra,0x0
    80001ff4:	cd2080e7          	jalr	-814(ra) # 80001cc2 <freeproc>
    release(&np->lock);
    80001ff8:	854e                	mv	a0,s3
    80001ffa:	fffff097          	auipc	ra,0xfffff
    80001ffe:	dae080e7          	jalr	-594(ra) # 80000da8 <release>
    return -1;
    80002002:	597d                	li	s2,-1
    80002004:	a059                	j	8000208a <fork+0x138>
  for (i = 0; i < NOFILE; i++)
    80002006:	04a1                	addi	s1,s1,8
    80002008:	0921                	addi	s2,s2,8
    8000200a:	01448b63          	beq	s1,s4,80002020 <fork+0xce>
    if (p->ofile[i])
    8000200e:	6088                	ld	a0,0(s1)
    80002010:	d97d                	beqz	a0,80002006 <fork+0xb4>
      np->ofile[i] = filedup(p->ofile[i]);
    80002012:	00003097          	auipc	ra,0x3
    80002016:	126080e7          	jalr	294(ra) # 80005138 <filedup>
    8000201a:	00a93023          	sd	a0,0(s2)
    8000201e:	b7e5                	j	80002006 <fork+0xb4>
  np->cwd = idup(p->cwd);
    80002020:	198ab503          	ld	a0,408(s5)
    80002024:	00002097          	auipc	ra,0x2
    80002028:	294080e7          	jalr	660(ra) # 800042b8 <idup>
    8000202c:	18a9bc23          	sd	a0,408(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002030:	4641                	li	a2,16
    80002032:	1a0a8593          	addi	a1,s5,416
    80002036:	1a098513          	addi	a0,s3,416
    8000203a:	fffff097          	auipc	ra,0xfffff
    8000203e:	f00080e7          	jalr	-256(ra) # 80000f3a <safestrcpy>
  pid = np->pid;
    80002042:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80002046:	854e                	mv	a0,s3
    80002048:	fffff097          	auipc	ra,0xfffff
    8000204c:	d60080e7          	jalr	-672(ra) # 80000da8 <release>
  acquire(&wait_lock);
    80002050:	00230497          	auipc	s1,0x230
    80002054:	e3048493          	addi	s1,s1,-464 # 80231e80 <wait_lock>
    80002058:	8526                	mv	a0,s1
    8000205a:	fffff097          	auipc	ra,0xfffff
    8000205e:	c9a080e7          	jalr	-870(ra) # 80000cf4 <acquire>
  np->parent = p;
    80002062:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80002066:	8526                	mv	a0,s1
    80002068:	fffff097          	auipc	ra,0xfffff
    8000206c:	d40080e7          	jalr	-704(ra) # 80000da8 <release>
  acquire(&np->lock);
    80002070:	854e                	mv	a0,s3
    80002072:	fffff097          	auipc	ra,0xfffff
    80002076:	c82080e7          	jalr	-894(ra) # 80000cf4 <acquire>
  np->state = RUNNABLE;
    8000207a:	478d                	li	a5,3
    8000207c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80002080:	854e                	mv	a0,s3
    80002082:	fffff097          	auipc	ra,0xfffff
    80002086:	d26080e7          	jalr	-730(ra) # 80000da8 <release>
}
    8000208a:	854a                	mv	a0,s2
    8000208c:	70e2                	ld	ra,56(sp)
    8000208e:	7442                	ld	s0,48(sp)
    80002090:	74a2                	ld	s1,40(sp)
    80002092:	7902                	ld	s2,32(sp)
    80002094:	69e2                	ld	s3,24(sp)
    80002096:	6a42                	ld	s4,16(sp)
    80002098:	6aa2                	ld	s5,8(sp)
    8000209a:	6121                	addi	sp,sp,64
    8000209c:	8082                	ret
    return -1;
    8000209e:	597d                	li	s2,-1
    800020a0:	b7ed                	j	8000208a <fork+0x138>

00000000800020a2 <getpreempted>:
  for (int i = 0; i < level; i++)
    800020a2:	08a05063          	blez	a0,80002122 <getpreempted+0x80>
{
    800020a6:	dc010113          	addi	sp,sp,-576
    800020aa:	22113c23          	sd	ra,568(sp)
    800020ae:	22813823          	sd	s0,560(sp)
    800020b2:	22913423          	sd	s1,552(sp)
    800020b6:	23213023          	sd	s2,544(sp)
    800020ba:	21313c23          	sd	s3,536(sp)
    800020be:	0480                	addi	s0,sp,576
    800020c0:	892a                	mv	s2,a0
  for (int i = 0; i < level; i++)
    800020c2:	4481                	li	s1,0
    if (!empty(queuetable[i]))
    800020c4:	00238997          	auipc	s3,0x238
    800020c8:	bd498993          	addi	s3,s3,-1068 # 80239c98 <queuetable>
    800020cc:	00549793          	slli	a5,s1,0x5
    800020d0:	97a6                	add	a5,a5,s1
    800020d2:	0792                	slli	a5,a5,0x4
    800020d4:	97ce                	add	a5,a5,s3
    800020d6:	dc040713          	addi	a4,s0,-576
    800020da:	21078313          	addi	t1,a5,528
    800020de:	0007b883          	ld	a7,0(a5)
    800020e2:	0087b803          	ld	a6,8(a5)
    800020e6:	6b88                	ld	a0,16(a5)
    800020e8:	6f8c                	ld	a1,24(a5)
    800020ea:	7390                	ld	a2,32(a5)
    800020ec:	7794                	ld	a3,40(a5)
    800020ee:	01173023          	sd	a7,0(a4)
    800020f2:	01073423          	sd	a6,8(a4)
    800020f6:	eb08                	sd	a0,16(a4)
    800020f8:	ef0c                	sd	a1,24(a4)
    800020fa:	f310                	sd	a2,32(a4)
    800020fc:	f714                	sd	a3,40(a4)
    800020fe:	03078793          	addi	a5,a5,48
    80002102:	03070713          	addi	a4,a4,48
    80002106:	fc679ce3          	bne	a5,t1,800020de <getpreempted+0x3c>
    8000210a:	dc040513          	addi	a0,s0,-576
    8000210e:	00005097          	auipc	ra,0x5
    80002112:	b0a080e7          	jalr	-1270(ra) # 80006c18 <empty>
    80002116:	c901                	beqz	a0,80002126 <getpreempted+0x84>
  for (int i = 0; i < level; i++)
    80002118:	2485                	addiw	s1,s1,1
    8000211a:	fa9919e3          	bne	s2,s1,800020cc <getpreempted+0x2a>
  return 0;
    8000211e:	4501                	li	a0,0
    80002120:	a021                	j	80002128 <getpreempted+0x86>
    80002122:	4501                	li	a0,0
}
    80002124:	8082                	ret
      return 1;
    80002126:	4505                	li	a0,1
}
    80002128:	23813083          	ld	ra,568(sp)
    8000212c:	23013403          	ld	s0,560(sp)
    80002130:	22813483          	ld	s1,552(sp)
    80002134:	22013903          	ld	s2,544(sp)
    80002138:	21813983          	ld	s3,536(sp)
    8000213c:	24010113          	addi	sp,sp,576
    80002140:	8082                	ret

0000000080002142 <scheduler>:
{
    80002142:	d7010113          	addi	sp,sp,-656
    80002146:	28113423          	sd	ra,648(sp)
    8000214a:	28813023          	sd	s0,640(sp)
    8000214e:	26913c23          	sd	s1,632(sp)
    80002152:	27213823          	sd	s2,624(sp)
    80002156:	27313423          	sd	s3,616(sp)
    8000215a:	27413023          	sd	s4,608(sp)
    8000215e:	25513c23          	sd	s5,600(sp)
    80002162:	25613823          	sd	s6,592(sp)
    80002166:	25713423          	sd	s7,584(sp)
    8000216a:	25813023          	sd	s8,576(sp)
    8000216e:	23913c23          	sd	s9,568(sp)
    80002172:	23a13823          	sd	s10,560(sp)
    80002176:	23b13423          	sd	s11,552(sp)
    8000217a:	0d00                	addi	s0,sp,656
    8000217c:	8492                	mv	s1,tp
  return r_tp();
    8000217e:	2481                	sext.w	s1,s1
  c->proc = 0;
    80002180:	00749913          	slli	s2,s1,0x7
    80002184:	00230797          	auipc	a5,0x230
    80002188:	ce478793          	addi	a5,a5,-796 # 80231e68 <pid_lock>
    8000218c:	97ca                	add	a5,a5,s2
    8000218e:	0207b823          	sd	zero,48(a5)
  printf("MLFQ\n");
    80002192:	00007517          	auipc	a0,0x7
    80002196:	0a650513          	addi	a0,a0,166 # 80009238 <digits+0x1f8>
    8000219a:	ffffe097          	auipc	ra,0xffffe
    8000219e:	3f0080e7          	jalr	1008(ra) # 8000058a <printf>
      swtch(&c->context, &pp->context);
    800021a2:	00230797          	auipc	a5,0x230
    800021a6:	cfe78793          	addi	a5,a5,-770 # 80231ea0 <cpus+0x8>
    800021aa:	97ca                	add	a5,a5,s2
    800021ac:	d6f43c23          	sd	a5,-648(s0)
      if (p->state == RUNNABLE && ticks - p->q_entertime >= AGE)
    800021b0:	490d                	li	s2,3
        remove(&queuetable[p->qlevel], p);
    800021b2:	00238b17          	auipc	s6,0x238
    800021b6:	ae6b0b13          	addi	s6,s6,-1306 # 80239c98 <queuetable>
      c->proc = pp;
    800021ba:	049e                	slli	s1,s1,0x7
    800021bc:	00230797          	auipc	a5,0x230
    800021c0:	cac78793          	addi	a5,a5,-852 # 80231e68 <pid_lock>
    800021c4:	97a6                	add	a5,a5,s1
    800021c6:	d6f43823          	sd	a5,-656(s0)
    800021ca:	aa79                	j	80002368 <scheduler+0x226>
    for (p = proc; p < &proc[NPROC]; p++)
    800021cc:	1e848493          	addi	s1,s1,488
    800021d0:	07348263          	beq	s1,s3,80002234 <scheduler+0xf2>
      if (p->state == RUNNABLE && ticks - p->q_entertime >= AGE)
    800021d4:	4c9c                	lw	a5,24(s1)
    800021d6:	ff279be3          	bne	a5,s2,800021cc <scheduler+0x8a>
    800021da:	000c2783          	lw	a5,0(s8) # 1000 <_entry-0x7ffff000>
    800021de:	1d04a703          	lw	a4,464(s1)
    800021e2:	9f99                	subw	a5,a5,a4
    800021e4:	fefaf4e3          	bgeu	s5,a5,800021cc <scheduler+0x8a>
        remove(&queuetable[p->qlevel], p);
    800021e8:	1c84a783          	lw	a5,456(s1)
    800021ec:	00579513          	slli	a0,a5,0x5
    800021f0:	953e                	add	a0,a0,a5
    800021f2:	0512                	slli	a0,a0,0x4
    800021f4:	85a6                	mv	a1,s1
    800021f6:	955a                	add	a0,a0,s6
    800021f8:	00005097          	auipc	ra,0x5
    800021fc:	9a6080e7          	jalr	-1626(ra) # 80006b9e <remove>
        acquire(&p->lock);
    80002200:	8526                	mv	a0,s1
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	af2080e7          	jalr	-1294(ra) # 80000cf4 <acquire>
        p->qlevel--;
    8000220a:	1c84a783          	lw	a5,456(s1)
    8000220e:	37fd                	addiw	a5,a5,-1
    80002210:	0007871b          	sext.w	a4,a5
    80002214:	fff74713          	not	a4,a4
    80002218:	977d                	srai	a4,a4,0x3f
    8000221a:	8ff9                	and	a5,a5,a4
    8000221c:	1cf4a423          	sw	a5,456(s1)
        p->q_entertime = ticks;
    80002220:	000c2783          	lw	a5,0(s8)
    80002224:	1cf4a823          	sw	a5,464(s1)
        release(&p->lock);
    80002228:	8526                	mv	a0,s1
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	b7e080e7          	jalr	-1154(ra) # 80000da8 <release>
    80002232:	bf69                	j	800021cc <scheduler+0x8a>
    for (p = proc; p < &proc[NPROC]; p++)
    80002234:	00230497          	auipc	s1,0x230
    80002238:	06448493          	addi	s1,s1,100 # 80232298 <proc>
    8000223c:	a811                	j	80002250 <scheduler+0x10e>
      release(&p->lock);
    8000223e:	8526                	mv	a0,s1
    80002240:	fffff097          	auipc	ra,0xfffff
    80002244:	b68080e7          	jalr	-1176(ra) # 80000da8 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002248:	1e848493          	addi	s1,s1,488
    8000224c:	03348d63          	beq	s1,s3,80002286 <scheduler+0x144>
      acquire(&p->lock);
    80002250:	8526                	mv	a0,s1
    80002252:	fffff097          	auipc	ra,0xfffff
    80002256:	aa2080e7          	jalr	-1374(ra) # 80000cf4 <acquire>
      if (p->state == RUNNABLE && p->qstate == NOTQUEUED)
    8000225a:	4c9c                	lw	a5,24(s1)
    8000225c:	ff2791e3          	bne	a5,s2,8000223e <scheduler+0xfc>
    80002260:	1c44a783          	lw	a5,452(s1)
    80002264:	fd479de3          	bne	a5,s4,8000223e <scheduler+0xfc>
        push(&queuetable[p->qlevel], p);
    80002268:	1c84a783          	lw	a5,456(s1)
    8000226c:	00579513          	slli	a0,a5,0x5
    80002270:	953e                	add	a0,a0,a5
    80002272:	0512                	slli	a0,a0,0x4
    80002274:	85a6                	mv	a1,s1
    80002276:	955a                	add	a0,a0,s6
    80002278:	00005097          	auipc	ra,0x5
    8000227c:	8aa080e7          	jalr	-1878(ra) # 80006b22 <push>
        p->qstate = QUEUED;
    80002280:	1c04a223          	sw	zero,452(s1)
    80002284:	bf6d                	j	8000223e <scheduler+0xfc>
    80002286:	00238d17          	auipc	s10,0x238
    8000228a:	a12d0d13          	addi	s10,s10,-1518 # 80239c98 <queuetable>
    for (int i = 0; i < 5; i++)
    8000228e:	4c81                	li	s9,0
    80002290:	4d95                	li	s11,5
    80002292:	a031                	j	8000229e <scheduler+0x15c>
    80002294:	2c85                	addiw	s9,s9,1 # fffffffffffff001 <end+0xffffffff7fdb81b9>
    80002296:	210d0d13          	addi	s10,s10,528
    8000229a:	0fbc8063          	beq	s9,s11,8000237a <scheduler+0x238>
        struct proc *p = pop(&queuetable[i]);
    8000229e:	8bea                	mv	s7,s10
      while (!empty(queuetable[i]))
    800022a0:	005c9a93          	slli	s5,s9,0x5
    800022a4:	9ae6                	add	s5,s5,s9
    800022a6:	0a92                	slli	s5,s5,0x4
    800022a8:	015b07b3          	add	a5,s6,s5
    800022ac:	d8040713          	addi	a4,s0,-640
    800022b0:	21078313          	addi	t1,a5,528
    800022b4:	0007b883          	ld	a7,0(a5)
    800022b8:	0087b803          	ld	a6,8(a5)
    800022bc:	6b88                	ld	a0,16(a5)
    800022be:	6f8c                	ld	a1,24(a5)
    800022c0:	7390                	ld	a2,32(a5)
    800022c2:	7794                	ld	a3,40(a5)
    800022c4:	01173023          	sd	a7,0(a4)
    800022c8:	01073423          	sd	a6,8(a4)
    800022cc:	eb08                	sd	a0,16(a4)
    800022ce:	ef0c                	sd	a1,24(a4)
    800022d0:	f310                	sd	a2,32(a4)
    800022d2:	f714                	sd	a3,40(a4)
    800022d4:	03078793          	addi	a5,a5,48
    800022d8:	03070713          	addi	a4,a4,48
    800022dc:	fc679ce3          	bne	a5,t1,800022b4 <scheduler+0x172>
    800022e0:	d8040513          	addi	a0,s0,-640
    800022e4:	00005097          	auipc	ra,0x5
    800022e8:	934080e7          	jalr	-1740(ra) # 80006c18 <empty>
    800022ec:	f545                	bnez	a0,80002294 <scheduler+0x152>
        struct proc *p = pop(&queuetable[i]);
    800022ee:	855e                	mv	a0,s7
    800022f0:	00005097          	auipc	ra,0x5
    800022f4:	870080e7          	jalr	-1936(ra) # 80006b60 <pop>
    800022f8:	84aa                	mv	s1,a0
        p->qstate = NOTQUEUED;
    800022fa:	1d452223          	sw	s4,452(a0)
        if (p->state == RUNNABLE)
    800022fe:	4d1c                	lw	a5,24(a0)
    80002300:	fb2794e3          	bne	a5,s2,800022a8 <scheduler+0x166>
      acquire(&pp->lock);
    80002304:	fffff097          	auipc	ra,0xfffff
    80002308:	9f0080e7          	jalr	-1552(ra) # 80000cf4 <acquire>
      pp->scheduletick = ticks;
    8000230c:	00008997          	auipc	s3,0x8
    80002310:	8d498993          	addi	s3,s3,-1836 # 80009be0 <ticks>
    80002314:	0009a783          	lw	a5,0(s3)
    80002318:	1af4a823          	sw	a5,432(s1)
      pp->q_entertime = ticks;
    8000231c:	1cf4a823          	sw	a5,464(s1)
      pp->state = RUNNING;
    80002320:	4791                	li	a5,4
    80002322:	cc9c                	sw	a5,24(s1)
      pp->qruntime = 0;
    80002324:	1c04a623          	sw	zero,460(s1)
      pp->runningticks = 0;
    80002328:	1a04aa23          	sw	zero,436(s1)
      pp->sleepingticks = 0;
    8000232c:	1a04ac23          	sw	zero,440(s1)
      pp->schedulecount++;
    80002330:	1c04a783          	lw	a5,448(s1)
    80002334:	2785                	addiw	a5,a5,1
    80002336:	1cf4a023          	sw	a5,448(s1)
      c->proc = pp;
    8000233a:	d7043a03          	ld	s4,-656(s0)
    8000233e:	029a3823          	sd	s1,48(s4)
      swtch(&c->context, &pp->context);
    80002342:	0a848593          	addi	a1,s1,168
    80002346:	d7843503          	ld	a0,-648(s0)
    8000234a:	00001097          	auipc	ra,0x1
    8000234e:	b30080e7          	jalr	-1232(ra) # 80002e7a <swtch>
      pp->q_entertime = ticks;
    80002352:	0009a783          	lw	a5,0(s3)
    80002356:	1cf4a823          	sw	a5,464(s1)
      c->proc = 0;
    8000235a:	020a3823          	sd	zero,48(s4)
      release(&pp->lock);
    8000235e:	8526                	mv	a0,s1
    80002360:	fffff097          	auipc	ra,0xfffff
    80002364:	a48080e7          	jalr	-1464(ra) # 80000da8 <release>
      if (p->state == RUNNABLE && ticks - p->q_entertime >= AGE)
    80002368:	00008c17          	auipc	s8,0x8
    8000236c:	878c0c13          	addi	s8,s8,-1928 # 80009be0 <ticks>
    for (p = proc; p < &proc[NPROC]; p++)
    80002370:	00238997          	auipc	s3,0x238
    80002374:	92898993          	addi	s3,s3,-1752 # 80239c98 <queuetable>
      if (p->state == RUNNABLE && p->qstate == NOTQUEUED)
    80002378:	4a05                	li	s4,1
  asm volatile("csrr %0, sstatus"
    8000237a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000237e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0"
    80002382:	10079073          	csrw	sstatus,a5
    for (p = proc; p < &proc[NPROC]; p++)
    80002386:	00230497          	auipc	s1,0x230
    8000238a:	f1248493          	addi	s1,s1,-238 # 80232298 <proc>
      if (p->state == RUNNABLE && ticks - p->q_entertime >= AGE)
    8000238e:	4acd                	li	s5,19
    80002390:	b591                	j	800021d4 <scheduler+0x92>

0000000080002392 <sched>:
{
    80002392:	7179                	addi	sp,sp,-48
    80002394:	f406                	sd	ra,40(sp)
    80002396:	f022                	sd	s0,32(sp)
    80002398:	ec26                	sd	s1,24(sp)
    8000239a:	e84a                	sd	s2,16(sp)
    8000239c:	e44e                	sd	s3,8(sp)
    8000239e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800023a0:	fffff097          	auipc	ra,0xfffff
    800023a4:	770080e7          	jalr	1904(ra) # 80001b10 <myproc>
    800023a8:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    800023aa:	fffff097          	auipc	ra,0xfffff
    800023ae:	8d0080e7          	jalr	-1840(ra) # 80000c7a <holding>
    800023b2:	c93d                	beqz	a0,80002428 <sched+0x96>
  asm volatile("mv %0, tp"
    800023b4:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    800023b6:	2781                	sext.w	a5,a5
    800023b8:	079e                	slli	a5,a5,0x7
    800023ba:	00230717          	auipc	a4,0x230
    800023be:	aae70713          	addi	a4,a4,-1362 # 80231e68 <pid_lock>
    800023c2:	97ba                	add	a5,a5,a4
    800023c4:	0a87a703          	lw	a4,168(a5)
    800023c8:	4785                	li	a5,1
    800023ca:	06f71763          	bne	a4,a5,80002438 <sched+0xa6>
  if (p->state == RUNNING)
    800023ce:	4c98                	lw	a4,24(s1)
    800023d0:	4791                	li	a5,4
    800023d2:	06f70b63          	beq	a4,a5,80002448 <sched+0xb6>
  asm volatile("csrr %0, sstatus"
    800023d6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800023da:	8b89                	andi	a5,a5,2
  if (intr_get())
    800023dc:	efb5                	bnez	a5,80002458 <sched+0xc6>
  asm volatile("mv %0, tp"
    800023de:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800023e0:	00230917          	auipc	s2,0x230
    800023e4:	a8890913          	addi	s2,s2,-1400 # 80231e68 <pid_lock>
    800023e8:	2781                	sext.w	a5,a5
    800023ea:	079e                	slli	a5,a5,0x7
    800023ec:	97ca                	add	a5,a5,s2
    800023ee:	0ac7a983          	lw	s3,172(a5)
    800023f2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800023f4:	2781                	sext.w	a5,a5
    800023f6:	079e                	slli	a5,a5,0x7
    800023f8:	00230597          	auipc	a1,0x230
    800023fc:	aa858593          	addi	a1,a1,-1368 # 80231ea0 <cpus+0x8>
    80002400:	95be                	add	a1,a1,a5
    80002402:	0a848513          	addi	a0,s1,168
    80002406:	00001097          	auipc	ra,0x1
    8000240a:	a74080e7          	jalr	-1420(ra) # 80002e7a <swtch>
    8000240e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002410:	2781                	sext.w	a5,a5
    80002412:	079e                	slli	a5,a5,0x7
    80002414:	993e                	add	s2,s2,a5
    80002416:	0b392623          	sw	s3,172(s2)
}
    8000241a:	70a2                	ld	ra,40(sp)
    8000241c:	7402                	ld	s0,32(sp)
    8000241e:	64e2                	ld	s1,24(sp)
    80002420:	6942                	ld	s2,16(sp)
    80002422:	69a2                	ld	s3,8(sp)
    80002424:	6145                	addi	sp,sp,48
    80002426:	8082                	ret
    panic("sched p->lock");
    80002428:	00007517          	auipc	a0,0x7
    8000242c:	e1850513          	addi	a0,a0,-488 # 80009240 <digits+0x200>
    80002430:	ffffe097          	auipc	ra,0xffffe
    80002434:	110080e7          	jalr	272(ra) # 80000540 <panic>
    panic("sched locks");
    80002438:	00007517          	auipc	a0,0x7
    8000243c:	e1850513          	addi	a0,a0,-488 # 80009250 <digits+0x210>
    80002440:	ffffe097          	auipc	ra,0xffffe
    80002444:	100080e7          	jalr	256(ra) # 80000540 <panic>
    panic("sched running");
    80002448:	00007517          	auipc	a0,0x7
    8000244c:	e1850513          	addi	a0,a0,-488 # 80009260 <digits+0x220>
    80002450:	ffffe097          	auipc	ra,0xffffe
    80002454:	0f0080e7          	jalr	240(ra) # 80000540 <panic>
    panic("sched interruptible");
    80002458:	00007517          	auipc	a0,0x7
    8000245c:	e1850513          	addi	a0,a0,-488 # 80009270 <digits+0x230>
    80002460:	ffffe097          	auipc	ra,0xffffe
    80002464:	0e0080e7          	jalr	224(ra) # 80000540 <panic>

0000000080002468 <yield>:
{
    80002468:	1101                	addi	sp,sp,-32
    8000246a:	ec06                	sd	ra,24(sp)
    8000246c:	e822                	sd	s0,16(sp)
    8000246e:	e426                	sd	s1,8(sp)
    80002470:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002472:	fffff097          	auipc	ra,0xfffff
    80002476:	69e080e7          	jalr	1694(ra) # 80001b10 <myproc>
    8000247a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000247c:	fffff097          	auipc	ra,0xfffff
    80002480:	878080e7          	jalr	-1928(ra) # 80000cf4 <acquire>
  p->state = RUNNABLE;
    80002484:	478d                	li	a5,3
    80002486:	cc9c                	sw	a5,24(s1)
  sched();
    80002488:	00000097          	auipc	ra,0x0
    8000248c:	f0a080e7          	jalr	-246(ra) # 80002392 <sched>
  release(&p->lock);
    80002490:	8526                	mv	a0,s1
    80002492:	fffff097          	auipc	ra,0xfffff
    80002496:	916080e7          	jalr	-1770(ra) # 80000da8 <release>
}
    8000249a:	60e2                	ld	ra,24(sp)
    8000249c:	6442                	ld	s0,16(sp)
    8000249e:	64a2                	ld	s1,8(sp)
    800024a0:	6105                	addi	sp,sp,32
    800024a2:	8082                	ret

00000000800024a4 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800024a4:	7179                	addi	sp,sp,-48
    800024a6:	f406                	sd	ra,40(sp)
    800024a8:	f022                	sd	s0,32(sp)
    800024aa:	ec26                	sd	s1,24(sp)
    800024ac:	e84a                	sd	s2,16(sp)
    800024ae:	e44e                	sd	s3,8(sp)
    800024b0:	1800                	addi	s0,sp,48
    800024b2:	89aa                	mv	s3,a0
    800024b4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800024b6:	fffff097          	auipc	ra,0xfffff
    800024ba:	65a080e7          	jalr	1626(ra) # 80001b10 <myproc>
    800024be:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    800024c0:	fffff097          	auipc	ra,0xfffff
    800024c4:	834080e7          	jalr	-1996(ra) # 80000cf4 <acquire>
  release(lk);
    800024c8:	854a                	mv	a0,s2
    800024ca:	fffff097          	auipc	ra,0xfffff
    800024ce:	8de080e7          	jalr	-1826(ra) # 80000da8 <release>

  // Go to sleep.
  p->chan = chan;
    800024d2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800024d6:	4789                	li	a5,2
    800024d8:	cc9c                	sw	a5,24(s1)

  sched();
    800024da:	00000097          	auipc	ra,0x0
    800024de:	eb8080e7          	jalr	-328(ra) # 80002392 <sched>

  // Tidy up.
  p->chan = 0;
    800024e2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800024e6:	8526                	mv	a0,s1
    800024e8:	fffff097          	auipc	ra,0xfffff
    800024ec:	8c0080e7          	jalr	-1856(ra) # 80000da8 <release>
  acquire(lk);
    800024f0:	854a                	mv	a0,s2
    800024f2:	fffff097          	auipc	ra,0xfffff
    800024f6:	802080e7          	jalr	-2046(ra) # 80000cf4 <acquire>
}
    800024fa:	70a2                	ld	ra,40(sp)
    800024fc:	7402                	ld	s0,32(sp)
    800024fe:	64e2                	ld	s1,24(sp)
    80002500:	6942                	ld	s2,16(sp)
    80002502:	69a2                	ld	s3,8(sp)
    80002504:	6145                	addi	sp,sp,48
    80002506:	8082                	ret

0000000080002508 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80002508:	db010113          	addi	sp,sp,-592
    8000250c:	24113423          	sd	ra,584(sp)
    80002510:	24813023          	sd	s0,576(sp)
    80002514:	22913c23          	sd	s1,568(sp)
    80002518:	23213823          	sd	s2,560(sp)
    8000251c:	23313423          	sd	s3,552(sp)
    80002520:	23413023          	sd	s4,544(sp)
    80002524:	21513c23          	sd	s5,536(sp)
    80002528:	21613823          	sd	s6,528(sp)
    8000252c:	0c80                	addi	s0,sp,592
    8000252e:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80002530:	00230497          	auipc	s1,0x230
    80002534:	d6848493          	addi	s1,s1,-664 # 80232298 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    80002538:	4989                	li	s3,2
      {
#ifdef MLFQ
        if (!empty(queuetable[p->qlevel]))
    8000253a:	00237a97          	auipc	s5,0x237
    8000253e:	75ea8a93          	addi	s5,s5,1886 # 80239c98 <queuetable>
        {
          struct proc *pp = pop(&queuetable[p->qlevel]);
          push(&queuetable[p->qlevel], pp);
        }
#endif
        p->state = RUNNABLE;
    80002542:	4b0d                	li	s6,3
  for (p = proc; p < &proc[NPROC]; p++)
    80002544:	00237917          	auipc	s2,0x237
    80002548:	75490913          	addi	s2,s2,1876 # 80239c98 <queuetable>
    8000254c:	a821                	j	80002564 <wakeup+0x5c>
        p->state = RUNNABLE;
    8000254e:	0164ac23          	sw	s6,24(s1)
      }
      release(&p->lock);
    80002552:	8526                	mv	a0,s1
    80002554:	fffff097          	auipc	ra,0xfffff
    80002558:	854080e7          	jalr	-1964(ra) # 80000da8 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    8000255c:	1e848493          	addi	s1,s1,488
    80002560:	0b248463          	beq	s1,s2,80002608 <wakeup+0x100>
    if (p != myproc())
    80002564:	fffff097          	auipc	ra,0xfffff
    80002568:	5ac080e7          	jalr	1452(ra) # 80001b10 <myproc>
    8000256c:	fea488e3          	beq	s1,a0,8000255c <wakeup+0x54>
      acquire(&p->lock);
    80002570:	8526                	mv	a0,s1
    80002572:	ffffe097          	auipc	ra,0xffffe
    80002576:	782080e7          	jalr	1922(ra) # 80000cf4 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    8000257a:	4c9c                	lw	a5,24(s1)
    8000257c:	fd379be3          	bne	a5,s3,80002552 <wakeup+0x4a>
    80002580:	709c                	ld	a5,32(s1)
    80002582:	fd4798e3          	bne	a5,s4,80002552 <wakeup+0x4a>
        if (!empty(queuetable[p->qlevel]))
    80002586:	1c84a703          	lw	a4,456(s1)
    8000258a:	00571793          	slli	a5,a4,0x5
    8000258e:	97ba                	add	a5,a5,a4
    80002590:	0792                	slli	a5,a5,0x4
    80002592:	97d6                	add	a5,a5,s5
    80002594:	db040713          	addi	a4,s0,-592
    80002598:	21078313          	addi	t1,a5,528
    8000259c:	0007b883          	ld	a7,0(a5)
    800025a0:	0087b803          	ld	a6,8(a5)
    800025a4:	6b88                	ld	a0,16(a5)
    800025a6:	6f8c                	ld	a1,24(a5)
    800025a8:	7390                	ld	a2,32(a5)
    800025aa:	7794                	ld	a3,40(a5)
    800025ac:	01173023          	sd	a7,0(a4)
    800025b0:	01073423          	sd	a6,8(a4)
    800025b4:	eb08                	sd	a0,16(a4)
    800025b6:	ef0c                	sd	a1,24(a4)
    800025b8:	f310                	sd	a2,32(a4)
    800025ba:	f714                	sd	a3,40(a4)
    800025bc:	03078793          	addi	a5,a5,48
    800025c0:	03070713          	addi	a4,a4,48
    800025c4:	fc679ce3          	bne	a5,t1,8000259c <wakeup+0x94>
    800025c8:	db040513          	addi	a0,s0,-592
    800025cc:	00004097          	auipc	ra,0x4
    800025d0:	64c080e7          	jalr	1612(ra) # 80006c18 <empty>
    800025d4:	fd2d                	bnez	a0,8000254e <wakeup+0x46>
          struct proc *pp = pop(&queuetable[p->qlevel]);
    800025d6:	1c84a783          	lw	a5,456(s1)
    800025da:	00579513          	slli	a0,a5,0x5
    800025de:	953e                	add	a0,a0,a5
    800025e0:	0512                	slli	a0,a0,0x4
    800025e2:	9556                	add	a0,a0,s5
    800025e4:	00004097          	auipc	ra,0x4
    800025e8:	57c080e7          	jalr	1404(ra) # 80006b60 <pop>
    800025ec:	85aa                	mv	a1,a0
          push(&queuetable[p->qlevel], pp);
    800025ee:	1c84a703          	lw	a4,456(s1)
    800025f2:	00571793          	slli	a5,a4,0x5
    800025f6:	97ba                	add	a5,a5,a4
    800025f8:	0792                	slli	a5,a5,0x4
    800025fa:	00fa8533          	add	a0,s5,a5
    800025fe:	00004097          	auipc	ra,0x4
    80002602:	524080e7          	jalr	1316(ra) # 80006b22 <push>
    80002606:	b7a1                	j	8000254e <wakeup+0x46>
    }
  }
}
    80002608:	24813083          	ld	ra,584(sp)
    8000260c:	24013403          	ld	s0,576(sp)
    80002610:	23813483          	ld	s1,568(sp)
    80002614:	23013903          	ld	s2,560(sp)
    80002618:	22813983          	ld	s3,552(sp)
    8000261c:	22013a03          	ld	s4,544(sp)
    80002620:	21813a83          	ld	s5,536(sp)
    80002624:	21013b03          	ld	s6,528(sp)
    80002628:	25010113          	addi	sp,sp,592
    8000262c:	8082                	ret

000000008000262e <reparent>:
{
    8000262e:	7179                	addi	sp,sp,-48
    80002630:	f406                	sd	ra,40(sp)
    80002632:	f022                	sd	s0,32(sp)
    80002634:	ec26                	sd	s1,24(sp)
    80002636:	e84a                	sd	s2,16(sp)
    80002638:	e44e                	sd	s3,8(sp)
    8000263a:	e052                	sd	s4,0(sp)
    8000263c:	1800                	addi	s0,sp,48
    8000263e:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    80002640:	00230497          	auipc	s1,0x230
    80002644:	c5848493          	addi	s1,s1,-936 # 80232298 <proc>
      pp->parent = initproc;
    80002648:	00007a17          	auipc	s4,0x7
    8000264c:	590a0a13          	addi	s4,s4,1424 # 80009bd8 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    80002650:	00237997          	auipc	s3,0x237
    80002654:	64898993          	addi	s3,s3,1608 # 80239c98 <queuetable>
    80002658:	a029                	j	80002662 <reparent+0x34>
    8000265a:	1e848493          	addi	s1,s1,488
    8000265e:	01348d63          	beq	s1,s3,80002678 <reparent+0x4a>
    if (pp->parent == p)
    80002662:	7c9c                	ld	a5,56(s1)
    80002664:	ff279be3          	bne	a5,s2,8000265a <reparent+0x2c>
      pp->parent = initproc;
    80002668:	000a3503          	ld	a0,0(s4)
    8000266c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000266e:	00000097          	auipc	ra,0x0
    80002672:	e9a080e7          	jalr	-358(ra) # 80002508 <wakeup>
    80002676:	b7d5                	j	8000265a <reparent+0x2c>
}
    80002678:	70a2                	ld	ra,40(sp)
    8000267a:	7402                	ld	s0,32(sp)
    8000267c:	64e2                	ld	s1,24(sp)
    8000267e:	6942                	ld	s2,16(sp)
    80002680:	69a2                	ld	s3,8(sp)
    80002682:	6a02                	ld	s4,0(sp)
    80002684:	6145                	addi	sp,sp,48
    80002686:	8082                	ret

0000000080002688 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80002688:	7179                	addi	sp,sp,-48
    8000268a:	f406                	sd	ra,40(sp)
    8000268c:	f022                	sd	s0,32(sp)
    8000268e:	ec26                	sd	s1,24(sp)
    80002690:	e84a                	sd	s2,16(sp)
    80002692:	e44e                	sd	s3,8(sp)
    80002694:	1800                	addi	s0,sp,48
    80002696:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80002698:	00230497          	auipc	s1,0x230
    8000269c:	c0048493          	addi	s1,s1,-1024 # 80232298 <proc>
    800026a0:	00237997          	auipc	s3,0x237
    800026a4:	5f898993          	addi	s3,s3,1528 # 80239c98 <queuetable>
  {
    acquire(&p->lock);
    800026a8:	8526                	mv	a0,s1
    800026aa:	ffffe097          	auipc	ra,0xffffe
    800026ae:	64a080e7          	jalr	1610(ra) # 80000cf4 <acquire>
    if (p->pid == pid)
    800026b2:	589c                	lw	a5,48(s1)
    800026b4:	01278d63          	beq	a5,s2,800026ce <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800026b8:	8526                	mv	a0,s1
    800026ba:	ffffe097          	auipc	ra,0xffffe
    800026be:	6ee080e7          	jalr	1774(ra) # 80000da8 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800026c2:	1e848493          	addi	s1,s1,488
    800026c6:	ff3491e3          	bne	s1,s3,800026a8 <kill+0x20>
  }
  return -1;
    800026ca:	557d                	li	a0,-1
    800026cc:	a829                	j	800026e6 <kill+0x5e>
      p->killed = 1;
    800026ce:	4785                	li	a5,1
    800026d0:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    800026d2:	4c98                	lw	a4,24(s1)
    800026d4:	4789                	li	a5,2
    800026d6:	00f70f63          	beq	a4,a5,800026f4 <kill+0x6c>
      release(&p->lock);
    800026da:	8526                	mv	a0,s1
    800026dc:	ffffe097          	auipc	ra,0xffffe
    800026e0:	6cc080e7          	jalr	1740(ra) # 80000da8 <release>
      return 0;
    800026e4:	4501                	li	a0,0
}
    800026e6:	70a2                	ld	ra,40(sp)
    800026e8:	7402                	ld	s0,32(sp)
    800026ea:	64e2                	ld	s1,24(sp)
    800026ec:	6942                	ld	s2,16(sp)
    800026ee:	69a2                	ld	s3,8(sp)
    800026f0:	6145                	addi	sp,sp,48
    800026f2:	8082                	ret
        p->state = RUNNABLE;
    800026f4:	478d                	li	a5,3
    800026f6:	cc9c                	sw	a5,24(s1)
    800026f8:	b7cd                	j	800026da <kill+0x52>

00000000800026fa <setkilled>:

void setkilled(struct proc *p)
{
    800026fa:	1101                	addi	sp,sp,-32
    800026fc:	ec06                	sd	ra,24(sp)
    800026fe:	e822                	sd	s0,16(sp)
    80002700:	e426                	sd	s1,8(sp)
    80002702:	1000                	addi	s0,sp,32
    80002704:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002706:	ffffe097          	auipc	ra,0xffffe
    8000270a:	5ee080e7          	jalr	1518(ra) # 80000cf4 <acquire>
  p->killed = 1;
    8000270e:	4785                	li	a5,1
    80002710:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002712:	8526                	mv	a0,s1
    80002714:	ffffe097          	auipc	ra,0xffffe
    80002718:	694080e7          	jalr	1684(ra) # 80000da8 <release>
}
    8000271c:	60e2                	ld	ra,24(sp)
    8000271e:	6442                	ld	s0,16(sp)
    80002720:	64a2                	ld	s1,8(sp)
    80002722:	6105                	addi	sp,sp,32
    80002724:	8082                	ret

0000000080002726 <killed>:

int killed(struct proc *p)
{
    80002726:	1101                	addi	sp,sp,-32
    80002728:	ec06                	sd	ra,24(sp)
    8000272a:	e822                	sd	s0,16(sp)
    8000272c:	e426                	sd	s1,8(sp)
    8000272e:	e04a                	sd	s2,0(sp)
    80002730:	1000                	addi	s0,sp,32
    80002732:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80002734:	ffffe097          	auipc	ra,0xffffe
    80002738:	5c0080e7          	jalr	1472(ra) # 80000cf4 <acquire>
  k = p->killed;
    8000273c:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002740:	8526                	mv	a0,s1
    80002742:	ffffe097          	auipc	ra,0xffffe
    80002746:	666080e7          	jalr	1638(ra) # 80000da8 <release>
  return k;
}
    8000274a:	854a                	mv	a0,s2
    8000274c:	60e2                	ld	ra,24(sp)
    8000274e:	6442                	ld	s0,16(sp)
    80002750:	64a2                	ld	s1,8(sp)
    80002752:	6902                	ld	s2,0(sp)
    80002754:	6105                	addi	sp,sp,32
    80002756:	8082                	ret

0000000080002758 <wait>:
{
    80002758:	715d                	addi	sp,sp,-80
    8000275a:	e486                	sd	ra,72(sp)
    8000275c:	e0a2                	sd	s0,64(sp)
    8000275e:	fc26                	sd	s1,56(sp)
    80002760:	f84a                	sd	s2,48(sp)
    80002762:	f44e                	sd	s3,40(sp)
    80002764:	f052                	sd	s4,32(sp)
    80002766:	ec56                	sd	s5,24(sp)
    80002768:	e85a                	sd	s6,16(sp)
    8000276a:	e45e                	sd	s7,8(sp)
    8000276c:	e062                	sd	s8,0(sp)
    8000276e:	0880                	addi	s0,sp,80
    80002770:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002772:	fffff097          	auipc	ra,0xfffff
    80002776:	39e080e7          	jalr	926(ra) # 80001b10 <myproc>
    8000277a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000277c:	0022f517          	auipc	a0,0x22f
    80002780:	70450513          	addi	a0,a0,1796 # 80231e80 <wait_lock>
    80002784:	ffffe097          	auipc	ra,0xffffe
    80002788:	570080e7          	jalr	1392(ra) # 80000cf4 <acquire>
    havekids = 0;
    8000278c:	4b81                	li	s7,0
        if (pp->state == ZOMBIE)
    8000278e:	4a15                	li	s4,5
        havekids = 1;
    80002790:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002792:	00237997          	auipc	s3,0x237
    80002796:	50698993          	addi	s3,s3,1286 # 80239c98 <queuetable>
    sleep(p, &wait_lock); // DOC: wait-sleep
    8000279a:	0022fc17          	auipc	s8,0x22f
    8000279e:	6e6c0c13          	addi	s8,s8,1766 # 80231e80 <wait_lock>
    havekids = 0;
    800027a2:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800027a4:	00230497          	auipc	s1,0x230
    800027a8:	af448493          	addi	s1,s1,-1292 # 80232298 <proc>
    800027ac:	a0bd                	j	8000281a <wait+0xc2>
          pid = pp->pid;
    800027ae:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800027b2:	000b0e63          	beqz	s6,800027ce <wait+0x76>
    800027b6:	4691                	li	a3,4
    800027b8:	02c48613          	addi	a2,s1,44
    800027bc:	85da                	mv	a1,s6
    800027be:	09893503          	ld	a0,152(s2)
    800027c2:	fffff097          	auipc	ra,0xfffff
    800027c6:	fd6080e7          	jalr	-42(ra) # 80001798 <copyout>
    800027ca:	02054563          	bltz	a0,800027f4 <wait+0x9c>
          freeproc(pp);
    800027ce:	8526                	mv	a0,s1
    800027d0:	fffff097          	auipc	ra,0xfffff
    800027d4:	4f2080e7          	jalr	1266(ra) # 80001cc2 <freeproc>
          release(&pp->lock);
    800027d8:	8526                	mv	a0,s1
    800027da:	ffffe097          	auipc	ra,0xffffe
    800027de:	5ce080e7          	jalr	1486(ra) # 80000da8 <release>
          release(&wait_lock);
    800027e2:	0022f517          	auipc	a0,0x22f
    800027e6:	69e50513          	addi	a0,a0,1694 # 80231e80 <wait_lock>
    800027ea:	ffffe097          	auipc	ra,0xffffe
    800027ee:	5be080e7          	jalr	1470(ra) # 80000da8 <release>
          return pid;
    800027f2:	a0b5                	j	8000285e <wait+0x106>
            release(&pp->lock);
    800027f4:	8526                	mv	a0,s1
    800027f6:	ffffe097          	auipc	ra,0xffffe
    800027fa:	5b2080e7          	jalr	1458(ra) # 80000da8 <release>
            release(&wait_lock);
    800027fe:	0022f517          	auipc	a0,0x22f
    80002802:	68250513          	addi	a0,a0,1666 # 80231e80 <wait_lock>
    80002806:	ffffe097          	auipc	ra,0xffffe
    8000280a:	5a2080e7          	jalr	1442(ra) # 80000da8 <release>
            return -1;
    8000280e:	59fd                	li	s3,-1
    80002810:	a0b9                	j	8000285e <wait+0x106>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002812:	1e848493          	addi	s1,s1,488
    80002816:	03348463          	beq	s1,s3,8000283e <wait+0xe6>
      if (pp->parent == p)
    8000281a:	7c9c                	ld	a5,56(s1)
    8000281c:	ff279be3          	bne	a5,s2,80002812 <wait+0xba>
        acquire(&pp->lock);
    80002820:	8526                	mv	a0,s1
    80002822:	ffffe097          	auipc	ra,0xffffe
    80002826:	4d2080e7          	jalr	1234(ra) # 80000cf4 <acquire>
        if (pp->state == ZOMBIE)
    8000282a:	4c9c                	lw	a5,24(s1)
    8000282c:	f94781e3          	beq	a5,s4,800027ae <wait+0x56>
        release(&pp->lock);
    80002830:	8526                	mv	a0,s1
    80002832:	ffffe097          	auipc	ra,0xffffe
    80002836:	576080e7          	jalr	1398(ra) # 80000da8 <release>
        havekids = 1;
    8000283a:	8756                	mv	a4,s5
    8000283c:	bfd9                	j	80002812 <wait+0xba>
    if (!havekids || killed(p))
    8000283e:	c719                	beqz	a4,8000284c <wait+0xf4>
    80002840:	854a                	mv	a0,s2
    80002842:	00000097          	auipc	ra,0x0
    80002846:	ee4080e7          	jalr	-284(ra) # 80002726 <killed>
    8000284a:	c51d                	beqz	a0,80002878 <wait+0x120>
      release(&wait_lock);
    8000284c:	0022f517          	auipc	a0,0x22f
    80002850:	63450513          	addi	a0,a0,1588 # 80231e80 <wait_lock>
    80002854:	ffffe097          	auipc	ra,0xffffe
    80002858:	554080e7          	jalr	1364(ra) # 80000da8 <release>
      return -1;
    8000285c:	59fd                	li	s3,-1
}
    8000285e:	854e                	mv	a0,s3
    80002860:	60a6                	ld	ra,72(sp)
    80002862:	6406                	ld	s0,64(sp)
    80002864:	74e2                	ld	s1,56(sp)
    80002866:	7942                	ld	s2,48(sp)
    80002868:	79a2                	ld	s3,40(sp)
    8000286a:	7a02                	ld	s4,32(sp)
    8000286c:	6ae2                	ld	s5,24(sp)
    8000286e:	6b42                	ld	s6,16(sp)
    80002870:	6ba2                	ld	s7,8(sp)
    80002872:	6c02                	ld	s8,0(sp)
    80002874:	6161                	addi	sp,sp,80
    80002876:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002878:	85e2                	mv	a1,s8
    8000287a:	854a                	mv	a0,s2
    8000287c:	00000097          	auipc	ra,0x0
    80002880:	c28080e7          	jalr	-984(ra) # 800024a4 <sleep>
    havekids = 0;
    80002884:	bf39                	j	800027a2 <wait+0x4a>

0000000080002886 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002886:	7179                	addi	sp,sp,-48
    80002888:	f406                	sd	ra,40(sp)
    8000288a:	f022                	sd	s0,32(sp)
    8000288c:	ec26                	sd	s1,24(sp)
    8000288e:	e84a                	sd	s2,16(sp)
    80002890:	e44e                	sd	s3,8(sp)
    80002892:	e052                	sd	s4,0(sp)
    80002894:	1800                	addi	s0,sp,48
    80002896:	84aa                	mv	s1,a0
    80002898:	892e                	mv	s2,a1
    8000289a:	89b2                	mv	s3,a2
    8000289c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000289e:	fffff097          	auipc	ra,0xfffff
    800028a2:	272080e7          	jalr	626(ra) # 80001b10 <myproc>
  if (user_dst)
    800028a6:	c08d                	beqz	s1,800028c8 <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    800028a8:	86d2                	mv	a3,s4
    800028aa:	864e                	mv	a2,s3
    800028ac:	85ca                	mv	a1,s2
    800028ae:	6d48                	ld	a0,152(a0)
    800028b0:	fffff097          	auipc	ra,0xfffff
    800028b4:	ee8080e7          	jalr	-280(ra) # 80001798 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800028b8:	70a2                	ld	ra,40(sp)
    800028ba:	7402                	ld	s0,32(sp)
    800028bc:	64e2                	ld	s1,24(sp)
    800028be:	6942                	ld	s2,16(sp)
    800028c0:	69a2                	ld	s3,8(sp)
    800028c2:	6a02                	ld	s4,0(sp)
    800028c4:	6145                	addi	sp,sp,48
    800028c6:	8082                	ret
    memmove((char *)dst, src, len);
    800028c8:	000a061b          	sext.w	a2,s4
    800028cc:	85ce                	mv	a1,s3
    800028ce:	854a                	mv	a0,s2
    800028d0:	ffffe097          	auipc	ra,0xffffe
    800028d4:	57c080e7          	jalr	1404(ra) # 80000e4c <memmove>
    return 0;
    800028d8:	8526                	mv	a0,s1
    800028da:	bff9                	j	800028b8 <either_copyout+0x32>

00000000800028dc <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800028dc:	7179                	addi	sp,sp,-48
    800028de:	f406                	sd	ra,40(sp)
    800028e0:	f022                	sd	s0,32(sp)
    800028e2:	ec26                	sd	s1,24(sp)
    800028e4:	e84a                	sd	s2,16(sp)
    800028e6:	e44e                	sd	s3,8(sp)
    800028e8:	e052                	sd	s4,0(sp)
    800028ea:	1800                	addi	s0,sp,48
    800028ec:	892a                	mv	s2,a0
    800028ee:	84ae                	mv	s1,a1
    800028f0:	89b2                	mv	s3,a2
    800028f2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800028f4:	fffff097          	auipc	ra,0xfffff
    800028f8:	21c080e7          	jalr	540(ra) # 80001b10 <myproc>
  if (user_src)
    800028fc:	c08d                	beqz	s1,8000291e <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    800028fe:	86d2                	mv	a3,s4
    80002900:	864e                	mv	a2,s3
    80002902:	85ca                	mv	a1,s2
    80002904:	6d48                	ld	a0,152(a0)
    80002906:	fffff097          	auipc	ra,0xfffff
    8000290a:	f56080e7          	jalr	-170(ra) # 8000185c <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    8000290e:	70a2                	ld	ra,40(sp)
    80002910:	7402                	ld	s0,32(sp)
    80002912:	64e2                	ld	s1,24(sp)
    80002914:	6942                	ld	s2,16(sp)
    80002916:	69a2                	ld	s3,8(sp)
    80002918:	6a02                	ld	s4,0(sp)
    8000291a:	6145                	addi	sp,sp,48
    8000291c:	8082                	ret
    memmove(dst, (char *)src, len);
    8000291e:	000a061b          	sext.w	a2,s4
    80002922:	85ce                	mv	a1,s3
    80002924:	854a                	mv	a0,s2
    80002926:	ffffe097          	auipc	ra,0xffffe
    8000292a:	526080e7          	jalr	1318(ra) # 80000e4c <memmove>
    return 0;
    8000292e:	8526                	mv	a0,s1
    80002930:	bff9                	j	8000290e <either_copyin+0x32>

0000000080002932 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002932:	715d                	addi	sp,sp,-80
    80002934:	e486                	sd	ra,72(sp)
    80002936:	e0a2                	sd	s0,64(sp)
    80002938:	fc26                	sd	s1,56(sp)
    8000293a:	f84a                	sd	s2,48(sp)
    8000293c:	f44e                	sd	s3,40(sp)
    8000293e:	f052                	sd	s4,32(sp)
    80002940:	ec56                	sd	s5,24(sp)
    80002942:	e85a                	sd	s6,16(sp)
    80002944:	e45e                	sd	s7,8(sp)
    80002946:	0880                	addi	s0,sp,80
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;
  printf("\n");
    80002948:	00006517          	auipc	a0,0x6
    8000294c:	7a050513          	addi	a0,a0,1952 # 800090e8 <digits+0xa8>
    80002950:	ffffe097          	auipc	ra,0xffffe
    80002954:	c3a080e7          	jalr	-966(ra) # 8000058a <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80002958:	00230497          	auipc	s1,0x230
    8000295c:	94048493          	addi	s1,s1,-1728 # 80232298 <proc>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002960:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002962:	00007997          	auipc	s3,0x7
    80002966:	92698993          	addi	s3,s3,-1754 # 80009288 <digits+0x248>
#ifdef PBS
    int wtime = ticks - p->createtime - p->totalRunTime;
    printf("%d\t%d\t%s\t%d\t%d\t%d\n", p->pid, p->priority, state, p->totalRunTime, wtime, p->num_runs);
#endif
#if defined MLFQ
    int wtime = ticks - p->createtime - p->totalrtime;
    8000296a:	00007a97          	auipc	s5,0x7
    8000296e:	276a8a93          	addi	s5,s5,630 # 80009be0 <ticks>
    printf("%d\t%s\t%d\t%d\t%d\n", p->pid, state, p->totalrtime, wtime, p->num_runs);
    80002972:	00007a17          	auipc	s4,0x7
    80002976:	91ea0a13          	addi	s4,s4,-1762 # 80009290 <digits+0x250>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000297a:	00007b97          	auipc	s7,0x7
    8000297e:	976b8b93          	addi	s7,s7,-1674 # 800092f0 <states.0>
  for (p = proc; p < &proc[NPROC]; p++)
    80002982:	00237917          	auipc	s2,0x237
    80002986:	31690913          	addi	s2,s2,790 # 80239c98 <queuetable>
    8000298a:	a02d                	j	800029b4 <procdump+0x82>
    int wtime = ticks - p->createtime - p->totalrtime;
    8000298c:	1bc4a683          	lw	a3,444(s1)
    80002990:	50f8                	lw	a4,100(s1)
    80002992:	9f35                	addw	a4,a4,a3
    80002994:	000aa583          	lw	a1,0(s5)
    printf("%d\t%s\t%d\t%d\t%d\n", p->pid, state, p->totalrtime, wtime, p->num_runs);
    80002998:	0804a783          	lw	a5,128(s1)
    8000299c:	40e5873b          	subw	a4,a1,a4
    800029a0:	588c                	lw	a1,48(s1)
    800029a2:	8552                	mv	a0,s4
    800029a4:	ffffe097          	auipc	ra,0xffffe
    800029a8:	be6080e7          	jalr	-1050(ra) # 8000058a <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    800029ac:	1e848493          	addi	s1,s1,488
    800029b0:	03248063          	beq	s1,s2,800029d0 <procdump+0x9e>
    if (p->state == UNUSED)
    800029b4:	4c9c                	lw	a5,24(s1)
    800029b6:	dbfd                	beqz	a5,800029ac <procdump+0x7a>
      state = "???";
    800029b8:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029ba:	fcfb69e3          	bltu	s6,a5,8000298c <procdump+0x5a>
    800029be:	02079713          	slli	a4,a5,0x20
    800029c2:	01d75793          	srli	a5,a4,0x1d
    800029c6:	97de                	add	a5,a5,s7
    800029c8:	6390                	ld	a2,0(a5)
    800029ca:	f269                	bnez	a2,8000298c <procdump+0x5a>
      state = "???";
    800029cc:	864e                	mv	a2,s3
    800029ce:	bf7d                	j	8000298c <procdump+0x5a>
#endif
  }
}
    800029d0:	60a6                	ld	ra,72(sp)
    800029d2:	6406                	ld	s0,64(sp)
    800029d4:	74e2                	ld	s1,56(sp)
    800029d6:	7942                	ld	s2,48(sp)
    800029d8:	79a2                	ld	s3,40(sp)
    800029da:	7a02                	ld	s4,32(sp)
    800029dc:	6ae2                	ld	s5,24(sp)
    800029de:	6b42                	ld	s6,16(sp)
    800029e0:	6ba2                	ld	s7,8(sp)
    800029e2:	6161                	addi	sp,sp,80
    800029e4:	8082                	ret

00000000800029e6 <queuetableinit>:
void queuetableinit(void)
{
    800029e6:	1141                	addi	sp,sp,-16
    800029e8:	e422                	sd	s0,8(sp)
    800029ea:	0800                	addi	s0,sp,16
  for (int i = 0; i < 5; i++)
  {
    queuetable[i].front = 0;
    800029ec:	00237797          	auipc	a5,0x237
    800029f0:	2ac78793          	addi	a5,a5,684 # 80239c98 <queuetable>
    800029f4:	0007a023          	sw	zero,0(a5)
    queuetable[i].back = 0;
    800029f8:	0007a223          	sw	zero,4(a5)
    queuetable[i].front = 0;
    800029fc:	2007a823          	sw	zero,528(a5)
    queuetable[i].back = 0;
    80002a00:	2007aa23          	sw	zero,532(a5)
    queuetable[i].front = 0;
    80002a04:	4207a023          	sw	zero,1056(a5)
    queuetable[i].back = 0;
    80002a08:	4207a223          	sw	zero,1060(a5)
    queuetable[i].front = 0;
    80002a0c:	6207a823          	sw	zero,1584(a5)
    queuetable[i].back = 0;
    80002a10:	6207aa23          	sw	zero,1588(a5)
    queuetable[i].front = 0;
    80002a14:	00238797          	auipc	a5,0x238
    80002a18:	28478793          	addi	a5,a5,644 # 8023ac98 <bcache+0x598>
    80002a1c:	8407a023          	sw	zero,-1984(a5)
    queuetable[i].back = 0;
    80002a20:	8407a223          	sw	zero,-1980(a5)
  }
}
    80002a24:	6422                	ld	s0,8(sp)
    80002a26:	0141                	addi	sp,sp,16
    80002a28:	8082                	ret

0000000080002a2a <waitx>:
int waitx(uint64 addr, uint *runTime, uint *wtime)
{
    80002a2a:	711d                	addi	sp,sp,-96
    80002a2c:	ec86                	sd	ra,88(sp)
    80002a2e:	e8a2                	sd	s0,80(sp)
    80002a30:	e4a6                	sd	s1,72(sp)
    80002a32:	e0ca                	sd	s2,64(sp)
    80002a34:	fc4e                	sd	s3,56(sp)
    80002a36:	f852                	sd	s4,48(sp)
    80002a38:	f456                	sd	s5,40(sp)
    80002a3a:	f05a                	sd	s6,32(sp)
    80002a3c:	ec5e                	sd	s7,24(sp)
    80002a3e:	e862                	sd	s8,16(sp)
    80002a40:	e466                	sd	s9,8(sp)
    80002a42:	e06a                	sd	s10,0(sp)
    80002a44:	1080                	addi	s0,sp,96
    80002a46:	8b2a                	mv	s6,a0
    80002a48:	8c2e                	mv	s8,a1
    80002a4a:	8bb2                	mv	s7,a2
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
    80002a4c:	fffff097          	auipc	ra,0xfffff
    80002a50:	0c4080e7          	jalr	196(ra) # 80001b10 <myproc>
    80002a54:	892a                	mv	s2,a0

  acquire(&wait_lock);
    80002a56:	0022f517          	auipc	a0,0x22f
    80002a5a:	42a50513          	addi	a0,a0,1066 # 80231e80 <wait_lock>
    80002a5e:	ffffe097          	auipc	ra,0xffffe
    80002a62:	296080e7          	jalr	662(ra) # 80000cf4 <acquire>

  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    80002a66:	4c81                	li	s9,0
      {
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if (np->state == ZOMBIE)
    80002a68:	4a15                	li	s4,5
        havekids = 1;
    80002a6a:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++)
    80002a6c:	00237997          	auipc	s3,0x237
    80002a70:	22c98993          	addi	s3,s3,556 # 80239c98 <queuetable>
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002a74:	0022fd17          	auipc	s10,0x22f
    80002a78:	40cd0d13          	addi	s10,s10,1036 # 80231e80 <wait_lock>
    havekids = 0;
    80002a7c:	8766                	mv	a4,s9
    for (np = proc; np < &proc[NPROC]; np++)
    80002a7e:	00230497          	auipc	s1,0x230
    80002a82:	81a48493          	addi	s1,s1,-2022 # 80232298 <proc>
    80002a86:	a041                	j	80002b06 <waitx+0xdc>
          pid = np->pid;
    80002a88:	0304a983          	lw	s3,48(s1)
          *runTime = np->totalRunTime;
    80002a8c:	5cfc                	lw	a5,124(s1)
    80002a8e:	00fc2023          	sw	a5,0(s8)
          *wtime = np->exitTime - np->createtime - np->totalRunTime;
    80002a92:	50f8                	lw	a4,100(s1)
    80002a94:	9f3d                	addw	a4,a4,a5
    80002a96:	54fc                	lw	a5,108(s1)
    80002a98:	9f99                	subw	a5,a5,a4
    80002a9a:	00fba023          	sw	a5,0(s7)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002a9e:	000b0e63          	beqz	s6,80002aba <waitx+0x90>
    80002aa2:	4691                	li	a3,4
    80002aa4:	02c48613          	addi	a2,s1,44
    80002aa8:	85da                	mv	a1,s6
    80002aaa:	09893503          	ld	a0,152(s2)
    80002aae:	fffff097          	auipc	ra,0xfffff
    80002ab2:	cea080e7          	jalr	-790(ra) # 80001798 <copyout>
    80002ab6:	02054563          	bltz	a0,80002ae0 <waitx+0xb6>
          freeproc(np);
    80002aba:	8526                	mv	a0,s1
    80002abc:	fffff097          	auipc	ra,0xfffff
    80002ac0:	206080e7          	jalr	518(ra) # 80001cc2 <freeproc>
          release(&np->lock);
    80002ac4:	8526                	mv	a0,s1
    80002ac6:	ffffe097          	auipc	ra,0xffffe
    80002aca:	2e2080e7          	jalr	738(ra) # 80000da8 <release>
          release(&wait_lock);
    80002ace:	0022f517          	auipc	a0,0x22f
    80002ad2:	3b250513          	addi	a0,a0,946 # 80231e80 <wait_lock>
    80002ad6:	ffffe097          	auipc	ra,0xffffe
    80002ada:	2d2080e7          	jalr	722(ra) # 80000da8 <release>
          return pid;
    80002ade:	a09d                	j	80002b44 <waitx+0x11a>
            release(&np->lock);
    80002ae0:	8526                	mv	a0,s1
    80002ae2:	ffffe097          	auipc	ra,0xffffe
    80002ae6:	2c6080e7          	jalr	710(ra) # 80000da8 <release>
            release(&wait_lock);
    80002aea:	0022f517          	auipc	a0,0x22f
    80002aee:	39650513          	addi	a0,a0,918 # 80231e80 <wait_lock>
    80002af2:	ffffe097          	auipc	ra,0xffffe
    80002af6:	2b6080e7          	jalr	694(ra) # 80000da8 <release>
            return -1;
    80002afa:	59fd                	li	s3,-1
    80002afc:	a0a1                	j	80002b44 <waitx+0x11a>
    for (np = proc; np < &proc[NPROC]; np++)
    80002afe:	1e848493          	addi	s1,s1,488
    80002b02:	03348463          	beq	s1,s3,80002b2a <waitx+0x100>
      if (np->parent == p)
    80002b06:	7c9c                	ld	a5,56(s1)
    80002b08:	ff279be3          	bne	a5,s2,80002afe <waitx+0xd4>
        acquire(&np->lock);
    80002b0c:	8526                	mv	a0,s1
    80002b0e:	ffffe097          	auipc	ra,0xffffe
    80002b12:	1e6080e7          	jalr	486(ra) # 80000cf4 <acquire>
        if (np->state == ZOMBIE)
    80002b16:	4c9c                	lw	a5,24(s1)
    80002b18:	f74788e3          	beq	a5,s4,80002a88 <waitx+0x5e>
        release(&np->lock);
    80002b1c:	8526                	mv	a0,s1
    80002b1e:	ffffe097          	auipc	ra,0xffffe
    80002b22:	28a080e7          	jalr	650(ra) # 80000da8 <release>
        havekids = 1;
    80002b26:	8756                	mv	a4,s5
    80002b28:	bfd9                	j	80002afe <waitx+0xd4>
    if (!havekids || p->killed)
    80002b2a:	c701                	beqz	a4,80002b32 <waitx+0x108>
    80002b2c:	02892783          	lw	a5,40(s2)
    80002b30:	cb8d                	beqz	a5,80002b62 <waitx+0x138>
      release(&wait_lock);
    80002b32:	0022f517          	auipc	a0,0x22f
    80002b36:	34e50513          	addi	a0,a0,846 # 80231e80 <wait_lock>
    80002b3a:	ffffe097          	auipc	ra,0xffffe
    80002b3e:	26e080e7          	jalr	622(ra) # 80000da8 <release>
      return -1;
    80002b42:	59fd                	li	s3,-1
  }
}
    80002b44:	854e                	mv	a0,s3
    80002b46:	60e6                	ld	ra,88(sp)
    80002b48:	6446                	ld	s0,80(sp)
    80002b4a:	64a6                	ld	s1,72(sp)
    80002b4c:	6906                	ld	s2,64(sp)
    80002b4e:	79e2                	ld	s3,56(sp)
    80002b50:	7a42                	ld	s4,48(sp)
    80002b52:	7aa2                	ld	s5,40(sp)
    80002b54:	7b02                	ld	s6,32(sp)
    80002b56:	6be2                	ld	s7,24(sp)
    80002b58:	6c42                	ld	s8,16(sp)
    80002b5a:	6ca2                	ld	s9,8(sp)
    80002b5c:	6d02                	ld	s10,0(sp)
    80002b5e:	6125                	addi	sp,sp,96
    80002b60:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002b62:	85ea                	mv	a1,s10
    80002b64:	854a                	mv	a0,s2
    80002b66:	00000097          	auipc	ra,0x0
    80002b6a:	93e080e7          	jalr	-1730(ra) # 800024a4 <sleep>
    havekids = 0;
    80002b6e:	b739                	j	80002a7c <waitx+0x52>

0000000080002b70 <update_time>:

void update_time()
{
    80002b70:	7179                	addi	sp,sp,-48
    80002b72:	f406                	sd	ra,40(sp)
    80002b74:	f022                	sd	s0,32(sp)
    80002b76:	ec26                	sd	s1,24(sp)
    80002b78:	e84a                	sd	s2,16(sp)
    80002b7a:	e44e                	sd	s3,8(sp)
    80002b7c:	e052                	sd	s4,0(sp)
    80002b7e:	1800                	addi	s0,sp,48
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
    80002b80:	0022f497          	auipc	s1,0x22f
    80002b84:	71848493          	addi	s1,s1,1816 # 80232298 <proc>
  {
    acquire(&p->lock);        // lock the process
    if (p->state == SLEEPING) // if the Process is sleeping
    80002b88:	4989                	li	s3,2
      p->sleepTime++;         // increment the sleepTime
    if (p->state == RUNNING)  // if the Process is running
    80002b8a:	4a11                	li	s4,4
  for (p = proc; p < &proc[NPROC]; p++)
    80002b8c:	00237917          	auipc	s2,0x237
    80002b90:	10c90913          	addi	s2,s2,268 # 80239c98 <queuetable>
    80002b94:	a829                	j	80002bae <update_time+0x3e>
      p->sleepTime++;         // increment the sleepTime
    80002b96:	5cbc                	lw	a5,120(s1)
    80002b98:	2785                	addiw	a5,a5,1
    80002b9a:	dcbc                	sw	a5,120(s1)
      p->runTime++;      // increment the runTime
      p->totalRunTime++; // increment the totalRunTime
      p->totalrtime++;
    }

    release(&p->lock); // unlock the process
    80002b9c:	8526                	mv	a0,s1
    80002b9e:	ffffe097          	auipc	ra,0xffffe
    80002ba2:	20a080e7          	jalr	522(ra) # 80000da8 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002ba6:	1e848493          	addi	s1,s1,488
    80002baa:	03248d63          	beq	s1,s2,80002be4 <update_time+0x74>
    acquire(&p->lock);        // lock the process
    80002bae:	8526                	mv	a0,s1
    80002bb0:	ffffe097          	auipc	ra,0xffffe
    80002bb4:	144080e7          	jalr	324(ra) # 80000cf4 <acquire>
    if (p->state == SLEEPING) // if the Process is sleeping
    80002bb8:	4c9c                	lw	a5,24(s1)
    80002bba:	fd378ee3          	beq	a5,s3,80002b96 <update_time+0x26>
    if (p->state == RUNNING)  // if the Process is running
    80002bbe:	fd479fe3          	bne	a5,s4,80002b9c <update_time+0x2c>
      p->runningticks++;
    80002bc2:	1b44a783          	lw	a5,436(s1)
    80002bc6:	2785                	addiw	a5,a5,1
    80002bc8:	1af4aa23          	sw	a5,436(s1)
      p->runTime++;      // increment the runTime
    80002bcc:	58bc                	lw	a5,112(s1)
    80002bce:	2785                	addiw	a5,a5,1
    80002bd0:	d8bc                	sw	a5,112(s1)
      p->totalRunTime++; // increment the totalRunTime
    80002bd2:	5cfc                	lw	a5,124(s1)
    80002bd4:	2785                	addiw	a5,a5,1
    80002bd6:	dcfc                	sw	a5,124(s1)
      p->totalrtime++;
    80002bd8:	1bc4a783          	lw	a5,444(s1)
    80002bdc:	2785                	addiw	a5,a5,1
    80002bde:	1af4ae23          	sw	a5,444(s1)
    80002be2:	bf6d                	j	80002b9c <update_time+0x2c>
  }
}
    80002be4:	70a2                	ld	ra,40(sp)
    80002be6:	7402                	ld	s0,32(sp)
    80002be8:	64e2                	ld	s1,24(sp)
    80002bea:	6942                	ld	s2,16(sp)
    80002bec:	69a2                	ld	s3,8(sp)
    80002bee:	6a02                	ld	s4,0(sp)
    80002bf0:	6145                	addi	sp,sp,48
    80002bf2:	8082                	ret

0000000080002bf4 <exit>:

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait().
void exit(int status)
{
    80002bf4:	7179                	addi	sp,sp,-48
    80002bf6:	f406                	sd	ra,40(sp)
    80002bf8:	f022                	sd	s0,32(sp)
    80002bfa:	ec26                	sd	s1,24(sp)
    80002bfc:	e84a                	sd	s2,16(sp)
    80002bfe:	e44e                	sd	s3,8(sp)
    80002c00:	e052                	sd	s4,0(sp)
    80002c02:	1800                	addi	s0,sp,48
    80002c04:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002c06:	fffff097          	auipc	ra,0xfffff
    80002c0a:	f0a080e7          	jalr	-246(ra) # 80001b10 <myproc>
    80002c0e:	89aa                	mv	s3,a0

  if (p == initproc)
    80002c10:	00007797          	auipc	a5,0x7
    80002c14:	fc87b783          	ld	a5,-56(a5) # 80009bd8 <initproc>
    80002c18:	11850493          	addi	s1,a0,280
    80002c1c:	19850913          	addi	s2,a0,408
    80002c20:	02a79363          	bne	a5,a0,80002c46 <exit+0x52>
    panic("init exiting");
    80002c24:	00006517          	auipc	a0,0x6
    80002c28:	67c50513          	addi	a0,a0,1660 # 800092a0 <digits+0x260>
    80002c2c:	ffffe097          	auipc	ra,0xffffe
    80002c30:	914080e7          	jalr	-1772(ra) # 80000540 <panic>
  for (int fd = 0; fd < NOFILE; fd++)
  {
    if (p->ofile[fd])
    {
      struct file *f = p->ofile[fd];
      fileclose(f);
    80002c34:	00002097          	auipc	ra,0x2
    80002c38:	556080e7          	jalr	1366(ra) # 8000518a <fileclose>
      p->ofile[fd] = 0;
    80002c3c:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    80002c40:	04a1                	addi	s1,s1,8
    80002c42:	01248563          	beq	s1,s2,80002c4c <exit+0x58>
    if (p->ofile[fd])
    80002c46:	6088                	ld	a0,0(s1)
    80002c48:	f575                	bnez	a0,80002c34 <exit+0x40>
    80002c4a:	bfdd                	j	80002c40 <exit+0x4c>
    }
  }

  begin_op();
    80002c4c:	00002097          	auipc	ra,0x2
    80002c50:	076080e7          	jalr	118(ra) # 80004cc2 <begin_op>
  iput(p->cwd);
    80002c54:	1989b503          	ld	a0,408(s3)
    80002c58:	00002097          	auipc	ra,0x2
    80002c5c:	858080e7          	jalr	-1960(ra) # 800044b0 <iput>
  end_op();
    80002c60:	00002097          	auipc	ra,0x2
    80002c64:	0e0080e7          	jalr	224(ra) # 80004d40 <end_op>
  p->cwd = 0;
    80002c68:	1809bc23          	sd	zero,408(s3)

  acquire(&wait_lock);
    80002c6c:	0022f497          	auipc	s1,0x22f
    80002c70:	21448493          	addi	s1,s1,532 # 80231e80 <wait_lock>
    80002c74:	8526                	mv	a0,s1
    80002c76:	ffffe097          	auipc	ra,0xffffe
    80002c7a:	07e080e7          	jalr	126(ra) # 80000cf4 <acquire>

  // Give any children to init.
  reparent(p);
    80002c7e:	854e                	mv	a0,s3
    80002c80:	00000097          	auipc	ra,0x0
    80002c84:	9ae080e7          	jalr	-1618(ra) # 8000262e <reparent>

  // Parent might be sleeping in wait().
  wakeup(p->parent);
    80002c88:	0389b503          	ld	a0,56(s3)
    80002c8c:	00000097          	auipc	ra,0x0
    80002c90:	87c080e7          	jalr	-1924(ra) # 80002508 <wakeup>

  acquire(&p->lock);
    80002c94:	854e                	mv	a0,s3
    80002c96:	ffffe097          	auipc	ra,0xffffe
    80002c9a:	05e080e7          	jalr	94(ra) # 80000cf4 <acquire>

  p->xstate = status;
    80002c9e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002ca2:	4795                	li	a5,5
    80002ca4:	00f9ac23          	sw	a5,24(s3)
  p->exitTime = ticks;
    80002ca8:	00007797          	auipc	a5,0x7
    80002cac:	f387a783          	lw	a5,-200(a5) # 80009be0 <ticks>
    80002cb0:	06f9a623          	sw	a5,108(s3)

  release(&wait_lock);
    80002cb4:	8526                	mv	a0,s1
    80002cb6:	ffffe097          	auipc	ra,0xffffe
    80002cba:	0f2080e7          	jalr	242(ra) # 80000da8 <release>

  // Jump into the scheduler, never to return.
  sched();
    80002cbe:	fffff097          	auipc	ra,0xfffff
    80002cc2:	6d4080e7          	jalr	1748(ra) # 80002392 <sched>
  panic("zombie exit");
    80002cc6:	00006517          	auipc	a0,0x6
    80002cca:	5ea50513          	addi	a0,a0,1514 # 800092b0 <digits+0x270>
    80002cce:	ffffe097          	auipc	ra,0xffffe
    80002cd2:	872080e7          	jalr	-1934(ra) # 80000540 <panic>

0000000080002cd6 <restore>:
//     release(&p->lock);
//   }
//   return old_;
// }
void restore()
{
    80002cd6:	1101                	addi	sp,sp,-32
    80002cd8:	ec06                	sd	ra,24(sp)
    80002cda:	e822                	sd	s0,16(sp)
    80002cdc:	e426                	sd	s1,8(sp)
    80002cde:	1000                	addi	s0,sp,32
  myproc()->trapframe_copy->kernel_sp = myproc()->trapframe->kernel_sp;
    80002ce0:	fffff097          	auipc	ra,0xfffff
    80002ce4:	e30080e7          	jalr	-464(ra) # 80001b10 <myproc>
    80002ce8:	7144                	ld	s1,160(a0)
    80002cea:	fffff097          	auipc	ra,0xfffff
    80002cee:	e26080e7          	jalr	-474(ra) # 80001b10 <myproc>
    80002cf2:	6d3c                	ld	a5,88(a0)
    80002cf4:	6498                	ld	a4,8(s1)
    80002cf6:	e798                	sd	a4,8(a5)
  myproc()->trapframe_copy->kernel_satp = myproc()->trapframe->kernel_satp;
    80002cf8:	fffff097          	auipc	ra,0xfffff
    80002cfc:	e18080e7          	jalr	-488(ra) # 80001b10 <myproc>
    80002d00:	7144                	ld	s1,160(a0)
    80002d02:	fffff097          	auipc	ra,0xfffff
    80002d06:	e0e080e7          	jalr	-498(ra) # 80001b10 <myproc>
    80002d0a:	6d3c                	ld	a5,88(a0)
    80002d0c:	6098                	ld	a4,0(s1)
    80002d0e:	e398                	sd	a4,0(a5)
  myproc()->trapframe_copy->kernel_hartid = myproc()->trapframe->kernel_hartid;
    80002d10:	fffff097          	auipc	ra,0xfffff
    80002d14:	e00080e7          	jalr	-512(ra) # 80001b10 <myproc>
    80002d18:	7144                	ld	s1,160(a0)
    80002d1a:	fffff097          	auipc	ra,0xfffff
    80002d1e:	df6080e7          	jalr	-522(ra) # 80001b10 <myproc>
    80002d22:	6d3c                	ld	a5,88(a0)
    80002d24:	7098                	ld	a4,32(s1)
    80002d26:	f398                	sd	a4,32(a5)
  myproc()->trapframe_copy->kernel_trap = myproc()->trapframe->kernel_trap;
    80002d28:	fffff097          	auipc	ra,0xfffff
    80002d2c:	de8080e7          	jalr	-536(ra) # 80001b10 <myproc>
    80002d30:	7144                	ld	s1,160(a0)
    80002d32:	fffff097          	auipc	ra,0xfffff
    80002d36:	dde080e7          	jalr	-546(ra) # 80001b10 <myproc>
    80002d3a:	6d3c                	ld	a5,88(a0)
    80002d3c:	6898                	ld	a4,16(s1)
    80002d3e:	eb98                	sd	a4,16(a5)
  *(myproc()->trapframe) = *(myproc()->trapframe_copy);
    80002d40:	fffff097          	auipc	ra,0xfffff
    80002d44:	dd0080e7          	jalr	-560(ra) # 80001b10 <myproc>
    80002d48:	6d24                	ld	s1,88(a0)
    80002d4a:	fffff097          	auipc	ra,0xfffff
    80002d4e:	dc6080e7          	jalr	-570(ra) # 80001b10 <myproc>
    80002d52:	87a6                	mv	a5,s1
    80002d54:	7158                	ld	a4,160(a0)
    80002d56:	12048493          	addi	s1,s1,288
    80002d5a:	6388                	ld	a0,0(a5)
    80002d5c:	678c                	ld	a1,8(a5)
    80002d5e:	6b90                	ld	a2,16(a5)
    80002d60:	6f94                	ld	a3,24(a5)
    80002d62:	e308                	sd	a0,0(a4)
    80002d64:	e70c                	sd	a1,8(a4)
    80002d66:	eb10                	sd	a2,16(a4)
    80002d68:	ef14                	sd	a3,24(a4)
    80002d6a:	02078793          	addi	a5,a5,32
    80002d6e:	02070713          	addi	a4,a4,32
    80002d72:	fe9794e3          	bne	a5,s1,80002d5a <restore+0x84>
}
    80002d76:	60e2                	ld	ra,24(sp)
    80002d78:	6442                	ld	s0,16(sp)
    80002d7a:	64a2                	ld	s1,8(sp)
    80002d7c:	6105                	addi	sp,sp,32
    80002d7e:	8082                	ret

0000000080002d80 <sys_sigreturn>:
uint64
sys_sigreturn(void)
{
    80002d80:	1141                	addi	sp,sp,-16
    80002d82:	e406                	sd	ra,8(sp)
    80002d84:	e022                	sd	s0,0(sp)
    80002d86:	0800                	addi	s0,sp,16
  restore();
    80002d88:	00000097          	auipc	ra,0x0
    80002d8c:	f4e080e7          	jalr	-178(ra) # 80002cd6 <restore>
  myproc()->is_sigalarm = 0;
    80002d90:	fffff097          	auipc	ra,0xfffff
    80002d94:	d80080e7          	jalr	-640(ra) # 80001b10 <myproc>
    80002d98:	04052023          	sw	zero,64(a0)
  return myproc()->trapframe->a0;
    80002d9c:	fffff097          	auipc	ra,0xfffff
    80002da0:	d74080e7          	jalr	-652(ra) # 80001b10 <myproc>
    80002da4:	715c                	ld	a5,160(a0)
}
    80002da6:	7ba8                	ld	a0,112(a5)
    80002da8:	60a2                	ld	ra,8(sp)
    80002daa:	6402                	ld	s0,0(sp)
    80002dac:	0141                	addi	sp,sp,16
    80002dae:	8082                	ret

0000000080002db0 <sys_set_priority>:
uint64
sys_set_priority(void)
{
    80002db0:	7139                	addi	sp,sp,-64
    80002db2:	fc06                	sd	ra,56(sp)
    80002db4:	f822                	sd	s0,48(sp)
    80002db6:	f426                	sd	s1,40(sp)
    80002db8:	f04a                	sd	s2,32(sp)
    80002dba:	ec4e                	sd	s3,24(sp)
    80002dbc:	0080                	addi	s0,sp,64
  // similar
  int priority, pid_;
  int oldpriority = 101;
  argint(0, &priority);
    80002dbe:	fcc40593          	addi	a1,s0,-52
    80002dc2:	4501                	li	a0,0
    80002dc4:	00000097          	auipc	ra,0x0
    80002dc8:	742080e7          	jalr	1858(ra) # 80003506 <argint>
  argint(1, &pid_);
    80002dcc:	fc840593          	addi	a1,s0,-56
    80002dd0:	4505                	li	a0,1
    80002dd2:	00000097          	auipc	ra,0x0
    80002dd6:	734080e7          	jalr	1844(ra) # 80003506 <argint>
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80002dda:	0022f497          	auipc	s1,0x22f
    80002dde:	4be48493          	addi	s1,s1,1214 # 80232298 <proc>
  {
    acquire(&p->lock);

    if (p->pid == pid_ && priority >= 0 && priority <= 100)
    80002de2:	06400993          	li	s3,100
  for (p = proc; p < &proc[NPROC]; p++)
    80002de6:	00237917          	auipc	s2,0x237
    80002dea:	eb290913          	addi	s2,s2,-334 # 80239c98 <queuetable>
    80002dee:	a811                	j	80002e02 <sys_set_priority+0x52>
      oldpriority = p->priority;
      p->priority = priority;
#endif
    }

    release(&p->lock);
    80002df0:	8526                	mv	a0,s1
    80002df2:	ffffe097          	auipc	ra,0xffffe
    80002df6:	fb6080e7          	jalr	-74(ra) # 80000da8 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002dfa:	1e848493          	addi	s1,s1,488
    80002dfe:	03248563          	beq	s1,s2,80002e28 <sys_set_priority+0x78>
    acquire(&p->lock);
    80002e02:	8526                	mv	a0,s1
    80002e04:	ffffe097          	auipc	ra,0xffffe
    80002e08:	ef0080e7          	jalr	-272(ra) # 80000cf4 <acquire>
    if (p->pid == pid_ && priority >= 0 && priority <= 100)
    80002e0c:	5898                	lw	a4,48(s1)
    80002e0e:	fc842783          	lw	a5,-56(s0)
    80002e12:	fcf71fe3          	bne	a4,a5,80002df0 <sys_set_priority+0x40>
    80002e16:	fcc42783          	lw	a5,-52(s0)
    80002e1a:	fcf9ebe3          	bltu	s3,a5,80002df0 <sys_set_priority+0x40>
      p->sleepTime = 0;
    80002e1e:	0604ac23          	sw	zero,120(s1)
      p->runTime = 0;
    80002e22:	0604a823          	sw	zero,112(s1)
    80002e26:	b7e9                	j	80002df0 <sys_set_priority+0x40>
  }
  if (oldpriority > priority)
    80002e28:	fcc42703          	lw	a4,-52(s0)
    80002e2c:	06400793          	li	a5,100
    80002e30:	00e7db63          	bge	a5,a4,80002e46 <sys_set_priority+0x96>
    yield();

  return oldpriority;
}
    80002e34:	06500513          	li	a0,101
    80002e38:	70e2                	ld	ra,56(sp)
    80002e3a:	7442                	ld	s0,48(sp)
    80002e3c:	74a2                	ld	s1,40(sp)
    80002e3e:	7902                	ld	s2,32(sp)
    80002e40:	69e2                	ld	s3,24(sp)
    80002e42:	6121                	addi	sp,sp,64
    80002e44:	8082                	ret
    yield();
    80002e46:	fffff097          	auipc	ra,0xfffff
    80002e4a:	622080e7          	jalr	1570(ra) # 80002468 <yield>
    80002e4e:	b7dd                	j	80002e34 <sys_set_priority+0x84>

0000000080002e50 <sys_set_ticket>:
uint64 sys_set_ticket(void)
{
    80002e50:	1101                	addi	sp,sp,-32
    80002e52:	ec06                	sd	ra,24(sp)
    80002e54:	e822                	sd	s0,16(sp)
    80002e56:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002e58:	fec40593          	addi	a1,s0,-20
    80002e5c:	4501                	li	a0,0
    80002e5e:	00000097          	auipc	ra,0x0
    80002e62:	6a8080e7          	jalr	1704(ra) # 80003506 <argint>
  proc->ticket = n;
    80002e66:	fec42503          	lw	a0,-20(s0)
    80002e6a:	0022f797          	auipc	a5,0x22f
    80002e6e:	46a7a123          	sw	a0,1122(a5) # 802322cc <proc+0x34>
  return n;
    80002e72:	60e2                	ld	ra,24(sp)
    80002e74:	6442                	ld	s0,16(sp)
    80002e76:	6105                	addi	sp,sp,32
    80002e78:	8082                	ret

0000000080002e7a <swtch>:
    80002e7a:	00153023          	sd	ra,0(a0)
    80002e7e:	00253423          	sd	sp,8(a0)
    80002e82:	e900                	sd	s0,16(a0)
    80002e84:	ed04                	sd	s1,24(a0)
    80002e86:	03253023          	sd	s2,32(a0)
    80002e8a:	03353423          	sd	s3,40(a0)
    80002e8e:	03453823          	sd	s4,48(a0)
    80002e92:	03553c23          	sd	s5,56(a0)
    80002e96:	05653023          	sd	s6,64(a0)
    80002e9a:	05753423          	sd	s7,72(a0)
    80002e9e:	05853823          	sd	s8,80(a0)
    80002ea2:	05953c23          	sd	s9,88(a0)
    80002ea6:	07a53023          	sd	s10,96(a0)
    80002eaa:	07b53423          	sd	s11,104(a0)
    80002eae:	0005b083          	ld	ra,0(a1)
    80002eb2:	0085b103          	ld	sp,8(a1)
    80002eb6:	6980                	ld	s0,16(a1)
    80002eb8:	6d84                	ld	s1,24(a1)
    80002eba:	0205b903          	ld	s2,32(a1)
    80002ebe:	0285b983          	ld	s3,40(a1)
    80002ec2:	0305ba03          	ld	s4,48(a1)
    80002ec6:	0385ba83          	ld	s5,56(a1)
    80002eca:	0405bb03          	ld	s6,64(a1)
    80002ece:	0485bb83          	ld	s7,72(a1)
    80002ed2:	0505bc03          	ld	s8,80(a1)
    80002ed6:	0585bc83          	ld	s9,88(a1)
    80002eda:	0605bd03          	ld	s10,96(a1)
    80002ede:	0685bd83          	ld	s11,104(a1)
    80002ee2:	8082                	ret

0000000080002ee4 <cow_trap_handler>:
void kernelvec();

extern int devintr();

int cow_trap_handler(void *va, pagetable_t pagetable)
{
    80002ee4:	7179                	addi	sp,sp,-48
    80002ee6:	f406                	sd	ra,40(sp)
    80002ee8:	f022                	sd	s0,32(sp)
    80002eea:	ec26                	sd	s1,24(sp)
    80002eec:	e84a                	sd	s2,16(sp)
    80002eee:	e44e                	sd	s3,8(sp)
    80002ef0:	e052                	sd	s4,0(sp)
    80002ef2:	1800                	addi	s0,sp,48
    80002ef4:	84aa                	mv	s1,a0
    80002ef6:	892e                	mv	s2,a1

  struct proc *p = myproc();
    80002ef8:	fffff097          	auipc	ra,0xfffff
    80002efc:	c18080e7          	jalr	-1000(ra) # 80001b10 <myproc>
  if ((uint64)va >= MAXVA || ((uint64)va >= PGROUNDDOWN(p->trapframe->sp) - PGSIZE && (uint64)va <= PGROUNDDOWN(p->trapframe->sp)))
    80002f00:	57fd                	li	a5,-1
    80002f02:	83e9                	srli	a5,a5,0x1a
    80002f04:	0897e663          	bltu	a5,s1,80002f90 <cow_trap_handler+0xac>
    80002f08:	7158                	ld	a4,160(a0)
    80002f0a:	77fd                	lui	a5,0xfffff
    80002f0c:	7b18                	ld	a4,48(a4)
    80002f0e:	8f7d                	and	a4,a4,a5
    80002f10:	97ba                	add	a5,a5,a4
    80002f12:	00f4e463          	bltu	s1,a5,80002f1a <cow_trap_handler+0x36>
    80002f16:	06977f63          	bgeu	a4,s1,80002f94 <cow_trap_handler+0xb0>

  pte_t *pte;
  uint64 pa;
  uint flags;
  va = (void *)PGROUNDDOWN((uint64)va);
  pte = walk(pagetable, (uint64)va, 0);
    80002f1a:	4601                	li	a2,0
    80002f1c:	75fd                	lui	a1,0xfffff
    80002f1e:	8de5                	and	a1,a1,s1
    80002f20:	854a                	mv	a0,s2
    80002f22:	ffffe097          	auipc	ra,0xffffe
    80002f26:	1ba080e7          	jalr	442(ra) # 800010dc <walk>
    80002f2a:	84aa                	mv	s1,a0
  if (pte == 0)
    80002f2c:	c535                	beqz	a0,80002f98 <cow_trap_handler+0xb4>
  {
    return -1;
  }
  pa = PTE2PA(*pte);
    80002f2e:	611c                	ld	a5,0(a0)
    80002f30:	00a7d913          	srli	s2,a5,0xa
    80002f34:	0932                	slli	s2,s2,0xc
  if (pa == 0)
    80002f36:	06090363          	beqz	s2,80002f9c <cow_trap_handler+0xb8>
  {
    return -1;
  }
  flags = PTE_FLAGS(*pte);
    80002f3a:	0007871b          	sext.w	a4,a5
  if (flags & PTE_C)
    80002f3e:	0207f793          	andi	a5,a5,32
    memmove(mem, (void *)pa, PGSIZE);
    *pte = PA2PTE(mem) | flags;
    kfree((void *)pa);
    return 0;
  }
  return 0;
    80002f42:	4501                	li	a0,0
  if (flags & PTE_C)
    80002f44:	eb89                	bnez	a5,80002f56 <cow_trap_handler+0x72>
}
    80002f46:	70a2                	ld	ra,40(sp)
    80002f48:	7402                	ld	s0,32(sp)
    80002f4a:	64e2                	ld	s1,24(sp)
    80002f4c:	6942                	ld	s2,16(sp)
    80002f4e:	69a2                	ld	s3,8(sp)
    80002f50:	6a02                	ld	s4,0(sp)
    80002f52:	6145                	addi	sp,sp,48
    80002f54:	8082                	ret
    flags = flags & (~PTE_C);
    80002f56:	3df77713          	andi	a4,a4,991
    flags = flags | PTE_W;
    80002f5a:	00476993          	ori	s3,a4,4
    if ((mem = kalloc()) == 0)
    80002f5e:	ffffe097          	auipc	ra,0xffffe
    80002f62:	c9c080e7          	jalr	-868(ra) # 80000bfa <kalloc>
    80002f66:	8a2a                	mv	s4,a0
    80002f68:	cd05                	beqz	a0,80002fa0 <cow_trap_handler+0xbc>
    memmove(mem, (void *)pa, PGSIZE);
    80002f6a:	6605                	lui	a2,0x1
    80002f6c:	85ca                	mv	a1,s2
    80002f6e:	ffffe097          	auipc	ra,0xffffe
    80002f72:	ede080e7          	jalr	-290(ra) # 80000e4c <memmove>
    *pte = PA2PTE(mem) | flags;
    80002f76:	00ca5a13          	srli	s4,s4,0xc
    80002f7a:	0a2a                	slli	s4,s4,0xa
    80002f7c:	0149e733          	or	a4,s3,s4
    80002f80:	e098                	sd	a4,0(s1)
    kfree((void *)pa);
    80002f82:	854a                	mv	a0,s2
    80002f84:	ffffe097          	auipc	ra,0xffffe
    80002f88:	ace080e7          	jalr	-1330(ra) # 80000a52 <kfree>
    return 0;
    80002f8c:	4501                	li	a0,0
    80002f8e:	bf65                	j	80002f46 <cow_trap_handler+0x62>
    return -2;
    80002f90:	5579                	li	a0,-2
    80002f92:	bf55                	j	80002f46 <cow_trap_handler+0x62>
    80002f94:	5579                	li	a0,-2
    80002f96:	bf45                	j	80002f46 <cow_trap_handler+0x62>
    return -1;
    80002f98:	557d                	li	a0,-1
    80002f9a:	b775                	j	80002f46 <cow_trap_handler+0x62>
    return -1;
    80002f9c:	557d                	li	a0,-1
    80002f9e:	b765                	j	80002f46 <cow_trap_handler+0x62>
      return -1;
    80002fa0:	557d                	li	a0,-1
    80002fa2:	b755                	j	80002f46 <cow_trap_handler+0x62>

0000000080002fa4 <trapinit>:

void trapinit(void)
{
    80002fa4:	1141                	addi	sp,sp,-16
    80002fa6:	e406                	sd	ra,8(sp)
    80002fa8:	e022                	sd	s0,0(sp)
    80002faa:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002fac:	00006597          	auipc	a1,0x6
    80002fb0:	37458593          	addi	a1,a1,884 # 80009320 <states.0+0x30>
    80002fb4:	00237517          	auipc	a0,0x237
    80002fb8:	73450513          	addi	a0,a0,1844 # 8023a6e8 <tickslock>
    80002fbc:	ffffe097          	auipc	ra,0xffffe
    80002fc0:	ca8080e7          	jalr	-856(ra) # 80000c64 <initlock>
}
    80002fc4:	60a2                	ld	ra,8(sp)
    80002fc6:	6402                	ld	s0,0(sp)
    80002fc8:	0141                	addi	sp,sp,16
    80002fca:	8082                	ret

0000000080002fcc <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002fcc:	1141                	addi	sp,sp,-16
    80002fce:	e422                	sd	s0,8(sp)
    80002fd0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0"
    80002fd2:	00004797          	auipc	a5,0x4
    80002fd6:	80e78793          	addi	a5,a5,-2034 # 800067e0 <kernelvec>
    80002fda:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002fde:	6422                	ld	s0,8(sp)
    80002fe0:	0141                	addi	sp,sp,16
    80002fe2:	8082                	ret

0000000080002fe4 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002fe4:	1141                	addi	sp,sp,-16
    80002fe6:	e406                	sd	ra,8(sp)
    80002fe8:	e022                	sd	s0,0(sp)
    80002fea:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002fec:	fffff097          	auipc	ra,0xfffff
    80002ff0:	b24080e7          	jalr	-1244(ra) # 80001b10 <myproc>
  asm volatile("csrr %0, sstatus"
    80002ff4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002ff8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0"
    80002ffa:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002ffe:	00005697          	auipc	a3,0x5
    80003002:	00268693          	addi	a3,a3,2 # 80008000 <_trampoline>
    80003006:	00005717          	auipc	a4,0x5
    8000300a:	ffa70713          	addi	a4,a4,-6 # 80008000 <_trampoline>
    8000300e:	8f15                	sub	a4,a4,a3
    80003010:	040007b7          	lui	a5,0x4000
    80003014:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80003016:	07b2                	slli	a5,a5,0xc
    80003018:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0"
    8000301a:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000301e:	7158                	ld	a4,160(a0)
  asm volatile("csrr %0, satp"
    80003020:	18002673          	csrr	a2,satp
    80003024:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80003026:	7150                	ld	a2,160(a0)
    80003028:	6558                	ld	a4,136(a0)
    8000302a:	6585                	lui	a1,0x1
    8000302c:	972e                	add	a4,a4,a1
    8000302e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80003030:	7158                	ld	a4,160(a0)
    80003032:	00000617          	auipc	a2,0x0
    80003036:	13e60613          	addi	a2,a2,318 # 80003170 <usertrap>
    8000303a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    8000303c:	7158                	ld	a4,160(a0)
  asm volatile("mv %0, tp"
    8000303e:	8612                	mv	a2,tp
    80003040:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus"
    80003042:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80003046:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000304a:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0"
    8000304e:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80003052:	7158                	ld	a4,160(a0)
  asm volatile("csrw sepc, %0"
    80003054:	6f18                	ld	a4,24(a4)
    80003056:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000305a:	6d48                	ld	a0,152(a0)
    8000305c:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000305e:	00005717          	auipc	a4,0x5
    80003062:	03e70713          	addi	a4,a4,62 # 8000809c <userret>
    80003066:	8f15                	sub	a4,a4,a3
    80003068:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000306a:	577d                	li	a4,-1
    8000306c:	177e                	slli	a4,a4,0x3f
    8000306e:	8d59                	or	a0,a0,a4
    80003070:	9782                	jalr	a5
}
    80003072:	60a2                	ld	ra,8(sp)
    80003074:	6402                	ld	s0,0(sp)
    80003076:	0141                	addi	sp,sp,16
    80003078:	8082                	ret

000000008000307a <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    8000307a:	1101                	addi	sp,sp,-32
    8000307c:	ec06                	sd	ra,24(sp)
    8000307e:	e822                	sd	s0,16(sp)
    80003080:	e426                	sd	s1,8(sp)
    80003082:	e04a                	sd	s2,0(sp)
    80003084:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80003086:	00237917          	auipc	s2,0x237
    8000308a:	66290913          	addi	s2,s2,1634 # 8023a6e8 <tickslock>
    8000308e:	854a                	mv	a0,s2
    80003090:	ffffe097          	auipc	ra,0xffffe
    80003094:	c64080e7          	jalr	-924(ra) # 80000cf4 <acquire>
  ticks++;
    80003098:	00007497          	auipc	s1,0x7
    8000309c:	b4848493          	addi	s1,s1,-1208 # 80009be0 <ticks>
    800030a0:	409c                	lw	a5,0(s1)
    800030a2:	2785                	addiw	a5,a5,1
    800030a4:	c09c                	sw	a5,0(s1)
  update_time();
    800030a6:	00000097          	auipc	ra,0x0
    800030aa:	aca080e7          	jalr	-1334(ra) # 80002b70 <update_time>
  wakeup(&ticks);
    800030ae:	8526                	mv	a0,s1
    800030b0:	fffff097          	auipc	ra,0xfffff
    800030b4:	458080e7          	jalr	1112(ra) # 80002508 <wakeup>
  release(&tickslock);
    800030b8:	854a                	mv	a0,s2
    800030ba:	ffffe097          	auipc	ra,0xffffe
    800030be:	cee080e7          	jalr	-786(ra) # 80000da8 <release>
}
    800030c2:	60e2                	ld	ra,24(sp)
    800030c4:	6442                	ld	s0,16(sp)
    800030c6:	64a2                	ld	s1,8(sp)
    800030c8:	6902                	ld	s2,0(sp)
    800030ca:	6105                	addi	sp,sp,32
    800030cc:	8082                	ret

00000000800030ce <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    800030ce:	1101                	addi	sp,sp,-32
    800030d0:	ec06                	sd	ra,24(sp)
    800030d2:	e822                	sd	s0,16(sp)
    800030d4:	e426                	sd	s1,8(sp)
    800030d6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause"
    800030d8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    800030dc:	00074d63          	bltz	a4,800030f6 <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L)
    800030e0:	57fd                	li	a5,-1
    800030e2:	17fe                	slli	a5,a5,0x3f
    800030e4:	0785                	addi	a5,a5,1

    return 2;
  }
  else
  {
    return 0;
    800030e6:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    800030e8:	06f70363          	beq	a4,a5,8000314e <devintr+0x80>
  }
}
    800030ec:	60e2                	ld	ra,24(sp)
    800030ee:	6442                	ld	s0,16(sp)
    800030f0:	64a2                	ld	s1,8(sp)
    800030f2:	6105                	addi	sp,sp,32
    800030f4:	8082                	ret
      (scause & 0xff) == 9)
    800030f6:	0ff77793          	zext.b	a5,a4
  if ((scause & 0x8000000000000000L) &&
    800030fa:	46a5                	li	a3,9
    800030fc:	fed792e3          	bne	a5,a3,800030e0 <devintr+0x12>
    int irq = plic_claim();
    80003100:	00003097          	auipc	ra,0x3
    80003104:	7e8080e7          	jalr	2024(ra) # 800068e8 <plic_claim>
    80003108:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    8000310a:	47a9                	li	a5,10
    8000310c:	02f50763          	beq	a0,a5,8000313a <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ)
    80003110:	4785                	li	a5,1
    80003112:	02f50963          	beq	a0,a5,80003144 <devintr+0x76>
    return 1;
    80003116:	4505                	li	a0,1
    else if (irq)
    80003118:	d8f1                	beqz	s1,800030ec <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    8000311a:	85a6                	mv	a1,s1
    8000311c:	00006517          	auipc	a0,0x6
    80003120:	20c50513          	addi	a0,a0,524 # 80009328 <states.0+0x38>
    80003124:	ffffd097          	auipc	ra,0xffffd
    80003128:	466080e7          	jalr	1126(ra) # 8000058a <printf>
      plic_complete(irq);
    8000312c:	8526                	mv	a0,s1
    8000312e:	00003097          	auipc	ra,0x3
    80003132:	7de080e7          	jalr	2014(ra) # 8000690c <plic_complete>
    return 1;
    80003136:	4505                	li	a0,1
    80003138:	bf55                	j	800030ec <devintr+0x1e>
      uartintr();
    8000313a:	ffffe097          	auipc	ra,0xffffe
    8000313e:	85e080e7          	jalr	-1954(ra) # 80000998 <uartintr>
    80003142:	b7ed                	j	8000312c <devintr+0x5e>
      virtio_disk_intr();
    80003144:	00004097          	auipc	ra,0x4
    80003148:	f96080e7          	jalr	-106(ra) # 800070da <virtio_disk_intr>
    8000314c:	b7c5                	j	8000312c <devintr+0x5e>
    if (cpuid() == 0)
    8000314e:	fffff097          	auipc	ra,0xfffff
    80003152:	996080e7          	jalr	-1642(ra) # 80001ae4 <cpuid>
    80003156:	c901                	beqz	a0,80003166 <devintr+0x98>
  asm volatile("csrr %0, sip"
    80003158:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000315c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0"
    8000315e:	14479073          	csrw	sip,a5
    return 2;
    80003162:	4509                	li	a0,2
    80003164:	b761                	j	800030ec <devintr+0x1e>
      clockintr();
    80003166:	00000097          	auipc	ra,0x0
    8000316a:	f14080e7          	jalr	-236(ra) # 8000307a <clockintr>
    8000316e:	b7ed                	j	80003158 <devintr+0x8a>

0000000080003170 <usertrap>:
{
    80003170:	1101                	addi	sp,sp,-32
    80003172:	ec06                	sd	ra,24(sp)
    80003174:	e822                	sd	s0,16(sp)
    80003176:	e426                	sd	s1,8(sp)
    80003178:	e04a                	sd	s2,0(sp)
    8000317a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus"
    8000317c:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80003180:	1007f793          	andi	a5,a5,256
    80003184:	e3b5                	bnez	a5,800031e8 <usertrap+0x78>
  asm volatile("csrw stvec, %0"
    80003186:	00003797          	auipc	a5,0x3
    8000318a:	65a78793          	addi	a5,a5,1626 # 800067e0 <kernelvec>
    8000318e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80003192:	fffff097          	auipc	ra,0xfffff
    80003196:	97e080e7          	jalr	-1666(ra) # 80001b10 <myproc>
    8000319a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000319c:	715c                	ld	a5,160(a0)
  asm volatile("csrr %0, sepc"
    8000319e:	14102773          	csrr	a4,sepc
    800031a2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause"
    800031a4:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    800031a8:	47a1                	li	a5,8
    800031aa:	04f70763          	beq	a4,a5,800031f8 <usertrap+0x88>
  else if ((which_dev = devintr()) != 0)
    800031ae:	00000097          	auipc	ra,0x0
    800031b2:	f20080e7          	jalr	-224(ra) # 800030ce <devintr>
    800031b6:	892a                	mv	s2,a0
    800031b8:	e179                	bnez	a0,8000327e <usertrap+0x10e>
    800031ba:	14202773          	csrr	a4,scause
  else if (r_scause() == 15 || r_scause() == 13)
    800031be:	47bd                	li	a5,15
    800031c0:	00f70763          	beq	a4,a5,800031ce <usertrap+0x5e>
    800031c4:	14202773          	csrr	a4,scause
    800031c8:	47b5                	li	a5,13
    800031ca:	08f71063          	bne	a4,a5,8000324a <usertrap+0xda>
  asm volatile("csrr %0, stval"
    800031ce:	14302573          	csrr	a0,stval
    int res = cow_trap_handler((void *)r_stval(), p->pagetable);
    800031d2:	6ccc                	ld	a1,152(s1)
    800031d4:	00000097          	auipc	ra,0x0
    800031d8:	d10080e7          	jalr	-752(ra) # 80002ee4 <cow_trap_handler>
    if (res == -1 || res == -2)
    800031dc:	2509                	addiw	a0,a0,2
    800031de:	4785                	li	a5,1
    800031e0:	02a7ef63          	bltu	a5,a0,8000321e <usertrap+0xae>
      p->killed = 1;
    800031e4:	d49c                	sw	a5,40(s1)
    800031e6:	a825                	j	8000321e <usertrap+0xae>
    panic("usertrap: not from user mode");
    800031e8:	00006517          	auipc	a0,0x6
    800031ec:	16050513          	addi	a0,a0,352 # 80009348 <states.0+0x58>
    800031f0:	ffffd097          	auipc	ra,0xffffd
    800031f4:	350080e7          	jalr	848(ra) # 80000540 <panic>
    if (killed(p))
    800031f8:	fffff097          	auipc	ra,0xfffff
    800031fc:	52e080e7          	jalr	1326(ra) # 80002726 <killed>
    80003200:	ed1d                	bnez	a0,8000323e <usertrap+0xce>
    p->trapframe->epc += 4;
    80003202:	70d8                	ld	a4,160(s1)
    80003204:	6f1c                	ld	a5,24(a4)
    80003206:	0791                	addi	a5,a5,4
    80003208:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus"
    8000320a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000320e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0"
    80003212:	10079073          	csrw	sstatus,a5
    syscall();
    80003216:	00000097          	auipc	ra,0x0
    8000321a:	368080e7          	jalr	872(ra) # 8000357e <syscall>
  if (killed(p))
    8000321e:	8526                	mv	a0,s1
    80003220:	fffff097          	auipc	ra,0xfffff
    80003224:	506080e7          	jalr	1286(ra) # 80002726 <killed>
    80003228:	e135                	bnez	a0,8000328c <usertrap+0x11c>
  usertrapret();
    8000322a:	00000097          	auipc	ra,0x0
    8000322e:	dba080e7          	jalr	-582(ra) # 80002fe4 <usertrapret>
}
    80003232:	60e2                	ld	ra,24(sp)
    80003234:	6442                	ld	s0,16(sp)
    80003236:	64a2                	ld	s1,8(sp)
    80003238:	6902                	ld	s2,0(sp)
    8000323a:	6105                	addi	sp,sp,32
    8000323c:	8082                	ret
      exit(-1);
    8000323e:	557d                	li	a0,-1
    80003240:	00000097          	auipc	ra,0x0
    80003244:	9b4080e7          	jalr	-1612(ra) # 80002bf4 <exit>
    80003248:	bf6d                	j	80003202 <usertrap+0x92>
  asm volatile("csrr %0, scause"
    8000324a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000324e:	5890                	lw	a2,48(s1)
    80003250:	00006517          	auipc	a0,0x6
    80003254:	11850513          	addi	a0,a0,280 # 80009368 <states.0+0x78>
    80003258:	ffffd097          	auipc	ra,0xffffd
    8000325c:	332080e7          	jalr	818(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc"
    80003260:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval"
    80003264:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003268:	00006517          	auipc	a0,0x6
    8000326c:	13050513          	addi	a0,a0,304 # 80009398 <states.0+0xa8>
    80003270:	ffffd097          	auipc	ra,0xffffd
    80003274:	31a080e7          	jalr	794(ra) # 8000058a <printf>
    p->killed = 1;
    80003278:	4785                	li	a5,1
    8000327a:	d49c                	sw	a5,40(s1)
    8000327c:	b74d                	j	8000321e <usertrap+0xae>
  if (killed(p))
    8000327e:	8526                	mv	a0,s1
    80003280:	fffff097          	auipc	ra,0xfffff
    80003284:	4a6080e7          	jalr	1190(ra) # 80002726 <killed>
    80003288:	c901                	beqz	a0,80003298 <usertrap+0x128>
    8000328a:	a011                	j	8000328e <usertrap+0x11e>
    8000328c:	4901                	li	s2,0
    exit(-1);
    8000328e:	557d                	li	a0,-1
    80003290:	00000097          	auipc	ra,0x0
    80003294:	964080e7          	jalr	-1692(ra) # 80002bf4 <exit>
  if (which_dev == 2)
    80003298:	4789                	li	a5,2
    8000329a:	f8f918e3          	bne	s2,a5,8000322a <usertrap+0xba>
    struct proc *p = myproc();
    8000329e:	fffff097          	auipc	ra,0xfffff
    800032a2:	872080e7          	jalr	-1934(ra) # 80001b10 <myproc>
    800032a6:	84aa                	mv	s1,a0
    if (p->runningticks >= (1 << p->qlevel))
    800032a8:	1c852703          	lw	a4,456(a0)
    800032ac:	1b452783          	lw	a5,436(a0)
    800032b0:	00e7d7bb          	srlw	a5,a5,a4
    800032b4:	ef89                	bnez	a5,800032ce <usertrap+0x15e>
    if (getpreempted(p->qlevel))
    800032b6:	1c84a503          	lw	a0,456(s1)
    800032ba:	fffff097          	auipc	ra,0xfffff
    800032be:	de8080e7          	jalr	-536(ra) # 800020a2 <getpreempted>
    800032c2:	d525                	beqz	a0,8000322a <usertrap+0xba>
      yield();
    800032c4:	fffff097          	auipc	ra,0xfffff
    800032c8:	1a4080e7          	jalr	420(ra) # 80002468 <yield>
    800032cc:	bfb9                	j	8000322a <usertrap+0xba>
      p->qlevel = min(p->qlevel + 1, 5);
    800032ce:	87ba                	mv	a5,a4
    800032d0:	4691                	li	a3,4
    800032d2:	00e6d363          	bge	a3,a4,800032d8 <usertrap+0x168>
    800032d6:	4791                	li	a5,4
    800032d8:	2785                	addiw	a5,a5,1
    800032da:	1cf4a423          	sw	a5,456(s1)
      p->qstate = NOTQUEUED;
    800032de:	4785                	li	a5,1
    800032e0:	1cf4a223          	sw	a5,452(s1)
      yield();
    800032e4:	fffff097          	auipc	ra,0xfffff
    800032e8:	184080e7          	jalr	388(ra) # 80002468 <yield>
    800032ec:	b7e9                	j	800032b6 <usertrap+0x146>

00000000800032ee <kerneltrap>:
{
    800032ee:	7179                	addi	sp,sp,-48
    800032f0:	f406                	sd	ra,40(sp)
    800032f2:	f022                	sd	s0,32(sp)
    800032f4:	ec26                	sd	s1,24(sp)
    800032f6:	e84a                	sd	s2,16(sp)
    800032f8:	e44e                	sd	s3,8(sp)
    800032fa:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc"
    800032fc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus"
    80003300:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause"
    80003304:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80003308:	1004f793          	andi	a5,s1,256
    8000330c:	cb85                	beqz	a5,8000333c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus"
    8000330e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80003312:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80003314:	ef85                	bnez	a5,8000334c <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80003316:	00000097          	auipc	ra,0x0
    8000331a:	db8080e7          	jalr	-584(ra) # 800030ce <devintr>
    8000331e:	cd1d                	beqz	a0,8000335c <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003320:	4789                	li	a5,2
    80003322:	06f50a63          	beq	a0,a5,80003396 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0"
    80003326:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0"
    8000332a:	10049073          	csrw	sstatus,s1
}
    8000332e:	70a2                	ld	ra,40(sp)
    80003330:	7402                	ld	s0,32(sp)
    80003332:	64e2                	ld	s1,24(sp)
    80003334:	6942                	ld	s2,16(sp)
    80003336:	69a2                	ld	s3,8(sp)
    80003338:	6145                	addi	sp,sp,48
    8000333a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000333c:	00006517          	auipc	a0,0x6
    80003340:	07c50513          	addi	a0,a0,124 # 800093b8 <states.0+0xc8>
    80003344:	ffffd097          	auipc	ra,0xffffd
    80003348:	1fc080e7          	jalr	508(ra) # 80000540 <panic>
    panic("kerneltrap: interrupts enabled");
    8000334c:	00006517          	auipc	a0,0x6
    80003350:	09450513          	addi	a0,a0,148 # 800093e0 <states.0+0xf0>
    80003354:	ffffd097          	auipc	ra,0xffffd
    80003358:	1ec080e7          	jalr	492(ra) # 80000540 <panic>
    printf("scause %p\n", scause);
    8000335c:	85ce                	mv	a1,s3
    8000335e:	00006517          	auipc	a0,0x6
    80003362:	0a250513          	addi	a0,a0,162 # 80009400 <states.0+0x110>
    80003366:	ffffd097          	auipc	ra,0xffffd
    8000336a:	224080e7          	jalr	548(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc"
    8000336e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval"
    80003372:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003376:	00006517          	auipc	a0,0x6
    8000337a:	09a50513          	addi	a0,a0,154 # 80009410 <states.0+0x120>
    8000337e:	ffffd097          	auipc	ra,0xffffd
    80003382:	20c080e7          	jalr	524(ra) # 8000058a <printf>
    panic("kerneltrap");
    80003386:	00006517          	auipc	a0,0x6
    8000338a:	0a250513          	addi	a0,a0,162 # 80009428 <states.0+0x138>
    8000338e:	ffffd097          	auipc	ra,0xffffd
    80003392:	1b2080e7          	jalr	434(ra) # 80000540 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003396:	ffffe097          	auipc	ra,0xffffe
    8000339a:	77a080e7          	jalr	1914(ra) # 80001b10 <myproc>
    8000339e:	d541                	beqz	a0,80003326 <kerneltrap+0x38>
    800033a0:	ffffe097          	auipc	ra,0xffffe
    800033a4:	770080e7          	jalr	1904(ra) # 80001b10 <myproc>
    800033a8:	4d18                	lw	a4,24(a0)
    800033aa:	4791                	li	a5,4
    800033ac:	f6f71de3          	bne	a4,a5,80003326 <kerneltrap+0x38>
    struct proc *p = myproc();
    800033b0:	ffffe097          	auipc	ra,0xffffe
    800033b4:	760080e7          	jalr	1888(ra) # 80001b10 <myproc>
    800033b8:	89aa                	mv	s3,a0
    if (p->runningticks >= (1 << p->qlevel))
    800033ba:	1c852703          	lw	a4,456(a0)
    800033be:	1b452783          	lw	a5,436(a0)
    800033c2:	00e7d7bb          	srlw	a5,a5,a4
    800033c6:	ef89                	bnez	a5,800033e0 <kerneltrap+0xf2>
    if (getpreempted(p->qlevel))
    800033c8:	1c89a503          	lw	a0,456(s3)
    800033cc:	fffff097          	auipc	ra,0xfffff
    800033d0:	cd6080e7          	jalr	-810(ra) # 800020a2 <getpreempted>
    800033d4:	d929                	beqz	a0,80003326 <kerneltrap+0x38>
      yield();
    800033d6:	fffff097          	auipc	ra,0xfffff
    800033da:	092080e7          	jalr	146(ra) # 80002468 <yield>
    800033de:	b7a1                	j	80003326 <kerneltrap+0x38>
      p->qlevel = min(p->qlevel + 1, 5);
    800033e0:	87ba                	mv	a5,a4
    800033e2:	4691                	li	a3,4
    800033e4:	00e6d363          	bge	a3,a4,800033ea <kerneltrap+0xfc>
    800033e8:	4791                	li	a5,4
    800033ea:	2785                	addiw	a5,a5,1
    800033ec:	1cf9a423          	sw	a5,456(s3)
      p->qstate = NOTQUEUED;
    800033f0:	4785                	li	a5,1
    800033f2:	1cf9a223          	sw	a5,452(s3)
      yield();
    800033f6:	fffff097          	auipc	ra,0xfffff
    800033fa:	072080e7          	jalr	114(ra) # 80002468 <yield>
    800033fe:	b7e9                	j	800033c8 <kerneltrap+0xda>

0000000080003400 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80003400:	1101                	addi	sp,sp,-32
    80003402:	ec06                	sd	ra,24(sp)
    80003404:	e822                	sd	s0,16(sp)
    80003406:	e426                	sd	s1,8(sp)
    80003408:	1000                	addi	s0,sp,32
    8000340a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000340c:	ffffe097          	auipc	ra,0xffffe
    80003410:	704080e7          	jalr	1796(ra) # 80001b10 <myproc>
  switch (n)
    80003414:	4795                	li	a5,5
    80003416:	0497e163          	bltu	a5,s1,80003458 <argraw+0x58>
    8000341a:	048a                	slli	s1,s1,0x2
    8000341c:	00006717          	auipc	a4,0x6
    80003420:	16470713          	addi	a4,a4,356 # 80009580 <states.0+0x290>
    80003424:	94ba                	add	s1,s1,a4
    80003426:	409c                	lw	a5,0(s1)
    80003428:	97ba                	add	a5,a5,a4
    8000342a:	8782                	jr	a5
  {
  case 0:
    return p->trapframe->a0;
    8000342c:	715c                	ld	a5,160(a0)
    8000342e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80003430:	60e2                	ld	ra,24(sp)
    80003432:	6442                	ld	s0,16(sp)
    80003434:	64a2                	ld	s1,8(sp)
    80003436:	6105                	addi	sp,sp,32
    80003438:	8082                	ret
    return p->trapframe->a1;
    8000343a:	715c                	ld	a5,160(a0)
    8000343c:	7fa8                	ld	a0,120(a5)
    8000343e:	bfcd                	j	80003430 <argraw+0x30>
    return p->trapframe->a2;
    80003440:	715c                	ld	a5,160(a0)
    80003442:	63c8                	ld	a0,128(a5)
    80003444:	b7f5                	j	80003430 <argraw+0x30>
    return p->trapframe->a3;
    80003446:	715c                	ld	a5,160(a0)
    80003448:	67c8                	ld	a0,136(a5)
    8000344a:	b7dd                	j	80003430 <argraw+0x30>
    return p->trapframe->a4;
    8000344c:	715c                	ld	a5,160(a0)
    8000344e:	6bc8                	ld	a0,144(a5)
    80003450:	b7c5                	j	80003430 <argraw+0x30>
    return p->trapframe->a5;
    80003452:	715c                	ld	a5,160(a0)
    80003454:	6fc8                	ld	a0,152(a5)
    80003456:	bfe9                	j	80003430 <argraw+0x30>
  panic("argraw");
    80003458:	00006517          	auipc	a0,0x6
    8000345c:	fe050513          	addi	a0,a0,-32 # 80009438 <states.0+0x148>
    80003460:	ffffd097          	auipc	ra,0xffffd
    80003464:	0e0080e7          	jalr	224(ra) # 80000540 <panic>

0000000080003468 <fetchaddr>:
{
    80003468:	1101                	addi	sp,sp,-32
    8000346a:	ec06                	sd	ra,24(sp)
    8000346c:	e822                	sd	s0,16(sp)
    8000346e:	e426                	sd	s1,8(sp)
    80003470:	e04a                	sd	s2,0(sp)
    80003472:	1000                	addi	s0,sp,32
    80003474:	84aa                	mv	s1,a0
    80003476:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80003478:	ffffe097          	auipc	ra,0xffffe
    8000347c:	698080e7          	jalr	1688(ra) # 80001b10 <myproc>
  if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003480:	695c                	ld	a5,144(a0)
    80003482:	02f4f863          	bgeu	s1,a5,800034b2 <fetchaddr+0x4a>
    80003486:	00848713          	addi	a4,s1,8
    8000348a:	02e7e663          	bltu	a5,a4,800034b6 <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000348e:	46a1                	li	a3,8
    80003490:	8626                	mv	a2,s1
    80003492:	85ca                	mv	a1,s2
    80003494:	6d48                	ld	a0,152(a0)
    80003496:	ffffe097          	auipc	ra,0xffffe
    8000349a:	3c6080e7          	jalr	966(ra) # 8000185c <copyin>
    8000349e:	00a03533          	snez	a0,a0
    800034a2:	40a00533          	neg	a0,a0
}
    800034a6:	60e2                	ld	ra,24(sp)
    800034a8:	6442                	ld	s0,16(sp)
    800034aa:	64a2                	ld	s1,8(sp)
    800034ac:	6902                	ld	s2,0(sp)
    800034ae:	6105                	addi	sp,sp,32
    800034b0:	8082                	ret
    return -1;
    800034b2:	557d                	li	a0,-1
    800034b4:	bfcd                	j	800034a6 <fetchaddr+0x3e>
    800034b6:	557d                	li	a0,-1
    800034b8:	b7fd                	j	800034a6 <fetchaddr+0x3e>

00000000800034ba <fetchstr>:
{
    800034ba:	7179                	addi	sp,sp,-48
    800034bc:	f406                	sd	ra,40(sp)
    800034be:	f022                	sd	s0,32(sp)
    800034c0:	ec26                	sd	s1,24(sp)
    800034c2:	e84a                	sd	s2,16(sp)
    800034c4:	e44e                	sd	s3,8(sp)
    800034c6:	1800                	addi	s0,sp,48
    800034c8:	892a                	mv	s2,a0
    800034ca:	84ae                	mv	s1,a1
    800034cc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800034ce:	ffffe097          	auipc	ra,0xffffe
    800034d2:	642080e7          	jalr	1602(ra) # 80001b10 <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0)
    800034d6:	86ce                	mv	a3,s3
    800034d8:	864a                	mv	a2,s2
    800034da:	85a6                	mv	a1,s1
    800034dc:	6d48                	ld	a0,152(a0)
    800034de:	ffffe097          	auipc	ra,0xffffe
    800034e2:	40c080e7          	jalr	1036(ra) # 800018ea <copyinstr>
    800034e6:	00054e63          	bltz	a0,80003502 <fetchstr+0x48>
  return strlen(buf);
    800034ea:	8526                	mv	a0,s1
    800034ec:	ffffe097          	auipc	ra,0xffffe
    800034f0:	a80080e7          	jalr	-1408(ra) # 80000f6c <strlen>
}
    800034f4:	70a2                	ld	ra,40(sp)
    800034f6:	7402                	ld	s0,32(sp)
    800034f8:	64e2                	ld	s1,24(sp)
    800034fa:	6942                	ld	s2,16(sp)
    800034fc:	69a2                	ld	s3,8(sp)
    800034fe:	6145                	addi	sp,sp,48
    80003500:	8082                	ret
    return -1;
    80003502:	557d                	li	a0,-1
    80003504:	bfc5                	j	800034f4 <fetchstr+0x3a>

0000000080003506 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80003506:	1101                	addi	sp,sp,-32
    80003508:	ec06                	sd	ra,24(sp)
    8000350a:	e822                	sd	s0,16(sp)
    8000350c:	e426                	sd	s1,8(sp)
    8000350e:	1000                	addi	s0,sp,32
    80003510:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003512:	00000097          	auipc	ra,0x0
    80003516:	eee080e7          	jalr	-274(ra) # 80003400 <argraw>
    8000351a:	c088                	sw	a0,0(s1)
}
    8000351c:	60e2                	ld	ra,24(sp)
    8000351e:	6442                	ld	s0,16(sp)
    80003520:	64a2                	ld	s1,8(sp)
    80003522:	6105                	addi	sp,sp,32
    80003524:	8082                	ret

0000000080003526 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80003526:	1101                	addi	sp,sp,-32
    80003528:	ec06                	sd	ra,24(sp)
    8000352a:	e822                	sd	s0,16(sp)
    8000352c:	e426                	sd	s1,8(sp)
    8000352e:	1000                	addi	s0,sp,32
    80003530:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003532:	00000097          	auipc	ra,0x0
    80003536:	ece080e7          	jalr	-306(ra) # 80003400 <argraw>
    8000353a:	e088                	sd	a0,0(s1)
}
    8000353c:	60e2                	ld	ra,24(sp)
    8000353e:	6442                	ld	s0,16(sp)
    80003540:	64a2                	ld	s1,8(sp)
    80003542:	6105                	addi	sp,sp,32
    80003544:	8082                	ret

0000000080003546 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80003546:	7179                	addi	sp,sp,-48
    80003548:	f406                	sd	ra,40(sp)
    8000354a:	f022                	sd	s0,32(sp)
    8000354c:	ec26                	sd	s1,24(sp)
    8000354e:	e84a                	sd	s2,16(sp)
    80003550:	1800                	addi	s0,sp,48
    80003552:	84ae                	mv	s1,a1
    80003554:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80003556:	fd840593          	addi	a1,s0,-40
    8000355a:	00000097          	auipc	ra,0x0
    8000355e:	fcc080e7          	jalr	-52(ra) # 80003526 <argaddr>
  return fetchstr(addr, buf, max);
    80003562:	864a                	mv	a2,s2
    80003564:	85a6                	mv	a1,s1
    80003566:	fd843503          	ld	a0,-40(s0)
    8000356a:	00000097          	auipc	ra,0x0
    8000356e:	f50080e7          	jalr	-176(ra) # 800034ba <fetchstr>
}
    80003572:	70a2                	ld	ra,40(sp)
    80003574:	7402                	ld	s0,32(sp)
    80003576:	64e2                	ld	s1,24(sp)
    80003578:	6942                	ld	s2,16(sp)
    8000357a:	6145                	addi	sp,sp,48
    8000357c:	8082                	ret

000000008000357e <syscall>:
    [SYS_waitx] "waitx",
    [SYS_set_priority] "set_priority",
    [SYS_set_ticket] "set_ticket",
};
void syscall(void)
{
    8000357e:	7179                	addi	sp,sp,-48
    80003580:	f406                	sd	ra,40(sp)
    80003582:	f022                	sd	s0,32(sp)
    80003584:	ec26                	sd	s1,24(sp)
    80003586:	e84a                	sd	s2,16(sp)
    80003588:	e44e                	sd	s3,8(sp)
    8000358a:	e052                	sd	s4,0(sp)
    8000358c:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    8000358e:	ffffe097          	auipc	ra,0xffffe
    80003592:	582080e7          	jalr	1410(ra) # 80001b10 <myproc>
    80003596:	84aa                	mv	s1,a0
  num = p->trapframe->a7;
    80003598:	0a053903          	ld	s2,160(a0)
    8000359c:	0a893783          	ld	a5,168(s2)
    800035a0:	0007899b          	sext.w	s3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    800035a4:	37fd                	addiw	a5,a5,-1
    800035a6:	4769                	li	a4,26
    800035a8:	16f76763          	bltu	a4,a5,80003716 <syscall+0x198>
    800035ac:	00399713          	slli	a4,s3,0x3
    800035b0:	00006797          	auipc	a5,0x6
    800035b4:	fe878793          	addi	a5,a5,-24 # 80009598 <syscalls>
    800035b8:	97ba                	add	a5,a5,a4
    800035ba:	639c                	ld	a5,0(a5)
    800035bc:	14078d63          	beqz	a5,80003716 <syscall+0x198>
  {
    int first_arg = p->trapframe->a0;
    800035c0:	07093a03          	ld	s4,112(s2)
    p->trapframe->a0 = syscalls[num]();
    800035c4:	9782                	jalr	a5
    800035c6:	06a93823          	sd	a0,112(s2)
    if (p->tracemask & (1 << num))
    800035ca:	50bc                	lw	a5,96(s1)
    800035cc:	4137d7bb          	sraw	a5,a5,s3
    800035d0:	8b85                	andi	a5,a5,1
    800035d2:	16078163          	beqz	a5,80003734 <syscall+0x1b6>
    {
      printf("%d: syscall %s ", p->pid, syscall_name[num]);
    800035d6:	00006917          	auipc	s2,0x6
    800035da:	46a90913          	addi	s2,s2,1130 # 80009a40 <syscall_name>
    800035de:	00399793          	slli	a5,s3,0x3
    800035e2:	97ca                	add	a5,a5,s2
    800035e4:	6390                	ld	a2,0(a5)
    800035e6:	588c                	lw	a1,48(s1)
    800035e8:	00006517          	auipc	a0,0x6
    800035ec:	e5850513          	addi	a0,a0,-424 # 80009440 <states.0+0x150>
    800035f0:	ffffd097          	auipc	ra,0xffffd
    800035f4:	f9a080e7          	jalr	-102(ra) # 8000058a <printf>
      if (syscall_argc[num] >= 1)
    800035f8:	00299793          	slli	a5,s3,0x2
    800035fc:	993e                	add	s2,s2,a5
    800035fe:	0e092783          	lw	a5,224(s2)
    80003602:	08f04863          	bgtz	a5,80003692 <syscall+0x114>
        printf("(%d", first_arg);
      if (syscall_argc[num] >= 2)
    80003606:	00299713          	slli	a4,s3,0x2
    8000360a:	00006797          	auipc	a5,0x6
    8000360e:	43678793          	addi	a5,a5,1078 # 80009a40 <syscall_name>
    80003612:	97ba                	add	a5,a5,a4
    80003614:	0e07a703          	lw	a4,224(a5)
    80003618:	4785                	li	a5,1
    8000361a:	08e7c763          	blt	a5,a4,800036a8 <syscall+0x12a>
        printf(" %d", p->trapframe->a1);
      if (syscall_argc[num] >= 3)
    8000361e:	00299713          	slli	a4,s3,0x2
    80003622:	00006797          	auipc	a5,0x6
    80003626:	41e78793          	addi	a5,a5,1054 # 80009a40 <syscall_name>
    8000362a:	97ba                	add	a5,a5,a4
    8000362c:	0e07a703          	lw	a4,224(a5)
    80003630:	4789                	li	a5,2
    80003632:	08e7c663          	blt	a5,a4,800036be <syscall+0x140>
        printf(" %d", p->trapframe->a2);
      if (syscall_argc[num] >= 4)
    80003636:	00299713          	slli	a4,s3,0x2
    8000363a:	00006797          	auipc	a5,0x6
    8000363e:	40678793          	addi	a5,a5,1030 # 80009a40 <syscall_name>
    80003642:	97ba                	add	a5,a5,a4
    80003644:	0e07a703          	lw	a4,224(a5)
    80003648:	478d                	li	a5,3
    8000364a:	08e7c563          	blt	a5,a4,800036d4 <syscall+0x156>
        printf(" %d", p->trapframe->a3);
      if (syscall_argc[num] >= 5)
    8000364e:	00299713          	slli	a4,s3,0x2
    80003652:	00006797          	auipc	a5,0x6
    80003656:	3ee78793          	addi	a5,a5,1006 # 80009a40 <syscall_name>
    8000365a:	97ba                	add	a5,a5,a4
    8000365c:	0e07a703          	lw	a4,224(a5)
    80003660:	4791                	li	a5,4
    80003662:	08e7c463          	blt	a5,a4,800036ea <syscall+0x16c>
        printf(" %d", p->trapframe->a4);
      if (syscall_argc[num] >= 6)
    80003666:	098a                	slli	s3,s3,0x2
    80003668:	00006797          	auipc	a5,0x6
    8000366c:	3d878793          	addi	a5,a5,984 # 80009a40 <syscall_name>
    80003670:	97ce                	add	a5,a5,s3
    80003672:	0e07a703          	lw	a4,224(a5)
    80003676:	4795                	li	a5,5
    80003678:	08e7c463          	blt	a5,a4,80003700 <syscall+0x182>
        printf(" %d", p->trapframe->a5);
      printf(") -> %d\n", p->trapframe->a0);
    8000367c:	70dc                	ld	a5,160(s1)
    8000367e:	7bac                	ld	a1,112(a5)
    80003680:	00006517          	auipc	a0,0x6
    80003684:	de050513          	addi	a0,a0,-544 # 80009460 <states.0+0x170>
    80003688:	ffffd097          	auipc	ra,0xffffd
    8000368c:	f02080e7          	jalr	-254(ra) # 8000058a <printf>
    80003690:	a055                	j	80003734 <syscall+0x1b6>
        printf("(%d", first_arg);
    80003692:	000a059b          	sext.w	a1,s4
    80003696:	00006517          	auipc	a0,0x6
    8000369a:	dba50513          	addi	a0,a0,-582 # 80009450 <states.0+0x160>
    8000369e:	ffffd097          	auipc	ra,0xffffd
    800036a2:	eec080e7          	jalr	-276(ra) # 8000058a <printf>
    800036a6:	b785                	j	80003606 <syscall+0x88>
        printf(" %d", p->trapframe->a1);
    800036a8:	70dc                	ld	a5,160(s1)
    800036aa:	7fac                	ld	a1,120(a5)
    800036ac:	00006517          	auipc	a0,0x6
    800036b0:	dac50513          	addi	a0,a0,-596 # 80009458 <states.0+0x168>
    800036b4:	ffffd097          	auipc	ra,0xffffd
    800036b8:	ed6080e7          	jalr	-298(ra) # 8000058a <printf>
    800036bc:	b78d                	j	8000361e <syscall+0xa0>
        printf(" %d", p->trapframe->a2);
    800036be:	70dc                	ld	a5,160(s1)
    800036c0:	63cc                	ld	a1,128(a5)
    800036c2:	00006517          	auipc	a0,0x6
    800036c6:	d9650513          	addi	a0,a0,-618 # 80009458 <states.0+0x168>
    800036ca:	ffffd097          	auipc	ra,0xffffd
    800036ce:	ec0080e7          	jalr	-320(ra) # 8000058a <printf>
    800036d2:	b795                	j	80003636 <syscall+0xb8>
        printf(" %d", p->trapframe->a3);
    800036d4:	70dc                	ld	a5,160(s1)
    800036d6:	67cc                	ld	a1,136(a5)
    800036d8:	00006517          	auipc	a0,0x6
    800036dc:	d8050513          	addi	a0,a0,-640 # 80009458 <states.0+0x168>
    800036e0:	ffffd097          	auipc	ra,0xffffd
    800036e4:	eaa080e7          	jalr	-342(ra) # 8000058a <printf>
    800036e8:	b79d                	j	8000364e <syscall+0xd0>
        printf(" %d", p->trapframe->a4);
    800036ea:	70dc                	ld	a5,160(s1)
    800036ec:	6bcc                	ld	a1,144(a5)
    800036ee:	00006517          	auipc	a0,0x6
    800036f2:	d6a50513          	addi	a0,a0,-662 # 80009458 <states.0+0x168>
    800036f6:	ffffd097          	auipc	ra,0xffffd
    800036fa:	e94080e7          	jalr	-364(ra) # 8000058a <printf>
    800036fe:	b7a5                	j	80003666 <syscall+0xe8>
        printf(" %d", p->trapframe->a5);
    80003700:	70dc                	ld	a5,160(s1)
    80003702:	6fcc                	ld	a1,152(a5)
    80003704:	00006517          	auipc	a0,0x6
    80003708:	d5450513          	addi	a0,a0,-684 # 80009458 <states.0+0x168>
    8000370c:	ffffd097          	auipc	ra,0xffffd
    80003710:	e7e080e7          	jalr	-386(ra) # 8000058a <printf>
    80003714:	b7a5                	j	8000367c <syscall+0xfe>
    }
  }
  else
  {
    printf("%d %s: unknown sys call %d\n",
    80003716:	86ce                	mv	a3,s3
    80003718:	1a048613          	addi	a2,s1,416
    8000371c:	588c                	lw	a1,48(s1)
    8000371e:	00006517          	auipc	a0,0x6
    80003722:	d5250513          	addi	a0,a0,-686 # 80009470 <states.0+0x180>
    80003726:	ffffd097          	auipc	ra,0xffffd
    8000372a:	e64080e7          	jalr	-412(ra) # 8000058a <printf>
           p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000372e:	70dc                	ld	a5,160(s1)
    80003730:	577d                	li	a4,-1
    80003732:	fbb8                	sd	a4,112(a5)
  }
    80003734:	70a2                	ld	ra,40(sp)
    80003736:	7402                	ld	s0,32(sp)
    80003738:	64e2                	ld	s1,24(sp)
    8000373a:	6942                	ld	s2,16(sp)
    8000373c:	69a2                	ld	s3,8(sp)
    8000373e:	6a02                	ld	s4,0(sp)
    80003740:	6145                	addi	sp,sp,48
    80003742:	8082                	ret

0000000080003744 <sys_exit>:
#include "syscall.h"
// #include "user/user.h"
extern int waitx(uint64 addr, uint *runTime, uint *wtime);
uint64
sys_exit(void)
{
    80003744:	1101                	addi	sp,sp,-32
    80003746:	ec06                	sd	ra,24(sp)
    80003748:	e822                	sd	s0,16(sp)
    8000374a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000374c:	fec40593          	addi	a1,s0,-20
    80003750:	4501                	li	a0,0
    80003752:	00000097          	auipc	ra,0x0
    80003756:	db4080e7          	jalr	-588(ra) # 80003506 <argint>
  exit(n);
    8000375a:	fec42503          	lw	a0,-20(s0)
    8000375e:	fffff097          	auipc	ra,0xfffff
    80003762:	496080e7          	jalr	1174(ra) # 80002bf4 <exit>
  return 0; // not reached
}
    80003766:	4501                	li	a0,0
    80003768:	60e2                	ld	ra,24(sp)
    8000376a:	6442                	ld	s0,16(sp)
    8000376c:	6105                	addi	sp,sp,32
    8000376e:	8082                	ret

0000000080003770 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003770:	1141                	addi	sp,sp,-16
    80003772:	e406                	sd	ra,8(sp)
    80003774:	e022                	sd	s0,0(sp)
    80003776:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003778:	ffffe097          	auipc	ra,0xffffe
    8000377c:	398080e7          	jalr	920(ra) # 80001b10 <myproc>
}
    80003780:	5908                	lw	a0,48(a0)
    80003782:	60a2                	ld	ra,8(sp)
    80003784:	6402                	ld	s0,0(sp)
    80003786:	0141                	addi	sp,sp,16
    80003788:	8082                	ret

000000008000378a <sys_fork>:

uint64
sys_fork(void)
{
    8000378a:	1141                	addi	sp,sp,-16
    8000378c:	e406                	sd	ra,8(sp)
    8000378e:	e022                	sd	s0,0(sp)
    80003790:	0800                	addi	s0,sp,16
  return fork();
    80003792:	ffffe097          	auipc	ra,0xffffe
    80003796:	7c0080e7          	jalr	1984(ra) # 80001f52 <fork>
}
    8000379a:	60a2                	ld	ra,8(sp)
    8000379c:	6402                	ld	s0,0(sp)
    8000379e:	0141                	addi	sp,sp,16
    800037a0:	8082                	ret

00000000800037a2 <sys_wait>:

uint64
sys_wait(void)
{
    800037a2:	1101                	addi	sp,sp,-32
    800037a4:	ec06                	sd	ra,24(sp)
    800037a6:	e822                	sd	s0,16(sp)
    800037a8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800037aa:	fe840593          	addi	a1,s0,-24
    800037ae:	4501                	li	a0,0
    800037b0:	00000097          	auipc	ra,0x0
    800037b4:	d76080e7          	jalr	-650(ra) # 80003526 <argaddr>
  return wait(p);
    800037b8:	fe843503          	ld	a0,-24(s0)
    800037bc:	fffff097          	auipc	ra,0xfffff
    800037c0:	f9c080e7          	jalr	-100(ra) # 80002758 <wait>
}
    800037c4:	60e2                	ld	ra,24(sp)
    800037c6:	6442                	ld	s0,16(sp)
    800037c8:	6105                	addi	sp,sp,32
    800037ca:	8082                	ret

00000000800037cc <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800037cc:	7179                	addi	sp,sp,-48
    800037ce:	f406                	sd	ra,40(sp)
    800037d0:	f022                	sd	s0,32(sp)
    800037d2:	ec26                	sd	s1,24(sp)
    800037d4:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800037d6:	fdc40593          	addi	a1,s0,-36
    800037da:	4501                	li	a0,0
    800037dc:	00000097          	auipc	ra,0x0
    800037e0:	d2a080e7          	jalr	-726(ra) # 80003506 <argint>
  addr = myproc()->sz;
    800037e4:	ffffe097          	auipc	ra,0xffffe
    800037e8:	32c080e7          	jalr	812(ra) # 80001b10 <myproc>
    800037ec:	6944                	ld	s1,144(a0)
  if (growproc(n) < 0)
    800037ee:	fdc42503          	lw	a0,-36(s0)
    800037f2:	ffffe097          	auipc	ra,0xffffe
    800037f6:	704080e7          	jalr	1796(ra) # 80001ef6 <growproc>
    800037fa:	00054863          	bltz	a0,8000380a <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800037fe:	8526                	mv	a0,s1
    80003800:	70a2                	ld	ra,40(sp)
    80003802:	7402                	ld	s0,32(sp)
    80003804:	64e2                	ld	s1,24(sp)
    80003806:	6145                	addi	sp,sp,48
    80003808:	8082                	ret
    return -1;
    8000380a:	54fd                	li	s1,-1
    8000380c:	bfcd                	j	800037fe <sys_sbrk+0x32>

000000008000380e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000380e:	7139                	addi	sp,sp,-64
    80003810:	fc06                	sd	ra,56(sp)
    80003812:	f822                	sd	s0,48(sp)
    80003814:	f426                	sd	s1,40(sp)
    80003816:	f04a                	sd	s2,32(sp)
    80003818:	ec4e                	sd	s3,24(sp)
    8000381a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000381c:	fcc40593          	addi	a1,s0,-52
    80003820:	4501                	li	a0,0
    80003822:	00000097          	auipc	ra,0x0
    80003826:	ce4080e7          	jalr	-796(ra) # 80003506 <argint>
  acquire(&tickslock);
    8000382a:	00237517          	auipc	a0,0x237
    8000382e:	ebe50513          	addi	a0,a0,-322 # 8023a6e8 <tickslock>
    80003832:	ffffd097          	auipc	ra,0xffffd
    80003836:	4c2080e7          	jalr	1218(ra) # 80000cf4 <acquire>
  ticks0 = ticks;
    8000383a:	00006917          	auipc	s2,0x6
    8000383e:	3a692903          	lw	s2,934(s2) # 80009be0 <ticks>
  while (ticks - ticks0 < n)
    80003842:	fcc42783          	lw	a5,-52(s0)
    80003846:	cf9d                	beqz	a5,80003884 <sys_sleep+0x76>
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003848:	00237997          	auipc	s3,0x237
    8000384c:	ea098993          	addi	s3,s3,-352 # 8023a6e8 <tickslock>
    80003850:	00006497          	auipc	s1,0x6
    80003854:	39048493          	addi	s1,s1,912 # 80009be0 <ticks>
    if (killed(myproc()))
    80003858:	ffffe097          	auipc	ra,0xffffe
    8000385c:	2b8080e7          	jalr	696(ra) # 80001b10 <myproc>
    80003860:	fffff097          	auipc	ra,0xfffff
    80003864:	ec6080e7          	jalr	-314(ra) # 80002726 <killed>
    80003868:	ed15                	bnez	a0,800038a4 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    8000386a:	85ce                	mv	a1,s3
    8000386c:	8526                	mv	a0,s1
    8000386e:	fffff097          	auipc	ra,0xfffff
    80003872:	c36080e7          	jalr	-970(ra) # 800024a4 <sleep>
  while (ticks - ticks0 < n)
    80003876:	409c                	lw	a5,0(s1)
    80003878:	412787bb          	subw	a5,a5,s2
    8000387c:	fcc42703          	lw	a4,-52(s0)
    80003880:	fce7ece3          	bltu	a5,a4,80003858 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80003884:	00237517          	auipc	a0,0x237
    80003888:	e6450513          	addi	a0,a0,-412 # 8023a6e8 <tickslock>
    8000388c:	ffffd097          	auipc	ra,0xffffd
    80003890:	51c080e7          	jalr	1308(ra) # 80000da8 <release>
  return 0;
    80003894:	4501                	li	a0,0
}
    80003896:	70e2                	ld	ra,56(sp)
    80003898:	7442                	ld	s0,48(sp)
    8000389a:	74a2                	ld	s1,40(sp)
    8000389c:	7902                	ld	s2,32(sp)
    8000389e:	69e2                	ld	s3,24(sp)
    800038a0:	6121                	addi	sp,sp,64
    800038a2:	8082                	ret
      release(&tickslock);
    800038a4:	00237517          	auipc	a0,0x237
    800038a8:	e4450513          	addi	a0,a0,-444 # 8023a6e8 <tickslock>
    800038ac:	ffffd097          	auipc	ra,0xffffd
    800038b0:	4fc080e7          	jalr	1276(ra) # 80000da8 <release>
      return -1;
    800038b4:	557d                	li	a0,-1
    800038b6:	b7c5                	j	80003896 <sys_sleep+0x88>

00000000800038b8 <sys_kill>:

uint64
sys_kill(void)
{
    800038b8:	1101                	addi	sp,sp,-32
    800038ba:	ec06                	sd	ra,24(sp)
    800038bc:	e822                	sd	s0,16(sp)
    800038be:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800038c0:	fec40593          	addi	a1,s0,-20
    800038c4:	4501                	li	a0,0
    800038c6:	00000097          	auipc	ra,0x0
    800038ca:	c40080e7          	jalr	-960(ra) # 80003506 <argint>
  return kill(pid);
    800038ce:	fec42503          	lw	a0,-20(s0)
    800038d2:	fffff097          	auipc	ra,0xfffff
    800038d6:	db6080e7          	jalr	-586(ra) # 80002688 <kill>
}
    800038da:	60e2                	ld	ra,24(sp)
    800038dc:	6442                	ld	s0,16(sp)
    800038de:	6105                	addi	sp,sp,32
    800038e0:	8082                	ret

00000000800038e2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800038e2:	1101                	addi	sp,sp,-32
    800038e4:	ec06                	sd	ra,24(sp)
    800038e6:	e822                	sd	s0,16(sp)
    800038e8:	e426                	sd	s1,8(sp)
    800038ea:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800038ec:	00237517          	auipc	a0,0x237
    800038f0:	dfc50513          	addi	a0,a0,-516 # 8023a6e8 <tickslock>
    800038f4:	ffffd097          	auipc	ra,0xffffd
    800038f8:	400080e7          	jalr	1024(ra) # 80000cf4 <acquire>
  xticks = ticks;
    800038fc:	00006497          	auipc	s1,0x6
    80003900:	2e44a483          	lw	s1,740(s1) # 80009be0 <ticks>
  release(&tickslock);
    80003904:	00237517          	auipc	a0,0x237
    80003908:	de450513          	addi	a0,a0,-540 # 8023a6e8 <tickslock>
    8000390c:	ffffd097          	auipc	ra,0xffffd
    80003910:	49c080e7          	jalr	1180(ra) # 80000da8 <release>
  return xticks;
}
    80003914:	02049513          	slli	a0,s1,0x20
    80003918:	9101                	srli	a0,a0,0x20
    8000391a:	60e2                	ld	ra,24(sp)
    8000391c:	6442                	ld	s0,16(sp)
    8000391e:	64a2                	ld	s1,8(sp)
    80003920:	6105                	addi	sp,sp,32
    80003922:	8082                	ret

0000000080003924 <sys_trace>:
uint64
sys_trace(void)
{
    80003924:	1101                	addi	sp,sp,-32
    80003926:	ec06                	sd	ra,24(sp)
    80003928:	e822                	sd	s0,16(sp)
    8000392a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000392c:	fec40593          	addi	a1,s0,-20
    80003930:	4501                	li	a0,0
    80003932:	00000097          	auipc	ra,0x0
    80003936:	bd4080e7          	jalr	-1068(ra) # 80003506 <argint>
  myproc()->tracemask = n;
    8000393a:	ffffe097          	auipc	ra,0xffffe
    8000393e:	1d6080e7          	jalr	470(ra) # 80001b10 <myproc>
    80003942:	fec42783          	lw	a5,-20(s0)
    80003946:	d13c                	sw	a5,96(a0)
  return 0;
}
    80003948:	4501                	li	a0,0
    8000394a:	60e2                	ld	ra,24(sp)
    8000394c:	6442                	ld	s0,16(sp)
    8000394e:	6105                	addi	sp,sp,32
    80003950:	8082                	ret

0000000080003952 <sys_sigalarm>:
uint64 sys_sigalarm(void)
{
    80003952:	1101                	addi	sp,sp,-32
    80003954:	ec06                	sd	ra,24(sp)
    80003956:	e822                	sd	s0,16(sp)
    80003958:	1000                	addi	s0,sp,32
  int ticks;
  argint(0, &ticks);
    8000395a:	fec40593          	addi	a1,s0,-20
    8000395e:	4501                	li	a0,0
    80003960:	00000097          	auipc	ra,0x0
    80003964:	ba6080e7          	jalr	-1114(ra) # 80003506 <argint>
  uint64 handler;
  argaddr(1, &handler);
    80003968:	fe040593          	addi	a1,s0,-32
    8000396c:	4505                	li	a0,1
    8000396e:	00000097          	auipc	ra,0x0
    80003972:	bb8080e7          	jalr	-1096(ra) # 80003526 <argaddr>
  myproc()->is_sigalarm = 0;
    80003976:	ffffe097          	auipc	ra,0xffffe
    8000397a:	19a080e7          	jalr	410(ra) # 80001b10 <myproc>
    8000397e:	04052023          	sw	zero,64(a0)
  myproc()->ticks = ticks;
    80003982:	ffffe097          	auipc	ra,0xffffe
    80003986:	18e080e7          	jalr	398(ra) # 80001b10 <myproc>
    8000398a:	fec42783          	lw	a5,-20(s0)
    8000398e:	c17c                	sw	a5,68(a0)
  myproc()->now_ticks = 0;
    80003990:	ffffe097          	auipc	ra,0xffffe
    80003994:	180080e7          	jalr	384(ra) # 80001b10 <myproc>
    80003998:	04052423          	sw	zero,72(a0)
  myproc()->handler = handler;
    8000399c:	ffffe097          	auipc	ra,0xffffe
    800039a0:	174080e7          	jalr	372(ra) # 80001b10 <myproc>
    800039a4:	fe043783          	ld	a5,-32(s0)
    800039a8:	e93c                	sd	a5,80(a0)
  return 0;
}
    800039aa:	4501                	li	a0,0
    800039ac:	60e2                	ld	ra,24(sp)
    800039ae:	6442                	ld	s0,16(sp)
    800039b0:	6105                	addi	sp,sp,32
    800039b2:	8082                	ret

00000000800039b4 <sys_waitx>:
uint64
sys_waitx(void)
{
    800039b4:	7139                	addi	sp,sp,-64
    800039b6:	fc06                	sd	ra,56(sp)
    800039b8:	f822                	sd	s0,48(sp)
    800039ba:	f426                	sd	s1,40(sp)
    800039bc:	f04a                	sd	s2,32(sp)
    800039be:	0080                	addi	s0,sp,64
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
    800039c0:	fd840593          	addi	a1,s0,-40
    800039c4:	4501                	li	a0,0
    800039c6:	00000097          	auipc	ra,0x0
    800039ca:	b60080e7          	jalr	-1184(ra) # 80003526 <argaddr>
  argaddr(1, &addr1);
    800039ce:	fd040593          	addi	a1,s0,-48
    800039d2:	4505                	li	a0,1
    800039d4:	00000097          	auipc	ra,0x0
    800039d8:	b52080e7          	jalr	-1198(ra) # 80003526 <argaddr>
  argaddr(2, &addr2);
    800039dc:	fc840593          	addi	a1,s0,-56
    800039e0:	4509                	li	a0,2
    800039e2:	00000097          	auipc	ra,0x0
    800039e6:	b44080e7          	jalr	-1212(ra) # 80003526 <argaddr>
  int ret = waitx(addr, &wtime, &rtime);
    800039ea:	fc040613          	addi	a2,s0,-64
    800039ee:	fc440593          	addi	a1,s0,-60
    800039f2:	fd843503          	ld	a0,-40(s0)
    800039f6:	fffff097          	auipc	ra,0xfffff
    800039fa:	034080e7          	jalr	52(ra) # 80002a2a <waitx>
    800039fe:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80003a00:	ffffe097          	auipc	ra,0xffffe
    80003a04:	110080e7          	jalr	272(ra) # 80001b10 <myproc>
    80003a08:	84aa                	mv	s1,a0
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    80003a0a:	4691                	li	a3,4
    80003a0c:	fc440613          	addi	a2,s0,-60
    80003a10:	fd043583          	ld	a1,-48(s0)
    80003a14:	6d48                	ld	a0,152(a0)
    80003a16:	ffffe097          	auipc	ra,0xffffe
    80003a1a:	d82080e7          	jalr	-638(ra) # 80001798 <copyout>
    return -1;
    80003a1e:	57fd                	li	a5,-1
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    80003a20:	00054f63          	bltz	a0,80003a3e <sys_waitx+0x8a>
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    80003a24:	4691                	li	a3,4
    80003a26:	fc040613          	addi	a2,s0,-64
    80003a2a:	fc843583          	ld	a1,-56(s0)
    80003a2e:	6cc8                	ld	a0,152(s1)
    80003a30:	ffffe097          	auipc	ra,0xffffe
    80003a34:	d68080e7          	jalr	-664(ra) # 80001798 <copyout>
    80003a38:	00054a63          	bltz	a0,80003a4c <sys_waitx+0x98>
    return -1;
  return ret;
    80003a3c:	87ca                	mv	a5,s2
}
    80003a3e:	853e                	mv	a0,a5
    80003a40:	70e2                	ld	ra,56(sp)
    80003a42:	7442                	ld	s0,48(sp)
    80003a44:	74a2                	ld	s1,40(sp)
    80003a46:	7902                	ld	s2,32(sp)
    80003a48:	6121                	addi	sp,sp,64
    80003a4a:	8082                	ret
    return -1;
    80003a4c:	57fd                	li	a5,-1
    80003a4e:	bfc5                	j	80003a3e <sys_waitx+0x8a>

0000000080003a50 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003a50:	7179                	addi	sp,sp,-48
    80003a52:	f406                	sd	ra,40(sp)
    80003a54:	f022                	sd	s0,32(sp)
    80003a56:	ec26                	sd	s1,24(sp)
    80003a58:	e84a                	sd	s2,16(sp)
    80003a5a:	e44e                	sd	s3,8(sp)
    80003a5c:	e052                	sd	s4,0(sp)
    80003a5e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003a60:	00006597          	auipc	a1,0x6
    80003a64:	c1858593          	addi	a1,a1,-1000 # 80009678 <syscalls+0xe0>
    80003a68:	00237517          	auipc	a0,0x237
    80003a6c:	c9850513          	addi	a0,a0,-872 # 8023a700 <bcache>
    80003a70:	ffffd097          	auipc	ra,0xffffd
    80003a74:	1f4080e7          	jalr	500(ra) # 80000c64 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003a78:	0023f797          	auipc	a5,0x23f
    80003a7c:	c8878793          	addi	a5,a5,-888 # 80242700 <bcache+0x8000>
    80003a80:	0023f717          	auipc	a4,0x23f
    80003a84:	ee870713          	addi	a4,a4,-280 # 80242968 <bcache+0x8268>
    80003a88:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003a8c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003a90:	00237497          	auipc	s1,0x237
    80003a94:	c8848493          	addi	s1,s1,-888 # 8023a718 <bcache+0x18>
    b->next = bcache.head.next;
    80003a98:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003a9a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003a9c:	00006a17          	auipc	s4,0x6
    80003aa0:	be4a0a13          	addi	s4,s4,-1052 # 80009680 <syscalls+0xe8>
    b->next = bcache.head.next;
    80003aa4:	2b893783          	ld	a5,696(s2)
    80003aa8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003aaa:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003aae:	85d2                	mv	a1,s4
    80003ab0:	01048513          	addi	a0,s1,16
    80003ab4:	00001097          	auipc	ra,0x1
    80003ab8:	4c8080e7          	jalr	1224(ra) # 80004f7c <initsleeplock>
    bcache.head.next->prev = b;
    80003abc:	2b893783          	ld	a5,696(s2)
    80003ac0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003ac2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003ac6:	45848493          	addi	s1,s1,1112
    80003aca:	fd349de3          	bne	s1,s3,80003aa4 <binit+0x54>
  }
}
    80003ace:	70a2                	ld	ra,40(sp)
    80003ad0:	7402                	ld	s0,32(sp)
    80003ad2:	64e2                	ld	s1,24(sp)
    80003ad4:	6942                	ld	s2,16(sp)
    80003ad6:	69a2                	ld	s3,8(sp)
    80003ad8:	6a02                	ld	s4,0(sp)
    80003ada:	6145                	addi	sp,sp,48
    80003adc:	8082                	ret

0000000080003ade <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003ade:	7179                	addi	sp,sp,-48
    80003ae0:	f406                	sd	ra,40(sp)
    80003ae2:	f022                	sd	s0,32(sp)
    80003ae4:	ec26                	sd	s1,24(sp)
    80003ae6:	e84a                	sd	s2,16(sp)
    80003ae8:	e44e                	sd	s3,8(sp)
    80003aea:	1800                	addi	s0,sp,48
    80003aec:	892a                	mv	s2,a0
    80003aee:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003af0:	00237517          	auipc	a0,0x237
    80003af4:	c1050513          	addi	a0,a0,-1008 # 8023a700 <bcache>
    80003af8:	ffffd097          	auipc	ra,0xffffd
    80003afc:	1fc080e7          	jalr	508(ra) # 80000cf4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003b00:	0023f497          	auipc	s1,0x23f
    80003b04:	eb84b483          	ld	s1,-328(s1) # 802429b8 <bcache+0x82b8>
    80003b08:	0023f797          	auipc	a5,0x23f
    80003b0c:	e6078793          	addi	a5,a5,-416 # 80242968 <bcache+0x8268>
    80003b10:	02f48f63          	beq	s1,a5,80003b4e <bread+0x70>
    80003b14:	873e                	mv	a4,a5
    80003b16:	a021                	j	80003b1e <bread+0x40>
    80003b18:	68a4                	ld	s1,80(s1)
    80003b1a:	02e48a63          	beq	s1,a4,80003b4e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003b1e:	449c                	lw	a5,8(s1)
    80003b20:	ff279ce3          	bne	a5,s2,80003b18 <bread+0x3a>
    80003b24:	44dc                	lw	a5,12(s1)
    80003b26:	ff3799e3          	bne	a5,s3,80003b18 <bread+0x3a>
      b->refcnt++;
    80003b2a:	40bc                	lw	a5,64(s1)
    80003b2c:	2785                	addiw	a5,a5,1
    80003b2e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003b30:	00237517          	auipc	a0,0x237
    80003b34:	bd050513          	addi	a0,a0,-1072 # 8023a700 <bcache>
    80003b38:	ffffd097          	auipc	ra,0xffffd
    80003b3c:	270080e7          	jalr	624(ra) # 80000da8 <release>
      acquiresleep(&b->lock);
    80003b40:	01048513          	addi	a0,s1,16
    80003b44:	00001097          	auipc	ra,0x1
    80003b48:	472080e7          	jalr	1138(ra) # 80004fb6 <acquiresleep>
      return b;
    80003b4c:	a8b9                	j	80003baa <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003b4e:	0023f497          	auipc	s1,0x23f
    80003b52:	e624b483          	ld	s1,-414(s1) # 802429b0 <bcache+0x82b0>
    80003b56:	0023f797          	auipc	a5,0x23f
    80003b5a:	e1278793          	addi	a5,a5,-494 # 80242968 <bcache+0x8268>
    80003b5e:	00f48863          	beq	s1,a5,80003b6e <bread+0x90>
    80003b62:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003b64:	40bc                	lw	a5,64(s1)
    80003b66:	cf81                	beqz	a5,80003b7e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003b68:	64a4                	ld	s1,72(s1)
    80003b6a:	fee49de3          	bne	s1,a4,80003b64 <bread+0x86>
  panic("bget: no buffers");
    80003b6e:	00006517          	auipc	a0,0x6
    80003b72:	b1a50513          	addi	a0,a0,-1254 # 80009688 <syscalls+0xf0>
    80003b76:	ffffd097          	auipc	ra,0xffffd
    80003b7a:	9ca080e7          	jalr	-1590(ra) # 80000540 <panic>
      b->dev = dev;
    80003b7e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003b82:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003b86:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003b8a:	4785                	li	a5,1
    80003b8c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003b8e:	00237517          	auipc	a0,0x237
    80003b92:	b7250513          	addi	a0,a0,-1166 # 8023a700 <bcache>
    80003b96:	ffffd097          	auipc	ra,0xffffd
    80003b9a:	212080e7          	jalr	530(ra) # 80000da8 <release>
      acquiresleep(&b->lock);
    80003b9e:	01048513          	addi	a0,s1,16
    80003ba2:	00001097          	auipc	ra,0x1
    80003ba6:	414080e7          	jalr	1044(ra) # 80004fb6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003baa:	409c                	lw	a5,0(s1)
    80003bac:	cb89                	beqz	a5,80003bbe <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003bae:	8526                	mv	a0,s1
    80003bb0:	70a2                	ld	ra,40(sp)
    80003bb2:	7402                	ld	s0,32(sp)
    80003bb4:	64e2                	ld	s1,24(sp)
    80003bb6:	6942                	ld	s2,16(sp)
    80003bb8:	69a2                	ld	s3,8(sp)
    80003bba:	6145                	addi	sp,sp,48
    80003bbc:	8082                	ret
    virtio_disk_rw(b, 0);
    80003bbe:	4581                	li	a1,0
    80003bc0:	8526                	mv	a0,s1
    80003bc2:	00003097          	auipc	ra,0x3
    80003bc6:	2e6080e7          	jalr	742(ra) # 80006ea8 <virtio_disk_rw>
    b->valid = 1;
    80003bca:	4785                	li	a5,1
    80003bcc:	c09c                	sw	a5,0(s1)
  return b;
    80003bce:	b7c5                	j	80003bae <bread+0xd0>

0000000080003bd0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003bd0:	1101                	addi	sp,sp,-32
    80003bd2:	ec06                	sd	ra,24(sp)
    80003bd4:	e822                	sd	s0,16(sp)
    80003bd6:	e426                	sd	s1,8(sp)
    80003bd8:	1000                	addi	s0,sp,32
    80003bda:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003bdc:	0541                	addi	a0,a0,16
    80003bde:	00001097          	auipc	ra,0x1
    80003be2:	472080e7          	jalr	1138(ra) # 80005050 <holdingsleep>
    80003be6:	cd01                	beqz	a0,80003bfe <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003be8:	4585                	li	a1,1
    80003bea:	8526                	mv	a0,s1
    80003bec:	00003097          	auipc	ra,0x3
    80003bf0:	2bc080e7          	jalr	700(ra) # 80006ea8 <virtio_disk_rw>
}
    80003bf4:	60e2                	ld	ra,24(sp)
    80003bf6:	6442                	ld	s0,16(sp)
    80003bf8:	64a2                	ld	s1,8(sp)
    80003bfa:	6105                	addi	sp,sp,32
    80003bfc:	8082                	ret
    panic("bwrite");
    80003bfe:	00006517          	auipc	a0,0x6
    80003c02:	aa250513          	addi	a0,a0,-1374 # 800096a0 <syscalls+0x108>
    80003c06:	ffffd097          	auipc	ra,0xffffd
    80003c0a:	93a080e7          	jalr	-1734(ra) # 80000540 <panic>

0000000080003c0e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003c0e:	1101                	addi	sp,sp,-32
    80003c10:	ec06                	sd	ra,24(sp)
    80003c12:	e822                	sd	s0,16(sp)
    80003c14:	e426                	sd	s1,8(sp)
    80003c16:	e04a                	sd	s2,0(sp)
    80003c18:	1000                	addi	s0,sp,32
    80003c1a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003c1c:	01050913          	addi	s2,a0,16
    80003c20:	854a                	mv	a0,s2
    80003c22:	00001097          	auipc	ra,0x1
    80003c26:	42e080e7          	jalr	1070(ra) # 80005050 <holdingsleep>
    80003c2a:	c92d                	beqz	a0,80003c9c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003c2c:	854a                	mv	a0,s2
    80003c2e:	00001097          	auipc	ra,0x1
    80003c32:	3de080e7          	jalr	990(ra) # 8000500c <releasesleep>

  acquire(&bcache.lock);
    80003c36:	00237517          	auipc	a0,0x237
    80003c3a:	aca50513          	addi	a0,a0,-1334 # 8023a700 <bcache>
    80003c3e:	ffffd097          	auipc	ra,0xffffd
    80003c42:	0b6080e7          	jalr	182(ra) # 80000cf4 <acquire>
  b->refcnt--;
    80003c46:	40bc                	lw	a5,64(s1)
    80003c48:	37fd                	addiw	a5,a5,-1
    80003c4a:	0007871b          	sext.w	a4,a5
    80003c4e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003c50:	eb05                	bnez	a4,80003c80 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003c52:	68bc                	ld	a5,80(s1)
    80003c54:	64b8                	ld	a4,72(s1)
    80003c56:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003c58:	64bc                	ld	a5,72(s1)
    80003c5a:	68b8                	ld	a4,80(s1)
    80003c5c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003c5e:	0023f797          	auipc	a5,0x23f
    80003c62:	aa278793          	addi	a5,a5,-1374 # 80242700 <bcache+0x8000>
    80003c66:	2b87b703          	ld	a4,696(a5)
    80003c6a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003c6c:	0023f717          	auipc	a4,0x23f
    80003c70:	cfc70713          	addi	a4,a4,-772 # 80242968 <bcache+0x8268>
    80003c74:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003c76:	2b87b703          	ld	a4,696(a5)
    80003c7a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003c7c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003c80:	00237517          	auipc	a0,0x237
    80003c84:	a8050513          	addi	a0,a0,-1408 # 8023a700 <bcache>
    80003c88:	ffffd097          	auipc	ra,0xffffd
    80003c8c:	120080e7          	jalr	288(ra) # 80000da8 <release>
}
    80003c90:	60e2                	ld	ra,24(sp)
    80003c92:	6442                	ld	s0,16(sp)
    80003c94:	64a2                	ld	s1,8(sp)
    80003c96:	6902                	ld	s2,0(sp)
    80003c98:	6105                	addi	sp,sp,32
    80003c9a:	8082                	ret
    panic("brelse");
    80003c9c:	00006517          	auipc	a0,0x6
    80003ca0:	a0c50513          	addi	a0,a0,-1524 # 800096a8 <syscalls+0x110>
    80003ca4:	ffffd097          	auipc	ra,0xffffd
    80003ca8:	89c080e7          	jalr	-1892(ra) # 80000540 <panic>

0000000080003cac <bpin>:

void
bpin(struct buf *b) {
    80003cac:	1101                	addi	sp,sp,-32
    80003cae:	ec06                	sd	ra,24(sp)
    80003cb0:	e822                	sd	s0,16(sp)
    80003cb2:	e426                	sd	s1,8(sp)
    80003cb4:	1000                	addi	s0,sp,32
    80003cb6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003cb8:	00237517          	auipc	a0,0x237
    80003cbc:	a4850513          	addi	a0,a0,-1464 # 8023a700 <bcache>
    80003cc0:	ffffd097          	auipc	ra,0xffffd
    80003cc4:	034080e7          	jalr	52(ra) # 80000cf4 <acquire>
  b->refcnt++;
    80003cc8:	40bc                	lw	a5,64(s1)
    80003cca:	2785                	addiw	a5,a5,1
    80003ccc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003cce:	00237517          	auipc	a0,0x237
    80003cd2:	a3250513          	addi	a0,a0,-1486 # 8023a700 <bcache>
    80003cd6:	ffffd097          	auipc	ra,0xffffd
    80003cda:	0d2080e7          	jalr	210(ra) # 80000da8 <release>
}
    80003cde:	60e2                	ld	ra,24(sp)
    80003ce0:	6442                	ld	s0,16(sp)
    80003ce2:	64a2                	ld	s1,8(sp)
    80003ce4:	6105                	addi	sp,sp,32
    80003ce6:	8082                	ret

0000000080003ce8 <bunpin>:

void
bunpin(struct buf *b) {
    80003ce8:	1101                	addi	sp,sp,-32
    80003cea:	ec06                	sd	ra,24(sp)
    80003cec:	e822                	sd	s0,16(sp)
    80003cee:	e426                	sd	s1,8(sp)
    80003cf0:	1000                	addi	s0,sp,32
    80003cf2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003cf4:	00237517          	auipc	a0,0x237
    80003cf8:	a0c50513          	addi	a0,a0,-1524 # 8023a700 <bcache>
    80003cfc:	ffffd097          	auipc	ra,0xffffd
    80003d00:	ff8080e7          	jalr	-8(ra) # 80000cf4 <acquire>
  b->refcnt--;
    80003d04:	40bc                	lw	a5,64(s1)
    80003d06:	37fd                	addiw	a5,a5,-1
    80003d08:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003d0a:	00237517          	auipc	a0,0x237
    80003d0e:	9f650513          	addi	a0,a0,-1546 # 8023a700 <bcache>
    80003d12:	ffffd097          	auipc	ra,0xffffd
    80003d16:	096080e7          	jalr	150(ra) # 80000da8 <release>
}
    80003d1a:	60e2                	ld	ra,24(sp)
    80003d1c:	6442                	ld	s0,16(sp)
    80003d1e:	64a2                	ld	s1,8(sp)
    80003d20:	6105                	addi	sp,sp,32
    80003d22:	8082                	ret

0000000080003d24 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003d24:	1101                	addi	sp,sp,-32
    80003d26:	ec06                	sd	ra,24(sp)
    80003d28:	e822                	sd	s0,16(sp)
    80003d2a:	e426                	sd	s1,8(sp)
    80003d2c:	e04a                	sd	s2,0(sp)
    80003d2e:	1000                	addi	s0,sp,32
    80003d30:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003d32:	00d5d59b          	srliw	a1,a1,0xd
    80003d36:	0023f797          	auipc	a5,0x23f
    80003d3a:	0a67a783          	lw	a5,166(a5) # 80242ddc <sb+0x1c>
    80003d3e:	9dbd                	addw	a1,a1,a5
    80003d40:	00000097          	auipc	ra,0x0
    80003d44:	d9e080e7          	jalr	-610(ra) # 80003ade <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003d48:	0074f713          	andi	a4,s1,7
    80003d4c:	4785                	li	a5,1
    80003d4e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003d52:	14ce                	slli	s1,s1,0x33
    80003d54:	90d9                	srli	s1,s1,0x36
    80003d56:	00950733          	add	a4,a0,s1
    80003d5a:	05874703          	lbu	a4,88(a4)
    80003d5e:	00e7f6b3          	and	a3,a5,a4
    80003d62:	c69d                	beqz	a3,80003d90 <bfree+0x6c>
    80003d64:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003d66:	94aa                	add	s1,s1,a0
    80003d68:	fff7c793          	not	a5,a5
    80003d6c:	8f7d                	and	a4,a4,a5
    80003d6e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003d72:	00001097          	auipc	ra,0x1
    80003d76:	126080e7          	jalr	294(ra) # 80004e98 <log_write>
  brelse(bp);
    80003d7a:	854a                	mv	a0,s2
    80003d7c:	00000097          	auipc	ra,0x0
    80003d80:	e92080e7          	jalr	-366(ra) # 80003c0e <brelse>
}
    80003d84:	60e2                	ld	ra,24(sp)
    80003d86:	6442                	ld	s0,16(sp)
    80003d88:	64a2                	ld	s1,8(sp)
    80003d8a:	6902                	ld	s2,0(sp)
    80003d8c:	6105                	addi	sp,sp,32
    80003d8e:	8082                	ret
    panic("freeing free block");
    80003d90:	00006517          	auipc	a0,0x6
    80003d94:	92050513          	addi	a0,a0,-1760 # 800096b0 <syscalls+0x118>
    80003d98:	ffffc097          	auipc	ra,0xffffc
    80003d9c:	7a8080e7          	jalr	1960(ra) # 80000540 <panic>

0000000080003da0 <balloc>:
{
    80003da0:	711d                	addi	sp,sp,-96
    80003da2:	ec86                	sd	ra,88(sp)
    80003da4:	e8a2                	sd	s0,80(sp)
    80003da6:	e4a6                	sd	s1,72(sp)
    80003da8:	e0ca                	sd	s2,64(sp)
    80003daa:	fc4e                	sd	s3,56(sp)
    80003dac:	f852                	sd	s4,48(sp)
    80003dae:	f456                	sd	s5,40(sp)
    80003db0:	f05a                	sd	s6,32(sp)
    80003db2:	ec5e                	sd	s7,24(sp)
    80003db4:	e862                	sd	s8,16(sp)
    80003db6:	e466                	sd	s9,8(sp)
    80003db8:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003dba:	0023f797          	auipc	a5,0x23f
    80003dbe:	00a7a783          	lw	a5,10(a5) # 80242dc4 <sb+0x4>
    80003dc2:	cff5                	beqz	a5,80003ebe <balloc+0x11e>
    80003dc4:	8baa                	mv	s7,a0
    80003dc6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003dc8:	0023fb17          	auipc	s6,0x23f
    80003dcc:	ff8b0b13          	addi	s6,s6,-8 # 80242dc0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003dd0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003dd2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003dd4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003dd6:	6c89                	lui	s9,0x2
    80003dd8:	a061                	j	80003e60 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003dda:	97ca                	add	a5,a5,s2
    80003ddc:	8e55                	or	a2,a2,a3
    80003dde:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003de2:	854a                	mv	a0,s2
    80003de4:	00001097          	auipc	ra,0x1
    80003de8:	0b4080e7          	jalr	180(ra) # 80004e98 <log_write>
        brelse(bp);
    80003dec:	854a                	mv	a0,s2
    80003dee:	00000097          	auipc	ra,0x0
    80003df2:	e20080e7          	jalr	-480(ra) # 80003c0e <brelse>
  bp = bread(dev, bno);
    80003df6:	85a6                	mv	a1,s1
    80003df8:	855e                	mv	a0,s7
    80003dfa:	00000097          	auipc	ra,0x0
    80003dfe:	ce4080e7          	jalr	-796(ra) # 80003ade <bread>
    80003e02:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003e04:	40000613          	li	a2,1024
    80003e08:	4581                	li	a1,0
    80003e0a:	05850513          	addi	a0,a0,88
    80003e0e:	ffffd097          	auipc	ra,0xffffd
    80003e12:	fe2080e7          	jalr	-30(ra) # 80000df0 <memset>
  log_write(bp);
    80003e16:	854a                	mv	a0,s2
    80003e18:	00001097          	auipc	ra,0x1
    80003e1c:	080080e7          	jalr	128(ra) # 80004e98 <log_write>
  brelse(bp);
    80003e20:	854a                	mv	a0,s2
    80003e22:	00000097          	auipc	ra,0x0
    80003e26:	dec080e7          	jalr	-532(ra) # 80003c0e <brelse>
}
    80003e2a:	8526                	mv	a0,s1
    80003e2c:	60e6                	ld	ra,88(sp)
    80003e2e:	6446                	ld	s0,80(sp)
    80003e30:	64a6                	ld	s1,72(sp)
    80003e32:	6906                	ld	s2,64(sp)
    80003e34:	79e2                	ld	s3,56(sp)
    80003e36:	7a42                	ld	s4,48(sp)
    80003e38:	7aa2                	ld	s5,40(sp)
    80003e3a:	7b02                	ld	s6,32(sp)
    80003e3c:	6be2                	ld	s7,24(sp)
    80003e3e:	6c42                	ld	s8,16(sp)
    80003e40:	6ca2                	ld	s9,8(sp)
    80003e42:	6125                	addi	sp,sp,96
    80003e44:	8082                	ret
    brelse(bp);
    80003e46:	854a                	mv	a0,s2
    80003e48:	00000097          	auipc	ra,0x0
    80003e4c:	dc6080e7          	jalr	-570(ra) # 80003c0e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003e50:	015c87bb          	addw	a5,s9,s5
    80003e54:	00078a9b          	sext.w	s5,a5
    80003e58:	004b2703          	lw	a4,4(s6)
    80003e5c:	06eaf163          	bgeu	s5,a4,80003ebe <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80003e60:	41fad79b          	sraiw	a5,s5,0x1f
    80003e64:	0137d79b          	srliw	a5,a5,0x13
    80003e68:	015787bb          	addw	a5,a5,s5
    80003e6c:	40d7d79b          	sraiw	a5,a5,0xd
    80003e70:	01cb2583          	lw	a1,28(s6)
    80003e74:	9dbd                	addw	a1,a1,a5
    80003e76:	855e                	mv	a0,s7
    80003e78:	00000097          	auipc	ra,0x0
    80003e7c:	c66080e7          	jalr	-922(ra) # 80003ade <bread>
    80003e80:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003e82:	004b2503          	lw	a0,4(s6)
    80003e86:	000a849b          	sext.w	s1,s5
    80003e8a:	8762                	mv	a4,s8
    80003e8c:	faa4fde3          	bgeu	s1,a0,80003e46 <balloc+0xa6>
      m = 1 << (bi % 8);
    80003e90:	00777693          	andi	a3,a4,7
    80003e94:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003e98:	41f7579b          	sraiw	a5,a4,0x1f
    80003e9c:	01d7d79b          	srliw	a5,a5,0x1d
    80003ea0:	9fb9                	addw	a5,a5,a4
    80003ea2:	4037d79b          	sraiw	a5,a5,0x3
    80003ea6:	00f90633          	add	a2,s2,a5
    80003eaa:	05864603          	lbu	a2,88(a2)
    80003eae:	00c6f5b3          	and	a1,a3,a2
    80003eb2:	d585                	beqz	a1,80003dda <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003eb4:	2705                	addiw	a4,a4,1
    80003eb6:	2485                	addiw	s1,s1,1
    80003eb8:	fd471ae3          	bne	a4,s4,80003e8c <balloc+0xec>
    80003ebc:	b769                	j	80003e46 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80003ebe:	00006517          	auipc	a0,0x6
    80003ec2:	80a50513          	addi	a0,a0,-2038 # 800096c8 <syscalls+0x130>
    80003ec6:	ffffc097          	auipc	ra,0xffffc
    80003eca:	6c4080e7          	jalr	1732(ra) # 8000058a <printf>
  return 0;
    80003ece:	4481                	li	s1,0
    80003ed0:	bfa9                	j	80003e2a <balloc+0x8a>

0000000080003ed2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003ed2:	7179                	addi	sp,sp,-48
    80003ed4:	f406                	sd	ra,40(sp)
    80003ed6:	f022                	sd	s0,32(sp)
    80003ed8:	ec26                	sd	s1,24(sp)
    80003eda:	e84a                	sd	s2,16(sp)
    80003edc:	e44e                	sd	s3,8(sp)
    80003ede:	e052                	sd	s4,0(sp)
    80003ee0:	1800                	addi	s0,sp,48
    80003ee2:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003ee4:	47ad                	li	a5,11
    80003ee6:	02b7e863          	bltu	a5,a1,80003f16 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80003eea:	02059793          	slli	a5,a1,0x20
    80003eee:	01e7d593          	srli	a1,a5,0x1e
    80003ef2:	00b504b3          	add	s1,a0,a1
    80003ef6:	0504a903          	lw	s2,80(s1)
    80003efa:	06091e63          	bnez	s2,80003f76 <bmap+0xa4>
      addr = balloc(ip->dev);
    80003efe:	4108                	lw	a0,0(a0)
    80003f00:	00000097          	auipc	ra,0x0
    80003f04:	ea0080e7          	jalr	-352(ra) # 80003da0 <balloc>
    80003f08:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003f0c:	06090563          	beqz	s2,80003f76 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80003f10:	0524a823          	sw	s2,80(s1)
    80003f14:	a08d                	j	80003f76 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003f16:	ff45849b          	addiw	s1,a1,-12
    80003f1a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003f1e:	0ff00793          	li	a5,255
    80003f22:	08e7e563          	bltu	a5,a4,80003fac <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003f26:	08052903          	lw	s2,128(a0)
    80003f2a:	00091d63          	bnez	s2,80003f44 <bmap+0x72>
      addr = balloc(ip->dev);
    80003f2e:	4108                	lw	a0,0(a0)
    80003f30:	00000097          	auipc	ra,0x0
    80003f34:	e70080e7          	jalr	-400(ra) # 80003da0 <balloc>
    80003f38:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003f3c:	02090d63          	beqz	s2,80003f76 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003f40:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003f44:	85ca                	mv	a1,s2
    80003f46:	0009a503          	lw	a0,0(s3)
    80003f4a:	00000097          	auipc	ra,0x0
    80003f4e:	b94080e7          	jalr	-1132(ra) # 80003ade <bread>
    80003f52:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003f54:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003f58:	02049713          	slli	a4,s1,0x20
    80003f5c:	01e75593          	srli	a1,a4,0x1e
    80003f60:	00b784b3          	add	s1,a5,a1
    80003f64:	0004a903          	lw	s2,0(s1)
    80003f68:	02090063          	beqz	s2,80003f88 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003f6c:	8552                	mv	a0,s4
    80003f6e:	00000097          	auipc	ra,0x0
    80003f72:	ca0080e7          	jalr	-864(ra) # 80003c0e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003f76:	854a                	mv	a0,s2
    80003f78:	70a2                	ld	ra,40(sp)
    80003f7a:	7402                	ld	s0,32(sp)
    80003f7c:	64e2                	ld	s1,24(sp)
    80003f7e:	6942                	ld	s2,16(sp)
    80003f80:	69a2                	ld	s3,8(sp)
    80003f82:	6a02                	ld	s4,0(sp)
    80003f84:	6145                	addi	sp,sp,48
    80003f86:	8082                	ret
      addr = balloc(ip->dev);
    80003f88:	0009a503          	lw	a0,0(s3)
    80003f8c:	00000097          	auipc	ra,0x0
    80003f90:	e14080e7          	jalr	-492(ra) # 80003da0 <balloc>
    80003f94:	0005091b          	sext.w	s2,a0
      if(addr){
    80003f98:	fc090ae3          	beqz	s2,80003f6c <bmap+0x9a>
        a[bn] = addr;
    80003f9c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003fa0:	8552                	mv	a0,s4
    80003fa2:	00001097          	auipc	ra,0x1
    80003fa6:	ef6080e7          	jalr	-266(ra) # 80004e98 <log_write>
    80003faa:	b7c9                	j	80003f6c <bmap+0x9a>
  panic("bmap: out of range");
    80003fac:	00005517          	auipc	a0,0x5
    80003fb0:	73450513          	addi	a0,a0,1844 # 800096e0 <syscalls+0x148>
    80003fb4:	ffffc097          	auipc	ra,0xffffc
    80003fb8:	58c080e7          	jalr	1420(ra) # 80000540 <panic>

0000000080003fbc <iget>:
{
    80003fbc:	7179                	addi	sp,sp,-48
    80003fbe:	f406                	sd	ra,40(sp)
    80003fc0:	f022                	sd	s0,32(sp)
    80003fc2:	ec26                	sd	s1,24(sp)
    80003fc4:	e84a                	sd	s2,16(sp)
    80003fc6:	e44e                	sd	s3,8(sp)
    80003fc8:	e052                	sd	s4,0(sp)
    80003fca:	1800                	addi	s0,sp,48
    80003fcc:	89aa                	mv	s3,a0
    80003fce:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003fd0:	0023f517          	auipc	a0,0x23f
    80003fd4:	e1050513          	addi	a0,a0,-496 # 80242de0 <itable>
    80003fd8:	ffffd097          	auipc	ra,0xffffd
    80003fdc:	d1c080e7          	jalr	-740(ra) # 80000cf4 <acquire>
  empty = 0;
    80003fe0:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003fe2:	0023f497          	auipc	s1,0x23f
    80003fe6:	e1648493          	addi	s1,s1,-490 # 80242df8 <itable+0x18>
    80003fea:	00241697          	auipc	a3,0x241
    80003fee:	89e68693          	addi	a3,a3,-1890 # 80244888 <log>
    80003ff2:	a039                	j	80004000 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003ff4:	02090b63          	beqz	s2,8000402a <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003ff8:	08848493          	addi	s1,s1,136
    80003ffc:	02d48a63          	beq	s1,a3,80004030 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80004000:	449c                	lw	a5,8(s1)
    80004002:	fef059e3          	blez	a5,80003ff4 <iget+0x38>
    80004006:	4098                	lw	a4,0(s1)
    80004008:	ff3716e3          	bne	a4,s3,80003ff4 <iget+0x38>
    8000400c:	40d8                	lw	a4,4(s1)
    8000400e:	ff4713e3          	bne	a4,s4,80003ff4 <iget+0x38>
      ip->ref++;
    80004012:	2785                	addiw	a5,a5,1
    80004014:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80004016:	0023f517          	auipc	a0,0x23f
    8000401a:	dca50513          	addi	a0,a0,-566 # 80242de0 <itable>
    8000401e:	ffffd097          	auipc	ra,0xffffd
    80004022:	d8a080e7          	jalr	-630(ra) # 80000da8 <release>
      return ip;
    80004026:	8926                	mv	s2,s1
    80004028:	a03d                	j	80004056 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000402a:	f7f9                	bnez	a5,80003ff8 <iget+0x3c>
    8000402c:	8926                	mv	s2,s1
    8000402e:	b7e9                	j	80003ff8 <iget+0x3c>
  if(empty == 0)
    80004030:	02090c63          	beqz	s2,80004068 <iget+0xac>
  ip->dev = dev;
    80004034:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80004038:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000403c:	4785                	li	a5,1
    8000403e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80004042:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80004046:	0023f517          	auipc	a0,0x23f
    8000404a:	d9a50513          	addi	a0,a0,-614 # 80242de0 <itable>
    8000404e:	ffffd097          	auipc	ra,0xffffd
    80004052:	d5a080e7          	jalr	-678(ra) # 80000da8 <release>
}
    80004056:	854a                	mv	a0,s2
    80004058:	70a2                	ld	ra,40(sp)
    8000405a:	7402                	ld	s0,32(sp)
    8000405c:	64e2                	ld	s1,24(sp)
    8000405e:	6942                	ld	s2,16(sp)
    80004060:	69a2                	ld	s3,8(sp)
    80004062:	6a02                	ld	s4,0(sp)
    80004064:	6145                	addi	sp,sp,48
    80004066:	8082                	ret
    panic("iget: no inodes");
    80004068:	00005517          	auipc	a0,0x5
    8000406c:	69050513          	addi	a0,a0,1680 # 800096f8 <syscalls+0x160>
    80004070:	ffffc097          	auipc	ra,0xffffc
    80004074:	4d0080e7          	jalr	1232(ra) # 80000540 <panic>

0000000080004078 <fsinit>:
fsinit(int dev) {
    80004078:	7179                	addi	sp,sp,-48
    8000407a:	f406                	sd	ra,40(sp)
    8000407c:	f022                	sd	s0,32(sp)
    8000407e:	ec26                	sd	s1,24(sp)
    80004080:	e84a                	sd	s2,16(sp)
    80004082:	e44e                	sd	s3,8(sp)
    80004084:	1800                	addi	s0,sp,48
    80004086:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80004088:	4585                	li	a1,1
    8000408a:	00000097          	auipc	ra,0x0
    8000408e:	a54080e7          	jalr	-1452(ra) # 80003ade <bread>
    80004092:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80004094:	0023f997          	auipc	s3,0x23f
    80004098:	d2c98993          	addi	s3,s3,-724 # 80242dc0 <sb>
    8000409c:	02000613          	li	a2,32
    800040a0:	05850593          	addi	a1,a0,88
    800040a4:	854e                	mv	a0,s3
    800040a6:	ffffd097          	auipc	ra,0xffffd
    800040aa:	da6080e7          	jalr	-602(ra) # 80000e4c <memmove>
  brelse(bp);
    800040ae:	8526                	mv	a0,s1
    800040b0:	00000097          	auipc	ra,0x0
    800040b4:	b5e080e7          	jalr	-1186(ra) # 80003c0e <brelse>
  if(sb.magic != FSMAGIC)
    800040b8:	0009a703          	lw	a4,0(s3)
    800040bc:	102037b7          	lui	a5,0x10203
    800040c0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800040c4:	02f71263          	bne	a4,a5,800040e8 <fsinit+0x70>
  initlog(dev, &sb);
    800040c8:	0023f597          	auipc	a1,0x23f
    800040cc:	cf858593          	addi	a1,a1,-776 # 80242dc0 <sb>
    800040d0:	854a                	mv	a0,s2
    800040d2:	00001097          	auipc	ra,0x1
    800040d6:	b4a080e7          	jalr	-1206(ra) # 80004c1c <initlog>
}
    800040da:	70a2                	ld	ra,40(sp)
    800040dc:	7402                	ld	s0,32(sp)
    800040de:	64e2                	ld	s1,24(sp)
    800040e0:	6942                	ld	s2,16(sp)
    800040e2:	69a2                	ld	s3,8(sp)
    800040e4:	6145                	addi	sp,sp,48
    800040e6:	8082                	ret
    panic("invalid file system");
    800040e8:	00005517          	auipc	a0,0x5
    800040ec:	62050513          	addi	a0,a0,1568 # 80009708 <syscalls+0x170>
    800040f0:	ffffc097          	auipc	ra,0xffffc
    800040f4:	450080e7          	jalr	1104(ra) # 80000540 <panic>

00000000800040f8 <iinit>:
{
    800040f8:	7179                	addi	sp,sp,-48
    800040fa:	f406                	sd	ra,40(sp)
    800040fc:	f022                	sd	s0,32(sp)
    800040fe:	ec26                	sd	s1,24(sp)
    80004100:	e84a                	sd	s2,16(sp)
    80004102:	e44e                	sd	s3,8(sp)
    80004104:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80004106:	00005597          	auipc	a1,0x5
    8000410a:	61a58593          	addi	a1,a1,1562 # 80009720 <syscalls+0x188>
    8000410e:	0023f517          	auipc	a0,0x23f
    80004112:	cd250513          	addi	a0,a0,-814 # 80242de0 <itable>
    80004116:	ffffd097          	auipc	ra,0xffffd
    8000411a:	b4e080e7          	jalr	-1202(ra) # 80000c64 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000411e:	0023f497          	auipc	s1,0x23f
    80004122:	cea48493          	addi	s1,s1,-790 # 80242e08 <itable+0x28>
    80004126:	00240997          	auipc	s3,0x240
    8000412a:	77298993          	addi	s3,s3,1906 # 80244898 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000412e:	00005917          	auipc	s2,0x5
    80004132:	5fa90913          	addi	s2,s2,1530 # 80009728 <syscalls+0x190>
    80004136:	85ca                	mv	a1,s2
    80004138:	8526                	mv	a0,s1
    8000413a:	00001097          	auipc	ra,0x1
    8000413e:	e42080e7          	jalr	-446(ra) # 80004f7c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80004142:	08848493          	addi	s1,s1,136
    80004146:	ff3498e3          	bne	s1,s3,80004136 <iinit+0x3e>
}
    8000414a:	70a2                	ld	ra,40(sp)
    8000414c:	7402                	ld	s0,32(sp)
    8000414e:	64e2                	ld	s1,24(sp)
    80004150:	6942                	ld	s2,16(sp)
    80004152:	69a2                	ld	s3,8(sp)
    80004154:	6145                	addi	sp,sp,48
    80004156:	8082                	ret

0000000080004158 <ialloc>:
{
    80004158:	715d                	addi	sp,sp,-80
    8000415a:	e486                	sd	ra,72(sp)
    8000415c:	e0a2                	sd	s0,64(sp)
    8000415e:	fc26                	sd	s1,56(sp)
    80004160:	f84a                	sd	s2,48(sp)
    80004162:	f44e                	sd	s3,40(sp)
    80004164:	f052                	sd	s4,32(sp)
    80004166:	ec56                	sd	s5,24(sp)
    80004168:	e85a                	sd	s6,16(sp)
    8000416a:	e45e                	sd	s7,8(sp)
    8000416c:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000416e:	0023f717          	auipc	a4,0x23f
    80004172:	c5e72703          	lw	a4,-930(a4) # 80242dcc <sb+0xc>
    80004176:	4785                	li	a5,1
    80004178:	04e7fa63          	bgeu	a5,a4,800041cc <ialloc+0x74>
    8000417c:	8aaa                	mv	s5,a0
    8000417e:	8bae                	mv	s7,a1
    80004180:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80004182:	0023fa17          	auipc	s4,0x23f
    80004186:	c3ea0a13          	addi	s4,s4,-962 # 80242dc0 <sb>
    8000418a:	00048b1b          	sext.w	s6,s1
    8000418e:	0044d593          	srli	a1,s1,0x4
    80004192:	018a2783          	lw	a5,24(s4)
    80004196:	9dbd                	addw	a1,a1,a5
    80004198:	8556                	mv	a0,s5
    8000419a:	00000097          	auipc	ra,0x0
    8000419e:	944080e7          	jalr	-1724(ra) # 80003ade <bread>
    800041a2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800041a4:	05850993          	addi	s3,a0,88
    800041a8:	00f4f793          	andi	a5,s1,15
    800041ac:	079a                	slli	a5,a5,0x6
    800041ae:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800041b0:	00099783          	lh	a5,0(s3)
    800041b4:	c3a1                	beqz	a5,800041f4 <ialloc+0x9c>
    brelse(bp);
    800041b6:	00000097          	auipc	ra,0x0
    800041ba:	a58080e7          	jalr	-1448(ra) # 80003c0e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800041be:	0485                	addi	s1,s1,1
    800041c0:	00ca2703          	lw	a4,12(s4)
    800041c4:	0004879b          	sext.w	a5,s1
    800041c8:	fce7e1e3          	bltu	a5,a4,8000418a <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800041cc:	00005517          	auipc	a0,0x5
    800041d0:	56450513          	addi	a0,a0,1380 # 80009730 <syscalls+0x198>
    800041d4:	ffffc097          	auipc	ra,0xffffc
    800041d8:	3b6080e7          	jalr	950(ra) # 8000058a <printf>
  return 0;
    800041dc:	4501                	li	a0,0
}
    800041de:	60a6                	ld	ra,72(sp)
    800041e0:	6406                	ld	s0,64(sp)
    800041e2:	74e2                	ld	s1,56(sp)
    800041e4:	7942                	ld	s2,48(sp)
    800041e6:	79a2                	ld	s3,40(sp)
    800041e8:	7a02                	ld	s4,32(sp)
    800041ea:	6ae2                	ld	s5,24(sp)
    800041ec:	6b42                	ld	s6,16(sp)
    800041ee:	6ba2                	ld	s7,8(sp)
    800041f0:	6161                	addi	sp,sp,80
    800041f2:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800041f4:	04000613          	li	a2,64
    800041f8:	4581                	li	a1,0
    800041fa:	854e                	mv	a0,s3
    800041fc:	ffffd097          	auipc	ra,0xffffd
    80004200:	bf4080e7          	jalr	-1036(ra) # 80000df0 <memset>
      dip->type = type;
    80004204:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80004208:	854a                	mv	a0,s2
    8000420a:	00001097          	auipc	ra,0x1
    8000420e:	c8e080e7          	jalr	-882(ra) # 80004e98 <log_write>
      brelse(bp);
    80004212:	854a                	mv	a0,s2
    80004214:	00000097          	auipc	ra,0x0
    80004218:	9fa080e7          	jalr	-1542(ra) # 80003c0e <brelse>
      return iget(dev, inum);
    8000421c:	85da                	mv	a1,s6
    8000421e:	8556                	mv	a0,s5
    80004220:	00000097          	auipc	ra,0x0
    80004224:	d9c080e7          	jalr	-612(ra) # 80003fbc <iget>
    80004228:	bf5d                	j	800041de <ialloc+0x86>

000000008000422a <iupdate>:
{
    8000422a:	1101                	addi	sp,sp,-32
    8000422c:	ec06                	sd	ra,24(sp)
    8000422e:	e822                	sd	s0,16(sp)
    80004230:	e426                	sd	s1,8(sp)
    80004232:	e04a                	sd	s2,0(sp)
    80004234:	1000                	addi	s0,sp,32
    80004236:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004238:	415c                	lw	a5,4(a0)
    8000423a:	0047d79b          	srliw	a5,a5,0x4
    8000423e:	0023f597          	auipc	a1,0x23f
    80004242:	b9a5a583          	lw	a1,-1126(a1) # 80242dd8 <sb+0x18>
    80004246:	9dbd                	addw	a1,a1,a5
    80004248:	4108                	lw	a0,0(a0)
    8000424a:	00000097          	auipc	ra,0x0
    8000424e:	894080e7          	jalr	-1900(ra) # 80003ade <bread>
    80004252:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004254:	05850793          	addi	a5,a0,88
    80004258:	40d8                	lw	a4,4(s1)
    8000425a:	8b3d                	andi	a4,a4,15
    8000425c:	071a                	slli	a4,a4,0x6
    8000425e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80004260:	04449703          	lh	a4,68(s1)
    80004264:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80004268:	04649703          	lh	a4,70(s1)
    8000426c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80004270:	04849703          	lh	a4,72(s1)
    80004274:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80004278:	04a49703          	lh	a4,74(s1)
    8000427c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80004280:	44f8                	lw	a4,76(s1)
    80004282:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80004284:	03400613          	li	a2,52
    80004288:	05048593          	addi	a1,s1,80
    8000428c:	00c78513          	addi	a0,a5,12
    80004290:	ffffd097          	auipc	ra,0xffffd
    80004294:	bbc080e7          	jalr	-1092(ra) # 80000e4c <memmove>
  log_write(bp);
    80004298:	854a                	mv	a0,s2
    8000429a:	00001097          	auipc	ra,0x1
    8000429e:	bfe080e7          	jalr	-1026(ra) # 80004e98 <log_write>
  brelse(bp);
    800042a2:	854a                	mv	a0,s2
    800042a4:	00000097          	auipc	ra,0x0
    800042a8:	96a080e7          	jalr	-1686(ra) # 80003c0e <brelse>
}
    800042ac:	60e2                	ld	ra,24(sp)
    800042ae:	6442                	ld	s0,16(sp)
    800042b0:	64a2                	ld	s1,8(sp)
    800042b2:	6902                	ld	s2,0(sp)
    800042b4:	6105                	addi	sp,sp,32
    800042b6:	8082                	ret

00000000800042b8 <idup>:
{
    800042b8:	1101                	addi	sp,sp,-32
    800042ba:	ec06                	sd	ra,24(sp)
    800042bc:	e822                	sd	s0,16(sp)
    800042be:	e426                	sd	s1,8(sp)
    800042c0:	1000                	addi	s0,sp,32
    800042c2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800042c4:	0023f517          	auipc	a0,0x23f
    800042c8:	b1c50513          	addi	a0,a0,-1252 # 80242de0 <itable>
    800042cc:	ffffd097          	auipc	ra,0xffffd
    800042d0:	a28080e7          	jalr	-1496(ra) # 80000cf4 <acquire>
  ip->ref++;
    800042d4:	449c                	lw	a5,8(s1)
    800042d6:	2785                	addiw	a5,a5,1
    800042d8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800042da:	0023f517          	auipc	a0,0x23f
    800042de:	b0650513          	addi	a0,a0,-1274 # 80242de0 <itable>
    800042e2:	ffffd097          	auipc	ra,0xffffd
    800042e6:	ac6080e7          	jalr	-1338(ra) # 80000da8 <release>
}
    800042ea:	8526                	mv	a0,s1
    800042ec:	60e2                	ld	ra,24(sp)
    800042ee:	6442                	ld	s0,16(sp)
    800042f0:	64a2                	ld	s1,8(sp)
    800042f2:	6105                	addi	sp,sp,32
    800042f4:	8082                	ret

00000000800042f6 <ilock>:
{
    800042f6:	1101                	addi	sp,sp,-32
    800042f8:	ec06                	sd	ra,24(sp)
    800042fa:	e822                	sd	s0,16(sp)
    800042fc:	e426                	sd	s1,8(sp)
    800042fe:	e04a                	sd	s2,0(sp)
    80004300:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80004302:	c115                	beqz	a0,80004326 <ilock+0x30>
    80004304:	84aa                	mv	s1,a0
    80004306:	451c                	lw	a5,8(a0)
    80004308:	00f05f63          	blez	a5,80004326 <ilock+0x30>
  acquiresleep(&ip->lock);
    8000430c:	0541                	addi	a0,a0,16
    8000430e:	00001097          	auipc	ra,0x1
    80004312:	ca8080e7          	jalr	-856(ra) # 80004fb6 <acquiresleep>
  if(ip->valid == 0){
    80004316:	40bc                	lw	a5,64(s1)
    80004318:	cf99                	beqz	a5,80004336 <ilock+0x40>
}
    8000431a:	60e2                	ld	ra,24(sp)
    8000431c:	6442                	ld	s0,16(sp)
    8000431e:	64a2                	ld	s1,8(sp)
    80004320:	6902                	ld	s2,0(sp)
    80004322:	6105                	addi	sp,sp,32
    80004324:	8082                	ret
    panic("ilock");
    80004326:	00005517          	auipc	a0,0x5
    8000432a:	42250513          	addi	a0,a0,1058 # 80009748 <syscalls+0x1b0>
    8000432e:	ffffc097          	auipc	ra,0xffffc
    80004332:	212080e7          	jalr	530(ra) # 80000540 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004336:	40dc                	lw	a5,4(s1)
    80004338:	0047d79b          	srliw	a5,a5,0x4
    8000433c:	0023f597          	auipc	a1,0x23f
    80004340:	a9c5a583          	lw	a1,-1380(a1) # 80242dd8 <sb+0x18>
    80004344:	9dbd                	addw	a1,a1,a5
    80004346:	4088                	lw	a0,0(s1)
    80004348:	fffff097          	auipc	ra,0xfffff
    8000434c:	796080e7          	jalr	1942(ra) # 80003ade <bread>
    80004350:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004352:	05850593          	addi	a1,a0,88
    80004356:	40dc                	lw	a5,4(s1)
    80004358:	8bbd                	andi	a5,a5,15
    8000435a:	079a                	slli	a5,a5,0x6
    8000435c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000435e:	00059783          	lh	a5,0(a1)
    80004362:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80004366:	00259783          	lh	a5,2(a1)
    8000436a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000436e:	00459783          	lh	a5,4(a1)
    80004372:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80004376:	00659783          	lh	a5,6(a1)
    8000437a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000437e:	459c                	lw	a5,8(a1)
    80004380:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80004382:	03400613          	li	a2,52
    80004386:	05b1                	addi	a1,a1,12
    80004388:	05048513          	addi	a0,s1,80
    8000438c:	ffffd097          	auipc	ra,0xffffd
    80004390:	ac0080e7          	jalr	-1344(ra) # 80000e4c <memmove>
    brelse(bp);
    80004394:	854a                	mv	a0,s2
    80004396:	00000097          	auipc	ra,0x0
    8000439a:	878080e7          	jalr	-1928(ra) # 80003c0e <brelse>
    ip->valid = 1;
    8000439e:	4785                	li	a5,1
    800043a0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800043a2:	04449783          	lh	a5,68(s1)
    800043a6:	fbb5                	bnez	a5,8000431a <ilock+0x24>
      panic("ilock: no type");
    800043a8:	00005517          	auipc	a0,0x5
    800043ac:	3a850513          	addi	a0,a0,936 # 80009750 <syscalls+0x1b8>
    800043b0:	ffffc097          	auipc	ra,0xffffc
    800043b4:	190080e7          	jalr	400(ra) # 80000540 <panic>

00000000800043b8 <iunlock>:
{
    800043b8:	1101                	addi	sp,sp,-32
    800043ba:	ec06                	sd	ra,24(sp)
    800043bc:	e822                	sd	s0,16(sp)
    800043be:	e426                	sd	s1,8(sp)
    800043c0:	e04a                	sd	s2,0(sp)
    800043c2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800043c4:	c905                	beqz	a0,800043f4 <iunlock+0x3c>
    800043c6:	84aa                	mv	s1,a0
    800043c8:	01050913          	addi	s2,a0,16
    800043cc:	854a                	mv	a0,s2
    800043ce:	00001097          	auipc	ra,0x1
    800043d2:	c82080e7          	jalr	-894(ra) # 80005050 <holdingsleep>
    800043d6:	cd19                	beqz	a0,800043f4 <iunlock+0x3c>
    800043d8:	449c                	lw	a5,8(s1)
    800043da:	00f05d63          	blez	a5,800043f4 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800043de:	854a                	mv	a0,s2
    800043e0:	00001097          	auipc	ra,0x1
    800043e4:	c2c080e7          	jalr	-980(ra) # 8000500c <releasesleep>
}
    800043e8:	60e2                	ld	ra,24(sp)
    800043ea:	6442                	ld	s0,16(sp)
    800043ec:	64a2                	ld	s1,8(sp)
    800043ee:	6902                	ld	s2,0(sp)
    800043f0:	6105                	addi	sp,sp,32
    800043f2:	8082                	ret
    panic("iunlock");
    800043f4:	00005517          	auipc	a0,0x5
    800043f8:	36c50513          	addi	a0,a0,876 # 80009760 <syscalls+0x1c8>
    800043fc:	ffffc097          	auipc	ra,0xffffc
    80004400:	144080e7          	jalr	324(ra) # 80000540 <panic>

0000000080004404 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80004404:	7179                	addi	sp,sp,-48
    80004406:	f406                	sd	ra,40(sp)
    80004408:	f022                	sd	s0,32(sp)
    8000440a:	ec26                	sd	s1,24(sp)
    8000440c:	e84a                	sd	s2,16(sp)
    8000440e:	e44e                	sd	s3,8(sp)
    80004410:	e052                	sd	s4,0(sp)
    80004412:	1800                	addi	s0,sp,48
    80004414:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80004416:	05050493          	addi	s1,a0,80
    8000441a:	08050913          	addi	s2,a0,128
    8000441e:	a021                	j	80004426 <itrunc+0x22>
    80004420:	0491                	addi	s1,s1,4
    80004422:	01248d63          	beq	s1,s2,8000443c <itrunc+0x38>
    if(ip->addrs[i]){
    80004426:	408c                	lw	a1,0(s1)
    80004428:	dde5                	beqz	a1,80004420 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    8000442a:	0009a503          	lw	a0,0(s3)
    8000442e:	00000097          	auipc	ra,0x0
    80004432:	8f6080e7          	jalr	-1802(ra) # 80003d24 <bfree>
      ip->addrs[i] = 0;
    80004436:	0004a023          	sw	zero,0(s1)
    8000443a:	b7dd                	j	80004420 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000443c:	0809a583          	lw	a1,128(s3)
    80004440:	e185                	bnez	a1,80004460 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80004442:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80004446:	854e                	mv	a0,s3
    80004448:	00000097          	auipc	ra,0x0
    8000444c:	de2080e7          	jalr	-542(ra) # 8000422a <iupdate>
}
    80004450:	70a2                	ld	ra,40(sp)
    80004452:	7402                	ld	s0,32(sp)
    80004454:	64e2                	ld	s1,24(sp)
    80004456:	6942                	ld	s2,16(sp)
    80004458:	69a2                	ld	s3,8(sp)
    8000445a:	6a02                	ld	s4,0(sp)
    8000445c:	6145                	addi	sp,sp,48
    8000445e:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80004460:	0009a503          	lw	a0,0(s3)
    80004464:	fffff097          	auipc	ra,0xfffff
    80004468:	67a080e7          	jalr	1658(ra) # 80003ade <bread>
    8000446c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000446e:	05850493          	addi	s1,a0,88
    80004472:	45850913          	addi	s2,a0,1112
    80004476:	a021                	j	8000447e <itrunc+0x7a>
    80004478:	0491                	addi	s1,s1,4
    8000447a:	01248b63          	beq	s1,s2,80004490 <itrunc+0x8c>
      if(a[j])
    8000447e:	408c                	lw	a1,0(s1)
    80004480:	dde5                	beqz	a1,80004478 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80004482:	0009a503          	lw	a0,0(s3)
    80004486:	00000097          	auipc	ra,0x0
    8000448a:	89e080e7          	jalr	-1890(ra) # 80003d24 <bfree>
    8000448e:	b7ed                	j	80004478 <itrunc+0x74>
    brelse(bp);
    80004490:	8552                	mv	a0,s4
    80004492:	fffff097          	auipc	ra,0xfffff
    80004496:	77c080e7          	jalr	1916(ra) # 80003c0e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000449a:	0809a583          	lw	a1,128(s3)
    8000449e:	0009a503          	lw	a0,0(s3)
    800044a2:	00000097          	auipc	ra,0x0
    800044a6:	882080e7          	jalr	-1918(ra) # 80003d24 <bfree>
    ip->addrs[NDIRECT] = 0;
    800044aa:	0809a023          	sw	zero,128(s3)
    800044ae:	bf51                	j	80004442 <itrunc+0x3e>

00000000800044b0 <iput>:
{
    800044b0:	1101                	addi	sp,sp,-32
    800044b2:	ec06                	sd	ra,24(sp)
    800044b4:	e822                	sd	s0,16(sp)
    800044b6:	e426                	sd	s1,8(sp)
    800044b8:	e04a                	sd	s2,0(sp)
    800044ba:	1000                	addi	s0,sp,32
    800044bc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800044be:	0023f517          	auipc	a0,0x23f
    800044c2:	92250513          	addi	a0,a0,-1758 # 80242de0 <itable>
    800044c6:	ffffd097          	auipc	ra,0xffffd
    800044ca:	82e080e7          	jalr	-2002(ra) # 80000cf4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800044ce:	4498                	lw	a4,8(s1)
    800044d0:	4785                	li	a5,1
    800044d2:	02f70363          	beq	a4,a5,800044f8 <iput+0x48>
  ip->ref--;
    800044d6:	449c                	lw	a5,8(s1)
    800044d8:	37fd                	addiw	a5,a5,-1
    800044da:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800044dc:	0023f517          	auipc	a0,0x23f
    800044e0:	90450513          	addi	a0,a0,-1788 # 80242de0 <itable>
    800044e4:	ffffd097          	auipc	ra,0xffffd
    800044e8:	8c4080e7          	jalr	-1852(ra) # 80000da8 <release>
}
    800044ec:	60e2                	ld	ra,24(sp)
    800044ee:	6442                	ld	s0,16(sp)
    800044f0:	64a2                	ld	s1,8(sp)
    800044f2:	6902                	ld	s2,0(sp)
    800044f4:	6105                	addi	sp,sp,32
    800044f6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800044f8:	40bc                	lw	a5,64(s1)
    800044fa:	dff1                	beqz	a5,800044d6 <iput+0x26>
    800044fc:	04a49783          	lh	a5,74(s1)
    80004500:	fbf9                	bnez	a5,800044d6 <iput+0x26>
    acquiresleep(&ip->lock);
    80004502:	01048913          	addi	s2,s1,16
    80004506:	854a                	mv	a0,s2
    80004508:	00001097          	auipc	ra,0x1
    8000450c:	aae080e7          	jalr	-1362(ra) # 80004fb6 <acquiresleep>
    release(&itable.lock);
    80004510:	0023f517          	auipc	a0,0x23f
    80004514:	8d050513          	addi	a0,a0,-1840 # 80242de0 <itable>
    80004518:	ffffd097          	auipc	ra,0xffffd
    8000451c:	890080e7          	jalr	-1904(ra) # 80000da8 <release>
    itrunc(ip);
    80004520:	8526                	mv	a0,s1
    80004522:	00000097          	auipc	ra,0x0
    80004526:	ee2080e7          	jalr	-286(ra) # 80004404 <itrunc>
    ip->type = 0;
    8000452a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000452e:	8526                	mv	a0,s1
    80004530:	00000097          	auipc	ra,0x0
    80004534:	cfa080e7          	jalr	-774(ra) # 8000422a <iupdate>
    ip->valid = 0;
    80004538:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000453c:	854a                	mv	a0,s2
    8000453e:	00001097          	auipc	ra,0x1
    80004542:	ace080e7          	jalr	-1330(ra) # 8000500c <releasesleep>
    acquire(&itable.lock);
    80004546:	0023f517          	auipc	a0,0x23f
    8000454a:	89a50513          	addi	a0,a0,-1894 # 80242de0 <itable>
    8000454e:	ffffc097          	auipc	ra,0xffffc
    80004552:	7a6080e7          	jalr	1958(ra) # 80000cf4 <acquire>
    80004556:	b741                	j	800044d6 <iput+0x26>

0000000080004558 <iunlockput>:
{
    80004558:	1101                	addi	sp,sp,-32
    8000455a:	ec06                	sd	ra,24(sp)
    8000455c:	e822                	sd	s0,16(sp)
    8000455e:	e426                	sd	s1,8(sp)
    80004560:	1000                	addi	s0,sp,32
    80004562:	84aa                	mv	s1,a0
  iunlock(ip);
    80004564:	00000097          	auipc	ra,0x0
    80004568:	e54080e7          	jalr	-428(ra) # 800043b8 <iunlock>
  iput(ip);
    8000456c:	8526                	mv	a0,s1
    8000456e:	00000097          	auipc	ra,0x0
    80004572:	f42080e7          	jalr	-190(ra) # 800044b0 <iput>
}
    80004576:	60e2                	ld	ra,24(sp)
    80004578:	6442                	ld	s0,16(sp)
    8000457a:	64a2                	ld	s1,8(sp)
    8000457c:	6105                	addi	sp,sp,32
    8000457e:	8082                	ret

0000000080004580 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004580:	1141                	addi	sp,sp,-16
    80004582:	e422                	sd	s0,8(sp)
    80004584:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80004586:	411c                	lw	a5,0(a0)
    80004588:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000458a:	415c                	lw	a5,4(a0)
    8000458c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000458e:	04451783          	lh	a5,68(a0)
    80004592:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004596:	04a51783          	lh	a5,74(a0)
    8000459a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000459e:	04c56783          	lwu	a5,76(a0)
    800045a2:	e99c                	sd	a5,16(a1)
}
    800045a4:	6422                	ld	s0,8(sp)
    800045a6:	0141                	addi	sp,sp,16
    800045a8:	8082                	ret

00000000800045aa <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800045aa:	457c                	lw	a5,76(a0)
    800045ac:	0ed7e963          	bltu	a5,a3,8000469e <readi+0xf4>
{
    800045b0:	7159                	addi	sp,sp,-112
    800045b2:	f486                	sd	ra,104(sp)
    800045b4:	f0a2                	sd	s0,96(sp)
    800045b6:	eca6                	sd	s1,88(sp)
    800045b8:	e8ca                	sd	s2,80(sp)
    800045ba:	e4ce                	sd	s3,72(sp)
    800045bc:	e0d2                	sd	s4,64(sp)
    800045be:	fc56                	sd	s5,56(sp)
    800045c0:	f85a                	sd	s6,48(sp)
    800045c2:	f45e                	sd	s7,40(sp)
    800045c4:	f062                	sd	s8,32(sp)
    800045c6:	ec66                	sd	s9,24(sp)
    800045c8:	e86a                	sd	s10,16(sp)
    800045ca:	e46e                	sd	s11,8(sp)
    800045cc:	1880                	addi	s0,sp,112
    800045ce:	8b2a                	mv	s6,a0
    800045d0:	8bae                	mv	s7,a1
    800045d2:	8a32                	mv	s4,a2
    800045d4:	84b6                	mv	s1,a3
    800045d6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800045d8:	9f35                	addw	a4,a4,a3
    return 0;
    800045da:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800045dc:	0ad76063          	bltu	a4,a3,8000467c <readi+0xd2>
  if(off + n > ip->size)
    800045e0:	00e7f463          	bgeu	a5,a4,800045e8 <readi+0x3e>
    n = ip->size - off;
    800045e4:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800045e8:	0a0a8963          	beqz	s5,8000469a <readi+0xf0>
    800045ec:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800045ee:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800045f2:	5c7d                	li	s8,-1
    800045f4:	a82d                	j	8000462e <readi+0x84>
    800045f6:	020d1d93          	slli	s11,s10,0x20
    800045fa:	020ddd93          	srli	s11,s11,0x20
    800045fe:	05890613          	addi	a2,s2,88
    80004602:	86ee                	mv	a3,s11
    80004604:	963a                	add	a2,a2,a4
    80004606:	85d2                	mv	a1,s4
    80004608:	855e                	mv	a0,s7
    8000460a:	ffffe097          	auipc	ra,0xffffe
    8000460e:	27c080e7          	jalr	636(ra) # 80002886 <either_copyout>
    80004612:	05850d63          	beq	a0,s8,8000466c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004616:	854a                	mv	a0,s2
    80004618:	fffff097          	auipc	ra,0xfffff
    8000461c:	5f6080e7          	jalr	1526(ra) # 80003c0e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004620:	013d09bb          	addw	s3,s10,s3
    80004624:	009d04bb          	addw	s1,s10,s1
    80004628:	9a6e                	add	s4,s4,s11
    8000462a:	0559f763          	bgeu	s3,s5,80004678 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    8000462e:	00a4d59b          	srliw	a1,s1,0xa
    80004632:	855a                	mv	a0,s6
    80004634:	00000097          	auipc	ra,0x0
    80004638:	89e080e7          	jalr	-1890(ra) # 80003ed2 <bmap>
    8000463c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80004640:	cd85                	beqz	a1,80004678 <readi+0xce>
    bp = bread(ip->dev, addr);
    80004642:	000b2503          	lw	a0,0(s6)
    80004646:	fffff097          	auipc	ra,0xfffff
    8000464a:	498080e7          	jalr	1176(ra) # 80003ade <bread>
    8000464e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004650:	3ff4f713          	andi	a4,s1,1023
    80004654:	40ec87bb          	subw	a5,s9,a4
    80004658:	413a86bb          	subw	a3,s5,s3
    8000465c:	8d3e                	mv	s10,a5
    8000465e:	2781                	sext.w	a5,a5
    80004660:	0006861b          	sext.w	a2,a3
    80004664:	f8f679e3          	bgeu	a2,a5,800045f6 <readi+0x4c>
    80004668:	8d36                	mv	s10,a3
    8000466a:	b771                	j	800045f6 <readi+0x4c>
      brelse(bp);
    8000466c:	854a                	mv	a0,s2
    8000466e:	fffff097          	auipc	ra,0xfffff
    80004672:	5a0080e7          	jalr	1440(ra) # 80003c0e <brelse>
      tot = -1;
    80004676:	59fd                	li	s3,-1
  }
  return tot;
    80004678:	0009851b          	sext.w	a0,s3
}
    8000467c:	70a6                	ld	ra,104(sp)
    8000467e:	7406                	ld	s0,96(sp)
    80004680:	64e6                	ld	s1,88(sp)
    80004682:	6946                	ld	s2,80(sp)
    80004684:	69a6                	ld	s3,72(sp)
    80004686:	6a06                	ld	s4,64(sp)
    80004688:	7ae2                	ld	s5,56(sp)
    8000468a:	7b42                	ld	s6,48(sp)
    8000468c:	7ba2                	ld	s7,40(sp)
    8000468e:	7c02                	ld	s8,32(sp)
    80004690:	6ce2                	ld	s9,24(sp)
    80004692:	6d42                	ld	s10,16(sp)
    80004694:	6da2                	ld	s11,8(sp)
    80004696:	6165                	addi	sp,sp,112
    80004698:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000469a:	89d6                	mv	s3,s5
    8000469c:	bff1                	j	80004678 <readi+0xce>
    return 0;
    8000469e:	4501                	li	a0,0
}
    800046a0:	8082                	ret

00000000800046a2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800046a2:	457c                	lw	a5,76(a0)
    800046a4:	10d7e863          	bltu	a5,a3,800047b4 <writei+0x112>
{
    800046a8:	7159                	addi	sp,sp,-112
    800046aa:	f486                	sd	ra,104(sp)
    800046ac:	f0a2                	sd	s0,96(sp)
    800046ae:	eca6                	sd	s1,88(sp)
    800046b0:	e8ca                	sd	s2,80(sp)
    800046b2:	e4ce                	sd	s3,72(sp)
    800046b4:	e0d2                	sd	s4,64(sp)
    800046b6:	fc56                	sd	s5,56(sp)
    800046b8:	f85a                	sd	s6,48(sp)
    800046ba:	f45e                	sd	s7,40(sp)
    800046bc:	f062                	sd	s8,32(sp)
    800046be:	ec66                	sd	s9,24(sp)
    800046c0:	e86a                	sd	s10,16(sp)
    800046c2:	e46e                	sd	s11,8(sp)
    800046c4:	1880                	addi	s0,sp,112
    800046c6:	8aaa                	mv	s5,a0
    800046c8:	8bae                	mv	s7,a1
    800046ca:	8a32                	mv	s4,a2
    800046cc:	8936                	mv	s2,a3
    800046ce:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800046d0:	00e687bb          	addw	a5,a3,a4
    800046d4:	0ed7e263          	bltu	a5,a3,800047b8 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800046d8:	00043737          	lui	a4,0x43
    800046dc:	0ef76063          	bltu	a4,a5,800047bc <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800046e0:	0c0b0863          	beqz	s6,800047b0 <writei+0x10e>
    800046e4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800046e6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800046ea:	5c7d                	li	s8,-1
    800046ec:	a091                	j	80004730 <writei+0x8e>
    800046ee:	020d1d93          	slli	s11,s10,0x20
    800046f2:	020ddd93          	srli	s11,s11,0x20
    800046f6:	05848513          	addi	a0,s1,88
    800046fa:	86ee                	mv	a3,s11
    800046fc:	8652                	mv	a2,s4
    800046fe:	85de                	mv	a1,s7
    80004700:	953a                	add	a0,a0,a4
    80004702:	ffffe097          	auipc	ra,0xffffe
    80004706:	1da080e7          	jalr	474(ra) # 800028dc <either_copyin>
    8000470a:	07850263          	beq	a0,s8,8000476e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000470e:	8526                	mv	a0,s1
    80004710:	00000097          	auipc	ra,0x0
    80004714:	788080e7          	jalr	1928(ra) # 80004e98 <log_write>
    brelse(bp);
    80004718:	8526                	mv	a0,s1
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	4f4080e7          	jalr	1268(ra) # 80003c0e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004722:	013d09bb          	addw	s3,s10,s3
    80004726:	012d093b          	addw	s2,s10,s2
    8000472a:	9a6e                	add	s4,s4,s11
    8000472c:	0569f663          	bgeu	s3,s6,80004778 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80004730:	00a9559b          	srliw	a1,s2,0xa
    80004734:	8556                	mv	a0,s5
    80004736:	fffff097          	auipc	ra,0xfffff
    8000473a:	79c080e7          	jalr	1948(ra) # 80003ed2 <bmap>
    8000473e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80004742:	c99d                	beqz	a1,80004778 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80004744:	000aa503          	lw	a0,0(s5)
    80004748:	fffff097          	auipc	ra,0xfffff
    8000474c:	396080e7          	jalr	918(ra) # 80003ade <bread>
    80004750:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004752:	3ff97713          	andi	a4,s2,1023
    80004756:	40ec87bb          	subw	a5,s9,a4
    8000475a:	413b06bb          	subw	a3,s6,s3
    8000475e:	8d3e                	mv	s10,a5
    80004760:	2781                	sext.w	a5,a5
    80004762:	0006861b          	sext.w	a2,a3
    80004766:	f8f674e3          	bgeu	a2,a5,800046ee <writei+0x4c>
    8000476a:	8d36                	mv	s10,a3
    8000476c:	b749                	j	800046ee <writei+0x4c>
      brelse(bp);
    8000476e:	8526                	mv	a0,s1
    80004770:	fffff097          	auipc	ra,0xfffff
    80004774:	49e080e7          	jalr	1182(ra) # 80003c0e <brelse>
  }

  if(off > ip->size)
    80004778:	04caa783          	lw	a5,76(s5)
    8000477c:	0127f463          	bgeu	a5,s2,80004784 <writei+0xe2>
    ip->size = off;
    80004780:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004784:	8556                	mv	a0,s5
    80004786:	00000097          	auipc	ra,0x0
    8000478a:	aa4080e7          	jalr	-1372(ra) # 8000422a <iupdate>

  return tot;
    8000478e:	0009851b          	sext.w	a0,s3
}
    80004792:	70a6                	ld	ra,104(sp)
    80004794:	7406                	ld	s0,96(sp)
    80004796:	64e6                	ld	s1,88(sp)
    80004798:	6946                	ld	s2,80(sp)
    8000479a:	69a6                	ld	s3,72(sp)
    8000479c:	6a06                	ld	s4,64(sp)
    8000479e:	7ae2                	ld	s5,56(sp)
    800047a0:	7b42                	ld	s6,48(sp)
    800047a2:	7ba2                	ld	s7,40(sp)
    800047a4:	7c02                	ld	s8,32(sp)
    800047a6:	6ce2                	ld	s9,24(sp)
    800047a8:	6d42                	ld	s10,16(sp)
    800047aa:	6da2                	ld	s11,8(sp)
    800047ac:	6165                	addi	sp,sp,112
    800047ae:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800047b0:	89da                	mv	s3,s6
    800047b2:	bfc9                	j	80004784 <writei+0xe2>
    return -1;
    800047b4:	557d                	li	a0,-1
}
    800047b6:	8082                	ret
    return -1;
    800047b8:	557d                	li	a0,-1
    800047ba:	bfe1                	j	80004792 <writei+0xf0>
    return -1;
    800047bc:	557d                	li	a0,-1
    800047be:	bfd1                	j	80004792 <writei+0xf0>

00000000800047c0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800047c0:	1141                	addi	sp,sp,-16
    800047c2:	e406                	sd	ra,8(sp)
    800047c4:	e022                	sd	s0,0(sp)
    800047c6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800047c8:	4639                	li	a2,14
    800047ca:	ffffc097          	auipc	ra,0xffffc
    800047ce:	6f6080e7          	jalr	1782(ra) # 80000ec0 <strncmp>
}
    800047d2:	60a2                	ld	ra,8(sp)
    800047d4:	6402                	ld	s0,0(sp)
    800047d6:	0141                	addi	sp,sp,16
    800047d8:	8082                	ret

00000000800047da <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800047da:	7139                	addi	sp,sp,-64
    800047dc:	fc06                	sd	ra,56(sp)
    800047de:	f822                	sd	s0,48(sp)
    800047e0:	f426                	sd	s1,40(sp)
    800047e2:	f04a                	sd	s2,32(sp)
    800047e4:	ec4e                	sd	s3,24(sp)
    800047e6:	e852                	sd	s4,16(sp)
    800047e8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800047ea:	04451703          	lh	a4,68(a0)
    800047ee:	4785                	li	a5,1
    800047f0:	00f71a63          	bne	a4,a5,80004804 <dirlookup+0x2a>
    800047f4:	892a                	mv	s2,a0
    800047f6:	89ae                	mv	s3,a1
    800047f8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800047fa:	457c                	lw	a5,76(a0)
    800047fc:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800047fe:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004800:	e79d                	bnez	a5,8000482e <dirlookup+0x54>
    80004802:	a8a5                	j	8000487a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004804:	00005517          	auipc	a0,0x5
    80004808:	f6450513          	addi	a0,a0,-156 # 80009768 <syscalls+0x1d0>
    8000480c:	ffffc097          	auipc	ra,0xffffc
    80004810:	d34080e7          	jalr	-716(ra) # 80000540 <panic>
      panic("dirlookup read");
    80004814:	00005517          	auipc	a0,0x5
    80004818:	f6c50513          	addi	a0,a0,-148 # 80009780 <syscalls+0x1e8>
    8000481c:	ffffc097          	auipc	ra,0xffffc
    80004820:	d24080e7          	jalr	-732(ra) # 80000540 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004824:	24c1                	addiw	s1,s1,16
    80004826:	04c92783          	lw	a5,76(s2)
    8000482a:	04f4f763          	bgeu	s1,a5,80004878 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000482e:	4741                	li	a4,16
    80004830:	86a6                	mv	a3,s1
    80004832:	fc040613          	addi	a2,s0,-64
    80004836:	4581                	li	a1,0
    80004838:	854a                	mv	a0,s2
    8000483a:	00000097          	auipc	ra,0x0
    8000483e:	d70080e7          	jalr	-656(ra) # 800045aa <readi>
    80004842:	47c1                	li	a5,16
    80004844:	fcf518e3          	bne	a0,a5,80004814 <dirlookup+0x3a>
    if(de.inum == 0)
    80004848:	fc045783          	lhu	a5,-64(s0)
    8000484c:	dfe1                	beqz	a5,80004824 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000484e:	fc240593          	addi	a1,s0,-62
    80004852:	854e                	mv	a0,s3
    80004854:	00000097          	auipc	ra,0x0
    80004858:	f6c080e7          	jalr	-148(ra) # 800047c0 <namecmp>
    8000485c:	f561                	bnez	a0,80004824 <dirlookup+0x4a>
      if(poff)
    8000485e:	000a0463          	beqz	s4,80004866 <dirlookup+0x8c>
        *poff = off;
    80004862:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004866:	fc045583          	lhu	a1,-64(s0)
    8000486a:	00092503          	lw	a0,0(s2)
    8000486e:	fffff097          	auipc	ra,0xfffff
    80004872:	74e080e7          	jalr	1870(ra) # 80003fbc <iget>
    80004876:	a011                	j	8000487a <dirlookup+0xa0>
  return 0;
    80004878:	4501                	li	a0,0
}
    8000487a:	70e2                	ld	ra,56(sp)
    8000487c:	7442                	ld	s0,48(sp)
    8000487e:	74a2                	ld	s1,40(sp)
    80004880:	7902                	ld	s2,32(sp)
    80004882:	69e2                	ld	s3,24(sp)
    80004884:	6a42                	ld	s4,16(sp)
    80004886:	6121                	addi	sp,sp,64
    80004888:	8082                	ret

000000008000488a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000488a:	711d                	addi	sp,sp,-96
    8000488c:	ec86                	sd	ra,88(sp)
    8000488e:	e8a2                	sd	s0,80(sp)
    80004890:	e4a6                	sd	s1,72(sp)
    80004892:	e0ca                	sd	s2,64(sp)
    80004894:	fc4e                	sd	s3,56(sp)
    80004896:	f852                	sd	s4,48(sp)
    80004898:	f456                	sd	s5,40(sp)
    8000489a:	f05a                	sd	s6,32(sp)
    8000489c:	ec5e                	sd	s7,24(sp)
    8000489e:	e862                	sd	s8,16(sp)
    800048a0:	e466                	sd	s9,8(sp)
    800048a2:	e06a                	sd	s10,0(sp)
    800048a4:	1080                	addi	s0,sp,96
    800048a6:	84aa                	mv	s1,a0
    800048a8:	8b2e                	mv	s6,a1
    800048aa:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800048ac:	00054703          	lbu	a4,0(a0)
    800048b0:	02f00793          	li	a5,47
    800048b4:	02f70363          	beq	a4,a5,800048da <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800048b8:	ffffd097          	auipc	ra,0xffffd
    800048bc:	258080e7          	jalr	600(ra) # 80001b10 <myproc>
    800048c0:	19853503          	ld	a0,408(a0)
    800048c4:	00000097          	auipc	ra,0x0
    800048c8:	9f4080e7          	jalr	-1548(ra) # 800042b8 <idup>
    800048cc:	8a2a                	mv	s4,a0
  while(*path == '/')
    800048ce:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800048d2:	4cb5                	li	s9,13
  len = path - s;
    800048d4:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800048d6:	4c05                	li	s8,1
    800048d8:	a87d                	j	80004996 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800048da:	4585                	li	a1,1
    800048dc:	4505                	li	a0,1
    800048de:	fffff097          	auipc	ra,0xfffff
    800048e2:	6de080e7          	jalr	1758(ra) # 80003fbc <iget>
    800048e6:	8a2a                	mv	s4,a0
    800048e8:	b7dd                	j	800048ce <namex+0x44>
      iunlockput(ip);
    800048ea:	8552                	mv	a0,s4
    800048ec:	00000097          	auipc	ra,0x0
    800048f0:	c6c080e7          	jalr	-916(ra) # 80004558 <iunlockput>
      return 0;
    800048f4:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800048f6:	8552                	mv	a0,s4
    800048f8:	60e6                	ld	ra,88(sp)
    800048fa:	6446                	ld	s0,80(sp)
    800048fc:	64a6                	ld	s1,72(sp)
    800048fe:	6906                	ld	s2,64(sp)
    80004900:	79e2                	ld	s3,56(sp)
    80004902:	7a42                	ld	s4,48(sp)
    80004904:	7aa2                	ld	s5,40(sp)
    80004906:	7b02                	ld	s6,32(sp)
    80004908:	6be2                	ld	s7,24(sp)
    8000490a:	6c42                	ld	s8,16(sp)
    8000490c:	6ca2                	ld	s9,8(sp)
    8000490e:	6d02                	ld	s10,0(sp)
    80004910:	6125                	addi	sp,sp,96
    80004912:	8082                	ret
      iunlock(ip);
    80004914:	8552                	mv	a0,s4
    80004916:	00000097          	auipc	ra,0x0
    8000491a:	aa2080e7          	jalr	-1374(ra) # 800043b8 <iunlock>
      return ip;
    8000491e:	bfe1                	j	800048f6 <namex+0x6c>
      iunlockput(ip);
    80004920:	8552                	mv	a0,s4
    80004922:	00000097          	auipc	ra,0x0
    80004926:	c36080e7          	jalr	-970(ra) # 80004558 <iunlockput>
      return 0;
    8000492a:	8a4e                	mv	s4,s3
    8000492c:	b7e9                	j	800048f6 <namex+0x6c>
  len = path - s;
    8000492e:	40998633          	sub	a2,s3,s1
    80004932:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80004936:	09acd863          	bge	s9,s10,800049c6 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    8000493a:	4639                	li	a2,14
    8000493c:	85a6                	mv	a1,s1
    8000493e:	8556                	mv	a0,s5
    80004940:	ffffc097          	auipc	ra,0xffffc
    80004944:	50c080e7          	jalr	1292(ra) # 80000e4c <memmove>
    80004948:	84ce                	mv	s1,s3
  while(*path == '/')
    8000494a:	0004c783          	lbu	a5,0(s1)
    8000494e:	01279763          	bne	a5,s2,8000495c <namex+0xd2>
    path++;
    80004952:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004954:	0004c783          	lbu	a5,0(s1)
    80004958:	ff278de3          	beq	a5,s2,80004952 <namex+0xc8>
    ilock(ip);
    8000495c:	8552                	mv	a0,s4
    8000495e:	00000097          	auipc	ra,0x0
    80004962:	998080e7          	jalr	-1640(ra) # 800042f6 <ilock>
    if(ip->type != T_DIR){
    80004966:	044a1783          	lh	a5,68(s4)
    8000496a:	f98790e3          	bne	a5,s8,800048ea <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000496e:	000b0563          	beqz	s6,80004978 <namex+0xee>
    80004972:	0004c783          	lbu	a5,0(s1)
    80004976:	dfd9                	beqz	a5,80004914 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004978:	865e                	mv	a2,s7
    8000497a:	85d6                	mv	a1,s5
    8000497c:	8552                	mv	a0,s4
    8000497e:	00000097          	auipc	ra,0x0
    80004982:	e5c080e7          	jalr	-420(ra) # 800047da <dirlookup>
    80004986:	89aa                	mv	s3,a0
    80004988:	dd41                	beqz	a0,80004920 <namex+0x96>
    iunlockput(ip);
    8000498a:	8552                	mv	a0,s4
    8000498c:	00000097          	auipc	ra,0x0
    80004990:	bcc080e7          	jalr	-1076(ra) # 80004558 <iunlockput>
    ip = next;
    80004994:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004996:	0004c783          	lbu	a5,0(s1)
    8000499a:	01279763          	bne	a5,s2,800049a8 <namex+0x11e>
    path++;
    8000499e:	0485                	addi	s1,s1,1
  while(*path == '/')
    800049a0:	0004c783          	lbu	a5,0(s1)
    800049a4:	ff278de3          	beq	a5,s2,8000499e <namex+0x114>
  if(*path == 0)
    800049a8:	cb9d                	beqz	a5,800049de <namex+0x154>
  while(*path != '/' && *path != 0)
    800049aa:	0004c783          	lbu	a5,0(s1)
    800049ae:	89a6                	mv	s3,s1
  len = path - s;
    800049b0:	8d5e                	mv	s10,s7
    800049b2:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800049b4:	01278963          	beq	a5,s2,800049c6 <namex+0x13c>
    800049b8:	dbbd                	beqz	a5,8000492e <namex+0xa4>
    path++;
    800049ba:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800049bc:	0009c783          	lbu	a5,0(s3)
    800049c0:	ff279ce3          	bne	a5,s2,800049b8 <namex+0x12e>
    800049c4:	b7ad                	j	8000492e <namex+0xa4>
    memmove(name, s, len);
    800049c6:	2601                	sext.w	a2,a2
    800049c8:	85a6                	mv	a1,s1
    800049ca:	8556                	mv	a0,s5
    800049cc:	ffffc097          	auipc	ra,0xffffc
    800049d0:	480080e7          	jalr	1152(ra) # 80000e4c <memmove>
    name[len] = 0;
    800049d4:	9d56                	add	s10,s10,s5
    800049d6:	000d0023          	sb	zero,0(s10)
    800049da:	84ce                	mv	s1,s3
    800049dc:	b7bd                	j	8000494a <namex+0xc0>
  if(nameiparent){
    800049de:	f00b0ce3          	beqz	s6,800048f6 <namex+0x6c>
    iput(ip);
    800049e2:	8552                	mv	a0,s4
    800049e4:	00000097          	auipc	ra,0x0
    800049e8:	acc080e7          	jalr	-1332(ra) # 800044b0 <iput>
    return 0;
    800049ec:	4a01                	li	s4,0
    800049ee:	b721                	j	800048f6 <namex+0x6c>

00000000800049f0 <dirlink>:
{
    800049f0:	7139                	addi	sp,sp,-64
    800049f2:	fc06                	sd	ra,56(sp)
    800049f4:	f822                	sd	s0,48(sp)
    800049f6:	f426                	sd	s1,40(sp)
    800049f8:	f04a                	sd	s2,32(sp)
    800049fa:	ec4e                	sd	s3,24(sp)
    800049fc:	e852                	sd	s4,16(sp)
    800049fe:	0080                	addi	s0,sp,64
    80004a00:	892a                	mv	s2,a0
    80004a02:	8a2e                	mv	s4,a1
    80004a04:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004a06:	4601                	li	a2,0
    80004a08:	00000097          	auipc	ra,0x0
    80004a0c:	dd2080e7          	jalr	-558(ra) # 800047da <dirlookup>
    80004a10:	e93d                	bnez	a0,80004a86 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004a12:	04c92483          	lw	s1,76(s2)
    80004a16:	c49d                	beqz	s1,80004a44 <dirlink+0x54>
    80004a18:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a1a:	4741                	li	a4,16
    80004a1c:	86a6                	mv	a3,s1
    80004a1e:	fc040613          	addi	a2,s0,-64
    80004a22:	4581                	li	a1,0
    80004a24:	854a                	mv	a0,s2
    80004a26:	00000097          	auipc	ra,0x0
    80004a2a:	b84080e7          	jalr	-1148(ra) # 800045aa <readi>
    80004a2e:	47c1                	li	a5,16
    80004a30:	06f51163          	bne	a0,a5,80004a92 <dirlink+0xa2>
    if(de.inum == 0)
    80004a34:	fc045783          	lhu	a5,-64(s0)
    80004a38:	c791                	beqz	a5,80004a44 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004a3a:	24c1                	addiw	s1,s1,16
    80004a3c:	04c92783          	lw	a5,76(s2)
    80004a40:	fcf4ede3          	bltu	s1,a5,80004a1a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004a44:	4639                	li	a2,14
    80004a46:	85d2                	mv	a1,s4
    80004a48:	fc240513          	addi	a0,s0,-62
    80004a4c:	ffffc097          	auipc	ra,0xffffc
    80004a50:	4b0080e7          	jalr	1200(ra) # 80000efc <strncpy>
  de.inum = inum;
    80004a54:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a58:	4741                	li	a4,16
    80004a5a:	86a6                	mv	a3,s1
    80004a5c:	fc040613          	addi	a2,s0,-64
    80004a60:	4581                	li	a1,0
    80004a62:	854a                	mv	a0,s2
    80004a64:	00000097          	auipc	ra,0x0
    80004a68:	c3e080e7          	jalr	-962(ra) # 800046a2 <writei>
    80004a6c:	1541                	addi	a0,a0,-16
    80004a6e:	00a03533          	snez	a0,a0
    80004a72:	40a00533          	neg	a0,a0
}
    80004a76:	70e2                	ld	ra,56(sp)
    80004a78:	7442                	ld	s0,48(sp)
    80004a7a:	74a2                	ld	s1,40(sp)
    80004a7c:	7902                	ld	s2,32(sp)
    80004a7e:	69e2                	ld	s3,24(sp)
    80004a80:	6a42                	ld	s4,16(sp)
    80004a82:	6121                	addi	sp,sp,64
    80004a84:	8082                	ret
    iput(ip);
    80004a86:	00000097          	auipc	ra,0x0
    80004a8a:	a2a080e7          	jalr	-1494(ra) # 800044b0 <iput>
    return -1;
    80004a8e:	557d                	li	a0,-1
    80004a90:	b7dd                	j	80004a76 <dirlink+0x86>
      panic("dirlink read");
    80004a92:	00005517          	auipc	a0,0x5
    80004a96:	cfe50513          	addi	a0,a0,-770 # 80009790 <syscalls+0x1f8>
    80004a9a:	ffffc097          	auipc	ra,0xffffc
    80004a9e:	aa6080e7          	jalr	-1370(ra) # 80000540 <panic>

0000000080004aa2 <namei>:

struct inode*
namei(char *path)
{
    80004aa2:	1101                	addi	sp,sp,-32
    80004aa4:	ec06                	sd	ra,24(sp)
    80004aa6:	e822                	sd	s0,16(sp)
    80004aa8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004aaa:	fe040613          	addi	a2,s0,-32
    80004aae:	4581                	li	a1,0
    80004ab0:	00000097          	auipc	ra,0x0
    80004ab4:	dda080e7          	jalr	-550(ra) # 8000488a <namex>
}
    80004ab8:	60e2                	ld	ra,24(sp)
    80004aba:	6442                	ld	s0,16(sp)
    80004abc:	6105                	addi	sp,sp,32
    80004abe:	8082                	ret

0000000080004ac0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004ac0:	1141                	addi	sp,sp,-16
    80004ac2:	e406                	sd	ra,8(sp)
    80004ac4:	e022                	sd	s0,0(sp)
    80004ac6:	0800                	addi	s0,sp,16
    80004ac8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004aca:	4585                	li	a1,1
    80004acc:	00000097          	auipc	ra,0x0
    80004ad0:	dbe080e7          	jalr	-578(ra) # 8000488a <namex>
}
    80004ad4:	60a2                	ld	ra,8(sp)
    80004ad6:	6402                	ld	s0,0(sp)
    80004ad8:	0141                	addi	sp,sp,16
    80004ada:	8082                	ret

0000000080004adc <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004adc:	1101                	addi	sp,sp,-32
    80004ade:	ec06                	sd	ra,24(sp)
    80004ae0:	e822                	sd	s0,16(sp)
    80004ae2:	e426                	sd	s1,8(sp)
    80004ae4:	e04a                	sd	s2,0(sp)
    80004ae6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004ae8:	00240917          	auipc	s2,0x240
    80004aec:	da090913          	addi	s2,s2,-608 # 80244888 <log>
    80004af0:	01892583          	lw	a1,24(s2)
    80004af4:	02892503          	lw	a0,40(s2)
    80004af8:	fffff097          	auipc	ra,0xfffff
    80004afc:	fe6080e7          	jalr	-26(ra) # 80003ade <bread>
    80004b00:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004b02:	02c92683          	lw	a3,44(s2)
    80004b06:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004b08:	02d05863          	blez	a3,80004b38 <write_head+0x5c>
    80004b0c:	00240797          	auipc	a5,0x240
    80004b10:	dac78793          	addi	a5,a5,-596 # 802448b8 <log+0x30>
    80004b14:	05c50713          	addi	a4,a0,92
    80004b18:	36fd                	addiw	a3,a3,-1
    80004b1a:	02069613          	slli	a2,a3,0x20
    80004b1e:	01e65693          	srli	a3,a2,0x1e
    80004b22:	00240617          	auipc	a2,0x240
    80004b26:	d9a60613          	addi	a2,a2,-614 # 802448bc <log+0x34>
    80004b2a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80004b2c:	4390                	lw	a2,0(a5)
    80004b2e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004b30:	0791                	addi	a5,a5,4
    80004b32:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80004b34:	fed79ce3          	bne	a5,a3,80004b2c <write_head+0x50>
  }
  bwrite(buf);
    80004b38:	8526                	mv	a0,s1
    80004b3a:	fffff097          	auipc	ra,0xfffff
    80004b3e:	096080e7          	jalr	150(ra) # 80003bd0 <bwrite>
  brelse(buf);
    80004b42:	8526                	mv	a0,s1
    80004b44:	fffff097          	auipc	ra,0xfffff
    80004b48:	0ca080e7          	jalr	202(ra) # 80003c0e <brelse>
}
    80004b4c:	60e2                	ld	ra,24(sp)
    80004b4e:	6442                	ld	s0,16(sp)
    80004b50:	64a2                	ld	s1,8(sp)
    80004b52:	6902                	ld	s2,0(sp)
    80004b54:	6105                	addi	sp,sp,32
    80004b56:	8082                	ret

0000000080004b58 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004b58:	00240797          	auipc	a5,0x240
    80004b5c:	d5c7a783          	lw	a5,-676(a5) # 802448b4 <log+0x2c>
    80004b60:	0af05d63          	blez	a5,80004c1a <install_trans+0xc2>
{
    80004b64:	7139                	addi	sp,sp,-64
    80004b66:	fc06                	sd	ra,56(sp)
    80004b68:	f822                	sd	s0,48(sp)
    80004b6a:	f426                	sd	s1,40(sp)
    80004b6c:	f04a                	sd	s2,32(sp)
    80004b6e:	ec4e                	sd	s3,24(sp)
    80004b70:	e852                	sd	s4,16(sp)
    80004b72:	e456                	sd	s5,8(sp)
    80004b74:	e05a                	sd	s6,0(sp)
    80004b76:	0080                	addi	s0,sp,64
    80004b78:	8b2a                	mv	s6,a0
    80004b7a:	00240a97          	auipc	s5,0x240
    80004b7e:	d3ea8a93          	addi	s5,s5,-706 # 802448b8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004b82:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004b84:	00240997          	auipc	s3,0x240
    80004b88:	d0498993          	addi	s3,s3,-764 # 80244888 <log>
    80004b8c:	a00d                	j	80004bae <install_trans+0x56>
    brelse(lbuf);
    80004b8e:	854a                	mv	a0,s2
    80004b90:	fffff097          	auipc	ra,0xfffff
    80004b94:	07e080e7          	jalr	126(ra) # 80003c0e <brelse>
    brelse(dbuf);
    80004b98:	8526                	mv	a0,s1
    80004b9a:	fffff097          	auipc	ra,0xfffff
    80004b9e:	074080e7          	jalr	116(ra) # 80003c0e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004ba2:	2a05                	addiw	s4,s4,1
    80004ba4:	0a91                	addi	s5,s5,4
    80004ba6:	02c9a783          	lw	a5,44(s3)
    80004baa:	04fa5e63          	bge	s4,a5,80004c06 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004bae:	0189a583          	lw	a1,24(s3)
    80004bb2:	014585bb          	addw	a1,a1,s4
    80004bb6:	2585                	addiw	a1,a1,1
    80004bb8:	0289a503          	lw	a0,40(s3)
    80004bbc:	fffff097          	auipc	ra,0xfffff
    80004bc0:	f22080e7          	jalr	-222(ra) # 80003ade <bread>
    80004bc4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004bc6:	000aa583          	lw	a1,0(s5)
    80004bca:	0289a503          	lw	a0,40(s3)
    80004bce:	fffff097          	auipc	ra,0xfffff
    80004bd2:	f10080e7          	jalr	-240(ra) # 80003ade <bread>
    80004bd6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004bd8:	40000613          	li	a2,1024
    80004bdc:	05890593          	addi	a1,s2,88
    80004be0:	05850513          	addi	a0,a0,88
    80004be4:	ffffc097          	auipc	ra,0xffffc
    80004be8:	268080e7          	jalr	616(ra) # 80000e4c <memmove>
    bwrite(dbuf);  // write dst to disk
    80004bec:	8526                	mv	a0,s1
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	fe2080e7          	jalr	-30(ra) # 80003bd0 <bwrite>
    if(recovering == 0)
    80004bf6:	f80b1ce3          	bnez	s6,80004b8e <install_trans+0x36>
      bunpin(dbuf);
    80004bfa:	8526                	mv	a0,s1
    80004bfc:	fffff097          	auipc	ra,0xfffff
    80004c00:	0ec080e7          	jalr	236(ra) # 80003ce8 <bunpin>
    80004c04:	b769                	j	80004b8e <install_trans+0x36>
}
    80004c06:	70e2                	ld	ra,56(sp)
    80004c08:	7442                	ld	s0,48(sp)
    80004c0a:	74a2                	ld	s1,40(sp)
    80004c0c:	7902                	ld	s2,32(sp)
    80004c0e:	69e2                	ld	s3,24(sp)
    80004c10:	6a42                	ld	s4,16(sp)
    80004c12:	6aa2                	ld	s5,8(sp)
    80004c14:	6b02                	ld	s6,0(sp)
    80004c16:	6121                	addi	sp,sp,64
    80004c18:	8082                	ret
    80004c1a:	8082                	ret

0000000080004c1c <initlog>:
{
    80004c1c:	7179                	addi	sp,sp,-48
    80004c1e:	f406                	sd	ra,40(sp)
    80004c20:	f022                	sd	s0,32(sp)
    80004c22:	ec26                	sd	s1,24(sp)
    80004c24:	e84a                	sd	s2,16(sp)
    80004c26:	e44e                	sd	s3,8(sp)
    80004c28:	1800                	addi	s0,sp,48
    80004c2a:	892a                	mv	s2,a0
    80004c2c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004c2e:	00240497          	auipc	s1,0x240
    80004c32:	c5a48493          	addi	s1,s1,-934 # 80244888 <log>
    80004c36:	00005597          	auipc	a1,0x5
    80004c3a:	b6a58593          	addi	a1,a1,-1174 # 800097a0 <syscalls+0x208>
    80004c3e:	8526                	mv	a0,s1
    80004c40:	ffffc097          	auipc	ra,0xffffc
    80004c44:	024080e7          	jalr	36(ra) # 80000c64 <initlock>
  log.start = sb->logstart;
    80004c48:	0149a583          	lw	a1,20(s3)
    80004c4c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004c4e:	0109a783          	lw	a5,16(s3)
    80004c52:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004c54:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004c58:	854a                	mv	a0,s2
    80004c5a:	fffff097          	auipc	ra,0xfffff
    80004c5e:	e84080e7          	jalr	-380(ra) # 80003ade <bread>
  log.lh.n = lh->n;
    80004c62:	4d34                	lw	a3,88(a0)
    80004c64:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004c66:	02d05663          	blez	a3,80004c92 <initlog+0x76>
    80004c6a:	05c50793          	addi	a5,a0,92
    80004c6e:	00240717          	auipc	a4,0x240
    80004c72:	c4a70713          	addi	a4,a4,-950 # 802448b8 <log+0x30>
    80004c76:	36fd                	addiw	a3,a3,-1
    80004c78:	02069613          	slli	a2,a3,0x20
    80004c7c:	01e65693          	srli	a3,a2,0x1e
    80004c80:	06050613          	addi	a2,a0,96
    80004c84:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004c86:	4390                	lw	a2,0(a5)
    80004c88:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004c8a:	0791                	addi	a5,a5,4
    80004c8c:	0711                	addi	a4,a4,4
    80004c8e:	fed79ce3          	bne	a5,a3,80004c86 <initlog+0x6a>
  brelse(buf);
    80004c92:	fffff097          	auipc	ra,0xfffff
    80004c96:	f7c080e7          	jalr	-132(ra) # 80003c0e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004c9a:	4505                	li	a0,1
    80004c9c:	00000097          	auipc	ra,0x0
    80004ca0:	ebc080e7          	jalr	-324(ra) # 80004b58 <install_trans>
  log.lh.n = 0;
    80004ca4:	00240797          	auipc	a5,0x240
    80004ca8:	c007a823          	sw	zero,-1008(a5) # 802448b4 <log+0x2c>
  write_head(); // clear the log
    80004cac:	00000097          	auipc	ra,0x0
    80004cb0:	e30080e7          	jalr	-464(ra) # 80004adc <write_head>
}
    80004cb4:	70a2                	ld	ra,40(sp)
    80004cb6:	7402                	ld	s0,32(sp)
    80004cb8:	64e2                	ld	s1,24(sp)
    80004cba:	6942                	ld	s2,16(sp)
    80004cbc:	69a2                	ld	s3,8(sp)
    80004cbe:	6145                	addi	sp,sp,48
    80004cc0:	8082                	ret

0000000080004cc2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004cc2:	1101                	addi	sp,sp,-32
    80004cc4:	ec06                	sd	ra,24(sp)
    80004cc6:	e822                	sd	s0,16(sp)
    80004cc8:	e426                	sd	s1,8(sp)
    80004cca:	e04a                	sd	s2,0(sp)
    80004ccc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004cce:	00240517          	auipc	a0,0x240
    80004cd2:	bba50513          	addi	a0,a0,-1094 # 80244888 <log>
    80004cd6:	ffffc097          	auipc	ra,0xffffc
    80004cda:	01e080e7          	jalr	30(ra) # 80000cf4 <acquire>
  while(1){
    if(log.committing){
    80004cde:	00240497          	auipc	s1,0x240
    80004ce2:	baa48493          	addi	s1,s1,-1110 # 80244888 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004ce6:	4979                	li	s2,30
    80004ce8:	a039                	j	80004cf6 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004cea:	85a6                	mv	a1,s1
    80004cec:	8526                	mv	a0,s1
    80004cee:	ffffd097          	auipc	ra,0xffffd
    80004cf2:	7b6080e7          	jalr	1974(ra) # 800024a4 <sleep>
    if(log.committing){
    80004cf6:	50dc                	lw	a5,36(s1)
    80004cf8:	fbed                	bnez	a5,80004cea <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004cfa:	5098                	lw	a4,32(s1)
    80004cfc:	2705                	addiw	a4,a4,1
    80004cfe:	0007069b          	sext.w	a3,a4
    80004d02:	0027179b          	slliw	a5,a4,0x2
    80004d06:	9fb9                	addw	a5,a5,a4
    80004d08:	0017979b          	slliw	a5,a5,0x1
    80004d0c:	54d8                	lw	a4,44(s1)
    80004d0e:	9fb9                	addw	a5,a5,a4
    80004d10:	00f95963          	bge	s2,a5,80004d22 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004d14:	85a6                	mv	a1,s1
    80004d16:	8526                	mv	a0,s1
    80004d18:	ffffd097          	auipc	ra,0xffffd
    80004d1c:	78c080e7          	jalr	1932(ra) # 800024a4 <sleep>
    80004d20:	bfd9                	j	80004cf6 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004d22:	00240517          	auipc	a0,0x240
    80004d26:	b6650513          	addi	a0,a0,-1178 # 80244888 <log>
    80004d2a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004d2c:	ffffc097          	auipc	ra,0xffffc
    80004d30:	07c080e7          	jalr	124(ra) # 80000da8 <release>
      break;
    }
  }
}
    80004d34:	60e2                	ld	ra,24(sp)
    80004d36:	6442                	ld	s0,16(sp)
    80004d38:	64a2                	ld	s1,8(sp)
    80004d3a:	6902                	ld	s2,0(sp)
    80004d3c:	6105                	addi	sp,sp,32
    80004d3e:	8082                	ret

0000000080004d40 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004d40:	7139                	addi	sp,sp,-64
    80004d42:	fc06                	sd	ra,56(sp)
    80004d44:	f822                	sd	s0,48(sp)
    80004d46:	f426                	sd	s1,40(sp)
    80004d48:	f04a                	sd	s2,32(sp)
    80004d4a:	ec4e                	sd	s3,24(sp)
    80004d4c:	e852                	sd	s4,16(sp)
    80004d4e:	e456                	sd	s5,8(sp)
    80004d50:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004d52:	00240497          	auipc	s1,0x240
    80004d56:	b3648493          	addi	s1,s1,-1226 # 80244888 <log>
    80004d5a:	8526                	mv	a0,s1
    80004d5c:	ffffc097          	auipc	ra,0xffffc
    80004d60:	f98080e7          	jalr	-104(ra) # 80000cf4 <acquire>
  log.outstanding -= 1;
    80004d64:	509c                	lw	a5,32(s1)
    80004d66:	37fd                	addiw	a5,a5,-1
    80004d68:	0007891b          	sext.w	s2,a5
    80004d6c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004d6e:	50dc                	lw	a5,36(s1)
    80004d70:	e7b9                	bnez	a5,80004dbe <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004d72:	04091e63          	bnez	s2,80004dce <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004d76:	00240497          	auipc	s1,0x240
    80004d7a:	b1248493          	addi	s1,s1,-1262 # 80244888 <log>
    80004d7e:	4785                	li	a5,1
    80004d80:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004d82:	8526                	mv	a0,s1
    80004d84:	ffffc097          	auipc	ra,0xffffc
    80004d88:	024080e7          	jalr	36(ra) # 80000da8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004d8c:	54dc                	lw	a5,44(s1)
    80004d8e:	06f04763          	bgtz	a5,80004dfc <end_op+0xbc>
    acquire(&log.lock);
    80004d92:	00240497          	auipc	s1,0x240
    80004d96:	af648493          	addi	s1,s1,-1290 # 80244888 <log>
    80004d9a:	8526                	mv	a0,s1
    80004d9c:	ffffc097          	auipc	ra,0xffffc
    80004da0:	f58080e7          	jalr	-168(ra) # 80000cf4 <acquire>
    log.committing = 0;
    80004da4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004da8:	8526                	mv	a0,s1
    80004daa:	ffffd097          	auipc	ra,0xffffd
    80004dae:	75e080e7          	jalr	1886(ra) # 80002508 <wakeup>
    release(&log.lock);
    80004db2:	8526                	mv	a0,s1
    80004db4:	ffffc097          	auipc	ra,0xffffc
    80004db8:	ff4080e7          	jalr	-12(ra) # 80000da8 <release>
}
    80004dbc:	a03d                	j	80004dea <end_op+0xaa>
    panic("log.committing");
    80004dbe:	00005517          	auipc	a0,0x5
    80004dc2:	9ea50513          	addi	a0,a0,-1558 # 800097a8 <syscalls+0x210>
    80004dc6:	ffffb097          	auipc	ra,0xffffb
    80004dca:	77a080e7          	jalr	1914(ra) # 80000540 <panic>
    wakeup(&log);
    80004dce:	00240497          	auipc	s1,0x240
    80004dd2:	aba48493          	addi	s1,s1,-1350 # 80244888 <log>
    80004dd6:	8526                	mv	a0,s1
    80004dd8:	ffffd097          	auipc	ra,0xffffd
    80004ddc:	730080e7          	jalr	1840(ra) # 80002508 <wakeup>
  release(&log.lock);
    80004de0:	8526                	mv	a0,s1
    80004de2:	ffffc097          	auipc	ra,0xffffc
    80004de6:	fc6080e7          	jalr	-58(ra) # 80000da8 <release>
}
    80004dea:	70e2                	ld	ra,56(sp)
    80004dec:	7442                	ld	s0,48(sp)
    80004dee:	74a2                	ld	s1,40(sp)
    80004df0:	7902                	ld	s2,32(sp)
    80004df2:	69e2                	ld	s3,24(sp)
    80004df4:	6a42                	ld	s4,16(sp)
    80004df6:	6aa2                	ld	s5,8(sp)
    80004df8:	6121                	addi	sp,sp,64
    80004dfa:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004dfc:	00240a97          	auipc	s5,0x240
    80004e00:	abca8a93          	addi	s5,s5,-1348 # 802448b8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004e04:	00240a17          	auipc	s4,0x240
    80004e08:	a84a0a13          	addi	s4,s4,-1404 # 80244888 <log>
    80004e0c:	018a2583          	lw	a1,24(s4)
    80004e10:	012585bb          	addw	a1,a1,s2
    80004e14:	2585                	addiw	a1,a1,1
    80004e16:	028a2503          	lw	a0,40(s4)
    80004e1a:	fffff097          	auipc	ra,0xfffff
    80004e1e:	cc4080e7          	jalr	-828(ra) # 80003ade <bread>
    80004e22:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004e24:	000aa583          	lw	a1,0(s5)
    80004e28:	028a2503          	lw	a0,40(s4)
    80004e2c:	fffff097          	auipc	ra,0xfffff
    80004e30:	cb2080e7          	jalr	-846(ra) # 80003ade <bread>
    80004e34:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004e36:	40000613          	li	a2,1024
    80004e3a:	05850593          	addi	a1,a0,88
    80004e3e:	05848513          	addi	a0,s1,88
    80004e42:	ffffc097          	auipc	ra,0xffffc
    80004e46:	00a080e7          	jalr	10(ra) # 80000e4c <memmove>
    bwrite(to);  // write the log
    80004e4a:	8526                	mv	a0,s1
    80004e4c:	fffff097          	auipc	ra,0xfffff
    80004e50:	d84080e7          	jalr	-636(ra) # 80003bd0 <bwrite>
    brelse(from);
    80004e54:	854e                	mv	a0,s3
    80004e56:	fffff097          	auipc	ra,0xfffff
    80004e5a:	db8080e7          	jalr	-584(ra) # 80003c0e <brelse>
    brelse(to);
    80004e5e:	8526                	mv	a0,s1
    80004e60:	fffff097          	auipc	ra,0xfffff
    80004e64:	dae080e7          	jalr	-594(ra) # 80003c0e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004e68:	2905                	addiw	s2,s2,1
    80004e6a:	0a91                	addi	s5,s5,4
    80004e6c:	02ca2783          	lw	a5,44(s4)
    80004e70:	f8f94ee3          	blt	s2,a5,80004e0c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004e74:	00000097          	auipc	ra,0x0
    80004e78:	c68080e7          	jalr	-920(ra) # 80004adc <write_head>
    install_trans(0); // Now install writes to home locations
    80004e7c:	4501                	li	a0,0
    80004e7e:	00000097          	auipc	ra,0x0
    80004e82:	cda080e7          	jalr	-806(ra) # 80004b58 <install_trans>
    log.lh.n = 0;
    80004e86:	00240797          	auipc	a5,0x240
    80004e8a:	a207a723          	sw	zero,-1490(a5) # 802448b4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004e8e:	00000097          	auipc	ra,0x0
    80004e92:	c4e080e7          	jalr	-946(ra) # 80004adc <write_head>
    80004e96:	bdf5                	j	80004d92 <end_op+0x52>

0000000080004e98 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004e98:	1101                	addi	sp,sp,-32
    80004e9a:	ec06                	sd	ra,24(sp)
    80004e9c:	e822                	sd	s0,16(sp)
    80004e9e:	e426                	sd	s1,8(sp)
    80004ea0:	e04a                	sd	s2,0(sp)
    80004ea2:	1000                	addi	s0,sp,32
    80004ea4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004ea6:	00240917          	auipc	s2,0x240
    80004eaa:	9e290913          	addi	s2,s2,-1566 # 80244888 <log>
    80004eae:	854a                	mv	a0,s2
    80004eb0:	ffffc097          	auipc	ra,0xffffc
    80004eb4:	e44080e7          	jalr	-444(ra) # 80000cf4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004eb8:	02c92603          	lw	a2,44(s2)
    80004ebc:	47f5                	li	a5,29
    80004ebe:	06c7c563          	blt	a5,a2,80004f28 <log_write+0x90>
    80004ec2:	00240797          	auipc	a5,0x240
    80004ec6:	9e27a783          	lw	a5,-1566(a5) # 802448a4 <log+0x1c>
    80004eca:	37fd                	addiw	a5,a5,-1
    80004ecc:	04f65e63          	bge	a2,a5,80004f28 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004ed0:	00240797          	auipc	a5,0x240
    80004ed4:	9d87a783          	lw	a5,-1576(a5) # 802448a8 <log+0x20>
    80004ed8:	06f05063          	blez	a5,80004f38 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004edc:	4781                	li	a5,0
    80004ede:	06c05563          	blez	a2,80004f48 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004ee2:	44cc                	lw	a1,12(s1)
    80004ee4:	00240717          	auipc	a4,0x240
    80004ee8:	9d470713          	addi	a4,a4,-1580 # 802448b8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004eec:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004eee:	4314                	lw	a3,0(a4)
    80004ef0:	04b68c63          	beq	a3,a1,80004f48 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004ef4:	2785                	addiw	a5,a5,1
    80004ef6:	0711                	addi	a4,a4,4
    80004ef8:	fef61be3          	bne	a2,a5,80004eee <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004efc:	0621                	addi	a2,a2,8
    80004efe:	060a                	slli	a2,a2,0x2
    80004f00:	00240797          	auipc	a5,0x240
    80004f04:	98878793          	addi	a5,a5,-1656 # 80244888 <log>
    80004f08:	97b2                	add	a5,a5,a2
    80004f0a:	44d8                	lw	a4,12(s1)
    80004f0c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004f0e:	8526                	mv	a0,s1
    80004f10:	fffff097          	auipc	ra,0xfffff
    80004f14:	d9c080e7          	jalr	-612(ra) # 80003cac <bpin>
    log.lh.n++;
    80004f18:	00240717          	auipc	a4,0x240
    80004f1c:	97070713          	addi	a4,a4,-1680 # 80244888 <log>
    80004f20:	575c                	lw	a5,44(a4)
    80004f22:	2785                	addiw	a5,a5,1
    80004f24:	d75c                	sw	a5,44(a4)
    80004f26:	a82d                	j	80004f60 <log_write+0xc8>
    panic("too big a transaction");
    80004f28:	00005517          	auipc	a0,0x5
    80004f2c:	89050513          	addi	a0,a0,-1904 # 800097b8 <syscalls+0x220>
    80004f30:	ffffb097          	auipc	ra,0xffffb
    80004f34:	610080e7          	jalr	1552(ra) # 80000540 <panic>
    panic("log_write outside of trans");
    80004f38:	00005517          	auipc	a0,0x5
    80004f3c:	89850513          	addi	a0,a0,-1896 # 800097d0 <syscalls+0x238>
    80004f40:	ffffb097          	auipc	ra,0xffffb
    80004f44:	600080e7          	jalr	1536(ra) # 80000540 <panic>
  log.lh.block[i] = b->blockno;
    80004f48:	00878693          	addi	a3,a5,8
    80004f4c:	068a                	slli	a3,a3,0x2
    80004f4e:	00240717          	auipc	a4,0x240
    80004f52:	93a70713          	addi	a4,a4,-1734 # 80244888 <log>
    80004f56:	9736                	add	a4,a4,a3
    80004f58:	44d4                	lw	a3,12(s1)
    80004f5a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004f5c:	faf609e3          	beq	a2,a5,80004f0e <log_write+0x76>
  }
  release(&log.lock);
    80004f60:	00240517          	auipc	a0,0x240
    80004f64:	92850513          	addi	a0,a0,-1752 # 80244888 <log>
    80004f68:	ffffc097          	auipc	ra,0xffffc
    80004f6c:	e40080e7          	jalr	-448(ra) # 80000da8 <release>
}
    80004f70:	60e2                	ld	ra,24(sp)
    80004f72:	6442                	ld	s0,16(sp)
    80004f74:	64a2                	ld	s1,8(sp)
    80004f76:	6902                	ld	s2,0(sp)
    80004f78:	6105                	addi	sp,sp,32
    80004f7a:	8082                	ret

0000000080004f7c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004f7c:	1101                	addi	sp,sp,-32
    80004f7e:	ec06                	sd	ra,24(sp)
    80004f80:	e822                	sd	s0,16(sp)
    80004f82:	e426                	sd	s1,8(sp)
    80004f84:	e04a                	sd	s2,0(sp)
    80004f86:	1000                	addi	s0,sp,32
    80004f88:	84aa                	mv	s1,a0
    80004f8a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004f8c:	00005597          	auipc	a1,0x5
    80004f90:	86458593          	addi	a1,a1,-1948 # 800097f0 <syscalls+0x258>
    80004f94:	0521                	addi	a0,a0,8
    80004f96:	ffffc097          	auipc	ra,0xffffc
    80004f9a:	cce080e7          	jalr	-818(ra) # 80000c64 <initlock>
  lk->name = name;
    80004f9e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004fa2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004fa6:	0204a423          	sw	zero,40(s1)
}
    80004faa:	60e2                	ld	ra,24(sp)
    80004fac:	6442                	ld	s0,16(sp)
    80004fae:	64a2                	ld	s1,8(sp)
    80004fb0:	6902                	ld	s2,0(sp)
    80004fb2:	6105                	addi	sp,sp,32
    80004fb4:	8082                	ret

0000000080004fb6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004fb6:	1101                	addi	sp,sp,-32
    80004fb8:	ec06                	sd	ra,24(sp)
    80004fba:	e822                	sd	s0,16(sp)
    80004fbc:	e426                	sd	s1,8(sp)
    80004fbe:	e04a                	sd	s2,0(sp)
    80004fc0:	1000                	addi	s0,sp,32
    80004fc2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004fc4:	00850913          	addi	s2,a0,8
    80004fc8:	854a                	mv	a0,s2
    80004fca:	ffffc097          	auipc	ra,0xffffc
    80004fce:	d2a080e7          	jalr	-726(ra) # 80000cf4 <acquire>
  while (lk->locked) {
    80004fd2:	409c                	lw	a5,0(s1)
    80004fd4:	cb89                	beqz	a5,80004fe6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004fd6:	85ca                	mv	a1,s2
    80004fd8:	8526                	mv	a0,s1
    80004fda:	ffffd097          	auipc	ra,0xffffd
    80004fde:	4ca080e7          	jalr	1226(ra) # 800024a4 <sleep>
  while (lk->locked) {
    80004fe2:	409c                	lw	a5,0(s1)
    80004fe4:	fbed                	bnez	a5,80004fd6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004fe6:	4785                	li	a5,1
    80004fe8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004fea:	ffffd097          	auipc	ra,0xffffd
    80004fee:	b26080e7          	jalr	-1242(ra) # 80001b10 <myproc>
    80004ff2:	591c                	lw	a5,48(a0)
    80004ff4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004ff6:	854a                	mv	a0,s2
    80004ff8:	ffffc097          	auipc	ra,0xffffc
    80004ffc:	db0080e7          	jalr	-592(ra) # 80000da8 <release>
}
    80005000:	60e2                	ld	ra,24(sp)
    80005002:	6442                	ld	s0,16(sp)
    80005004:	64a2                	ld	s1,8(sp)
    80005006:	6902                	ld	s2,0(sp)
    80005008:	6105                	addi	sp,sp,32
    8000500a:	8082                	ret

000000008000500c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000500c:	1101                	addi	sp,sp,-32
    8000500e:	ec06                	sd	ra,24(sp)
    80005010:	e822                	sd	s0,16(sp)
    80005012:	e426                	sd	s1,8(sp)
    80005014:	e04a                	sd	s2,0(sp)
    80005016:	1000                	addi	s0,sp,32
    80005018:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000501a:	00850913          	addi	s2,a0,8
    8000501e:	854a                	mv	a0,s2
    80005020:	ffffc097          	auipc	ra,0xffffc
    80005024:	cd4080e7          	jalr	-812(ra) # 80000cf4 <acquire>
  lk->locked = 0;
    80005028:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000502c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80005030:	8526                	mv	a0,s1
    80005032:	ffffd097          	auipc	ra,0xffffd
    80005036:	4d6080e7          	jalr	1238(ra) # 80002508 <wakeup>
  release(&lk->lk);
    8000503a:	854a                	mv	a0,s2
    8000503c:	ffffc097          	auipc	ra,0xffffc
    80005040:	d6c080e7          	jalr	-660(ra) # 80000da8 <release>
}
    80005044:	60e2                	ld	ra,24(sp)
    80005046:	6442                	ld	s0,16(sp)
    80005048:	64a2                	ld	s1,8(sp)
    8000504a:	6902                	ld	s2,0(sp)
    8000504c:	6105                	addi	sp,sp,32
    8000504e:	8082                	ret

0000000080005050 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80005050:	7179                	addi	sp,sp,-48
    80005052:	f406                	sd	ra,40(sp)
    80005054:	f022                	sd	s0,32(sp)
    80005056:	ec26                	sd	s1,24(sp)
    80005058:	e84a                	sd	s2,16(sp)
    8000505a:	e44e                	sd	s3,8(sp)
    8000505c:	1800                	addi	s0,sp,48
    8000505e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80005060:	00850913          	addi	s2,a0,8
    80005064:	854a                	mv	a0,s2
    80005066:	ffffc097          	auipc	ra,0xffffc
    8000506a:	c8e080e7          	jalr	-882(ra) # 80000cf4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000506e:	409c                	lw	a5,0(s1)
    80005070:	ef99                	bnez	a5,8000508e <holdingsleep+0x3e>
    80005072:	4481                	li	s1,0
  release(&lk->lk);
    80005074:	854a                	mv	a0,s2
    80005076:	ffffc097          	auipc	ra,0xffffc
    8000507a:	d32080e7          	jalr	-718(ra) # 80000da8 <release>
  return r;
}
    8000507e:	8526                	mv	a0,s1
    80005080:	70a2                	ld	ra,40(sp)
    80005082:	7402                	ld	s0,32(sp)
    80005084:	64e2                	ld	s1,24(sp)
    80005086:	6942                	ld	s2,16(sp)
    80005088:	69a2                	ld	s3,8(sp)
    8000508a:	6145                	addi	sp,sp,48
    8000508c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000508e:	0284a983          	lw	s3,40(s1)
    80005092:	ffffd097          	auipc	ra,0xffffd
    80005096:	a7e080e7          	jalr	-1410(ra) # 80001b10 <myproc>
    8000509a:	5904                	lw	s1,48(a0)
    8000509c:	413484b3          	sub	s1,s1,s3
    800050a0:	0014b493          	seqz	s1,s1
    800050a4:	bfc1                	j	80005074 <holdingsleep+0x24>

00000000800050a6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800050a6:	1141                	addi	sp,sp,-16
    800050a8:	e406                	sd	ra,8(sp)
    800050aa:	e022                	sd	s0,0(sp)
    800050ac:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800050ae:	00004597          	auipc	a1,0x4
    800050b2:	75258593          	addi	a1,a1,1874 # 80009800 <syscalls+0x268>
    800050b6:	00240517          	auipc	a0,0x240
    800050ba:	91a50513          	addi	a0,a0,-1766 # 802449d0 <ftable>
    800050be:	ffffc097          	auipc	ra,0xffffc
    800050c2:	ba6080e7          	jalr	-1114(ra) # 80000c64 <initlock>
}
    800050c6:	60a2                	ld	ra,8(sp)
    800050c8:	6402                	ld	s0,0(sp)
    800050ca:	0141                	addi	sp,sp,16
    800050cc:	8082                	ret

00000000800050ce <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800050ce:	1101                	addi	sp,sp,-32
    800050d0:	ec06                	sd	ra,24(sp)
    800050d2:	e822                	sd	s0,16(sp)
    800050d4:	e426                	sd	s1,8(sp)
    800050d6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800050d8:	00240517          	auipc	a0,0x240
    800050dc:	8f850513          	addi	a0,a0,-1800 # 802449d0 <ftable>
    800050e0:	ffffc097          	auipc	ra,0xffffc
    800050e4:	c14080e7          	jalr	-1004(ra) # 80000cf4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800050e8:	00240497          	auipc	s1,0x240
    800050ec:	90048493          	addi	s1,s1,-1792 # 802449e8 <ftable+0x18>
    800050f0:	00241717          	auipc	a4,0x241
    800050f4:	89870713          	addi	a4,a4,-1896 # 80245988 <mt>
    if(f->ref == 0){
    800050f8:	40dc                	lw	a5,4(s1)
    800050fa:	cf99                	beqz	a5,80005118 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800050fc:	02848493          	addi	s1,s1,40
    80005100:	fee49ce3          	bne	s1,a4,800050f8 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80005104:	00240517          	auipc	a0,0x240
    80005108:	8cc50513          	addi	a0,a0,-1844 # 802449d0 <ftable>
    8000510c:	ffffc097          	auipc	ra,0xffffc
    80005110:	c9c080e7          	jalr	-868(ra) # 80000da8 <release>
  return 0;
    80005114:	4481                	li	s1,0
    80005116:	a819                	j	8000512c <filealloc+0x5e>
      f->ref = 1;
    80005118:	4785                	li	a5,1
    8000511a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000511c:	00240517          	auipc	a0,0x240
    80005120:	8b450513          	addi	a0,a0,-1868 # 802449d0 <ftable>
    80005124:	ffffc097          	auipc	ra,0xffffc
    80005128:	c84080e7          	jalr	-892(ra) # 80000da8 <release>
}
    8000512c:	8526                	mv	a0,s1
    8000512e:	60e2                	ld	ra,24(sp)
    80005130:	6442                	ld	s0,16(sp)
    80005132:	64a2                	ld	s1,8(sp)
    80005134:	6105                	addi	sp,sp,32
    80005136:	8082                	ret

0000000080005138 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80005138:	1101                	addi	sp,sp,-32
    8000513a:	ec06                	sd	ra,24(sp)
    8000513c:	e822                	sd	s0,16(sp)
    8000513e:	e426                	sd	s1,8(sp)
    80005140:	1000                	addi	s0,sp,32
    80005142:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80005144:	00240517          	auipc	a0,0x240
    80005148:	88c50513          	addi	a0,a0,-1908 # 802449d0 <ftable>
    8000514c:	ffffc097          	auipc	ra,0xffffc
    80005150:	ba8080e7          	jalr	-1112(ra) # 80000cf4 <acquire>
  if(f->ref < 1)
    80005154:	40dc                	lw	a5,4(s1)
    80005156:	02f05263          	blez	a5,8000517a <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000515a:	2785                	addiw	a5,a5,1
    8000515c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000515e:	00240517          	auipc	a0,0x240
    80005162:	87250513          	addi	a0,a0,-1934 # 802449d0 <ftable>
    80005166:	ffffc097          	auipc	ra,0xffffc
    8000516a:	c42080e7          	jalr	-958(ra) # 80000da8 <release>
  return f;
}
    8000516e:	8526                	mv	a0,s1
    80005170:	60e2                	ld	ra,24(sp)
    80005172:	6442                	ld	s0,16(sp)
    80005174:	64a2                	ld	s1,8(sp)
    80005176:	6105                	addi	sp,sp,32
    80005178:	8082                	ret
    panic("filedup");
    8000517a:	00004517          	auipc	a0,0x4
    8000517e:	68e50513          	addi	a0,a0,1678 # 80009808 <syscalls+0x270>
    80005182:	ffffb097          	auipc	ra,0xffffb
    80005186:	3be080e7          	jalr	958(ra) # 80000540 <panic>

000000008000518a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000518a:	7139                	addi	sp,sp,-64
    8000518c:	fc06                	sd	ra,56(sp)
    8000518e:	f822                	sd	s0,48(sp)
    80005190:	f426                	sd	s1,40(sp)
    80005192:	f04a                	sd	s2,32(sp)
    80005194:	ec4e                	sd	s3,24(sp)
    80005196:	e852                	sd	s4,16(sp)
    80005198:	e456                	sd	s5,8(sp)
    8000519a:	0080                	addi	s0,sp,64
    8000519c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000519e:	00240517          	auipc	a0,0x240
    800051a2:	83250513          	addi	a0,a0,-1998 # 802449d0 <ftable>
    800051a6:	ffffc097          	auipc	ra,0xffffc
    800051aa:	b4e080e7          	jalr	-1202(ra) # 80000cf4 <acquire>
  if(f->ref < 1)
    800051ae:	40dc                	lw	a5,4(s1)
    800051b0:	06f05163          	blez	a5,80005212 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800051b4:	37fd                	addiw	a5,a5,-1
    800051b6:	0007871b          	sext.w	a4,a5
    800051ba:	c0dc                	sw	a5,4(s1)
    800051bc:	06e04363          	bgtz	a4,80005222 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800051c0:	0004a903          	lw	s2,0(s1)
    800051c4:	0094ca83          	lbu	s5,9(s1)
    800051c8:	0104ba03          	ld	s4,16(s1)
    800051cc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800051d0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800051d4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800051d8:	0023f517          	auipc	a0,0x23f
    800051dc:	7f850513          	addi	a0,a0,2040 # 802449d0 <ftable>
    800051e0:	ffffc097          	auipc	ra,0xffffc
    800051e4:	bc8080e7          	jalr	-1080(ra) # 80000da8 <release>

  if(ff.type == FD_PIPE){
    800051e8:	4785                	li	a5,1
    800051ea:	04f90d63          	beq	s2,a5,80005244 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800051ee:	3979                	addiw	s2,s2,-2
    800051f0:	4785                	li	a5,1
    800051f2:	0527e063          	bltu	a5,s2,80005232 <fileclose+0xa8>
    begin_op();
    800051f6:	00000097          	auipc	ra,0x0
    800051fa:	acc080e7          	jalr	-1332(ra) # 80004cc2 <begin_op>
    iput(ff.ip);
    800051fe:	854e                	mv	a0,s3
    80005200:	fffff097          	auipc	ra,0xfffff
    80005204:	2b0080e7          	jalr	688(ra) # 800044b0 <iput>
    end_op();
    80005208:	00000097          	auipc	ra,0x0
    8000520c:	b38080e7          	jalr	-1224(ra) # 80004d40 <end_op>
    80005210:	a00d                	j	80005232 <fileclose+0xa8>
    panic("fileclose");
    80005212:	00004517          	auipc	a0,0x4
    80005216:	5fe50513          	addi	a0,a0,1534 # 80009810 <syscalls+0x278>
    8000521a:	ffffb097          	auipc	ra,0xffffb
    8000521e:	326080e7          	jalr	806(ra) # 80000540 <panic>
    release(&ftable.lock);
    80005222:	0023f517          	auipc	a0,0x23f
    80005226:	7ae50513          	addi	a0,a0,1966 # 802449d0 <ftable>
    8000522a:	ffffc097          	auipc	ra,0xffffc
    8000522e:	b7e080e7          	jalr	-1154(ra) # 80000da8 <release>
  }
}
    80005232:	70e2                	ld	ra,56(sp)
    80005234:	7442                	ld	s0,48(sp)
    80005236:	74a2                	ld	s1,40(sp)
    80005238:	7902                	ld	s2,32(sp)
    8000523a:	69e2                	ld	s3,24(sp)
    8000523c:	6a42                	ld	s4,16(sp)
    8000523e:	6aa2                	ld	s5,8(sp)
    80005240:	6121                	addi	sp,sp,64
    80005242:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80005244:	85d6                	mv	a1,s5
    80005246:	8552                	mv	a0,s4
    80005248:	00000097          	auipc	ra,0x0
    8000524c:	34c080e7          	jalr	844(ra) # 80005594 <pipeclose>
    80005250:	b7cd                	j	80005232 <fileclose+0xa8>

0000000080005252 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80005252:	715d                	addi	sp,sp,-80
    80005254:	e486                	sd	ra,72(sp)
    80005256:	e0a2                	sd	s0,64(sp)
    80005258:	fc26                	sd	s1,56(sp)
    8000525a:	f84a                	sd	s2,48(sp)
    8000525c:	f44e                	sd	s3,40(sp)
    8000525e:	0880                	addi	s0,sp,80
    80005260:	84aa                	mv	s1,a0
    80005262:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80005264:	ffffd097          	auipc	ra,0xffffd
    80005268:	8ac080e7          	jalr	-1876(ra) # 80001b10 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000526c:	409c                	lw	a5,0(s1)
    8000526e:	37f9                	addiw	a5,a5,-2
    80005270:	4705                	li	a4,1
    80005272:	04f76763          	bltu	a4,a5,800052c0 <filestat+0x6e>
    80005276:	892a                	mv	s2,a0
    ilock(f->ip);
    80005278:	6c88                	ld	a0,24(s1)
    8000527a:	fffff097          	auipc	ra,0xfffff
    8000527e:	07c080e7          	jalr	124(ra) # 800042f6 <ilock>
    stati(f->ip, &st);
    80005282:	fb840593          	addi	a1,s0,-72
    80005286:	6c88                	ld	a0,24(s1)
    80005288:	fffff097          	auipc	ra,0xfffff
    8000528c:	2f8080e7          	jalr	760(ra) # 80004580 <stati>
    iunlock(f->ip);
    80005290:	6c88                	ld	a0,24(s1)
    80005292:	fffff097          	auipc	ra,0xfffff
    80005296:	126080e7          	jalr	294(ra) # 800043b8 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000529a:	46e1                	li	a3,24
    8000529c:	fb840613          	addi	a2,s0,-72
    800052a0:	85ce                	mv	a1,s3
    800052a2:	09893503          	ld	a0,152(s2)
    800052a6:	ffffc097          	auipc	ra,0xffffc
    800052aa:	4f2080e7          	jalr	1266(ra) # 80001798 <copyout>
    800052ae:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800052b2:	60a6                	ld	ra,72(sp)
    800052b4:	6406                	ld	s0,64(sp)
    800052b6:	74e2                	ld	s1,56(sp)
    800052b8:	7942                	ld	s2,48(sp)
    800052ba:	79a2                	ld	s3,40(sp)
    800052bc:	6161                	addi	sp,sp,80
    800052be:	8082                	ret
  return -1;
    800052c0:	557d                	li	a0,-1
    800052c2:	bfc5                	j	800052b2 <filestat+0x60>

00000000800052c4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800052c4:	7179                	addi	sp,sp,-48
    800052c6:	f406                	sd	ra,40(sp)
    800052c8:	f022                	sd	s0,32(sp)
    800052ca:	ec26                	sd	s1,24(sp)
    800052cc:	e84a                	sd	s2,16(sp)
    800052ce:	e44e                	sd	s3,8(sp)
    800052d0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800052d2:	00854783          	lbu	a5,8(a0)
    800052d6:	c3d5                	beqz	a5,8000537a <fileread+0xb6>
    800052d8:	84aa                	mv	s1,a0
    800052da:	89ae                	mv	s3,a1
    800052dc:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800052de:	411c                	lw	a5,0(a0)
    800052e0:	4705                	li	a4,1
    800052e2:	04e78963          	beq	a5,a4,80005334 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800052e6:	470d                	li	a4,3
    800052e8:	04e78d63          	beq	a5,a4,80005342 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800052ec:	4709                	li	a4,2
    800052ee:	06e79e63          	bne	a5,a4,8000536a <fileread+0xa6>
    ilock(f->ip);
    800052f2:	6d08                	ld	a0,24(a0)
    800052f4:	fffff097          	auipc	ra,0xfffff
    800052f8:	002080e7          	jalr	2(ra) # 800042f6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800052fc:	874a                	mv	a4,s2
    800052fe:	5094                	lw	a3,32(s1)
    80005300:	864e                	mv	a2,s3
    80005302:	4585                	li	a1,1
    80005304:	6c88                	ld	a0,24(s1)
    80005306:	fffff097          	auipc	ra,0xfffff
    8000530a:	2a4080e7          	jalr	676(ra) # 800045aa <readi>
    8000530e:	892a                	mv	s2,a0
    80005310:	00a05563          	blez	a0,8000531a <fileread+0x56>
      f->off += r;
    80005314:	509c                	lw	a5,32(s1)
    80005316:	9fa9                	addw	a5,a5,a0
    80005318:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000531a:	6c88                	ld	a0,24(s1)
    8000531c:	fffff097          	auipc	ra,0xfffff
    80005320:	09c080e7          	jalr	156(ra) # 800043b8 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80005324:	854a                	mv	a0,s2
    80005326:	70a2                	ld	ra,40(sp)
    80005328:	7402                	ld	s0,32(sp)
    8000532a:	64e2                	ld	s1,24(sp)
    8000532c:	6942                	ld	s2,16(sp)
    8000532e:	69a2                	ld	s3,8(sp)
    80005330:	6145                	addi	sp,sp,48
    80005332:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80005334:	6908                	ld	a0,16(a0)
    80005336:	00000097          	auipc	ra,0x0
    8000533a:	3c6080e7          	jalr	966(ra) # 800056fc <piperead>
    8000533e:	892a                	mv	s2,a0
    80005340:	b7d5                	j	80005324 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80005342:	02451783          	lh	a5,36(a0)
    80005346:	03079693          	slli	a3,a5,0x30
    8000534a:	92c1                	srli	a3,a3,0x30
    8000534c:	4725                	li	a4,9
    8000534e:	02d76863          	bltu	a4,a3,8000537e <fileread+0xba>
    80005352:	0792                	slli	a5,a5,0x4
    80005354:	0023f717          	auipc	a4,0x23f
    80005358:	5dc70713          	addi	a4,a4,1500 # 80244930 <devsw>
    8000535c:	97ba                	add	a5,a5,a4
    8000535e:	639c                	ld	a5,0(a5)
    80005360:	c38d                	beqz	a5,80005382 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80005362:	4505                	li	a0,1
    80005364:	9782                	jalr	a5
    80005366:	892a                	mv	s2,a0
    80005368:	bf75                	j	80005324 <fileread+0x60>
    panic("fileread");
    8000536a:	00004517          	auipc	a0,0x4
    8000536e:	4b650513          	addi	a0,a0,1206 # 80009820 <syscalls+0x288>
    80005372:	ffffb097          	auipc	ra,0xffffb
    80005376:	1ce080e7          	jalr	462(ra) # 80000540 <panic>
    return -1;
    8000537a:	597d                	li	s2,-1
    8000537c:	b765                	j	80005324 <fileread+0x60>
      return -1;
    8000537e:	597d                	li	s2,-1
    80005380:	b755                	j	80005324 <fileread+0x60>
    80005382:	597d                	li	s2,-1
    80005384:	b745                	j	80005324 <fileread+0x60>

0000000080005386 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80005386:	715d                	addi	sp,sp,-80
    80005388:	e486                	sd	ra,72(sp)
    8000538a:	e0a2                	sd	s0,64(sp)
    8000538c:	fc26                	sd	s1,56(sp)
    8000538e:	f84a                	sd	s2,48(sp)
    80005390:	f44e                	sd	s3,40(sp)
    80005392:	f052                	sd	s4,32(sp)
    80005394:	ec56                	sd	s5,24(sp)
    80005396:	e85a                	sd	s6,16(sp)
    80005398:	e45e                	sd	s7,8(sp)
    8000539a:	e062                	sd	s8,0(sp)
    8000539c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    8000539e:	00954783          	lbu	a5,9(a0)
    800053a2:	10078663          	beqz	a5,800054ae <filewrite+0x128>
    800053a6:	892a                	mv	s2,a0
    800053a8:	8b2e                	mv	s6,a1
    800053aa:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800053ac:	411c                	lw	a5,0(a0)
    800053ae:	4705                	li	a4,1
    800053b0:	02e78263          	beq	a5,a4,800053d4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800053b4:	470d                	li	a4,3
    800053b6:	02e78663          	beq	a5,a4,800053e2 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800053ba:	4709                	li	a4,2
    800053bc:	0ee79163          	bne	a5,a4,8000549e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800053c0:	0ac05d63          	blez	a2,8000547a <filewrite+0xf4>
    int i = 0;
    800053c4:	4981                	li	s3,0
    800053c6:	6b85                	lui	s7,0x1
    800053c8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800053cc:	6c05                	lui	s8,0x1
    800053ce:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800053d2:	a861                	j	8000546a <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    800053d4:	6908                	ld	a0,16(a0)
    800053d6:	00000097          	auipc	ra,0x0
    800053da:	22e080e7          	jalr	558(ra) # 80005604 <pipewrite>
    800053de:	8a2a                	mv	s4,a0
    800053e0:	a045                	j	80005480 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800053e2:	02451783          	lh	a5,36(a0)
    800053e6:	03079693          	slli	a3,a5,0x30
    800053ea:	92c1                	srli	a3,a3,0x30
    800053ec:	4725                	li	a4,9
    800053ee:	0cd76263          	bltu	a4,a3,800054b2 <filewrite+0x12c>
    800053f2:	0792                	slli	a5,a5,0x4
    800053f4:	0023f717          	auipc	a4,0x23f
    800053f8:	53c70713          	addi	a4,a4,1340 # 80244930 <devsw>
    800053fc:	97ba                	add	a5,a5,a4
    800053fe:	679c                	ld	a5,8(a5)
    80005400:	cbdd                	beqz	a5,800054b6 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80005402:	4505                	li	a0,1
    80005404:	9782                	jalr	a5
    80005406:	8a2a                	mv	s4,a0
    80005408:	a8a5                	j	80005480 <filewrite+0xfa>
    8000540a:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    8000540e:	00000097          	auipc	ra,0x0
    80005412:	8b4080e7          	jalr	-1868(ra) # 80004cc2 <begin_op>
      ilock(f->ip);
    80005416:	01893503          	ld	a0,24(s2)
    8000541a:	fffff097          	auipc	ra,0xfffff
    8000541e:	edc080e7          	jalr	-292(ra) # 800042f6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80005422:	8756                	mv	a4,s5
    80005424:	02092683          	lw	a3,32(s2)
    80005428:	01698633          	add	a2,s3,s6
    8000542c:	4585                	li	a1,1
    8000542e:	01893503          	ld	a0,24(s2)
    80005432:	fffff097          	auipc	ra,0xfffff
    80005436:	270080e7          	jalr	624(ra) # 800046a2 <writei>
    8000543a:	84aa                	mv	s1,a0
    8000543c:	00a05763          	blez	a0,8000544a <filewrite+0xc4>
        f->off += r;
    80005440:	02092783          	lw	a5,32(s2)
    80005444:	9fa9                	addw	a5,a5,a0
    80005446:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000544a:	01893503          	ld	a0,24(s2)
    8000544e:	fffff097          	auipc	ra,0xfffff
    80005452:	f6a080e7          	jalr	-150(ra) # 800043b8 <iunlock>
      end_op();
    80005456:	00000097          	auipc	ra,0x0
    8000545a:	8ea080e7          	jalr	-1814(ra) # 80004d40 <end_op>

      if(r != n1){
    8000545e:	009a9f63          	bne	s5,s1,8000547c <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80005462:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80005466:	0149db63          	bge	s3,s4,8000547c <filewrite+0xf6>
      int n1 = n - i;
    8000546a:	413a04bb          	subw	s1,s4,s3
    8000546e:	0004879b          	sext.w	a5,s1
    80005472:	f8fbdce3          	bge	s7,a5,8000540a <filewrite+0x84>
    80005476:	84e2                	mv	s1,s8
    80005478:	bf49                	j	8000540a <filewrite+0x84>
    int i = 0;
    8000547a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    8000547c:	013a1f63          	bne	s4,s3,8000549a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80005480:	8552                	mv	a0,s4
    80005482:	60a6                	ld	ra,72(sp)
    80005484:	6406                	ld	s0,64(sp)
    80005486:	74e2                	ld	s1,56(sp)
    80005488:	7942                	ld	s2,48(sp)
    8000548a:	79a2                	ld	s3,40(sp)
    8000548c:	7a02                	ld	s4,32(sp)
    8000548e:	6ae2                	ld	s5,24(sp)
    80005490:	6b42                	ld	s6,16(sp)
    80005492:	6ba2                	ld	s7,8(sp)
    80005494:	6c02                	ld	s8,0(sp)
    80005496:	6161                	addi	sp,sp,80
    80005498:	8082                	ret
    ret = (i == n ? n : -1);
    8000549a:	5a7d                	li	s4,-1
    8000549c:	b7d5                	j	80005480 <filewrite+0xfa>
    panic("filewrite");
    8000549e:	00004517          	auipc	a0,0x4
    800054a2:	39250513          	addi	a0,a0,914 # 80009830 <syscalls+0x298>
    800054a6:	ffffb097          	auipc	ra,0xffffb
    800054aa:	09a080e7          	jalr	154(ra) # 80000540 <panic>
    return -1;
    800054ae:	5a7d                	li	s4,-1
    800054b0:	bfc1                	j	80005480 <filewrite+0xfa>
      return -1;
    800054b2:	5a7d                	li	s4,-1
    800054b4:	b7f1                	j	80005480 <filewrite+0xfa>
    800054b6:	5a7d                	li	s4,-1
    800054b8:	b7e1                	j	80005480 <filewrite+0xfa>

00000000800054ba <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800054ba:	7179                	addi	sp,sp,-48
    800054bc:	f406                	sd	ra,40(sp)
    800054be:	f022                	sd	s0,32(sp)
    800054c0:	ec26                	sd	s1,24(sp)
    800054c2:	e84a                	sd	s2,16(sp)
    800054c4:	e44e                	sd	s3,8(sp)
    800054c6:	e052                	sd	s4,0(sp)
    800054c8:	1800                	addi	s0,sp,48
    800054ca:	84aa                	mv	s1,a0
    800054cc:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800054ce:	0005b023          	sd	zero,0(a1)
    800054d2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800054d6:	00000097          	auipc	ra,0x0
    800054da:	bf8080e7          	jalr	-1032(ra) # 800050ce <filealloc>
    800054de:	e088                	sd	a0,0(s1)
    800054e0:	c551                	beqz	a0,8000556c <pipealloc+0xb2>
    800054e2:	00000097          	auipc	ra,0x0
    800054e6:	bec080e7          	jalr	-1044(ra) # 800050ce <filealloc>
    800054ea:	00aa3023          	sd	a0,0(s4)
    800054ee:	c92d                	beqz	a0,80005560 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800054f0:	ffffb097          	auipc	ra,0xffffb
    800054f4:	70a080e7          	jalr	1802(ra) # 80000bfa <kalloc>
    800054f8:	892a                	mv	s2,a0
    800054fa:	c125                	beqz	a0,8000555a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800054fc:	4985                	li	s3,1
    800054fe:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80005502:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80005506:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000550a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000550e:	00004597          	auipc	a1,0x4
    80005512:	f9a58593          	addi	a1,a1,-102 # 800094a8 <states.0+0x1b8>
    80005516:	ffffb097          	auipc	ra,0xffffb
    8000551a:	74e080e7          	jalr	1870(ra) # 80000c64 <initlock>
  (*f0)->type = FD_PIPE;
    8000551e:	609c                	ld	a5,0(s1)
    80005520:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80005524:	609c                	ld	a5,0(s1)
    80005526:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000552a:	609c                	ld	a5,0(s1)
    8000552c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80005530:	609c                	ld	a5,0(s1)
    80005532:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80005536:	000a3783          	ld	a5,0(s4)
    8000553a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000553e:	000a3783          	ld	a5,0(s4)
    80005542:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80005546:	000a3783          	ld	a5,0(s4)
    8000554a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000554e:	000a3783          	ld	a5,0(s4)
    80005552:	0127b823          	sd	s2,16(a5)
  return 0;
    80005556:	4501                	li	a0,0
    80005558:	a025                	j	80005580 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000555a:	6088                	ld	a0,0(s1)
    8000555c:	e501                	bnez	a0,80005564 <pipealloc+0xaa>
    8000555e:	a039                	j	8000556c <pipealloc+0xb2>
    80005560:	6088                	ld	a0,0(s1)
    80005562:	c51d                	beqz	a0,80005590 <pipealloc+0xd6>
    fileclose(*f0);
    80005564:	00000097          	auipc	ra,0x0
    80005568:	c26080e7          	jalr	-986(ra) # 8000518a <fileclose>
  if(*f1)
    8000556c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80005570:	557d                	li	a0,-1
  if(*f1)
    80005572:	c799                	beqz	a5,80005580 <pipealloc+0xc6>
    fileclose(*f1);
    80005574:	853e                	mv	a0,a5
    80005576:	00000097          	auipc	ra,0x0
    8000557a:	c14080e7          	jalr	-1004(ra) # 8000518a <fileclose>
  return -1;
    8000557e:	557d                	li	a0,-1
}
    80005580:	70a2                	ld	ra,40(sp)
    80005582:	7402                	ld	s0,32(sp)
    80005584:	64e2                	ld	s1,24(sp)
    80005586:	6942                	ld	s2,16(sp)
    80005588:	69a2                	ld	s3,8(sp)
    8000558a:	6a02                	ld	s4,0(sp)
    8000558c:	6145                	addi	sp,sp,48
    8000558e:	8082                	ret
  return -1;
    80005590:	557d                	li	a0,-1
    80005592:	b7fd                	j	80005580 <pipealloc+0xc6>

0000000080005594 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005594:	1101                	addi	sp,sp,-32
    80005596:	ec06                	sd	ra,24(sp)
    80005598:	e822                	sd	s0,16(sp)
    8000559a:	e426                	sd	s1,8(sp)
    8000559c:	e04a                	sd	s2,0(sp)
    8000559e:	1000                	addi	s0,sp,32
    800055a0:	84aa                	mv	s1,a0
    800055a2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800055a4:	ffffb097          	auipc	ra,0xffffb
    800055a8:	750080e7          	jalr	1872(ra) # 80000cf4 <acquire>
  if(writable){
    800055ac:	02090d63          	beqz	s2,800055e6 <pipeclose+0x52>
    pi->writeopen = 0;
    800055b0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800055b4:	21848513          	addi	a0,s1,536
    800055b8:	ffffd097          	auipc	ra,0xffffd
    800055bc:	f50080e7          	jalr	-176(ra) # 80002508 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800055c0:	2204b783          	ld	a5,544(s1)
    800055c4:	eb95                	bnez	a5,800055f8 <pipeclose+0x64>
    release(&pi->lock);
    800055c6:	8526                	mv	a0,s1
    800055c8:	ffffb097          	auipc	ra,0xffffb
    800055cc:	7e0080e7          	jalr	2016(ra) # 80000da8 <release>
    kfree((char*)pi);
    800055d0:	8526                	mv	a0,s1
    800055d2:	ffffb097          	auipc	ra,0xffffb
    800055d6:	480080e7          	jalr	1152(ra) # 80000a52 <kfree>
  } else
    release(&pi->lock);
}
    800055da:	60e2                	ld	ra,24(sp)
    800055dc:	6442                	ld	s0,16(sp)
    800055de:	64a2                	ld	s1,8(sp)
    800055e0:	6902                	ld	s2,0(sp)
    800055e2:	6105                	addi	sp,sp,32
    800055e4:	8082                	ret
    pi->readopen = 0;
    800055e6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800055ea:	21c48513          	addi	a0,s1,540
    800055ee:	ffffd097          	auipc	ra,0xffffd
    800055f2:	f1a080e7          	jalr	-230(ra) # 80002508 <wakeup>
    800055f6:	b7e9                	j	800055c0 <pipeclose+0x2c>
    release(&pi->lock);
    800055f8:	8526                	mv	a0,s1
    800055fa:	ffffb097          	auipc	ra,0xffffb
    800055fe:	7ae080e7          	jalr	1966(ra) # 80000da8 <release>
}
    80005602:	bfe1                	j	800055da <pipeclose+0x46>

0000000080005604 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005604:	711d                	addi	sp,sp,-96
    80005606:	ec86                	sd	ra,88(sp)
    80005608:	e8a2                	sd	s0,80(sp)
    8000560a:	e4a6                	sd	s1,72(sp)
    8000560c:	e0ca                	sd	s2,64(sp)
    8000560e:	fc4e                	sd	s3,56(sp)
    80005610:	f852                	sd	s4,48(sp)
    80005612:	f456                	sd	s5,40(sp)
    80005614:	f05a                	sd	s6,32(sp)
    80005616:	ec5e                	sd	s7,24(sp)
    80005618:	e862                	sd	s8,16(sp)
    8000561a:	1080                	addi	s0,sp,96
    8000561c:	84aa                	mv	s1,a0
    8000561e:	8aae                	mv	s5,a1
    80005620:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80005622:	ffffc097          	auipc	ra,0xffffc
    80005626:	4ee080e7          	jalr	1262(ra) # 80001b10 <myproc>
    8000562a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000562c:	8526                	mv	a0,s1
    8000562e:	ffffb097          	auipc	ra,0xffffb
    80005632:	6c6080e7          	jalr	1734(ra) # 80000cf4 <acquire>
  while(i < n){
    80005636:	0b405663          	blez	s4,800056e2 <pipewrite+0xde>
  int i = 0;
    8000563a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000563c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000563e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005642:	21c48b93          	addi	s7,s1,540
    80005646:	a089                	j	80005688 <pipewrite+0x84>
      release(&pi->lock);
    80005648:	8526                	mv	a0,s1
    8000564a:	ffffb097          	auipc	ra,0xffffb
    8000564e:	75e080e7          	jalr	1886(ra) # 80000da8 <release>
      return -1;
    80005652:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80005654:	854a                	mv	a0,s2
    80005656:	60e6                	ld	ra,88(sp)
    80005658:	6446                	ld	s0,80(sp)
    8000565a:	64a6                	ld	s1,72(sp)
    8000565c:	6906                	ld	s2,64(sp)
    8000565e:	79e2                	ld	s3,56(sp)
    80005660:	7a42                	ld	s4,48(sp)
    80005662:	7aa2                	ld	s5,40(sp)
    80005664:	7b02                	ld	s6,32(sp)
    80005666:	6be2                	ld	s7,24(sp)
    80005668:	6c42                	ld	s8,16(sp)
    8000566a:	6125                	addi	sp,sp,96
    8000566c:	8082                	ret
      wakeup(&pi->nread);
    8000566e:	8562                	mv	a0,s8
    80005670:	ffffd097          	auipc	ra,0xffffd
    80005674:	e98080e7          	jalr	-360(ra) # 80002508 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80005678:	85a6                	mv	a1,s1
    8000567a:	855e                	mv	a0,s7
    8000567c:	ffffd097          	auipc	ra,0xffffd
    80005680:	e28080e7          	jalr	-472(ra) # 800024a4 <sleep>
  while(i < n){
    80005684:	07495063          	bge	s2,s4,800056e4 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80005688:	2204a783          	lw	a5,544(s1)
    8000568c:	dfd5                	beqz	a5,80005648 <pipewrite+0x44>
    8000568e:	854e                	mv	a0,s3
    80005690:	ffffd097          	auipc	ra,0xffffd
    80005694:	096080e7          	jalr	150(ra) # 80002726 <killed>
    80005698:	f945                	bnez	a0,80005648 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000569a:	2184a783          	lw	a5,536(s1)
    8000569e:	21c4a703          	lw	a4,540(s1)
    800056a2:	2007879b          	addiw	a5,a5,512
    800056a6:	fcf704e3          	beq	a4,a5,8000566e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800056aa:	4685                	li	a3,1
    800056ac:	01590633          	add	a2,s2,s5
    800056b0:	faf40593          	addi	a1,s0,-81
    800056b4:	0989b503          	ld	a0,152(s3)
    800056b8:	ffffc097          	auipc	ra,0xffffc
    800056bc:	1a4080e7          	jalr	420(ra) # 8000185c <copyin>
    800056c0:	03650263          	beq	a0,s6,800056e4 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800056c4:	21c4a783          	lw	a5,540(s1)
    800056c8:	0017871b          	addiw	a4,a5,1
    800056cc:	20e4ae23          	sw	a4,540(s1)
    800056d0:	1ff7f793          	andi	a5,a5,511
    800056d4:	97a6                	add	a5,a5,s1
    800056d6:	faf44703          	lbu	a4,-81(s0)
    800056da:	00e78c23          	sb	a4,24(a5)
      i++;
    800056de:	2905                	addiw	s2,s2,1
    800056e0:	b755                	j	80005684 <pipewrite+0x80>
  int i = 0;
    800056e2:	4901                	li	s2,0
  wakeup(&pi->nread);
    800056e4:	21848513          	addi	a0,s1,536
    800056e8:	ffffd097          	auipc	ra,0xffffd
    800056ec:	e20080e7          	jalr	-480(ra) # 80002508 <wakeup>
  release(&pi->lock);
    800056f0:	8526                	mv	a0,s1
    800056f2:	ffffb097          	auipc	ra,0xffffb
    800056f6:	6b6080e7          	jalr	1718(ra) # 80000da8 <release>
  return i;
    800056fa:	bfa9                	j	80005654 <pipewrite+0x50>

00000000800056fc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800056fc:	715d                	addi	sp,sp,-80
    800056fe:	e486                	sd	ra,72(sp)
    80005700:	e0a2                	sd	s0,64(sp)
    80005702:	fc26                	sd	s1,56(sp)
    80005704:	f84a                	sd	s2,48(sp)
    80005706:	f44e                	sd	s3,40(sp)
    80005708:	f052                	sd	s4,32(sp)
    8000570a:	ec56                	sd	s5,24(sp)
    8000570c:	e85a                	sd	s6,16(sp)
    8000570e:	0880                	addi	s0,sp,80
    80005710:	84aa                	mv	s1,a0
    80005712:	892e                	mv	s2,a1
    80005714:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005716:	ffffc097          	auipc	ra,0xffffc
    8000571a:	3fa080e7          	jalr	1018(ra) # 80001b10 <myproc>
    8000571e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005720:	8526                	mv	a0,s1
    80005722:	ffffb097          	auipc	ra,0xffffb
    80005726:	5d2080e7          	jalr	1490(ra) # 80000cf4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000572a:	2184a703          	lw	a4,536(s1)
    8000572e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005732:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005736:	02f71763          	bne	a4,a5,80005764 <piperead+0x68>
    8000573a:	2244a783          	lw	a5,548(s1)
    8000573e:	c39d                	beqz	a5,80005764 <piperead+0x68>
    if(killed(pr)){
    80005740:	8552                	mv	a0,s4
    80005742:	ffffd097          	auipc	ra,0xffffd
    80005746:	fe4080e7          	jalr	-28(ra) # 80002726 <killed>
    8000574a:	e949                	bnez	a0,800057dc <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000574c:	85a6                	mv	a1,s1
    8000574e:	854e                	mv	a0,s3
    80005750:	ffffd097          	auipc	ra,0xffffd
    80005754:	d54080e7          	jalr	-684(ra) # 800024a4 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005758:	2184a703          	lw	a4,536(s1)
    8000575c:	21c4a783          	lw	a5,540(s1)
    80005760:	fcf70de3          	beq	a4,a5,8000573a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005764:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005766:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005768:	05505463          	blez	s5,800057b0 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    8000576c:	2184a783          	lw	a5,536(s1)
    80005770:	21c4a703          	lw	a4,540(s1)
    80005774:	02f70e63          	beq	a4,a5,800057b0 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005778:	0017871b          	addiw	a4,a5,1
    8000577c:	20e4ac23          	sw	a4,536(s1)
    80005780:	1ff7f793          	andi	a5,a5,511
    80005784:	97a6                	add	a5,a5,s1
    80005786:	0187c783          	lbu	a5,24(a5)
    8000578a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000578e:	4685                	li	a3,1
    80005790:	fbf40613          	addi	a2,s0,-65
    80005794:	85ca                	mv	a1,s2
    80005796:	098a3503          	ld	a0,152(s4)
    8000579a:	ffffc097          	auipc	ra,0xffffc
    8000579e:	ffe080e7          	jalr	-2(ra) # 80001798 <copyout>
    800057a2:	01650763          	beq	a0,s6,800057b0 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800057a6:	2985                	addiw	s3,s3,1
    800057a8:	0905                	addi	s2,s2,1
    800057aa:	fd3a91e3          	bne	s5,s3,8000576c <piperead+0x70>
    800057ae:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800057b0:	21c48513          	addi	a0,s1,540
    800057b4:	ffffd097          	auipc	ra,0xffffd
    800057b8:	d54080e7          	jalr	-684(ra) # 80002508 <wakeup>
  release(&pi->lock);
    800057bc:	8526                	mv	a0,s1
    800057be:	ffffb097          	auipc	ra,0xffffb
    800057c2:	5ea080e7          	jalr	1514(ra) # 80000da8 <release>
  return i;
}
    800057c6:	854e                	mv	a0,s3
    800057c8:	60a6                	ld	ra,72(sp)
    800057ca:	6406                	ld	s0,64(sp)
    800057cc:	74e2                	ld	s1,56(sp)
    800057ce:	7942                	ld	s2,48(sp)
    800057d0:	79a2                	ld	s3,40(sp)
    800057d2:	7a02                	ld	s4,32(sp)
    800057d4:	6ae2                	ld	s5,24(sp)
    800057d6:	6b42                	ld	s6,16(sp)
    800057d8:	6161                	addi	sp,sp,80
    800057da:	8082                	ret
      release(&pi->lock);
    800057dc:	8526                	mv	a0,s1
    800057de:	ffffb097          	auipc	ra,0xffffb
    800057e2:	5ca080e7          	jalr	1482(ra) # 80000da8 <release>
      return -1;
    800057e6:	59fd                	li	s3,-1
    800057e8:	bff9                	j	800057c6 <piperead+0xca>

00000000800057ea <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800057ea:	1141                	addi	sp,sp,-16
    800057ec:	e422                	sd	s0,8(sp)
    800057ee:	0800                	addi	s0,sp,16
    800057f0:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800057f2:	8905                	andi	a0,a0,1
    800057f4:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800057f6:	8b89                	andi	a5,a5,2
    800057f8:	c399                	beqz	a5,800057fe <flags2perm+0x14>
      perm |= PTE_W;
    800057fa:	00456513          	ori	a0,a0,4
    return perm;
}
    800057fe:	6422                	ld	s0,8(sp)
    80005800:	0141                	addi	sp,sp,16
    80005802:	8082                	ret

0000000080005804 <exec>:

int
exec(char *path, char **argv)
{
    80005804:	de010113          	addi	sp,sp,-544
    80005808:	20113c23          	sd	ra,536(sp)
    8000580c:	20813823          	sd	s0,528(sp)
    80005810:	20913423          	sd	s1,520(sp)
    80005814:	21213023          	sd	s2,512(sp)
    80005818:	ffce                	sd	s3,504(sp)
    8000581a:	fbd2                	sd	s4,496(sp)
    8000581c:	f7d6                	sd	s5,488(sp)
    8000581e:	f3da                	sd	s6,480(sp)
    80005820:	efde                	sd	s7,472(sp)
    80005822:	ebe2                	sd	s8,464(sp)
    80005824:	e7e6                	sd	s9,456(sp)
    80005826:	e3ea                	sd	s10,448(sp)
    80005828:	ff6e                	sd	s11,440(sp)
    8000582a:	1400                	addi	s0,sp,544
    8000582c:	892a                	mv	s2,a0
    8000582e:	dea43423          	sd	a0,-536(s0)
    80005832:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005836:	ffffc097          	auipc	ra,0xffffc
    8000583a:	2da080e7          	jalr	730(ra) # 80001b10 <myproc>
    8000583e:	84aa                	mv	s1,a0

  begin_op();
    80005840:	fffff097          	auipc	ra,0xfffff
    80005844:	482080e7          	jalr	1154(ra) # 80004cc2 <begin_op>

  if((ip = namei(path)) == 0){
    80005848:	854a                	mv	a0,s2
    8000584a:	fffff097          	auipc	ra,0xfffff
    8000584e:	258080e7          	jalr	600(ra) # 80004aa2 <namei>
    80005852:	c93d                	beqz	a0,800058c8 <exec+0xc4>
    80005854:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005856:	fffff097          	auipc	ra,0xfffff
    8000585a:	aa0080e7          	jalr	-1376(ra) # 800042f6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000585e:	04000713          	li	a4,64
    80005862:	4681                	li	a3,0
    80005864:	e5040613          	addi	a2,s0,-432
    80005868:	4581                	li	a1,0
    8000586a:	8556                	mv	a0,s5
    8000586c:	fffff097          	auipc	ra,0xfffff
    80005870:	d3e080e7          	jalr	-706(ra) # 800045aa <readi>
    80005874:	04000793          	li	a5,64
    80005878:	00f51a63          	bne	a0,a5,8000588c <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000587c:	e5042703          	lw	a4,-432(s0)
    80005880:	464c47b7          	lui	a5,0x464c4
    80005884:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005888:	04f70663          	beq	a4,a5,800058d4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000588c:	8556                	mv	a0,s5
    8000588e:	fffff097          	auipc	ra,0xfffff
    80005892:	cca080e7          	jalr	-822(ra) # 80004558 <iunlockput>
    end_op();
    80005896:	fffff097          	auipc	ra,0xfffff
    8000589a:	4aa080e7          	jalr	1194(ra) # 80004d40 <end_op>
  }
  return -1;
    8000589e:	557d                	li	a0,-1
}
    800058a0:	21813083          	ld	ra,536(sp)
    800058a4:	21013403          	ld	s0,528(sp)
    800058a8:	20813483          	ld	s1,520(sp)
    800058ac:	20013903          	ld	s2,512(sp)
    800058b0:	79fe                	ld	s3,504(sp)
    800058b2:	7a5e                	ld	s4,496(sp)
    800058b4:	7abe                	ld	s5,488(sp)
    800058b6:	7b1e                	ld	s6,480(sp)
    800058b8:	6bfe                	ld	s7,472(sp)
    800058ba:	6c5e                	ld	s8,464(sp)
    800058bc:	6cbe                	ld	s9,456(sp)
    800058be:	6d1e                	ld	s10,448(sp)
    800058c0:	7dfa                	ld	s11,440(sp)
    800058c2:	22010113          	addi	sp,sp,544
    800058c6:	8082                	ret
    end_op();
    800058c8:	fffff097          	auipc	ra,0xfffff
    800058cc:	478080e7          	jalr	1144(ra) # 80004d40 <end_op>
    return -1;
    800058d0:	557d                	li	a0,-1
    800058d2:	b7f9                	j	800058a0 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800058d4:	8526                	mv	a0,s1
    800058d6:	ffffc097          	auipc	ra,0xffffc
    800058da:	2fe080e7          	jalr	766(ra) # 80001bd4 <proc_pagetable>
    800058de:	8b2a                	mv	s6,a0
    800058e0:	d555                	beqz	a0,8000588c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800058e2:	e7042783          	lw	a5,-400(s0)
    800058e6:	e8845703          	lhu	a4,-376(s0)
    800058ea:	c735                	beqz	a4,80005956 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800058ec:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800058ee:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800058f2:	6a05                	lui	s4,0x1
    800058f4:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800058f8:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800058fc:	6d85                	lui	s11,0x1
    800058fe:	7d7d                	lui	s10,0xfffff
    80005900:	ac3d                	j	80005b3e <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80005902:	00004517          	auipc	a0,0x4
    80005906:	f3e50513          	addi	a0,a0,-194 # 80009840 <syscalls+0x2a8>
    8000590a:	ffffb097          	auipc	ra,0xffffb
    8000590e:	c36080e7          	jalr	-970(ra) # 80000540 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005912:	874a                	mv	a4,s2
    80005914:	009c86bb          	addw	a3,s9,s1
    80005918:	4581                	li	a1,0
    8000591a:	8556                	mv	a0,s5
    8000591c:	fffff097          	auipc	ra,0xfffff
    80005920:	c8e080e7          	jalr	-882(ra) # 800045aa <readi>
    80005924:	2501                	sext.w	a0,a0
    80005926:	1aa91963          	bne	s2,a0,80005ad8 <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    8000592a:	009d84bb          	addw	s1,s11,s1
    8000592e:	013d09bb          	addw	s3,s10,s3
    80005932:	1f74f663          	bgeu	s1,s7,80005b1e <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    80005936:	02049593          	slli	a1,s1,0x20
    8000593a:	9181                	srli	a1,a1,0x20
    8000593c:	95e2                	add	a1,a1,s8
    8000593e:	855a                	mv	a0,s6
    80005940:	ffffc097          	auipc	ra,0xffffc
    80005944:	842080e7          	jalr	-1982(ra) # 80001182 <walkaddr>
    80005948:	862a                	mv	a2,a0
    if(pa == 0)
    8000594a:	dd45                	beqz	a0,80005902 <exec+0xfe>
      n = PGSIZE;
    8000594c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000594e:	fd49f2e3          	bgeu	s3,s4,80005912 <exec+0x10e>
      n = sz - i;
    80005952:	894e                	mv	s2,s3
    80005954:	bf7d                	j	80005912 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005956:	4901                	li	s2,0
  iunlockput(ip);
    80005958:	8556                	mv	a0,s5
    8000595a:	fffff097          	auipc	ra,0xfffff
    8000595e:	bfe080e7          	jalr	-1026(ra) # 80004558 <iunlockput>
  end_op();
    80005962:	fffff097          	auipc	ra,0xfffff
    80005966:	3de080e7          	jalr	990(ra) # 80004d40 <end_op>
  p = myproc();
    8000596a:	ffffc097          	auipc	ra,0xffffc
    8000596e:	1a6080e7          	jalr	422(ra) # 80001b10 <myproc>
    80005972:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80005974:	09053d03          	ld	s10,144(a0)
  sz = PGROUNDUP(sz);
    80005978:	6785                	lui	a5,0x1
    8000597a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000597c:	97ca                	add	a5,a5,s2
    8000597e:	777d                	lui	a4,0xfffff
    80005980:	8ff9                	and	a5,a5,a4
    80005982:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005986:	4691                	li	a3,4
    80005988:	6609                	lui	a2,0x2
    8000598a:	963e                	add	a2,a2,a5
    8000598c:	85be                	mv	a1,a5
    8000598e:	855a                	mv	a0,s6
    80005990:	ffffc097          	auipc	ra,0xffffc
    80005994:	ba6080e7          	jalr	-1114(ra) # 80001536 <uvmalloc>
    80005998:	8c2a                	mv	s8,a0
  ip = 0;
    8000599a:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000599c:	12050e63          	beqz	a0,80005ad8 <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    800059a0:	75f9                	lui	a1,0xffffe
    800059a2:	95aa                	add	a1,a1,a0
    800059a4:	855a                	mv	a0,s6
    800059a6:	ffffc097          	auipc	ra,0xffffc
    800059aa:	dc0080e7          	jalr	-576(ra) # 80001766 <uvmclear>
  stackbase = sp - PGSIZE;
    800059ae:	7afd                	lui	s5,0xfffff
    800059b0:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800059b2:	df043783          	ld	a5,-528(s0)
    800059b6:	6388                	ld	a0,0(a5)
    800059b8:	c925                	beqz	a0,80005a28 <exec+0x224>
    800059ba:	e9040993          	addi	s3,s0,-368
    800059be:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800059c2:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800059c4:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800059c6:	ffffb097          	auipc	ra,0xffffb
    800059ca:	5a6080e7          	jalr	1446(ra) # 80000f6c <strlen>
    800059ce:	0015079b          	addiw	a5,a0,1
    800059d2:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800059d6:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800059da:	13596663          	bltu	s2,s5,80005b06 <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800059de:	df043d83          	ld	s11,-528(s0)
    800059e2:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800059e6:	8552                	mv	a0,s4
    800059e8:	ffffb097          	auipc	ra,0xffffb
    800059ec:	584080e7          	jalr	1412(ra) # 80000f6c <strlen>
    800059f0:	0015069b          	addiw	a3,a0,1
    800059f4:	8652                	mv	a2,s4
    800059f6:	85ca                	mv	a1,s2
    800059f8:	855a                	mv	a0,s6
    800059fa:	ffffc097          	auipc	ra,0xffffc
    800059fe:	d9e080e7          	jalr	-610(ra) # 80001798 <copyout>
    80005a02:	10054663          	bltz	a0,80005b0e <exec+0x30a>
    ustack[argc] = sp;
    80005a06:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005a0a:	0485                	addi	s1,s1,1
    80005a0c:	008d8793          	addi	a5,s11,8
    80005a10:	def43823          	sd	a5,-528(s0)
    80005a14:	008db503          	ld	a0,8(s11)
    80005a18:	c911                	beqz	a0,80005a2c <exec+0x228>
    if(argc >= MAXARG)
    80005a1a:	09a1                	addi	s3,s3,8
    80005a1c:	fb3c95e3          	bne	s9,s3,800059c6 <exec+0x1c2>
  sz = sz1;
    80005a20:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005a24:	4a81                	li	s5,0
    80005a26:	a84d                	j	80005ad8 <exec+0x2d4>
  sp = sz;
    80005a28:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005a2a:	4481                	li	s1,0
  ustack[argc] = 0;
    80005a2c:	00349793          	slli	a5,s1,0x3
    80005a30:	f9078793          	addi	a5,a5,-112
    80005a34:	97a2                	add	a5,a5,s0
    80005a36:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005a3a:	00148693          	addi	a3,s1,1
    80005a3e:	068e                	slli	a3,a3,0x3
    80005a40:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005a44:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80005a48:	01597663          	bgeu	s2,s5,80005a54 <exec+0x250>
  sz = sz1;
    80005a4c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005a50:	4a81                	li	s5,0
    80005a52:	a059                	j	80005ad8 <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005a54:	e9040613          	addi	a2,s0,-368
    80005a58:	85ca                	mv	a1,s2
    80005a5a:	855a                	mv	a0,s6
    80005a5c:	ffffc097          	auipc	ra,0xffffc
    80005a60:	d3c080e7          	jalr	-708(ra) # 80001798 <copyout>
    80005a64:	0a054963          	bltz	a0,80005b16 <exec+0x312>
  p->trapframe->a1 = sp;
    80005a68:	0a0bb783          	ld	a5,160(s7)
    80005a6c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005a70:	de843783          	ld	a5,-536(s0)
    80005a74:	0007c703          	lbu	a4,0(a5)
    80005a78:	cf11                	beqz	a4,80005a94 <exec+0x290>
    80005a7a:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005a7c:	02f00693          	li	a3,47
    80005a80:	a039                	j	80005a8e <exec+0x28a>
      last = s+1;
    80005a82:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005a86:	0785                	addi	a5,a5,1
    80005a88:	fff7c703          	lbu	a4,-1(a5)
    80005a8c:	c701                	beqz	a4,80005a94 <exec+0x290>
    if(*s == '/')
    80005a8e:	fed71ce3          	bne	a4,a3,80005a86 <exec+0x282>
    80005a92:	bfc5                	j	80005a82 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80005a94:	4641                	li	a2,16
    80005a96:	de843583          	ld	a1,-536(s0)
    80005a9a:	1a0b8513          	addi	a0,s7,416
    80005a9e:	ffffb097          	auipc	ra,0xffffb
    80005aa2:	49c080e7          	jalr	1180(ra) # 80000f3a <safestrcpy>
  oldpagetable = p->pagetable;
    80005aa6:	098bb503          	ld	a0,152(s7)
  p->pagetable = pagetable;
    80005aaa:	096bbc23          	sd	s6,152(s7)
  p->sz = sz;
    80005aae:	098bb823          	sd	s8,144(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005ab2:	0a0bb783          	ld	a5,160(s7)
    80005ab6:	e6843703          	ld	a4,-408(s0)
    80005aba:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005abc:	0a0bb783          	ld	a5,160(s7)
    80005ac0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005ac4:	85ea                	mv	a1,s10
    80005ac6:	ffffc097          	auipc	ra,0xffffc
    80005aca:	1aa080e7          	jalr	426(ra) # 80001c70 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005ace:	0004851b          	sext.w	a0,s1
    80005ad2:	b3f9                	j	800058a0 <exec+0x9c>
    80005ad4:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005ad8:	df843583          	ld	a1,-520(s0)
    80005adc:	855a                	mv	a0,s6
    80005ade:	ffffc097          	auipc	ra,0xffffc
    80005ae2:	192080e7          	jalr	402(ra) # 80001c70 <proc_freepagetable>
  if(ip){
    80005ae6:	da0a93e3          	bnez	s5,8000588c <exec+0x88>
  return -1;
    80005aea:	557d                	li	a0,-1
    80005aec:	bb55                	j	800058a0 <exec+0x9c>
    80005aee:	df243c23          	sd	s2,-520(s0)
    80005af2:	b7dd                	j	80005ad8 <exec+0x2d4>
    80005af4:	df243c23          	sd	s2,-520(s0)
    80005af8:	b7c5                	j	80005ad8 <exec+0x2d4>
    80005afa:	df243c23          	sd	s2,-520(s0)
    80005afe:	bfe9                	j	80005ad8 <exec+0x2d4>
    80005b00:	df243c23          	sd	s2,-520(s0)
    80005b04:	bfd1                	j	80005ad8 <exec+0x2d4>
  sz = sz1;
    80005b06:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005b0a:	4a81                	li	s5,0
    80005b0c:	b7f1                	j	80005ad8 <exec+0x2d4>
  sz = sz1;
    80005b0e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005b12:	4a81                	li	s5,0
    80005b14:	b7d1                	j	80005ad8 <exec+0x2d4>
  sz = sz1;
    80005b16:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005b1a:	4a81                	li	s5,0
    80005b1c:	bf75                	j	80005ad8 <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005b1e:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005b22:	e0843783          	ld	a5,-504(s0)
    80005b26:	0017869b          	addiw	a3,a5,1
    80005b2a:	e0d43423          	sd	a3,-504(s0)
    80005b2e:	e0043783          	ld	a5,-512(s0)
    80005b32:	0387879b          	addiw	a5,a5,56
    80005b36:	e8845703          	lhu	a4,-376(s0)
    80005b3a:	e0e6dfe3          	bge	a3,a4,80005958 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005b3e:	2781                	sext.w	a5,a5
    80005b40:	e0f43023          	sd	a5,-512(s0)
    80005b44:	03800713          	li	a4,56
    80005b48:	86be                	mv	a3,a5
    80005b4a:	e1840613          	addi	a2,s0,-488
    80005b4e:	4581                	li	a1,0
    80005b50:	8556                	mv	a0,s5
    80005b52:	fffff097          	auipc	ra,0xfffff
    80005b56:	a58080e7          	jalr	-1448(ra) # 800045aa <readi>
    80005b5a:	03800793          	li	a5,56
    80005b5e:	f6f51be3          	bne	a0,a5,80005ad4 <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    80005b62:	e1842783          	lw	a5,-488(s0)
    80005b66:	4705                	li	a4,1
    80005b68:	fae79de3          	bne	a5,a4,80005b22 <exec+0x31e>
    if(ph.memsz < ph.filesz)
    80005b6c:	e4043483          	ld	s1,-448(s0)
    80005b70:	e3843783          	ld	a5,-456(s0)
    80005b74:	f6f4ede3          	bltu	s1,a5,80005aee <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005b78:	e2843783          	ld	a5,-472(s0)
    80005b7c:	94be                	add	s1,s1,a5
    80005b7e:	f6f4ebe3          	bltu	s1,a5,80005af4 <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    80005b82:	de043703          	ld	a4,-544(s0)
    80005b86:	8ff9                	and	a5,a5,a4
    80005b88:	fbad                	bnez	a5,80005afa <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005b8a:	e1c42503          	lw	a0,-484(s0)
    80005b8e:	00000097          	auipc	ra,0x0
    80005b92:	c5c080e7          	jalr	-932(ra) # 800057ea <flags2perm>
    80005b96:	86aa                	mv	a3,a0
    80005b98:	8626                	mv	a2,s1
    80005b9a:	85ca                	mv	a1,s2
    80005b9c:	855a                	mv	a0,s6
    80005b9e:	ffffc097          	auipc	ra,0xffffc
    80005ba2:	998080e7          	jalr	-1640(ra) # 80001536 <uvmalloc>
    80005ba6:	dea43c23          	sd	a0,-520(s0)
    80005baa:	d939                	beqz	a0,80005b00 <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005bac:	e2843c03          	ld	s8,-472(s0)
    80005bb0:	e2042c83          	lw	s9,-480(s0)
    80005bb4:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005bb8:	f60b83e3          	beqz	s7,80005b1e <exec+0x31a>
    80005bbc:	89de                	mv	s3,s7
    80005bbe:	4481                	li	s1,0
    80005bc0:	bb9d                	j	80005936 <exec+0x132>

0000000080005bc2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005bc2:	7179                	addi	sp,sp,-48
    80005bc4:	f406                	sd	ra,40(sp)
    80005bc6:	f022                	sd	s0,32(sp)
    80005bc8:	ec26                	sd	s1,24(sp)
    80005bca:	e84a                	sd	s2,16(sp)
    80005bcc:	1800                	addi	s0,sp,48
    80005bce:	892e                	mv	s2,a1
    80005bd0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005bd2:	fdc40593          	addi	a1,s0,-36
    80005bd6:	ffffe097          	auipc	ra,0xffffe
    80005bda:	930080e7          	jalr	-1744(ra) # 80003506 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005bde:	fdc42703          	lw	a4,-36(s0)
    80005be2:	47bd                	li	a5,15
    80005be4:	02e7eb63          	bltu	a5,a4,80005c1a <argfd+0x58>
    80005be8:	ffffc097          	auipc	ra,0xffffc
    80005bec:	f28080e7          	jalr	-216(ra) # 80001b10 <myproc>
    80005bf0:	fdc42703          	lw	a4,-36(s0)
    80005bf4:	02270793          	addi	a5,a4,34 # fffffffffffff022 <end+0xffffffff7fdb81da>
    80005bf8:	078e                	slli	a5,a5,0x3
    80005bfa:	953e                	add	a0,a0,a5
    80005bfc:	651c                	ld	a5,8(a0)
    80005bfe:	c385                	beqz	a5,80005c1e <argfd+0x5c>
    return -1;
  if(pfd)
    80005c00:	00090463          	beqz	s2,80005c08 <argfd+0x46>
    *pfd = fd;
    80005c04:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005c08:	4501                	li	a0,0
  if(pf)
    80005c0a:	c091                	beqz	s1,80005c0e <argfd+0x4c>
    *pf = f;
    80005c0c:	e09c                	sd	a5,0(s1)
}
    80005c0e:	70a2                	ld	ra,40(sp)
    80005c10:	7402                	ld	s0,32(sp)
    80005c12:	64e2                	ld	s1,24(sp)
    80005c14:	6942                	ld	s2,16(sp)
    80005c16:	6145                	addi	sp,sp,48
    80005c18:	8082                	ret
    return -1;
    80005c1a:	557d                	li	a0,-1
    80005c1c:	bfcd                	j	80005c0e <argfd+0x4c>
    80005c1e:	557d                	li	a0,-1
    80005c20:	b7fd                	j	80005c0e <argfd+0x4c>

0000000080005c22 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005c22:	1101                	addi	sp,sp,-32
    80005c24:	ec06                	sd	ra,24(sp)
    80005c26:	e822                	sd	s0,16(sp)
    80005c28:	e426                	sd	s1,8(sp)
    80005c2a:	1000                	addi	s0,sp,32
    80005c2c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005c2e:	ffffc097          	auipc	ra,0xffffc
    80005c32:	ee2080e7          	jalr	-286(ra) # 80001b10 <myproc>
    80005c36:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005c38:	11850793          	addi	a5,a0,280
    80005c3c:	4501                	li	a0,0
    80005c3e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005c40:	6398                	ld	a4,0(a5)
    80005c42:	cb19                	beqz	a4,80005c58 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005c44:	2505                	addiw	a0,a0,1
    80005c46:	07a1                	addi	a5,a5,8
    80005c48:	fed51ce3          	bne	a0,a3,80005c40 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005c4c:	557d                	li	a0,-1
}
    80005c4e:	60e2                	ld	ra,24(sp)
    80005c50:	6442                	ld	s0,16(sp)
    80005c52:	64a2                	ld	s1,8(sp)
    80005c54:	6105                	addi	sp,sp,32
    80005c56:	8082                	ret
      p->ofile[fd] = f;
    80005c58:	02250793          	addi	a5,a0,34
    80005c5c:	078e                	slli	a5,a5,0x3
    80005c5e:	963e                	add	a2,a2,a5
    80005c60:	e604                	sd	s1,8(a2)
      return fd;
    80005c62:	b7f5                	j	80005c4e <fdalloc+0x2c>

0000000080005c64 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005c64:	715d                	addi	sp,sp,-80
    80005c66:	e486                	sd	ra,72(sp)
    80005c68:	e0a2                	sd	s0,64(sp)
    80005c6a:	fc26                	sd	s1,56(sp)
    80005c6c:	f84a                	sd	s2,48(sp)
    80005c6e:	f44e                	sd	s3,40(sp)
    80005c70:	f052                	sd	s4,32(sp)
    80005c72:	ec56                	sd	s5,24(sp)
    80005c74:	e85a                	sd	s6,16(sp)
    80005c76:	0880                	addi	s0,sp,80
    80005c78:	8b2e                	mv	s6,a1
    80005c7a:	89b2                	mv	s3,a2
    80005c7c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005c7e:	fb040593          	addi	a1,s0,-80
    80005c82:	fffff097          	auipc	ra,0xfffff
    80005c86:	e3e080e7          	jalr	-450(ra) # 80004ac0 <nameiparent>
    80005c8a:	84aa                	mv	s1,a0
    80005c8c:	14050f63          	beqz	a0,80005dea <create+0x186>
    return 0;

  ilock(dp);
    80005c90:	ffffe097          	auipc	ra,0xffffe
    80005c94:	666080e7          	jalr	1638(ra) # 800042f6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005c98:	4601                	li	a2,0
    80005c9a:	fb040593          	addi	a1,s0,-80
    80005c9e:	8526                	mv	a0,s1
    80005ca0:	fffff097          	auipc	ra,0xfffff
    80005ca4:	b3a080e7          	jalr	-1222(ra) # 800047da <dirlookup>
    80005ca8:	8aaa                	mv	s5,a0
    80005caa:	c931                	beqz	a0,80005cfe <create+0x9a>
    iunlockput(dp);
    80005cac:	8526                	mv	a0,s1
    80005cae:	fffff097          	auipc	ra,0xfffff
    80005cb2:	8aa080e7          	jalr	-1878(ra) # 80004558 <iunlockput>
    ilock(ip);
    80005cb6:	8556                	mv	a0,s5
    80005cb8:	ffffe097          	auipc	ra,0xffffe
    80005cbc:	63e080e7          	jalr	1598(ra) # 800042f6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005cc0:	000b059b          	sext.w	a1,s6
    80005cc4:	4789                	li	a5,2
    80005cc6:	02f59563          	bne	a1,a5,80005cf0 <create+0x8c>
    80005cca:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7fdb81fc>
    80005cce:	37f9                	addiw	a5,a5,-2
    80005cd0:	17c2                	slli	a5,a5,0x30
    80005cd2:	93c1                	srli	a5,a5,0x30
    80005cd4:	4705                	li	a4,1
    80005cd6:	00f76d63          	bltu	a4,a5,80005cf0 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005cda:	8556                	mv	a0,s5
    80005cdc:	60a6                	ld	ra,72(sp)
    80005cde:	6406                	ld	s0,64(sp)
    80005ce0:	74e2                	ld	s1,56(sp)
    80005ce2:	7942                	ld	s2,48(sp)
    80005ce4:	79a2                	ld	s3,40(sp)
    80005ce6:	7a02                	ld	s4,32(sp)
    80005ce8:	6ae2                	ld	s5,24(sp)
    80005cea:	6b42                	ld	s6,16(sp)
    80005cec:	6161                	addi	sp,sp,80
    80005cee:	8082                	ret
    iunlockput(ip);
    80005cf0:	8556                	mv	a0,s5
    80005cf2:	fffff097          	auipc	ra,0xfffff
    80005cf6:	866080e7          	jalr	-1946(ra) # 80004558 <iunlockput>
    return 0;
    80005cfa:	4a81                	li	s5,0
    80005cfc:	bff9                	j	80005cda <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005cfe:	85da                	mv	a1,s6
    80005d00:	4088                	lw	a0,0(s1)
    80005d02:	ffffe097          	auipc	ra,0xffffe
    80005d06:	456080e7          	jalr	1110(ra) # 80004158 <ialloc>
    80005d0a:	8a2a                	mv	s4,a0
    80005d0c:	c539                	beqz	a0,80005d5a <create+0xf6>
  ilock(ip);
    80005d0e:	ffffe097          	auipc	ra,0xffffe
    80005d12:	5e8080e7          	jalr	1512(ra) # 800042f6 <ilock>
  ip->major = major;
    80005d16:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005d1a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005d1e:	4905                	li	s2,1
    80005d20:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005d24:	8552                	mv	a0,s4
    80005d26:	ffffe097          	auipc	ra,0xffffe
    80005d2a:	504080e7          	jalr	1284(ra) # 8000422a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005d2e:	000b059b          	sext.w	a1,s6
    80005d32:	03258b63          	beq	a1,s2,80005d68 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80005d36:	004a2603          	lw	a2,4(s4)
    80005d3a:	fb040593          	addi	a1,s0,-80
    80005d3e:	8526                	mv	a0,s1
    80005d40:	fffff097          	auipc	ra,0xfffff
    80005d44:	cb0080e7          	jalr	-848(ra) # 800049f0 <dirlink>
    80005d48:	06054f63          	bltz	a0,80005dc6 <create+0x162>
  iunlockput(dp);
    80005d4c:	8526                	mv	a0,s1
    80005d4e:	fffff097          	auipc	ra,0xfffff
    80005d52:	80a080e7          	jalr	-2038(ra) # 80004558 <iunlockput>
  return ip;
    80005d56:	8ad2                	mv	s5,s4
    80005d58:	b749                	j	80005cda <create+0x76>
    iunlockput(dp);
    80005d5a:	8526                	mv	a0,s1
    80005d5c:	ffffe097          	auipc	ra,0xffffe
    80005d60:	7fc080e7          	jalr	2044(ra) # 80004558 <iunlockput>
    return 0;
    80005d64:	8ad2                	mv	s5,s4
    80005d66:	bf95                	j	80005cda <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005d68:	004a2603          	lw	a2,4(s4)
    80005d6c:	00004597          	auipc	a1,0x4
    80005d70:	af458593          	addi	a1,a1,-1292 # 80009860 <syscalls+0x2c8>
    80005d74:	8552                	mv	a0,s4
    80005d76:	fffff097          	auipc	ra,0xfffff
    80005d7a:	c7a080e7          	jalr	-902(ra) # 800049f0 <dirlink>
    80005d7e:	04054463          	bltz	a0,80005dc6 <create+0x162>
    80005d82:	40d0                	lw	a2,4(s1)
    80005d84:	00004597          	auipc	a1,0x4
    80005d88:	ae458593          	addi	a1,a1,-1308 # 80009868 <syscalls+0x2d0>
    80005d8c:	8552                	mv	a0,s4
    80005d8e:	fffff097          	auipc	ra,0xfffff
    80005d92:	c62080e7          	jalr	-926(ra) # 800049f0 <dirlink>
    80005d96:	02054863          	bltz	a0,80005dc6 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80005d9a:	004a2603          	lw	a2,4(s4)
    80005d9e:	fb040593          	addi	a1,s0,-80
    80005da2:	8526                	mv	a0,s1
    80005da4:	fffff097          	auipc	ra,0xfffff
    80005da8:	c4c080e7          	jalr	-948(ra) # 800049f0 <dirlink>
    80005dac:	00054d63          	bltz	a0,80005dc6 <create+0x162>
    dp->nlink++;  // for ".."
    80005db0:	04a4d783          	lhu	a5,74(s1)
    80005db4:	2785                	addiw	a5,a5,1
    80005db6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005dba:	8526                	mv	a0,s1
    80005dbc:	ffffe097          	auipc	ra,0xffffe
    80005dc0:	46e080e7          	jalr	1134(ra) # 8000422a <iupdate>
    80005dc4:	b761                	j	80005d4c <create+0xe8>
  ip->nlink = 0;
    80005dc6:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005dca:	8552                	mv	a0,s4
    80005dcc:	ffffe097          	auipc	ra,0xffffe
    80005dd0:	45e080e7          	jalr	1118(ra) # 8000422a <iupdate>
  iunlockput(ip);
    80005dd4:	8552                	mv	a0,s4
    80005dd6:	ffffe097          	auipc	ra,0xffffe
    80005dda:	782080e7          	jalr	1922(ra) # 80004558 <iunlockput>
  iunlockput(dp);
    80005dde:	8526                	mv	a0,s1
    80005de0:	ffffe097          	auipc	ra,0xffffe
    80005de4:	778080e7          	jalr	1912(ra) # 80004558 <iunlockput>
  return 0;
    80005de8:	bdcd                	j	80005cda <create+0x76>
    return 0;
    80005dea:	8aaa                	mv	s5,a0
    80005dec:	b5fd                	j	80005cda <create+0x76>

0000000080005dee <sys_dup>:
{
    80005dee:	7179                	addi	sp,sp,-48
    80005df0:	f406                	sd	ra,40(sp)
    80005df2:	f022                	sd	s0,32(sp)
    80005df4:	ec26                	sd	s1,24(sp)
    80005df6:	e84a                	sd	s2,16(sp)
    80005df8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005dfa:	fd840613          	addi	a2,s0,-40
    80005dfe:	4581                	li	a1,0
    80005e00:	4501                	li	a0,0
    80005e02:	00000097          	auipc	ra,0x0
    80005e06:	dc0080e7          	jalr	-576(ra) # 80005bc2 <argfd>
    return -1;
    80005e0a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005e0c:	02054363          	bltz	a0,80005e32 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80005e10:	fd843903          	ld	s2,-40(s0)
    80005e14:	854a                	mv	a0,s2
    80005e16:	00000097          	auipc	ra,0x0
    80005e1a:	e0c080e7          	jalr	-500(ra) # 80005c22 <fdalloc>
    80005e1e:	84aa                	mv	s1,a0
    return -1;
    80005e20:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005e22:	00054863          	bltz	a0,80005e32 <sys_dup+0x44>
  filedup(f);
    80005e26:	854a                	mv	a0,s2
    80005e28:	fffff097          	auipc	ra,0xfffff
    80005e2c:	310080e7          	jalr	784(ra) # 80005138 <filedup>
  return fd;
    80005e30:	87a6                	mv	a5,s1
}
    80005e32:	853e                	mv	a0,a5
    80005e34:	70a2                	ld	ra,40(sp)
    80005e36:	7402                	ld	s0,32(sp)
    80005e38:	64e2                	ld	s1,24(sp)
    80005e3a:	6942                	ld	s2,16(sp)
    80005e3c:	6145                	addi	sp,sp,48
    80005e3e:	8082                	ret

0000000080005e40 <sys_read>:
{
    80005e40:	7179                	addi	sp,sp,-48
    80005e42:	f406                	sd	ra,40(sp)
    80005e44:	f022                	sd	s0,32(sp)
    80005e46:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005e48:	fd840593          	addi	a1,s0,-40
    80005e4c:	4505                	li	a0,1
    80005e4e:	ffffd097          	auipc	ra,0xffffd
    80005e52:	6d8080e7          	jalr	1752(ra) # 80003526 <argaddr>
  argint(2, &n);
    80005e56:	fe440593          	addi	a1,s0,-28
    80005e5a:	4509                	li	a0,2
    80005e5c:	ffffd097          	auipc	ra,0xffffd
    80005e60:	6aa080e7          	jalr	1706(ra) # 80003506 <argint>
  if(argfd(0, 0, &f) < 0)
    80005e64:	fe840613          	addi	a2,s0,-24
    80005e68:	4581                	li	a1,0
    80005e6a:	4501                	li	a0,0
    80005e6c:	00000097          	auipc	ra,0x0
    80005e70:	d56080e7          	jalr	-682(ra) # 80005bc2 <argfd>
    80005e74:	87aa                	mv	a5,a0
    return -1;
    80005e76:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005e78:	0007cc63          	bltz	a5,80005e90 <sys_read+0x50>
  return fileread(f, p, n);
    80005e7c:	fe442603          	lw	a2,-28(s0)
    80005e80:	fd843583          	ld	a1,-40(s0)
    80005e84:	fe843503          	ld	a0,-24(s0)
    80005e88:	fffff097          	auipc	ra,0xfffff
    80005e8c:	43c080e7          	jalr	1084(ra) # 800052c4 <fileread>
}
    80005e90:	70a2                	ld	ra,40(sp)
    80005e92:	7402                	ld	s0,32(sp)
    80005e94:	6145                	addi	sp,sp,48
    80005e96:	8082                	ret

0000000080005e98 <sys_write>:
{
    80005e98:	7179                	addi	sp,sp,-48
    80005e9a:	f406                	sd	ra,40(sp)
    80005e9c:	f022                	sd	s0,32(sp)
    80005e9e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005ea0:	fd840593          	addi	a1,s0,-40
    80005ea4:	4505                	li	a0,1
    80005ea6:	ffffd097          	auipc	ra,0xffffd
    80005eaa:	680080e7          	jalr	1664(ra) # 80003526 <argaddr>
  argint(2, &n);
    80005eae:	fe440593          	addi	a1,s0,-28
    80005eb2:	4509                	li	a0,2
    80005eb4:	ffffd097          	auipc	ra,0xffffd
    80005eb8:	652080e7          	jalr	1618(ra) # 80003506 <argint>
  if(argfd(0, 0, &f) < 0)
    80005ebc:	fe840613          	addi	a2,s0,-24
    80005ec0:	4581                	li	a1,0
    80005ec2:	4501                	li	a0,0
    80005ec4:	00000097          	auipc	ra,0x0
    80005ec8:	cfe080e7          	jalr	-770(ra) # 80005bc2 <argfd>
    80005ecc:	87aa                	mv	a5,a0
    return -1;
    80005ece:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005ed0:	0007cc63          	bltz	a5,80005ee8 <sys_write+0x50>
  return filewrite(f, p, n);
    80005ed4:	fe442603          	lw	a2,-28(s0)
    80005ed8:	fd843583          	ld	a1,-40(s0)
    80005edc:	fe843503          	ld	a0,-24(s0)
    80005ee0:	fffff097          	auipc	ra,0xfffff
    80005ee4:	4a6080e7          	jalr	1190(ra) # 80005386 <filewrite>
}
    80005ee8:	70a2                	ld	ra,40(sp)
    80005eea:	7402                	ld	s0,32(sp)
    80005eec:	6145                	addi	sp,sp,48
    80005eee:	8082                	ret

0000000080005ef0 <sys_close>:
{
    80005ef0:	1101                	addi	sp,sp,-32
    80005ef2:	ec06                	sd	ra,24(sp)
    80005ef4:	e822                	sd	s0,16(sp)
    80005ef6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005ef8:	fe040613          	addi	a2,s0,-32
    80005efc:	fec40593          	addi	a1,s0,-20
    80005f00:	4501                	li	a0,0
    80005f02:	00000097          	auipc	ra,0x0
    80005f06:	cc0080e7          	jalr	-832(ra) # 80005bc2 <argfd>
    return -1;
    80005f0a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005f0c:	02054563          	bltz	a0,80005f36 <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    80005f10:	ffffc097          	auipc	ra,0xffffc
    80005f14:	c00080e7          	jalr	-1024(ra) # 80001b10 <myproc>
    80005f18:	fec42783          	lw	a5,-20(s0)
    80005f1c:	02278793          	addi	a5,a5,34
    80005f20:	078e                	slli	a5,a5,0x3
    80005f22:	953e                	add	a0,a0,a5
    80005f24:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80005f28:	fe043503          	ld	a0,-32(s0)
    80005f2c:	fffff097          	auipc	ra,0xfffff
    80005f30:	25e080e7          	jalr	606(ra) # 8000518a <fileclose>
  return 0;
    80005f34:	4781                	li	a5,0
}
    80005f36:	853e                	mv	a0,a5
    80005f38:	60e2                	ld	ra,24(sp)
    80005f3a:	6442                	ld	s0,16(sp)
    80005f3c:	6105                	addi	sp,sp,32
    80005f3e:	8082                	ret

0000000080005f40 <sys_fstat>:
{
    80005f40:	1101                	addi	sp,sp,-32
    80005f42:	ec06                	sd	ra,24(sp)
    80005f44:	e822                	sd	s0,16(sp)
    80005f46:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005f48:	fe040593          	addi	a1,s0,-32
    80005f4c:	4505                	li	a0,1
    80005f4e:	ffffd097          	auipc	ra,0xffffd
    80005f52:	5d8080e7          	jalr	1496(ra) # 80003526 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005f56:	fe840613          	addi	a2,s0,-24
    80005f5a:	4581                	li	a1,0
    80005f5c:	4501                	li	a0,0
    80005f5e:	00000097          	auipc	ra,0x0
    80005f62:	c64080e7          	jalr	-924(ra) # 80005bc2 <argfd>
    80005f66:	87aa                	mv	a5,a0
    return -1;
    80005f68:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005f6a:	0007ca63          	bltz	a5,80005f7e <sys_fstat+0x3e>
  return filestat(f, st);
    80005f6e:	fe043583          	ld	a1,-32(s0)
    80005f72:	fe843503          	ld	a0,-24(s0)
    80005f76:	fffff097          	auipc	ra,0xfffff
    80005f7a:	2dc080e7          	jalr	732(ra) # 80005252 <filestat>
}
    80005f7e:	60e2                	ld	ra,24(sp)
    80005f80:	6442                	ld	s0,16(sp)
    80005f82:	6105                	addi	sp,sp,32
    80005f84:	8082                	ret

0000000080005f86 <sys_link>:
{
    80005f86:	7169                	addi	sp,sp,-304
    80005f88:	f606                	sd	ra,296(sp)
    80005f8a:	f222                	sd	s0,288(sp)
    80005f8c:	ee26                	sd	s1,280(sp)
    80005f8e:	ea4a                	sd	s2,272(sp)
    80005f90:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005f92:	08000613          	li	a2,128
    80005f96:	ed040593          	addi	a1,s0,-304
    80005f9a:	4501                	li	a0,0
    80005f9c:	ffffd097          	auipc	ra,0xffffd
    80005fa0:	5aa080e7          	jalr	1450(ra) # 80003546 <argstr>
    return -1;
    80005fa4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005fa6:	10054e63          	bltz	a0,800060c2 <sys_link+0x13c>
    80005faa:	08000613          	li	a2,128
    80005fae:	f5040593          	addi	a1,s0,-176
    80005fb2:	4505                	li	a0,1
    80005fb4:	ffffd097          	auipc	ra,0xffffd
    80005fb8:	592080e7          	jalr	1426(ra) # 80003546 <argstr>
    return -1;
    80005fbc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005fbe:	10054263          	bltz	a0,800060c2 <sys_link+0x13c>
  begin_op();
    80005fc2:	fffff097          	auipc	ra,0xfffff
    80005fc6:	d00080e7          	jalr	-768(ra) # 80004cc2 <begin_op>
  if((ip = namei(old)) == 0){
    80005fca:	ed040513          	addi	a0,s0,-304
    80005fce:	fffff097          	auipc	ra,0xfffff
    80005fd2:	ad4080e7          	jalr	-1324(ra) # 80004aa2 <namei>
    80005fd6:	84aa                	mv	s1,a0
    80005fd8:	c551                	beqz	a0,80006064 <sys_link+0xde>
  ilock(ip);
    80005fda:	ffffe097          	auipc	ra,0xffffe
    80005fde:	31c080e7          	jalr	796(ra) # 800042f6 <ilock>
  if(ip->type == T_DIR){
    80005fe2:	04449703          	lh	a4,68(s1)
    80005fe6:	4785                	li	a5,1
    80005fe8:	08f70463          	beq	a4,a5,80006070 <sys_link+0xea>
  ip->nlink++;
    80005fec:	04a4d783          	lhu	a5,74(s1)
    80005ff0:	2785                	addiw	a5,a5,1
    80005ff2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005ff6:	8526                	mv	a0,s1
    80005ff8:	ffffe097          	auipc	ra,0xffffe
    80005ffc:	232080e7          	jalr	562(ra) # 8000422a <iupdate>
  iunlock(ip);
    80006000:	8526                	mv	a0,s1
    80006002:	ffffe097          	auipc	ra,0xffffe
    80006006:	3b6080e7          	jalr	950(ra) # 800043b8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000600a:	fd040593          	addi	a1,s0,-48
    8000600e:	f5040513          	addi	a0,s0,-176
    80006012:	fffff097          	auipc	ra,0xfffff
    80006016:	aae080e7          	jalr	-1362(ra) # 80004ac0 <nameiparent>
    8000601a:	892a                	mv	s2,a0
    8000601c:	c935                	beqz	a0,80006090 <sys_link+0x10a>
  ilock(dp);
    8000601e:	ffffe097          	auipc	ra,0xffffe
    80006022:	2d8080e7          	jalr	728(ra) # 800042f6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80006026:	00092703          	lw	a4,0(s2)
    8000602a:	409c                	lw	a5,0(s1)
    8000602c:	04f71d63          	bne	a4,a5,80006086 <sys_link+0x100>
    80006030:	40d0                	lw	a2,4(s1)
    80006032:	fd040593          	addi	a1,s0,-48
    80006036:	854a                	mv	a0,s2
    80006038:	fffff097          	auipc	ra,0xfffff
    8000603c:	9b8080e7          	jalr	-1608(ra) # 800049f0 <dirlink>
    80006040:	04054363          	bltz	a0,80006086 <sys_link+0x100>
  iunlockput(dp);
    80006044:	854a                	mv	a0,s2
    80006046:	ffffe097          	auipc	ra,0xffffe
    8000604a:	512080e7          	jalr	1298(ra) # 80004558 <iunlockput>
  iput(ip);
    8000604e:	8526                	mv	a0,s1
    80006050:	ffffe097          	auipc	ra,0xffffe
    80006054:	460080e7          	jalr	1120(ra) # 800044b0 <iput>
  end_op();
    80006058:	fffff097          	auipc	ra,0xfffff
    8000605c:	ce8080e7          	jalr	-792(ra) # 80004d40 <end_op>
  return 0;
    80006060:	4781                	li	a5,0
    80006062:	a085                	j	800060c2 <sys_link+0x13c>
    end_op();
    80006064:	fffff097          	auipc	ra,0xfffff
    80006068:	cdc080e7          	jalr	-804(ra) # 80004d40 <end_op>
    return -1;
    8000606c:	57fd                	li	a5,-1
    8000606e:	a891                	j	800060c2 <sys_link+0x13c>
    iunlockput(ip);
    80006070:	8526                	mv	a0,s1
    80006072:	ffffe097          	auipc	ra,0xffffe
    80006076:	4e6080e7          	jalr	1254(ra) # 80004558 <iunlockput>
    end_op();
    8000607a:	fffff097          	auipc	ra,0xfffff
    8000607e:	cc6080e7          	jalr	-826(ra) # 80004d40 <end_op>
    return -1;
    80006082:	57fd                	li	a5,-1
    80006084:	a83d                	j	800060c2 <sys_link+0x13c>
    iunlockput(dp);
    80006086:	854a                	mv	a0,s2
    80006088:	ffffe097          	auipc	ra,0xffffe
    8000608c:	4d0080e7          	jalr	1232(ra) # 80004558 <iunlockput>
  ilock(ip);
    80006090:	8526                	mv	a0,s1
    80006092:	ffffe097          	auipc	ra,0xffffe
    80006096:	264080e7          	jalr	612(ra) # 800042f6 <ilock>
  ip->nlink--;
    8000609a:	04a4d783          	lhu	a5,74(s1)
    8000609e:	37fd                	addiw	a5,a5,-1
    800060a0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800060a4:	8526                	mv	a0,s1
    800060a6:	ffffe097          	auipc	ra,0xffffe
    800060aa:	184080e7          	jalr	388(ra) # 8000422a <iupdate>
  iunlockput(ip);
    800060ae:	8526                	mv	a0,s1
    800060b0:	ffffe097          	auipc	ra,0xffffe
    800060b4:	4a8080e7          	jalr	1192(ra) # 80004558 <iunlockput>
  end_op();
    800060b8:	fffff097          	auipc	ra,0xfffff
    800060bc:	c88080e7          	jalr	-888(ra) # 80004d40 <end_op>
  return -1;
    800060c0:	57fd                	li	a5,-1
}
    800060c2:	853e                	mv	a0,a5
    800060c4:	70b2                	ld	ra,296(sp)
    800060c6:	7412                	ld	s0,288(sp)
    800060c8:	64f2                	ld	s1,280(sp)
    800060ca:	6952                	ld	s2,272(sp)
    800060cc:	6155                	addi	sp,sp,304
    800060ce:	8082                	ret

00000000800060d0 <sys_unlink>:
{
    800060d0:	7151                	addi	sp,sp,-240
    800060d2:	f586                	sd	ra,232(sp)
    800060d4:	f1a2                	sd	s0,224(sp)
    800060d6:	eda6                	sd	s1,216(sp)
    800060d8:	e9ca                	sd	s2,208(sp)
    800060da:	e5ce                	sd	s3,200(sp)
    800060dc:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800060de:	08000613          	li	a2,128
    800060e2:	f3040593          	addi	a1,s0,-208
    800060e6:	4501                	li	a0,0
    800060e8:	ffffd097          	auipc	ra,0xffffd
    800060ec:	45e080e7          	jalr	1118(ra) # 80003546 <argstr>
    800060f0:	18054163          	bltz	a0,80006272 <sys_unlink+0x1a2>
  begin_op();
    800060f4:	fffff097          	auipc	ra,0xfffff
    800060f8:	bce080e7          	jalr	-1074(ra) # 80004cc2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800060fc:	fb040593          	addi	a1,s0,-80
    80006100:	f3040513          	addi	a0,s0,-208
    80006104:	fffff097          	auipc	ra,0xfffff
    80006108:	9bc080e7          	jalr	-1604(ra) # 80004ac0 <nameiparent>
    8000610c:	84aa                	mv	s1,a0
    8000610e:	c979                	beqz	a0,800061e4 <sys_unlink+0x114>
  ilock(dp);
    80006110:	ffffe097          	auipc	ra,0xffffe
    80006114:	1e6080e7          	jalr	486(ra) # 800042f6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80006118:	00003597          	auipc	a1,0x3
    8000611c:	74858593          	addi	a1,a1,1864 # 80009860 <syscalls+0x2c8>
    80006120:	fb040513          	addi	a0,s0,-80
    80006124:	ffffe097          	auipc	ra,0xffffe
    80006128:	69c080e7          	jalr	1692(ra) # 800047c0 <namecmp>
    8000612c:	14050a63          	beqz	a0,80006280 <sys_unlink+0x1b0>
    80006130:	00003597          	auipc	a1,0x3
    80006134:	73858593          	addi	a1,a1,1848 # 80009868 <syscalls+0x2d0>
    80006138:	fb040513          	addi	a0,s0,-80
    8000613c:	ffffe097          	auipc	ra,0xffffe
    80006140:	684080e7          	jalr	1668(ra) # 800047c0 <namecmp>
    80006144:	12050e63          	beqz	a0,80006280 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80006148:	f2c40613          	addi	a2,s0,-212
    8000614c:	fb040593          	addi	a1,s0,-80
    80006150:	8526                	mv	a0,s1
    80006152:	ffffe097          	auipc	ra,0xffffe
    80006156:	688080e7          	jalr	1672(ra) # 800047da <dirlookup>
    8000615a:	892a                	mv	s2,a0
    8000615c:	12050263          	beqz	a0,80006280 <sys_unlink+0x1b0>
  ilock(ip);
    80006160:	ffffe097          	auipc	ra,0xffffe
    80006164:	196080e7          	jalr	406(ra) # 800042f6 <ilock>
  if(ip->nlink < 1)
    80006168:	04a91783          	lh	a5,74(s2)
    8000616c:	08f05263          	blez	a5,800061f0 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80006170:	04491703          	lh	a4,68(s2)
    80006174:	4785                	li	a5,1
    80006176:	08f70563          	beq	a4,a5,80006200 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000617a:	4641                	li	a2,16
    8000617c:	4581                	li	a1,0
    8000617e:	fc040513          	addi	a0,s0,-64
    80006182:	ffffb097          	auipc	ra,0xffffb
    80006186:	c6e080e7          	jalr	-914(ra) # 80000df0 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000618a:	4741                	li	a4,16
    8000618c:	f2c42683          	lw	a3,-212(s0)
    80006190:	fc040613          	addi	a2,s0,-64
    80006194:	4581                	li	a1,0
    80006196:	8526                	mv	a0,s1
    80006198:	ffffe097          	auipc	ra,0xffffe
    8000619c:	50a080e7          	jalr	1290(ra) # 800046a2 <writei>
    800061a0:	47c1                	li	a5,16
    800061a2:	0af51563          	bne	a0,a5,8000624c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800061a6:	04491703          	lh	a4,68(s2)
    800061aa:	4785                	li	a5,1
    800061ac:	0af70863          	beq	a4,a5,8000625c <sys_unlink+0x18c>
  iunlockput(dp);
    800061b0:	8526                	mv	a0,s1
    800061b2:	ffffe097          	auipc	ra,0xffffe
    800061b6:	3a6080e7          	jalr	934(ra) # 80004558 <iunlockput>
  ip->nlink--;
    800061ba:	04a95783          	lhu	a5,74(s2)
    800061be:	37fd                	addiw	a5,a5,-1
    800061c0:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800061c4:	854a                	mv	a0,s2
    800061c6:	ffffe097          	auipc	ra,0xffffe
    800061ca:	064080e7          	jalr	100(ra) # 8000422a <iupdate>
  iunlockput(ip);
    800061ce:	854a                	mv	a0,s2
    800061d0:	ffffe097          	auipc	ra,0xffffe
    800061d4:	388080e7          	jalr	904(ra) # 80004558 <iunlockput>
  end_op();
    800061d8:	fffff097          	auipc	ra,0xfffff
    800061dc:	b68080e7          	jalr	-1176(ra) # 80004d40 <end_op>
  return 0;
    800061e0:	4501                	li	a0,0
    800061e2:	a84d                	j	80006294 <sys_unlink+0x1c4>
    end_op();
    800061e4:	fffff097          	auipc	ra,0xfffff
    800061e8:	b5c080e7          	jalr	-1188(ra) # 80004d40 <end_op>
    return -1;
    800061ec:	557d                	li	a0,-1
    800061ee:	a05d                	j	80006294 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800061f0:	00003517          	auipc	a0,0x3
    800061f4:	68050513          	addi	a0,a0,1664 # 80009870 <syscalls+0x2d8>
    800061f8:	ffffa097          	auipc	ra,0xffffa
    800061fc:	348080e7          	jalr	840(ra) # 80000540 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80006200:	04c92703          	lw	a4,76(s2)
    80006204:	02000793          	li	a5,32
    80006208:	f6e7f9e3          	bgeu	a5,a4,8000617a <sys_unlink+0xaa>
    8000620c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80006210:	4741                	li	a4,16
    80006212:	86ce                	mv	a3,s3
    80006214:	f1840613          	addi	a2,s0,-232
    80006218:	4581                	li	a1,0
    8000621a:	854a                	mv	a0,s2
    8000621c:	ffffe097          	auipc	ra,0xffffe
    80006220:	38e080e7          	jalr	910(ra) # 800045aa <readi>
    80006224:	47c1                	li	a5,16
    80006226:	00f51b63          	bne	a0,a5,8000623c <sys_unlink+0x16c>
    if(de.inum != 0)
    8000622a:	f1845783          	lhu	a5,-232(s0)
    8000622e:	e7a1                	bnez	a5,80006276 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80006230:	29c1                	addiw	s3,s3,16
    80006232:	04c92783          	lw	a5,76(s2)
    80006236:	fcf9ede3          	bltu	s3,a5,80006210 <sys_unlink+0x140>
    8000623a:	b781                	j	8000617a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000623c:	00003517          	auipc	a0,0x3
    80006240:	64c50513          	addi	a0,a0,1612 # 80009888 <syscalls+0x2f0>
    80006244:	ffffa097          	auipc	ra,0xffffa
    80006248:	2fc080e7          	jalr	764(ra) # 80000540 <panic>
    panic("unlink: writei");
    8000624c:	00003517          	auipc	a0,0x3
    80006250:	65450513          	addi	a0,a0,1620 # 800098a0 <syscalls+0x308>
    80006254:	ffffa097          	auipc	ra,0xffffa
    80006258:	2ec080e7          	jalr	748(ra) # 80000540 <panic>
    dp->nlink--;
    8000625c:	04a4d783          	lhu	a5,74(s1)
    80006260:	37fd                	addiw	a5,a5,-1
    80006262:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80006266:	8526                	mv	a0,s1
    80006268:	ffffe097          	auipc	ra,0xffffe
    8000626c:	fc2080e7          	jalr	-62(ra) # 8000422a <iupdate>
    80006270:	b781                	j	800061b0 <sys_unlink+0xe0>
    return -1;
    80006272:	557d                	li	a0,-1
    80006274:	a005                	j	80006294 <sys_unlink+0x1c4>
    iunlockput(ip);
    80006276:	854a                	mv	a0,s2
    80006278:	ffffe097          	auipc	ra,0xffffe
    8000627c:	2e0080e7          	jalr	736(ra) # 80004558 <iunlockput>
  iunlockput(dp);
    80006280:	8526                	mv	a0,s1
    80006282:	ffffe097          	auipc	ra,0xffffe
    80006286:	2d6080e7          	jalr	726(ra) # 80004558 <iunlockput>
  end_op();
    8000628a:	fffff097          	auipc	ra,0xfffff
    8000628e:	ab6080e7          	jalr	-1354(ra) # 80004d40 <end_op>
  return -1;
    80006292:	557d                	li	a0,-1
}
    80006294:	70ae                	ld	ra,232(sp)
    80006296:	740e                	ld	s0,224(sp)
    80006298:	64ee                	ld	s1,216(sp)
    8000629a:	694e                	ld	s2,208(sp)
    8000629c:	69ae                	ld	s3,200(sp)
    8000629e:	616d                	addi	sp,sp,240
    800062a0:	8082                	ret

00000000800062a2 <sys_open>:

uint64
sys_open(void)
{
    800062a2:	7131                	addi	sp,sp,-192
    800062a4:	fd06                	sd	ra,184(sp)
    800062a6:	f922                	sd	s0,176(sp)
    800062a8:	f526                	sd	s1,168(sp)
    800062aa:	f14a                	sd	s2,160(sp)
    800062ac:	ed4e                	sd	s3,152(sp)
    800062ae:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800062b0:	f4c40593          	addi	a1,s0,-180
    800062b4:	4505                	li	a0,1
    800062b6:	ffffd097          	auipc	ra,0xffffd
    800062ba:	250080e7          	jalr	592(ra) # 80003506 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800062be:	08000613          	li	a2,128
    800062c2:	f5040593          	addi	a1,s0,-176
    800062c6:	4501                	li	a0,0
    800062c8:	ffffd097          	auipc	ra,0xffffd
    800062cc:	27e080e7          	jalr	638(ra) # 80003546 <argstr>
    800062d0:	87aa                	mv	a5,a0
    return -1;
    800062d2:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800062d4:	0a07c963          	bltz	a5,80006386 <sys_open+0xe4>

  begin_op();
    800062d8:	fffff097          	auipc	ra,0xfffff
    800062dc:	9ea080e7          	jalr	-1558(ra) # 80004cc2 <begin_op>

  if(omode & O_CREATE){
    800062e0:	f4c42783          	lw	a5,-180(s0)
    800062e4:	2007f793          	andi	a5,a5,512
    800062e8:	cfc5                	beqz	a5,800063a0 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800062ea:	4681                	li	a3,0
    800062ec:	4601                	li	a2,0
    800062ee:	4589                	li	a1,2
    800062f0:	f5040513          	addi	a0,s0,-176
    800062f4:	00000097          	auipc	ra,0x0
    800062f8:	970080e7          	jalr	-1680(ra) # 80005c64 <create>
    800062fc:	84aa                	mv	s1,a0
    if(ip == 0){
    800062fe:	c959                	beqz	a0,80006394 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80006300:	04449703          	lh	a4,68(s1)
    80006304:	478d                	li	a5,3
    80006306:	00f71763          	bne	a4,a5,80006314 <sys_open+0x72>
    8000630a:	0464d703          	lhu	a4,70(s1)
    8000630e:	47a5                	li	a5,9
    80006310:	0ce7ed63          	bltu	a5,a4,800063ea <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80006314:	fffff097          	auipc	ra,0xfffff
    80006318:	dba080e7          	jalr	-582(ra) # 800050ce <filealloc>
    8000631c:	89aa                	mv	s3,a0
    8000631e:	10050363          	beqz	a0,80006424 <sys_open+0x182>
    80006322:	00000097          	auipc	ra,0x0
    80006326:	900080e7          	jalr	-1792(ra) # 80005c22 <fdalloc>
    8000632a:	892a                	mv	s2,a0
    8000632c:	0e054763          	bltz	a0,8000641a <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80006330:	04449703          	lh	a4,68(s1)
    80006334:	478d                	li	a5,3
    80006336:	0cf70563          	beq	a4,a5,80006400 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000633a:	4789                	li	a5,2
    8000633c:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80006340:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80006344:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80006348:	f4c42783          	lw	a5,-180(s0)
    8000634c:	0017c713          	xori	a4,a5,1
    80006350:	8b05                	andi	a4,a4,1
    80006352:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80006356:	0037f713          	andi	a4,a5,3
    8000635a:	00e03733          	snez	a4,a4
    8000635e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80006362:	4007f793          	andi	a5,a5,1024
    80006366:	c791                	beqz	a5,80006372 <sys_open+0xd0>
    80006368:	04449703          	lh	a4,68(s1)
    8000636c:	4789                	li	a5,2
    8000636e:	0af70063          	beq	a4,a5,8000640e <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80006372:	8526                	mv	a0,s1
    80006374:	ffffe097          	auipc	ra,0xffffe
    80006378:	044080e7          	jalr	68(ra) # 800043b8 <iunlock>
  end_op();
    8000637c:	fffff097          	auipc	ra,0xfffff
    80006380:	9c4080e7          	jalr	-1596(ra) # 80004d40 <end_op>

  return fd;
    80006384:	854a                	mv	a0,s2
}
    80006386:	70ea                	ld	ra,184(sp)
    80006388:	744a                	ld	s0,176(sp)
    8000638a:	74aa                	ld	s1,168(sp)
    8000638c:	790a                	ld	s2,160(sp)
    8000638e:	69ea                	ld	s3,152(sp)
    80006390:	6129                	addi	sp,sp,192
    80006392:	8082                	ret
      end_op();
    80006394:	fffff097          	auipc	ra,0xfffff
    80006398:	9ac080e7          	jalr	-1620(ra) # 80004d40 <end_op>
      return -1;
    8000639c:	557d                	li	a0,-1
    8000639e:	b7e5                	j	80006386 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    800063a0:	f5040513          	addi	a0,s0,-176
    800063a4:	ffffe097          	auipc	ra,0xffffe
    800063a8:	6fe080e7          	jalr	1790(ra) # 80004aa2 <namei>
    800063ac:	84aa                	mv	s1,a0
    800063ae:	c905                	beqz	a0,800063de <sys_open+0x13c>
    ilock(ip);
    800063b0:	ffffe097          	auipc	ra,0xffffe
    800063b4:	f46080e7          	jalr	-186(ra) # 800042f6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800063b8:	04449703          	lh	a4,68(s1)
    800063bc:	4785                	li	a5,1
    800063be:	f4f711e3          	bne	a4,a5,80006300 <sys_open+0x5e>
    800063c2:	f4c42783          	lw	a5,-180(s0)
    800063c6:	d7b9                	beqz	a5,80006314 <sys_open+0x72>
      iunlockput(ip);
    800063c8:	8526                	mv	a0,s1
    800063ca:	ffffe097          	auipc	ra,0xffffe
    800063ce:	18e080e7          	jalr	398(ra) # 80004558 <iunlockput>
      end_op();
    800063d2:	fffff097          	auipc	ra,0xfffff
    800063d6:	96e080e7          	jalr	-1682(ra) # 80004d40 <end_op>
      return -1;
    800063da:	557d                	li	a0,-1
    800063dc:	b76d                	j	80006386 <sys_open+0xe4>
      end_op();
    800063de:	fffff097          	auipc	ra,0xfffff
    800063e2:	962080e7          	jalr	-1694(ra) # 80004d40 <end_op>
      return -1;
    800063e6:	557d                	li	a0,-1
    800063e8:	bf79                	j	80006386 <sys_open+0xe4>
    iunlockput(ip);
    800063ea:	8526                	mv	a0,s1
    800063ec:	ffffe097          	auipc	ra,0xffffe
    800063f0:	16c080e7          	jalr	364(ra) # 80004558 <iunlockput>
    end_op();
    800063f4:	fffff097          	auipc	ra,0xfffff
    800063f8:	94c080e7          	jalr	-1716(ra) # 80004d40 <end_op>
    return -1;
    800063fc:	557d                	li	a0,-1
    800063fe:	b761                	j	80006386 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80006400:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80006404:	04649783          	lh	a5,70(s1)
    80006408:	02f99223          	sh	a5,36(s3)
    8000640c:	bf25                	j	80006344 <sys_open+0xa2>
    itrunc(ip);
    8000640e:	8526                	mv	a0,s1
    80006410:	ffffe097          	auipc	ra,0xffffe
    80006414:	ff4080e7          	jalr	-12(ra) # 80004404 <itrunc>
    80006418:	bfa9                	j	80006372 <sys_open+0xd0>
      fileclose(f);
    8000641a:	854e                	mv	a0,s3
    8000641c:	fffff097          	auipc	ra,0xfffff
    80006420:	d6e080e7          	jalr	-658(ra) # 8000518a <fileclose>
    iunlockput(ip);
    80006424:	8526                	mv	a0,s1
    80006426:	ffffe097          	auipc	ra,0xffffe
    8000642a:	132080e7          	jalr	306(ra) # 80004558 <iunlockput>
    end_op();
    8000642e:	fffff097          	auipc	ra,0xfffff
    80006432:	912080e7          	jalr	-1774(ra) # 80004d40 <end_op>
    return -1;
    80006436:	557d                	li	a0,-1
    80006438:	b7b9                	j	80006386 <sys_open+0xe4>

000000008000643a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000643a:	7175                	addi	sp,sp,-144
    8000643c:	e506                	sd	ra,136(sp)
    8000643e:	e122                	sd	s0,128(sp)
    80006440:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80006442:	fffff097          	auipc	ra,0xfffff
    80006446:	880080e7          	jalr	-1920(ra) # 80004cc2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000644a:	08000613          	li	a2,128
    8000644e:	f7040593          	addi	a1,s0,-144
    80006452:	4501                	li	a0,0
    80006454:	ffffd097          	auipc	ra,0xffffd
    80006458:	0f2080e7          	jalr	242(ra) # 80003546 <argstr>
    8000645c:	02054963          	bltz	a0,8000648e <sys_mkdir+0x54>
    80006460:	4681                	li	a3,0
    80006462:	4601                	li	a2,0
    80006464:	4585                	li	a1,1
    80006466:	f7040513          	addi	a0,s0,-144
    8000646a:	fffff097          	auipc	ra,0xfffff
    8000646e:	7fa080e7          	jalr	2042(ra) # 80005c64 <create>
    80006472:	cd11                	beqz	a0,8000648e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006474:	ffffe097          	auipc	ra,0xffffe
    80006478:	0e4080e7          	jalr	228(ra) # 80004558 <iunlockput>
  end_op();
    8000647c:	fffff097          	auipc	ra,0xfffff
    80006480:	8c4080e7          	jalr	-1852(ra) # 80004d40 <end_op>
  return 0;
    80006484:	4501                	li	a0,0
}
    80006486:	60aa                	ld	ra,136(sp)
    80006488:	640a                	ld	s0,128(sp)
    8000648a:	6149                	addi	sp,sp,144
    8000648c:	8082                	ret
    end_op();
    8000648e:	fffff097          	auipc	ra,0xfffff
    80006492:	8b2080e7          	jalr	-1870(ra) # 80004d40 <end_op>
    return -1;
    80006496:	557d                	li	a0,-1
    80006498:	b7fd                	j	80006486 <sys_mkdir+0x4c>

000000008000649a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000649a:	7135                	addi	sp,sp,-160
    8000649c:	ed06                	sd	ra,152(sp)
    8000649e:	e922                	sd	s0,144(sp)
    800064a0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800064a2:	fffff097          	auipc	ra,0xfffff
    800064a6:	820080e7          	jalr	-2016(ra) # 80004cc2 <begin_op>
  argint(1, &major);
    800064aa:	f6c40593          	addi	a1,s0,-148
    800064ae:	4505                	li	a0,1
    800064b0:	ffffd097          	auipc	ra,0xffffd
    800064b4:	056080e7          	jalr	86(ra) # 80003506 <argint>
  argint(2, &minor);
    800064b8:	f6840593          	addi	a1,s0,-152
    800064bc:	4509                	li	a0,2
    800064be:	ffffd097          	auipc	ra,0xffffd
    800064c2:	048080e7          	jalr	72(ra) # 80003506 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800064c6:	08000613          	li	a2,128
    800064ca:	f7040593          	addi	a1,s0,-144
    800064ce:	4501                	li	a0,0
    800064d0:	ffffd097          	auipc	ra,0xffffd
    800064d4:	076080e7          	jalr	118(ra) # 80003546 <argstr>
    800064d8:	02054b63          	bltz	a0,8000650e <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800064dc:	f6841683          	lh	a3,-152(s0)
    800064e0:	f6c41603          	lh	a2,-148(s0)
    800064e4:	458d                	li	a1,3
    800064e6:	f7040513          	addi	a0,s0,-144
    800064ea:	fffff097          	auipc	ra,0xfffff
    800064ee:	77a080e7          	jalr	1914(ra) # 80005c64 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800064f2:	cd11                	beqz	a0,8000650e <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800064f4:	ffffe097          	auipc	ra,0xffffe
    800064f8:	064080e7          	jalr	100(ra) # 80004558 <iunlockput>
  end_op();
    800064fc:	fffff097          	auipc	ra,0xfffff
    80006500:	844080e7          	jalr	-1980(ra) # 80004d40 <end_op>
  return 0;
    80006504:	4501                	li	a0,0
}
    80006506:	60ea                	ld	ra,152(sp)
    80006508:	644a                	ld	s0,144(sp)
    8000650a:	610d                	addi	sp,sp,160
    8000650c:	8082                	ret
    end_op();
    8000650e:	fffff097          	auipc	ra,0xfffff
    80006512:	832080e7          	jalr	-1998(ra) # 80004d40 <end_op>
    return -1;
    80006516:	557d                	li	a0,-1
    80006518:	b7fd                	j	80006506 <sys_mknod+0x6c>

000000008000651a <sys_chdir>:

uint64
sys_chdir(void)
{
    8000651a:	7135                	addi	sp,sp,-160
    8000651c:	ed06                	sd	ra,152(sp)
    8000651e:	e922                	sd	s0,144(sp)
    80006520:	e526                	sd	s1,136(sp)
    80006522:	e14a                	sd	s2,128(sp)
    80006524:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80006526:	ffffb097          	auipc	ra,0xffffb
    8000652a:	5ea080e7          	jalr	1514(ra) # 80001b10 <myproc>
    8000652e:	892a                	mv	s2,a0
  
  begin_op();
    80006530:	ffffe097          	auipc	ra,0xffffe
    80006534:	792080e7          	jalr	1938(ra) # 80004cc2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80006538:	08000613          	li	a2,128
    8000653c:	f6040593          	addi	a1,s0,-160
    80006540:	4501                	li	a0,0
    80006542:	ffffd097          	auipc	ra,0xffffd
    80006546:	004080e7          	jalr	4(ra) # 80003546 <argstr>
    8000654a:	04054b63          	bltz	a0,800065a0 <sys_chdir+0x86>
    8000654e:	f6040513          	addi	a0,s0,-160
    80006552:	ffffe097          	auipc	ra,0xffffe
    80006556:	550080e7          	jalr	1360(ra) # 80004aa2 <namei>
    8000655a:	84aa                	mv	s1,a0
    8000655c:	c131                	beqz	a0,800065a0 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000655e:	ffffe097          	auipc	ra,0xffffe
    80006562:	d98080e7          	jalr	-616(ra) # 800042f6 <ilock>
  if(ip->type != T_DIR){
    80006566:	04449703          	lh	a4,68(s1)
    8000656a:	4785                	li	a5,1
    8000656c:	04f71063          	bne	a4,a5,800065ac <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80006570:	8526                	mv	a0,s1
    80006572:	ffffe097          	auipc	ra,0xffffe
    80006576:	e46080e7          	jalr	-442(ra) # 800043b8 <iunlock>
  iput(p->cwd);
    8000657a:	19893503          	ld	a0,408(s2)
    8000657e:	ffffe097          	auipc	ra,0xffffe
    80006582:	f32080e7          	jalr	-206(ra) # 800044b0 <iput>
  end_op();
    80006586:	ffffe097          	auipc	ra,0xffffe
    8000658a:	7ba080e7          	jalr	1978(ra) # 80004d40 <end_op>
  p->cwd = ip;
    8000658e:	18993c23          	sd	s1,408(s2)
  return 0;
    80006592:	4501                	li	a0,0
}
    80006594:	60ea                	ld	ra,152(sp)
    80006596:	644a                	ld	s0,144(sp)
    80006598:	64aa                	ld	s1,136(sp)
    8000659a:	690a                	ld	s2,128(sp)
    8000659c:	610d                	addi	sp,sp,160
    8000659e:	8082                	ret
    end_op();
    800065a0:	ffffe097          	auipc	ra,0xffffe
    800065a4:	7a0080e7          	jalr	1952(ra) # 80004d40 <end_op>
    return -1;
    800065a8:	557d                	li	a0,-1
    800065aa:	b7ed                	j	80006594 <sys_chdir+0x7a>
    iunlockput(ip);
    800065ac:	8526                	mv	a0,s1
    800065ae:	ffffe097          	auipc	ra,0xffffe
    800065b2:	faa080e7          	jalr	-86(ra) # 80004558 <iunlockput>
    end_op();
    800065b6:	ffffe097          	auipc	ra,0xffffe
    800065ba:	78a080e7          	jalr	1930(ra) # 80004d40 <end_op>
    return -1;
    800065be:	557d                	li	a0,-1
    800065c0:	bfd1                	j	80006594 <sys_chdir+0x7a>

00000000800065c2 <sys_exec>:

uint64
sys_exec(void)
{
    800065c2:	7145                	addi	sp,sp,-464
    800065c4:	e786                	sd	ra,456(sp)
    800065c6:	e3a2                	sd	s0,448(sp)
    800065c8:	ff26                	sd	s1,440(sp)
    800065ca:	fb4a                	sd	s2,432(sp)
    800065cc:	f74e                	sd	s3,424(sp)
    800065ce:	f352                	sd	s4,416(sp)
    800065d0:	ef56                	sd	s5,408(sp)
    800065d2:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800065d4:	e3840593          	addi	a1,s0,-456
    800065d8:	4505                	li	a0,1
    800065da:	ffffd097          	auipc	ra,0xffffd
    800065de:	f4c080e7          	jalr	-180(ra) # 80003526 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800065e2:	08000613          	li	a2,128
    800065e6:	f4040593          	addi	a1,s0,-192
    800065ea:	4501                	li	a0,0
    800065ec:	ffffd097          	auipc	ra,0xffffd
    800065f0:	f5a080e7          	jalr	-166(ra) # 80003546 <argstr>
    800065f4:	87aa                	mv	a5,a0
    return -1;
    800065f6:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800065f8:	0c07c363          	bltz	a5,800066be <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    800065fc:	10000613          	li	a2,256
    80006600:	4581                	li	a1,0
    80006602:	e4040513          	addi	a0,s0,-448
    80006606:	ffffa097          	auipc	ra,0xffffa
    8000660a:	7ea080e7          	jalr	2026(ra) # 80000df0 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000660e:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80006612:	89a6                	mv	s3,s1
    80006614:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80006616:	02000a13          	li	s4,32
    8000661a:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000661e:	00391513          	slli	a0,s2,0x3
    80006622:	e3040593          	addi	a1,s0,-464
    80006626:	e3843783          	ld	a5,-456(s0)
    8000662a:	953e                	add	a0,a0,a5
    8000662c:	ffffd097          	auipc	ra,0xffffd
    80006630:	e3c080e7          	jalr	-452(ra) # 80003468 <fetchaddr>
    80006634:	02054a63          	bltz	a0,80006668 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80006638:	e3043783          	ld	a5,-464(s0)
    8000663c:	c3b9                	beqz	a5,80006682 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000663e:	ffffa097          	auipc	ra,0xffffa
    80006642:	5bc080e7          	jalr	1468(ra) # 80000bfa <kalloc>
    80006646:	85aa                	mv	a1,a0
    80006648:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000664c:	cd11                	beqz	a0,80006668 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000664e:	6605                	lui	a2,0x1
    80006650:	e3043503          	ld	a0,-464(s0)
    80006654:	ffffd097          	auipc	ra,0xffffd
    80006658:	e66080e7          	jalr	-410(ra) # 800034ba <fetchstr>
    8000665c:	00054663          	bltz	a0,80006668 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80006660:	0905                	addi	s2,s2,1
    80006662:	09a1                	addi	s3,s3,8
    80006664:	fb491be3          	bne	s2,s4,8000661a <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006668:	f4040913          	addi	s2,s0,-192
    8000666c:	6088                	ld	a0,0(s1)
    8000666e:	c539                	beqz	a0,800066bc <sys_exec+0xfa>
    kfree(argv[i]);
    80006670:	ffffa097          	auipc	ra,0xffffa
    80006674:	3e2080e7          	jalr	994(ra) # 80000a52 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006678:	04a1                	addi	s1,s1,8
    8000667a:	ff2499e3          	bne	s1,s2,8000666c <sys_exec+0xaa>
  return -1;
    8000667e:	557d                	li	a0,-1
    80006680:	a83d                	j	800066be <sys_exec+0xfc>
      argv[i] = 0;
    80006682:	0a8e                	slli	s5,s5,0x3
    80006684:	fc0a8793          	addi	a5,s5,-64
    80006688:	00878ab3          	add	s5,a5,s0
    8000668c:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80006690:	e4040593          	addi	a1,s0,-448
    80006694:	f4040513          	addi	a0,s0,-192
    80006698:	fffff097          	auipc	ra,0xfffff
    8000669c:	16c080e7          	jalr	364(ra) # 80005804 <exec>
    800066a0:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800066a2:	f4040993          	addi	s3,s0,-192
    800066a6:	6088                	ld	a0,0(s1)
    800066a8:	c901                	beqz	a0,800066b8 <sys_exec+0xf6>
    kfree(argv[i]);
    800066aa:	ffffa097          	auipc	ra,0xffffa
    800066ae:	3a8080e7          	jalr	936(ra) # 80000a52 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800066b2:	04a1                	addi	s1,s1,8
    800066b4:	ff3499e3          	bne	s1,s3,800066a6 <sys_exec+0xe4>
  return ret;
    800066b8:	854a                	mv	a0,s2
    800066ba:	a011                	j	800066be <sys_exec+0xfc>
  return -1;
    800066bc:	557d                	li	a0,-1
}
    800066be:	60be                	ld	ra,456(sp)
    800066c0:	641e                	ld	s0,448(sp)
    800066c2:	74fa                	ld	s1,440(sp)
    800066c4:	795a                	ld	s2,432(sp)
    800066c6:	79ba                	ld	s3,424(sp)
    800066c8:	7a1a                	ld	s4,416(sp)
    800066ca:	6afa                	ld	s5,408(sp)
    800066cc:	6179                	addi	sp,sp,464
    800066ce:	8082                	ret

00000000800066d0 <sys_pipe>:

uint64
sys_pipe(void)
{
    800066d0:	7139                	addi	sp,sp,-64
    800066d2:	fc06                	sd	ra,56(sp)
    800066d4:	f822                	sd	s0,48(sp)
    800066d6:	f426                	sd	s1,40(sp)
    800066d8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800066da:	ffffb097          	auipc	ra,0xffffb
    800066de:	436080e7          	jalr	1078(ra) # 80001b10 <myproc>
    800066e2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800066e4:	fd840593          	addi	a1,s0,-40
    800066e8:	4501                	li	a0,0
    800066ea:	ffffd097          	auipc	ra,0xffffd
    800066ee:	e3c080e7          	jalr	-452(ra) # 80003526 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800066f2:	fc840593          	addi	a1,s0,-56
    800066f6:	fd040513          	addi	a0,s0,-48
    800066fa:	fffff097          	auipc	ra,0xfffff
    800066fe:	dc0080e7          	jalr	-576(ra) # 800054ba <pipealloc>
    return -1;
    80006702:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006704:	0c054763          	bltz	a0,800067d2 <sys_pipe+0x102>
  fd0 = -1;
    80006708:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000670c:	fd043503          	ld	a0,-48(s0)
    80006710:	fffff097          	auipc	ra,0xfffff
    80006714:	512080e7          	jalr	1298(ra) # 80005c22 <fdalloc>
    80006718:	fca42223          	sw	a0,-60(s0)
    8000671c:	08054e63          	bltz	a0,800067b8 <sys_pipe+0xe8>
    80006720:	fc843503          	ld	a0,-56(s0)
    80006724:	fffff097          	auipc	ra,0xfffff
    80006728:	4fe080e7          	jalr	1278(ra) # 80005c22 <fdalloc>
    8000672c:	fca42023          	sw	a0,-64(s0)
    80006730:	06054a63          	bltz	a0,800067a4 <sys_pipe+0xd4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006734:	4691                	li	a3,4
    80006736:	fc440613          	addi	a2,s0,-60
    8000673a:	fd843583          	ld	a1,-40(s0)
    8000673e:	6cc8                	ld	a0,152(s1)
    80006740:	ffffb097          	auipc	ra,0xffffb
    80006744:	058080e7          	jalr	88(ra) # 80001798 <copyout>
    80006748:	02054063          	bltz	a0,80006768 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000674c:	4691                	li	a3,4
    8000674e:	fc040613          	addi	a2,s0,-64
    80006752:	fd843583          	ld	a1,-40(s0)
    80006756:	0591                	addi	a1,a1,4
    80006758:	6cc8                	ld	a0,152(s1)
    8000675a:	ffffb097          	auipc	ra,0xffffb
    8000675e:	03e080e7          	jalr	62(ra) # 80001798 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006762:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006764:	06055763          	bgez	a0,800067d2 <sys_pipe+0x102>
    p->ofile[fd0] = 0;
    80006768:	fc442783          	lw	a5,-60(s0)
    8000676c:	02278793          	addi	a5,a5,34
    80006770:	078e                	slli	a5,a5,0x3
    80006772:	97a6                	add	a5,a5,s1
    80006774:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80006778:	fc042783          	lw	a5,-64(s0)
    8000677c:	02278793          	addi	a5,a5,34
    80006780:	078e                	slli	a5,a5,0x3
    80006782:	94be                	add	s1,s1,a5
    80006784:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80006788:	fd043503          	ld	a0,-48(s0)
    8000678c:	fffff097          	auipc	ra,0xfffff
    80006790:	9fe080e7          	jalr	-1538(ra) # 8000518a <fileclose>
    fileclose(wf);
    80006794:	fc843503          	ld	a0,-56(s0)
    80006798:	fffff097          	auipc	ra,0xfffff
    8000679c:	9f2080e7          	jalr	-1550(ra) # 8000518a <fileclose>
    return -1;
    800067a0:	57fd                	li	a5,-1
    800067a2:	a805                	j	800067d2 <sys_pipe+0x102>
    if(fd0 >= 0)
    800067a4:	fc442783          	lw	a5,-60(s0)
    800067a8:	0007c863          	bltz	a5,800067b8 <sys_pipe+0xe8>
      p->ofile[fd0] = 0;
    800067ac:	02278793          	addi	a5,a5,34
    800067b0:	078e                	slli	a5,a5,0x3
    800067b2:	97a6                	add	a5,a5,s1
    800067b4:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    800067b8:	fd043503          	ld	a0,-48(s0)
    800067bc:	fffff097          	auipc	ra,0xfffff
    800067c0:	9ce080e7          	jalr	-1586(ra) # 8000518a <fileclose>
    fileclose(wf);
    800067c4:	fc843503          	ld	a0,-56(s0)
    800067c8:	fffff097          	auipc	ra,0xfffff
    800067cc:	9c2080e7          	jalr	-1598(ra) # 8000518a <fileclose>
    return -1;
    800067d0:	57fd                	li	a5,-1
}
    800067d2:	853e                	mv	a0,a5
    800067d4:	70e2                	ld	ra,56(sp)
    800067d6:	7442                	ld	s0,48(sp)
    800067d8:	74a2                	ld	s1,40(sp)
    800067da:	6121                	addi	sp,sp,64
    800067dc:	8082                	ret
	...

00000000800067e0 <kernelvec>:
    800067e0:	7111                	addi	sp,sp,-256
    800067e2:	e006                	sd	ra,0(sp)
    800067e4:	e40a                	sd	sp,8(sp)
    800067e6:	e80e                	sd	gp,16(sp)
    800067e8:	ec12                	sd	tp,24(sp)
    800067ea:	f016                	sd	t0,32(sp)
    800067ec:	f41a                	sd	t1,40(sp)
    800067ee:	f81e                	sd	t2,48(sp)
    800067f0:	fc22                	sd	s0,56(sp)
    800067f2:	e0a6                	sd	s1,64(sp)
    800067f4:	e4aa                	sd	a0,72(sp)
    800067f6:	e8ae                	sd	a1,80(sp)
    800067f8:	ecb2                	sd	a2,88(sp)
    800067fa:	f0b6                	sd	a3,96(sp)
    800067fc:	f4ba                	sd	a4,104(sp)
    800067fe:	f8be                	sd	a5,112(sp)
    80006800:	fcc2                	sd	a6,120(sp)
    80006802:	e146                	sd	a7,128(sp)
    80006804:	e54a                	sd	s2,136(sp)
    80006806:	e94e                	sd	s3,144(sp)
    80006808:	ed52                	sd	s4,152(sp)
    8000680a:	f156                	sd	s5,160(sp)
    8000680c:	f55a                	sd	s6,168(sp)
    8000680e:	f95e                	sd	s7,176(sp)
    80006810:	fd62                	sd	s8,184(sp)
    80006812:	e1e6                	sd	s9,192(sp)
    80006814:	e5ea                	sd	s10,200(sp)
    80006816:	e9ee                	sd	s11,208(sp)
    80006818:	edf2                	sd	t3,216(sp)
    8000681a:	f1f6                	sd	t4,224(sp)
    8000681c:	f5fa                	sd	t5,232(sp)
    8000681e:	f9fe                	sd	t6,240(sp)
    80006820:	acffc0ef          	jal	ra,800032ee <kerneltrap>
    80006824:	6082                	ld	ra,0(sp)
    80006826:	6122                	ld	sp,8(sp)
    80006828:	61c2                	ld	gp,16(sp)
    8000682a:	7282                	ld	t0,32(sp)
    8000682c:	7322                	ld	t1,40(sp)
    8000682e:	73c2                	ld	t2,48(sp)
    80006830:	7462                	ld	s0,56(sp)
    80006832:	6486                	ld	s1,64(sp)
    80006834:	6526                	ld	a0,72(sp)
    80006836:	65c6                	ld	a1,80(sp)
    80006838:	6666                	ld	a2,88(sp)
    8000683a:	7686                	ld	a3,96(sp)
    8000683c:	7726                	ld	a4,104(sp)
    8000683e:	77c6                	ld	a5,112(sp)
    80006840:	7866                	ld	a6,120(sp)
    80006842:	688a                	ld	a7,128(sp)
    80006844:	692a                	ld	s2,136(sp)
    80006846:	69ca                	ld	s3,144(sp)
    80006848:	6a6a                	ld	s4,152(sp)
    8000684a:	7a8a                	ld	s5,160(sp)
    8000684c:	7b2a                	ld	s6,168(sp)
    8000684e:	7bca                	ld	s7,176(sp)
    80006850:	7c6a                	ld	s8,184(sp)
    80006852:	6c8e                	ld	s9,192(sp)
    80006854:	6d2e                	ld	s10,200(sp)
    80006856:	6dce                	ld	s11,208(sp)
    80006858:	6e6e                	ld	t3,216(sp)
    8000685a:	7e8e                	ld	t4,224(sp)
    8000685c:	7f2e                	ld	t5,232(sp)
    8000685e:	7fce                	ld	t6,240(sp)
    80006860:	6111                	addi	sp,sp,256
    80006862:	10200073          	sret
    80006866:	00000013          	nop
    8000686a:	00000013          	nop
    8000686e:	0001                	nop

0000000080006870 <timervec>:
    80006870:	34051573          	csrrw	a0,mscratch,a0
    80006874:	e10c                	sd	a1,0(a0)
    80006876:	e510                	sd	a2,8(a0)
    80006878:	e914                	sd	a3,16(a0)
    8000687a:	6d0c                	ld	a1,24(a0)
    8000687c:	7110                	ld	a2,32(a0)
    8000687e:	6194                	ld	a3,0(a1)
    80006880:	96b2                	add	a3,a3,a2
    80006882:	e194                	sd	a3,0(a1)
    80006884:	4589                	li	a1,2
    80006886:	14459073          	csrw	sip,a1
    8000688a:	6914                	ld	a3,16(a0)
    8000688c:	6510                	ld	a2,8(a0)
    8000688e:	610c                	ld	a1,0(a0)
    80006890:	34051573          	csrrw	a0,mscratch,a0
    80006894:	30200073          	mret
	...

000000008000689a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000689a:	1141                	addi	sp,sp,-16
    8000689c:	e422                	sd	s0,8(sp)
    8000689e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800068a0:	0c0007b7          	lui	a5,0xc000
    800068a4:	4705                	li	a4,1
    800068a6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800068a8:	c3d8                	sw	a4,4(a5)
}
    800068aa:	6422                	ld	s0,8(sp)
    800068ac:	0141                	addi	sp,sp,16
    800068ae:	8082                	ret

00000000800068b0 <plicinithart>:

void
plicinithart(void)
{
    800068b0:	1141                	addi	sp,sp,-16
    800068b2:	e406                	sd	ra,8(sp)
    800068b4:	e022                	sd	s0,0(sp)
    800068b6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800068b8:	ffffb097          	auipc	ra,0xffffb
    800068bc:	22c080e7          	jalr	556(ra) # 80001ae4 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800068c0:	0085171b          	slliw	a4,a0,0x8
    800068c4:	0c0027b7          	lui	a5,0xc002
    800068c8:	97ba                	add	a5,a5,a4
    800068ca:	40200713          	li	a4,1026
    800068ce:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800068d2:	00d5151b          	slliw	a0,a0,0xd
    800068d6:	0c2017b7          	lui	a5,0xc201
    800068da:	97aa                	add	a5,a5,a0
    800068dc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800068e0:	60a2                	ld	ra,8(sp)
    800068e2:	6402                	ld	s0,0(sp)
    800068e4:	0141                	addi	sp,sp,16
    800068e6:	8082                	ret

00000000800068e8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800068e8:	1141                	addi	sp,sp,-16
    800068ea:	e406                	sd	ra,8(sp)
    800068ec:	e022                	sd	s0,0(sp)
    800068ee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800068f0:	ffffb097          	auipc	ra,0xffffb
    800068f4:	1f4080e7          	jalr	500(ra) # 80001ae4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800068f8:	00d5151b          	slliw	a0,a0,0xd
    800068fc:	0c2017b7          	lui	a5,0xc201
    80006900:	97aa                	add	a5,a5,a0
  return irq;
}
    80006902:	43c8                	lw	a0,4(a5)
    80006904:	60a2                	ld	ra,8(sp)
    80006906:	6402                	ld	s0,0(sp)
    80006908:	0141                	addi	sp,sp,16
    8000690a:	8082                	ret

000000008000690c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000690c:	1101                	addi	sp,sp,-32
    8000690e:	ec06                	sd	ra,24(sp)
    80006910:	e822                	sd	s0,16(sp)
    80006912:	e426                	sd	s1,8(sp)
    80006914:	1000                	addi	s0,sp,32
    80006916:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006918:	ffffb097          	auipc	ra,0xffffb
    8000691c:	1cc080e7          	jalr	460(ra) # 80001ae4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006920:	00d5151b          	slliw	a0,a0,0xd
    80006924:	0c2017b7          	lui	a5,0xc201
    80006928:	97aa                	add	a5,a5,a0
    8000692a:	c3c4                	sw	s1,4(a5)
}
    8000692c:	60e2                	ld	ra,24(sp)
    8000692e:	6442                	ld	s0,16(sp)
    80006930:	64a2                	ld	s1,8(sp)
    80006932:	6105                	addi	sp,sp,32
    80006934:	8082                	ret

0000000080006936 <sgenrand>:
static int mti=N+1; /* mti==N+1 means mt[N] is not initialized */

/* initializing the array with a NONZERO seed */
void
sgenrand(unsigned long seed)
{
    80006936:	1141                	addi	sp,sp,-16
    80006938:	e422                	sd	s0,8(sp)
    8000693a:	0800                	addi	s0,sp,16
    /* setting initial seeds to mt[N] using         */
    /* the generator Line 25 of Table 1 in          */
    /* [KNUTH 1981, The Art of Computer Programming */
    /*    Vol. 2 (2nd Ed.), pp102]                  */
    mt[0]= seed & 0xffffffff;
    8000693c:	0023f717          	auipc	a4,0x23f
    80006940:	04c70713          	addi	a4,a4,76 # 80245988 <mt>
    80006944:	1502                	slli	a0,a0,0x20
    80006946:	9101                	srli	a0,a0,0x20
    80006948:	e308                	sd	a0,0(a4)
    for (mti=1; mti<N; mti++)
    8000694a:	00240597          	auipc	a1,0x240
    8000694e:	3b658593          	addi	a1,a1,950 # 80246d00 <mt+0x1378>
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
    80006952:	6645                	lui	a2,0x11
    80006954:	dcd60613          	addi	a2,a2,-563 # 10dcd <_entry-0x7ffef233>
    80006958:	56fd                	li	a3,-1
    8000695a:	9281                	srli	a3,a3,0x20
    8000695c:	631c                	ld	a5,0(a4)
    8000695e:	02c787b3          	mul	a5,a5,a2
    80006962:	8ff5                	and	a5,a5,a3
    80006964:	e71c                	sd	a5,8(a4)
    for (mti=1; mti<N; mti++)
    80006966:	0721                	addi	a4,a4,8
    80006968:	feb71ae3          	bne	a4,a1,8000695c <sgenrand+0x26>
    8000696c:	27000793          	li	a5,624
    80006970:	00003717          	auipc	a4,0x3
    80006974:	06f72c23          	sw	a5,120(a4) # 800099e8 <mti>
}
    80006978:	6422                	ld	s0,8(sp)
    8000697a:	0141                	addi	sp,sp,16
    8000697c:	8082                	ret

000000008000697e <genrand>:

long /* for integer generation */
genrand()
{
    8000697e:	1141                	addi	sp,sp,-16
    80006980:	e406                	sd	ra,8(sp)
    80006982:	e022                	sd	s0,0(sp)
    80006984:	0800                	addi	s0,sp,16
    unsigned long y;
    static unsigned long mag01[2]={0x0, MATRIX_A};
    /* mag01[x] = x * MATRIX_A  for x=0,1 */

    if (mti >= N) { /* generate N words at one time */
    80006986:	00003797          	auipc	a5,0x3
    8000698a:	0627a783          	lw	a5,98(a5) # 800099e8 <mti>
    8000698e:	26f00713          	li	a4,623
    80006992:	0ef75963          	bge	a4,a5,80006a84 <genrand+0x106>
        int kk;

        if (mti == N+1)   /* if sgenrand() has not been called, */
    80006996:	27100713          	li	a4,625
    8000699a:	12e78e63          	beq	a5,a4,80006ad6 <genrand+0x158>
            sgenrand(4357); /* a default initial seed is used   */

        for (kk=0;kk<N-M;kk++) {
    8000699e:	0023f817          	auipc	a6,0x23f
    800069a2:	fea80813          	addi	a6,a6,-22 # 80245988 <mt>
    800069a6:	0023fe17          	auipc	t3,0x23f
    800069aa:	6fae0e13          	addi	t3,t3,1786 # 802460a0 <mt+0x718>
{
    800069ae:	8742                	mv	a4,a6
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
    800069b0:	4885                	li	a7,1
    800069b2:	08fe                	slli	a7,a7,0x1f
    800069b4:	80000537          	lui	a0,0x80000
    800069b8:	fff54513          	not	a0,a0
            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
    800069bc:	6585                	lui	a1,0x1
    800069be:	c6858593          	addi	a1,a1,-920 # c68 <_entry-0x7ffff398>
    800069c2:	00003317          	auipc	t1,0x3
    800069c6:	eee30313          	addi	t1,t1,-274 # 800098b0 <mag01.0>
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
    800069ca:	631c                	ld	a5,0(a4)
    800069cc:	0117f7b3          	and	a5,a5,a7
    800069d0:	6714                	ld	a3,8(a4)
    800069d2:	8ee9                	and	a3,a3,a0
    800069d4:	8fd5                	or	a5,a5,a3
            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
    800069d6:	00b70633          	add	a2,a4,a1
    800069da:	0017d693          	srli	a3,a5,0x1
    800069de:	6210                	ld	a2,0(a2)
    800069e0:	8eb1                	xor	a3,a3,a2
    800069e2:	8b85                	andi	a5,a5,1
    800069e4:	078e                	slli	a5,a5,0x3
    800069e6:	979a                	add	a5,a5,t1
    800069e8:	639c                	ld	a5,0(a5)
    800069ea:	8fb5                	xor	a5,a5,a3
    800069ec:	e31c                	sd	a5,0(a4)
        for (kk=0;kk<N-M;kk++) {
    800069ee:	0721                	addi	a4,a4,8
    800069f0:	fdc71de3          	bne	a4,t3,800069ca <genrand+0x4c>
        }
        for (;kk<N-1;kk++) {
    800069f4:	6605                	lui	a2,0x1
    800069f6:	c6060613          	addi	a2,a2,-928 # c60 <_entry-0x7ffff3a0>
    800069fa:	9642                	add	a2,a2,a6
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
    800069fc:	4505                	li	a0,1
    800069fe:	057e                	slli	a0,a0,0x1f
    80006a00:	800005b7          	lui	a1,0x80000
    80006a04:	fff5c593          	not	a1,a1
            mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1];
    80006a08:	00003897          	auipc	a7,0x3
    80006a0c:	ea888893          	addi	a7,a7,-344 # 800098b0 <mag01.0>
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
    80006a10:	71883783          	ld	a5,1816(a6)
    80006a14:	8fe9                	and	a5,a5,a0
    80006a16:	72083703          	ld	a4,1824(a6)
    80006a1a:	8f6d                	and	a4,a4,a1
    80006a1c:	8fd9                	or	a5,a5,a4
            mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1];
    80006a1e:	0017d713          	srli	a4,a5,0x1
    80006a22:	00083683          	ld	a3,0(a6)
    80006a26:	8f35                	xor	a4,a4,a3
    80006a28:	8b85                	andi	a5,a5,1
    80006a2a:	078e                	slli	a5,a5,0x3
    80006a2c:	97c6                	add	a5,a5,a7
    80006a2e:	639c                	ld	a5,0(a5)
    80006a30:	8fb9                	xor	a5,a5,a4
    80006a32:	70f83c23          	sd	a5,1816(a6)
        for (;kk<N-1;kk++) {
    80006a36:	0821                	addi	a6,a6,8
    80006a38:	fcc81ce3          	bne	a6,a2,80006a10 <genrand+0x92>
        }
        y = (mt[N-1]&UPPER_MASK)|(mt[0]&LOWER_MASK);
    80006a3c:	00240697          	auipc	a3,0x240
    80006a40:	f4c68693          	addi	a3,a3,-180 # 80246988 <mt+0x1000>
    80006a44:	3786b783          	ld	a5,888(a3)
    80006a48:	4705                	li	a4,1
    80006a4a:	077e                	slli	a4,a4,0x1f
    80006a4c:	8ff9                	and	a5,a5,a4
    80006a4e:	0023f717          	auipc	a4,0x23f
    80006a52:	f3a73703          	ld	a4,-198(a4) # 80245988 <mt>
    80006a56:	1706                	slli	a4,a4,0x21
    80006a58:	9305                	srli	a4,a4,0x21
    80006a5a:	8fd9                	or	a5,a5,a4
        mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1];
    80006a5c:	0017d713          	srli	a4,a5,0x1
    80006a60:	c606b603          	ld	a2,-928(a3)
    80006a64:	8f31                	xor	a4,a4,a2
    80006a66:	8b85                	andi	a5,a5,1
    80006a68:	078e                	slli	a5,a5,0x3
    80006a6a:	00003617          	auipc	a2,0x3
    80006a6e:	e4660613          	addi	a2,a2,-442 # 800098b0 <mag01.0>
    80006a72:	97b2                	add	a5,a5,a2
    80006a74:	639c                	ld	a5,0(a5)
    80006a76:	8fb9                	xor	a5,a5,a4
    80006a78:	36f6bc23          	sd	a5,888(a3)

        mti = 0;
    80006a7c:	00003797          	auipc	a5,0x3
    80006a80:	f607a623          	sw	zero,-148(a5) # 800099e8 <mti>
    }
  
    y = mt[mti++];
    80006a84:	00003717          	auipc	a4,0x3
    80006a88:	f6470713          	addi	a4,a4,-156 # 800099e8 <mti>
    80006a8c:	431c                	lw	a5,0(a4)
    80006a8e:	0017869b          	addiw	a3,a5,1
    80006a92:	c314                	sw	a3,0(a4)
    80006a94:	078e                	slli	a5,a5,0x3
    80006a96:	0023f717          	auipc	a4,0x23f
    80006a9a:	ef270713          	addi	a4,a4,-270 # 80245988 <mt>
    80006a9e:	97ba                	add	a5,a5,a4
    80006aa0:	639c                	ld	a5,0(a5)
    y ^= TEMPERING_SHIFT_U(y);
    80006aa2:	00b7d713          	srli	a4,a5,0xb
    80006aa6:	8f3d                	xor	a4,a4,a5
    y ^= TEMPERING_SHIFT_S(y) & TEMPERING_MASK_B;
    80006aa8:	013a67b7          	lui	a5,0x13a6
    80006aac:	8ad78793          	addi	a5,a5,-1875 # 13a58ad <_entry-0x7ec5a753>
    80006ab0:	8ff9                	and	a5,a5,a4
    80006ab2:	079e                	slli	a5,a5,0x7
    80006ab4:	8fb9                	xor	a5,a5,a4
    y ^= TEMPERING_SHIFT_T(y) & TEMPERING_MASK_C;
    80006ab6:	00f79713          	slli	a4,a5,0xf
    80006aba:	077e36b7          	lui	a3,0x77e3
    80006abe:	0696                	slli	a3,a3,0x5
    80006ac0:	8f75                	and	a4,a4,a3
    80006ac2:	8fb9                	xor	a5,a5,a4
    y ^= TEMPERING_SHIFT_L(y);
    80006ac4:	0127d513          	srli	a0,a5,0x12
    80006ac8:	8d3d                	xor	a0,a0,a5

    // Strip off uppermost bit because we want a long,
    // not an unsigned long
    return y & RAND_MAX;
    80006aca:	1506                	slli	a0,a0,0x21
}
    80006acc:	9105                	srli	a0,a0,0x21
    80006ace:	60a2                	ld	ra,8(sp)
    80006ad0:	6402                	ld	s0,0(sp)
    80006ad2:	0141                	addi	sp,sp,16
    80006ad4:	8082                	ret
            sgenrand(4357); /* a default initial seed is used   */
    80006ad6:	6505                	lui	a0,0x1
    80006ad8:	10550513          	addi	a0,a0,261 # 1105 <_entry-0x7fffeefb>
    80006adc:	00000097          	auipc	ra,0x0
    80006ae0:	e5a080e7          	jalr	-422(ra) # 80006936 <sgenrand>
    80006ae4:	bd6d                	j	8000699e <genrand+0x20>

0000000080006ae6 <random_at_most>:

// Assumes 0 <= max <= RAND_MAX
// Returns in the half-open interval [0, max]
long random_at_most(long max) {
    80006ae6:	1101                	addi	sp,sp,-32
    80006ae8:	ec06                	sd	ra,24(sp)
    80006aea:	e822                	sd	s0,16(sp)
    80006aec:	e426                	sd	s1,8(sp)
    80006aee:	e04a                	sd	s2,0(sp)
    80006af0:	1000                	addi	s0,sp,32
  unsigned long
    // max <= RAND_MAX < ULONG_MAX, so this is okay.
    num_bins = (unsigned long) max + 1,
    80006af2:	0505                	addi	a0,a0,1
    num_rand = (unsigned long) RAND_MAX + 1,
    bin_size = num_rand / num_bins,
    80006af4:	4785                	li	a5,1
    80006af6:	07fe                	slli	a5,a5,0x1f
    80006af8:	02a7d933          	divu	s2,a5,a0
    defect   = num_rand % num_bins;
    80006afc:	02a7f7b3          	remu	a5,a5,a0
  long x;
  do {
   x = genrand();
  }
  // This is carefully written not to overflow
  while (num_rand - defect <= (unsigned long)x);
    80006b00:	4485                	li	s1,1
    80006b02:	04fe                	slli	s1,s1,0x1f
    80006b04:	8c9d                	sub	s1,s1,a5
   x = genrand();
    80006b06:	00000097          	auipc	ra,0x0
    80006b0a:	e78080e7          	jalr	-392(ra) # 8000697e <genrand>
  while (num_rand - defect <= (unsigned long)x);
    80006b0e:	fe957ce3          	bgeu	a0,s1,80006b06 <random_at_most+0x20>

  // Truncated division is intentional
  return x/bin_size;
    80006b12:	03255533          	divu	a0,a0,s2
    80006b16:	60e2                	ld	ra,24(sp)
    80006b18:	6442                	ld	s0,16(sp)
    80006b1a:	64a2                	ld	s1,8(sp)
    80006b1c:	6902                	ld	s2,0(sp)
    80006b1e:	6105                	addi	sp,sp,32
    80006b20:	8082                	ret

0000000080006b22 <push>:
#include "proc.h"
#include "defs.h"

void
push(struct PriorityQueue* q, struct proc* p) {
  q->queue[q->front++] = p;
    80006b22:	411c                	lw	a5,0(a0)
    80006b24:	00379713          	slli	a4,a5,0x3
    80006b28:	972a                	add	a4,a4,a0
    80006b2a:	e70c                	sd	a1,8(a4)
    80006b2c:	2785                	addiw	a5,a5,1
  q->front %= 65;
    80006b2e:	04100713          	li	a4,65
    80006b32:	02e7e7bb          	remw	a5,a5,a4
    80006b36:	0007871b          	sext.w	a4,a5
    80006b3a:	c11c                	sw	a5,0(a0)
  if (q->front == q->back) {
    80006b3c:	415c                	lw	a5,4(a0)
    80006b3e:	00e78563          	beq	a5,a4,80006b48 <push+0x26>
    panic("Full queue push");
  }
  p->qstate = QUEUED;
    80006b42:	1c05a223          	sw	zero,452(a1) # ffffffff800001c4 <end+0xfffffffeffdb937c>
    80006b46:	8082                	ret
push(struct PriorityQueue* q, struct proc* p) {
    80006b48:	1141                	addi	sp,sp,-16
    80006b4a:	e406                	sd	ra,8(sp)
    80006b4c:	e022                	sd	s0,0(sp)
    80006b4e:	0800                	addi	s0,sp,16
    panic("Full queue push");
    80006b50:	00003517          	auipc	a0,0x3
    80006b54:	d7050513          	addi	a0,a0,-656 # 800098c0 <mag01.0+0x10>
    80006b58:	ffffa097          	auipc	ra,0xffffa
    80006b5c:	9e8080e7          	jalr	-1560(ra) # 80000540 <panic>

0000000080006b60 <pop>:
}

struct proc*
pop(struct PriorityQueue* q)
{
  if (q->back == q->front) {
    80006b60:	4158                	lw	a4,4(a0)
    80006b62:	4114                	lw	a3,0(a0)
    80006b64:	02e68163          	beq	a3,a4,80006b86 <pop+0x26>
    80006b68:	87aa                	mv	a5,a0
    panic("Empty queue pop");
  }
  struct proc* p = q->queue[q->back];
    80006b6a:	070e                	slli	a4,a4,0x3
    80006b6c:	972a                	add	a4,a4,a0
    80006b6e:	6708                	ld	a0,8(a4)
  p->qstate = NOTQUEUED;
    80006b70:	4705                	li	a4,1
    80006b72:	1ce52223          	sw	a4,452(a0)
  q->back++;
    80006b76:	43d8                	lw	a4,4(a5)
    80006b78:	2705                	addiw	a4,a4,1
  q->back %= 65;
    80006b7a:	04100693          	li	a3,65
    80006b7e:	02d7673b          	remw	a4,a4,a3
    80006b82:	c3d8                	sw	a4,4(a5)
  return p;
}
    80006b84:	8082                	ret
{
    80006b86:	1141                	addi	sp,sp,-16
    80006b88:	e406                	sd	ra,8(sp)
    80006b8a:	e022                	sd	s0,0(sp)
    80006b8c:	0800                	addi	s0,sp,16
    panic("Empty queue pop");
    80006b8e:	00003517          	auipc	a0,0x3
    80006b92:	d4250513          	addi	a0,a0,-702 # 800098d0 <mag01.0+0x20>
    80006b96:	ffffa097          	auipc	ra,0xffffa
    80006b9a:	9aa080e7          	jalr	-1622(ra) # 80000540 <panic>

0000000080006b9e <remove>:

void
remove(struct PriorityQueue* q, struct proc* p) {
    80006b9e:	1141                	addi	sp,sp,-16
    80006ba0:	e422                	sd	s0,8(sp)
    80006ba2:	0800                	addi	s0,sp,16
  if (p->qstate == NOTQUEUED) return;
    80006ba4:	1c45a703          	lw	a4,452(a1)
    80006ba8:	4785                	li	a5,1
    80006baa:	06f70463          	beq	a4,a5,80006c12 <remove+0x74>
  for (int i = q->back; i != q->front; i = (i + 1) % 65) {
    80006bae:	415c                	lw	a5,4(a0)
    80006bb0:	4114                	lw	a3,0(a0)
    80006bb2:	06d78063          	beq	a5,a3,80006c12 <remove+0x74>
    80006bb6:	04100613          	li	a2,65
    if (q->queue[i] == p) {
    80006bba:	00379713          	slli	a4,a5,0x3
    80006bbe:	972a                	add	a4,a4,a0
    80006bc0:	6718                	ld	a4,8(a4)
    80006bc2:	00b70863          	beq	a4,a1,80006bd2 <remove+0x34>
  for (int i = q->back; i != q->front; i = (i + 1) % 65) {
    80006bc6:	2785                	addiw	a5,a5,1
    80006bc8:	02c7e7bb          	remw	a5,a5,a2
    80006bcc:	fed797e3          	bne	a5,a3,80006bba <remove+0x1c>
    80006bd0:	a089                	j	80006c12 <remove+0x74>
      p->qstate = NOTQUEUED;
    80006bd2:	4705                	li	a4,1
    80006bd4:	1ce5a223          	sw	a4,452(a1)
      for (int j = i + 1; j != q->front; j = (j + 1) % 65) {
    80006bd8:	2785                	addiw	a5,a5,1
    80006bda:	410c                	lw	a1,0(a0)
    80006bdc:	02b78463          	beq	a5,a1,80006c04 <remove+0x66>
        q->queue[(j - 1 + 65) % 65] = q->queue[j];
    80006be0:	04100693          	li	a3,65
    80006be4:	00379713          	slli	a4,a5,0x3
    80006be8:	972a                	add	a4,a4,a0
    80006bea:	6710                	ld	a2,8(a4)
    80006bec:	0407871b          	addiw	a4,a5,64
    80006bf0:	02d7673b          	remw	a4,a4,a3
    80006bf4:	070e                	slli	a4,a4,0x3
    80006bf6:	972a                	add	a4,a4,a0
    80006bf8:	e710                	sd	a2,8(a4)
      for (int j = i + 1; j != q->front; j = (j + 1) % 65) {
    80006bfa:	2785                	addiw	a5,a5,1
    80006bfc:	02d7e7bb          	remw	a5,a5,a3
    80006c00:	feb792e3          	bne	a5,a1,80006be4 <remove+0x46>
      }
      q->front = (q->front - 1 + 65) % 65;
    80006c04:	0405859b          	addiw	a1,a1,64
    80006c08:	04100793          	li	a5,65
    80006c0c:	02f5e5bb          	remw	a1,a1,a5
    80006c10:	c10c                	sw	a1,0(a0)
      break;
    }
  }
}
    80006c12:	6422                	ld	s0,8(sp)
    80006c14:	0141                	addi	sp,sp,16
    80006c16:	8082                	ret

0000000080006c18 <empty>:

int
empty(struct PriorityQueue q) {
    80006c18:	1141                	addi	sp,sp,-16
    80006c1a:	e422                	sd	s0,8(sp)
    80006c1c:	0800                	addi	s0,sp,16
  return (q.front - q.back + 65) % 65 == 0;
    80006c1e:	411c                	lw	a5,0(a0)
    80006c20:	4158                	lw	a4,4(a0)
    80006c22:	40e7853b          	subw	a0,a5,a4
    80006c26:	0415051b          	addiw	a0,a0,65
    80006c2a:	04100793          	li	a5,65
    80006c2e:	02f5653b          	remw	a0,a0,a5
}
    80006c32:	00153513          	seqz	a0,a0
    80006c36:	6422                	ld	s0,8(sp)
    80006c38:	0141                	addi	sp,sp,16
    80006c3a:	8082                	ret

0000000080006c3c <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006c3c:	1141                	addi	sp,sp,-16
    80006c3e:	e406                	sd	ra,8(sp)
    80006c40:	e022                	sd	s0,0(sp)
    80006c42:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006c44:	479d                	li	a5,7
    80006c46:	04a7cc63          	blt	a5,a0,80006c9e <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006c4a:	00240797          	auipc	a5,0x240
    80006c4e:	0be78793          	addi	a5,a5,190 # 80246d08 <disk>
    80006c52:	97aa                	add	a5,a5,a0
    80006c54:	0187c783          	lbu	a5,24(a5)
    80006c58:	ebb9                	bnez	a5,80006cae <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006c5a:	00451693          	slli	a3,a0,0x4
    80006c5e:	00240797          	auipc	a5,0x240
    80006c62:	0aa78793          	addi	a5,a5,170 # 80246d08 <disk>
    80006c66:	6398                	ld	a4,0(a5)
    80006c68:	9736                	add	a4,a4,a3
    80006c6a:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80006c6e:	6398                	ld	a4,0(a5)
    80006c70:	9736                	add	a4,a4,a3
    80006c72:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006c76:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006c7a:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006c7e:	97aa                	add	a5,a5,a0
    80006c80:	4705                	li	a4,1
    80006c82:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006c86:	00240517          	auipc	a0,0x240
    80006c8a:	09a50513          	addi	a0,a0,154 # 80246d20 <disk+0x18>
    80006c8e:	ffffc097          	auipc	ra,0xffffc
    80006c92:	87a080e7          	jalr	-1926(ra) # 80002508 <wakeup>
}
    80006c96:	60a2                	ld	ra,8(sp)
    80006c98:	6402                	ld	s0,0(sp)
    80006c9a:	0141                	addi	sp,sp,16
    80006c9c:	8082                	ret
    panic("free_desc 1");
    80006c9e:	00003517          	auipc	a0,0x3
    80006ca2:	c4250513          	addi	a0,a0,-958 # 800098e0 <mag01.0+0x30>
    80006ca6:	ffffa097          	auipc	ra,0xffffa
    80006caa:	89a080e7          	jalr	-1894(ra) # 80000540 <panic>
    panic("free_desc 2");
    80006cae:	00003517          	auipc	a0,0x3
    80006cb2:	c4250513          	addi	a0,a0,-958 # 800098f0 <mag01.0+0x40>
    80006cb6:	ffffa097          	auipc	ra,0xffffa
    80006cba:	88a080e7          	jalr	-1910(ra) # 80000540 <panic>

0000000080006cbe <virtio_disk_init>:
{
    80006cbe:	1101                	addi	sp,sp,-32
    80006cc0:	ec06                	sd	ra,24(sp)
    80006cc2:	e822                	sd	s0,16(sp)
    80006cc4:	e426                	sd	s1,8(sp)
    80006cc6:	e04a                	sd	s2,0(sp)
    80006cc8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006cca:	00003597          	auipc	a1,0x3
    80006cce:	c3658593          	addi	a1,a1,-970 # 80009900 <mag01.0+0x50>
    80006cd2:	00240517          	auipc	a0,0x240
    80006cd6:	15e50513          	addi	a0,a0,350 # 80246e30 <disk+0x128>
    80006cda:	ffffa097          	auipc	ra,0xffffa
    80006cde:	f8a080e7          	jalr	-118(ra) # 80000c64 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006ce2:	100017b7          	lui	a5,0x10001
    80006ce6:	4398                	lw	a4,0(a5)
    80006ce8:	2701                	sext.w	a4,a4
    80006cea:	747277b7          	lui	a5,0x74727
    80006cee:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006cf2:	14f71b63          	bne	a4,a5,80006e48 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006cf6:	100017b7          	lui	a5,0x10001
    80006cfa:	43dc                	lw	a5,4(a5)
    80006cfc:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006cfe:	4709                	li	a4,2
    80006d00:	14e79463          	bne	a5,a4,80006e48 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006d04:	100017b7          	lui	a5,0x10001
    80006d08:	479c                	lw	a5,8(a5)
    80006d0a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006d0c:	12e79e63          	bne	a5,a4,80006e48 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006d10:	100017b7          	lui	a5,0x10001
    80006d14:	47d8                	lw	a4,12(a5)
    80006d16:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006d18:	554d47b7          	lui	a5,0x554d4
    80006d1c:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006d20:	12f71463          	bne	a4,a5,80006e48 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006d24:	100017b7          	lui	a5,0x10001
    80006d28:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006d2c:	4705                	li	a4,1
    80006d2e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006d30:	470d                	li	a4,3
    80006d32:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006d34:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006d36:	c7ffe6b7          	lui	a3,0xc7ffe
    80006d3a:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47db7917>
    80006d3e:	8f75                	and	a4,a4,a3
    80006d40:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006d42:	472d                	li	a4,11
    80006d44:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80006d46:	5bbc                	lw	a5,112(a5)
    80006d48:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006d4c:	8ba1                	andi	a5,a5,8
    80006d4e:	10078563          	beqz	a5,80006e58 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006d52:	100017b7          	lui	a5,0x10001
    80006d56:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006d5a:	43fc                	lw	a5,68(a5)
    80006d5c:	2781                	sext.w	a5,a5
    80006d5e:	10079563          	bnez	a5,80006e68 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006d62:	100017b7          	lui	a5,0x10001
    80006d66:	5bdc                	lw	a5,52(a5)
    80006d68:	2781                	sext.w	a5,a5
  if(max == 0)
    80006d6a:	10078763          	beqz	a5,80006e78 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80006d6e:	471d                	li	a4,7
    80006d70:	10f77c63          	bgeu	a4,a5,80006e88 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    80006d74:	ffffa097          	auipc	ra,0xffffa
    80006d78:	e86080e7          	jalr	-378(ra) # 80000bfa <kalloc>
    80006d7c:	00240497          	auipc	s1,0x240
    80006d80:	f8c48493          	addi	s1,s1,-116 # 80246d08 <disk>
    80006d84:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006d86:	ffffa097          	auipc	ra,0xffffa
    80006d8a:	e74080e7          	jalr	-396(ra) # 80000bfa <kalloc>
    80006d8e:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80006d90:	ffffa097          	auipc	ra,0xffffa
    80006d94:	e6a080e7          	jalr	-406(ra) # 80000bfa <kalloc>
    80006d98:	87aa                	mv	a5,a0
    80006d9a:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006d9c:	6088                	ld	a0,0(s1)
    80006d9e:	cd6d                	beqz	a0,80006e98 <virtio_disk_init+0x1da>
    80006da0:	00240717          	auipc	a4,0x240
    80006da4:	f7073703          	ld	a4,-144(a4) # 80246d10 <disk+0x8>
    80006da8:	cb65                	beqz	a4,80006e98 <virtio_disk_init+0x1da>
    80006daa:	c7fd                	beqz	a5,80006e98 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80006dac:	6605                	lui	a2,0x1
    80006dae:	4581                	li	a1,0
    80006db0:	ffffa097          	auipc	ra,0xffffa
    80006db4:	040080e7          	jalr	64(ra) # 80000df0 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006db8:	00240497          	auipc	s1,0x240
    80006dbc:	f5048493          	addi	s1,s1,-176 # 80246d08 <disk>
    80006dc0:	6605                	lui	a2,0x1
    80006dc2:	4581                	li	a1,0
    80006dc4:	6488                	ld	a0,8(s1)
    80006dc6:	ffffa097          	auipc	ra,0xffffa
    80006dca:	02a080e7          	jalr	42(ra) # 80000df0 <memset>
  memset(disk.used, 0, PGSIZE);
    80006dce:	6605                	lui	a2,0x1
    80006dd0:	4581                	li	a1,0
    80006dd2:	6888                	ld	a0,16(s1)
    80006dd4:	ffffa097          	auipc	ra,0xffffa
    80006dd8:	01c080e7          	jalr	28(ra) # 80000df0 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006ddc:	100017b7          	lui	a5,0x10001
    80006de0:	4721                	li	a4,8
    80006de2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006de4:	4098                	lw	a4,0(s1)
    80006de6:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006dea:	40d8                	lw	a4,4(s1)
    80006dec:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006df0:	6498                	ld	a4,8(s1)
    80006df2:	0007069b          	sext.w	a3,a4
    80006df6:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006dfa:	9701                	srai	a4,a4,0x20
    80006dfc:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006e00:	6898                	ld	a4,16(s1)
    80006e02:	0007069b          	sext.w	a3,a4
    80006e06:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006e0a:	9701                	srai	a4,a4,0x20
    80006e0c:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006e10:	4705                	li	a4,1
    80006e12:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80006e14:	00e48c23          	sb	a4,24(s1)
    80006e18:	00e48ca3          	sb	a4,25(s1)
    80006e1c:	00e48d23          	sb	a4,26(s1)
    80006e20:	00e48da3          	sb	a4,27(s1)
    80006e24:	00e48e23          	sb	a4,28(s1)
    80006e28:	00e48ea3          	sb	a4,29(s1)
    80006e2c:	00e48f23          	sb	a4,30(s1)
    80006e30:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006e34:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006e38:	0727a823          	sw	s2,112(a5)
}
    80006e3c:	60e2                	ld	ra,24(sp)
    80006e3e:	6442                	ld	s0,16(sp)
    80006e40:	64a2                	ld	s1,8(sp)
    80006e42:	6902                	ld	s2,0(sp)
    80006e44:	6105                	addi	sp,sp,32
    80006e46:	8082                	ret
    panic("could not find virtio disk");
    80006e48:	00003517          	auipc	a0,0x3
    80006e4c:	ac850513          	addi	a0,a0,-1336 # 80009910 <mag01.0+0x60>
    80006e50:	ffff9097          	auipc	ra,0xffff9
    80006e54:	6f0080e7          	jalr	1776(ra) # 80000540 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006e58:	00003517          	auipc	a0,0x3
    80006e5c:	ad850513          	addi	a0,a0,-1320 # 80009930 <mag01.0+0x80>
    80006e60:	ffff9097          	auipc	ra,0xffff9
    80006e64:	6e0080e7          	jalr	1760(ra) # 80000540 <panic>
    panic("virtio disk should not be ready");
    80006e68:	00003517          	auipc	a0,0x3
    80006e6c:	ae850513          	addi	a0,a0,-1304 # 80009950 <mag01.0+0xa0>
    80006e70:	ffff9097          	auipc	ra,0xffff9
    80006e74:	6d0080e7          	jalr	1744(ra) # 80000540 <panic>
    panic("virtio disk has no queue 0");
    80006e78:	00003517          	auipc	a0,0x3
    80006e7c:	af850513          	addi	a0,a0,-1288 # 80009970 <mag01.0+0xc0>
    80006e80:	ffff9097          	auipc	ra,0xffff9
    80006e84:	6c0080e7          	jalr	1728(ra) # 80000540 <panic>
    panic("virtio disk max queue too short");
    80006e88:	00003517          	auipc	a0,0x3
    80006e8c:	b0850513          	addi	a0,a0,-1272 # 80009990 <mag01.0+0xe0>
    80006e90:	ffff9097          	auipc	ra,0xffff9
    80006e94:	6b0080e7          	jalr	1712(ra) # 80000540 <panic>
    panic("virtio disk kalloc");
    80006e98:	00003517          	auipc	a0,0x3
    80006e9c:	b1850513          	addi	a0,a0,-1256 # 800099b0 <mag01.0+0x100>
    80006ea0:	ffff9097          	auipc	ra,0xffff9
    80006ea4:	6a0080e7          	jalr	1696(ra) # 80000540 <panic>

0000000080006ea8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006ea8:	7119                	addi	sp,sp,-128
    80006eaa:	fc86                	sd	ra,120(sp)
    80006eac:	f8a2                	sd	s0,112(sp)
    80006eae:	f4a6                	sd	s1,104(sp)
    80006eb0:	f0ca                	sd	s2,96(sp)
    80006eb2:	ecce                	sd	s3,88(sp)
    80006eb4:	e8d2                	sd	s4,80(sp)
    80006eb6:	e4d6                	sd	s5,72(sp)
    80006eb8:	e0da                	sd	s6,64(sp)
    80006eba:	fc5e                	sd	s7,56(sp)
    80006ebc:	f862                	sd	s8,48(sp)
    80006ebe:	f466                	sd	s9,40(sp)
    80006ec0:	f06a                	sd	s10,32(sp)
    80006ec2:	ec6e                	sd	s11,24(sp)
    80006ec4:	0100                	addi	s0,sp,128
    80006ec6:	8aaa                	mv	s5,a0
    80006ec8:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006eca:	00c52d03          	lw	s10,12(a0)
    80006ece:	001d1d1b          	slliw	s10,s10,0x1
    80006ed2:	1d02                	slli	s10,s10,0x20
    80006ed4:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80006ed8:	00240517          	auipc	a0,0x240
    80006edc:	f5850513          	addi	a0,a0,-168 # 80246e30 <disk+0x128>
    80006ee0:	ffffa097          	auipc	ra,0xffffa
    80006ee4:	e14080e7          	jalr	-492(ra) # 80000cf4 <acquire>
  for(int i = 0; i < 3; i++){
    80006ee8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006eea:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006eec:	00240b97          	auipc	s7,0x240
    80006ef0:	e1cb8b93          	addi	s7,s7,-484 # 80246d08 <disk>
  for(int i = 0; i < 3; i++){
    80006ef4:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006ef6:	00240c97          	auipc	s9,0x240
    80006efa:	f3ac8c93          	addi	s9,s9,-198 # 80246e30 <disk+0x128>
    80006efe:	a08d                	j	80006f60 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80006f00:	00fb8733          	add	a4,s7,a5
    80006f04:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006f08:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006f0a:	0207c563          	bltz	a5,80006f34 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    80006f0e:	2905                	addiw	s2,s2,1
    80006f10:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006f12:	05690c63          	beq	s2,s6,80006f6a <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80006f16:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006f18:	00240717          	auipc	a4,0x240
    80006f1c:	df070713          	addi	a4,a4,-528 # 80246d08 <disk>
    80006f20:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006f22:	01874683          	lbu	a3,24(a4)
    80006f26:	fee9                	bnez	a3,80006f00 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80006f28:	2785                	addiw	a5,a5,1
    80006f2a:	0705                	addi	a4,a4,1
    80006f2c:	fe979be3          	bne	a5,s1,80006f22 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80006f30:	57fd                	li	a5,-1
    80006f32:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006f34:	01205d63          	blez	s2,80006f4e <virtio_disk_rw+0xa6>
    80006f38:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006f3a:	000a2503          	lw	a0,0(s4)
    80006f3e:	00000097          	auipc	ra,0x0
    80006f42:	cfe080e7          	jalr	-770(ra) # 80006c3c <free_desc>
      for(int j = 0; j < i; j++)
    80006f46:	2d85                	addiw	s11,s11,1
    80006f48:	0a11                	addi	s4,s4,4
    80006f4a:	ff2d98e3          	bne	s11,s2,80006f3a <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006f4e:	85e6                	mv	a1,s9
    80006f50:	00240517          	auipc	a0,0x240
    80006f54:	dd050513          	addi	a0,a0,-560 # 80246d20 <disk+0x18>
    80006f58:	ffffb097          	auipc	ra,0xffffb
    80006f5c:	54c080e7          	jalr	1356(ra) # 800024a4 <sleep>
  for(int i = 0; i < 3; i++){
    80006f60:	f8040a13          	addi	s4,s0,-128
{
    80006f64:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006f66:	894e                	mv	s2,s3
    80006f68:	b77d                	j	80006f16 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006f6a:	f8042503          	lw	a0,-128(s0)
    80006f6e:	00a50713          	addi	a4,a0,10
    80006f72:	0712                	slli	a4,a4,0x4

  if(write)
    80006f74:	00240797          	auipc	a5,0x240
    80006f78:	d9478793          	addi	a5,a5,-620 # 80246d08 <disk>
    80006f7c:	00e786b3          	add	a3,a5,a4
    80006f80:	01803633          	snez	a2,s8
    80006f84:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006f86:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80006f8a:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006f8e:	f6070613          	addi	a2,a4,-160
    80006f92:	6394                	ld	a3,0(a5)
    80006f94:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006f96:	00870593          	addi	a1,a4,8
    80006f9a:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006f9c:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006f9e:	0007b803          	ld	a6,0(a5)
    80006fa2:	9642                	add	a2,a2,a6
    80006fa4:	46c1                	li	a3,16
    80006fa6:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006fa8:	4585                	li	a1,1
    80006faa:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80006fae:	f8442683          	lw	a3,-124(s0)
    80006fb2:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006fb6:	0692                	slli	a3,a3,0x4
    80006fb8:	9836                	add	a6,a6,a3
    80006fba:	058a8613          	addi	a2,s5,88
    80006fbe:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    80006fc2:	0007b803          	ld	a6,0(a5)
    80006fc6:	96c2                	add	a3,a3,a6
    80006fc8:	40000613          	li	a2,1024
    80006fcc:	c690                	sw	a2,8(a3)
  if(write)
    80006fce:	001c3613          	seqz	a2,s8
    80006fd2:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006fd6:	00166613          	ori	a2,a2,1
    80006fda:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80006fde:	f8842603          	lw	a2,-120(s0)
    80006fe2:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006fe6:	00250693          	addi	a3,a0,2
    80006fea:	0692                	slli	a3,a3,0x4
    80006fec:	96be                	add	a3,a3,a5
    80006fee:	58fd                	li	a7,-1
    80006ff0:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006ff4:	0612                	slli	a2,a2,0x4
    80006ff6:	9832                	add	a6,a6,a2
    80006ff8:	f9070713          	addi	a4,a4,-112
    80006ffc:	973e                	add	a4,a4,a5
    80006ffe:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    80007002:	6398                	ld	a4,0(a5)
    80007004:	9732                	add	a4,a4,a2
    80007006:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80007008:	4609                	li	a2,2
    8000700a:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    8000700e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80007012:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80007016:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000701a:	6794                	ld	a3,8(a5)
    8000701c:	0026d703          	lhu	a4,2(a3)
    80007020:	8b1d                	andi	a4,a4,7
    80007022:	0706                	slli	a4,a4,0x1
    80007024:	96ba                	add	a3,a3,a4
    80007026:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000702a:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000702e:	6798                	ld	a4,8(a5)
    80007030:	00275783          	lhu	a5,2(a4)
    80007034:	2785                	addiw	a5,a5,1
    80007036:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000703a:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000703e:	100017b7          	lui	a5,0x10001
    80007042:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80007046:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    8000704a:	00240917          	auipc	s2,0x240
    8000704e:	de690913          	addi	s2,s2,-538 # 80246e30 <disk+0x128>
  while(b->disk == 1) {
    80007052:	4485                	li	s1,1
    80007054:	00b79c63          	bne	a5,a1,8000706c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80007058:	85ca                	mv	a1,s2
    8000705a:	8556                	mv	a0,s5
    8000705c:	ffffb097          	auipc	ra,0xffffb
    80007060:	448080e7          	jalr	1096(ra) # 800024a4 <sleep>
  while(b->disk == 1) {
    80007064:	004aa783          	lw	a5,4(s5)
    80007068:	fe9788e3          	beq	a5,s1,80007058 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    8000706c:	f8042903          	lw	s2,-128(s0)
    80007070:	00290713          	addi	a4,s2,2
    80007074:	0712                	slli	a4,a4,0x4
    80007076:	00240797          	auipc	a5,0x240
    8000707a:	c9278793          	addi	a5,a5,-878 # 80246d08 <disk>
    8000707e:	97ba                	add	a5,a5,a4
    80007080:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80007084:	00240997          	auipc	s3,0x240
    80007088:	c8498993          	addi	s3,s3,-892 # 80246d08 <disk>
    8000708c:	00491713          	slli	a4,s2,0x4
    80007090:	0009b783          	ld	a5,0(s3)
    80007094:	97ba                	add	a5,a5,a4
    80007096:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000709a:	854a                	mv	a0,s2
    8000709c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800070a0:	00000097          	auipc	ra,0x0
    800070a4:	b9c080e7          	jalr	-1124(ra) # 80006c3c <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800070a8:	8885                	andi	s1,s1,1
    800070aa:	f0ed                	bnez	s1,8000708c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800070ac:	00240517          	auipc	a0,0x240
    800070b0:	d8450513          	addi	a0,a0,-636 # 80246e30 <disk+0x128>
    800070b4:	ffffa097          	auipc	ra,0xffffa
    800070b8:	cf4080e7          	jalr	-780(ra) # 80000da8 <release>
}
    800070bc:	70e6                	ld	ra,120(sp)
    800070be:	7446                	ld	s0,112(sp)
    800070c0:	74a6                	ld	s1,104(sp)
    800070c2:	7906                	ld	s2,96(sp)
    800070c4:	69e6                	ld	s3,88(sp)
    800070c6:	6a46                	ld	s4,80(sp)
    800070c8:	6aa6                	ld	s5,72(sp)
    800070ca:	6b06                	ld	s6,64(sp)
    800070cc:	7be2                	ld	s7,56(sp)
    800070ce:	7c42                	ld	s8,48(sp)
    800070d0:	7ca2                	ld	s9,40(sp)
    800070d2:	7d02                	ld	s10,32(sp)
    800070d4:	6de2                	ld	s11,24(sp)
    800070d6:	6109                	addi	sp,sp,128
    800070d8:	8082                	ret

00000000800070da <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800070da:	1101                	addi	sp,sp,-32
    800070dc:	ec06                	sd	ra,24(sp)
    800070de:	e822                	sd	s0,16(sp)
    800070e0:	e426                	sd	s1,8(sp)
    800070e2:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800070e4:	00240497          	auipc	s1,0x240
    800070e8:	c2448493          	addi	s1,s1,-988 # 80246d08 <disk>
    800070ec:	00240517          	auipc	a0,0x240
    800070f0:	d4450513          	addi	a0,a0,-700 # 80246e30 <disk+0x128>
    800070f4:	ffffa097          	auipc	ra,0xffffa
    800070f8:	c00080e7          	jalr	-1024(ra) # 80000cf4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800070fc:	10001737          	lui	a4,0x10001
    80007100:	533c                	lw	a5,96(a4)
    80007102:	8b8d                	andi	a5,a5,3
    80007104:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80007106:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000710a:	689c                	ld	a5,16(s1)
    8000710c:	0204d703          	lhu	a4,32(s1)
    80007110:	0027d783          	lhu	a5,2(a5)
    80007114:	04f70863          	beq	a4,a5,80007164 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80007118:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000711c:	6898                	ld	a4,16(s1)
    8000711e:	0204d783          	lhu	a5,32(s1)
    80007122:	8b9d                	andi	a5,a5,7
    80007124:	078e                	slli	a5,a5,0x3
    80007126:	97ba                	add	a5,a5,a4
    80007128:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000712a:	00278713          	addi	a4,a5,2
    8000712e:	0712                	slli	a4,a4,0x4
    80007130:	9726                	add	a4,a4,s1
    80007132:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80007136:	e721                	bnez	a4,8000717e <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80007138:	0789                	addi	a5,a5,2
    8000713a:	0792                	slli	a5,a5,0x4
    8000713c:	97a6                	add	a5,a5,s1
    8000713e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80007140:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80007144:	ffffb097          	auipc	ra,0xffffb
    80007148:	3c4080e7          	jalr	964(ra) # 80002508 <wakeup>

    disk.used_idx += 1;
    8000714c:	0204d783          	lhu	a5,32(s1)
    80007150:	2785                	addiw	a5,a5,1
    80007152:	17c2                	slli	a5,a5,0x30
    80007154:	93c1                	srli	a5,a5,0x30
    80007156:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000715a:	6898                	ld	a4,16(s1)
    8000715c:	00275703          	lhu	a4,2(a4)
    80007160:	faf71ce3          	bne	a4,a5,80007118 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80007164:	00240517          	auipc	a0,0x240
    80007168:	ccc50513          	addi	a0,a0,-820 # 80246e30 <disk+0x128>
    8000716c:	ffffa097          	auipc	ra,0xffffa
    80007170:	c3c080e7          	jalr	-964(ra) # 80000da8 <release>
}
    80007174:	60e2                	ld	ra,24(sp)
    80007176:	6442                	ld	s0,16(sp)
    80007178:	64a2                	ld	s1,8(sp)
    8000717a:	6105                	addi	sp,sp,32
    8000717c:	8082                	ret
      panic("virtio_disk_intr status");
    8000717e:	00003517          	auipc	a0,0x3
    80007182:	84a50513          	addi	a0,a0,-1974 # 800099c8 <mag01.0+0x118>
    80007186:	ffff9097          	auipc	ra,0xffff9
    8000718a:	3ba080e7          	jalr	954(ra) # 80000540 <panic>
	...

0000000080008000 <_trampoline>:
    80008000:	14051073          	csrw	sscratch,a0
    80008004:	02000537          	lui	a0,0x2000
    80008008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000800a:	0536                	slli	a0,a0,0xd
    8000800c:	02153423          	sd	ra,40(a0)
    80008010:	02253823          	sd	sp,48(a0)
    80008014:	02353c23          	sd	gp,56(a0)
    80008018:	04453023          	sd	tp,64(a0)
    8000801c:	04553423          	sd	t0,72(a0)
    80008020:	04653823          	sd	t1,80(a0)
    80008024:	04753c23          	sd	t2,88(a0)
    80008028:	f120                	sd	s0,96(a0)
    8000802a:	f524                	sd	s1,104(a0)
    8000802c:	fd2c                	sd	a1,120(a0)
    8000802e:	e150                	sd	a2,128(a0)
    80008030:	e554                	sd	a3,136(a0)
    80008032:	e958                	sd	a4,144(a0)
    80008034:	ed5c                	sd	a5,152(a0)
    80008036:	0b053023          	sd	a6,160(a0)
    8000803a:	0b153423          	sd	a7,168(a0)
    8000803e:	0b253823          	sd	s2,176(a0)
    80008042:	0b353c23          	sd	s3,184(a0)
    80008046:	0d453023          	sd	s4,192(a0)
    8000804a:	0d553423          	sd	s5,200(a0)
    8000804e:	0d653823          	sd	s6,208(a0)
    80008052:	0d753c23          	sd	s7,216(a0)
    80008056:	0f853023          	sd	s8,224(a0)
    8000805a:	0f953423          	sd	s9,232(a0)
    8000805e:	0fa53823          	sd	s10,240(a0)
    80008062:	0fb53c23          	sd	s11,248(a0)
    80008066:	11c53023          	sd	t3,256(a0)
    8000806a:	11d53423          	sd	t4,264(a0)
    8000806e:	11e53823          	sd	t5,272(a0)
    80008072:	11f53c23          	sd	t6,280(a0)
    80008076:	140022f3          	csrr	t0,sscratch
    8000807a:	06553823          	sd	t0,112(a0)
    8000807e:	00853103          	ld	sp,8(a0)
    80008082:	02053203          	ld	tp,32(a0)
    80008086:	01053283          	ld	t0,16(a0)
    8000808a:	00053303          	ld	t1,0(a0)
    8000808e:	12000073          	sfence.vma
    80008092:	18031073          	csrw	satp,t1
    80008096:	12000073          	sfence.vma
    8000809a:	8282                	jr	t0

000000008000809c <userret>:
    8000809c:	12000073          	sfence.vma
    800080a0:	18051073          	csrw	satp,a0
    800080a4:	12000073          	sfence.vma
    800080a8:	02000537          	lui	a0,0x2000
    800080ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800080ae:	0536                	slli	a0,a0,0xd
    800080b0:	02853083          	ld	ra,40(a0)
    800080b4:	03053103          	ld	sp,48(a0)
    800080b8:	03853183          	ld	gp,56(a0)
    800080bc:	04053203          	ld	tp,64(a0)
    800080c0:	04853283          	ld	t0,72(a0)
    800080c4:	05053303          	ld	t1,80(a0)
    800080c8:	05853383          	ld	t2,88(a0)
    800080cc:	7120                	ld	s0,96(a0)
    800080ce:	7524                	ld	s1,104(a0)
    800080d0:	7d2c                	ld	a1,120(a0)
    800080d2:	6150                	ld	a2,128(a0)
    800080d4:	6554                	ld	a3,136(a0)
    800080d6:	6958                	ld	a4,144(a0)
    800080d8:	6d5c                	ld	a5,152(a0)
    800080da:	0a053803          	ld	a6,160(a0)
    800080de:	0a853883          	ld	a7,168(a0)
    800080e2:	0b053903          	ld	s2,176(a0)
    800080e6:	0b853983          	ld	s3,184(a0)
    800080ea:	0c053a03          	ld	s4,192(a0)
    800080ee:	0c853a83          	ld	s5,200(a0)
    800080f2:	0d053b03          	ld	s6,208(a0)
    800080f6:	0d853b83          	ld	s7,216(a0)
    800080fa:	0e053c03          	ld	s8,224(a0)
    800080fe:	0e853c83          	ld	s9,232(a0)
    80008102:	0f053d03          	ld	s10,240(a0)
    80008106:	0f853d83          	ld	s11,248(a0)
    8000810a:	10053e03          	ld	t3,256(a0)
    8000810e:	10853e83          	ld	t4,264(a0)
    80008112:	11053f03          	ld	t5,272(a0)
    80008116:	11853f83          	ld	t6,280(a0)
    8000811a:	7928                	ld	a0,112(a0)
    8000811c:	10200073          	sret
	...
