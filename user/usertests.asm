
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	bf0080e7          	jalr	-1040(ra) # 5c00 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	bde080e7          	jalr	-1058(ra) # 5c00 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	0d250513          	addi	a0,a0,210 # 6110 <malloc+0xee>
      46:	00006097          	auipc	ra,0x6
      4a:	f24080e7          	jalr	-220(ra) # 5f6a <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	b70080e7          	jalr	-1168(ra) # 5bc0 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000a797          	auipc	a5,0xa
      5c:	4f078793          	addi	a5,a5,1264 # a548 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	bf868693          	addi	a3,a3,-1032 # cc58 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	0b050513          	addi	a0,a0,176 # 6130 <malloc+0x10e>
      88:	00006097          	auipc	ra,0x6
      8c:	ee2080e7          	jalr	-286(ra) # 5f6a <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	b2e080e7          	jalr	-1234(ra) # 5bc0 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	0a050513          	addi	a0,a0,160 # 6148 <malloc+0x126>
      b0:	00006097          	auipc	ra,0x6
      b4:	b50080e7          	jalr	-1200(ra) # 5c00 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	b2c080e7          	jalr	-1236(ra) # 5be8 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	0a250513          	addi	a0,a0,162 # 6168 <malloc+0x146>
      ce:	00006097          	auipc	ra,0x6
      d2:	b32080e7          	jalr	-1230(ra) # 5c00 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	06a50513          	addi	a0,a0,106 # 6150 <malloc+0x12e>
      ee:	00006097          	auipc	ra,0x6
      f2:	e7c080e7          	jalr	-388(ra) # 5f6a <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	ac8080e7          	jalr	-1336(ra) # 5bc0 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	07650513          	addi	a0,a0,118 # 6178 <malloc+0x156>
     10a:	00006097          	auipc	ra,0x6
     10e:	e60080e7          	jalr	-416(ra) # 5f6a <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	aac080e7          	jalr	-1364(ra) # 5bc0 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	07450513          	addi	a0,a0,116 # 61a0 <malloc+0x17e>
     134:	00006097          	auipc	ra,0x6
     138:	adc080e7          	jalr	-1316(ra) # 5c10 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	06050513          	addi	a0,a0,96 # 61a0 <malloc+0x17e>
     148:	00006097          	auipc	ra,0x6
     14c:	ab8080e7          	jalr	-1352(ra) # 5c00 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	05c58593          	addi	a1,a1,92 # 61b0 <malloc+0x18e>
     15c:	00006097          	auipc	ra,0x6
     160:	a84080e7          	jalr	-1404(ra) # 5be0 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	03850513          	addi	a0,a0,56 # 61a0 <malloc+0x17e>
     170:	00006097          	auipc	ra,0x6
     174:	a90080e7          	jalr	-1392(ra) # 5c00 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	03c58593          	addi	a1,a1,60 # 61b8 <malloc+0x196>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	a5a080e7          	jalr	-1446(ra) # 5be0 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	00c50513          	addi	a0,a0,12 # 61a0 <malloc+0x17e>
     19c:	00006097          	auipc	ra,0x6
     1a0:	a74080e7          	jalr	-1420(ra) # 5c10 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a42080e7          	jalr	-1470(ra) # 5be8 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a38080e7          	jalr	-1480(ra) # 5be8 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	ff650513          	addi	a0,a0,-10 # 61c0 <malloc+0x19e>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	d98080e7          	jalr	-616(ra) # 5f6a <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	9e4080e7          	jalr	-1564(ra) # 5bc0 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	9f0080e7          	jalr	-1552(ra) # 5c00 <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	9d0080e7          	jalr	-1584(ra) # 5be8 <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	9ca080e7          	jalr	-1590(ra) # 5c10 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	f6c50513          	addi	a0,a0,-148 # 61e8 <malloc+0x1c6>
     284:	00006097          	auipc	ra,0x6
     288:	98c080e7          	jalr	-1652(ra) # 5c10 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	f58a8a93          	addi	s5,s5,-168 # 61e8 <malloc+0x1c6>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9c0a0a13          	addi	s4,s4,-1600 # cc58 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <diskfull+0x145>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	954080e7          	jalr	-1708(ra) # 5c00 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	922080e7          	jalr	-1758(ra) # 5be0 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	90e080e7          	jalr	-1778(ra) # 5be0 <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	908080e7          	jalr	-1784(ra) # 5be8 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	926080e7          	jalr	-1754(ra) # 5c10 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	ee650513          	addi	a0,a0,-282 # 61f8 <malloc+0x1d6>
     31a:	00006097          	auipc	ra,0x6
     31e:	c50080e7          	jalr	-944(ra) # 5f6a <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	89c080e7          	jalr	-1892(ra) # 5bc0 <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	ee450513          	addi	a0,a0,-284 # 6218 <malloc+0x1f6>
     33c:	00006097          	auipc	ra,0x6
     340:	c2e080e7          	jalr	-978(ra) # 5f6a <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00006097          	auipc	ra,0x6
     34a:	87a080e7          	jalr	-1926(ra) # 5bc0 <exit>

000000000000034e <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     34e:	7179                	addi	sp,sp,-48
     350:	f406                	sd	ra,40(sp)
     352:	f022                	sd	s0,32(sp)
     354:	ec26                	sd	s1,24(sp)
     356:	e84a                	sd	s2,16(sp)
     358:	e44e                	sd	s3,8(sp)
     35a:	e052                	sd	s4,0(sp)
     35c:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     35e:	00006517          	auipc	a0,0x6
     362:	ed250513          	addi	a0,a0,-302 # 6230 <malloc+0x20e>
     366:	00006097          	auipc	ra,0x6
     36a:	8aa080e7          	jalr	-1878(ra) # 5c10 <unlink>
     36e:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     372:	00006997          	auipc	s3,0x6
     376:	ebe98993          	addi	s3,s3,-322 # 6230 <malloc+0x20e>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37a:	5a7d                	li	s4,-1
     37c:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     380:	20100593          	li	a1,513
     384:	854e                	mv	a0,s3
     386:	00006097          	auipc	ra,0x6
     38a:	87a080e7          	jalr	-1926(ra) # 5c00 <open>
     38e:	84aa                	mv	s1,a0
    if(fd < 0){
     390:	06054b63          	bltz	a0,406 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     394:	4605                	li	a2,1
     396:	85d2                	mv	a1,s4
     398:	00006097          	auipc	ra,0x6
     39c:	848080e7          	jalr	-1976(ra) # 5be0 <write>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00006097          	auipc	ra,0x6
     3a6:	846080e7          	jalr	-1978(ra) # 5be8 <close>
    unlink("junk");
     3aa:	854e                	mv	a0,s3
     3ac:	00006097          	auipc	ra,0x6
     3b0:	864080e7          	jalr	-1948(ra) # 5c10 <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b4:	397d                	addiw	s2,s2,-1
     3b6:	fc0915e3          	bnez	s2,380 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	00006517          	auipc	a0,0x6
     3c2:	e7250513          	addi	a0,a0,-398 # 6230 <malloc+0x20e>
     3c6:	00006097          	auipc	ra,0x6
     3ca:	83a080e7          	jalr	-1990(ra) # 5c00 <open>
     3ce:	84aa                	mv	s1,a0
  if(fd < 0){
     3d0:	04054863          	bltz	a0,420 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d4:	4605                	li	a2,1
     3d6:	00006597          	auipc	a1,0x6
     3da:	de258593          	addi	a1,a1,-542 # 61b8 <malloc+0x196>
     3de:	00006097          	auipc	ra,0x6
     3e2:	802080e7          	jalr	-2046(ra) # 5be0 <write>
     3e6:	4785                	li	a5,1
     3e8:	04f50963          	beq	a0,a5,43a <badwrite+0xec>
    printf("write failed\n");
     3ec:	00006517          	auipc	a0,0x6
     3f0:	e6450513          	addi	a0,a0,-412 # 6250 <malloc+0x22e>
     3f4:	00006097          	auipc	ra,0x6
     3f8:	b76080e7          	jalr	-1162(ra) # 5f6a <printf>
    exit(1);
     3fc:	4505                	li	a0,1
     3fe:	00005097          	auipc	ra,0x5
     402:	7c2080e7          	jalr	1986(ra) # 5bc0 <exit>
      printf("open junk failed\n");
     406:	00006517          	auipc	a0,0x6
     40a:	e3250513          	addi	a0,a0,-462 # 6238 <malloc+0x216>
     40e:	00006097          	auipc	ra,0x6
     412:	b5c080e7          	jalr	-1188(ra) # 5f6a <printf>
      exit(1);
     416:	4505                	li	a0,1
     418:	00005097          	auipc	ra,0x5
     41c:	7a8080e7          	jalr	1960(ra) # 5bc0 <exit>
    printf("open junk failed\n");
     420:	00006517          	auipc	a0,0x6
     424:	e1850513          	addi	a0,a0,-488 # 6238 <malloc+0x216>
     428:	00006097          	auipc	ra,0x6
     42c:	b42080e7          	jalr	-1214(ra) # 5f6a <printf>
    exit(1);
     430:	4505                	li	a0,1
     432:	00005097          	auipc	ra,0x5
     436:	78e080e7          	jalr	1934(ra) # 5bc0 <exit>
  }
  close(fd);
     43a:	8526                	mv	a0,s1
     43c:	00005097          	auipc	ra,0x5
     440:	7ac080e7          	jalr	1964(ra) # 5be8 <close>
  unlink("junk");
     444:	00006517          	auipc	a0,0x6
     448:	dec50513          	addi	a0,a0,-532 # 6230 <malloc+0x20e>
     44c:	00005097          	auipc	ra,0x5
     450:	7c4080e7          	jalr	1988(ra) # 5c10 <unlink>

  exit(0);
     454:	4501                	li	a0,0
     456:	00005097          	auipc	ra,0x5
     45a:	76a080e7          	jalr	1898(ra) # 5bc0 <exit>

000000000000045e <copyin>:
{
     45e:	715d                	addi	sp,sp,-80
     460:	e486                	sd	ra,72(sp)
     462:	e0a2                	sd	s0,64(sp)
     464:	fc26                	sd	s1,56(sp)
     466:	f84a                	sd	s2,48(sp)
     468:	f44e                	sd	s3,40(sp)
     46a:	f052                	sd	s4,32(sp)
     46c:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     46e:	4785                	li	a5,1
     470:	07fe                	slli	a5,a5,0x1f
     472:	fcf43023          	sd	a5,-64(s0)
     476:	57fd                	li	a5,-1
     478:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     47c:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     480:	00006a17          	auipc	s4,0x6
     484:	de0a0a13          	addi	s4,s4,-544 # 6260 <malloc+0x23e>
    uint64 addr = addrs[ai];
     488:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     48c:	20100593          	li	a1,513
     490:	8552                	mv	a0,s4
     492:	00005097          	auipc	ra,0x5
     496:	76e080e7          	jalr	1902(ra) # 5c00 <open>
     49a:	84aa                	mv	s1,a0
    if(fd < 0){
     49c:	08054863          	bltz	a0,52c <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     4a0:	6609                	lui	a2,0x2
     4a2:	85ce                	mv	a1,s3
     4a4:	00005097          	auipc	ra,0x5
     4a8:	73c080e7          	jalr	1852(ra) # 5be0 <write>
    if(n >= 0){
     4ac:	08055d63          	bgez	a0,546 <copyin+0xe8>
    close(fd);
     4b0:	8526                	mv	a0,s1
     4b2:	00005097          	auipc	ra,0x5
     4b6:	736080e7          	jalr	1846(ra) # 5be8 <close>
    unlink("copyin1");
     4ba:	8552                	mv	a0,s4
     4bc:	00005097          	auipc	ra,0x5
     4c0:	754080e7          	jalr	1876(ra) # 5c10 <unlink>
    n = write(1, (char*)addr, 8192);
     4c4:	6609                	lui	a2,0x2
     4c6:	85ce                	mv	a1,s3
     4c8:	4505                	li	a0,1
     4ca:	00005097          	auipc	ra,0x5
     4ce:	716080e7          	jalr	1814(ra) # 5be0 <write>
    if(n > 0){
     4d2:	08a04963          	bgtz	a0,564 <copyin+0x106>
    if(pipe(fds) < 0){
     4d6:	fb840513          	addi	a0,s0,-72
     4da:	00005097          	auipc	ra,0x5
     4de:	6f6080e7          	jalr	1782(ra) # 5bd0 <pipe>
     4e2:	0a054063          	bltz	a0,582 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     4e6:	6609                	lui	a2,0x2
     4e8:	85ce                	mv	a1,s3
     4ea:	fbc42503          	lw	a0,-68(s0)
     4ee:	00005097          	auipc	ra,0x5
     4f2:	6f2080e7          	jalr	1778(ra) # 5be0 <write>
    if(n > 0){
     4f6:	0aa04363          	bgtz	a0,59c <copyin+0x13e>
    close(fds[0]);
     4fa:	fb842503          	lw	a0,-72(s0)
     4fe:	00005097          	auipc	ra,0x5
     502:	6ea080e7          	jalr	1770(ra) # 5be8 <close>
    close(fds[1]);
     506:	fbc42503          	lw	a0,-68(s0)
     50a:	00005097          	auipc	ra,0x5
     50e:	6de080e7          	jalr	1758(ra) # 5be8 <close>
  for(int ai = 0; ai < 2; ai++){
     512:	0921                	addi	s2,s2,8
     514:	fd040793          	addi	a5,s0,-48
     518:	f6f918e3          	bne	s2,a5,488 <copyin+0x2a>
}
     51c:	60a6                	ld	ra,72(sp)
     51e:	6406                	ld	s0,64(sp)
     520:	74e2                	ld	s1,56(sp)
     522:	7942                	ld	s2,48(sp)
     524:	79a2                	ld	s3,40(sp)
     526:	7a02                	ld	s4,32(sp)
     528:	6161                	addi	sp,sp,80
     52a:	8082                	ret
      printf("open(copyin1) failed\n");
     52c:	00006517          	auipc	a0,0x6
     530:	d3c50513          	addi	a0,a0,-708 # 6268 <malloc+0x246>
     534:	00006097          	auipc	ra,0x6
     538:	a36080e7          	jalr	-1482(ra) # 5f6a <printf>
      exit(1);
     53c:	4505                	li	a0,1
     53e:	00005097          	auipc	ra,0x5
     542:	682080e7          	jalr	1666(ra) # 5bc0 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     546:	862a                	mv	a2,a0
     548:	85ce                	mv	a1,s3
     54a:	00006517          	auipc	a0,0x6
     54e:	d3650513          	addi	a0,a0,-714 # 6280 <malloc+0x25e>
     552:	00006097          	auipc	ra,0x6
     556:	a18080e7          	jalr	-1512(ra) # 5f6a <printf>
      exit(1);
     55a:	4505                	li	a0,1
     55c:	00005097          	auipc	ra,0x5
     560:	664080e7          	jalr	1636(ra) # 5bc0 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     564:	862a                	mv	a2,a0
     566:	85ce                	mv	a1,s3
     568:	00006517          	auipc	a0,0x6
     56c:	d4850513          	addi	a0,a0,-696 # 62b0 <malloc+0x28e>
     570:	00006097          	auipc	ra,0x6
     574:	9fa080e7          	jalr	-1542(ra) # 5f6a <printf>
      exit(1);
     578:	4505                	li	a0,1
     57a:	00005097          	auipc	ra,0x5
     57e:	646080e7          	jalr	1606(ra) # 5bc0 <exit>
      printf("pipe() failed\n");
     582:	00006517          	auipc	a0,0x6
     586:	d5e50513          	addi	a0,a0,-674 # 62e0 <malloc+0x2be>
     58a:	00006097          	auipc	ra,0x6
     58e:	9e0080e7          	jalr	-1568(ra) # 5f6a <printf>
      exit(1);
     592:	4505                	li	a0,1
     594:	00005097          	auipc	ra,0x5
     598:	62c080e7          	jalr	1580(ra) # 5bc0 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     59c:	862a                	mv	a2,a0
     59e:	85ce                	mv	a1,s3
     5a0:	00006517          	auipc	a0,0x6
     5a4:	d5050513          	addi	a0,a0,-688 # 62f0 <malloc+0x2ce>
     5a8:	00006097          	auipc	ra,0x6
     5ac:	9c2080e7          	jalr	-1598(ra) # 5f6a <printf>
      exit(1);
     5b0:	4505                	li	a0,1
     5b2:	00005097          	auipc	ra,0x5
     5b6:	60e080e7          	jalr	1550(ra) # 5bc0 <exit>

00000000000005ba <copyout>:
{
     5ba:	711d                	addi	sp,sp,-96
     5bc:	ec86                	sd	ra,88(sp)
     5be:	e8a2                	sd	s0,80(sp)
     5c0:	e4a6                	sd	s1,72(sp)
     5c2:	e0ca                	sd	s2,64(sp)
     5c4:	fc4e                	sd	s3,56(sp)
     5c6:	f852                	sd	s4,48(sp)
     5c8:	f456                	sd	s5,40(sp)
     5ca:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     5cc:	4785                	li	a5,1
     5ce:	07fe                	slli	a5,a5,0x1f
     5d0:	faf43823          	sd	a5,-80(s0)
     5d4:	57fd                	li	a5,-1
     5d6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     5da:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     5de:	00006a17          	auipc	s4,0x6
     5e2:	d42a0a13          	addi	s4,s4,-702 # 6320 <malloc+0x2fe>
    n = write(fds[1], "x", 1);
     5e6:	00006a97          	auipc	s5,0x6
     5ea:	bd2a8a93          	addi	s5,s5,-1070 # 61b8 <malloc+0x196>
    uint64 addr = addrs[ai];
     5ee:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     5f2:	4581                	li	a1,0
     5f4:	8552                	mv	a0,s4
     5f6:	00005097          	auipc	ra,0x5
     5fa:	60a080e7          	jalr	1546(ra) # 5c00 <open>
     5fe:	84aa                	mv	s1,a0
    if(fd < 0){
     600:	08054663          	bltz	a0,68c <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     604:	6609                	lui	a2,0x2
     606:	85ce                	mv	a1,s3
     608:	00005097          	auipc	ra,0x5
     60c:	5d0080e7          	jalr	1488(ra) # 5bd8 <read>
    if(n > 0){
     610:	08a04b63          	bgtz	a0,6a6 <copyout+0xec>
    close(fd);
     614:	8526                	mv	a0,s1
     616:	00005097          	auipc	ra,0x5
     61a:	5d2080e7          	jalr	1490(ra) # 5be8 <close>
    if(pipe(fds) < 0){
     61e:	fa840513          	addi	a0,s0,-88
     622:	00005097          	auipc	ra,0x5
     626:	5ae080e7          	jalr	1454(ra) # 5bd0 <pipe>
     62a:	08054d63          	bltz	a0,6c4 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     62e:	4605                	li	a2,1
     630:	85d6                	mv	a1,s5
     632:	fac42503          	lw	a0,-84(s0)
     636:	00005097          	auipc	ra,0x5
     63a:	5aa080e7          	jalr	1450(ra) # 5be0 <write>
    if(n != 1){
     63e:	4785                	li	a5,1
     640:	08f51f63          	bne	a0,a5,6de <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     644:	6609                	lui	a2,0x2
     646:	85ce                	mv	a1,s3
     648:	fa842503          	lw	a0,-88(s0)
     64c:	00005097          	auipc	ra,0x5
     650:	58c080e7          	jalr	1420(ra) # 5bd8 <read>
    if(n > 0){
     654:	0aa04263          	bgtz	a0,6f8 <copyout+0x13e>
    close(fds[0]);
     658:	fa842503          	lw	a0,-88(s0)
     65c:	00005097          	auipc	ra,0x5
     660:	58c080e7          	jalr	1420(ra) # 5be8 <close>
    close(fds[1]);
     664:	fac42503          	lw	a0,-84(s0)
     668:	00005097          	auipc	ra,0x5
     66c:	580080e7          	jalr	1408(ra) # 5be8 <close>
  for(int ai = 0; ai < 2; ai++){
     670:	0921                	addi	s2,s2,8
     672:	fc040793          	addi	a5,s0,-64
     676:	f6f91ce3          	bne	s2,a5,5ee <copyout+0x34>
}
     67a:	60e6                	ld	ra,88(sp)
     67c:	6446                	ld	s0,80(sp)
     67e:	64a6                	ld	s1,72(sp)
     680:	6906                	ld	s2,64(sp)
     682:	79e2                	ld	s3,56(sp)
     684:	7a42                	ld	s4,48(sp)
     686:	7aa2                	ld	s5,40(sp)
     688:	6125                	addi	sp,sp,96
     68a:	8082                	ret
      printf("open(README) failed\n");
     68c:	00006517          	auipc	a0,0x6
     690:	c9c50513          	addi	a0,a0,-868 # 6328 <malloc+0x306>
     694:	00006097          	auipc	ra,0x6
     698:	8d6080e7          	jalr	-1834(ra) # 5f6a <printf>
      exit(1);
     69c:	4505                	li	a0,1
     69e:	00005097          	auipc	ra,0x5
     6a2:	522080e7          	jalr	1314(ra) # 5bc0 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     6a6:	862a                	mv	a2,a0
     6a8:	85ce                	mv	a1,s3
     6aa:	00006517          	auipc	a0,0x6
     6ae:	c9650513          	addi	a0,a0,-874 # 6340 <malloc+0x31e>
     6b2:	00006097          	auipc	ra,0x6
     6b6:	8b8080e7          	jalr	-1864(ra) # 5f6a <printf>
      exit(1);
     6ba:	4505                	li	a0,1
     6bc:	00005097          	auipc	ra,0x5
     6c0:	504080e7          	jalr	1284(ra) # 5bc0 <exit>
      printf("pipe() failed\n");
     6c4:	00006517          	auipc	a0,0x6
     6c8:	c1c50513          	addi	a0,a0,-996 # 62e0 <malloc+0x2be>
     6cc:	00006097          	auipc	ra,0x6
     6d0:	89e080e7          	jalr	-1890(ra) # 5f6a <printf>
      exit(1);
     6d4:	4505                	li	a0,1
     6d6:	00005097          	auipc	ra,0x5
     6da:	4ea080e7          	jalr	1258(ra) # 5bc0 <exit>
      printf("pipe write failed\n");
     6de:	00006517          	auipc	a0,0x6
     6e2:	c9250513          	addi	a0,a0,-878 # 6370 <malloc+0x34e>
     6e6:	00006097          	auipc	ra,0x6
     6ea:	884080e7          	jalr	-1916(ra) # 5f6a <printf>
      exit(1);
     6ee:	4505                	li	a0,1
     6f0:	00005097          	auipc	ra,0x5
     6f4:	4d0080e7          	jalr	1232(ra) # 5bc0 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     6f8:	862a                	mv	a2,a0
     6fa:	85ce                	mv	a1,s3
     6fc:	00006517          	auipc	a0,0x6
     700:	c8c50513          	addi	a0,a0,-884 # 6388 <malloc+0x366>
     704:	00006097          	auipc	ra,0x6
     708:	866080e7          	jalr	-1946(ra) # 5f6a <printf>
      exit(1);
     70c:	4505                	li	a0,1
     70e:	00005097          	auipc	ra,0x5
     712:	4b2080e7          	jalr	1202(ra) # 5bc0 <exit>

0000000000000716 <truncate1>:
{
     716:	711d                	addi	sp,sp,-96
     718:	ec86                	sd	ra,88(sp)
     71a:	e8a2                	sd	s0,80(sp)
     71c:	e4a6                	sd	s1,72(sp)
     71e:	e0ca                	sd	s2,64(sp)
     720:	fc4e                	sd	s3,56(sp)
     722:	f852                	sd	s4,48(sp)
     724:	f456                	sd	s5,40(sp)
     726:	1080                	addi	s0,sp,96
     728:	8aaa                	mv	s5,a0
  unlink("truncfile");
     72a:	00006517          	auipc	a0,0x6
     72e:	a7650513          	addi	a0,a0,-1418 # 61a0 <malloc+0x17e>
     732:	00005097          	auipc	ra,0x5
     736:	4de080e7          	jalr	1246(ra) # 5c10 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     73a:	60100593          	li	a1,1537
     73e:	00006517          	auipc	a0,0x6
     742:	a6250513          	addi	a0,a0,-1438 # 61a0 <malloc+0x17e>
     746:	00005097          	auipc	ra,0x5
     74a:	4ba080e7          	jalr	1210(ra) # 5c00 <open>
     74e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     750:	4611                	li	a2,4
     752:	00006597          	auipc	a1,0x6
     756:	a5e58593          	addi	a1,a1,-1442 # 61b0 <malloc+0x18e>
     75a:	00005097          	auipc	ra,0x5
     75e:	486080e7          	jalr	1158(ra) # 5be0 <write>
  close(fd1);
     762:	8526                	mv	a0,s1
     764:	00005097          	auipc	ra,0x5
     768:	484080e7          	jalr	1156(ra) # 5be8 <close>
  int fd2 = open("truncfile", O_RDONLY);
     76c:	4581                	li	a1,0
     76e:	00006517          	auipc	a0,0x6
     772:	a3250513          	addi	a0,a0,-1486 # 61a0 <malloc+0x17e>
     776:	00005097          	auipc	ra,0x5
     77a:	48a080e7          	jalr	1162(ra) # 5c00 <open>
     77e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     780:	02000613          	li	a2,32
     784:	fa040593          	addi	a1,s0,-96
     788:	00005097          	auipc	ra,0x5
     78c:	450080e7          	jalr	1104(ra) # 5bd8 <read>
  if(n != 4){
     790:	4791                	li	a5,4
     792:	0cf51e63          	bne	a0,a5,86e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     796:	40100593          	li	a1,1025
     79a:	00006517          	auipc	a0,0x6
     79e:	a0650513          	addi	a0,a0,-1530 # 61a0 <malloc+0x17e>
     7a2:	00005097          	auipc	ra,0x5
     7a6:	45e080e7          	jalr	1118(ra) # 5c00 <open>
     7aa:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7ac:	4581                	li	a1,0
     7ae:	00006517          	auipc	a0,0x6
     7b2:	9f250513          	addi	a0,a0,-1550 # 61a0 <malloc+0x17e>
     7b6:	00005097          	auipc	ra,0x5
     7ba:	44a080e7          	jalr	1098(ra) # 5c00 <open>
     7be:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7c0:	02000613          	li	a2,32
     7c4:	fa040593          	addi	a1,s0,-96
     7c8:	00005097          	auipc	ra,0x5
     7cc:	410080e7          	jalr	1040(ra) # 5bd8 <read>
     7d0:	8a2a                	mv	s4,a0
  if(n != 0){
     7d2:	ed4d                	bnez	a0,88c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     7d4:	02000613          	li	a2,32
     7d8:	fa040593          	addi	a1,s0,-96
     7dc:	8526                	mv	a0,s1
     7de:	00005097          	auipc	ra,0x5
     7e2:	3fa080e7          	jalr	1018(ra) # 5bd8 <read>
     7e6:	8a2a                	mv	s4,a0
  if(n != 0){
     7e8:	e971                	bnez	a0,8bc <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     7ea:	4619                	li	a2,6
     7ec:	00006597          	auipc	a1,0x6
     7f0:	c2c58593          	addi	a1,a1,-980 # 6418 <malloc+0x3f6>
     7f4:	854e                	mv	a0,s3
     7f6:	00005097          	auipc	ra,0x5
     7fa:	3ea080e7          	jalr	1002(ra) # 5be0 <write>
  n = read(fd3, buf, sizeof(buf));
     7fe:	02000613          	li	a2,32
     802:	fa040593          	addi	a1,s0,-96
     806:	854a                	mv	a0,s2
     808:	00005097          	auipc	ra,0x5
     80c:	3d0080e7          	jalr	976(ra) # 5bd8 <read>
  if(n != 6){
     810:	4799                	li	a5,6
     812:	0cf51d63          	bne	a0,a5,8ec <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     816:	02000613          	li	a2,32
     81a:	fa040593          	addi	a1,s0,-96
     81e:	8526                	mv	a0,s1
     820:	00005097          	auipc	ra,0x5
     824:	3b8080e7          	jalr	952(ra) # 5bd8 <read>
  if(n != 2){
     828:	4789                	li	a5,2
     82a:	0ef51063          	bne	a0,a5,90a <truncate1+0x1f4>
  unlink("truncfile");
     82e:	00006517          	auipc	a0,0x6
     832:	97250513          	addi	a0,a0,-1678 # 61a0 <malloc+0x17e>
     836:	00005097          	auipc	ra,0x5
     83a:	3da080e7          	jalr	986(ra) # 5c10 <unlink>
  close(fd1);
     83e:	854e                	mv	a0,s3
     840:	00005097          	auipc	ra,0x5
     844:	3a8080e7          	jalr	936(ra) # 5be8 <close>
  close(fd2);
     848:	8526                	mv	a0,s1
     84a:	00005097          	auipc	ra,0x5
     84e:	39e080e7          	jalr	926(ra) # 5be8 <close>
  close(fd3);
     852:	854a                	mv	a0,s2
     854:	00005097          	auipc	ra,0x5
     858:	394080e7          	jalr	916(ra) # 5be8 <close>
}
     85c:	60e6                	ld	ra,88(sp)
     85e:	6446                	ld	s0,80(sp)
     860:	64a6                	ld	s1,72(sp)
     862:	6906                	ld	s2,64(sp)
     864:	79e2                	ld	s3,56(sp)
     866:	7a42                	ld	s4,48(sp)
     868:	7aa2                	ld	s5,40(sp)
     86a:	6125                	addi	sp,sp,96
     86c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     86e:	862a                	mv	a2,a0
     870:	85d6                	mv	a1,s5
     872:	00006517          	auipc	a0,0x6
     876:	b4650513          	addi	a0,a0,-1210 # 63b8 <malloc+0x396>
     87a:	00005097          	auipc	ra,0x5
     87e:	6f0080e7          	jalr	1776(ra) # 5f6a <printf>
    exit(1);
     882:	4505                	li	a0,1
     884:	00005097          	auipc	ra,0x5
     888:	33c080e7          	jalr	828(ra) # 5bc0 <exit>
    printf("aaa fd3=%d\n", fd3);
     88c:	85ca                	mv	a1,s2
     88e:	00006517          	auipc	a0,0x6
     892:	b4a50513          	addi	a0,a0,-1206 # 63d8 <malloc+0x3b6>
     896:	00005097          	auipc	ra,0x5
     89a:	6d4080e7          	jalr	1748(ra) # 5f6a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     89e:	8652                	mv	a2,s4
     8a0:	85d6                	mv	a1,s5
     8a2:	00006517          	auipc	a0,0x6
     8a6:	b4650513          	addi	a0,a0,-1210 # 63e8 <malloc+0x3c6>
     8aa:	00005097          	auipc	ra,0x5
     8ae:	6c0080e7          	jalr	1728(ra) # 5f6a <printf>
    exit(1);
     8b2:	4505                	li	a0,1
     8b4:	00005097          	auipc	ra,0x5
     8b8:	30c080e7          	jalr	780(ra) # 5bc0 <exit>
    printf("bbb fd2=%d\n", fd2);
     8bc:	85a6                	mv	a1,s1
     8be:	00006517          	auipc	a0,0x6
     8c2:	b4a50513          	addi	a0,a0,-1206 # 6408 <malloc+0x3e6>
     8c6:	00005097          	auipc	ra,0x5
     8ca:	6a4080e7          	jalr	1700(ra) # 5f6a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     8ce:	8652                	mv	a2,s4
     8d0:	85d6                	mv	a1,s5
     8d2:	00006517          	auipc	a0,0x6
     8d6:	b1650513          	addi	a0,a0,-1258 # 63e8 <malloc+0x3c6>
     8da:	00005097          	auipc	ra,0x5
     8de:	690080e7          	jalr	1680(ra) # 5f6a <printf>
    exit(1);
     8e2:	4505                	li	a0,1
     8e4:	00005097          	auipc	ra,0x5
     8e8:	2dc080e7          	jalr	732(ra) # 5bc0 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     8ec:	862a                	mv	a2,a0
     8ee:	85d6                	mv	a1,s5
     8f0:	00006517          	auipc	a0,0x6
     8f4:	b3050513          	addi	a0,a0,-1232 # 6420 <malloc+0x3fe>
     8f8:	00005097          	auipc	ra,0x5
     8fc:	672080e7          	jalr	1650(ra) # 5f6a <printf>
    exit(1);
     900:	4505                	li	a0,1
     902:	00005097          	auipc	ra,0x5
     906:	2be080e7          	jalr	702(ra) # 5bc0 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     90a:	862a                	mv	a2,a0
     90c:	85d6                	mv	a1,s5
     90e:	00006517          	auipc	a0,0x6
     912:	b3250513          	addi	a0,a0,-1230 # 6440 <malloc+0x41e>
     916:	00005097          	auipc	ra,0x5
     91a:	654080e7          	jalr	1620(ra) # 5f6a <printf>
    exit(1);
     91e:	4505                	li	a0,1
     920:	00005097          	auipc	ra,0x5
     924:	2a0080e7          	jalr	672(ra) # 5bc0 <exit>

0000000000000928 <writetest>:
{
     928:	7139                	addi	sp,sp,-64
     92a:	fc06                	sd	ra,56(sp)
     92c:	f822                	sd	s0,48(sp)
     92e:	f426                	sd	s1,40(sp)
     930:	f04a                	sd	s2,32(sp)
     932:	ec4e                	sd	s3,24(sp)
     934:	e852                	sd	s4,16(sp)
     936:	e456                	sd	s5,8(sp)
     938:	e05a                	sd	s6,0(sp)
     93a:	0080                	addi	s0,sp,64
     93c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     93e:	20200593          	li	a1,514
     942:	00006517          	auipc	a0,0x6
     946:	b1e50513          	addi	a0,a0,-1250 # 6460 <malloc+0x43e>
     94a:	00005097          	auipc	ra,0x5
     94e:	2b6080e7          	jalr	694(ra) # 5c00 <open>
  if(fd < 0){
     952:	0a054d63          	bltz	a0,a0c <writetest+0xe4>
     956:	892a                	mv	s2,a0
     958:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     95a:	00006997          	auipc	s3,0x6
     95e:	b2e98993          	addi	s3,s3,-1234 # 6488 <malloc+0x466>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     962:	00006a97          	auipc	s5,0x6
     966:	b5ea8a93          	addi	s5,s5,-1186 # 64c0 <malloc+0x49e>
  for(i = 0; i < N; i++){
     96a:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     96e:	4629                	li	a2,10
     970:	85ce                	mv	a1,s3
     972:	854a                	mv	a0,s2
     974:	00005097          	auipc	ra,0x5
     978:	26c080e7          	jalr	620(ra) # 5be0 <write>
     97c:	47a9                	li	a5,10
     97e:	0af51563          	bne	a0,a5,a28 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     982:	4629                	li	a2,10
     984:	85d6                	mv	a1,s5
     986:	854a                	mv	a0,s2
     988:	00005097          	auipc	ra,0x5
     98c:	258080e7          	jalr	600(ra) # 5be0 <write>
     990:	47a9                	li	a5,10
     992:	0af51a63          	bne	a0,a5,a46 <writetest+0x11e>
  for(i = 0; i < N; i++){
     996:	2485                	addiw	s1,s1,1
     998:	fd449be3          	bne	s1,s4,96e <writetest+0x46>
  close(fd);
     99c:	854a                	mv	a0,s2
     99e:	00005097          	auipc	ra,0x5
     9a2:	24a080e7          	jalr	586(ra) # 5be8 <close>
  fd = open("small", O_RDONLY);
     9a6:	4581                	li	a1,0
     9a8:	00006517          	auipc	a0,0x6
     9ac:	ab850513          	addi	a0,a0,-1352 # 6460 <malloc+0x43e>
     9b0:	00005097          	auipc	ra,0x5
     9b4:	250080e7          	jalr	592(ra) # 5c00 <open>
     9b8:	84aa                	mv	s1,a0
  if(fd < 0){
     9ba:	0a054563          	bltz	a0,a64 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     9be:	7d000613          	li	a2,2000
     9c2:	0000c597          	auipc	a1,0xc
     9c6:	29658593          	addi	a1,a1,662 # cc58 <buf>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	20e080e7          	jalr	526(ra) # 5bd8 <read>
  if(i != N*SZ*2){
     9d2:	7d000793          	li	a5,2000
     9d6:	0af51563          	bne	a0,a5,a80 <writetest+0x158>
  close(fd);
     9da:	8526                	mv	a0,s1
     9dc:	00005097          	auipc	ra,0x5
     9e0:	20c080e7          	jalr	524(ra) # 5be8 <close>
  if(unlink("small") < 0){
     9e4:	00006517          	auipc	a0,0x6
     9e8:	a7c50513          	addi	a0,a0,-1412 # 6460 <malloc+0x43e>
     9ec:	00005097          	auipc	ra,0x5
     9f0:	224080e7          	jalr	548(ra) # 5c10 <unlink>
     9f4:	0a054463          	bltz	a0,a9c <writetest+0x174>
}
     9f8:	70e2                	ld	ra,56(sp)
     9fa:	7442                	ld	s0,48(sp)
     9fc:	74a2                	ld	s1,40(sp)
     9fe:	7902                	ld	s2,32(sp)
     a00:	69e2                	ld	s3,24(sp)
     a02:	6a42                	ld	s4,16(sp)
     a04:	6aa2                	ld	s5,8(sp)
     a06:	6b02                	ld	s6,0(sp)
     a08:	6121                	addi	sp,sp,64
     a0a:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     a0c:	85da                	mv	a1,s6
     a0e:	00006517          	auipc	a0,0x6
     a12:	a5a50513          	addi	a0,a0,-1446 # 6468 <malloc+0x446>
     a16:	00005097          	auipc	ra,0x5
     a1a:	554080e7          	jalr	1364(ra) # 5f6a <printf>
    exit(1);
     a1e:	4505                	li	a0,1
     a20:	00005097          	auipc	ra,0x5
     a24:	1a0080e7          	jalr	416(ra) # 5bc0 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     a28:	8626                	mv	a2,s1
     a2a:	85da                	mv	a1,s6
     a2c:	00006517          	auipc	a0,0x6
     a30:	a6c50513          	addi	a0,a0,-1428 # 6498 <malloc+0x476>
     a34:	00005097          	auipc	ra,0x5
     a38:	536080e7          	jalr	1334(ra) # 5f6a <printf>
      exit(1);
     a3c:	4505                	li	a0,1
     a3e:	00005097          	auipc	ra,0x5
     a42:	182080e7          	jalr	386(ra) # 5bc0 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     a46:	8626                	mv	a2,s1
     a48:	85da                	mv	a1,s6
     a4a:	00006517          	auipc	a0,0x6
     a4e:	a8650513          	addi	a0,a0,-1402 # 64d0 <malloc+0x4ae>
     a52:	00005097          	auipc	ra,0x5
     a56:	518080e7          	jalr	1304(ra) # 5f6a <printf>
      exit(1);
     a5a:	4505                	li	a0,1
     a5c:	00005097          	auipc	ra,0x5
     a60:	164080e7          	jalr	356(ra) # 5bc0 <exit>
    printf("%s: error: open small failed!\n", s);
     a64:	85da                	mv	a1,s6
     a66:	00006517          	auipc	a0,0x6
     a6a:	a9250513          	addi	a0,a0,-1390 # 64f8 <malloc+0x4d6>
     a6e:	00005097          	auipc	ra,0x5
     a72:	4fc080e7          	jalr	1276(ra) # 5f6a <printf>
    exit(1);
     a76:	4505                	li	a0,1
     a78:	00005097          	auipc	ra,0x5
     a7c:	148080e7          	jalr	328(ra) # 5bc0 <exit>
    printf("%s: read failed\n", s);
     a80:	85da                	mv	a1,s6
     a82:	00006517          	auipc	a0,0x6
     a86:	a9650513          	addi	a0,a0,-1386 # 6518 <malloc+0x4f6>
     a8a:	00005097          	auipc	ra,0x5
     a8e:	4e0080e7          	jalr	1248(ra) # 5f6a <printf>
    exit(1);
     a92:	4505                	li	a0,1
     a94:	00005097          	auipc	ra,0x5
     a98:	12c080e7          	jalr	300(ra) # 5bc0 <exit>
    printf("%s: unlink small failed\n", s);
     a9c:	85da                	mv	a1,s6
     a9e:	00006517          	auipc	a0,0x6
     aa2:	a9250513          	addi	a0,a0,-1390 # 6530 <malloc+0x50e>
     aa6:	00005097          	auipc	ra,0x5
     aaa:	4c4080e7          	jalr	1220(ra) # 5f6a <printf>
    exit(1);
     aae:	4505                	li	a0,1
     ab0:	00005097          	auipc	ra,0x5
     ab4:	110080e7          	jalr	272(ra) # 5bc0 <exit>

0000000000000ab8 <writebig>:
{
     ab8:	7139                	addi	sp,sp,-64
     aba:	fc06                	sd	ra,56(sp)
     abc:	f822                	sd	s0,48(sp)
     abe:	f426                	sd	s1,40(sp)
     ac0:	f04a                	sd	s2,32(sp)
     ac2:	ec4e                	sd	s3,24(sp)
     ac4:	e852                	sd	s4,16(sp)
     ac6:	e456                	sd	s5,8(sp)
     ac8:	0080                	addi	s0,sp,64
     aca:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     acc:	20200593          	li	a1,514
     ad0:	00006517          	auipc	a0,0x6
     ad4:	a8050513          	addi	a0,a0,-1408 # 6550 <malloc+0x52e>
     ad8:	00005097          	auipc	ra,0x5
     adc:	128080e7          	jalr	296(ra) # 5c00 <open>
     ae0:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     ae2:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     ae4:	0000c917          	auipc	s2,0xc
     ae8:	17490913          	addi	s2,s2,372 # cc58 <buf>
  for(i = 0; i < MAXFILE; i++){
     aec:	10c00a13          	li	s4,268
  if(fd < 0){
     af0:	06054c63          	bltz	a0,b68 <writebig+0xb0>
    ((int*)buf)[0] = i;
     af4:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     af8:	40000613          	li	a2,1024
     afc:	85ca                	mv	a1,s2
     afe:	854e                	mv	a0,s3
     b00:	00005097          	auipc	ra,0x5
     b04:	0e0080e7          	jalr	224(ra) # 5be0 <write>
     b08:	40000793          	li	a5,1024
     b0c:	06f51c63          	bne	a0,a5,b84 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     b10:	2485                	addiw	s1,s1,1
     b12:	ff4491e3          	bne	s1,s4,af4 <writebig+0x3c>
  close(fd);
     b16:	854e                	mv	a0,s3
     b18:	00005097          	auipc	ra,0x5
     b1c:	0d0080e7          	jalr	208(ra) # 5be8 <close>
  fd = open("big", O_RDONLY);
     b20:	4581                	li	a1,0
     b22:	00006517          	auipc	a0,0x6
     b26:	a2e50513          	addi	a0,a0,-1490 # 6550 <malloc+0x52e>
     b2a:	00005097          	auipc	ra,0x5
     b2e:	0d6080e7          	jalr	214(ra) # 5c00 <open>
     b32:	89aa                	mv	s3,a0
  n = 0;
     b34:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     b36:	0000c917          	auipc	s2,0xc
     b3a:	12290913          	addi	s2,s2,290 # cc58 <buf>
  if(fd < 0){
     b3e:	06054263          	bltz	a0,ba2 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     b42:	40000613          	li	a2,1024
     b46:	85ca                	mv	a1,s2
     b48:	854e                	mv	a0,s3
     b4a:	00005097          	auipc	ra,0x5
     b4e:	08e080e7          	jalr	142(ra) # 5bd8 <read>
    if(i == 0){
     b52:	c535                	beqz	a0,bbe <writebig+0x106>
    } else if(i != BSIZE){
     b54:	40000793          	li	a5,1024
     b58:	0af51f63          	bne	a0,a5,c16 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     b5c:	00092683          	lw	a3,0(s2)
     b60:	0c969a63          	bne	a3,s1,c34 <writebig+0x17c>
    n++;
     b64:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     b66:	bff1                	j	b42 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     b68:	85d6                	mv	a1,s5
     b6a:	00006517          	auipc	a0,0x6
     b6e:	9ee50513          	addi	a0,a0,-1554 # 6558 <malloc+0x536>
     b72:	00005097          	auipc	ra,0x5
     b76:	3f8080e7          	jalr	1016(ra) # 5f6a <printf>
    exit(1);
     b7a:	4505                	li	a0,1
     b7c:	00005097          	auipc	ra,0x5
     b80:	044080e7          	jalr	68(ra) # 5bc0 <exit>
      printf("%s: error: write big file failed\n", s, i);
     b84:	8626                	mv	a2,s1
     b86:	85d6                	mv	a1,s5
     b88:	00006517          	auipc	a0,0x6
     b8c:	9f050513          	addi	a0,a0,-1552 # 6578 <malloc+0x556>
     b90:	00005097          	auipc	ra,0x5
     b94:	3da080e7          	jalr	986(ra) # 5f6a <printf>
      exit(1);
     b98:	4505                	li	a0,1
     b9a:	00005097          	auipc	ra,0x5
     b9e:	026080e7          	jalr	38(ra) # 5bc0 <exit>
    printf("%s: error: open big failed!\n", s);
     ba2:	85d6                	mv	a1,s5
     ba4:	00006517          	auipc	a0,0x6
     ba8:	9fc50513          	addi	a0,a0,-1540 # 65a0 <malloc+0x57e>
     bac:	00005097          	auipc	ra,0x5
     bb0:	3be080e7          	jalr	958(ra) # 5f6a <printf>
    exit(1);
     bb4:	4505                	li	a0,1
     bb6:	00005097          	auipc	ra,0x5
     bba:	00a080e7          	jalr	10(ra) # 5bc0 <exit>
      if(n == MAXFILE - 1){
     bbe:	10b00793          	li	a5,267
     bc2:	02f48a63          	beq	s1,a5,bf6 <writebig+0x13e>
  close(fd);
     bc6:	854e                	mv	a0,s3
     bc8:	00005097          	auipc	ra,0x5
     bcc:	020080e7          	jalr	32(ra) # 5be8 <close>
  if(unlink("big") < 0){
     bd0:	00006517          	auipc	a0,0x6
     bd4:	98050513          	addi	a0,a0,-1664 # 6550 <malloc+0x52e>
     bd8:	00005097          	auipc	ra,0x5
     bdc:	038080e7          	jalr	56(ra) # 5c10 <unlink>
     be0:	06054963          	bltz	a0,c52 <writebig+0x19a>
}
     be4:	70e2                	ld	ra,56(sp)
     be6:	7442                	ld	s0,48(sp)
     be8:	74a2                	ld	s1,40(sp)
     bea:	7902                	ld	s2,32(sp)
     bec:	69e2                	ld	s3,24(sp)
     bee:	6a42                	ld	s4,16(sp)
     bf0:	6aa2                	ld	s5,8(sp)
     bf2:	6121                	addi	sp,sp,64
     bf4:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     bf6:	10b00613          	li	a2,267
     bfa:	85d6                	mv	a1,s5
     bfc:	00006517          	auipc	a0,0x6
     c00:	9c450513          	addi	a0,a0,-1596 # 65c0 <malloc+0x59e>
     c04:	00005097          	auipc	ra,0x5
     c08:	366080e7          	jalr	870(ra) # 5f6a <printf>
        exit(1);
     c0c:	4505                	li	a0,1
     c0e:	00005097          	auipc	ra,0x5
     c12:	fb2080e7          	jalr	-78(ra) # 5bc0 <exit>
      printf("%s: read failed %d\n", s, i);
     c16:	862a                	mv	a2,a0
     c18:	85d6                	mv	a1,s5
     c1a:	00006517          	auipc	a0,0x6
     c1e:	9ce50513          	addi	a0,a0,-1586 # 65e8 <malloc+0x5c6>
     c22:	00005097          	auipc	ra,0x5
     c26:	348080e7          	jalr	840(ra) # 5f6a <printf>
      exit(1);
     c2a:	4505                	li	a0,1
     c2c:	00005097          	auipc	ra,0x5
     c30:	f94080e7          	jalr	-108(ra) # 5bc0 <exit>
      printf("%s: read content of block %d is %d\n", s,
     c34:	8626                	mv	a2,s1
     c36:	85d6                	mv	a1,s5
     c38:	00006517          	auipc	a0,0x6
     c3c:	9c850513          	addi	a0,a0,-1592 # 6600 <malloc+0x5de>
     c40:	00005097          	auipc	ra,0x5
     c44:	32a080e7          	jalr	810(ra) # 5f6a <printf>
      exit(1);
     c48:	4505                	li	a0,1
     c4a:	00005097          	auipc	ra,0x5
     c4e:	f76080e7          	jalr	-138(ra) # 5bc0 <exit>
    printf("%s: unlink big failed\n", s);
     c52:	85d6                	mv	a1,s5
     c54:	00006517          	auipc	a0,0x6
     c58:	9d450513          	addi	a0,a0,-1580 # 6628 <malloc+0x606>
     c5c:	00005097          	auipc	ra,0x5
     c60:	30e080e7          	jalr	782(ra) # 5f6a <printf>
    exit(1);
     c64:	4505                	li	a0,1
     c66:	00005097          	auipc	ra,0x5
     c6a:	f5a080e7          	jalr	-166(ra) # 5bc0 <exit>

0000000000000c6e <unlinkread>:
{
     c6e:	7179                	addi	sp,sp,-48
     c70:	f406                	sd	ra,40(sp)
     c72:	f022                	sd	s0,32(sp)
     c74:	ec26                	sd	s1,24(sp)
     c76:	e84a                	sd	s2,16(sp)
     c78:	e44e                	sd	s3,8(sp)
     c7a:	1800                	addi	s0,sp,48
     c7c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     c7e:	20200593          	li	a1,514
     c82:	00006517          	auipc	a0,0x6
     c86:	9be50513          	addi	a0,a0,-1602 # 6640 <malloc+0x61e>
     c8a:	00005097          	auipc	ra,0x5
     c8e:	f76080e7          	jalr	-138(ra) # 5c00 <open>
  if(fd < 0){
     c92:	0e054563          	bltz	a0,d7c <unlinkread+0x10e>
     c96:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     c98:	4615                	li	a2,5
     c9a:	00006597          	auipc	a1,0x6
     c9e:	9d658593          	addi	a1,a1,-1578 # 6670 <malloc+0x64e>
     ca2:	00005097          	auipc	ra,0x5
     ca6:	f3e080e7          	jalr	-194(ra) # 5be0 <write>
  close(fd);
     caa:	8526                	mv	a0,s1
     cac:	00005097          	auipc	ra,0x5
     cb0:	f3c080e7          	jalr	-196(ra) # 5be8 <close>
  fd = open("unlinkread", O_RDWR);
     cb4:	4589                	li	a1,2
     cb6:	00006517          	auipc	a0,0x6
     cba:	98a50513          	addi	a0,a0,-1654 # 6640 <malloc+0x61e>
     cbe:	00005097          	auipc	ra,0x5
     cc2:	f42080e7          	jalr	-190(ra) # 5c00 <open>
     cc6:	84aa                	mv	s1,a0
  if(fd < 0){
     cc8:	0c054863          	bltz	a0,d98 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     ccc:	00006517          	auipc	a0,0x6
     cd0:	97450513          	addi	a0,a0,-1676 # 6640 <malloc+0x61e>
     cd4:	00005097          	auipc	ra,0x5
     cd8:	f3c080e7          	jalr	-196(ra) # 5c10 <unlink>
     cdc:	ed61                	bnez	a0,db4 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     cde:	20200593          	li	a1,514
     ce2:	00006517          	auipc	a0,0x6
     ce6:	95e50513          	addi	a0,a0,-1698 # 6640 <malloc+0x61e>
     cea:	00005097          	auipc	ra,0x5
     cee:	f16080e7          	jalr	-234(ra) # 5c00 <open>
     cf2:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     cf4:	460d                	li	a2,3
     cf6:	00006597          	auipc	a1,0x6
     cfa:	9c258593          	addi	a1,a1,-1598 # 66b8 <malloc+0x696>
     cfe:	00005097          	auipc	ra,0x5
     d02:	ee2080e7          	jalr	-286(ra) # 5be0 <write>
  close(fd1);
     d06:	854a                	mv	a0,s2
     d08:	00005097          	auipc	ra,0x5
     d0c:	ee0080e7          	jalr	-288(ra) # 5be8 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d10:	660d                	lui	a2,0x3
     d12:	0000c597          	auipc	a1,0xc
     d16:	f4658593          	addi	a1,a1,-186 # cc58 <buf>
     d1a:	8526                	mv	a0,s1
     d1c:	00005097          	auipc	ra,0x5
     d20:	ebc080e7          	jalr	-324(ra) # 5bd8 <read>
     d24:	4795                	li	a5,5
     d26:	0af51563          	bne	a0,a5,dd0 <unlinkread+0x162>
  if(buf[0] != 'h'){
     d2a:	0000c717          	auipc	a4,0xc
     d2e:	f2e74703          	lbu	a4,-210(a4) # cc58 <buf>
     d32:	06800793          	li	a5,104
     d36:	0af71b63          	bne	a4,a5,dec <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     d3a:	4629                	li	a2,10
     d3c:	0000c597          	auipc	a1,0xc
     d40:	f1c58593          	addi	a1,a1,-228 # cc58 <buf>
     d44:	8526                	mv	a0,s1
     d46:	00005097          	auipc	ra,0x5
     d4a:	e9a080e7          	jalr	-358(ra) # 5be0 <write>
     d4e:	47a9                	li	a5,10
     d50:	0af51c63          	bne	a0,a5,e08 <unlinkread+0x19a>
  close(fd);
     d54:	8526                	mv	a0,s1
     d56:	00005097          	auipc	ra,0x5
     d5a:	e92080e7          	jalr	-366(ra) # 5be8 <close>
  unlink("unlinkread");
     d5e:	00006517          	auipc	a0,0x6
     d62:	8e250513          	addi	a0,a0,-1822 # 6640 <malloc+0x61e>
     d66:	00005097          	auipc	ra,0x5
     d6a:	eaa080e7          	jalr	-342(ra) # 5c10 <unlink>
}
     d6e:	70a2                	ld	ra,40(sp)
     d70:	7402                	ld	s0,32(sp)
     d72:	64e2                	ld	s1,24(sp)
     d74:	6942                	ld	s2,16(sp)
     d76:	69a2                	ld	s3,8(sp)
     d78:	6145                	addi	sp,sp,48
     d7a:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     d7c:	85ce                	mv	a1,s3
     d7e:	00006517          	auipc	a0,0x6
     d82:	8d250513          	addi	a0,a0,-1838 # 6650 <malloc+0x62e>
     d86:	00005097          	auipc	ra,0x5
     d8a:	1e4080e7          	jalr	484(ra) # 5f6a <printf>
    exit(1);
     d8e:	4505                	li	a0,1
     d90:	00005097          	auipc	ra,0x5
     d94:	e30080e7          	jalr	-464(ra) # 5bc0 <exit>
    printf("%s: open unlinkread failed\n", s);
     d98:	85ce                	mv	a1,s3
     d9a:	00006517          	auipc	a0,0x6
     d9e:	8de50513          	addi	a0,a0,-1826 # 6678 <malloc+0x656>
     da2:	00005097          	auipc	ra,0x5
     da6:	1c8080e7          	jalr	456(ra) # 5f6a <printf>
    exit(1);
     daa:	4505                	li	a0,1
     dac:	00005097          	auipc	ra,0x5
     db0:	e14080e7          	jalr	-492(ra) # 5bc0 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     db4:	85ce                	mv	a1,s3
     db6:	00006517          	auipc	a0,0x6
     dba:	8e250513          	addi	a0,a0,-1822 # 6698 <malloc+0x676>
     dbe:	00005097          	auipc	ra,0x5
     dc2:	1ac080e7          	jalr	428(ra) # 5f6a <printf>
    exit(1);
     dc6:	4505                	li	a0,1
     dc8:	00005097          	auipc	ra,0x5
     dcc:	df8080e7          	jalr	-520(ra) # 5bc0 <exit>
    printf("%s: unlinkread read failed", s);
     dd0:	85ce                	mv	a1,s3
     dd2:	00006517          	auipc	a0,0x6
     dd6:	8ee50513          	addi	a0,a0,-1810 # 66c0 <malloc+0x69e>
     dda:	00005097          	auipc	ra,0x5
     dde:	190080e7          	jalr	400(ra) # 5f6a <printf>
    exit(1);
     de2:	4505                	li	a0,1
     de4:	00005097          	auipc	ra,0x5
     de8:	ddc080e7          	jalr	-548(ra) # 5bc0 <exit>
    printf("%s: unlinkread wrong data\n", s);
     dec:	85ce                	mv	a1,s3
     dee:	00006517          	auipc	a0,0x6
     df2:	8f250513          	addi	a0,a0,-1806 # 66e0 <malloc+0x6be>
     df6:	00005097          	auipc	ra,0x5
     dfa:	174080e7          	jalr	372(ra) # 5f6a <printf>
    exit(1);
     dfe:	4505                	li	a0,1
     e00:	00005097          	auipc	ra,0x5
     e04:	dc0080e7          	jalr	-576(ra) # 5bc0 <exit>
    printf("%s: unlinkread write failed\n", s);
     e08:	85ce                	mv	a1,s3
     e0a:	00006517          	auipc	a0,0x6
     e0e:	8f650513          	addi	a0,a0,-1802 # 6700 <malloc+0x6de>
     e12:	00005097          	auipc	ra,0x5
     e16:	158080e7          	jalr	344(ra) # 5f6a <printf>
    exit(1);
     e1a:	4505                	li	a0,1
     e1c:	00005097          	auipc	ra,0x5
     e20:	da4080e7          	jalr	-604(ra) # 5bc0 <exit>

0000000000000e24 <linktest>:
{
     e24:	1101                	addi	sp,sp,-32
     e26:	ec06                	sd	ra,24(sp)
     e28:	e822                	sd	s0,16(sp)
     e2a:	e426                	sd	s1,8(sp)
     e2c:	e04a                	sd	s2,0(sp)
     e2e:	1000                	addi	s0,sp,32
     e30:	892a                	mv	s2,a0
  unlink("lf1");
     e32:	00006517          	auipc	a0,0x6
     e36:	8ee50513          	addi	a0,a0,-1810 # 6720 <malloc+0x6fe>
     e3a:	00005097          	auipc	ra,0x5
     e3e:	dd6080e7          	jalr	-554(ra) # 5c10 <unlink>
  unlink("lf2");
     e42:	00006517          	auipc	a0,0x6
     e46:	8e650513          	addi	a0,a0,-1818 # 6728 <malloc+0x706>
     e4a:	00005097          	auipc	ra,0x5
     e4e:	dc6080e7          	jalr	-570(ra) # 5c10 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     e52:	20200593          	li	a1,514
     e56:	00006517          	auipc	a0,0x6
     e5a:	8ca50513          	addi	a0,a0,-1846 # 6720 <malloc+0x6fe>
     e5e:	00005097          	auipc	ra,0x5
     e62:	da2080e7          	jalr	-606(ra) # 5c00 <open>
  if(fd < 0){
     e66:	10054763          	bltz	a0,f74 <linktest+0x150>
     e6a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     e6c:	4615                	li	a2,5
     e6e:	00006597          	auipc	a1,0x6
     e72:	80258593          	addi	a1,a1,-2046 # 6670 <malloc+0x64e>
     e76:	00005097          	auipc	ra,0x5
     e7a:	d6a080e7          	jalr	-662(ra) # 5be0 <write>
     e7e:	4795                	li	a5,5
     e80:	10f51863          	bne	a0,a5,f90 <linktest+0x16c>
  close(fd);
     e84:	8526                	mv	a0,s1
     e86:	00005097          	auipc	ra,0x5
     e8a:	d62080e7          	jalr	-670(ra) # 5be8 <close>
  if(link("lf1", "lf2") < 0){
     e8e:	00006597          	auipc	a1,0x6
     e92:	89a58593          	addi	a1,a1,-1894 # 6728 <malloc+0x706>
     e96:	00006517          	auipc	a0,0x6
     e9a:	88a50513          	addi	a0,a0,-1910 # 6720 <malloc+0x6fe>
     e9e:	00005097          	auipc	ra,0x5
     ea2:	d82080e7          	jalr	-638(ra) # 5c20 <link>
     ea6:	10054363          	bltz	a0,fac <linktest+0x188>
  unlink("lf1");
     eaa:	00006517          	auipc	a0,0x6
     eae:	87650513          	addi	a0,a0,-1930 # 6720 <malloc+0x6fe>
     eb2:	00005097          	auipc	ra,0x5
     eb6:	d5e080e7          	jalr	-674(ra) # 5c10 <unlink>
  if(open("lf1", 0) >= 0){
     eba:	4581                	li	a1,0
     ebc:	00006517          	auipc	a0,0x6
     ec0:	86450513          	addi	a0,a0,-1948 # 6720 <malloc+0x6fe>
     ec4:	00005097          	auipc	ra,0x5
     ec8:	d3c080e7          	jalr	-708(ra) # 5c00 <open>
     ecc:	0e055e63          	bgez	a0,fc8 <linktest+0x1a4>
  fd = open("lf2", 0);
     ed0:	4581                	li	a1,0
     ed2:	00006517          	auipc	a0,0x6
     ed6:	85650513          	addi	a0,a0,-1962 # 6728 <malloc+0x706>
     eda:	00005097          	auipc	ra,0x5
     ede:	d26080e7          	jalr	-730(ra) # 5c00 <open>
     ee2:	84aa                	mv	s1,a0
  if(fd < 0){
     ee4:	10054063          	bltz	a0,fe4 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     ee8:	660d                	lui	a2,0x3
     eea:	0000c597          	auipc	a1,0xc
     eee:	d6e58593          	addi	a1,a1,-658 # cc58 <buf>
     ef2:	00005097          	auipc	ra,0x5
     ef6:	ce6080e7          	jalr	-794(ra) # 5bd8 <read>
     efa:	4795                	li	a5,5
     efc:	10f51263          	bne	a0,a5,1000 <linktest+0x1dc>
  close(fd);
     f00:	8526                	mv	a0,s1
     f02:	00005097          	auipc	ra,0x5
     f06:	ce6080e7          	jalr	-794(ra) # 5be8 <close>
  if(link("lf2", "lf2") >= 0){
     f0a:	00006597          	auipc	a1,0x6
     f0e:	81e58593          	addi	a1,a1,-2018 # 6728 <malloc+0x706>
     f12:	852e                	mv	a0,a1
     f14:	00005097          	auipc	ra,0x5
     f18:	d0c080e7          	jalr	-756(ra) # 5c20 <link>
     f1c:	10055063          	bgez	a0,101c <linktest+0x1f8>
  unlink("lf2");
     f20:	00006517          	auipc	a0,0x6
     f24:	80850513          	addi	a0,a0,-2040 # 6728 <malloc+0x706>
     f28:	00005097          	auipc	ra,0x5
     f2c:	ce8080e7          	jalr	-792(ra) # 5c10 <unlink>
  if(link("lf2", "lf1") >= 0){
     f30:	00005597          	auipc	a1,0x5
     f34:	7f058593          	addi	a1,a1,2032 # 6720 <malloc+0x6fe>
     f38:	00005517          	auipc	a0,0x5
     f3c:	7f050513          	addi	a0,a0,2032 # 6728 <malloc+0x706>
     f40:	00005097          	auipc	ra,0x5
     f44:	ce0080e7          	jalr	-800(ra) # 5c20 <link>
     f48:	0e055863          	bgez	a0,1038 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     f4c:	00005597          	auipc	a1,0x5
     f50:	7d458593          	addi	a1,a1,2004 # 6720 <malloc+0x6fe>
     f54:	00006517          	auipc	a0,0x6
     f58:	8dc50513          	addi	a0,a0,-1828 # 6830 <malloc+0x80e>
     f5c:	00005097          	auipc	ra,0x5
     f60:	cc4080e7          	jalr	-828(ra) # 5c20 <link>
     f64:	0e055863          	bgez	a0,1054 <linktest+0x230>
}
     f68:	60e2                	ld	ra,24(sp)
     f6a:	6442                	ld	s0,16(sp)
     f6c:	64a2                	ld	s1,8(sp)
     f6e:	6902                	ld	s2,0(sp)
     f70:	6105                	addi	sp,sp,32
     f72:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     f74:	85ca                	mv	a1,s2
     f76:	00005517          	auipc	a0,0x5
     f7a:	7ba50513          	addi	a0,a0,1978 # 6730 <malloc+0x70e>
     f7e:	00005097          	auipc	ra,0x5
     f82:	fec080e7          	jalr	-20(ra) # 5f6a <printf>
    exit(1);
     f86:	4505                	li	a0,1
     f88:	00005097          	auipc	ra,0x5
     f8c:	c38080e7          	jalr	-968(ra) # 5bc0 <exit>
    printf("%s: write lf1 failed\n", s);
     f90:	85ca                	mv	a1,s2
     f92:	00005517          	auipc	a0,0x5
     f96:	7b650513          	addi	a0,a0,1974 # 6748 <malloc+0x726>
     f9a:	00005097          	auipc	ra,0x5
     f9e:	fd0080e7          	jalr	-48(ra) # 5f6a <printf>
    exit(1);
     fa2:	4505                	li	a0,1
     fa4:	00005097          	auipc	ra,0x5
     fa8:	c1c080e7          	jalr	-996(ra) # 5bc0 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     fac:	85ca                	mv	a1,s2
     fae:	00005517          	auipc	a0,0x5
     fb2:	7b250513          	addi	a0,a0,1970 # 6760 <malloc+0x73e>
     fb6:	00005097          	auipc	ra,0x5
     fba:	fb4080e7          	jalr	-76(ra) # 5f6a <printf>
    exit(1);
     fbe:	4505                	li	a0,1
     fc0:	00005097          	auipc	ra,0x5
     fc4:	c00080e7          	jalr	-1024(ra) # 5bc0 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     fc8:	85ca                	mv	a1,s2
     fca:	00005517          	auipc	a0,0x5
     fce:	7b650513          	addi	a0,a0,1974 # 6780 <malloc+0x75e>
     fd2:	00005097          	auipc	ra,0x5
     fd6:	f98080e7          	jalr	-104(ra) # 5f6a <printf>
    exit(1);
     fda:	4505                	li	a0,1
     fdc:	00005097          	auipc	ra,0x5
     fe0:	be4080e7          	jalr	-1052(ra) # 5bc0 <exit>
    printf("%s: open lf2 failed\n", s);
     fe4:	85ca                	mv	a1,s2
     fe6:	00005517          	auipc	a0,0x5
     fea:	7ca50513          	addi	a0,a0,1994 # 67b0 <malloc+0x78e>
     fee:	00005097          	auipc	ra,0x5
     ff2:	f7c080e7          	jalr	-132(ra) # 5f6a <printf>
    exit(1);
     ff6:	4505                	li	a0,1
     ff8:	00005097          	auipc	ra,0x5
     ffc:	bc8080e7          	jalr	-1080(ra) # 5bc0 <exit>
    printf("%s: read lf2 failed\n", s);
    1000:	85ca                	mv	a1,s2
    1002:	00005517          	auipc	a0,0x5
    1006:	7c650513          	addi	a0,a0,1990 # 67c8 <malloc+0x7a6>
    100a:	00005097          	auipc	ra,0x5
    100e:	f60080e7          	jalr	-160(ra) # 5f6a <printf>
    exit(1);
    1012:	4505                	li	a0,1
    1014:	00005097          	auipc	ra,0x5
    1018:	bac080e7          	jalr	-1108(ra) # 5bc0 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    101c:	85ca                	mv	a1,s2
    101e:	00005517          	auipc	a0,0x5
    1022:	7c250513          	addi	a0,a0,1986 # 67e0 <malloc+0x7be>
    1026:	00005097          	auipc	ra,0x5
    102a:	f44080e7          	jalr	-188(ra) # 5f6a <printf>
    exit(1);
    102e:	4505                	li	a0,1
    1030:	00005097          	auipc	ra,0x5
    1034:	b90080e7          	jalr	-1136(ra) # 5bc0 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1038:	85ca                	mv	a1,s2
    103a:	00005517          	auipc	a0,0x5
    103e:	7ce50513          	addi	a0,a0,1998 # 6808 <malloc+0x7e6>
    1042:	00005097          	auipc	ra,0x5
    1046:	f28080e7          	jalr	-216(ra) # 5f6a <printf>
    exit(1);
    104a:	4505                	li	a0,1
    104c:	00005097          	auipc	ra,0x5
    1050:	b74080e7          	jalr	-1164(ra) # 5bc0 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1054:	85ca                	mv	a1,s2
    1056:	00005517          	auipc	a0,0x5
    105a:	7e250513          	addi	a0,a0,2018 # 6838 <malloc+0x816>
    105e:	00005097          	auipc	ra,0x5
    1062:	f0c080e7          	jalr	-244(ra) # 5f6a <printf>
    exit(1);
    1066:	4505                	li	a0,1
    1068:	00005097          	auipc	ra,0x5
    106c:	b58080e7          	jalr	-1192(ra) # 5bc0 <exit>

0000000000001070 <validatetest>:
{
    1070:	7139                	addi	sp,sp,-64
    1072:	fc06                	sd	ra,56(sp)
    1074:	f822                	sd	s0,48(sp)
    1076:	f426                	sd	s1,40(sp)
    1078:	f04a                	sd	s2,32(sp)
    107a:	ec4e                	sd	s3,24(sp)
    107c:	e852                	sd	s4,16(sp)
    107e:	e456                	sd	s5,8(sp)
    1080:	e05a                	sd	s6,0(sp)
    1082:	0080                	addi	s0,sp,64
    1084:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1086:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    1088:	00005997          	auipc	s3,0x5
    108c:	7d098993          	addi	s3,s3,2000 # 6858 <malloc+0x836>
    1090:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1092:	6a85                	lui	s5,0x1
    1094:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1098:	85a6                	mv	a1,s1
    109a:	854e                	mv	a0,s3
    109c:	00005097          	auipc	ra,0x5
    10a0:	b84080e7          	jalr	-1148(ra) # 5c20 <link>
    10a4:	01251f63          	bne	a0,s2,10c2 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10a8:	94d6                	add	s1,s1,s5
    10aa:	ff4497e3          	bne	s1,s4,1098 <validatetest+0x28>
}
    10ae:	70e2                	ld	ra,56(sp)
    10b0:	7442                	ld	s0,48(sp)
    10b2:	74a2                	ld	s1,40(sp)
    10b4:	7902                	ld	s2,32(sp)
    10b6:	69e2                	ld	s3,24(sp)
    10b8:	6a42                	ld	s4,16(sp)
    10ba:	6aa2                	ld	s5,8(sp)
    10bc:	6b02                	ld	s6,0(sp)
    10be:	6121                	addi	sp,sp,64
    10c0:	8082                	ret
      printf("%s: link should not succeed\n", s);
    10c2:	85da                	mv	a1,s6
    10c4:	00005517          	auipc	a0,0x5
    10c8:	7a450513          	addi	a0,a0,1956 # 6868 <malloc+0x846>
    10cc:	00005097          	auipc	ra,0x5
    10d0:	e9e080e7          	jalr	-354(ra) # 5f6a <printf>
      exit(1);
    10d4:	4505                	li	a0,1
    10d6:	00005097          	auipc	ra,0x5
    10da:	aea080e7          	jalr	-1302(ra) # 5bc0 <exit>

00000000000010de <bigdir>:
{
    10de:	715d                	addi	sp,sp,-80
    10e0:	e486                	sd	ra,72(sp)
    10e2:	e0a2                	sd	s0,64(sp)
    10e4:	fc26                	sd	s1,56(sp)
    10e6:	f84a                	sd	s2,48(sp)
    10e8:	f44e                	sd	s3,40(sp)
    10ea:	f052                	sd	s4,32(sp)
    10ec:	ec56                	sd	s5,24(sp)
    10ee:	e85a                	sd	s6,16(sp)
    10f0:	0880                	addi	s0,sp,80
    10f2:	89aa                	mv	s3,a0
  unlink("bd");
    10f4:	00005517          	auipc	a0,0x5
    10f8:	79450513          	addi	a0,a0,1940 # 6888 <malloc+0x866>
    10fc:	00005097          	auipc	ra,0x5
    1100:	b14080e7          	jalr	-1260(ra) # 5c10 <unlink>
  fd = open("bd", O_CREATE);
    1104:	20000593          	li	a1,512
    1108:	00005517          	auipc	a0,0x5
    110c:	78050513          	addi	a0,a0,1920 # 6888 <malloc+0x866>
    1110:	00005097          	auipc	ra,0x5
    1114:	af0080e7          	jalr	-1296(ra) # 5c00 <open>
  if(fd < 0){
    1118:	0c054963          	bltz	a0,11ea <bigdir+0x10c>
  close(fd);
    111c:	00005097          	auipc	ra,0x5
    1120:	acc080e7          	jalr	-1332(ra) # 5be8 <close>
  for(i = 0; i < N; i++){
    1124:	4901                	li	s2,0
    name[0] = 'x';
    1126:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    112a:	00005a17          	auipc	s4,0x5
    112e:	75ea0a13          	addi	s4,s4,1886 # 6888 <malloc+0x866>
  for(i = 0; i < N; i++){
    1132:	1f400b13          	li	s6,500
    name[0] = 'x';
    1136:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    113a:	41f9571b          	sraiw	a4,s2,0x1f
    113e:	01a7571b          	srliw	a4,a4,0x1a
    1142:	012707bb          	addw	a5,a4,s2
    1146:	4067d69b          	sraiw	a3,a5,0x6
    114a:	0306869b          	addiw	a3,a3,48
    114e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1152:	03f7f793          	andi	a5,a5,63
    1156:	9f99                	subw	a5,a5,a4
    1158:	0307879b          	addiw	a5,a5,48
    115c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1160:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1164:	fb040593          	addi	a1,s0,-80
    1168:	8552                	mv	a0,s4
    116a:	00005097          	auipc	ra,0x5
    116e:	ab6080e7          	jalr	-1354(ra) # 5c20 <link>
    1172:	84aa                	mv	s1,a0
    1174:	e949                	bnez	a0,1206 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1176:	2905                	addiw	s2,s2,1
    1178:	fb691fe3          	bne	s2,s6,1136 <bigdir+0x58>
  unlink("bd");
    117c:	00005517          	auipc	a0,0x5
    1180:	70c50513          	addi	a0,a0,1804 # 6888 <malloc+0x866>
    1184:	00005097          	auipc	ra,0x5
    1188:	a8c080e7          	jalr	-1396(ra) # 5c10 <unlink>
    name[0] = 'x';
    118c:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1190:	1f400a13          	li	s4,500
    name[0] = 'x';
    1194:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1198:	41f4d71b          	sraiw	a4,s1,0x1f
    119c:	01a7571b          	srliw	a4,a4,0x1a
    11a0:	009707bb          	addw	a5,a4,s1
    11a4:	4067d69b          	sraiw	a3,a5,0x6
    11a8:	0306869b          	addiw	a3,a3,48
    11ac:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    11b0:	03f7f793          	andi	a5,a5,63
    11b4:	9f99                	subw	a5,a5,a4
    11b6:	0307879b          	addiw	a5,a5,48
    11ba:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    11be:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    11c2:	fb040513          	addi	a0,s0,-80
    11c6:	00005097          	auipc	ra,0x5
    11ca:	a4a080e7          	jalr	-1462(ra) # 5c10 <unlink>
    11ce:	ed21                	bnez	a0,1226 <bigdir+0x148>
  for(i = 0; i < N; i++){
    11d0:	2485                	addiw	s1,s1,1
    11d2:	fd4491e3          	bne	s1,s4,1194 <bigdir+0xb6>
}
    11d6:	60a6                	ld	ra,72(sp)
    11d8:	6406                	ld	s0,64(sp)
    11da:	74e2                	ld	s1,56(sp)
    11dc:	7942                	ld	s2,48(sp)
    11de:	79a2                	ld	s3,40(sp)
    11e0:	7a02                	ld	s4,32(sp)
    11e2:	6ae2                	ld	s5,24(sp)
    11e4:	6b42                	ld	s6,16(sp)
    11e6:	6161                	addi	sp,sp,80
    11e8:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    11ea:	85ce                	mv	a1,s3
    11ec:	00005517          	auipc	a0,0x5
    11f0:	6a450513          	addi	a0,a0,1700 # 6890 <malloc+0x86e>
    11f4:	00005097          	auipc	ra,0x5
    11f8:	d76080e7          	jalr	-650(ra) # 5f6a <printf>
    exit(1);
    11fc:	4505                	li	a0,1
    11fe:	00005097          	auipc	ra,0x5
    1202:	9c2080e7          	jalr	-1598(ra) # 5bc0 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1206:	fb040613          	addi	a2,s0,-80
    120a:	85ce                	mv	a1,s3
    120c:	00005517          	auipc	a0,0x5
    1210:	6a450513          	addi	a0,a0,1700 # 68b0 <malloc+0x88e>
    1214:	00005097          	auipc	ra,0x5
    1218:	d56080e7          	jalr	-682(ra) # 5f6a <printf>
      exit(1);
    121c:	4505                	li	a0,1
    121e:	00005097          	auipc	ra,0x5
    1222:	9a2080e7          	jalr	-1630(ra) # 5bc0 <exit>
      printf("%s: bigdir unlink failed", s);
    1226:	85ce                	mv	a1,s3
    1228:	00005517          	auipc	a0,0x5
    122c:	6a850513          	addi	a0,a0,1704 # 68d0 <malloc+0x8ae>
    1230:	00005097          	auipc	ra,0x5
    1234:	d3a080e7          	jalr	-710(ra) # 5f6a <printf>
      exit(1);
    1238:	4505                	li	a0,1
    123a:	00005097          	auipc	ra,0x5
    123e:	986080e7          	jalr	-1658(ra) # 5bc0 <exit>

0000000000001242 <pgbug>:
{
    1242:	7179                	addi	sp,sp,-48
    1244:	f406                	sd	ra,40(sp)
    1246:	f022                	sd	s0,32(sp)
    1248:	ec26                	sd	s1,24(sp)
    124a:	1800                	addi	s0,sp,48
  argv[0] = 0;
    124c:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1250:	00008497          	auipc	s1,0x8
    1254:	db048493          	addi	s1,s1,-592 # 9000 <big>
    1258:	fd840593          	addi	a1,s0,-40
    125c:	6088                	ld	a0,0(s1)
    125e:	00005097          	auipc	ra,0x5
    1262:	99a080e7          	jalr	-1638(ra) # 5bf8 <exec>
  pipe(big);
    1266:	6088                	ld	a0,0(s1)
    1268:	00005097          	auipc	ra,0x5
    126c:	968080e7          	jalr	-1688(ra) # 5bd0 <pipe>
  exit(0);
    1270:	4501                	li	a0,0
    1272:	00005097          	auipc	ra,0x5
    1276:	94e080e7          	jalr	-1714(ra) # 5bc0 <exit>

000000000000127a <badarg>:
{
    127a:	7139                	addi	sp,sp,-64
    127c:	fc06                	sd	ra,56(sp)
    127e:	f822                	sd	s0,48(sp)
    1280:	f426                	sd	s1,40(sp)
    1282:	f04a                	sd	s2,32(sp)
    1284:	ec4e                	sd	s3,24(sp)
    1286:	0080                	addi	s0,sp,64
    1288:	64b1                	lui	s1,0xc
    128a:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1e08>
    argv[0] = (char*)0xffffffff;
    128e:	597d                	li	s2,-1
    1290:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1294:	00005997          	auipc	s3,0x5
    1298:	eb498993          	addi	s3,s3,-332 # 6148 <malloc+0x126>
    argv[0] = (char*)0xffffffff;
    129c:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    12a0:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    12a4:	fc040593          	addi	a1,s0,-64
    12a8:	854e                	mv	a0,s3
    12aa:	00005097          	auipc	ra,0x5
    12ae:	94e080e7          	jalr	-1714(ra) # 5bf8 <exec>
  for(int i = 0; i < 50000; i++){
    12b2:	34fd                	addiw	s1,s1,-1
    12b4:	f4e5                	bnez	s1,129c <badarg+0x22>
  exit(0);
    12b6:	4501                	li	a0,0
    12b8:	00005097          	auipc	ra,0x5
    12bc:	908080e7          	jalr	-1784(ra) # 5bc0 <exit>

00000000000012c0 <copyinstr2>:
{
    12c0:	7155                	addi	sp,sp,-208
    12c2:	e586                	sd	ra,200(sp)
    12c4:	e1a2                	sd	s0,192(sp)
    12c6:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    12c8:	f6840793          	addi	a5,s0,-152
    12cc:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    12d0:	07800713          	li	a4,120
    12d4:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    12d8:	0785                	addi	a5,a5,1
    12da:	fed79de3          	bne	a5,a3,12d4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    12de:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    12e2:	f6840513          	addi	a0,s0,-152
    12e6:	00005097          	auipc	ra,0x5
    12ea:	92a080e7          	jalr	-1750(ra) # 5c10 <unlink>
  if(ret != -1){
    12ee:	57fd                	li	a5,-1
    12f0:	0ef51063          	bne	a0,a5,13d0 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    12f4:	20100593          	li	a1,513
    12f8:	f6840513          	addi	a0,s0,-152
    12fc:	00005097          	auipc	ra,0x5
    1300:	904080e7          	jalr	-1788(ra) # 5c00 <open>
  if(fd != -1){
    1304:	57fd                	li	a5,-1
    1306:	0ef51563          	bne	a0,a5,13f0 <copyinstr2+0x130>
  ret = link(b, b);
    130a:	f6840593          	addi	a1,s0,-152
    130e:	852e                	mv	a0,a1
    1310:	00005097          	auipc	ra,0x5
    1314:	910080e7          	jalr	-1776(ra) # 5c20 <link>
  if(ret != -1){
    1318:	57fd                	li	a5,-1
    131a:	0ef51b63          	bne	a0,a5,1410 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    131e:	00007797          	auipc	a5,0x7
    1322:	80a78793          	addi	a5,a5,-2038 # 7b28 <malloc+0x1b06>
    1326:	f4f43c23          	sd	a5,-168(s0)
    132a:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    132e:	f5840593          	addi	a1,s0,-168
    1332:	f6840513          	addi	a0,s0,-152
    1336:	00005097          	auipc	ra,0x5
    133a:	8c2080e7          	jalr	-1854(ra) # 5bf8 <exec>
  if(ret != -1){
    133e:	57fd                	li	a5,-1
    1340:	0ef51963          	bne	a0,a5,1432 <copyinstr2+0x172>
  int pid = fork();
    1344:	00005097          	auipc	ra,0x5
    1348:	874080e7          	jalr	-1932(ra) # 5bb8 <fork>
  if(pid < 0){
    134c:	10054363          	bltz	a0,1452 <copyinstr2+0x192>
  if(pid == 0){
    1350:	12051463          	bnez	a0,1478 <copyinstr2+0x1b8>
    1354:	00008797          	auipc	a5,0x8
    1358:	1ec78793          	addi	a5,a5,492 # 9540 <big.0>
    135c:	00009697          	auipc	a3,0x9
    1360:	1e468693          	addi	a3,a3,484 # a540 <big.0+0x1000>
      big[i] = 'x';
    1364:	07800713          	li	a4,120
    1368:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    136c:	0785                	addi	a5,a5,1
    136e:	fed79de3          	bne	a5,a3,1368 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1372:	00009797          	auipc	a5,0x9
    1376:	1c078723          	sb	zero,462(a5) # a540 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    137a:	00007797          	auipc	a5,0x7
    137e:	1ce78793          	addi	a5,a5,462 # 8548 <malloc+0x2526>
    1382:	6390                	ld	a2,0(a5)
    1384:	6794                	ld	a3,8(a5)
    1386:	6b98                	ld	a4,16(a5)
    1388:	6f9c                	ld	a5,24(a5)
    138a:	f2c43823          	sd	a2,-208(s0)
    138e:	f2d43c23          	sd	a3,-200(s0)
    1392:	f4e43023          	sd	a4,-192(s0)
    1396:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    139a:	f3040593          	addi	a1,s0,-208
    139e:	00005517          	auipc	a0,0x5
    13a2:	daa50513          	addi	a0,a0,-598 # 6148 <malloc+0x126>
    13a6:	00005097          	auipc	ra,0x5
    13aa:	852080e7          	jalr	-1966(ra) # 5bf8 <exec>
    if(ret != -1){
    13ae:	57fd                	li	a5,-1
    13b0:	0af50e63          	beq	a0,a5,146c <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    13b4:	55fd                	li	a1,-1
    13b6:	00005517          	auipc	a0,0x5
    13ba:	5c250513          	addi	a0,a0,1474 # 6978 <malloc+0x956>
    13be:	00005097          	auipc	ra,0x5
    13c2:	bac080e7          	jalr	-1108(ra) # 5f6a <printf>
      exit(1);
    13c6:	4505                	li	a0,1
    13c8:	00004097          	auipc	ra,0x4
    13cc:	7f8080e7          	jalr	2040(ra) # 5bc0 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    13d0:	862a                	mv	a2,a0
    13d2:	f6840593          	addi	a1,s0,-152
    13d6:	00005517          	auipc	a0,0x5
    13da:	51a50513          	addi	a0,a0,1306 # 68f0 <malloc+0x8ce>
    13de:	00005097          	auipc	ra,0x5
    13e2:	b8c080e7          	jalr	-1140(ra) # 5f6a <printf>
    exit(1);
    13e6:	4505                	li	a0,1
    13e8:	00004097          	auipc	ra,0x4
    13ec:	7d8080e7          	jalr	2008(ra) # 5bc0 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    13f0:	862a                	mv	a2,a0
    13f2:	f6840593          	addi	a1,s0,-152
    13f6:	00005517          	auipc	a0,0x5
    13fa:	51a50513          	addi	a0,a0,1306 # 6910 <malloc+0x8ee>
    13fe:	00005097          	auipc	ra,0x5
    1402:	b6c080e7          	jalr	-1172(ra) # 5f6a <printf>
    exit(1);
    1406:	4505                	li	a0,1
    1408:	00004097          	auipc	ra,0x4
    140c:	7b8080e7          	jalr	1976(ra) # 5bc0 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1410:	86aa                	mv	a3,a0
    1412:	f6840613          	addi	a2,s0,-152
    1416:	85b2                	mv	a1,a2
    1418:	00005517          	auipc	a0,0x5
    141c:	51850513          	addi	a0,a0,1304 # 6930 <malloc+0x90e>
    1420:	00005097          	auipc	ra,0x5
    1424:	b4a080e7          	jalr	-1206(ra) # 5f6a <printf>
    exit(1);
    1428:	4505                	li	a0,1
    142a:	00004097          	auipc	ra,0x4
    142e:	796080e7          	jalr	1942(ra) # 5bc0 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1432:	567d                	li	a2,-1
    1434:	f6840593          	addi	a1,s0,-152
    1438:	00005517          	auipc	a0,0x5
    143c:	52050513          	addi	a0,a0,1312 # 6958 <malloc+0x936>
    1440:	00005097          	auipc	ra,0x5
    1444:	b2a080e7          	jalr	-1238(ra) # 5f6a <printf>
    exit(1);
    1448:	4505                	li	a0,1
    144a:	00004097          	auipc	ra,0x4
    144e:	776080e7          	jalr	1910(ra) # 5bc0 <exit>
    printf("fork failed\n");
    1452:	00006517          	auipc	a0,0x6
    1456:	98650513          	addi	a0,a0,-1658 # 6dd8 <malloc+0xdb6>
    145a:	00005097          	auipc	ra,0x5
    145e:	b10080e7          	jalr	-1264(ra) # 5f6a <printf>
    exit(1);
    1462:	4505                	li	a0,1
    1464:	00004097          	auipc	ra,0x4
    1468:	75c080e7          	jalr	1884(ra) # 5bc0 <exit>
    exit(747); // OK
    146c:	2eb00513          	li	a0,747
    1470:	00004097          	auipc	ra,0x4
    1474:	750080e7          	jalr	1872(ra) # 5bc0 <exit>
  int st = 0;
    1478:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    147c:	f5440513          	addi	a0,s0,-172
    1480:	00004097          	auipc	ra,0x4
    1484:	748080e7          	jalr	1864(ra) # 5bc8 <wait>
  if(st != 747){
    1488:	f5442703          	lw	a4,-172(s0)
    148c:	2eb00793          	li	a5,747
    1490:	00f71663          	bne	a4,a5,149c <copyinstr2+0x1dc>
}
    1494:	60ae                	ld	ra,200(sp)
    1496:	640e                	ld	s0,192(sp)
    1498:	6169                	addi	sp,sp,208
    149a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    149c:	00005517          	auipc	a0,0x5
    14a0:	50450513          	addi	a0,a0,1284 # 69a0 <malloc+0x97e>
    14a4:	00005097          	auipc	ra,0x5
    14a8:	ac6080e7          	jalr	-1338(ra) # 5f6a <printf>
    exit(1);
    14ac:	4505                	li	a0,1
    14ae:	00004097          	auipc	ra,0x4
    14b2:	712080e7          	jalr	1810(ra) # 5bc0 <exit>

00000000000014b6 <truncate3>:
{
    14b6:	7159                	addi	sp,sp,-112
    14b8:	f486                	sd	ra,104(sp)
    14ba:	f0a2                	sd	s0,96(sp)
    14bc:	eca6                	sd	s1,88(sp)
    14be:	e8ca                	sd	s2,80(sp)
    14c0:	e4ce                	sd	s3,72(sp)
    14c2:	e0d2                	sd	s4,64(sp)
    14c4:	fc56                	sd	s5,56(sp)
    14c6:	1880                	addi	s0,sp,112
    14c8:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    14ca:	60100593          	li	a1,1537
    14ce:	00005517          	auipc	a0,0x5
    14d2:	cd250513          	addi	a0,a0,-814 # 61a0 <malloc+0x17e>
    14d6:	00004097          	auipc	ra,0x4
    14da:	72a080e7          	jalr	1834(ra) # 5c00 <open>
    14de:	00004097          	auipc	ra,0x4
    14e2:	70a080e7          	jalr	1802(ra) # 5be8 <close>
  pid = fork();
    14e6:	00004097          	auipc	ra,0x4
    14ea:	6d2080e7          	jalr	1746(ra) # 5bb8 <fork>
  if(pid < 0){
    14ee:	08054063          	bltz	a0,156e <truncate3+0xb8>
  if(pid == 0){
    14f2:	e969                	bnez	a0,15c4 <truncate3+0x10e>
    14f4:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    14f8:	00005a17          	auipc	s4,0x5
    14fc:	ca8a0a13          	addi	s4,s4,-856 # 61a0 <malloc+0x17e>
      int n = write(fd, "1234567890", 10);
    1500:	00005a97          	auipc	s5,0x5
    1504:	500a8a93          	addi	s5,s5,1280 # 6a00 <malloc+0x9de>
      int fd = open("truncfile", O_WRONLY);
    1508:	4585                	li	a1,1
    150a:	8552                	mv	a0,s4
    150c:	00004097          	auipc	ra,0x4
    1510:	6f4080e7          	jalr	1780(ra) # 5c00 <open>
    1514:	84aa                	mv	s1,a0
      if(fd < 0){
    1516:	06054a63          	bltz	a0,158a <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    151a:	4629                	li	a2,10
    151c:	85d6                	mv	a1,s5
    151e:	00004097          	auipc	ra,0x4
    1522:	6c2080e7          	jalr	1730(ra) # 5be0 <write>
      if(n != 10){
    1526:	47a9                	li	a5,10
    1528:	06f51f63          	bne	a0,a5,15a6 <truncate3+0xf0>
      close(fd);
    152c:	8526                	mv	a0,s1
    152e:	00004097          	auipc	ra,0x4
    1532:	6ba080e7          	jalr	1722(ra) # 5be8 <close>
      fd = open("truncfile", O_RDONLY);
    1536:	4581                	li	a1,0
    1538:	8552                	mv	a0,s4
    153a:	00004097          	auipc	ra,0x4
    153e:	6c6080e7          	jalr	1734(ra) # 5c00 <open>
    1542:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1544:	02000613          	li	a2,32
    1548:	f9840593          	addi	a1,s0,-104
    154c:	00004097          	auipc	ra,0x4
    1550:	68c080e7          	jalr	1676(ra) # 5bd8 <read>
      close(fd);
    1554:	8526                	mv	a0,s1
    1556:	00004097          	auipc	ra,0x4
    155a:	692080e7          	jalr	1682(ra) # 5be8 <close>
    for(int i = 0; i < 100; i++){
    155e:	39fd                	addiw	s3,s3,-1
    1560:	fa0994e3          	bnez	s3,1508 <truncate3+0x52>
    exit(0);
    1564:	4501                	li	a0,0
    1566:	00004097          	auipc	ra,0x4
    156a:	65a080e7          	jalr	1626(ra) # 5bc0 <exit>
    printf("%s: fork failed\n", s);
    156e:	85ca                	mv	a1,s2
    1570:	00005517          	auipc	a0,0x5
    1574:	46050513          	addi	a0,a0,1120 # 69d0 <malloc+0x9ae>
    1578:	00005097          	auipc	ra,0x5
    157c:	9f2080e7          	jalr	-1550(ra) # 5f6a <printf>
    exit(1);
    1580:	4505                	li	a0,1
    1582:	00004097          	auipc	ra,0x4
    1586:	63e080e7          	jalr	1598(ra) # 5bc0 <exit>
        printf("%s: open failed\n", s);
    158a:	85ca                	mv	a1,s2
    158c:	00005517          	auipc	a0,0x5
    1590:	45c50513          	addi	a0,a0,1116 # 69e8 <malloc+0x9c6>
    1594:	00005097          	auipc	ra,0x5
    1598:	9d6080e7          	jalr	-1578(ra) # 5f6a <printf>
        exit(1);
    159c:	4505                	li	a0,1
    159e:	00004097          	auipc	ra,0x4
    15a2:	622080e7          	jalr	1570(ra) # 5bc0 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    15a6:	862a                	mv	a2,a0
    15a8:	85ca                	mv	a1,s2
    15aa:	00005517          	auipc	a0,0x5
    15ae:	46650513          	addi	a0,a0,1126 # 6a10 <malloc+0x9ee>
    15b2:	00005097          	auipc	ra,0x5
    15b6:	9b8080e7          	jalr	-1608(ra) # 5f6a <printf>
        exit(1);
    15ba:	4505                	li	a0,1
    15bc:	00004097          	auipc	ra,0x4
    15c0:	604080e7          	jalr	1540(ra) # 5bc0 <exit>
    15c4:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    15c8:	00005a17          	auipc	s4,0x5
    15cc:	bd8a0a13          	addi	s4,s4,-1064 # 61a0 <malloc+0x17e>
    int n = write(fd, "xxx", 3);
    15d0:	00005a97          	auipc	s5,0x5
    15d4:	460a8a93          	addi	s5,s5,1120 # 6a30 <malloc+0xa0e>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    15d8:	60100593          	li	a1,1537
    15dc:	8552                	mv	a0,s4
    15de:	00004097          	auipc	ra,0x4
    15e2:	622080e7          	jalr	1570(ra) # 5c00 <open>
    15e6:	84aa                	mv	s1,a0
    if(fd < 0){
    15e8:	04054763          	bltz	a0,1636 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    15ec:	460d                	li	a2,3
    15ee:	85d6                	mv	a1,s5
    15f0:	00004097          	auipc	ra,0x4
    15f4:	5f0080e7          	jalr	1520(ra) # 5be0 <write>
    if(n != 3){
    15f8:	478d                	li	a5,3
    15fa:	04f51c63          	bne	a0,a5,1652 <truncate3+0x19c>
    close(fd);
    15fe:	8526                	mv	a0,s1
    1600:	00004097          	auipc	ra,0x4
    1604:	5e8080e7          	jalr	1512(ra) # 5be8 <close>
  for(int i = 0; i < 150; i++){
    1608:	39fd                	addiw	s3,s3,-1
    160a:	fc0997e3          	bnez	s3,15d8 <truncate3+0x122>
  wait(&xstatus);
    160e:	fbc40513          	addi	a0,s0,-68
    1612:	00004097          	auipc	ra,0x4
    1616:	5b6080e7          	jalr	1462(ra) # 5bc8 <wait>
  unlink("truncfile");
    161a:	00005517          	auipc	a0,0x5
    161e:	b8650513          	addi	a0,a0,-1146 # 61a0 <malloc+0x17e>
    1622:	00004097          	auipc	ra,0x4
    1626:	5ee080e7          	jalr	1518(ra) # 5c10 <unlink>
  exit(xstatus);
    162a:	fbc42503          	lw	a0,-68(s0)
    162e:	00004097          	auipc	ra,0x4
    1632:	592080e7          	jalr	1426(ra) # 5bc0 <exit>
      printf("%s: open failed\n", s);
    1636:	85ca                	mv	a1,s2
    1638:	00005517          	auipc	a0,0x5
    163c:	3b050513          	addi	a0,a0,944 # 69e8 <malloc+0x9c6>
    1640:	00005097          	auipc	ra,0x5
    1644:	92a080e7          	jalr	-1750(ra) # 5f6a <printf>
      exit(1);
    1648:	4505                	li	a0,1
    164a:	00004097          	auipc	ra,0x4
    164e:	576080e7          	jalr	1398(ra) # 5bc0 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1652:	862a                	mv	a2,a0
    1654:	85ca                	mv	a1,s2
    1656:	00005517          	auipc	a0,0x5
    165a:	3e250513          	addi	a0,a0,994 # 6a38 <malloc+0xa16>
    165e:	00005097          	auipc	ra,0x5
    1662:	90c080e7          	jalr	-1780(ra) # 5f6a <printf>
      exit(1);
    1666:	4505                	li	a0,1
    1668:	00004097          	auipc	ra,0x4
    166c:	558080e7          	jalr	1368(ra) # 5bc0 <exit>

0000000000001670 <exectest>:
{
    1670:	715d                	addi	sp,sp,-80
    1672:	e486                	sd	ra,72(sp)
    1674:	e0a2                	sd	s0,64(sp)
    1676:	fc26                	sd	s1,56(sp)
    1678:	f84a                	sd	s2,48(sp)
    167a:	0880                	addi	s0,sp,80
    167c:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    167e:	00005797          	auipc	a5,0x5
    1682:	aca78793          	addi	a5,a5,-1334 # 6148 <malloc+0x126>
    1686:	fcf43023          	sd	a5,-64(s0)
    168a:	00005797          	auipc	a5,0x5
    168e:	3ce78793          	addi	a5,a5,974 # 6a58 <malloc+0xa36>
    1692:	fcf43423          	sd	a5,-56(s0)
    1696:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    169a:	00005517          	auipc	a0,0x5
    169e:	3c650513          	addi	a0,a0,966 # 6a60 <malloc+0xa3e>
    16a2:	00004097          	auipc	ra,0x4
    16a6:	56e080e7          	jalr	1390(ra) # 5c10 <unlink>
  pid = fork();
    16aa:	00004097          	auipc	ra,0x4
    16ae:	50e080e7          	jalr	1294(ra) # 5bb8 <fork>
  if(pid < 0) {
    16b2:	04054663          	bltz	a0,16fe <exectest+0x8e>
    16b6:	84aa                	mv	s1,a0
  if(pid == 0) {
    16b8:	e959                	bnez	a0,174e <exectest+0xde>
    close(1);
    16ba:	4505                	li	a0,1
    16bc:	00004097          	auipc	ra,0x4
    16c0:	52c080e7          	jalr	1324(ra) # 5be8 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    16c4:	20100593          	li	a1,513
    16c8:	00005517          	auipc	a0,0x5
    16cc:	39850513          	addi	a0,a0,920 # 6a60 <malloc+0xa3e>
    16d0:	00004097          	auipc	ra,0x4
    16d4:	530080e7          	jalr	1328(ra) # 5c00 <open>
    if(fd < 0) {
    16d8:	04054163          	bltz	a0,171a <exectest+0xaa>
    if(fd != 1) {
    16dc:	4785                	li	a5,1
    16de:	04f50c63          	beq	a0,a5,1736 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    16e2:	85ca                	mv	a1,s2
    16e4:	00005517          	auipc	a0,0x5
    16e8:	39c50513          	addi	a0,a0,924 # 6a80 <malloc+0xa5e>
    16ec:	00005097          	auipc	ra,0x5
    16f0:	87e080e7          	jalr	-1922(ra) # 5f6a <printf>
      exit(1);
    16f4:	4505                	li	a0,1
    16f6:	00004097          	auipc	ra,0x4
    16fa:	4ca080e7          	jalr	1226(ra) # 5bc0 <exit>
     printf("%s: fork failed\n", s);
    16fe:	85ca                	mv	a1,s2
    1700:	00005517          	auipc	a0,0x5
    1704:	2d050513          	addi	a0,a0,720 # 69d0 <malloc+0x9ae>
    1708:	00005097          	auipc	ra,0x5
    170c:	862080e7          	jalr	-1950(ra) # 5f6a <printf>
     exit(1);
    1710:	4505                	li	a0,1
    1712:	00004097          	auipc	ra,0x4
    1716:	4ae080e7          	jalr	1198(ra) # 5bc0 <exit>
      printf("%s: create failed\n", s);
    171a:	85ca                	mv	a1,s2
    171c:	00005517          	auipc	a0,0x5
    1720:	34c50513          	addi	a0,a0,844 # 6a68 <malloc+0xa46>
    1724:	00005097          	auipc	ra,0x5
    1728:	846080e7          	jalr	-1978(ra) # 5f6a <printf>
      exit(1);
    172c:	4505                	li	a0,1
    172e:	00004097          	auipc	ra,0x4
    1732:	492080e7          	jalr	1170(ra) # 5bc0 <exit>
    if(exec("echo", echoargv) < 0){
    1736:	fc040593          	addi	a1,s0,-64
    173a:	00005517          	auipc	a0,0x5
    173e:	a0e50513          	addi	a0,a0,-1522 # 6148 <malloc+0x126>
    1742:	00004097          	auipc	ra,0x4
    1746:	4b6080e7          	jalr	1206(ra) # 5bf8 <exec>
    174a:	02054163          	bltz	a0,176c <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    174e:	fdc40513          	addi	a0,s0,-36
    1752:	00004097          	auipc	ra,0x4
    1756:	476080e7          	jalr	1142(ra) # 5bc8 <wait>
    175a:	02951763          	bne	a0,s1,1788 <exectest+0x118>
  if(xstatus != 0)
    175e:	fdc42503          	lw	a0,-36(s0)
    1762:	cd0d                	beqz	a0,179c <exectest+0x12c>
    exit(xstatus);
    1764:	00004097          	auipc	ra,0x4
    1768:	45c080e7          	jalr	1116(ra) # 5bc0 <exit>
      printf("%s: exec echo failed\n", s);
    176c:	85ca                	mv	a1,s2
    176e:	00005517          	auipc	a0,0x5
    1772:	32250513          	addi	a0,a0,802 # 6a90 <malloc+0xa6e>
    1776:	00004097          	auipc	ra,0x4
    177a:	7f4080e7          	jalr	2036(ra) # 5f6a <printf>
      exit(1);
    177e:	4505                	li	a0,1
    1780:	00004097          	auipc	ra,0x4
    1784:	440080e7          	jalr	1088(ra) # 5bc0 <exit>
    printf("%s: wait failed!\n", s);
    1788:	85ca                	mv	a1,s2
    178a:	00005517          	auipc	a0,0x5
    178e:	31e50513          	addi	a0,a0,798 # 6aa8 <malloc+0xa86>
    1792:	00004097          	auipc	ra,0x4
    1796:	7d8080e7          	jalr	2008(ra) # 5f6a <printf>
    179a:	b7d1                	j	175e <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    179c:	4581                	li	a1,0
    179e:	00005517          	auipc	a0,0x5
    17a2:	2c250513          	addi	a0,a0,706 # 6a60 <malloc+0xa3e>
    17a6:	00004097          	auipc	ra,0x4
    17aa:	45a080e7          	jalr	1114(ra) # 5c00 <open>
  if(fd < 0) {
    17ae:	02054a63          	bltz	a0,17e2 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    17b2:	4609                	li	a2,2
    17b4:	fb840593          	addi	a1,s0,-72
    17b8:	00004097          	auipc	ra,0x4
    17bc:	420080e7          	jalr	1056(ra) # 5bd8 <read>
    17c0:	4789                	li	a5,2
    17c2:	02f50e63          	beq	a0,a5,17fe <exectest+0x18e>
    printf("%s: read failed\n", s);
    17c6:	85ca                	mv	a1,s2
    17c8:	00005517          	auipc	a0,0x5
    17cc:	d5050513          	addi	a0,a0,-688 # 6518 <malloc+0x4f6>
    17d0:	00004097          	auipc	ra,0x4
    17d4:	79a080e7          	jalr	1946(ra) # 5f6a <printf>
    exit(1);
    17d8:	4505                	li	a0,1
    17da:	00004097          	auipc	ra,0x4
    17de:	3e6080e7          	jalr	998(ra) # 5bc0 <exit>
    printf("%s: open failed\n", s);
    17e2:	85ca                	mv	a1,s2
    17e4:	00005517          	auipc	a0,0x5
    17e8:	20450513          	addi	a0,a0,516 # 69e8 <malloc+0x9c6>
    17ec:	00004097          	auipc	ra,0x4
    17f0:	77e080e7          	jalr	1918(ra) # 5f6a <printf>
    exit(1);
    17f4:	4505                	li	a0,1
    17f6:	00004097          	auipc	ra,0x4
    17fa:	3ca080e7          	jalr	970(ra) # 5bc0 <exit>
  unlink("echo-ok");
    17fe:	00005517          	auipc	a0,0x5
    1802:	26250513          	addi	a0,a0,610 # 6a60 <malloc+0xa3e>
    1806:	00004097          	auipc	ra,0x4
    180a:	40a080e7          	jalr	1034(ra) # 5c10 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    180e:	fb844703          	lbu	a4,-72(s0)
    1812:	04f00793          	li	a5,79
    1816:	00f71863          	bne	a4,a5,1826 <exectest+0x1b6>
    181a:	fb944703          	lbu	a4,-71(s0)
    181e:	04b00793          	li	a5,75
    1822:	02f70063          	beq	a4,a5,1842 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1826:	85ca                	mv	a1,s2
    1828:	00005517          	auipc	a0,0x5
    182c:	29850513          	addi	a0,a0,664 # 6ac0 <malloc+0xa9e>
    1830:	00004097          	auipc	ra,0x4
    1834:	73a080e7          	jalr	1850(ra) # 5f6a <printf>
    exit(1);
    1838:	4505                	li	a0,1
    183a:	00004097          	auipc	ra,0x4
    183e:	386080e7          	jalr	902(ra) # 5bc0 <exit>
    exit(0);
    1842:	4501                	li	a0,0
    1844:	00004097          	auipc	ra,0x4
    1848:	37c080e7          	jalr	892(ra) # 5bc0 <exit>

000000000000184c <pipe1>:
{
    184c:	711d                	addi	sp,sp,-96
    184e:	ec86                	sd	ra,88(sp)
    1850:	e8a2                	sd	s0,80(sp)
    1852:	e4a6                	sd	s1,72(sp)
    1854:	e0ca                	sd	s2,64(sp)
    1856:	fc4e                	sd	s3,56(sp)
    1858:	f852                	sd	s4,48(sp)
    185a:	f456                	sd	s5,40(sp)
    185c:	f05a                	sd	s6,32(sp)
    185e:	ec5e                	sd	s7,24(sp)
    1860:	1080                	addi	s0,sp,96
    1862:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1864:	fa840513          	addi	a0,s0,-88
    1868:	00004097          	auipc	ra,0x4
    186c:	368080e7          	jalr	872(ra) # 5bd0 <pipe>
    1870:	e93d                	bnez	a0,18e6 <pipe1+0x9a>
    1872:	84aa                	mv	s1,a0
  pid = fork();
    1874:	00004097          	auipc	ra,0x4
    1878:	344080e7          	jalr	836(ra) # 5bb8 <fork>
    187c:	8a2a                	mv	s4,a0
  if(pid == 0){
    187e:	c151                	beqz	a0,1902 <pipe1+0xb6>
  } else if(pid > 0){
    1880:	16a05d63          	blez	a0,19fa <pipe1+0x1ae>
    close(fds[1]);
    1884:	fac42503          	lw	a0,-84(s0)
    1888:	00004097          	auipc	ra,0x4
    188c:	360080e7          	jalr	864(ra) # 5be8 <close>
    total = 0;
    1890:	8a26                	mv	s4,s1
    cc = 1;
    1892:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1894:	0000ba97          	auipc	s5,0xb
    1898:	3c4a8a93          	addi	s5,s5,964 # cc58 <buf>
      if(cc > sizeof(buf))
    189c:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    189e:	864e                	mv	a2,s3
    18a0:	85d6                	mv	a1,s5
    18a2:	fa842503          	lw	a0,-88(s0)
    18a6:	00004097          	auipc	ra,0x4
    18aa:	332080e7          	jalr	818(ra) # 5bd8 <read>
    18ae:	10a05163          	blez	a0,19b0 <pipe1+0x164>
      for(i = 0; i < n; i++){
    18b2:	0000b717          	auipc	a4,0xb
    18b6:	3a670713          	addi	a4,a4,934 # cc58 <buf>
    18ba:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    18be:	00074683          	lbu	a3,0(a4)
    18c2:	0ff4f793          	zext.b	a5,s1
    18c6:	2485                	addiw	s1,s1,1
    18c8:	0cf69063          	bne	a3,a5,1988 <pipe1+0x13c>
      for(i = 0; i < n; i++){
    18cc:	0705                	addi	a4,a4,1
    18ce:	fec498e3          	bne	s1,a2,18be <pipe1+0x72>
      total += n;
    18d2:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    18d6:	0019979b          	slliw	a5,s3,0x1
    18da:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    18de:	fd3b70e3          	bgeu	s6,s3,189e <pipe1+0x52>
        cc = sizeof(buf);
    18e2:	89da                	mv	s3,s6
    18e4:	bf6d                	j	189e <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    18e6:	85ca                	mv	a1,s2
    18e8:	00005517          	auipc	a0,0x5
    18ec:	1f050513          	addi	a0,a0,496 # 6ad8 <malloc+0xab6>
    18f0:	00004097          	auipc	ra,0x4
    18f4:	67a080e7          	jalr	1658(ra) # 5f6a <printf>
    exit(1);
    18f8:	4505                	li	a0,1
    18fa:	00004097          	auipc	ra,0x4
    18fe:	2c6080e7          	jalr	710(ra) # 5bc0 <exit>
    close(fds[0]);
    1902:	fa842503          	lw	a0,-88(s0)
    1906:	00004097          	auipc	ra,0x4
    190a:	2e2080e7          	jalr	738(ra) # 5be8 <close>
    for(n = 0; n < N; n++){
    190e:	0000bb17          	auipc	s6,0xb
    1912:	34ab0b13          	addi	s6,s6,842 # cc58 <buf>
    1916:	416004bb          	negw	s1,s6
    191a:	0ff4f493          	zext.b	s1,s1
    191e:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1922:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1924:	6a85                	lui	s5,0x1
    1926:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x16d>
{
    192a:	87da                	mv	a5,s6
        buf[i] = seq++;
    192c:	0097873b          	addw	a4,a5,s1
    1930:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1934:	0785                	addi	a5,a5,1
    1936:	fef99be3          	bne	s3,a5,192c <pipe1+0xe0>
        buf[i] = seq++;
    193a:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    193e:	40900613          	li	a2,1033
    1942:	85de                	mv	a1,s7
    1944:	fac42503          	lw	a0,-84(s0)
    1948:	00004097          	auipc	ra,0x4
    194c:	298080e7          	jalr	664(ra) # 5be0 <write>
    1950:	40900793          	li	a5,1033
    1954:	00f51c63          	bne	a0,a5,196c <pipe1+0x120>
    for(n = 0; n < N; n++){
    1958:	24a5                	addiw	s1,s1,9
    195a:	0ff4f493          	zext.b	s1,s1
    195e:	fd5a16e3          	bne	s4,s5,192a <pipe1+0xde>
    exit(0);
    1962:	4501                	li	a0,0
    1964:	00004097          	auipc	ra,0x4
    1968:	25c080e7          	jalr	604(ra) # 5bc0 <exit>
        printf("%s: pipe1 oops 1\n", s);
    196c:	85ca                	mv	a1,s2
    196e:	00005517          	auipc	a0,0x5
    1972:	18250513          	addi	a0,a0,386 # 6af0 <malloc+0xace>
    1976:	00004097          	auipc	ra,0x4
    197a:	5f4080e7          	jalr	1524(ra) # 5f6a <printf>
        exit(1);
    197e:	4505                	li	a0,1
    1980:	00004097          	auipc	ra,0x4
    1984:	240080e7          	jalr	576(ra) # 5bc0 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1988:	85ca                	mv	a1,s2
    198a:	00005517          	auipc	a0,0x5
    198e:	17e50513          	addi	a0,a0,382 # 6b08 <malloc+0xae6>
    1992:	00004097          	auipc	ra,0x4
    1996:	5d8080e7          	jalr	1496(ra) # 5f6a <printf>
}
    199a:	60e6                	ld	ra,88(sp)
    199c:	6446                	ld	s0,80(sp)
    199e:	64a6                	ld	s1,72(sp)
    19a0:	6906                	ld	s2,64(sp)
    19a2:	79e2                	ld	s3,56(sp)
    19a4:	7a42                	ld	s4,48(sp)
    19a6:	7aa2                	ld	s5,40(sp)
    19a8:	7b02                	ld	s6,32(sp)
    19aa:	6be2                	ld	s7,24(sp)
    19ac:	6125                	addi	sp,sp,96
    19ae:	8082                	ret
    if(total != N * SZ){
    19b0:	6785                	lui	a5,0x1
    19b2:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x16d>
    19b6:	02fa0063          	beq	s4,a5,19d6 <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    19ba:	85d2                	mv	a1,s4
    19bc:	00005517          	auipc	a0,0x5
    19c0:	16450513          	addi	a0,a0,356 # 6b20 <malloc+0xafe>
    19c4:	00004097          	auipc	ra,0x4
    19c8:	5a6080e7          	jalr	1446(ra) # 5f6a <printf>
      exit(1);
    19cc:	4505                	li	a0,1
    19ce:	00004097          	auipc	ra,0x4
    19d2:	1f2080e7          	jalr	498(ra) # 5bc0 <exit>
    close(fds[0]);
    19d6:	fa842503          	lw	a0,-88(s0)
    19da:	00004097          	auipc	ra,0x4
    19de:	20e080e7          	jalr	526(ra) # 5be8 <close>
    wait(&xstatus);
    19e2:	fa440513          	addi	a0,s0,-92
    19e6:	00004097          	auipc	ra,0x4
    19ea:	1e2080e7          	jalr	482(ra) # 5bc8 <wait>
    exit(xstatus);
    19ee:	fa442503          	lw	a0,-92(s0)
    19f2:	00004097          	auipc	ra,0x4
    19f6:	1ce080e7          	jalr	462(ra) # 5bc0 <exit>
    printf("%s: fork() failed\n", s);
    19fa:	85ca                	mv	a1,s2
    19fc:	00005517          	auipc	a0,0x5
    1a00:	14450513          	addi	a0,a0,324 # 6b40 <malloc+0xb1e>
    1a04:	00004097          	auipc	ra,0x4
    1a08:	566080e7          	jalr	1382(ra) # 5f6a <printf>
    exit(1);
    1a0c:	4505                	li	a0,1
    1a0e:	00004097          	auipc	ra,0x4
    1a12:	1b2080e7          	jalr	434(ra) # 5bc0 <exit>

0000000000001a16 <exitwait>:
{
    1a16:	7139                	addi	sp,sp,-64
    1a18:	fc06                	sd	ra,56(sp)
    1a1a:	f822                	sd	s0,48(sp)
    1a1c:	f426                	sd	s1,40(sp)
    1a1e:	f04a                	sd	s2,32(sp)
    1a20:	ec4e                	sd	s3,24(sp)
    1a22:	e852                	sd	s4,16(sp)
    1a24:	0080                	addi	s0,sp,64
    1a26:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1a28:	4901                	li	s2,0
    1a2a:	06400993          	li	s3,100
    pid = fork();
    1a2e:	00004097          	auipc	ra,0x4
    1a32:	18a080e7          	jalr	394(ra) # 5bb8 <fork>
    1a36:	84aa                	mv	s1,a0
    if(pid < 0){
    1a38:	02054a63          	bltz	a0,1a6c <exitwait+0x56>
    if(pid){
    1a3c:	c151                	beqz	a0,1ac0 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1a3e:	fcc40513          	addi	a0,s0,-52
    1a42:	00004097          	auipc	ra,0x4
    1a46:	186080e7          	jalr	390(ra) # 5bc8 <wait>
    1a4a:	02951f63          	bne	a0,s1,1a88 <exitwait+0x72>
      if(i != xstate) {
    1a4e:	fcc42783          	lw	a5,-52(s0)
    1a52:	05279963          	bne	a5,s2,1aa4 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1a56:	2905                	addiw	s2,s2,1
    1a58:	fd391be3          	bne	s2,s3,1a2e <exitwait+0x18>
}
    1a5c:	70e2                	ld	ra,56(sp)
    1a5e:	7442                	ld	s0,48(sp)
    1a60:	74a2                	ld	s1,40(sp)
    1a62:	7902                	ld	s2,32(sp)
    1a64:	69e2                	ld	s3,24(sp)
    1a66:	6a42                	ld	s4,16(sp)
    1a68:	6121                	addi	sp,sp,64
    1a6a:	8082                	ret
      printf("%s: fork failed\n", s);
    1a6c:	85d2                	mv	a1,s4
    1a6e:	00005517          	auipc	a0,0x5
    1a72:	f6250513          	addi	a0,a0,-158 # 69d0 <malloc+0x9ae>
    1a76:	00004097          	auipc	ra,0x4
    1a7a:	4f4080e7          	jalr	1268(ra) # 5f6a <printf>
      exit(1);
    1a7e:	4505                	li	a0,1
    1a80:	00004097          	auipc	ra,0x4
    1a84:	140080e7          	jalr	320(ra) # 5bc0 <exit>
        printf("%s: wait wrong pid\n", s);
    1a88:	85d2                	mv	a1,s4
    1a8a:	00005517          	auipc	a0,0x5
    1a8e:	0ce50513          	addi	a0,a0,206 # 6b58 <malloc+0xb36>
    1a92:	00004097          	auipc	ra,0x4
    1a96:	4d8080e7          	jalr	1240(ra) # 5f6a <printf>
        exit(1);
    1a9a:	4505                	li	a0,1
    1a9c:	00004097          	auipc	ra,0x4
    1aa0:	124080e7          	jalr	292(ra) # 5bc0 <exit>
        printf("%s: wait wrong exit status\n", s);
    1aa4:	85d2                	mv	a1,s4
    1aa6:	00005517          	auipc	a0,0x5
    1aaa:	0ca50513          	addi	a0,a0,202 # 6b70 <malloc+0xb4e>
    1aae:	00004097          	auipc	ra,0x4
    1ab2:	4bc080e7          	jalr	1212(ra) # 5f6a <printf>
        exit(1);
    1ab6:	4505                	li	a0,1
    1ab8:	00004097          	auipc	ra,0x4
    1abc:	108080e7          	jalr	264(ra) # 5bc0 <exit>
      exit(i);
    1ac0:	854a                	mv	a0,s2
    1ac2:	00004097          	auipc	ra,0x4
    1ac6:	0fe080e7          	jalr	254(ra) # 5bc0 <exit>

0000000000001aca <twochildren>:
{
    1aca:	1101                	addi	sp,sp,-32
    1acc:	ec06                	sd	ra,24(sp)
    1ace:	e822                	sd	s0,16(sp)
    1ad0:	e426                	sd	s1,8(sp)
    1ad2:	e04a                	sd	s2,0(sp)
    1ad4:	1000                	addi	s0,sp,32
    1ad6:	892a                	mv	s2,a0
    1ad8:	3e800493          	li	s1,1000
    int pid1 = fork();
    1adc:	00004097          	auipc	ra,0x4
    1ae0:	0dc080e7          	jalr	220(ra) # 5bb8 <fork>
    if(pid1 < 0){
    1ae4:	02054c63          	bltz	a0,1b1c <twochildren+0x52>
    if(pid1 == 0){
    1ae8:	c921                	beqz	a0,1b38 <twochildren+0x6e>
      int pid2 = fork();
    1aea:	00004097          	auipc	ra,0x4
    1aee:	0ce080e7          	jalr	206(ra) # 5bb8 <fork>
      if(pid2 < 0){
    1af2:	04054763          	bltz	a0,1b40 <twochildren+0x76>
      if(pid2 == 0){
    1af6:	c13d                	beqz	a0,1b5c <twochildren+0x92>
        wait(0);
    1af8:	4501                	li	a0,0
    1afa:	00004097          	auipc	ra,0x4
    1afe:	0ce080e7          	jalr	206(ra) # 5bc8 <wait>
        wait(0);
    1b02:	4501                	li	a0,0
    1b04:	00004097          	auipc	ra,0x4
    1b08:	0c4080e7          	jalr	196(ra) # 5bc8 <wait>
  for(int i = 0; i < 1000; i++){
    1b0c:	34fd                	addiw	s1,s1,-1
    1b0e:	f4f9                	bnez	s1,1adc <twochildren+0x12>
}
    1b10:	60e2                	ld	ra,24(sp)
    1b12:	6442                	ld	s0,16(sp)
    1b14:	64a2                	ld	s1,8(sp)
    1b16:	6902                	ld	s2,0(sp)
    1b18:	6105                	addi	sp,sp,32
    1b1a:	8082                	ret
      printf("%s: fork failed\n", s);
    1b1c:	85ca                	mv	a1,s2
    1b1e:	00005517          	auipc	a0,0x5
    1b22:	eb250513          	addi	a0,a0,-334 # 69d0 <malloc+0x9ae>
    1b26:	00004097          	auipc	ra,0x4
    1b2a:	444080e7          	jalr	1092(ra) # 5f6a <printf>
      exit(1);
    1b2e:	4505                	li	a0,1
    1b30:	00004097          	auipc	ra,0x4
    1b34:	090080e7          	jalr	144(ra) # 5bc0 <exit>
      exit(0);
    1b38:	00004097          	auipc	ra,0x4
    1b3c:	088080e7          	jalr	136(ra) # 5bc0 <exit>
        printf("%s: fork failed\n", s);
    1b40:	85ca                	mv	a1,s2
    1b42:	00005517          	auipc	a0,0x5
    1b46:	e8e50513          	addi	a0,a0,-370 # 69d0 <malloc+0x9ae>
    1b4a:	00004097          	auipc	ra,0x4
    1b4e:	420080e7          	jalr	1056(ra) # 5f6a <printf>
        exit(1);
    1b52:	4505                	li	a0,1
    1b54:	00004097          	auipc	ra,0x4
    1b58:	06c080e7          	jalr	108(ra) # 5bc0 <exit>
        exit(0);
    1b5c:	00004097          	auipc	ra,0x4
    1b60:	064080e7          	jalr	100(ra) # 5bc0 <exit>

0000000000001b64 <forkfork>:
{
    1b64:	7179                	addi	sp,sp,-48
    1b66:	f406                	sd	ra,40(sp)
    1b68:	f022                	sd	s0,32(sp)
    1b6a:	ec26                	sd	s1,24(sp)
    1b6c:	1800                	addi	s0,sp,48
    1b6e:	84aa                	mv	s1,a0
    int pid = fork();
    1b70:	00004097          	auipc	ra,0x4
    1b74:	048080e7          	jalr	72(ra) # 5bb8 <fork>
    if(pid < 0){
    1b78:	04054163          	bltz	a0,1bba <forkfork+0x56>
    if(pid == 0){
    1b7c:	cd29                	beqz	a0,1bd6 <forkfork+0x72>
    int pid = fork();
    1b7e:	00004097          	auipc	ra,0x4
    1b82:	03a080e7          	jalr	58(ra) # 5bb8 <fork>
    if(pid < 0){
    1b86:	02054a63          	bltz	a0,1bba <forkfork+0x56>
    if(pid == 0){
    1b8a:	c531                	beqz	a0,1bd6 <forkfork+0x72>
    wait(&xstatus);
    1b8c:	fdc40513          	addi	a0,s0,-36
    1b90:	00004097          	auipc	ra,0x4
    1b94:	038080e7          	jalr	56(ra) # 5bc8 <wait>
    if(xstatus != 0) {
    1b98:	fdc42783          	lw	a5,-36(s0)
    1b9c:	ebbd                	bnez	a5,1c12 <forkfork+0xae>
    wait(&xstatus);
    1b9e:	fdc40513          	addi	a0,s0,-36
    1ba2:	00004097          	auipc	ra,0x4
    1ba6:	026080e7          	jalr	38(ra) # 5bc8 <wait>
    if(xstatus != 0) {
    1baa:	fdc42783          	lw	a5,-36(s0)
    1bae:	e3b5                	bnez	a5,1c12 <forkfork+0xae>
}
    1bb0:	70a2                	ld	ra,40(sp)
    1bb2:	7402                	ld	s0,32(sp)
    1bb4:	64e2                	ld	s1,24(sp)
    1bb6:	6145                	addi	sp,sp,48
    1bb8:	8082                	ret
      printf("%s: fork failed", s);
    1bba:	85a6                	mv	a1,s1
    1bbc:	00005517          	auipc	a0,0x5
    1bc0:	fd450513          	addi	a0,a0,-44 # 6b90 <malloc+0xb6e>
    1bc4:	00004097          	auipc	ra,0x4
    1bc8:	3a6080e7          	jalr	934(ra) # 5f6a <printf>
      exit(1);
    1bcc:	4505                	li	a0,1
    1bce:	00004097          	auipc	ra,0x4
    1bd2:	ff2080e7          	jalr	-14(ra) # 5bc0 <exit>
{
    1bd6:	0c800493          	li	s1,200
        int pid1 = fork();
    1bda:	00004097          	auipc	ra,0x4
    1bde:	fde080e7          	jalr	-34(ra) # 5bb8 <fork>
        if(pid1 < 0){
    1be2:	00054f63          	bltz	a0,1c00 <forkfork+0x9c>
        if(pid1 == 0){
    1be6:	c115                	beqz	a0,1c0a <forkfork+0xa6>
        wait(0);
    1be8:	4501                	li	a0,0
    1bea:	00004097          	auipc	ra,0x4
    1bee:	fde080e7          	jalr	-34(ra) # 5bc8 <wait>
      for(int j = 0; j < 200; j++){
    1bf2:	34fd                	addiw	s1,s1,-1
    1bf4:	f0fd                	bnez	s1,1bda <forkfork+0x76>
      exit(0);
    1bf6:	4501                	li	a0,0
    1bf8:	00004097          	auipc	ra,0x4
    1bfc:	fc8080e7          	jalr	-56(ra) # 5bc0 <exit>
          exit(1);
    1c00:	4505                	li	a0,1
    1c02:	00004097          	auipc	ra,0x4
    1c06:	fbe080e7          	jalr	-66(ra) # 5bc0 <exit>
          exit(0);
    1c0a:	00004097          	auipc	ra,0x4
    1c0e:	fb6080e7          	jalr	-74(ra) # 5bc0 <exit>
      printf("%s: fork in child failed", s);
    1c12:	85a6                	mv	a1,s1
    1c14:	00005517          	auipc	a0,0x5
    1c18:	f8c50513          	addi	a0,a0,-116 # 6ba0 <malloc+0xb7e>
    1c1c:	00004097          	auipc	ra,0x4
    1c20:	34e080e7          	jalr	846(ra) # 5f6a <printf>
      exit(1);
    1c24:	4505                	li	a0,1
    1c26:	00004097          	auipc	ra,0x4
    1c2a:	f9a080e7          	jalr	-102(ra) # 5bc0 <exit>

0000000000001c2e <reparent2>:
{
    1c2e:	1101                	addi	sp,sp,-32
    1c30:	ec06                	sd	ra,24(sp)
    1c32:	e822                	sd	s0,16(sp)
    1c34:	e426                	sd	s1,8(sp)
    1c36:	1000                	addi	s0,sp,32
    1c38:	32000493          	li	s1,800
    int pid1 = fork();
    1c3c:	00004097          	auipc	ra,0x4
    1c40:	f7c080e7          	jalr	-132(ra) # 5bb8 <fork>
    if(pid1 < 0){
    1c44:	00054f63          	bltz	a0,1c62 <reparent2+0x34>
    if(pid1 == 0){
    1c48:	c915                	beqz	a0,1c7c <reparent2+0x4e>
    wait(0);
    1c4a:	4501                	li	a0,0
    1c4c:	00004097          	auipc	ra,0x4
    1c50:	f7c080e7          	jalr	-132(ra) # 5bc8 <wait>
  for(int i = 0; i < 800; i++){
    1c54:	34fd                	addiw	s1,s1,-1
    1c56:	f0fd                	bnez	s1,1c3c <reparent2+0xe>
  exit(0);
    1c58:	4501                	li	a0,0
    1c5a:	00004097          	auipc	ra,0x4
    1c5e:	f66080e7          	jalr	-154(ra) # 5bc0 <exit>
      printf("fork failed\n");
    1c62:	00005517          	auipc	a0,0x5
    1c66:	17650513          	addi	a0,a0,374 # 6dd8 <malloc+0xdb6>
    1c6a:	00004097          	auipc	ra,0x4
    1c6e:	300080e7          	jalr	768(ra) # 5f6a <printf>
      exit(1);
    1c72:	4505                	li	a0,1
    1c74:	00004097          	auipc	ra,0x4
    1c78:	f4c080e7          	jalr	-180(ra) # 5bc0 <exit>
      fork();
    1c7c:	00004097          	auipc	ra,0x4
    1c80:	f3c080e7          	jalr	-196(ra) # 5bb8 <fork>
      fork();
    1c84:	00004097          	auipc	ra,0x4
    1c88:	f34080e7          	jalr	-204(ra) # 5bb8 <fork>
      exit(0);
    1c8c:	4501                	li	a0,0
    1c8e:	00004097          	auipc	ra,0x4
    1c92:	f32080e7          	jalr	-206(ra) # 5bc0 <exit>

0000000000001c96 <createdelete>:
{
    1c96:	7175                	addi	sp,sp,-144
    1c98:	e506                	sd	ra,136(sp)
    1c9a:	e122                	sd	s0,128(sp)
    1c9c:	fca6                	sd	s1,120(sp)
    1c9e:	f8ca                	sd	s2,112(sp)
    1ca0:	f4ce                	sd	s3,104(sp)
    1ca2:	f0d2                	sd	s4,96(sp)
    1ca4:	ecd6                	sd	s5,88(sp)
    1ca6:	e8da                	sd	s6,80(sp)
    1ca8:	e4de                	sd	s7,72(sp)
    1caa:	e0e2                	sd	s8,64(sp)
    1cac:	fc66                	sd	s9,56(sp)
    1cae:	0900                	addi	s0,sp,144
    1cb0:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1cb2:	4901                	li	s2,0
    1cb4:	4991                	li	s3,4
    pid = fork();
    1cb6:	00004097          	auipc	ra,0x4
    1cba:	f02080e7          	jalr	-254(ra) # 5bb8 <fork>
    1cbe:	84aa                	mv	s1,a0
    if(pid < 0){
    1cc0:	02054f63          	bltz	a0,1cfe <createdelete+0x68>
    if(pid == 0){
    1cc4:	c939                	beqz	a0,1d1a <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1cc6:	2905                	addiw	s2,s2,1
    1cc8:	ff3917e3          	bne	s2,s3,1cb6 <createdelete+0x20>
    1ccc:	4491                	li	s1,4
    wait(&xstatus);
    1cce:	f7c40513          	addi	a0,s0,-132
    1cd2:	00004097          	auipc	ra,0x4
    1cd6:	ef6080e7          	jalr	-266(ra) # 5bc8 <wait>
    if(xstatus != 0)
    1cda:	f7c42903          	lw	s2,-132(s0)
    1cde:	0e091263          	bnez	s2,1dc2 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1ce2:	34fd                	addiw	s1,s1,-1
    1ce4:	f4ed                	bnez	s1,1cce <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1ce6:	f8040123          	sb	zero,-126(s0)
    1cea:	03000993          	li	s3,48
    1cee:	5a7d                	li	s4,-1
    1cf0:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1cf4:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1cf6:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1cf8:	07400a93          	li	s5,116
    1cfc:	a29d                	j	1e62 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1cfe:	85e6                	mv	a1,s9
    1d00:	00005517          	auipc	a0,0x5
    1d04:	0d850513          	addi	a0,a0,216 # 6dd8 <malloc+0xdb6>
    1d08:	00004097          	auipc	ra,0x4
    1d0c:	262080e7          	jalr	610(ra) # 5f6a <printf>
      exit(1);
    1d10:	4505                	li	a0,1
    1d12:	00004097          	auipc	ra,0x4
    1d16:	eae080e7          	jalr	-338(ra) # 5bc0 <exit>
      name[0] = 'p' + pi;
    1d1a:	0709091b          	addiw	s2,s2,112
    1d1e:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1d22:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1d26:	4951                	li	s2,20
    1d28:	a015                	j	1d4c <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1d2a:	85e6                	mv	a1,s9
    1d2c:	00005517          	auipc	a0,0x5
    1d30:	d3c50513          	addi	a0,a0,-708 # 6a68 <malloc+0xa46>
    1d34:	00004097          	auipc	ra,0x4
    1d38:	236080e7          	jalr	566(ra) # 5f6a <printf>
          exit(1);
    1d3c:	4505                	li	a0,1
    1d3e:	00004097          	auipc	ra,0x4
    1d42:	e82080e7          	jalr	-382(ra) # 5bc0 <exit>
      for(i = 0; i < N; i++){
    1d46:	2485                	addiw	s1,s1,1
    1d48:	07248863          	beq	s1,s2,1db8 <createdelete+0x122>
        name[1] = '0' + i;
    1d4c:	0304879b          	addiw	a5,s1,48
    1d50:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1d54:	20200593          	li	a1,514
    1d58:	f8040513          	addi	a0,s0,-128
    1d5c:	00004097          	auipc	ra,0x4
    1d60:	ea4080e7          	jalr	-348(ra) # 5c00 <open>
        if(fd < 0){
    1d64:	fc0543e3          	bltz	a0,1d2a <createdelete+0x94>
        close(fd);
    1d68:	00004097          	auipc	ra,0x4
    1d6c:	e80080e7          	jalr	-384(ra) # 5be8 <close>
        if(i > 0 && (i % 2 ) == 0){
    1d70:	fc905be3          	blez	s1,1d46 <createdelete+0xb0>
    1d74:	0014f793          	andi	a5,s1,1
    1d78:	f7f9                	bnez	a5,1d46 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1d7a:	01f4d79b          	srliw	a5,s1,0x1f
    1d7e:	9fa5                	addw	a5,a5,s1
    1d80:	4017d79b          	sraiw	a5,a5,0x1
    1d84:	0307879b          	addiw	a5,a5,48
    1d88:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1d8c:	f8040513          	addi	a0,s0,-128
    1d90:	00004097          	auipc	ra,0x4
    1d94:	e80080e7          	jalr	-384(ra) # 5c10 <unlink>
    1d98:	fa0557e3          	bgez	a0,1d46 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1d9c:	85e6                	mv	a1,s9
    1d9e:	00005517          	auipc	a0,0x5
    1da2:	e2250513          	addi	a0,a0,-478 # 6bc0 <malloc+0xb9e>
    1da6:	00004097          	auipc	ra,0x4
    1daa:	1c4080e7          	jalr	452(ra) # 5f6a <printf>
            exit(1);
    1dae:	4505                	li	a0,1
    1db0:	00004097          	auipc	ra,0x4
    1db4:	e10080e7          	jalr	-496(ra) # 5bc0 <exit>
      exit(0);
    1db8:	4501                	li	a0,0
    1dba:	00004097          	auipc	ra,0x4
    1dbe:	e06080e7          	jalr	-506(ra) # 5bc0 <exit>
      exit(1);
    1dc2:	4505                	li	a0,1
    1dc4:	00004097          	auipc	ra,0x4
    1dc8:	dfc080e7          	jalr	-516(ra) # 5bc0 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1dcc:	f8040613          	addi	a2,s0,-128
    1dd0:	85e6                	mv	a1,s9
    1dd2:	00005517          	auipc	a0,0x5
    1dd6:	e0650513          	addi	a0,a0,-506 # 6bd8 <malloc+0xbb6>
    1dda:	00004097          	auipc	ra,0x4
    1dde:	190080e7          	jalr	400(ra) # 5f6a <printf>
        exit(1);
    1de2:	4505                	li	a0,1
    1de4:	00004097          	auipc	ra,0x4
    1de8:	ddc080e7          	jalr	-548(ra) # 5bc0 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1dec:	054b7163          	bgeu	s6,s4,1e2e <createdelete+0x198>
      if(fd >= 0)
    1df0:	02055a63          	bgez	a0,1e24 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1df4:	2485                	addiw	s1,s1,1
    1df6:	0ff4f493          	zext.b	s1,s1
    1dfa:	05548c63          	beq	s1,s5,1e52 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1dfe:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1e02:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1e06:	4581                	li	a1,0
    1e08:	f8040513          	addi	a0,s0,-128
    1e0c:	00004097          	auipc	ra,0x4
    1e10:	df4080e7          	jalr	-524(ra) # 5c00 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1e14:	00090463          	beqz	s2,1e1c <createdelete+0x186>
    1e18:	fd2bdae3          	bge	s7,s2,1dec <createdelete+0x156>
    1e1c:	fa0548e3          	bltz	a0,1dcc <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1e20:	014b7963          	bgeu	s6,s4,1e32 <createdelete+0x19c>
        close(fd);
    1e24:	00004097          	auipc	ra,0x4
    1e28:	dc4080e7          	jalr	-572(ra) # 5be8 <close>
    1e2c:	b7e1                	j	1df4 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1e2e:	fc0543e3          	bltz	a0,1df4 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1e32:	f8040613          	addi	a2,s0,-128
    1e36:	85e6                	mv	a1,s9
    1e38:	00005517          	auipc	a0,0x5
    1e3c:	dc850513          	addi	a0,a0,-568 # 6c00 <malloc+0xbde>
    1e40:	00004097          	auipc	ra,0x4
    1e44:	12a080e7          	jalr	298(ra) # 5f6a <printf>
        exit(1);
    1e48:	4505                	li	a0,1
    1e4a:	00004097          	auipc	ra,0x4
    1e4e:	d76080e7          	jalr	-650(ra) # 5bc0 <exit>
  for(i = 0; i < N; i++){
    1e52:	2905                	addiw	s2,s2,1
    1e54:	2a05                	addiw	s4,s4,1
    1e56:	2985                	addiw	s3,s3,1
    1e58:	0ff9f993          	zext.b	s3,s3
    1e5c:	47d1                	li	a5,20
    1e5e:	02f90a63          	beq	s2,a5,1e92 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1e62:	84e2                	mv	s1,s8
    1e64:	bf69                	j	1dfe <createdelete+0x168>
  for(i = 0; i < N; i++){
    1e66:	2905                	addiw	s2,s2,1
    1e68:	0ff97913          	zext.b	s2,s2
    1e6c:	2985                	addiw	s3,s3,1
    1e6e:	0ff9f993          	zext.b	s3,s3
    1e72:	03490863          	beq	s2,s4,1ea2 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1e76:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1e78:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1e7c:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1e80:	f8040513          	addi	a0,s0,-128
    1e84:	00004097          	auipc	ra,0x4
    1e88:	d8c080e7          	jalr	-628(ra) # 5c10 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1e8c:	34fd                	addiw	s1,s1,-1
    1e8e:	f4ed                	bnez	s1,1e78 <createdelete+0x1e2>
    1e90:	bfd9                	j	1e66 <createdelete+0x1d0>
    1e92:	03000993          	li	s3,48
    1e96:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1e9a:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1e9c:	08400a13          	li	s4,132
    1ea0:	bfd9                	j	1e76 <createdelete+0x1e0>
}
    1ea2:	60aa                	ld	ra,136(sp)
    1ea4:	640a                	ld	s0,128(sp)
    1ea6:	74e6                	ld	s1,120(sp)
    1ea8:	7946                	ld	s2,112(sp)
    1eaa:	79a6                	ld	s3,104(sp)
    1eac:	7a06                	ld	s4,96(sp)
    1eae:	6ae6                	ld	s5,88(sp)
    1eb0:	6b46                	ld	s6,80(sp)
    1eb2:	6ba6                	ld	s7,72(sp)
    1eb4:	6c06                	ld	s8,64(sp)
    1eb6:	7ce2                	ld	s9,56(sp)
    1eb8:	6149                	addi	sp,sp,144
    1eba:	8082                	ret

0000000000001ebc <linkunlink>:
{
    1ebc:	711d                	addi	sp,sp,-96
    1ebe:	ec86                	sd	ra,88(sp)
    1ec0:	e8a2                	sd	s0,80(sp)
    1ec2:	e4a6                	sd	s1,72(sp)
    1ec4:	e0ca                	sd	s2,64(sp)
    1ec6:	fc4e                	sd	s3,56(sp)
    1ec8:	f852                	sd	s4,48(sp)
    1eca:	f456                	sd	s5,40(sp)
    1ecc:	f05a                	sd	s6,32(sp)
    1ece:	ec5e                	sd	s7,24(sp)
    1ed0:	e862                	sd	s8,16(sp)
    1ed2:	e466                	sd	s9,8(sp)
    1ed4:	1080                	addi	s0,sp,96
    1ed6:	84aa                	mv	s1,a0
  unlink("x");
    1ed8:	00004517          	auipc	a0,0x4
    1edc:	2e050513          	addi	a0,a0,736 # 61b8 <malloc+0x196>
    1ee0:	00004097          	auipc	ra,0x4
    1ee4:	d30080e7          	jalr	-720(ra) # 5c10 <unlink>
  pid = fork();
    1ee8:	00004097          	auipc	ra,0x4
    1eec:	cd0080e7          	jalr	-816(ra) # 5bb8 <fork>
  if(pid < 0){
    1ef0:	02054b63          	bltz	a0,1f26 <linkunlink+0x6a>
    1ef4:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1ef6:	4c85                	li	s9,1
    1ef8:	e119                	bnez	a0,1efe <linkunlink+0x42>
    1efa:	06100c93          	li	s9,97
    1efe:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1f02:	41c659b7          	lui	s3,0x41c65
    1f06:	e6d9899b          	addiw	s3,s3,-403 # 41c64e6d <base+0x41c55215>
    1f0a:	690d                	lui	s2,0x3
    1f0c:	0399091b          	addiw	s2,s2,57 # 3039 <fourteen+0x159>
    if((x % 3) == 0){
    1f10:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1f12:	4b05                	li	s6,1
      unlink("x");
    1f14:	00004a97          	auipc	s5,0x4
    1f18:	2a4a8a93          	addi	s5,s5,676 # 61b8 <malloc+0x196>
      link("cat", "x");
    1f1c:	00005b97          	auipc	s7,0x5
    1f20:	d0cb8b93          	addi	s7,s7,-756 # 6c28 <malloc+0xc06>
    1f24:	a825                	j	1f5c <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1f26:	85a6                	mv	a1,s1
    1f28:	00005517          	auipc	a0,0x5
    1f2c:	aa850513          	addi	a0,a0,-1368 # 69d0 <malloc+0x9ae>
    1f30:	00004097          	auipc	ra,0x4
    1f34:	03a080e7          	jalr	58(ra) # 5f6a <printf>
    exit(1);
    1f38:	4505                	li	a0,1
    1f3a:	00004097          	auipc	ra,0x4
    1f3e:	c86080e7          	jalr	-890(ra) # 5bc0 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1f42:	20200593          	li	a1,514
    1f46:	8556                	mv	a0,s5
    1f48:	00004097          	auipc	ra,0x4
    1f4c:	cb8080e7          	jalr	-840(ra) # 5c00 <open>
    1f50:	00004097          	auipc	ra,0x4
    1f54:	c98080e7          	jalr	-872(ra) # 5be8 <close>
  for(i = 0; i < 100; i++){
    1f58:	34fd                	addiw	s1,s1,-1
    1f5a:	c88d                	beqz	s1,1f8c <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1f5c:	033c87bb          	mulw	a5,s9,s3
    1f60:	012787bb          	addw	a5,a5,s2
    1f64:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1f68:	0347f7bb          	remuw	a5,a5,s4
    1f6c:	dbf9                	beqz	a5,1f42 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1f6e:	01678863          	beq	a5,s6,1f7e <linkunlink+0xc2>
      unlink("x");
    1f72:	8556                	mv	a0,s5
    1f74:	00004097          	auipc	ra,0x4
    1f78:	c9c080e7          	jalr	-868(ra) # 5c10 <unlink>
    1f7c:	bff1                	j	1f58 <linkunlink+0x9c>
      link("cat", "x");
    1f7e:	85d6                	mv	a1,s5
    1f80:	855e                	mv	a0,s7
    1f82:	00004097          	auipc	ra,0x4
    1f86:	c9e080e7          	jalr	-866(ra) # 5c20 <link>
    1f8a:	b7f9                	j	1f58 <linkunlink+0x9c>
  if(pid)
    1f8c:	020c0463          	beqz	s8,1fb4 <linkunlink+0xf8>
    wait(0);
    1f90:	4501                	li	a0,0
    1f92:	00004097          	auipc	ra,0x4
    1f96:	c36080e7          	jalr	-970(ra) # 5bc8 <wait>
}
    1f9a:	60e6                	ld	ra,88(sp)
    1f9c:	6446                	ld	s0,80(sp)
    1f9e:	64a6                	ld	s1,72(sp)
    1fa0:	6906                	ld	s2,64(sp)
    1fa2:	79e2                	ld	s3,56(sp)
    1fa4:	7a42                	ld	s4,48(sp)
    1fa6:	7aa2                	ld	s5,40(sp)
    1fa8:	7b02                	ld	s6,32(sp)
    1faa:	6be2                	ld	s7,24(sp)
    1fac:	6c42                	ld	s8,16(sp)
    1fae:	6ca2                	ld	s9,8(sp)
    1fb0:	6125                	addi	sp,sp,96
    1fb2:	8082                	ret
    exit(0);
    1fb4:	4501                	li	a0,0
    1fb6:	00004097          	auipc	ra,0x4
    1fba:	c0a080e7          	jalr	-1014(ra) # 5bc0 <exit>

0000000000001fbe <forktest>:
{
    1fbe:	7179                	addi	sp,sp,-48
    1fc0:	f406                	sd	ra,40(sp)
    1fc2:	f022                	sd	s0,32(sp)
    1fc4:	ec26                	sd	s1,24(sp)
    1fc6:	e84a                	sd	s2,16(sp)
    1fc8:	e44e                	sd	s3,8(sp)
    1fca:	1800                	addi	s0,sp,48
    1fcc:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1fce:	4481                	li	s1,0
    1fd0:	3e800913          	li	s2,1000
    pid = fork();
    1fd4:	00004097          	auipc	ra,0x4
    1fd8:	be4080e7          	jalr	-1052(ra) # 5bb8 <fork>
    if(pid < 0)
    1fdc:	02054863          	bltz	a0,200c <forktest+0x4e>
    if(pid == 0)
    1fe0:	c115                	beqz	a0,2004 <forktest+0x46>
  for(n=0; n<N; n++){
    1fe2:	2485                	addiw	s1,s1,1
    1fe4:	ff2498e3          	bne	s1,s2,1fd4 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1fe8:	85ce                	mv	a1,s3
    1fea:	00005517          	auipc	a0,0x5
    1fee:	c5e50513          	addi	a0,a0,-930 # 6c48 <malloc+0xc26>
    1ff2:	00004097          	auipc	ra,0x4
    1ff6:	f78080e7          	jalr	-136(ra) # 5f6a <printf>
    exit(1);
    1ffa:	4505                	li	a0,1
    1ffc:	00004097          	auipc	ra,0x4
    2000:	bc4080e7          	jalr	-1084(ra) # 5bc0 <exit>
      exit(0);
    2004:	00004097          	auipc	ra,0x4
    2008:	bbc080e7          	jalr	-1092(ra) # 5bc0 <exit>
  if (n == 0) {
    200c:	cc9d                	beqz	s1,204a <forktest+0x8c>
  if(n == N){
    200e:	3e800793          	li	a5,1000
    2012:	fcf48be3          	beq	s1,a5,1fe8 <forktest+0x2a>
  for(; n > 0; n--){
    2016:	00905b63          	blez	s1,202c <forktest+0x6e>
    if(wait(0) < 0){
    201a:	4501                	li	a0,0
    201c:	00004097          	auipc	ra,0x4
    2020:	bac080e7          	jalr	-1108(ra) # 5bc8 <wait>
    2024:	04054163          	bltz	a0,2066 <forktest+0xa8>
  for(; n > 0; n--){
    2028:	34fd                	addiw	s1,s1,-1
    202a:	f8e5                	bnez	s1,201a <forktest+0x5c>
  if(wait(0) != -1){
    202c:	4501                	li	a0,0
    202e:	00004097          	auipc	ra,0x4
    2032:	b9a080e7          	jalr	-1126(ra) # 5bc8 <wait>
    2036:	57fd                	li	a5,-1
    2038:	04f51563          	bne	a0,a5,2082 <forktest+0xc4>
}
    203c:	70a2                	ld	ra,40(sp)
    203e:	7402                	ld	s0,32(sp)
    2040:	64e2                	ld	s1,24(sp)
    2042:	6942                	ld	s2,16(sp)
    2044:	69a2                	ld	s3,8(sp)
    2046:	6145                	addi	sp,sp,48
    2048:	8082                	ret
    printf("%s: no fork at all!\n", s);
    204a:	85ce                	mv	a1,s3
    204c:	00005517          	auipc	a0,0x5
    2050:	be450513          	addi	a0,a0,-1052 # 6c30 <malloc+0xc0e>
    2054:	00004097          	auipc	ra,0x4
    2058:	f16080e7          	jalr	-234(ra) # 5f6a <printf>
    exit(1);
    205c:	4505                	li	a0,1
    205e:	00004097          	auipc	ra,0x4
    2062:	b62080e7          	jalr	-1182(ra) # 5bc0 <exit>
      printf("%s: wait stopped early\n", s);
    2066:	85ce                	mv	a1,s3
    2068:	00005517          	auipc	a0,0x5
    206c:	c0850513          	addi	a0,a0,-1016 # 6c70 <malloc+0xc4e>
    2070:	00004097          	auipc	ra,0x4
    2074:	efa080e7          	jalr	-262(ra) # 5f6a <printf>
      exit(1);
    2078:	4505                	li	a0,1
    207a:	00004097          	auipc	ra,0x4
    207e:	b46080e7          	jalr	-1210(ra) # 5bc0 <exit>
    printf("%s: wait got too many\n", s);
    2082:	85ce                	mv	a1,s3
    2084:	00005517          	auipc	a0,0x5
    2088:	c0450513          	addi	a0,a0,-1020 # 6c88 <malloc+0xc66>
    208c:	00004097          	auipc	ra,0x4
    2090:	ede080e7          	jalr	-290(ra) # 5f6a <printf>
    exit(1);
    2094:	4505                	li	a0,1
    2096:	00004097          	auipc	ra,0x4
    209a:	b2a080e7          	jalr	-1238(ra) # 5bc0 <exit>

000000000000209e <kernmem>:
{
    209e:	715d                	addi	sp,sp,-80
    20a0:	e486                	sd	ra,72(sp)
    20a2:	e0a2                	sd	s0,64(sp)
    20a4:	fc26                	sd	s1,56(sp)
    20a6:	f84a                	sd	s2,48(sp)
    20a8:	f44e                	sd	s3,40(sp)
    20aa:	f052                	sd	s4,32(sp)
    20ac:	ec56                	sd	s5,24(sp)
    20ae:	0880                	addi	s0,sp,80
    20b0:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20b2:	4485                	li	s1,1
    20b4:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    20b6:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20b8:	69b1                	lui	s3,0xc
    20ba:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1e08>
    20be:	1003d937          	lui	s2,0x1003d
    20c2:	090e                	slli	s2,s2,0x3
    20c4:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d828>
    pid = fork();
    20c8:	00004097          	auipc	ra,0x4
    20cc:	af0080e7          	jalr	-1296(ra) # 5bb8 <fork>
    if(pid < 0){
    20d0:	02054963          	bltz	a0,2102 <kernmem+0x64>
    if(pid == 0){
    20d4:	c529                	beqz	a0,211e <kernmem+0x80>
    wait(&xstatus);
    20d6:	fbc40513          	addi	a0,s0,-68
    20da:	00004097          	auipc	ra,0x4
    20de:	aee080e7          	jalr	-1298(ra) # 5bc8 <wait>
    if(xstatus != -1)  // did kernel kill child?
    20e2:	fbc42783          	lw	a5,-68(s0)
    20e6:	05579d63          	bne	a5,s5,2140 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20ea:	94ce                	add	s1,s1,s3
    20ec:	fd249ee3          	bne	s1,s2,20c8 <kernmem+0x2a>
}
    20f0:	60a6                	ld	ra,72(sp)
    20f2:	6406                	ld	s0,64(sp)
    20f4:	74e2                	ld	s1,56(sp)
    20f6:	7942                	ld	s2,48(sp)
    20f8:	79a2                	ld	s3,40(sp)
    20fa:	7a02                	ld	s4,32(sp)
    20fc:	6ae2                	ld	s5,24(sp)
    20fe:	6161                	addi	sp,sp,80
    2100:	8082                	ret
      printf("%s: fork failed\n", s);
    2102:	85d2                	mv	a1,s4
    2104:	00005517          	auipc	a0,0x5
    2108:	8cc50513          	addi	a0,a0,-1844 # 69d0 <malloc+0x9ae>
    210c:	00004097          	auipc	ra,0x4
    2110:	e5e080e7          	jalr	-418(ra) # 5f6a <printf>
      exit(1);
    2114:	4505                	li	a0,1
    2116:	00004097          	auipc	ra,0x4
    211a:	aaa080e7          	jalr	-1366(ra) # 5bc0 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    211e:	0004c683          	lbu	a3,0(s1)
    2122:	8626                	mv	a2,s1
    2124:	85d2                	mv	a1,s4
    2126:	00005517          	auipc	a0,0x5
    212a:	b7a50513          	addi	a0,a0,-1158 # 6ca0 <malloc+0xc7e>
    212e:	00004097          	auipc	ra,0x4
    2132:	e3c080e7          	jalr	-452(ra) # 5f6a <printf>
      exit(1);
    2136:	4505                	li	a0,1
    2138:	00004097          	auipc	ra,0x4
    213c:	a88080e7          	jalr	-1400(ra) # 5bc0 <exit>
      exit(1);
    2140:	4505                	li	a0,1
    2142:	00004097          	auipc	ra,0x4
    2146:	a7e080e7          	jalr	-1410(ra) # 5bc0 <exit>

000000000000214a <MAXVAplus>:
{
    214a:	7179                	addi	sp,sp,-48
    214c:	f406                	sd	ra,40(sp)
    214e:	f022                	sd	s0,32(sp)
    2150:	ec26                	sd	s1,24(sp)
    2152:	e84a                	sd	s2,16(sp)
    2154:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    2156:	4785                	li	a5,1
    2158:	179a                	slli	a5,a5,0x26
    215a:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    215e:	fd843783          	ld	a5,-40(s0)
    2162:	cf85                	beqz	a5,219a <MAXVAplus+0x50>
    2164:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    2166:	54fd                	li	s1,-1
    pid = fork();
    2168:	00004097          	auipc	ra,0x4
    216c:	a50080e7          	jalr	-1456(ra) # 5bb8 <fork>
    if(pid < 0){
    2170:	02054b63          	bltz	a0,21a6 <MAXVAplus+0x5c>
    if(pid == 0){
    2174:	c539                	beqz	a0,21c2 <MAXVAplus+0x78>
    wait(&xstatus);
    2176:	fd440513          	addi	a0,s0,-44
    217a:	00004097          	auipc	ra,0x4
    217e:	a4e080e7          	jalr	-1458(ra) # 5bc8 <wait>
    if(xstatus != -1)  // did kernel kill child?
    2182:	fd442783          	lw	a5,-44(s0)
    2186:	06979463          	bne	a5,s1,21ee <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    218a:	fd843783          	ld	a5,-40(s0)
    218e:	0786                	slli	a5,a5,0x1
    2190:	fcf43c23          	sd	a5,-40(s0)
    2194:	fd843783          	ld	a5,-40(s0)
    2198:	fbe1                	bnez	a5,2168 <MAXVAplus+0x1e>
}
    219a:	70a2                	ld	ra,40(sp)
    219c:	7402                	ld	s0,32(sp)
    219e:	64e2                	ld	s1,24(sp)
    21a0:	6942                	ld	s2,16(sp)
    21a2:	6145                	addi	sp,sp,48
    21a4:	8082                	ret
      printf("%s: fork failed\n", s);
    21a6:	85ca                	mv	a1,s2
    21a8:	00005517          	auipc	a0,0x5
    21ac:	82850513          	addi	a0,a0,-2008 # 69d0 <malloc+0x9ae>
    21b0:	00004097          	auipc	ra,0x4
    21b4:	dba080e7          	jalr	-582(ra) # 5f6a <printf>
      exit(1);
    21b8:	4505                	li	a0,1
    21ba:	00004097          	auipc	ra,0x4
    21be:	a06080e7          	jalr	-1530(ra) # 5bc0 <exit>
      *(char*)a = 99;
    21c2:	fd843783          	ld	a5,-40(s0)
    21c6:	06300713          	li	a4,99
    21ca:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    21ce:	fd843603          	ld	a2,-40(s0)
    21d2:	85ca                	mv	a1,s2
    21d4:	00005517          	auipc	a0,0x5
    21d8:	aec50513          	addi	a0,a0,-1300 # 6cc0 <malloc+0xc9e>
    21dc:	00004097          	auipc	ra,0x4
    21e0:	d8e080e7          	jalr	-626(ra) # 5f6a <printf>
      exit(1);
    21e4:	4505                	li	a0,1
    21e6:	00004097          	auipc	ra,0x4
    21ea:	9da080e7          	jalr	-1574(ra) # 5bc0 <exit>
      exit(1);
    21ee:	4505                	li	a0,1
    21f0:	00004097          	auipc	ra,0x4
    21f4:	9d0080e7          	jalr	-1584(ra) # 5bc0 <exit>

00000000000021f8 <bigargtest>:
{
    21f8:	7179                	addi	sp,sp,-48
    21fa:	f406                	sd	ra,40(sp)
    21fc:	f022                	sd	s0,32(sp)
    21fe:	ec26                	sd	s1,24(sp)
    2200:	1800                	addi	s0,sp,48
    2202:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2204:	00005517          	auipc	a0,0x5
    2208:	ad450513          	addi	a0,a0,-1324 # 6cd8 <malloc+0xcb6>
    220c:	00004097          	auipc	ra,0x4
    2210:	a04080e7          	jalr	-1532(ra) # 5c10 <unlink>
  pid = fork();
    2214:	00004097          	auipc	ra,0x4
    2218:	9a4080e7          	jalr	-1628(ra) # 5bb8 <fork>
  if(pid == 0){
    221c:	c121                	beqz	a0,225c <bigargtest+0x64>
  } else if(pid < 0){
    221e:	0a054063          	bltz	a0,22be <bigargtest+0xc6>
  wait(&xstatus);
    2222:	fdc40513          	addi	a0,s0,-36
    2226:	00004097          	auipc	ra,0x4
    222a:	9a2080e7          	jalr	-1630(ra) # 5bc8 <wait>
  if(xstatus != 0)
    222e:	fdc42503          	lw	a0,-36(s0)
    2232:	e545                	bnez	a0,22da <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2234:	4581                	li	a1,0
    2236:	00005517          	auipc	a0,0x5
    223a:	aa250513          	addi	a0,a0,-1374 # 6cd8 <malloc+0xcb6>
    223e:	00004097          	auipc	ra,0x4
    2242:	9c2080e7          	jalr	-1598(ra) # 5c00 <open>
  if(fd < 0){
    2246:	08054e63          	bltz	a0,22e2 <bigargtest+0xea>
  close(fd);
    224a:	00004097          	auipc	ra,0x4
    224e:	99e080e7          	jalr	-1634(ra) # 5be8 <close>
}
    2252:	70a2                	ld	ra,40(sp)
    2254:	7402                	ld	s0,32(sp)
    2256:	64e2                	ld	s1,24(sp)
    2258:	6145                	addi	sp,sp,48
    225a:	8082                	ret
    225c:	00007797          	auipc	a5,0x7
    2260:	1e478793          	addi	a5,a5,484 # 9440 <args.1>
    2264:	00007697          	auipc	a3,0x7
    2268:	2d468693          	addi	a3,a3,724 # 9538 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    226c:	00005717          	auipc	a4,0x5
    2270:	a7c70713          	addi	a4,a4,-1412 # 6ce8 <malloc+0xcc6>
    2274:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2276:	07a1                	addi	a5,a5,8
    2278:	fed79ee3          	bne	a5,a3,2274 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    227c:	00007597          	auipc	a1,0x7
    2280:	1c458593          	addi	a1,a1,452 # 9440 <args.1>
    2284:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2288:	00004517          	auipc	a0,0x4
    228c:	ec050513          	addi	a0,a0,-320 # 6148 <malloc+0x126>
    2290:	00004097          	auipc	ra,0x4
    2294:	968080e7          	jalr	-1688(ra) # 5bf8 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2298:	20000593          	li	a1,512
    229c:	00005517          	auipc	a0,0x5
    22a0:	a3c50513          	addi	a0,a0,-1476 # 6cd8 <malloc+0xcb6>
    22a4:	00004097          	auipc	ra,0x4
    22a8:	95c080e7          	jalr	-1700(ra) # 5c00 <open>
    close(fd);
    22ac:	00004097          	auipc	ra,0x4
    22b0:	93c080e7          	jalr	-1732(ra) # 5be8 <close>
    exit(0);
    22b4:	4501                	li	a0,0
    22b6:	00004097          	auipc	ra,0x4
    22ba:	90a080e7          	jalr	-1782(ra) # 5bc0 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    22be:	85a6                	mv	a1,s1
    22c0:	00005517          	auipc	a0,0x5
    22c4:	b0850513          	addi	a0,a0,-1272 # 6dc8 <malloc+0xda6>
    22c8:	00004097          	auipc	ra,0x4
    22cc:	ca2080e7          	jalr	-862(ra) # 5f6a <printf>
    exit(1);
    22d0:	4505                	li	a0,1
    22d2:	00004097          	auipc	ra,0x4
    22d6:	8ee080e7          	jalr	-1810(ra) # 5bc0 <exit>
    exit(xstatus);
    22da:	00004097          	auipc	ra,0x4
    22de:	8e6080e7          	jalr	-1818(ra) # 5bc0 <exit>
    printf("%s: bigarg test failed!\n", s);
    22e2:	85a6                	mv	a1,s1
    22e4:	00005517          	auipc	a0,0x5
    22e8:	b0450513          	addi	a0,a0,-1276 # 6de8 <malloc+0xdc6>
    22ec:	00004097          	auipc	ra,0x4
    22f0:	c7e080e7          	jalr	-898(ra) # 5f6a <printf>
    exit(1);
    22f4:	4505                	li	a0,1
    22f6:	00004097          	auipc	ra,0x4
    22fa:	8ca080e7          	jalr	-1846(ra) # 5bc0 <exit>

00000000000022fe <stacktest>:
{
    22fe:	7179                	addi	sp,sp,-48
    2300:	f406                	sd	ra,40(sp)
    2302:	f022                	sd	s0,32(sp)
    2304:	ec26                	sd	s1,24(sp)
    2306:	1800                	addi	s0,sp,48
    2308:	84aa                	mv	s1,a0
  pid = fork();
    230a:	00004097          	auipc	ra,0x4
    230e:	8ae080e7          	jalr	-1874(ra) # 5bb8 <fork>
  if(pid == 0) {
    2312:	c115                	beqz	a0,2336 <stacktest+0x38>
  } else if(pid < 0){
    2314:	04054463          	bltz	a0,235c <stacktest+0x5e>
  wait(&xstatus);
    2318:	fdc40513          	addi	a0,s0,-36
    231c:	00004097          	auipc	ra,0x4
    2320:	8ac080e7          	jalr	-1876(ra) # 5bc8 <wait>
  if(xstatus == -1)  // kernel killed child?
    2324:	fdc42503          	lw	a0,-36(s0)
    2328:	57fd                	li	a5,-1
    232a:	04f50763          	beq	a0,a5,2378 <stacktest+0x7a>
    exit(xstatus);
    232e:	00004097          	auipc	ra,0x4
    2332:	892080e7          	jalr	-1902(ra) # 5bc0 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp"
    2336:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2338:	77fd                	lui	a5,0xfffff
    233a:	97ba                	add	a5,a5,a4
    233c:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef3a8>
    2340:	85a6                	mv	a1,s1
    2342:	00005517          	auipc	a0,0x5
    2346:	ac650513          	addi	a0,a0,-1338 # 6e08 <malloc+0xde6>
    234a:	00004097          	auipc	ra,0x4
    234e:	c20080e7          	jalr	-992(ra) # 5f6a <printf>
    exit(1);
    2352:	4505                	li	a0,1
    2354:	00004097          	auipc	ra,0x4
    2358:	86c080e7          	jalr	-1940(ra) # 5bc0 <exit>
    printf("%s: fork failed\n", s);
    235c:	85a6                	mv	a1,s1
    235e:	00004517          	auipc	a0,0x4
    2362:	67250513          	addi	a0,a0,1650 # 69d0 <malloc+0x9ae>
    2366:	00004097          	auipc	ra,0x4
    236a:	c04080e7          	jalr	-1020(ra) # 5f6a <printf>
    exit(1);
    236e:	4505                	li	a0,1
    2370:	00004097          	auipc	ra,0x4
    2374:	850080e7          	jalr	-1968(ra) # 5bc0 <exit>
    exit(0);
    2378:	4501                	li	a0,0
    237a:	00004097          	auipc	ra,0x4
    237e:	846080e7          	jalr	-1978(ra) # 5bc0 <exit>

0000000000002382 <manywrites>:
{
    2382:	711d                	addi	sp,sp,-96
    2384:	ec86                	sd	ra,88(sp)
    2386:	e8a2                	sd	s0,80(sp)
    2388:	e4a6                	sd	s1,72(sp)
    238a:	e0ca                	sd	s2,64(sp)
    238c:	fc4e                	sd	s3,56(sp)
    238e:	f852                	sd	s4,48(sp)
    2390:	f456                	sd	s5,40(sp)
    2392:	f05a                	sd	s6,32(sp)
    2394:	ec5e                	sd	s7,24(sp)
    2396:	1080                	addi	s0,sp,96
    2398:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    239a:	4981                	li	s3,0
    239c:	4911                	li	s2,4
    int pid = fork();
    239e:	00004097          	auipc	ra,0x4
    23a2:	81a080e7          	jalr	-2022(ra) # 5bb8 <fork>
    23a6:	84aa                	mv	s1,a0
    if(pid < 0){
    23a8:	02054963          	bltz	a0,23da <manywrites+0x58>
    if(pid == 0){
    23ac:	c521                	beqz	a0,23f4 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    23ae:	2985                	addiw	s3,s3,1
    23b0:	ff2997e3          	bne	s3,s2,239e <manywrites+0x1c>
    23b4:	4491                	li	s1,4
    int st = 0;
    23b6:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    23ba:	fa840513          	addi	a0,s0,-88
    23be:	00004097          	auipc	ra,0x4
    23c2:	80a080e7          	jalr	-2038(ra) # 5bc8 <wait>
    if(st != 0)
    23c6:	fa842503          	lw	a0,-88(s0)
    23ca:	ed6d                	bnez	a0,24c4 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    23cc:	34fd                	addiw	s1,s1,-1
    23ce:	f4e5                	bnez	s1,23b6 <manywrites+0x34>
  exit(0);
    23d0:	4501                	li	a0,0
    23d2:	00003097          	auipc	ra,0x3
    23d6:	7ee080e7          	jalr	2030(ra) # 5bc0 <exit>
      printf("fork failed\n");
    23da:	00005517          	auipc	a0,0x5
    23de:	9fe50513          	addi	a0,a0,-1538 # 6dd8 <malloc+0xdb6>
    23e2:	00004097          	auipc	ra,0x4
    23e6:	b88080e7          	jalr	-1144(ra) # 5f6a <printf>
      exit(1);
    23ea:	4505                	li	a0,1
    23ec:	00003097          	auipc	ra,0x3
    23f0:	7d4080e7          	jalr	2004(ra) # 5bc0 <exit>
      name[0] = 'b';
    23f4:	06200793          	li	a5,98
    23f8:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    23fc:	0619879b          	addiw	a5,s3,97
    2400:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    2404:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    2408:	fa840513          	addi	a0,s0,-88
    240c:	00004097          	auipc	ra,0x4
    2410:	804080e7          	jalr	-2044(ra) # 5c10 <unlink>
    2414:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    2416:	0000bb17          	auipc	s6,0xb
    241a:	842b0b13          	addi	s6,s6,-1982 # cc58 <buf>
        for(int i = 0; i < ci+1; i++){
    241e:	8a26                	mv	s4,s1
    2420:	0209ce63          	bltz	s3,245c <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    2424:	20200593          	li	a1,514
    2428:	fa840513          	addi	a0,s0,-88
    242c:	00003097          	auipc	ra,0x3
    2430:	7d4080e7          	jalr	2004(ra) # 5c00 <open>
    2434:	892a                	mv	s2,a0
          if(fd < 0){
    2436:	04054763          	bltz	a0,2484 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    243a:	660d                	lui	a2,0x3
    243c:	85da                	mv	a1,s6
    243e:	00003097          	auipc	ra,0x3
    2442:	7a2080e7          	jalr	1954(ra) # 5be0 <write>
          if(cc != sz){
    2446:	678d                	lui	a5,0x3
    2448:	04f51e63          	bne	a0,a5,24a4 <manywrites+0x122>
          close(fd);
    244c:	854a                	mv	a0,s2
    244e:	00003097          	auipc	ra,0x3
    2452:	79a080e7          	jalr	1946(ra) # 5be8 <close>
        for(int i = 0; i < ci+1; i++){
    2456:	2a05                	addiw	s4,s4,1
    2458:	fd49d6e3          	bge	s3,s4,2424 <manywrites+0xa2>
        unlink(name);
    245c:	fa840513          	addi	a0,s0,-88
    2460:	00003097          	auipc	ra,0x3
    2464:	7b0080e7          	jalr	1968(ra) # 5c10 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    2468:	3bfd                	addiw	s7,s7,-1
    246a:	fa0b9ae3          	bnez	s7,241e <manywrites+0x9c>
      unlink(name);
    246e:	fa840513          	addi	a0,s0,-88
    2472:	00003097          	auipc	ra,0x3
    2476:	79e080e7          	jalr	1950(ra) # 5c10 <unlink>
      exit(0);
    247a:	4501                	li	a0,0
    247c:	00003097          	auipc	ra,0x3
    2480:	744080e7          	jalr	1860(ra) # 5bc0 <exit>
            printf("%s: cannot create %s\n", s, name);
    2484:	fa840613          	addi	a2,s0,-88
    2488:	85d6                	mv	a1,s5
    248a:	00005517          	auipc	a0,0x5
    248e:	9a650513          	addi	a0,a0,-1626 # 6e30 <malloc+0xe0e>
    2492:	00004097          	auipc	ra,0x4
    2496:	ad8080e7          	jalr	-1320(ra) # 5f6a <printf>
            exit(1);
    249a:	4505                	li	a0,1
    249c:	00003097          	auipc	ra,0x3
    24a0:	724080e7          	jalr	1828(ra) # 5bc0 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    24a4:	86aa                	mv	a3,a0
    24a6:	660d                	lui	a2,0x3
    24a8:	85d6                	mv	a1,s5
    24aa:	00004517          	auipc	a0,0x4
    24ae:	d6e50513          	addi	a0,a0,-658 # 6218 <malloc+0x1f6>
    24b2:	00004097          	auipc	ra,0x4
    24b6:	ab8080e7          	jalr	-1352(ra) # 5f6a <printf>
            exit(1);
    24ba:	4505                	li	a0,1
    24bc:	00003097          	auipc	ra,0x3
    24c0:	704080e7          	jalr	1796(ra) # 5bc0 <exit>
      exit(st);
    24c4:	00003097          	auipc	ra,0x3
    24c8:	6fc080e7          	jalr	1788(ra) # 5bc0 <exit>

00000000000024cc <copyinstr3>:
{
    24cc:	7179                	addi	sp,sp,-48
    24ce:	f406                	sd	ra,40(sp)
    24d0:	f022                	sd	s0,32(sp)
    24d2:	ec26                	sd	s1,24(sp)
    24d4:	1800                	addi	s0,sp,48
  sbrk(8192);
    24d6:	6509                	lui	a0,0x2
    24d8:	00003097          	auipc	ra,0x3
    24dc:	770080e7          	jalr	1904(ra) # 5c48 <sbrk>
  uint64 top = (uint64) sbrk(0);
    24e0:	4501                	li	a0,0
    24e2:	00003097          	auipc	ra,0x3
    24e6:	766080e7          	jalr	1894(ra) # 5c48 <sbrk>
  if((top % PGSIZE) != 0){
    24ea:	03451793          	slli	a5,a0,0x34
    24ee:	e3c9                	bnez	a5,2570 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    24f0:	4501                	li	a0,0
    24f2:	00003097          	auipc	ra,0x3
    24f6:	756080e7          	jalr	1878(ra) # 5c48 <sbrk>
  if(top % PGSIZE){
    24fa:	03451793          	slli	a5,a0,0x34
    24fe:	e3d9                	bnez	a5,2584 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2500:	fff50493          	addi	s1,a0,-1 # 1fff <forktest+0x41>
  *b = 'x';
    2504:	07800793          	li	a5,120
    2508:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    250c:	8526                	mv	a0,s1
    250e:	00003097          	auipc	ra,0x3
    2512:	702080e7          	jalr	1794(ra) # 5c10 <unlink>
  if(ret != -1){
    2516:	57fd                	li	a5,-1
    2518:	08f51363          	bne	a0,a5,259e <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    251c:	20100593          	li	a1,513
    2520:	8526                	mv	a0,s1
    2522:	00003097          	auipc	ra,0x3
    2526:	6de080e7          	jalr	1758(ra) # 5c00 <open>
  if(fd != -1){
    252a:	57fd                	li	a5,-1
    252c:	08f51863          	bne	a0,a5,25bc <copyinstr3+0xf0>
  ret = link(b, b);
    2530:	85a6                	mv	a1,s1
    2532:	8526                	mv	a0,s1
    2534:	00003097          	auipc	ra,0x3
    2538:	6ec080e7          	jalr	1772(ra) # 5c20 <link>
  if(ret != -1){
    253c:	57fd                	li	a5,-1
    253e:	08f51e63          	bne	a0,a5,25da <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2542:	00005797          	auipc	a5,0x5
    2546:	5e678793          	addi	a5,a5,1510 # 7b28 <malloc+0x1b06>
    254a:	fcf43823          	sd	a5,-48(s0)
    254e:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2552:	fd040593          	addi	a1,s0,-48
    2556:	8526                	mv	a0,s1
    2558:	00003097          	auipc	ra,0x3
    255c:	6a0080e7          	jalr	1696(ra) # 5bf8 <exec>
  if(ret != -1){
    2560:	57fd                	li	a5,-1
    2562:	08f51c63          	bne	a0,a5,25fa <copyinstr3+0x12e>
}
    2566:	70a2                	ld	ra,40(sp)
    2568:	7402                	ld	s0,32(sp)
    256a:	64e2                	ld	s1,24(sp)
    256c:	6145                	addi	sp,sp,48
    256e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2570:	0347d513          	srli	a0,a5,0x34
    2574:	6785                	lui	a5,0x1
    2576:	40a7853b          	subw	a0,a5,a0
    257a:	00003097          	auipc	ra,0x3
    257e:	6ce080e7          	jalr	1742(ra) # 5c48 <sbrk>
    2582:	b7bd                	j	24f0 <copyinstr3+0x24>
    printf("oops\n");
    2584:	00005517          	auipc	a0,0x5
    2588:	8c450513          	addi	a0,a0,-1852 # 6e48 <malloc+0xe26>
    258c:	00004097          	auipc	ra,0x4
    2590:	9de080e7          	jalr	-1570(ra) # 5f6a <printf>
    exit(1);
    2594:	4505                	li	a0,1
    2596:	00003097          	auipc	ra,0x3
    259a:	62a080e7          	jalr	1578(ra) # 5bc0 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    259e:	862a                	mv	a2,a0
    25a0:	85a6                	mv	a1,s1
    25a2:	00004517          	auipc	a0,0x4
    25a6:	34e50513          	addi	a0,a0,846 # 68f0 <malloc+0x8ce>
    25aa:	00004097          	auipc	ra,0x4
    25ae:	9c0080e7          	jalr	-1600(ra) # 5f6a <printf>
    exit(1);
    25b2:	4505                	li	a0,1
    25b4:	00003097          	auipc	ra,0x3
    25b8:	60c080e7          	jalr	1548(ra) # 5bc0 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    25bc:	862a                	mv	a2,a0
    25be:	85a6                	mv	a1,s1
    25c0:	00004517          	auipc	a0,0x4
    25c4:	35050513          	addi	a0,a0,848 # 6910 <malloc+0x8ee>
    25c8:	00004097          	auipc	ra,0x4
    25cc:	9a2080e7          	jalr	-1630(ra) # 5f6a <printf>
    exit(1);
    25d0:	4505                	li	a0,1
    25d2:	00003097          	auipc	ra,0x3
    25d6:	5ee080e7          	jalr	1518(ra) # 5bc0 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    25da:	86aa                	mv	a3,a0
    25dc:	8626                	mv	a2,s1
    25de:	85a6                	mv	a1,s1
    25e0:	00004517          	auipc	a0,0x4
    25e4:	35050513          	addi	a0,a0,848 # 6930 <malloc+0x90e>
    25e8:	00004097          	auipc	ra,0x4
    25ec:	982080e7          	jalr	-1662(ra) # 5f6a <printf>
    exit(1);
    25f0:	4505                	li	a0,1
    25f2:	00003097          	auipc	ra,0x3
    25f6:	5ce080e7          	jalr	1486(ra) # 5bc0 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    25fa:	567d                	li	a2,-1
    25fc:	85a6                	mv	a1,s1
    25fe:	00004517          	auipc	a0,0x4
    2602:	35a50513          	addi	a0,a0,858 # 6958 <malloc+0x936>
    2606:	00004097          	auipc	ra,0x4
    260a:	964080e7          	jalr	-1692(ra) # 5f6a <printf>
    exit(1);
    260e:	4505                	li	a0,1
    2610:	00003097          	auipc	ra,0x3
    2614:	5b0080e7          	jalr	1456(ra) # 5bc0 <exit>

0000000000002618 <rwsbrk>:
{
    2618:	1101                	addi	sp,sp,-32
    261a:	ec06                	sd	ra,24(sp)
    261c:	e822                	sd	s0,16(sp)
    261e:	e426                	sd	s1,8(sp)
    2620:	e04a                	sd	s2,0(sp)
    2622:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2624:	6509                	lui	a0,0x2
    2626:	00003097          	auipc	ra,0x3
    262a:	622080e7          	jalr	1570(ra) # 5c48 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    262e:	57fd                	li	a5,-1
    2630:	06f50263          	beq	a0,a5,2694 <rwsbrk+0x7c>
    2634:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2636:	7579                	lui	a0,0xffffe
    2638:	00003097          	auipc	ra,0x3
    263c:	610080e7          	jalr	1552(ra) # 5c48 <sbrk>
    2640:	57fd                	li	a5,-1
    2642:	06f50663          	beq	a0,a5,26ae <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2646:	20100593          	li	a1,513
    264a:	00005517          	auipc	a0,0x5
    264e:	83e50513          	addi	a0,a0,-1986 # 6e88 <malloc+0xe66>
    2652:	00003097          	auipc	ra,0x3
    2656:	5ae080e7          	jalr	1454(ra) # 5c00 <open>
    265a:	892a                	mv	s2,a0
  if(fd < 0){
    265c:	06054663          	bltz	a0,26c8 <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    2660:	6785                	lui	a5,0x1
    2662:	94be                	add	s1,s1,a5
    2664:	40000613          	li	a2,1024
    2668:	85a6                	mv	a1,s1
    266a:	00003097          	auipc	ra,0x3
    266e:	576080e7          	jalr	1398(ra) # 5be0 <write>
    2672:	862a                	mv	a2,a0
  if(n >= 0){
    2674:	06054763          	bltz	a0,26e2 <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    2678:	85a6                	mv	a1,s1
    267a:	00005517          	auipc	a0,0x5
    267e:	82e50513          	addi	a0,a0,-2002 # 6ea8 <malloc+0xe86>
    2682:	00004097          	auipc	ra,0x4
    2686:	8e8080e7          	jalr	-1816(ra) # 5f6a <printf>
    exit(1);
    268a:	4505                	li	a0,1
    268c:	00003097          	auipc	ra,0x3
    2690:	534080e7          	jalr	1332(ra) # 5bc0 <exit>
    printf("sbrk(rwsbrk) failed\n");
    2694:	00004517          	auipc	a0,0x4
    2698:	7bc50513          	addi	a0,a0,1980 # 6e50 <malloc+0xe2e>
    269c:	00004097          	auipc	ra,0x4
    26a0:	8ce080e7          	jalr	-1842(ra) # 5f6a <printf>
    exit(1);
    26a4:	4505                	li	a0,1
    26a6:	00003097          	auipc	ra,0x3
    26aa:	51a080e7          	jalr	1306(ra) # 5bc0 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    26ae:	00004517          	auipc	a0,0x4
    26b2:	7ba50513          	addi	a0,a0,1978 # 6e68 <malloc+0xe46>
    26b6:	00004097          	auipc	ra,0x4
    26ba:	8b4080e7          	jalr	-1868(ra) # 5f6a <printf>
    exit(1);
    26be:	4505                	li	a0,1
    26c0:	00003097          	auipc	ra,0x3
    26c4:	500080e7          	jalr	1280(ra) # 5bc0 <exit>
    printf("open(rwsbrk) failed\n");
    26c8:	00004517          	auipc	a0,0x4
    26cc:	7c850513          	addi	a0,a0,1992 # 6e90 <malloc+0xe6e>
    26d0:	00004097          	auipc	ra,0x4
    26d4:	89a080e7          	jalr	-1894(ra) # 5f6a <printf>
    exit(1);
    26d8:	4505                	li	a0,1
    26da:	00003097          	auipc	ra,0x3
    26de:	4e6080e7          	jalr	1254(ra) # 5bc0 <exit>
  close(fd);
    26e2:	854a                	mv	a0,s2
    26e4:	00003097          	auipc	ra,0x3
    26e8:	504080e7          	jalr	1284(ra) # 5be8 <close>
  unlink("rwsbrk");
    26ec:	00004517          	auipc	a0,0x4
    26f0:	79c50513          	addi	a0,a0,1948 # 6e88 <malloc+0xe66>
    26f4:	00003097          	auipc	ra,0x3
    26f8:	51c080e7          	jalr	1308(ra) # 5c10 <unlink>
  fd = open("README", O_RDONLY);
    26fc:	4581                	li	a1,0
    26fe:	00004517          	auipc	a0,0x4
    2702:	c2250513          	addi	a0,a0,-990 # 6320 <malloc+0x2fe>
    2706:	00003097          	auipc	ra,0x3
    270a:	4fa080e7          	jalr	1274(ra) # 5c00 <open>
    270e:	892a                	mv	s2,a0
  if(fd < 0){
    2710:	02054963          	bltz	a0,2742 <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    2714:	4629                	li	a2,10
    2716:	85a6                	mv	a1,s1
    2718:	00003097          	auipc	ra,0x3
    271c:	4c0080e7          	jalr	1216(ra) # 5bd8 <read>
    2720:	862a                	mv	a2,a0
  if(n >= 0){
    2722:	02054d63          	bltz	a0,275c <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2726:	85a6                	mv	a1,s1
    2728:	00004517          	auipc	a0,0x4
    272c:	7b050513          	addi	a0,a0,1968 # 6ed8 <malloc+0xeb6>
    2730:	00004097          	auipc	ra,0x4
    2734:	83a080e7          	jalr	-1990(ra) # 5f6a <printf>
    exit(1);
    2738:	4505                	li	a0,1
    273a:	00003097          	auipc	ra,0x3
    273e:	486080e7          	jalr	1158(ra) # 5bc0 <exit>
    printf("open(rwsbrk) failed\n");
    2742:	00004517          	auipc	a0,0x4
    2746:	74e50513          	addi	a0,a0,1870 # 6e90 <malloc+0xe6e>
    274a:	00004097          	auipc	ra,0x4
    274e:	820080e7          	jalr	-2016(ra) # 5f6a <printf>
    exit(1);
    2752:	4505                	li	a0,1
    2754:	00003097          	auipc	ra,0x3
    2758:	46c080e7          	jalr	1132(ra) # 5bc0 <exit>
  close(fd);
    275c:	854a                	mv	a0,s2
    275e:	00003097          	auipc	ra,0x3
    2762:	48a080e7          	jalr	1162(ra) # 5be8 <close>
  exit(0);
    2766:	4501                	li	a0,0
    2768:	00003097          	auipc	ra,0x3
    276c:	458080e7          	jalr	1112(ra) # 5bc0 <exit>

0000000000002770 <sbrkbasic>:
{
    2770:	7139                	addi	sp,sp,-64
    2772:	fc06                	sd	ra,56(sp)
    2774:	f822                	sd	s0,48(sp)
    2776:	f426                	sd	s1,40(sp)
    2778:	f04a                	sd	s2,32(sp)
    277a:	ec4e                	sd	s3,24(sp)
    277c:	e852                	sd	s4,16(sp)
    277e:	0080                	addi	s0,sp,64
    2780:	8a2a                	mv	s4,a0
  pid = fork();
    2782:	00003097          	auipc	ra,0x3
    2786:	436080e7          	jalr	1078(ra) # 5bb8 <fork>
  if(pid < 0){
    278a:	02054c63          	bltz	a0,27c2 <sbrkbasic+0x52>
  if(pid == 0){
    278e:	ed21                	bnez	a0,27e6 <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    2790:	40000537          	lui	a0,0x40000
    2794:	00003097          	auipc	ra,0x3
    2798:	4b4080e7          	jalr	1204(ra) # 5c48 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    279c:	57fd                	li	a5,-1
    279e:	02f50f63          	beq	a0,a5,27dc <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    27a2:	400007b7          	lui	a5,0x40000
    27a6:	97aa                	add	a5,a5,a0
      *b = 99;
    27a8:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    27ac:	6705                	lui	a4,0x1
      *b = 99;
    27ae:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff03a8>
    for(b = a; b < a+TOOMUCH; b += 4096){
    27b2:	953a                	add	a0,a0,a4
    27b4:	fef51de3          	bne	a0,a5,27ae <sbrkbasic+0x3e>
    exit(1);
    27b8:	4505                	li	a0,1
    27ba:	00003097          	auipc	ra,0x3
    27be:	406080e7          	jalr	1030(ra) # 5bc0 <exit>
    printf("fork failed in sbrkbasic\n");
    27c2:	00004517          	auipc	a0,0x4
    27c6:	73e50513          	addi	a0,a0,1854 # 6f00 <malloc+0xede>
    27ca:	00003097          	auipc	ra,0x3
    27ce:	7a0080e7          	jalr	1952(ra) # 5f6a <printf>
    exit(1);
    27d2:	4505                	li	a0,1
    27d4:	00003097          	auipc	ra,0x3
    27d8:	3ec080e7          	jalr	1004(ra) # 5bc0 <exit>
      exit(0);
    27dc:	4501                	li	a0,0
    27de:	00003097          	auipc	ra,0x3
    27e2:	3e2080e7          	jalr	994(ra) # 5bc0 <exit>
  wait(&xstatus);
    27e6:	fcc40513          	addi	a0,s0,-52
    27ea:	00003097          	auipc	ra,0x3
    27ee:	3de080e7          	jalr	990(ra) # 5bc8 <wait>
  if(xstatus == 1){
    27f2:	fcc42703          	lw	a4,-52(s0)
    27f6:	4785                	li	a5,1
    27f8:	00f70d63          	beq	a4,a5,2812 <sbrkbasic+0xa2>
  a = sbrk(0);
    27fc:	4501                	li	a0,0
    27fe:	00003097          	auipc	ra,0x3
    2802:	44a080e7          	jalr	1098(ra) # 5c48 <sbrk>
    2806:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2808:	4901                	li	s2,0
    280a:	6985                	lui	s3,0x1
    280c:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0xc8>
    2810:	a005                	j	2830 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    2812:	85d2                	mv	a1,s4
    2814:	00004517          	auipc	a0,0x4
    2818:	70c50513          	addi	a0,a0,1804 # 6f20 <malloc+0xefe>
    281c:	00003097          	auipc	ra,0x3
    2820:	74e080e7          	jalr	1870(ra) # 5f6a <printf>
    exit(1);
    2824:	4505                	li	a0,1
    2826:	00003097          	auipc	ra,0x3
    282a:	39a080e7          	jalr	922(ra) # 5bc0 <exit>
    a = b + 1;
    282e:	84be                	mv	s1,a5
    b = sbrk(1);
    2830:	4505                	li	a0,1
    2832:	00003097          	auipc	ra,0x3
    2836:	416080e7          	jalr	1046(ra) # 5c48 <sbrk>
    if(b != a){
    283a:	04951c63          	bne	a0,s1,2892 <sbrkbasic+0x122>
    *b = 1;
    283e:	4785                	li	a5,1
    2840:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2844:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2848:	2905                	addiw	s2,s2,1
    284a:	ff3912e3          	bne	s2,s3,282e <sbrkbasic+0xbe>
  pid = fork();
    284e:	00003097          	auipc	ra,0x3
    2852:	36a080e7          	jalr	874(ra) # 5bb8 <fork>
    2856:	892a                	mv	s2,a0
  if(pid < 0){
    2858:	04054e63          	bltz	a0,28b4 <sbrkbasic+0x144>
  c = sbrk(1);
    285c:	4505                	li	a0,1
    285e:	00003097          	auipc	ra,0x3
    2862:	3ea080e7          	jalr	1002(ra) # 5c48 <sbrk>
  c = sbrk(1);
    2866:	4505                	li	a0,1
    2868:	00003097          	auipc	ra,0x3
    286c:	3e0080e7          	jalr	992(ra) # 5c48 <sbrk>
  if(c != a + 1){
    2870:	0489                	addi	s1,s1,2
    2872:	04a48f63          	beq	s1,a0,28d0 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    2876:	85d2                	mv	a1,s4
    2878:	00004517          	auipc	a0,0x4
    287c:	70850513          	addi	a0,a0,1800 # 6f80 <malloc+0xf5e>
    2880:	00003097          	auipc	ra,0x3
    2884:	6ea080e7          	jalr	1770(ra) # 5f6a <printf>
    exit(1);
    2888:	4505                	li	a0,1
    288a:	00003097          	auipc	ra,0x3
    288e:	336080e7          	jalr	822(ra) # 5bc0 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2892:	872a                	mv	a4,a0
    2894:	86a6                	mv	a3,s1
    2896:	864a                	mv	a2,s2
    2898:	85d2                	mv	a1,s4
    289a:	00004517          	auipc	a0,0x4
    289e:	6a650513          	addi	a0,a0,1702 # 6f40 <malloc+0xf1e>
    28a2:	00003097          	auipc	ra,0x3
    28a6:	6c8080e7          	jalr	1736(ra) # 5f6a <printf>
      exit(1);
    28aa:	4505                	li	a0,1
    28ac:	00003097          	auipc	ra,0x3
    28b0:	314080e7          	jalr	788(ra) # 5bc0 <exit>
    printf("%s: sbrk test fork failed\n", s);
    28b4:	85d2                	mv	a1,s4
    28b6:	00004517          	auipc	a0,0x4
    28ba:	6aa50513          	addi	a0,a0,1706 # 6f60 <malloc+0xf3e>
    28be:	00003097          	auipc	ra,0x3
    28c2:	6ac080e7          	jalr	1708(ra) # 5f6a <printf>
    exit(1);
    28c6:	4505                	li	a0,1
    28c8:	00003097          	auipc	ra,0x3
    28cc:	2f8080e7          	jalr	760(ra) # 5bc0 <exit>
  if(pid == 0)
    28d0:	00091763          	bnez	s2,28de <sbrkbasic+0x16e>
    exit(0);
    28d4:	4501                	li	a0,0
    28d6:	00003097          	auipc	ra,0x3
    28da:	2ea080e7          	jalr	746(ra) # 5bc0 <exit>
  wait(&xstatus);
    28de:	fcc40513          	addi	a0,s0,-52
    28e2:	00003097          	auipc	ra,0x3
    28e6:	2e6080e7          	jalr	742(ra) # 5bc8 <wait>
  exit(xstatus);
    28ea:	fcc42503          	lw	a0,-52(s0)
    28ee:	00003097          	auipc	ra,0x3
    28f2:	2d2080e7          	jalr	722(ra) # 5bc0 <exit>

00000000000028f6 <sbrkmuch>:
{
    28f6:	7179                	addi	sp,sp,-48
    28f8:	f406                	sd	ra,40(sp)
    28fa:	f022                	sd	s0,32(sp)
    28fc:	ec26                	sd	s1,24(sp)
    28fe:	e84a                	sd	s2,16(sp)
    2900:	e44e                	sd	s3,8(sp)
    2902:	e052                	sd	s4,0(sp)
    2904:	1800                	addi	s0,sp,48
    2906:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2908:	4501                	li	a0,0
    290a:	00003097          	auipc	ra,0x3
    290e:	33e080e7          	jalr	830(ra) # 5c48 <sbrk>
    2912:	892a                	mv	s2,a0
  a = sbrk(0);
    2914:	4501                	li	a0,0
    2916:	00003097          	auipc	ra,0x3
    291a:	332080e7          	jalr	818(ra) # 5c48 <sbrk>
    291e:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2920:	06400537          	lui	a0,0x6400
    2924:	9d05                	subw	a0,a0,s1
    2926:	00003097          	auipc	ra,0x3
    292a:	322080e7          	jalr	802(ra) # 5c48 <sbrk>
  if (p != a) {
    292e:	0ca49863          	bne	s1,a0,29fe <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2932:	4501                	li	a0,0
    2934:	00003097          	auipc	ra,0x3
    2938:	314080e7          	jalr	788(ra) # 5c48 <sbrk>
    293c:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    293e:	00a4f963          	bgeu	s1,a0,2950 <sbrkmuch+0x5a>
    *pp = 1;
    2942:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2944:	6705                	lui	a4,0x1
    *pp = 1;
    2946:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    294a:	94ba                	add	s1,s1,a4
    294c:	fef4ede3          	bltu	s1,a5,2946 <sbrkmuch+0x50>
  *lastaddr = 99;
    2950:	064007b7          	lui	a5,0x6400
    2954:	06300713          	li	a4,99
    2958:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f03a7>
  a = sbrk(0);
    295c:	4501                	li	a0,0
    295e:	00003097          	auipc	ra,0x3
    2962:	2ea080e7          	jalr	746(ra) # 5c48 <sbrk>
    2966:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2968:	757d                	lui	a0,0xfffff
    296a:	00003097          	auipc	ra,0x3
    296e:	2de080e7          	jalr	734(ra) # 5c48 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2972:	57fd                	li	a5,-1
    2974:	0af50363          	beq	a0,a5,2a1a <sbrkmuch+0x124>
  c = sbrk(0);
    2978:	4501                	li	a0,0
    297a:	00003097          	auipc	ra,0x3
    297e:	2ce080e7          	jalr	718(ra) # 5c48 <sbrk>
  if(c != a - PGSIZE){
    2982:	77fd                	lui	a5,0xfffff
    2984:	97a6                	add	a5,a5,s1
    2986:	0af51863          	bne	a0,a5,2a36 <sbrkmuch+0x140>
  a = sbrk(0);
    298a:	4501                	li	a0,0
    298c:	00003097          	auipc	ra,0x3
    2990:	2bc080e7          	jalr	700(ra) # 5c48 <sbrk>
    2994:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2996:	6505                	lui	a0,0x1
    2998:	00003097          	auipc	ra,0x3
    299c:	2b0080e7          	jalr	688(ra) # 5c48 <sbrk>
    29a0:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    29a2:	0aa49a63          	bne	s1,a0,2a56 <sbrkmuch+0x160>
    29a6:	4501                	li	a0,0
    29a8:	00003097          	auipc	ra,0x3
    29ac:	2a0080e7          	jalr	672(ra) # 5c48 <sbrk>
    29b0:	6785                	lui	a5,0x1
    29b2:	97a6                	add	a5,a5,s1
    29b4:	0af51163          	bne	a0,a5,2a56 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    29b8:	064007b7          	lui	a5,0x6400
    29bc:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f03a7>
    29c0:	06300793          	li	a5,99
    29c4:	0af70963          	beq	a4,a5,2a76 <sbrkmuch+0x180>
  a = sbrk(0);
    29c8:	4501                	li	a0,0
    29ca:	00003097          	auipc	ra,0x3
    29ce:	27e080e7          	jalr	638(ra) # 5c48 <sbrk>
    29d2:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    29d4:	4501                	li	a0,0
    29d6:	00003097          	auipc	ra,0x3
    29da:	272080e7          	jalr	626(ra) # 5c48 <sbrk>
    29de:	40a9053b          	subw	a0,s2,a0
    29e2:	00003097          	auipc	ra,0x3
    29e6:	266080e7          	jalr	614(ra) # 5c48 <sbrk>
  if(c != a){
    29ea:	0aa49463          	bne	s1,a0,2a92 <sbrkmuch+0x19c>
}
    29ee:	70a2                	ld	ra,40(sp)
    29f0:	7402                	ld	s0,32(sp)
    29f2:	64e2                	ld	s1,24(sp)
    29f4:	6942                	ld	s2,16(sp)
    29f6:	69a2                	ld	s3,8(sp)
    29f8:	6a02                	ld	s4,0(sp)
    29fa:	6145                	addi	sp,sp,48
    29fc:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    29fe:	85ce                	mv	a1,s3
    2a00:	00004517          	auipc	a0,0x4
    2a04:	5a050513          	addi	a0,a0,1440 # 6fa0 <malloc+0xf7e>
    2a08:	00003097          	auipc	ra,0x3
    2a0c:	562080e7          	jalr	1378(ra) # 5f6a <printf>
    exit(1);
    2a10:	4505                	li	a0,1
    2a12:	00003097          	auipc	ra,0x3
    2a16:	1ae080e7          	jalr	430(ra) # 5bc0 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2a1a:	85ce                	mv	a1,s3
    2a1c:	00004517          	auipc	a0,0x4
    2a20:	5cc50513          	addi	a0,a0,1484 # 6fe8 <malloc+0xfc6>
    2a24:	00003097          	auipc	ra,0x3
    2a28:	546080e7          	jalr	1350(ra) # 5f6a <printf>
    exit(1);
    2a2c:	4505                	li	a0,1
    2a2e:	00003097          	auipc	ra,0x3
    2a32:	192080e7          	jalr	402(ra) # 5bc0 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2a36:	86aa                	mv	a3,a0
    2a38:	8626                	mv	a2,s1
    2a3a:	85ce                	mv	a1,s3
    2a3c:	00004517          	auipc	a0,0x4
    2a40:	5cc50513          	addi	a0,a0,1484 # 7008 <malloc+0xfe6>
    2a44:	00003097          	auipc	ra,0x3
    2a48:	526080e7          	jalr	1318(ra) # 5f6a <printf>
    exit(1);
    2a4c:	4505                	li	a0,1
    2a4e:	00003097          	auipc	ra,0x3
    2a52:	172080e7          	jalr	370(ra) # 5bc0 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2a56:	86d2                	mv	a3,s4
    2a58:	8626                	mv	a2,s1
    2a5a:	85ce                	mv	a1,s3
    2a5c:	00004517          	auipc	a0,0x4
    2a60:	5ec50513          	addi	a0,a0,1516 # 7048 <malloc+0x1026>
    2a64:	00003097          	auipc	ra,0x3
    2a68:	506080e7          	jalr	1286(ra) # 5f6a <printf>
    exit(1);
    2a6c:	4505                	li	a0,1
    2a6e:	00003097          	auipc	ra,0x3
    2a72:	152080e7          	jalr	338(ra) # 5bc0 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2a76:	85ce                	mv	a1,s3
    2a78:	00004517          	auipc	a0,0x4
    2a7c:	60050513          	addi	a0,a0,1536 # 7078 <malloc+0x1056>
    2a80:	00003097          	auipc	ra,0x3
    2a84:	4ea080e7          	jalr	1258(ra) # 5f6a <printf>
    exit(1);
    2a88:	4505                	li	a0,1
    2a8a:	00003097          	auipc	ra,0x3
    2a8e:	136080e7          	jalr	310(ra) # 5bc0 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2a92:	86aa                	mv	a3,a0
    2a94:	8626                	mv	a2,s1
    2a96:	85ce                	mv	a1,s3
    2a98:	00004517          	auipc	a0,0x4
    2a9c:	61850513          	addi	a0,a0,1560 # 70b0 <malloc+0x108e>
    2aa0:	00003097          	auipc	ra,0x3
    2aa4:	4ca080e7          	jalr	1226(ra) # 5f6a <printf>
    exit(1);
    2aa8:	4505                	li	a0,1
    2aaa:	00003097          	auipc	ra,0x3
    2aae:	116080e7          	jalr	278(ra) # 5bc0 <exit>

0000000000002ab2 <sbrkarg>:
{
    2ab2:	7179                	addi	sp,sp,-48
    2ab4:	f406                	sd	ra,40(sp)
    2ab6:	f022                	sd	s0,32(sp)
    2ab8:	ec26                	sd	s1,24(sp)
    2aba:	e84a                	sd	s2,16(sp)
    2abc:	e44e                	sd	s3,8(sp)
    2abe:	1800                	addi	s0,sp,48
    2ac0:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2ac2:	6505                	lui	a0,0x1
    2ac4:	00003097          	auipc	ra,0x3
    2ac8:	184080e7          	jalr	388(ra) # 5c48 <sbrk>
    2acc:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2ace:	20100593          	li	a1,513
    2ad2:	00004517          	auipc	a0,0x4
    2ad6:	60650513          	addi	a0,a0,1542 # 70d8 <malloc+0x10b6>
    2ada:	00003097          	auipc	ra,0x3
    2ade:	126080e7          	jalr	294(ra) # 5c00 <open>
    2ae2:	84aa                	mv	s1,a0
  unlink("sbrk");
    2ae4:	00004517          	auipc	a0,0x4
    2ae8:	5f450513          	addi	a0,a0,1524 # 70d8 <malloc+0x10b6>
    2aec:	00003097          	auipc	ra,0x3
    2af0:	124080e7          	jalr	292(ra) # 5c10 <unlink>
  if(fd < 0)  {
    2af4:	0404c163          	bltz	s1,2b36 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2af8:	6605                	lui	a2,0x1
    2afa:	85ca                	mv	a1,s2
    2afc:	8526                	mv	a0,s1
    2afe:	00003097          	auipc	ra,0x3
    2b02:	0e2080e7          	jalr	226(ra) # 5be0 <write>
    2b06:	04054663          	bltz	a0,2b52 <sbrkarg+0xa0>
  close(fd);
    2b0a:	8526                	mv	a0,s1
    2b0c:	00003097          	auipc	ra,0x3
    2b10:	0dc080e7          	jalr	220(ra) # 5be8 <close>
  a = sbrk(PGSIZE);
    2b14:	6505                	lui	a0,0x1
    2b16:	00003097          	auipc	ra,0x3
    2b1a:	132080e7          	jalr	306(ra) # 5c48 <sbrk>
  if(pipe((int *) a) != 0){
    2b1e:	00003097          	auipc	ra,0x3
    2b22:	0b2080e7          	jalr	178(ra) # 5bd0 <pipe>
    2b26:	e521                	bnez	a0,2b6e <sbrkarg+0xbc>
}
    2b28:	70a2                	ld	ra,40(sp)
    2b2a:	7402                	ld	s0,32(sp)
    2b2c:	64e2                	ld	s1,24(sp)
    2b2e:	6942                	ld	s2,16(sp)
    2b30:	69a2                	ld	s3,8(sp)
    2b32:	6145                	addi	sp,sp,48
    2b34:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2b36:	85ce                	mv	a1,s3
    2b38:	00004517          	auipc	a0,0x4
    2b3c:	5a850513          	addi	a0,a0,1448 # 70e0 <malloc+0x10be>
    2b40:	00003097          	auipc	ra,0x3
    2b44:	42a080e7          	jalr	1066(ra) # 5f6a <printf>
    exit(1);
    2b48:	4505                	li	a0,1
    2b4a:	00003097          	auipc	ra,0x3
    2b4e:	076080e7          	jalr	118(ra) # 5bc0 <exit>
    printf("%s: write sbrk failed\n", s);
    2b52:	85ce                	mv	a1,s3
    2b54:	00004517          	auipc	a0,0x4
    2b58:	5a450513          	addi	a0,a0,1444 # 70f8 <malloc+0x10d6>
    2b5c:	00003097          	auipc	ra,0x3
    2b60:	40e080e7          	jalr	1038(ra) # 5f6a <printf>
    exit(1);
    2b64:	4505                	li	a0,1
    2b66:	00003097          	auipc	ra,0x3
    2b6a:	05a080e7          	jalr	90(ra) # 5bc0 <exit>
    printf("%s: pipe() failed\n", s);
    2b6e:	85ce                	mv	a1,s3
    2b70:	00004517          	auipc	a0,0x4
    2b74:	f6850513          	addi	a0,a0,-152 # 6ad8 <malloc+0xab6>
    2b78:	00003097          	auipc	ra,0x3
    2b7c:	3f2080e7          	jalr	1010(ra) # 5f6a <printf>
    exit(1);
    2b80:	4505                	li	a0,1
    2b82:	00003097          	auipc	ra,0x3
    2b86:	03e080e7          	jalr	62(ra) # 5bc0 <exit>

0000000000002b8a <argptest>:
{
    2b8a:	1101                	addi	sp,sp,-32
    2b8c:	ec06                	sd	ra,24(sp)
    2b8e:	e822                	sd	s0,16(sp)
    2b90:	e426                	sd	s1,8(sp)
    2b92:	e04a                	sd	s2,0(sp)
    2b94:	1000                	addi	s0,sp,32
    2b96:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2b98:	4581                	li	a1,0
    2b9a:	00004517          	auipc	a0,0x4
    2b9e:	57650513          	addi	a0,a0,1398 # 7110 <malloc+0x10ee>
    2ba2:	00003097          	auipc	ra,0x3
    2ba6:	05e080e7          	jalr	94(ra) # 5c00 <open>
  if (fd < 0) {
    2baa:	02054b63          	bltz	a0,2be0 <argptest+0x56>
    2bae:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2bb0:	4501                	li	a0,0
    2bb2:	00003097          	auipc	ra,0x3
    2bb6:	096080e7          	jalr	150(ra) # 5c48 <sbrk>
    2bba:	567d                	li	a2,-1
    2bbc:	fff50593          	addi	a1,a0,-1
    2bc0:	8526                	mv	a0,s1
    2bc2:	00003097          	auipc	ra,0x3
    2bc6:	016080e7          	jalr	22(ra) # 5bd8 <read>
  close(fd);
    2bca:	8526                	mv	a0,s1
    2bcc:	00003097          	auipc	ra,0x3
    2bd0:	01c080e7          	jalr	28(ra) # 5be8 <close>
}
    2bd4:	60e2                	ld	ra,24(sp)
    2bd6:	6442                	ld	s0,16(sp)
    2bd8:	64a2                	ld	s1,8(sp)
    2bda:	6902                	ld	s2,0(sp)
    2bdc:	6105                	addi	sp,sp,32
    2bde:	8082                	ret
    printf("%s: open failed\n", s);
    2be0:	85ca                	mv	a1,s2
    2be2:	00004517          	auipc	a0,0x4
    2be6:	e0650513          	addi	a0,a0,-506 # 69e8 <malloc+0x9c6>
    2bea:	00003097          	auipc	ra,0x3
    2bee:	380080e7          	jalr	896(ra) # 5f6a <printf>
    exit(1);
    2bf2:	4505                	li	a0,1
    2bf4:	00003097          	auipc	ra,0x3
    2bf8:	fcc080e7          	jalr	-52(ra) # 5bc0 <exit>

0000000000002bfc <sbrkbugs>:
{
    2bfc:	1141                	addi	sp,sp,-16
    2bfe:	e406                	sd	ra,8(sp)
    2c00:	e022                	sd	s0,0(sp)
    2c02:	0800                	addi	s0,sp,16
  int pid = fork();
    2c04:	00003097          	auipc	ra,0x3
    2c08:	fb4080e7          	jalr	-76(ra) # 5bb8 <fork>
  if(pid < 0){
    2c0c:	02054263          	bltz	a0,2c30 <sbrkbugs+0x34>
  if(pid == 0){
    2c10:	ed0d                	bnez	a0,2c4a <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2c12:	00003097          	auipc	ra,0x3
    2c16:	036080e7          	jalr	54(ra) # 5c48 <sbrk>
    sbrk(-sz);
    2c1a:	40a0053b          	negw	a0,a0
    2c1e:	00003097          	auipc	ra,0x3
    2c22:	02a080e7          	jalr	42(ra) # 5c48 <sbrk>
    exit(0);
    2c26:	4501                	li	a0,0
    2c28:	00003097          	auipc	ra,0x3
    2c2c:	f98080e7          	jalr	-104(ra) # 5bc0 <exit>
    printf("fork failed\n");
    2c30:	00004517          	auipc	a0,0x4
    2c34:	1a850513          	addi	a0,a0,424 # 6dd8 <malloc+0xdb6>
    2c38:	00003097          	auipc	ra,0x3
    2c3c:	332080e7          	jalr	818(ra) # 5f6a <printf>
    exit(1);
    2c40:	4505                	li	a0,1
    2c42:	00003097          	auipc	ra,0x3
    2c46:	f7e080e7          	jalr	-130(ra) # 5bc0 <exit>
  wait(0);
    2c4a:	4501                	li	a0,0
    2c4c:	00003097          	auipc	ra,0x3
    2c50:	f7c080e7          	jalr	-132(ra) # 5bc8 <wait>
  pid = fork();
    2c54:	00003097          	auipc	ra,0x3
    2c58:	f64080e7          	jalr	-156(ra) # 5bb8 <fork>
  if(pid < 0){
    2c5c:	02054563          	bltz	a0,2c86 <sbrkbugs+0x8a>
  if(pid == 0){
    2c60:	e121                	bnez	a0,2ca0 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2c62:	00003097          	auipc	ra,0x3
    2c66:	fe6080e7          	jalr	-26(ra) # 5c48 <sbrk>
    sbrk(-(sz - 3500));
    2c6a:	6785                	lui	a5,0x1
    2c6c:	dac7879b          	addiw	a5,a5,-596 # dac <unlinkread+0x13e>
    2c70:	40a7853b          	subw	a0,a5,a0
    2c74:	00003097          	auipc	ra,0x3
    2c78:	fd4080e7          	jalr	-44(ra) # 5c48 <sbrk>
    exit(0);
    2c7c:	4501                	li	a0,0
    2c7e:	00003097          	auipc	ra,0x3
    2c82:	f42080e7          	jalr	-190(ra) # 5bc0 <exit>
    printf("fork failed\n");
    2c86:	00004517          	auipc	a0,0x4
    2c8a:	15250513          	addi	a0,a0,338 # 6dd8 <malloc+0xdb6>
    2c8e:	00003097          	auipc	ra,0x3
    2c92:	2dc080e7          	jalr	732(ra) # 5f6a <printf>
    exit(1);
    2c96:	4505                	li	a0,1
    2c98:	00003097          	auipc	ra,0x3
    2c9c:	f28080e7          	jalr	-216(ra) # 5bc0 <exit>
  wait(0);
    2ca0:	4501                	li	a0,0
    2ca2:	00003097          	auipc	ra,0x3
    2ca6:	f26080e7          	jalr	-218(ra) # 5bc8 <wait>
  pid = fork();
    2caa:	00003097          	auipc	ra,0x3
    2cae:	f0e080e7          	jalr	-242(ra) # 5bb8 <fork>
  if(pid < 0){
    2cb2:	02054a63          	bltz	a0,2ce6 <sbrkbugs+0xea>
  if(pid == 0){
    2cb6:	e529                	bnez	a0,2d00 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2cb8:	00003097          	auipc	ra,0x3
    2cbc:	f90080e7          	jalr	-112(ra) # 5c48 <sbrk>
    2cc0:	67ad                	lui	a5,0xb
    2cc2:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x2b8>
    2cc6:	40a7853b          	subw	a0,a5,a0
    2cca:	00003097          	auipc	ra,0x3
    2cce:	f7e080e7          	jalr	-130(ra) # 5c48 <sbrk>
    sbrk(-10);
    2cd2:	5559                	li	a0,-10
    2cd4:	00003097          	auipc	ra,0x3
    2cd8:	f74080e7          	jalr	-140(ra) # 5c48 <sbrk>
    exit(0);
    2cdc:	4501                	li	a0,0
    2cde:	00003097          	auipc	ra,0x3
    2ce2:	ee2080e7          	jalr	-286(ra) # 5bc0 <exit>
    printf("fork failed\n");
    2ce6:	00004517          	auipc	a0,0x4
    2cea:	0f250513          	addi	a0,a0,242 # 6dd8 <malloc+0xdb6>
    2cee:	00003097          	auipc	ra,0x3
    2cf2:	27c080e7          	jalr	636(ra) # 5f6a <printf>
    exit(1);
    2cf6:	4505                	li	a0,1
    2cf8:	00003097          	auipc	ra,0x3
    2cfc:	ec8080e7          	jalr	-312(ra) # 5bc0 <exit>
  wait(0);
    2d00:	4501                	li	a0,0
    2d02:	00003097          	auipc	ra,0x3
    2d06:	ec6080e7          	jalr	-314(ra) # 5bc8 <wait>
  exit(0);
    2d0a:	4501                	li	a0,0
    2d0c:	00003097          	auipc	ra,0x3
    2d10:	eb4080e7          	jalr	-332(ra) # 5bc0 <exit>

0000000000002d14 <sbrklast>:
{
    2d14:	7179                	addi	sp,sp,-48
    2d16:	f406                	sd	ra,40(sp)
    2d18:	f022                	sd	s0,32(sp)
    2d1a:	ec26                	sd	s1,24(sp)
    2d1c:	e84a                	sd	s2,16(sp)
    2d1e:	e44e                	sd	s3,8(sp)
    2d20:	e052                	sd	s4,0(sp)
    2d22:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2d24:	4501                	li	a0,0
    2d26:	00003097          	auipc	ra,0x3
    2d2a:	f22080e7          	jalr	-222(ra) # 5c48 <sbrk>
  if((top % 4096) != 0)
    2d2e:	03451793          	slli	a5,a0,0x34
    2d32:	ebd9                	bnez	a5,2dc8 <sbrklast+0xb4>
  sbrk(4096);
    2d34:	6505                	lui	a0,0x1
    2d36:	00003097          	auipc	ra,0x3
    2d3a:	f12080e7          	jalr	-238(ra) # 5c48 <sbrk>
  sbrk(10);
    2d3e:	4529                	li	a0,10
    2d40:	00003097          	auipc	ra,0x3
    2d44:	f08080e7          	jalr	-248(ra) # 5c48 <sbrk>
  sbrk(-20);
    2d48:	5531                	li	a0,-20
    2d4a:	00003097          	auipc	ra,0x3
    2d4e:	efe080e7          	jalr	-258(ra) # 5c48 <sbrk>
  top = (uint64) sbrk(0);
    2d52:	4501                	li	a0,0
    2d54:	00003097          	auipc	ra,0x3
    2d58:	ef4080e7          	jalr	-268(ra) # 5c48 <sbrk>
    2d5c:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2d5e:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0x19c>
  p[0] = 'x';
    2d62:	07800a13          	li	s4,120
    2d66:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2d6a:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2d6e:	20200593          	li	a1,514
    2d72:	854a                	mv	a0,s2
    2d74:	00003097          	auipc	ra,0x3
    2d78:	e8c080e7          	jalr	-372(ra) # 5c00 <open>
    2d7c:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2d7e:	4605                	li	a2,1
    2d80:	85ca                	mv	a1,s2
    2d82:	00003097          	auipc	ra,0x3
    2d86:	e5e080e7          	jalr	-418(ra) # 5be0 <write>
  close(fd);
    2d8a:	854e                	mv	a0,s3
    2d8c:	00003097          	auipc	ra,0x3
    2d90:	e5c080e7          	jalr	-420(ra) # 5be8 <close>
  fd = open(p, O_RDWR);
    2d94:	4589                	li	a1,2
    2d96:	854a                	mv	a0,s2
    2d98:	00003097          	auipc	ra,0x3
    2d9c:	e68080e7          	jalr	-408(ra) # 5c00 <open>
  p[0] = '\0';
    2da0:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2da4:	4605                	li	a2,1
    2da6:	85ca                	mv	a1,s2
    2da8:	00003097          	auipc	ra,0x3
    2dac:	e30080e7          	jalr	-464(ra) # 5bd8 <read>
  if(p[0] != 'x')
    2db0:	fc04c783          	lbu	a5,-64(s1)
    2db4:	03479463          	bne	a5,s4,2ddc <sbrklast+0xc8>
}
    2db8:	70a2                	ld	ra,40(sp)
    2dba:	7402                	ld	s0,32(sp)
    2dbc:	64e2                	ld	s1,24(sp)
    2dbe:	6942                	ld	s2,16(sp)
    2dc0:	69a2                	ld	s3,8(sp)
    2dc2:	6a02                	ld	s4,0(sp)
    2dc4:	6145                	addi	sp,sp,48
    2dc6:	8082                	ret
    sbrk(4096 - (top % 4096));
    2dc8:	0347d513          	srli	a0,a5,0x34
    2dcc:	6785                	lui	a5,0x1
    2dce:	40a7853b          	subw	a0,a5,a0
    2dd2:	00003097          	auipc	ra,0x3
    2dd6:	e76080e7          	jalr	-394(ra) # 5c48 <sbrk>
    2dda:	bfa9                	j	2d34 <sbrklast+0x20>
    exit(1);
    2ddc:	4505                	li	a0,1
    2dde:	00003097          	auipc	ra,0x3
    2de2:	de2080e7          	jalr	-542(ra) # 5bc0 <exit>

0000000000002de6 <sbrk8000>:
{
    2de6:	1141                	addi	sp,sp,-16
    2de8:	e406                	sd	ra,8(sp)
    2dea:	e022                	sd	s0,0(sp)
    2dec:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2dee:	80000537          	lui	a0,0x80000
    2df2:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff03ac>
    2df4:	00003097          	auipc	ra,0x3
    2df8:	e54080e7          	jalr	-428(ra) # 5c48 <sbrk>
  volatile char *top = sbrk(0);
    2dfc:	4501                	li	a0,0
    2dfe:	00003097          	auipc	ra,0x3
    2e02:	e4a080e7          	jalr	-438(ra) # 5c48 <sbrk>
  *(top-1) = *(top-1) + 1;
    2e06:	fff54783          	lbu	a5,-1(a0)
    2e0a:	2785                	addiw	a5,a5,1 # 1001 <linktest+0x1dd>
    2e0c:	0ff7f793          	zext.b	a5,a5
    2e10:	fef50fa3          	sb	a5,-1(a0)
}
    2e14:	60a2                	ld	ra,8(sp)
    2e16:	6402                	ld	s0,0(sp)
    2e18:	0141                	addi	sp,sp,16
    2e1a:	8082                	ret

0000000000002e1c <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2e1c:	715d                	addi	sp,sp,-80
    2e1e:	e486                	sd	ra,72(sp)
    2e20:	e0a2                	sd	s0,64(sp)
    2e22:	fc26                	sd	s1,56(sp)
    2e24:	f84a                	sd	s2,48(sp)
    2e26:	f44e                	sd	s3,40(sp)
    2e28:	f052                	sd	s4,32(sp)
    2e2a:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2e2c:	4901                	li	s2,0
    2e2e:	49bd                	li	s3,15
    int pid = fork();
    2e30:	00003097          	auipc	ra,0x3
    2e34:	d88080e7          	jalr	-632(ra) # 5bb8 <fork>
    2e38:	84aa                	mv	s1,a0
    if(pid < 0){
    2e3a:	02054063          	bltz	a0,2e5a <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2e3e:	c91d                	beqz	a0,2e74 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2e40:	4501                	li	a0,0
    2e42:	00003097          	auipc	ra,0x3
    2e46:	d86080e7          	jalr	-634(ra) # 5bc8 <wait>
  for(int avail = 0; avail < 15; avail++){
    2e4a:	2905                	addiw	s2,s2,1
    2e4c:	ff3912e3          	bne	s2,s3,2e30 <execout+0x14>
    }
  }

  exit(0);
    2e50:	4501                	li	a0,0
    2e52:	00003097          	auipc	ra,0x3
    2e56:	d6e080e7          	jalr	-658(ra) # 5bc0 <exit>
      printf("fork failed\n");
    2e5a:	00004517          	auipc	a0,0x4
    2e5e:	f7e50513          	addi	a0,a0,-130 # 6dd8 <malloc+0xdb6>
    2e62:	00003097          	auipc	ra,0x3
    2e66:	108080e7          	jalr	264(ra) # 5f6a <printf>
      exit(1);
    2e6a:	4505                	li	a0,1
    2e6c:	00003097          	auipc	ra,0x3
    2e70:	d54080e7          	jalr	-684(ra) # 5bc0 <exit>
        if(a == 0xffffffffffffffffLL)
    2e74:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2e76:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2e78:	6505                	lui	a0,0x1
    2e7a:	00003097          	auipc	ra,0x3
    2e7e:	dce080e7          	jalr	-562(ra) # 5c48 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2e82:	01350763          	beq	a0,s3,2e90 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2e86:	6785                	lui	a5,0x1
    2e88:	97aa                	add	a5,a5,a0
    2e8a:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0x1db>
      while(1){
    2e8e:	b7ed                	j	2e78 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2e90:	01205a63          	blez	s2,2ea4 <execout+0x88>
        sbrk(-4096);
    2e94:	757d                	lui	a0,0xfffff
    2e96:	00003097          	auipc	ra,0x3
    2e9a:	db2080e7          	jalr	-590(ra) # 5c48 <sbrk>
      for(int i = 0; i < avail; i++)
    2e9e:	2485                	addiw	s1,s1,1
    2ea0:	ff249ae3          	bne	s1,s2,2e94 <execout+0x78>
      close(1);
    2ea4:	4505                	li	a0,1
    2ea6:	00003097          	auipc	ra,0x3
    2eaa:	d42080e7          	jalr	-702(ra) # 5be8 <close>
      char *args[] = { "echo", "x", 0 };
    2eae:	00003517          	auipc	a0,0x3
    2eb2:	29a50513          	addi	a0,a0,666 # 6148 <malloc+0x126>
    2eb6:	faa43c23          	sd	a0,-72(s0)
    2eba:	00003797          	auipc	a5,0x3
    2ebe:	2fe78793          	addi	a5,a5,766 # 61b8 <malloc+0x196>
    2ec2:	fcf43023          	sd	a5,-64(s0)
    2ec6:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2eca:	fb840593          	addi	a1,s0,-72
    2ece:	00003097          	auipc	ra,0x3
    2ed2:	d2a080e7          	jalr	-726(ra) # 5bf8 <exec>
      exit(0);
    2ed6:	4501                	li	a0,0
    2ed8:	00003097          	auipc	ra,0x3
    2edc:	ce8080e7          	jalr	-792(ra) # 5bc0 <exit>

0000000000002ee0 <fourteen>:
{
    2ee0:	1101                	addi	sp,sp,-32
    2ee2:	ec06                	sd	ra,24(sp)
    2ee4:	e822                	sd	s0,16(sp)
    2ee6:	e426                	sd	s1,8(sp)
    2ee8:	1000                	addi	s0,sp,32
    2eea:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2eec:	00004517          	auipc	a0,0x4
    2ef0:	3fc50513          	addi	a0,a0,1020 # 72e8 <malloc+0x12c6>
    2ef4:	00003097          	auipc	ra,0x3
    2ef8:	d34080e7          	jalr	-716(ra) # 5c28 <mkdir>
    2efc:	e165                	bnez	a0,2fdc <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2efe:	00004517          	auipc	a0,0x4
    2f02:	24250513          	addi	a0,a0,578 # 7140 <malloc+0x111e>
    2f06:	00003097          	auipc	ra,0x3
    2f0a:	d22080e7          	jalr	-734(ra) # 5c28 <mkdir>
    2f0e:	e56d                	bnez	a0,2ff8 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2f10:	20000593          	li	a1,512
    2f14:	00004517          	auipc	a0,0x4
    2f18:	28450513          	addi	a0,a0,644 # 7198 <malloc+0x1176>
    2f1c:	00003097          	auipc	ra,0x3
    2f20:	ce4080e7          	jalr	-796(ra) # 5c00 <open>
  if(fd < 0){
    2f24:	0e054863          	bltz	a0,3014 <fourteen+0x134>
  close(fd);
    2f28:	00003097          	auipc	ra,0x3
    2f2c:	cc0080e7          	jalr	-832(ra) # 5be8 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2f30:	4581                	li	a1,0
    2f32:	00004517          	auipc	a0,0x4
    2f36:	2de50513          	addi	a0,a0,734 # 7210 <malloc+0x11ee>
    2f3a:	00003097          	auipc	ra,0x3
    2f3e:	cc6080e7          	jalr	-826(ra) # 5c00 <open>
  if(fd < 0){
    2f42:	0e054763          	bltz	a0,3030 <fourteen+0x150>
  close(fd);
    2f46:	00003097          	auipc	ra,0x3
    2f4a:	ca2080e7          	jalr	-862(ra) # 5be8 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2f4e:	00004517          	auipc	a0,0x4
    2f52:	33250513          	addi	a0,a0,818 # 7280 <malloc+0x125e>
    2f56:	00003097          	auipc	ra,0x3
    2f5a:	cd2080e7          	jalr	-814(ra) # 5c28 <mkdir>
    2f5e:	c57d                	beqz	a0,304c <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2f60:	00004517          	auipc	a0,0x4
    2f64:	37850513          	addi	a0,a0,888 # 72d8 <malloc+0x12b6>
    2f68:	00003097          	auipc	ra,0x3
    2f6c:	cc0080e7          	jalr	-832(ra) # 5c28 <mkdir>
    2f70:	cd65                	beqz	a0,3068 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2f72:	00004517          	auipc	a0,0x4
    2f76:	36650513          	addi	a0,a0,870 # 72d8 <malloc+0x12b6>
    2f7a:	00003097          	auipc	ra,0x3
    2f7e:	c96080e7          	jalr	-874(ra) # 5c10 <unlink>
  unlink("12345678901234/12345678901234");
    2f82:	00004517          	auipc	a0,0x4
    2f86:	2fe50513          	addi	a0,a0,766 # 7280 <malloc+0x125e>
    2f8a:	00003097          	auipc	ra,0x3
    2f8e:	c86080e7          	jalr	-890(ra) # 5c10 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2f92:	00004517          	auipc	a0,0x4
    2f96:	27e50513          	addi	a0,a0,638 # 7210 <malloc+0x11ee>
    2f9a:	00003097          	auipc	ra,0x3
    2f9e:	c76080e7          	jalr	-906(ra) # 5c10 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2fa2:	00004517          	auipc	a0,0x4
    2fa6:	1f650513          	addi	a0,a0,502 # 7198 <malloc+0x1176>
    2faa:	00003097          	auipc	ra,0x3
    2fae:	c66080e7          	jalr	-922(ra) # 5c10 <unlink>
  unlink("12345678901234/123456789012345");
    2fb2:	00004517          	auipc	a0,0x4
    2fb6:	18e50513          	addi	a0,a0,398 # 7140 <malloc+0x111e>
    2fba:	00003097          	auipc	ra,0x3
    2fbe:	c56080e7          	jalr	-938(ra) # 5c10 <unlink>
  unlink("12345678901234");
    2fc2:	00004517          	auipc	a0,0x4
    2fc6:	32650513          	addi	a0,a0,806 # 72e8 <malloc+0x12c6>
    2fca:	00003097          	auipc	ra,0x3
    2fce:	c46080e7          	jalr	-954(ra) # 5c10 <unlink>
}
    2fd2:	60e2                	ld	ra,24(sp)
    2fd4:	6442                	ld	s0,16(sp)
    2fd6:	64a2                	ld	s1,8(sp)
    2fd8:	6105                	addi	sp,sp,32
    2fda:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2fdc:	85a6                	mv	a1,s1
    2fde:	00004517          	auipc	a0,0x4
    2fe2:	13a50513          	addi	a0,a0,314 # 7118 <malloc+0x10f6>
    2fe6:	00003097          	auipc	ra,0x3
    2fea:	f84080e7          	jalr	-124(ra) # 5f6a <printf>
    exit(1);
    2fee:	4505                	li	a0,1
    2ff0:	00003097          	auipc	ra,0x3
    2ff4:	bd0080e7          	jalr	-1072(ra) # 5bc0 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2ff8:	85a6                	mv	a1,s1
    2ffa:	00004517          	auipc	a0,0x4
    2ffe:	16650513          	addi	a0,a0,358 # 7160 <malloc+0x113e>
    3002:	00003097          	auipc	ra,0x3
    3006:	f68080e7          	jalr	-152(ra) # 5f6a <printf>
    exit(1);
    300a:	4505                	li	a0,1
    300c:	00003097          	auipc	ra,0x3
    3010:	bb4080e7          	jalr	-1100(ra) # 5bc0 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    3014:	85a6                	mv	a1,s1
    3016:	00004517          	auipc	a0,0x4
    301a:	1b250513          	addi	a0,a0,434 # 71c8 <malloc+0x11a6>
    301e:	00003097          	auipc	ra,0x3
    3022:	f4c080e7          	jalr	-180(ra) # 5f6a <printf>
    exit(1);
    3026:	4505                	li	a0,1
    3028:	00003097          	auipc	ra,0x3
    302c:	b98080e7          	jalr	-1128(ra) # 5bc0 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3030:	85a6                	mv	a1,s1
    3032:	00004517          	auipc	a0,0x4
    3036:	20e50513          	addi	a0,a0,526 # 7240 <malloc+0x121e>
    303a:	00003097          	auipc	ra,0x3
    303e:	f30080e7          	jalr	-208(ra) # 5f6a <printf>
    exit(1);
    3042:	4505                	li	a0,1
    3044:	00003097          	auipc	ra,0x3
    3048:	b7c080e7          	jalr	-1156(ra) # 5bc0 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    304c:	85a6                	mv	a1,s1
    304e:	00004517          	auipc	a0,0x4
    3052:	25250513          	addi	a0,a0,594 # 72a0 <malloc+0x127e>
    3056:	00003097          	auipc	ra,0x3
    305a:	f14080e7          	jalr	-236(ra) # 5f6a <printf>
    exit(1);
    305e:	4505                	li	a0,1
    3060:	00003097          	auipc	ra,0x3
    3064:	b60080e7          	jalr	-1184(ra) # 5bc0 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    3068:	85a6                	mv	a1,s1
    306a:	00004517          	auipc	a0,0x4
    306e:	28e50513          	addi	a0,a0,654 # 72f8 <malloc+0x12d6>
    3072:	00003097          	auipc	ra,0x3
    3076:	ef8080e7          	jalr	-264(ra) # 5f6a <printf>
    exit(1);
    307a:	4505                	li	a0,1
    307c:	00003097          	auipc	ra,0x3
    3080:	b44080e7          	jalr	-1212(ra) # 5bc0 <exit>

0000000000003084 <diskfull>:
}

// can the kernel tolerate running out of disk space?
void
diskfull(char *s)
{
    3084:	b9010113          	addi	sp,sp,-1136
    3088:	46113423          	sd	ra,1128(sp)
    308c:	46813023          	sd	s0,1120(sp)
    3090:	44913c23          	sd	s1,1112(sp)
    3094:	45213823          	sd	s2,1104(sp)
    3098:	45313423          	sd	s3,1096(sp)
    309c:	45413023          	sd	s4,1088(sp)
    30a0:	43513c23          	sd	s5,1080(sp)
    30a4:	43613823          	sd	s6,1072(sp)
    30a8:	43713423          	sd	s7,1064(sp)
    30ac:	43813023          	sd	s8,1056(sp)
    30b0:	47010413          	addi	s0,sp,1136
    30b4:	8c2a                	mv	s8,a0
  int fi;
  int done = 0;

  unlink("diskfulldir");
    30b6:	00004517          	auipc	a0,0x4
    30ba:	27a50513          	addi	a0,a0,634 # 7330 <malloc+0x130e>
    30be:	00003097          	auipc	ra,0x3
    30c2:	b52080e7          	jalr	-1198(ra) # 5c10 <unlink>
  
  for(fi = 0; done == 0; fi++){
    30c6:	4a01                	li	s4,0
    char name[32];
    name[0] = 'b';
    30c8:	06200b13          	li	s6,98
    name[1] = 'i';
    30cc:	06900a93          	li	s5,105
    name[2] = 'g';
    30d0:	06700993          	li	s3,103
    30d4:	10c00b93          	li	s7,268
    30d8:	aabd                	j	3256 <diskfull+0x1d2>
    name[4] = '\0';
    unlink(name);
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    if(fd < 0){
      // oops, ran out of inodes before running out of blocks.
      printf("%s: could not create file %s\n", s, name);
    30da:	b9040613          	addi	a2,s0,-1136
    30de:	85e2                	mv	a1,s8
    30e0:	00004517          	auipc	a0,0x4
    30e4:	26050513          	addi	a0,a0,608 # 7340 <malloc+0x131e>
    30e8:	00003097          	auipc	ra,0x3
    30ec:	e82080e7          	jalr	-382(ra) # 5f6a <printf>
      done = 1;
      break;
    30f0:	a821                	j	3108 <diskfull+0x84>
    }
    for(int i = 0; i < MAXFILE; i++){
      char buf[BSIZE];
      if(write(fd, buf, BSIZE) != BSIZE){
        done = 1;
        close(fd);
    30f2:	854a                	mv	a0,s2
    30f4:	00003097          	auipc	ra,0x3
    30f8:	af4080e7          	jalr	-1292(ra) # 5be8 <close>
        break;
      }
    }
    close(fd);
    30fc:	854a                	mv	a0,s2
    30fe:	00003097          	auipc	ra,0x3
    3102:	aea080e7          	jalr	-1302(ra) # 5be8 <close>
  for(fi = 0; done == 0; fi++){
    3106:	2a05                	addiw	s4,s4,1
  // now that there are no free blocks, test that dirlink()
  // merely fails (doesn't panic) if it can't extend
  // directory content. one of these file creations
  // is expected to fail.
  int nzz = 128;
  for(int i = 0; i < nzz; i++){
    3108:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
    310a:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    310e:	08000993          	li	s3,128
    name[0] = 'z';
    3112:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    3116:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    311a:	41f4d71b          	sraiw	a4,s1,0x1f
    311e:	01b7571b          	srliw	a4,a4,0x1b
    3122:	009707bb          	addw	a5,a4,s1
    3126:	4057d69b          	sraiw	a3,a5,0x5
    312a:	0306869b          	addiw	a3,a3,48
    312e:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3132:	8bfd                	andi	a5,a5,31
    3134:	9f99                	subw	a5,a5,a4
    3136:	0307879b          	addiw	a5,a5,48
    313a:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    313e:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3142:	bb040513          	addi	a0,s0,-1104
    3146:	00003097          	auipc	ra,0x3
    314a:	aca080e7          	jalr	-1334(ra) # 5c10 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    314e:	60200593          	li	a1,1538
    3152:	bb040513          	addi	a0,s0,-1104
    3156:	00003097          	auipc	ra,0x3
    315a:	aaa080e7          	jalr	-1366(ra) # 5c00 <open>
    if(fd < 0)
    315e:	00054963          	bltz	a0,3170 <diskfull+0xec>
      break;
    close(fd);
    3162:	00003097          	auipc	ra,0x3
    3166:	a86080e7          	jalr	-1402(ra) # 5be8 <close>
  for(int i = 0; i < nzz; i++){
    316a:	2485                	addiw	s1,s1,1
    316c:	fb3493e3          	bne	s1,s3,3112 <diskfull+0x8e>
  }

  // this mkdir() is expected to fail.
  if(mkdir("diskfulldir") == 0)
    3170:	00004517          	auipc	a0,0x4
    3174:	1c050513          	addi	a0,a0,448 # 7330 <malloc+0x130e>
    3178:	00003097          	auipc	ra,0x3
    317c:	ab0080e7          	jalr	-1360(ra) # 5c28 <mkdir>
    3180:	12050963          	beqz	a0,32b2 <diskfull+0x22e>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");

  unlink("diskfulldir");
    3184:	00004517          	auipc	a0,0x4
    3188:	1ac50513          	addi	a0,a0,428 # 7330 <malloc+0x130e>
    318c:	00003097          	auipc	ra,0x3
    3190:	a84080e7          	jalr	-1404(ra) # 5c10 <unlink>

  for(int i = 0; i < nzz; i++){
    3194:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
    3196:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    319a:	08000993          	li	s3,128
    name[0] = 'z';
    319e:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    31a2:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    31a6:	41f4d71b          	sraiw	a4,s1,0x1f
    31aa:	01b7571b          	srliw	a4,a4,0x1b
    31ae:	009707bb          	addw	a5,a4,s1
    31b2:	4057d69b          	sraiw	a3,a5,0x5
    31b6:	0306869b          	addiw	a3,a3,48
    31ba:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    31be:	8bfd                	andi	a5,a5,31
    31c0:	9f99                	subw	a5,a5,a4
    31c2:	0307879b          	addiw	a5,a5,48
    31c6:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    31ca:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    31ce:	bb040513          	addi	a0,s0,-1104
    31d2:	00003097          	auipc	ra,0x3
    31d6:	a3e080e7          	jalr	-1474(ra) # 5c10 <unlink>
  for(int i = 0; i < nzz; i++){
    31da:	2485                	addiw	s1,s1,1
    31dc:	fd3491e3          	bne	s1,s3,319e <diskfull+0x11a>
  }

  for(int i = 0; i < fi; i++){
    31e0:	03405e63          	blez	s4,321c <diskfull+0x198>
    31e4:	4481                	li	s1,0
    char name[32];
    name[0] = 'b';
    31e6:	06200a93          	li	s5,98
    name[1] = 'i';
    31ea:	06900993          	li	s3,105
    name[2] = 'g';
    31ee:	06700913          	li	s2,103
    name[0] = 'b';
    31f2:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    31f6:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    31fa:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    31fe:	0304879b          	addiw	a5,s1,48
    3202:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3206:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    320a:	bb040513          	addi	a0,s0,-1104
    320e:	00003097          	auipc	ra,0x3
    3212:	a02080e7          	jalr	-1534(ra) # 5c10 <unlink>
  for(int i = 0; i < fi; i++){
    3216:	2485                	addiw	s1,s1,1
    3218:	fd449de3          	bne	s1,s4,31f2 <diskfull+0x16e>
  }
}
    321c:	46813083          	ld	ra,1128(sp)
    3220:	46013403          	ld	s0,1120(sp)
    3224:	45813483          	ld	s1,1112(sp)
    3228:	45013903          	ld	s2,1104(sp)
    322c:	44813983          	ld	s3,1096(sp)
    3230:	44013a03          	ld	s4,1088(sp)
    3234:	43813a83          	ld	s5,1080(sp)
    3238:	43013b03          	ld	s6,1072(sp)
    323c:	42813b83          	ld	s7,1064(sp)
    3240:	42013c03          	ld	s8,1056(sp)
    3244:	47010113          	addi	sp,sp,1136
    3248:	8082                	ret
    close(fd);
    324a:	854a                	mv	a0,s2
    324c:	00003097          	auipc	ra,0x3
    3250:	99c080e7          	jalr	-1636(ra) # 5be8 <close>
  for(fi = 0; done == 0; fi++){
    3254:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    3256:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    325a:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    325e:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    3262:	030a079b          	addiw	a5,s4,48
    3266:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    326a:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    326e:	b9040513          	addi	a0,s0,-1136
    3272:	00003097          	auipc	ra,0x3
    3276:	99e080e7          	jalr	-1634(ra) # 5c10 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    327a:	60200593          	li	a1,1538
    327e:	b9040513          	addi	a0,s0,-1136
    3282:	00003097          	auipc	ra,0x3
    3286:	97e080e7          	jalr	-1666(ra) # 5c00 <open>
    328a:	892a                	mv	s2,a0
    if(fd < 0){
    328c:	e40547e3          	bltz	a0,30da <diskfull+0x56>
    3290:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    3292:	40000613          	li	a2,1024
    3296:	bb040593          	addi	a1,s0,-1104
    329a:	854a                	mv	a0,s2
    329c:	00003097          	auipc	ra,0x3
    32a0:	944080e7          	jalr	-1724(ra) # 5be0 <write>
    32a4:	40000793          	li	a5,1024
    32a8:	e4f515e3          	bne	a0,a5,30f2 <diskfull+0x6e>
    for(int i = 0; i < MAXFILE; i++){
    32ac:	34fd                	addiw	s1,s1,-1
    32ae:	f0f5                	bnez	s1,3292 <diskfull+0x20e>
    32b0:	bf69                	j	324a <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    32b2:	00004517          	auipc	a0,0x4
    32b6:	0ae50513          	addi	a0,a0,174 # 7360 <malloc+0x133e>
    32ba:	00003097          	auipc	ra,0x3
    32be:	cb0080e7          	jalr	-848(ra) # 5f6a <printf>
    32c2:	b5c9                	j	3184 <diskfull+0x100>

00000000000032c4 <iputtest>:
{
    32c4:	1101                	addi	sp,sp,-32
    32c6:	ec06                	sd	ra,24(sp)
    32c8:	e822                	sd	s0,16(sp)
    32ca:	e426                	sd	s1,8(sp)
    32cc:	1000                	addi	s0,sp,32
    32ce:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    32d0:	00004517          	auipc	a0,0x4
    32d4:	0c050513          	addi	a0,a0,192 # 7390 <malloc+0x136e>
    32d8:	00003097          	auipc	ra,0x3
    32dc:	950080e7          	jalr	-1712(ra) # 5c28 <mkdir>
    32e0:	04054563          	bltz	a0,332a <iputtest+0x66>
  if(chdir("iputdir") < 0){
    32e4:	00004517          	auipc	a0,0x4
    32e8:	0ac50513          	addi	a0,a0,172 # 7390 <malloc+0x136e>
    32ec:	00003097          	auipc	ra,0x3
    32f0:	944080e7          	jalr	-1724(ra) # 5c30 <chdir>
    32f4:	04054963          	bltz	a0,3346 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    32f8:	00004517          	auipc	a0,0x4
    32fc:	0d850513          	addi	a0,a0,216 # 73d0 <malloc+0x13ae>
    3300:	00003097          	auipc	ra,0x3
    3304:	910080e7          	jalr	-1776(ra) # 5c10 <unlink>
    3308:	04054d63          	bltz	a0,3362 <iputtest+0x9e>
  if(chdir("/") < 0){
    330c:	00004517          	auipc	a0,0x4
    3310:	0f450513          	addi	a0,a0,244 # 7400 <malloc+0x13de>
    3314:	00003097          	auipc	ra,0x3
    3318:	91c080e7          	jalr	-1764(ra) # 5c30 <chdir>
    331c:	06054163          	bltz	a0,337e <iputtest+0xba>
}
    3320:	60e2                	ld	ra,24(sp)
    3322:	6442                	ld	s0,16(sp)
    3324:	64a2                	ld	s1,8(sp)
    3326:	6105                	addi	sp,sp,32
    3328:	8082                	ret
    printf("%s: mkdir failed\n", s);
    332a:	85a6                	mv	a1,s1
    332c:	00004517          	auipc	a0,0x4
    3330:	06c50513          	addi	a0,a0,108 # 7398 <malloc+0x1376>
    3334:	00003097          	auipc	ra,0x3
    3338:	c36080e7          	jalr	-970(ra) # 5f6a <printf>
    exit(1);
    333c:	4505                	li	a0,1
    333e:	00003097          	auipc	ra,0x3
    3342:	882080e7          	jalr	-1918(ra) # 5bc0 <exit>
    printf("%s: chdir iputdir failed\n", s);
    3346:	85a6                	mv	a1,s1
    3348:	00004517          	auipc	a0,0x4
    334c:	06850513          	addi	a0,a0,104 # 73b0 <malloc+0x138e>
    3350:	00003097          	auipc	ra,0x3
    3354:	c1a080e7          	jalr	-998(ra) # 5f6a <printf>
    exit(1);
    3358:	4505                	li	a0,1
    335a:	00003097          	auipc	ra,0x3
    335e:	866080e7          	jalr	-1946(ra) # 5bc0 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3362:	85a6                	mv	a1,s1
    3364:	00004517          	auipc	a0,0x4
    3368:	07c50513          	addi	a0,a0,124 # 73e0 <malloc+0x13be>
    336c:	00003097          	auipc	ra,0x3
    3370:	bfe080e7          	jalr	-1026(ra) # 5f6a <printf>
    exit(1);
    3374:	4505                	li	a0,1
    3376:	00003097          	auipc	ra,0x3
    337a:	84a080e7          	jalr	-1974(ra) # 5bc0 <exit>
    printf("%s: chdir / failed\n", s);
    337e:	85a6                	mv	a1,s1
    3380:	00004517          	auipc	a0,0x4
    3384:	08850513          	addi	a0,a0,136 # 7408 <malloc+0x13e6>
    3388:	00003097          	auipc	ra,0x3
    338c:	be2080e7          	jalr	-1054(ra) # 5f6a <printf>
    exit(1);
    3390:	4505                	li	a0,1
    3392:	00003097          	auipc	ra,0x3
    3396:	82e080e7          	jalr	-2002(ra) # 5bc0 <exit>

000000000000339a <exitiputtest>:
{
    339a:	7179                	addi	sp,sp,-48
    339c:	f406                	sd	ra,40(sp)
    339e:	f022                	sd	s0,32(sp)
    33a0:	ec26                	sd	s1,24(sp)
    33a2:	1800                	addi	s0,sp,48
    33a4:	84aa                	mv	s1,a0
  pid = fork();
    33a6:	00003097          	auipc	ra,0x3
    33aa:	812080e7          	jalr	-2030(ra) # 5bb8 <fork>
  if(pid < 0){
    33ae:	04054663          	bltz	a0,33fa <exitiputtest+0x60>
  if(pid == 0){
    33b2:	ed45                	bnez	a0,346a <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    33b4:	00004517          	auipc	a0,0x4
    33b8:	fdc50513          	addi	a0,a0,-36 # 7390 <malloc+0x136e>
    33bc:	00003097          	auipc	ra,0x3
    33c0:	86c080e7          	jalr	-1940(ra) # 5c28 <mkdir>
    33c4:	04054963          	bltz	a0,3416 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    33c8:	00004517          	auipc	a0,0x4
    33cc:	fc850513          	addi	a0,a0,-56 # 7390 <malloc+0x136e>
    33d0:	00003097          	auipc	ra,0x3
    33d4:	860080e7          	jalr	-1952(ra) # 5c30 <chdir>
    33d8:	04054d63          	bltz	a0,3432 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    33dc:	00004517          	auipc	a0,0x4
    33e0:	ff450513          	addi	a0,a0,-12 # 73d0 <malloc+0x13ae>
    33e4:	00003097          	auipc	ra,0x3
    33e8:	82c080e7          	jalr	-2004(ra) # 5c10 <unlink>
    33ec:	06054163          	bltz	a0,344e <exitiputtest+0xb4>
    exit(0);
    33f0:	4501                	li	a0,0
    33f2:	00002097          	auipc	ra,0x2
    33f6:	7ce080e7          	jalr	1998(ra) # 5bc0 <exit>
    printf("%s: fork failed\n", s);
    33fa:	85a6                	mv	a1,s1
    33fc:	00003517          	auipc	a0,0x3
    3400:	5d450513          	addi	a0,a0,1492 # 69d0 <malloc+0x9ae>
    3404:	00003097          	auipc	ra,0x3
    3408:	b66080e7          	jalr	-1178(ra) # 5f6a <printf>
    exit(1);
    340c:	4505                	li	a0,1
    340e:	00002097          	auipc	ra,0x2
    3412:	7b2080e7          	jalr	1970(ra) # 5bc0 <exit>
      printf("%s: mkdir failed\n", s);
    3416:	85a6                	mv	a1,s1
    3418:	00004517          	auipc	a0,0x4
    341c:	f8050513          	addi	a0,a0,-128 # 7398 <malloc+0x1376>
    3420:	00003097          	auipc	ra,0x3
    3424:	b4a080e7          	jalr	-1206(ra) # 5f6a <printf>
      exit(1);
    3428:	4505                	li	a0,1
    342a:	00002097          	auipc	ra,0x2
    342e:	796080e7          	jalr	1942(ra) # 5bc0 <exit>
      printf("%s: child chdir failed\n", s);
    3432:	85a6                	mv	a1,s1
    3434:	00004517          	auipc	a0,0x4
    3438:	fec50513          	addi	a0,a0,-20 # 7420 <malloc+0x13fe>
    343c:	00003097          	auipc	ra,0x3
    3440:	b2e080e7          	jalr	-1234(ra) # 5f6a <printf>
      exit(1);
    3444:	4505                	li	a0,1
    3446:	00002097          	auipc	ra,0x2
    344a:	77a080e7          	jalr	1914(ra) # 5bc0 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    344e:	85a6                	mv	a1,s1
    3450:	00004517          	auipc	a0,0x4
    3454:	f9050513          	addi	a0,a0,-112 # 73e0 <malloc+0x13be>
    3458:	00003097          	auipc	ra,0x3
    345c:	b12080e7          	jalr	-1262(ra) # 5f6a <printf>
      exit(1);
    3460:	4505                	li	a0,1
    3462:	00002097          	auipc	ra,0x2
    3466:	75e080e7          	jalr	1886(ra) # 5bc0 <exit>
  wait(&xstatus);
    346a:	fdc40513          	addi	a0,s0,-36
    346e:	00002097          	auipc	ra,0x2
    3472:	75a080e7          	jalr	1882(ra) # 5bc8 <wait>
  exit(xstatus);
    3476:	fdc42503          	lw	a0,-36(s0)
    347a:	00002097          	auipc	ra,0x2
    347e:	746080e7          	jalr	1862(ra) # 5bc0 <exit>

0000000000003482 <dirtest>:
{
    3482:	1101                	addi	sp,sp,-32
    3484:	ec06                	sd	ra,24(sp)
    3486:	e822                	sd	s0,16(sp)
    3488:	e426                	sd	s1,8(sp)
    348a:	1000                	addi	s0,sp,32
    348c:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    348e:	00004517          	auipc	a0,0x4
    3492:	faa50513          	addi	a0,a0,-86 # 7438 <malloc+0x1416>
    3496:	00002097          	auipc	ra,0x2
    349a:	792080e7          	jalr	1938(ra) # 5c28 <mkdir>
    349e:	04054563          	bltz	a0,34e8 <dirtest+0x66>
  if(chdir("dir0") < 0){
    34a2:	00004517          	auipc	a0,0x4
    34a6:	f9650513          	addi	a0,a0,-106 # 7438 <malloc+0x1416>
    34aa:	00002097          	auipc	ra,0x2
    34ae:	786080e7          	jalr	1926(ra) # 5c30 <chdir>
    34b2:	04054963          	bltz	a0,3504 <dirtest+0x82>
  if(chdir("..") < 0){
    34b6:	00004517          	auipc	a0,0x4
    34ba:	fa250513          	addi	a0,a0,-94 # 7458 <malloc+0x1436>
    34be:	00002097          	auipc	ra,0x2
    34c2:	772080e7          	jalr	1906(ra) # 5c30 <chdir>
    34c6:	04054d63          	bltz	a0,3520 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    34ca:	00004517          	auipc	a0,0x4
    34ce:	f6e50513          	addi	a0,a0,-146 # 7438 <malloc+0x1416>
    34d2:	00002097          	auipc	ra,0x2
    34d6:	73e080e7          	jalr	1854(ra) # 5c10 <unlink>
    34da:	06054163          	bltz	a0,353c <dirtest+0xba>
}
    34de:	60e2                	ld	ra,24(sp)
    34e0:	6442                	ld	s0,16(sp)
    34e2:	64a2                	ld	s1,8(sp)
    34e4:	6105                	addi	sp,sp,32
    34e6:	8082                	ret
    printf("%s: mkdir failed\n", s);
    34e8:	85a6                	mv	a1,s1
    34ea:	00004517          	auipc	a0,0x4
    34ee:	eae50513          	addi	a0,a0,-338 # 7398 <malloc+0x1376>
    34f2:	00003097          	auipc	ra,0x3
    34f6:	a78080e7          	jalr	-1416(ra) # 5f6a <printf>
    exit(1);
    34fa:	4505                	li	a0,1
    34fc:	00002097          	auipc	ra,0x2
    3500:	6c4080e7          	jalr	1732(ra) # 5bc0 <exit>
    printf("%s: chdir dir0 failed\n", s);
    3504:	85a6                	mv	a1,s1
    3506:	00004517          	auipc	a0,0x4
    350a:	f3a50513          	addi	a0,a0,-198 # 7440 <malloc+0x141e>
    350e:	00003097          	auipc	ra,0x3
    3512:	a5c080e7          	jalr	-1444(ra) # 5f6a <printf>
    exit(1);
    3516:	4505                	li	a0,1
    3518:	00002097          	auipc	ra,0x2
    351c:	6a8080e7          	jalr	1704(ra) # 5bc0 <exit>
    printf("%s: chdir .. failed\n", s);
    3520:	85a6                	mv	a1,s1
    3522:	00004517          	auipc	a0,0x4
    3526:	f3e50513          	addi	a0,a0,-194 # 7460 <malloc+0x143e>
    352a:	00003097          	auipc	ra,0x3
    352e:	a40080e7          	jalr	-1472(ra) # 5f6a <printf>
    exit(1);
    3532:	4505                	li	a0,1
    3534:	00002097          	auipc	ra,0x2
    3538:	68c080e7          	jalr	1676(ra) # 5bc0 <exit>
    printf("%s: unlink dir0 failed\n", s);
    353c:	85a6                	mv	a1,s1
    353e:	00004517          	auipc	a0,0x4
    3542:	f3a50513          	addi	a0,a0,-198 # 7478 <malloc+0x1456>
    3546:	00003097          	auipc	ra,0x3
    354a:	a24080e7          	jalr	-1500(ra) # 5f6a <printf>
    exit(1);
    354e:	4505                	li	a0,1
    3550:	00002097          	auipc	ra,0x2
    3554:	670080e7          	jalr	1648(ra) # 5bc0 <exit>

0000000000003558 <subdir>:
{
    3558:	1101                	addi	sp,sp,-32
    355a:	ec06                	sd	ra,24(sp)
    355c:	e822                	sd	s0,16(sp)
    355e:	e426                	sd	s1,8(sp)
    3560:	e04a                	sd	s2,0(sp)
    3562:	1000                	addi	s0,sp,32
    3564:	892a                	mv	s2,a0
  unlink("ff");
    3566:	00004517          	auipc	a0,0x4
    356a:	05a50513          	addi	a0,a0,90 # 75c0 <malloc+0x159e>
    356e:	00002097          	auipc	ra,0x2
    3572:	6a2080e7          	jalr	1698(ra) # 5c10 <unlink>
  if(mkdir("dd") != 0){
    3576:	00004517          	auipc	a0,0x4
    357a:	f1a50513          	addi	a0,a0,-230 # 7490 <malloc+0x146e>
    357e:	00002097          	auipc	ra,0x2
    3582:	6aa080e7          	jalr	1706(ra) # 5c28 <mkdir>
    3586:	38051663          	bnez	a0,3912 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    358a:	20200593          	li	a1,514
    358e:	00004517          	auipc	a0,0x4
    3592:	f2250513          	addi	a0,a0,-222 # 74b0 <malloc+0x148e>
    3596:	00002097          	auipc	ra,0x2
    359a:	66a080e7          	jalr	1642(ra) # 5c00 <open>
    359e:	84aa                	mv	s1,a0
  if(fd < 0){
    35a0:	38054763          	bltz	a0,392e <subdir+0x3d6>
  write(fd, "ff", 2);
    35a4:	4609                	li	a2,2
    35a6:	00004597          	auipc	a1,0x4
    35aa:	01a58593          	addi	a1,a1,26 # 75c0 <malloc+0x159e>
    35ae:	00002097          	auipc	ra,0x2
    35b2:	632080e7          	jalr	1586(ra) # 5be0 <write>
  close(fd);
    35b6:	8526                	mv	a0,s1
    35b8:	00002097          	auipc	ra,0x2
    35bc:	630080e7          	jalr	1584(ra) # 5be8 <close>
  if(unlink("dd") >= 0){
    35c0:	00004517          	auipc	a0,0x4
    35c4:	ed050513          	addi	a0,a0,-304 # 7490 <malloc+0x146e>
    35c8:	00002097          	auipc	ra,0x2
    35cc:	648080e7          	jalr	1608(ra) # 5c10 <unlink>
    35d0:	36055d63          	bgez	a0,394a <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    35d4:	00004517          	auipc	a0,0x4
    35d8:	f3450513          	addi	a0,a0,-204 # 7508 <malloc+0x14e6>
    35dc:	00002097          	auipc	ra,0x2
    35e0:	64c080e7          	jalr	1612(ra) # 5c28 <mkdir>
    35e4:	38051163          	bnez	a0,3966 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    35e8:	20200593          	li	a1,514
    35ec:	00004517          	auipc	a0,0x4
    35f0:	f4450513          	addi	a0,a0,-188 # 7530 <malloc+0x150e>
    35f4:	00002097          	auipc	ra,0x2
    35f8:	60c080e7          	jalr	1548(ra) # 5c00 <open>
    35fc:	84aa                	mv	s1,a0
  if(fd < 0){
    35fe:	38054263          	bltz	a0,3982 <subdir+0x42a>
  write(fd, "FF", 2);
    3602:	4609                	li	a2,2
    3604:	00004597          	auipc	a1,0x4
    3608:	f5c58593          	addi	a1,a1,-164 # 7560 <malloc+0x153e>
    360c:	00002097          	auipc	ra,0x2
    3610:	5d4080e7          	jalr	1492(ra) # 5be0 <write>
  close(fd);
    3614:	8526                	mv	a0,s1
    3616:	00002097          	auipc	ra,0x2
    361a:	5d2080e7          	jalr	1490(ra) # 5be8 <close>
  fd = open("dd/dd/../ff", 0);
    361e:	4581                	li	a1,0
    3620:	00004517          	auipc	a0,0x4
    3624:	f4850513          	addi	a0,a0,-184 # 7568 <malloc+0x1546>
    3628:	00002097          	auipc	ra,0x2
    362c:	5d8080e7          	jalr	1496(ra) # 5c00 <open>
    3630:	84aa                	mv	s1,a0
  if(fd < 0){
    3632:	36054663          	bltz	a0,399e <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3636:	660d                	lui	a2,0x3
    3638:	00009597          	auipc	a1,0x9
    363c:	62058593          	addi	a1,a1,1568 # cc58 <buf>
    3640:	00002097          	auipc	ra,0x2
    3644:	598080e7          	jalr	1432(ra) # 5bd8 <read>
  if(cc != 2 || buf[0] != 'f'){
    3648:	4789                	li	a5,2
    364a:	36f51863          	bne	a0,a5,39ba <subdir+0x462>
    364e:	00009717          	auipc	a4,0x9
    3652:	60a74703          	lbu	a4,1546(a4) # cc58 <buf>
    3656:	06600793          	li	a5,102
    365a:	36f71063          	bne	a4,a5,39ba <subdir+0x462>
  close(fd);
    365e:	8526                	mv	a0,s1
    3660:	00002097          	auipc	ra,0x2
    3664:	588080e7          	jalr	1416(ra) # 5be8 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3668:	00004597          	auipc	a1,0x4
    366c:	f5058593          	addi	a1,a1,-176 # 75b8 <malloc+0x1596>
    3670:	00004517          	auipc	a0,0x4
    3674:	ec050513          	addi	a0,a0,-320 # 7530 <malloc+0x150e>
    3678:	00002097          	auipc	ra,0x2
    367c:	5a8080e7          	jalr	1448(ra) # 5c20 <link>
    3680:	34051b63          	bnez	a0,39d6 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3684:	00004517          	auipc	a0,0x4
    3688:	eac50513          	addi	a0,a0,-340 # 7530 <malloc+0x150e>
    368c:	00002097          	auipc	ra,0x2
    3690:	584080e7          	jalr	1412(ra) # 5c10 <unlink>
    3694:	34051f63          	bnez	a0,39f2 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3698:	4581                	li	a1,0
    369a:	00004517          	auipc	a0,0x4
    369e:	e9650513          	addi	a0,a0,-362 # 7530 <malloc+0x150e>
    36a2:	00002097          	auipc	ra,0x2
    36a6:	55e080e7          	jalr	1374(ra) # 5c00 <open>
    36aa:	36055263          	bgez	a0,3a0e <subdir+0x4b6>
  if(chdir("dd") != 0){
    36ae:	00004517          	auipc	a0,0x4
    36b2:	de250513          	addi	a0,a0,-542 # 7490 <malloc+0x146e>
    36b6:	00002097          	auipc	ra,0x2
    36ba:	57a080e7          	jalr	1402(ra) # 5c30 <chdir>
    36be:	36051663          	bnez	a0,3a2a <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    36c2:	00004517          	auipc	a0,0x4
    36c6:	f8e50513          	addi	a0,a0,-114 # 7650 <malloc+0x162e>
    36ca:	00002097          	auipc	ra,0x2
    36ce:	566080e7          	jalr	1382(ra) # 5c30 <chdir>
    36d2:	36051a63          	bnez	a0,3a46 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    36d6:	00004517          	auipc	a0,0x4
    36da:	faa50513          	addi	a0,a0,-86 # 7680 <malloc+0x165e>
    36de:	00002097          	auipc	ra,0x2
    36e2:	552080e7          	jalr	1362(ra) # 5c30 <chdir>
    36e6:	36051e63          	bnez	a0,3a62 <subdir+0x50a>
  if(chdir("./..") != 0){
    36ea:	00004517          	auipc	a0,0x4
    36ee:	fc650513          	addi	a0,a0,-58 # 76b0 <malloc+0x168e>
    36f2:	00002097          	auipc	ra,0x2
    36f6:	53e080e7          	jalr	1342(ra) # 5c30 <chdir>
    36fa:	38051263          	bnez	a0,3a7e <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    36fe:	4581                	li	a1,0
    3700:	00004517          	auipc	a0,0x4
    3704:	eb850513          	addi	a0,a0,-328 # 75b8 <malloc+0x1596>
    3708:	00002097          	auipc	ra,0x2
    370c:	4f8080e7          	jalr	1272(ra) # 5c00 <open>
    3710:	84aa                	mv	s1,a0
  if(fd < 0){
    3712:	38054463          	bltz	a0,3a9a <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3716:	660d                	lui	a2,0x3
    3718:	00009597          	auipc	a1,0x9
    371c:	54058593          	addi	a1,a1,1344 # cc58 <buf>
    3720:	00002097          	auipc	ra,0x2
    3724:	4b8080e7          	jalr	1208(ra) # 5bd8 <read>
    3728:	4789                	li	a5,2
    372a:	38f51663          	bne	a0,a5,3ab6 <subdir+0x55e>
  close(fd);
    372e:	8526                	mv	a0,s1
    3730:	00002097          	auipc	ra,0x2
    3734:	4b8080e7          	jalr	1208(ra) # 5be8 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3738:	4581                	li	a1,0
    373a:	00004517          	auipc	a0,0x4
    373e:	df650513          	addi	a0,a0,-522 # 7530 <malloc+0x150e>
    3742:	00002097          	auipc	ra,0x2
    3746:	4be080e7          	jalr	1214(ra) # 5c00 <open>
    374a:	38055463          	bgez	a0,3ad2 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    374e:	20200593          	li	a1,514
    3752:	00004517          	auipc	a0,0x4
    3756:	fee50513          	addi	a0,a0,-18 # 7740 <malloc+0x171e>
    375a:	00002097          	auipc	ra,0x2
    375e:	4a6080e7          	jalr	1190(ra) # 5c00 <open>
    3762:	38055663          	bgez	a0,3aee <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3766:	20200593          	li	a1,514
    376a:	00004517          	auipc	a0,0x4
    376e:	00650513          	addi	a0,a0,6 # 7770 <malloc+0x174e>
    3772:	00002097          	auipc	ra,0x2
    3776:	48e080e7          	jalr	1166(ra) # 5c00 <open>
    377a:	38055863          	bgez	a0,3b0a <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    377e:	20000593          	li	a1,512
    3782:	00004517          	auipc	a0,0x4
    3786:	d0e50513          	addi	a0,a0,-754 # 7490 <malloc+0x146e>
    378a:	00002097          	auipc	ra,0x2
    378e:	476080e7          	jalr	1142(ra) # 5c00 <open>
    3792:	38055a63          	bgez	a0,3b26 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3796:	4589                	li	a1,2
    3798:	00004517          	auipc	a0,0x4
    379c:	cf850513          	addi	a0,a0,-776 # 7490 <malloc+0x146e>
    37a0:	00002097          	auipc	ra,0x2
    37a4:	460080e7          	jalr	1120(ra) # 5c00 <open>
    37a8:	38055d63          	bgez	a0,3b42 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    37ac:	4585                	li	a1,1
    37ae:	00004517          	auipc	a0,0x4
    37b2:	ce250513          	addi	a0,a0,-798 # 7490 <malloc+0x146e>
    37b6:	00002097          	auipc	ra,0x2
    37ba:	44a080e7          	jalr	1098(ra) # 5c00 <open>
    37be:	3a055063          	bgez	a0,3b5e <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    37c2:	00004597          	auipc	a1,0x4
    37c6:	03e58593          	addi	a1,a1,62 # 7800 <malloc+0x17de>
    37ca:	00004517          	auipc	a0,0x4
    37ce:	f7650513          	addi	a0,a0,-138 # 7740 <malloc+0x171e>
    37d2:	00002097          	auipc	ra,0x2
    37d6:	44e080e7          	jalr	1102(ra) # 5c20 <link>
    37da:	3a050063          	beqz	a0,3b7a <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    37de:	00004597          	auipc	a1,0x4
    37e2:	02258593          	addi	a1,a1,34 # 7800 <malloc+0x17de>
    37e6:	00004517          	auipc	a0,0x4
    37ea:	f8a50513          	addi	a0,a0,-118 # 7770 <malloc+0x174e>
    37ee:	00002097          	auipc	ra,0x2
    37f2:	432080e7          	jalr	1074(ra) # 5c20 <link>
    37f6:	3a050063          	beqz	a0,3b96 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    37fa:	00004597          	auipc	a1,0x4
    37fe:	dbe58593          	addi	a1,a1,-578 # 75b8 <malloc+0x1596>
    3802:	00004517          	auipc	a0,0x4
    3806:	cae50513          	addi	a0,a0,-850 # 74b0 <malloc+0x148e>
    380a:	00002097          	auipc	ra,0x2
    380e:	416080e7          	jalr	1046(ra) # 5c20 <link>
    3812:	3a050063          	beqz	a0,3bb2 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3816:	00004517          	auipc	a0,0x4
    381a:	f2a50513          	addi	a0,a0,-214 # 7740 <malloc+0x171e>
    381e:	00002097          	auipc	ra,0x2
    3822:	40a080e7          	jalr	1034(ra) # 5c28 <mkdir>
    3826:	3a050463          	beqz	a0,3bce <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    382a:	00004517          	auipc	a0,0x4
    382e:	f4650513          	addi	a0,a0,-186 # 7770 <malloc+0x174e>
    3832:	00002097          	auipc	ra,0x2
    3836:	3f6080e7          	jalr	1014(ra) # 5c28 <mkdir>
    383a:	3a050863          	beqz	a0,3bea <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    383e:	00004517          	auipc	a0,0x4
    3842:	d7a50513          	addi	a0,a0,-646 # 75b8 <malloc+0x1596>
    3846:	00002097          	auipc	ra,0x2
    384a:	3e2080e7          	jalr	994(ra) # 5c28 <mkdir>
    384e:	3a050c63          	beqz	a0,3c06 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3852:	00004517          	auipc	a0,0x4
    3856:	f1e50513          	addi	a0,a0,-226 # 7770 <malloc+0x174e>
    385a:	00002097          	auipc	ra,0x2
    385e:	3b6080e7          	jalr	950(ra) # 5c10 <unlink>
    3862:	3c050063          	beqz	a0,3c22 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3866:	00004517          	auipc	a0,0x4
    386a:	eda50513          	addi	a0,a0,-294 # 7740 <malloc+0x171e>
    386e:	00002097          	auipc	ra,0x2
    3872:	3a2080e7          	jalr	930(ra) # 5c10 <unlink>
    3876:	3c050463          	beqz	a0,3c3e <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    387a:	00004517          	auipc	a0,0x4
    387e:	c3650513          	addi	a0,a0,-970 # 74b0 <malloc+0x148e>
    3882:	00002097          	auipc	ra,0x2
    3886:	3ae080e7          	jalr	942(ra) # 5c30 <chdir>
    388a:	3c050863          	beqz	a0,3c5a <subdir+0x702>
  if(chdir("dd/xx") == 0){
    388e:	00004517          	auipc	a0,0x4
    3892:	0c250513          	addi	a0,a0,194 # 7950 <malloc+0x192e>
    3896:	00002097          	auipc	ra,0x2
    389a:	39a080e7          	jalr	922(ra) # 5c30 <chdir>
    389e:	3c050c63          	beqz	a0,3c76 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    38a2:	00004517          	auipc	a0,0x4
    38a6:	d1650513          	addi	a0,a0,-746 # 75b8 <malloc+0x1596>
    38aa:	00002097          	auipc	ra,0x2
    38ae:	366080e7          	jalr	870(ra) # 5c10 <unlink>
    38b2:	3e051063          	bnez	a0,3c92 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    38b6:	00004517          	auipc	a0,0x4
    38ba:	bfa50513          	addi	a0,a0,-1030 # 74b0 <malloc+0x148e>
    38be:	00002097          	auipc	ra,0x2
    38c2:	352080e7          	jalr	850(ra) # 5c10 <unlink>
    38c6:	3e051463          	bnez	a0,3cae <subdir+0x756>
  if(unlink("dd") == 0){
    38ca:	00004517          	auipc	a0,0x4
    38ce:	bc650513          	addi	a0,a0,-1082 # 7490 <malloc+0x146e>
    38d2:	00002097          	auipc	ra,0x2
    38d6:	33e080e7          	jalr	830(ra) # 5c10 <unlink>
    38da:	3e050863          	beqz	a0,3cca <subdir+0x772>
  if(unlink("dd/dd") < 0){
    38de:	00004517          	auipc	a0,0x4
    38e2:	0e250513          	addi	a0,a0,226 # 79c0 <malloc+0x199e>
    38e6:	00002097          	auipc	ra,0x2
    38ea:	32a080e7          	jalr	810(ra) # 5c10 <unlink>
    38ee:	3e054c63          	bltz	a0,3ce6 <subdir+0x78e>
  if(unlink("dd") < 0){
    38f2:	00004517          	auipc	a0,0x4
    38f6:	b9e50513          	addi	a0,a0,-1122 # 7490 <malloc+0x146e>
    38fa:	00002097          	auipc	ra,0x2
    38fe:	316080e7          	jalr	790(ra) # 5c10 <unlink>
    3902:	40054063          	bltz	a0,3d02 <subdir+0x7aa>
}
    3906:	60e2                	ld	ra,24(sp)
    3908:	6442                	ld	s0,16(sp)
    390a:	64a2                	ld	s1,8(sp)
    390c:	6902                	ld	s2,0(sp)
    390e:	6105                	addi	sp,sp,32
    3910:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3912:	85ca                	mv	a1,s2
    3914:	00004517          	auipc	a0,0x4
    3918:	b8450513          	addi	a0,a0,-1148 # 7498 <malloc+0x1476>
    391c:	00002097          	auipc	ra,0x2
    3920:	64e080e7          	jalr	1614(ra) # 5f6a <printf>
    exit(1);
    3924:	4505                	li	a0,1
    3926:	00002097          	auipc	ra,0x2
    392a:	29a080e7          	jalr	666(ra) # 5bc0 <exit>
    printf("%s: create dd/ff failed\n", s);
    392e:	85ca                	mv	a1,s2
    3930:	00004517          	auipc	a0,0x4
    3934:	b8850513          	addi	a0,a0,-1144 # 74b8 <malloc+0x1496>
    3938:	00002097          	auipc	ra,0x2
    393c:	632080e7          	jalr	1586(ra) # 5f6a <printf>
    exit(1);
    3940:	4505                	li	a0,1
    3942:	00002097          	auipc	ra,0x2
    3946:	27e080e7          	jalr	638(ra) # 5bc0 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    394a:	85ca                	mv	a1,s2
    394c:	00004517          	auipc	a0,0x4
    3950:	b8c50513          	addi	a0,a0,-1140 # 74d8 <malloc+0x14b6>
    3954:	00002097          	auipc	ra,0x2
    3958:	616080e7          	jalr	1558(ra) # 5f6a <printf>
    exit(1);
    395c:	4505                	li	a0,1
    395e:	00002097          	auipc	ra,0x2
    3962:	262080e7          	jalr	610(ra) # 5bc0 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3966:	85ca                	mv	a1,s2
    3968:	00004517          	auipc	a0,0x4
    396c:	ba850513          	addi	a0,a0,-1112 # 7510 <malloc+0x14ee>
    3970:	00002097          	auipc	ra,0x2
    3974:	5fa080e7          	jalr	1530(ra) # 5f6a <printf>
    exit(1);
    3978:	4505                	li	a0,1
    397a:	00002097          	auipc	ra,0x2
    397e:	246080e7          	jalr	582(ra) # 5bc0 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3982:	85ca                	mv	a1,s2
    3984:	00004517          	auipc	a0,0x4
    3988:	bbc50513          	addi	a0,a0,-1092 # 7540 <malloc+0x151e>
    398c:	00002097          	auipc	ra,0x2
    3990:	5de080e7          	jalr	1502(ra) # 5f6a <printf>
    exit(1);
    3994:	4505                	li	a0,1
    3996:	00002097          	auipc	ra,0x2
    399a:	22a080e7          	jalr	554(ra) # 5bc0 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    399e:	85ca                	mv	a1,s2
    39a0:	00004517          	auipc	a0,0x4
    39a4:	bd850513          	addi	a0,a0,-1064 # 7578 <malloc+0x1556>
    39a8:	00002097          	auipc	ra,0x2
    39ac:	5c2080e7          	jalr	1474(ra) # 5f6a <printf>
    exit(1);
    39b0:	4505                	li	a0,1
    39b2:	00002097          	auipc	ra,0x2
    39b6:	20e080e7          	jalr	526(ra) # 5bc0 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    39ba:	85ca                	mv	a1,s2
    39bc:	00004517          	auipc	a0,0x4
    39c0:	bdc50513          	addi	a0,a0,-1060 # 7598 <malloc+0x1576>
    39c4:	00002097          	auipc	ra,0x2
    39c8:	5a6080e7          	jalr	1446(ra) # 5f6a <printf>
    exit(1);
    39cc:	4505                	li	a0,1
    39ce:	00002097          	auipc	ra,0x2
    39d2:	1f2080e7          	jalr	498(ra) # 5bc0 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    39d6:	85ca                	mv	a1,s2
    39d8:	00004517          	auipc	a0,0x4
    39dc:	bf050513          	addi	a0,a0,-1040 # 75c8 <malloc+0x15a6>
    39e0:	00002097          	auipc	ra,0x2
    39e4:	58a080e7          	jalr	1418(ra) # 5f6a <printf>
    exit(1);
    39e8:	4505                	li	a0,1
    39ea:	00002097          	auipc	ra,0x2
    39ee:	1d6080e7          	jalr	470(ra) # 5bc0 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    39f2:	85ca                	mv	a1,s2
    39f4:	00004517          	auipc	a0,0x4
    39f8:	bfc50513          	addi	a0,a0,-1028 # 75f0 <malloc+0x15ce>
    39fc:	00002097          	auipc	ra,0x2
    3a00:	56e080e7          	jalr	1390(ra) # 5f6a <printf>
    exit(1);
    3a04:	4505                	li	a0,1
    3a06:	00002097          	auipc	ra,0x2
    3a0a:	1ba080e7          	jalr	442(ra) # 5bc0 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3a0e:	85ca                	mv	a1,s2
    3a10:	00004517          	auipc	a0,0x4
    3a14:	c0050513          	addi	a0,a0,-1024 # 7610 <malloc+0x15ee>
    3a18:	00002097          	auipc	ra,0x2
    3a1c:	552080e7          	jalr	1362(ra) # 5f6a <printf>
    exit(1);
    3a20:	4505                	li	a0,1
    3a22:	00002097          	auipc	ra,0x2
    3a26:	19e080e7          	jalr	414(ra) # 5bc0 <exit>
    printf("%s: chdir dd failed\n", s);
    3a2a:	85ca                	mv	a1,s2
    3a2c:	00004517          	auipc	a0,0x4
    3a30:	c0c50513          	addi	a0,a0,-1012 # 7638 <malloc+0x1616>
    3a34:	00002097          	auipc	ra,0x2
    3a38:	536080e7          	jalr	1334(ra) # 5f6a <printf>
    exit(1);
    3a3c:	4505                	li	a0,1
    3a3e:	00002097          	auipc	ra,0x2
    3a42:	182080e7          	jalr	386(ra) # 5bc0 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3a46:	85ca                	mv	a1,s2
    3a48:	00004517          	auipc	a0,0x4
    3a4c:	c1850513          	addi	a0,a0,-1000 # 7660 <malloc+0x163e>
    3a50:	00002097          	auipc	ra,0x2
    3a54:	51a080e7          	jalr	1306(ra) # 5f6a <printf>
    exit(1);
    3a58:	4505                	li	a0,1
    3a5a:	00002097          	auipc	ra,0x2
    3a5e:	166080e7          	jalr	358(ra) # 5bc0 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3a62:	85ca                	mv	a1,s2
    3a64:	00004517          	auipc	a0,0x4
    3a68:	c2c50513          	addi	a0,a0,-980 # 7690 <malloc+0x166e>
    3a6c:	00002097          	auipc	ra,0x2
    3a70:	4fe080e7          	jalr	1278(ra) # 5f6a <printf>
    exit(1);
    3a74:	4505                	li	a0,1
    3a76:	00002097          	auipc	ra,0x2
    3a7a:	14a080e7          	jalr	330(ra) # 5bc0 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3a7e:	85ca                	mv	a1,s2
    3a80:	00004517          	auipc	a0,0x4
    3a84:	c3850513          	addi	a0,a0,-968 # 76b8 <malloc+0x1696>
    3a88:	00002097          	auipc	ra,0x2
    3a8c:	4e2080e7          	jalr	1250(ra) # 5f6a <printf>
    exit(1);
    3a90:	4505                	li	a0,1
    3a92:	00002097          	auipc	ra,0x2
    3a96:	12e080e7          	jalr	302(ra) # 5bc0 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3a9a:	85ca                	mv	a1,s2
    3a9c:	00004517          	auipc	a0,0x4
    3aa0:	c3450513          	addi	a0,a0,-972 # 76d0 <malloc+0x16ae>
    3aa4:	00002097          	auipc	ra,0x2
    3aa8:	4c6080e7          	jalr	1222(ra) # 5f6a <printf>
    exit(1);
    3aac:	4505                	li	a0,1
    3aae:	00002097          	auipc	ra,0x2
    3ab2:	112080e7          	jalr	274(ra) # 5bc0 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3ab6:	85ca                	mv	a1,s2
    3ab8:	00004517          	auipc	a0,0x4
    3abc:	c3850513          	addi	a0,a0,-968 # 76f0 <malloc+0x16ce>
    3ac0:	00002097          	auipc	ra,0x2
    3ac4:	4aa080e7          	jalr	1194(ra) # 5f6a <printf>
    exit(1);
    3ac8:	4505                	li	a0,1
    3aca:	00002097          	auipc	ra,0x2
    3ace:	0f6080e7          	jalr	246(ra) # 5bc0 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3ad2:	85ca                	mv	a1,s2
    3ad4:	00004517          	auipc	a0,0x4
    3ad8:	c3c50513          	addi	a0,a0,-964 # 7710 <malloc+0x16ee>
    3adc:	00002097          	auipc	ra,0x2
    3ae0:	48e080e7          	jalr	1166(ra) # 5f6a <printf>
    exit(1);
    3ae4:	4505                	li	a0,1
    3ae6:	00002097          	auipc	ra,0x2
    3aea:	0da080e7          	jalr	218(ra) # 5bc0 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3aee:	85ca                	mv	a1,s2
    3af0:	00004517          	auipc	a0,0x4
    3af4:	c6050513          	addi	a0,a0,-928 # 7750 <malloc+0x172e>
    3af8:	00002097          	auipc	ra,0x2
    3afc:	472080e7          	jalr	1138(ra) # 5f6a <printf>
    exit(1);
    3b00:	4505                	li	a0,1
    3b02:	00002097          	auipc	ra,0x2
    3b06:	0be080e7          	jalr	190(ra) # 5bc0 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3b0a:	85ca                	mv	a1,s2
    3b0c:	00004517          	auipc	a0,0x4
    3b10:	c7450513          	addi	a0,a0,-908 # 7780 <malloc+0x175e>
    3b14:	00002097          	auipc	ra,0x2
    3b18:	456080e7          	jalr	1110(ra) # 5f6a <printf>
    exit(1);
    3b1c:	4505                	li	a0,1
    3b1e:	00002097          	auipc	ra,0x2
    3b22:	0a2080e7          	jalr	162(ra) # 5bc0 <exit>
    printf("%s: create dd succeeded!\n", s);
    3b26:	85ca                	mv	a1,s2
    3b28:	00004517          	auipc	a0,0x4
    3b2c:	c7850513          	addi	a0,a0,-904 # 77a0 <malloc+0x177e>
    3b30:	00002097          	auipc	ra,0x2
    3b34:	43a080e7          	jalr	1082(ra) # 5f6a <printf>
    exit(1);
    3b38:	4505                	li	a0,1
    3b3a:	00002097          	auipc	ra,0x2
    3b3e:	086080e7          	jalr	134(ra) # 5bc0 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3b42:	85ca                	mv	a1,s2
    3b44:	00004517          	auipc	a0,0x4
    3b48:	c7c50513          	addi	a0,a0,-900 # 77c0 <malloc+0x179e>
    3b4c:	00002097          	auipc	ra,0x2
    3b50:	41e080e7          	jalr	1054(ra) # 5f6a <printf>
    exit(1);
    3b54:	4505                	li	a0,1
    3b56:	00002097          	auipc	ra,0x2
    3b5a:	06a080e7          	jalr	106(ra) # 5bc0 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3b5e:	85ca                	mv	a1,s2
    3b60:	00004517          	auipc	a0,0x4
    3b64:	c8050513          	addi	a0,a0,-896 # 77e0 <malloc+0x17be>
    3b68:	00002097          	auipc	ra,0x2
    3b6c:	402080e7          	jalr	1026(ra) # 5f6a <printf>
    exit(1);
    3b70:	4505                	li	a0,1
    3b72:	00002097          	auipc	ra,0x2
    3b76:	04e080e7          	jalr	78(ra) # 5bc0 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3b7a:	85ca                	mv	a1,s2
    3b7c:	00004517          	auipc	a0,0x4
    3b80:	c9450513          	addi	a0,a0,-876 # 7810 <malloc+0x17ee>
    3b84:	00002097          	auipc	ra,0x2
    3b88:	3e6080e7          	jalr	998(ra) # 5f6a <printf>
    exit(1);
    3b8c:	4505                	li	a0,1
    3b8e:	00002097          	auipc	ra,0x2
    3b92:	032080e7          	jalr	50(ra) # 5bc0 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3b96:	85ca                	mv	a1,s2
    3b98:	00004517          	auipc	a0,0x4
    3b9c:	ca050513          	addi	a0,a0,-864 # 7838 <malloc+0x1816>
    3ba0:	00002097          	auipc	ra,0x2
    3ba4:	3ca080e7          	jalr	970(ra) # 5f6a <printf>
    exit(1);
    3ba8:	4505                	li	a0,1
    3baa:	00002097          	auipc	ra,0x2
    3bae:	016080e7          	jalr	22(ra) # 5bc0 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3bb2:	85ca                	mv	a1,s2
    3bb4:	00004517          	auipc	a0,0x4
    3bb8:	cac50513          	addi	a0,a0,-852 # 7860 <malloc+0x183e>
    3bbc:	00002097          	auipc	ra,0x2
    3bc0:	3ae080e7          	jalr	942(ra) # 5f6a <printf>
    exit(1);
    3bc4:	4505                	li	a0,1
    3bc6:	00002097          	auipc	ra,0x2
    3bca:	ffa080e7          	jalr	-6(ra) # 5bc0 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3bce:	85ca                	mv	a1,s2
    3bd0:	00004517          	auipc	a0,0x4
    3bd4:	cb850513          	addi	a0,a0,-840 # 7888 <malloc+0x1866>
    3bd8:	00002097          	auipc	ra,0x2
    3bdc:	392080e7          	jalr	914(ra) # 5f6a <printf>
    exit(1);
    3be0:	4505                	li	a0,1
    3be2:	00002097          	auipc	ra,0x2
    3be6:	fde080e7          	jalr	-34(ra) # 5bc0 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3bea:	85ca                	mv	a1,s2
    3bec:	00004517          	auipc	a0,0x4
    3bf0:	cbc50513          	addi	a0,a0,-836 # 78a8 <malloc+0x1886>
    3bf4:	00002097          	auipc	ra,0x2
    3bf8:	376080e7          	jalr	886(ra) # 5f6a <printf>
    exit(1);
    3bfc:	4505                	li	a0,1
    3bfe:	00002097          	auipc	ra,0x2
    3c02:	fc2080e7          	jalr	-62(ra) # 5bc0 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3c06:	85ca                	mv	a1,s2
    3c08:	00004517          	auipc	a0,0x4
    3c0c:	cc050513          	addi	a0,a0,-832 # 78c8 <malloc+0x18a6>
    3c10:	00002097          	auipc	ra,0x2
    3c14:	35a080e7          	jalr	858(ra) # 5f6a <printf>
    exit(1);
    3c18:	4505                	li	a0,1
    3c1a:	00002097          	auipc	ra,0x2
    3c1e:	fa6080e7          	jalr	-90(ra) # 5bc0 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3c22:	85ca                	mv	a1,s2
    3c24:	00004517          	auipc	a0,0x4
    3c28:	ccc50513          	addi	a0,a0,-820 # 78f0 <malloc+0x18ce>
    3c2c:	00002097          	auipc	ra,0x2
    3c30:	33e080e7          	jalr	830(ra) # 5f6a <printf>
    exit(1);
    3c34:	4505                	li	a0,1
    3c36:	00002097          	auipc	ra,0x2
    3c3a:	f8a080e7          	jalr	-118(ra) # 5bc0 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3c3e:	85ca                	mv	a1,s2
    3c40:	00004517          	auipc	a0,0x4
    3c44:	cd050513          	addi	a0,a0,-816 # 7910 <malloc+0x18ee>
    3c48:	00002097          	auipc	ra,0x2
    3c4c:	322080e7          	jalr	802(ra) # 5f6a <printf>
    exit(1);
    3c50:	4505                	li	a0,1
    3c52:	00002097          	auipc	ra,0x2
    3c56:	f6e080e7          	jalr	-146(ra) # 5bc0 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3c5a:	85ca                	mv	a1,s2
    3c5c:	00004517          	auipc	a0,0x4
    3c60:	cd450513          	addi	a0,a0,-812 # 7930 <malloc+0x190e>
    3c64:	00002097          	auipc	ra,0x2
    3c68:	306080e7          	jalr	774(ra) # 5f6a <printf>
    exit(1);
    3c6c:	4505                	li	a0,1
    3c6e:	00002097          	auipc	ra,0x2
    3c72:	f52080e7          	jalr	-174(ra) # 5bc0 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3c76:	85ca                	mv	a1,s2
    3c78:	00004517          	auipc	a0,0x4
    3c7c:	ce050513          	addi	a0,a0,-800 # 7958 <malloc+0x1936>
    3c80:	00002097          	auipc	ra,0x2
    3c84:	2ea080e7          	jalr	746(ra) # 5f6a <printf>
    exit(1);
    3c88:	4505                	li	a0,1
    3c8a:	00002097          	auipc	ra,0x2
    3c8e:	f36080e7          	jalr	-202(ra) # 5bc0 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3c92:	85ca                	mv	a1,s2
    3c94:	00004517          	auipc	a0,0x4
    3c98:	95c50513          	addi	a0,a0,-1700 # 75f0 <malloc+0x15ce>
    3c9c:	00002097          	auipc	ra,0x2
    3ca0:	2ce080e7          	jalr	718(ra) # 5f6a <printf>
    exit(1);
    3ca4:	4505                	li	a0,1
    3ca6:	00002097          	auipc	ra,0x2
    3caa:	f1a080e7          	jalr	-230(ra) # 5bc0 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3cae:	85ca                	mv	a1,s2
    3cb0:	00004517          	auipc	a0,0x4
    3cb4:	cc850513          	addi	a0,a0,-824 # 7978 <malloc+0x1956>
    3cb8:	00002097          	auipc	ra,0x2
    3cbc:	2b2080e7          	jalr	690(ra) # 5f6a <printf>
    exit(1);
    3cc0:	4505                	li	a0,1
    3cc2:	00002097          	auipc	ra,0x2
    3cc6:	efe080e7          	jalr	-258(ra) # 5bc0 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3cca:	85ca                	mv	a1,s2
    3ccc:	00004517          	auipc	a0,0x4
    3cd0:	ccc50513          	addi	a0,a0,-820 # 7998 <malloc+0x1976>
    3cd4:	00002097          	auipc	ra,0x2
    3cd8:	296080e7          	jalr	662(ra) # 5f6a <printf>
    exit(1);
    3cdc:	4505                	li	a0,1
    3cde:	00002097          	auipc	ra,0x2
    3ce2:	ee2080e7          	jalr	-286(ra) # 5bc0 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3ce6:	85ca                	mv	a1,s2
    3ce8:	00004517          	auipc	a0,0x4
    3cec:	ce050513          	addi	a0,a0,-800 # 79c8 <malloc+0x19a6>
    3cf0:	00002097          	auipc	ra,0x2
    3cf4:	27a080e7          	jalr	634(ra) # 5f6a <printf>
    exit(1);
    3cf8:	4505                	li	a0,1
    3cfa:	00002097          	auipc	ra,0x2
    3cfe:	ec6080e7          	jalr	-314(ra) # 5bc0 <exit>
    printf("%s: unlink dd failed\n", s);
    3d02:	85ca                	mv	a1,s2
    3d04:	00004517          	auipc	a0,0x4
    3d08:	ce450513          	addi	a0,a0,-796 # 79e8 <malloc+0x19c6>
    3d0c:	00002097          	auipc	ra,0x2
    3d10:	25e080e7          	jalr	606(ra) # 5f6a <printf>
    exit(1);
    3d14:	4505                	li	a0,1
    3d16:	00002097          	auipc	ra,0x2
    3d1a:	eaa080e7          	jalr	-342(ra) # 5bc0 <exit>

0000000000003d1e <rmdot>:
{
    3d1e:	1101                	addi	sp,sp,-32
    3d20:	ec06                	sd	ra,24(sp)
    3d22:	e822                	sd	s0,16(sp)
    3d24:	e426                	sd	s1,8(sp)
    3d26:	1000                	addi	s0,sp,32
    3d28:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3d2a:	00004517          	auipc	a0,0x4
    3d2e:	cd650513          	addi	a0,a0,-810 # 7a00 <malloc+0x19de>
    3d32:	00002097          	auipc	ra,0x2
    3d36:	ef6080e7          	jalr	-266(ra) # 5c28 <mkdir>
    3d3a:	e549                	bnez	a0,3dc4 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3d3c:	00004517          	auipc	a0,0x4
    3d40:	cc450513          	addi	a0,a0,-828 # 7a00 <malloc+0x19de>
    3d44:	00002097          	auipc	ra,0x2
    3d48:	eec080e7          	jalr	-276(ra) # 5c30 <chdir>
    3d4c:	e951                	bnez	a0,3de0 <rmdot+0xc2>
  if(unlink(".") == 0){
    3d4e:	00003517          	auipc	a0,0x3
    3d52:	ae250513          	addi	a0,a0,-1310 # 6830 <malloc+0x80e>
    3d56:	00002097          	auipc	ra,0x2
    3d5a:	eba080e7          	jalr	-326(ra) # 5c10 <unlink>
    3d5e:	cd59                	beqz	a0,3dfc <rmdot+0xde>
  if(unlink("..") == 0){
    3d60:	00003517          	auipc	a0,0x3
    3d64:	6f850513          	addi	a0,a0,1784 # 7458 <malloc+0x1436>
    3d68:	00002097          	auipc	ra,0x2
    3d6c:	ea8080e7          	jalr	-344(ra) # 5c10 <unlink>
    3d70:	c545                	beqz	a0,3e18 <rmdot+0xfa>
  if(chdir("/") != 0){
    3d72:	00003517          	auipc	a0,0x3
    3d76:	68e50513          	addi	a0,a0,1678 # 7400 <malloc+0x13de>
    3d7a:	00002097          	auipc	ra,0x2
    3d7e:	eb6080e7          	jalr	-330(ra) # 5c30 <chdir>
    3d82:	e94d                	bnez	a0,3e34 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3d84:	00004517          	auipc	a0,0x4
    3d88:	ce450513          	addi	a0,a0,-796 # 7a68 <malloc+0x1a46>
    3d8c:	00002097          	auipc	ra,0x2
    3d90:	e84080e7          	jalr	-380(ra) # 5c10 <unlink>
    3d94:	cd55                	beqz	a0,3e50 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3d96:	00004517          	auipc	a0,0x4
    3d9a:	cfa50513          	addi	a0,a0,-774 # 7a90 <malloc+0x1a6e>
    3d9e:	00002097          	auipc	ra,0x2
    3da2:	e72080e7          	jalr	-398(ra) # 5c10 <unlink>
    3da6:	c179                	beqz	a0,3e6c <rmdot+0x14e>
  if(unlink("dots") != 0){
    3da8:	00004517          	auipc	a0,0x4
    3dac:	c5850513          	addi	a0,a0,-936 # 7a00 <malloc+0x19de>
    3db0:	00002097          	auipc	ra,0x2
    3db4:	e60080e7          	jalr	-416(ra) # 5c10 <unlink>
    3db8:	e961                	bnez	a0,3e88 <rmdot+0x16a>
}
    3dba:	60e2                	ld	ra,24(sp)
    3dbc:	6442                	ld	s0,16(sp)
    3dbe:	64a2                	ld	s1,8(sp)
    3dc0:	6105                	addi	sp,sp,32
    3dc2:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3dc4:	85a6                	mv	a1,s1
    3dc6:	00004517          	auipc	a0,0x4
    3dca:	c4250513          	addi	a0,a0,-958 # 7a08 <malloc+0x19e6>
    3dce:	00002097          	auipc	ra,0x2
    3dd2:	19c080e7          	jalr	412(ra) # 5f6a <printf>
    exit(1);
    3dd6:	4505                	li	a0,1
    3dd8:	00002097          	auipc	ra,0x2
    3ddc:	de8080e7          	jalr	-536(ra) # 5bc0 <exit>
    printf("%s: chdir dots failed\n", s);
    3de0:	85a6                	mv	a1,s1
    3de2:	00004517          	auipc	a0,0x4
    3de6:	c3e50513          	addi	a0,a0,-962 # 7a20 <malloc+0x19fe>
    3dea:	00002097          	auipc	ra,0x2
    3dee:	180080e7          	jalr	384(ra) # 5f6a <printf>
    exit(1);
    3df2:	4505                	li	a0,1
    3df4:	00002097          	auipc	ra,0x2
    3df8:	dcc080e7          	jalr	-564(ra) # 5bc0 <exit>
    printf("%s: rm . worked!\n", s);
    3dfc:	85a6                	mv	a1,s1
    3dfe:	00004517          	auipc	a0,0x4
    3e02:	c3a50513          	addi	a0,a0,-966 # 7a38 <malloc+0x1a16>
    3e06:	00002097          	auipc	ra,0x2
    3e0a:	164080e7          	jalr	356(ra) # 5f6a <printf>
    exit(1);
    3e0e:	4505                	li	a0,1
    3e10:	00002097          	auipc	ra,0x2
    3e14:	db0080e7          	jalr	-592(ra) # 5bc0 <exit>
    printf("%s: rm .. worked!\n", s);
    3e18:	85a6                	mv	a1,s1
    3e1a:	00004517          	auipc	a0,0x4
    3e1e:	c3650513          	addi	a0,a0,-970 # 7a50 <malloc+0x1a2e>
    3e22:	00002097          	auipc	ra,0x2
    3e26:	148080e7          	jalr	328(ra) # 5f6a <printf>
    exit(1);
    3e2a:	4505                	li	a0,1
    3e2c:	00002097          	auipc	ra,0x2
    3e30:	d94080e7          	jalr	-620(ra) # 5bc0 <exit>
    printf("%s: chdir / failed\n", s);
    3e34:	85a6                	mv	a1,s1
    3e36:	00003517          	auipc	a0,0x3
    3e3a:	5d250513          	addi	a0,a0,1490 # 7408 <malloc+0x13e6>
    3e3e:	00002097          	auipc	ra,0x2
    3e42:	12c080e7          	jalr	300(ra) # 5f6a <printf>
    exit(1);
    3e46:	4505                	li	a0,1
    3e48:	00002097          	auipc	ra,0x2
    3e4c:	d78080e7          	jalr	-648(ra) # 5bc0 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3e50:	85a6                	mv	a1,s1
    3e52:	00004517          	auipc	a0,0x4
    3e56:	c1e50513          	addi	a0,a0,-994 # 7a70 <malloc+0x1a4e>
    3e5a:	00002097          	auipc	ra,0x2
    3e5e:	110080e7          	jalr	272(ra) # 5f6a <printf>
    exit(1);
    3e62:	4505                	li	a0,1
    3e64:	00002097          	auipc	ra,0x2
    3e68:	d5c080e7          	jalr	-676(ra) # 5bc0 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3e6c:	85a6                	mv	a1,s1
    3e6e:	00004517          	auipc	a0,0x4
    3e72:	c2a50513          	addi	a0,a0,-982 # 7a98 <malloc+0x1a76>
    3e76:	00002097          	auipc	ra,0x2
    3e7a:	0f4080e7          	jalr	244(ra) # 5f6a <printf>
    exit(1);
    3e7e:	4505                	li	a0,1
    3e80:	00002097          	auipc	ra,0x2
    3e84:	d40080e7          	jalr	-704(ra) # 5bc0 <exit>
    printf("%s: unlink dots failed!\n", s);
    3e88:	85a6                	mv	a1,s1
    3e8a:	00004517          	auipc	a0,0x4
    3e8e:	c2e50513          	addi	a0,a0,-978 # 7ab8 <malloc+0x1a96>
    3e92:	00002097          	auipc	ra,0x2
    3e96:	0d8080e7          	jalr	216(ra) # 5f6a <printf>
    exit(1);
    3e9a:	4505                	li	a0,1
    3e9c:	00002097          	auipc	ra,0x2
    3ea0:	d24080e7          	jalr	-732(ra) # 5bc0 <exit>

0000000000003ea4 <dirfile>:
{
    3ea4:	1101                	addi	sp,sp,-32
    3ea6:	ec06                	sd	ra,24(sp)
    3ea8:	e822                	sd	s0,16(sp)
    3eaa:	e426                	sd	s1,8(sp)
    3eac:	e04a                	sd	s2,0(sp)
    3eae:	1000                	addi	s0,sp,32
    3eb0:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3eb2:	20000593          	li	a1,512
    3eb6:	00004517          	auipc	a0,0x4
    3eba:	c2250513          	addi	a0,a0,-990 # 7ad8 <malloc+0x1ab6>
    3ebe:	00002097          	auipc	ra,0x2
    3ec2:	d42080e7          	jalr	-702(ra) # 5c00 <open>
  if(fd < 0){
    3ec6:	0e054d63          	bltz	a0,3fc0 <dirfile+0x11c>
  close(fd);
    3eca:	00002097          	auipc	ra,0x2
    3ece:	d1e080e7          	jalr	-738(ra) # 5be8 <close>
  if(chdir("dirfile") == 0){
    3ed2:	00004517          	auipc	a0,0x4
    3ed6:	c0650513          	addi	a0,a0,-1018 # 7ad8 <malloc+0x1ab6>
    3eda:	00002097          	auipc	ra,0x2
    3ede:	d56080e7          	jalr	-682(ra) # 5c30 <chdir>
    3ee2:	cd6d                	beqz	a0,3fdc <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3ee4:	4581                	li	a1,0
    3ee6:	00004517          	auipc	a0,0x4
    3eea:	c3a50513          	addi	a0,a0,-966 # 7b20 <malloc+0x1afe>
    3eee:	00002097          	auipc	ra,0x2
    3ef2:	d12080e7          	jalr	-750(ra) # 5c00 <open>
  if(fd >= 0){
    3ef6:	10055163          	bgez	a0,3ff8 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3efa:	20000593          	li	a1,512
    3efe:	00004517          	auipc	a0,0x4
    3f02:	c2250513          	addi	a0,a0,-990 # 7b20 <malloc+0x1afe>
    3f06:	00002097          	auipc	ra,0x2
    3f0a:	cfa080e7          	jalr	-774(ra) # 5c00 <open>
  if(fd >= 0){
    3f0e:	10055363          	bgez	a0,4014 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3f12:	00004517          	auipc	a0,0x4
    3f16:	c0e50513          	addi	a0,a0,-1010 # 7b20 <malloc+0x1afe>
    3f1a:	00002097          	auipc	ra,0x2
    3f1e:	d0e080e7          	jalr	-754(ra) # 5c28 <mkdir>
    3f22:	10050763          	beqz	a0,4030 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3f26:	00004517          	auipc	a0,0x4
    3f2a:	bfa50513          	addi	a0,a0,-1030 # 7b20 <malloc+0x1afe>
    3f2e:	00002097          	auipc	ra,0x2
    3f32:	ce2080e7          	jalr	-798(ra) # 5c10 <unlink>
    3f36:	10050b63          	beqz	a0,404c <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3f3a:	00004597          	auipc	a1,0x4
    3f3e:	be658593          	addi	a1,a1,-1050 # 7b20 <malloc+0x1afe>
    3f42:	00002517          	auipc	a0,0x2
    3f46:	3de50513          	addi	a0,a0,990 # 6320 <malloc+0x2fe>
    3f4a:	00002097          	auipc	ra,0x2
    3f4e:	cd6080e7          	jalr	-810(ra) # 5c20 <link>
    3f52:	10050b63          	beqz	a0,4068 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3f56:	00004517          	auipc	a0,0x4
    3f5a:	b8250513          	addi	a0,a0,-1150 # 7ad8 <malloc+0x1ab6>
    3f5e:	00002097          	auipc	ra,0x2
    3f62:	cb2080e7          	jalr	-846(ra) # 5c10 <unlink>
    3f66:	10051f63          	bnez	a0,4084 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3f6a:	4589                	li	a1,2
    3f6c:	00003517          	auipc	a0,0x3
    3f70:	8c450513          	addi	a0,a0,-1852 # 6830 <malloc+0x80e>
    3f74:	00002097          	auipc	ra,0x2
    3f78:	c8c080e7          	jalr	-884(ra) # 5c00 <open>
  if(fd >= 0){
    3f7c:	12055263          	bgez	a0,40a0 <dirfile+0x1fc>
  fd = open(".", 0);
    3f80:	4581                	li	a1,0
    3f82:	00003517          	auipc	a0,0x3
    3f86:	8ae50513          	addi	a0,a0,-1874 # 6830 <malloc+0x80e>
    3f8a:	00002097          	auipc	ra,0x2
    3f8e:	c76080e7          	jalr	-906(ra) # 5c00 <open>
    3f92:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3f94:	4605                	li	a2,1
    3f96:	00002597          	auipc	a1,0x2
    3f9a:	22258593          	addi	a1,a1,546 # 61b8 <malloc+0x196>
    3f9e:	00002097          	auipc	ra,0x2
    3fa2:	c42080e7          	jalr	-958(ra) # 5be0 <write>
    3fa6:	10a04b63          	bgtz	a0,40bc <dirfile+0x218>
  close(fd);
    3faa:	8526                	mv	a0,s1
    3fac:	00002097          	auipc	ra,0x2
    3fb0:	c3c080e7          	jalr	-964(ra) # 5be8 <close>
}
    3fb4:	60e2                	ld	ra,24(sp)
    3fb6:	6442                	ld	s0,16(sp)
    3fb8:	64a2                	ld	s1,8(sp)
    3fba:	6902                	ld	s2,0(sp)
    3fbc:	6105                	addi	sp,sp,32
    3fbe:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3fc0:	85ca                	mv	a1,s2
    3fc2:	00004517          	auipc	a0,0x4
    3fc6:	b1e50513          	addi	a0,a0,-1250 # 7ae0 <malloc+0x1abe>
    3fca:	00002097          	auipc	ra,0x2
    3fce:	fa0080e7          	jalr	-96(ra) # 5f6a <printf>
    exit(1);
    3fd2:	4505                	li	a0,1
    3fd4:	00002097          	auipc	ra,0x2
    3fd8:	bec080e7          	jalr	-1044(ra) # 5bc0 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3fdc:	85ca                	mv	a1,s2
    3fde:	00004517          	auipc	a0,0x4
    3fe2:	b2250513          	addi	a0,a0,-1246 # 7b00 <malloc+0x1ade>
    3fe6:	00002097          	auipc	ra,0x2
    3fea:	f84080e7          	jalr	-124(ra) # 5f6a <printf>
    exit(1);
    3fee:	4505                	li	a0,1
    3ff0:	00002097          	auipc	ra,0x2
    3ff4:	bd0080e7          	jalr	-1072(ra) # 5bc0 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3ff8:	85ca                	mv	a1,s2
    3ffa:	00004517          	auipc	a0,0x4
    3ffe:	b3650513          	addi	a0,a0,-1226 # 7b30 <malloc+0x1b0e>
    4002:	00002097          	auipc	ra,0x2
    4006:	f68080e7          	jalr	-152(ra) # 5f6a <printf>
    exit(1);
    400a:	4505                	li	a0,1
    400c:	00002097          	auipc	ra,0x2
    4010:	bb4080e7          	jalr	-1100(ra) # 5bc0 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4014:	85ca                	mv	a1,s2
    4016:	00004517          	auipc	a0,0x4
    401a:	b1a50513          	addi	a0,a0,-1254 # 7b30 <malloc+0x1b0e>
    401e:	00002097          	auipc	ra,0x2
    4022:	f4c080e7          	jalr	-180(ra) # 5f6a <printf>
    exit(1);
    4026:	4505                	li	a0,1
    4028:	00002097          	auipc	ra,0x2
    402c:	b98080e7          	jalr	-1128(ra) # 5bc0 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4030:	85ca                	mv	a1,s2
    4032:	00004517          	auipc	a0,0x4
    4036:	b2650513          	addi	a0,a0,-1242 # 7b58 <malloc+0x1b36>
    403a:	00002097          	auipc	ra,0x2
    403e:	f30080e7          	jalr	-208(ra) # 5f6a <printf>
    exit(1);
    4042:	4505                	li	a0,1
    4044:	00002097          	auipc	ra,0x2
    4048:	b7c080e7          	jalr	-1156(ra) # 5bc0 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    404c:	85ca                	mv	a1,s2
    404e:	00004517          	auipc	a0,0x4
    4052:	b3250513          	addi	a0,a0,-1230 # 7b80 <malloc+0x1b5e>
    4056:	00002097          	auipc	ra,0x2
    405a:	f14080e7          	jalr	-236(ra) # 5f6a <printf>
    exit(1);
    405e:	4505                	li	a0,1
    4060:	00002097          	auipc	ra,0x2
    4064:	b60080e7          	jalr	-1184(ra) # 5bc0 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    4068:	85ca                	mv	a1,s2
    406a:	00004517          	auipc	a0,0x4
    406e:	b3e50513          	addi	a0,a0,-1218 # 7ba8 <malloc+0x1b86>
    4072:	00002097          	auipc	ra,0x2
    4076:	ef8080e7          	jalr	-264(ra) # 5f6a <printf>
    exit(1);
    407a:	4505                	li	a0,1
    407c:	00002097          	auipc	ra,0x2
    4080:	b44080e7          	jalr	-1212(ra) # 5bc0 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    4084:	85ca                	mv	a1,s2
    4086:	00004517          	auipc	a0,0x4
    408a:	b4a50513          	addi	a0,a0,-1206 # 7bd0 <malloc+0x1bae>
    408e:	00002097          	auipc	ra,0x2
    4092:	edc080e7          	jalr	-292(ra) # 5f6a <printf>
    exit(1);
    4096:	4505                	li	a0,1
    4098:	00002097          	auipc	ra,0x2
    409c:	b28080e7          	jalr	-1240(ra) # 5bc0 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    40a0:	85ca                	mv	a1,s2
    40a2:	00004517          	auipc	a0,0x4
    40a6:	b4e50513          	addi	a0,a0,-1202 # 7bf0 <malloc+0x1bce>
    40aa:	00002097          	auipc	ra,0x2
    40ae:	ec0080e7          	jalr	-320(ra) # 5f6a <printf>
    exit(1);
    40b2:	4505                	li	a0,1
    40b4:	00002097          	auipc	ra,0x2
    40b8:	b0c080e7          	jalr	-1268(ra) # 5bc0 <exit>
    printf("%s: write . succeeded!\n", s);
    40bc:	85ca                	mv	a1,s2
    40be:	00004517          	auipc	a0,0x4
    40c2:	b5a50513          	addi	a0,a0,-1190 # 7c18 <malloc+0x1bf6>
    40c6:	00002097          	auipc	ra,0x2
    40ca:	ea4080e7          	jalr	-348(ra) # 5f6a <printf>
    exit(1);
    40ce:	4505                	li	a0,1
    40d0:	00002097          	auipc	ra,0x2
    40d4:	af0080e7          	jalr	-1296(ra) # 5bc0 <exit>

00000000000040d8 <iref>:
{
    40d8:	7139                	addi	sp,sp,-64
    40da:	fc06                	sd	ra,56(sp)
    40dc:	f822                	sd	s0,48(sp)
    40de:	f426                	sd	s1,40(sp)
    40e0:	f04a                	sd	s2,32(sp)
    40e2:	ec4e                	sd	s3,24(sp)
    40e4:	e852                	sd	s4,16(sp)
    40e6:	e456                	sd	s5,8(sp)
    40e8:	e05a                	sd	s6,0(sp)
    40ea:	0080                	addi	s0,sp,64
    40ec:	8b2a                	mv	s6,a0
    40ee:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    40f2:	00004a17          	auipc	s4,0x4
    40f6:	b3ea0a13          	addi	s4,s4,-1218 # 7c30 <malloc+0x1c0e>
    mkdir("");
    40fa:	00003497          	auipc	s1,0x3
    40fe:	63e48493          	addi	s1,s1,1598 # 7738 <malloc+0x1716>
    link("README", "");
    4102:	00002a97          	auipc	s5,0x2
    4106:	21ea8a93          	addi	s5,s5,542 # 6320 <malloc+0x2fe>
    fd = open("xx", O_CREATE);
    410a:	00004997          	auipc	s3,0x4
    410e:	a1e98993          	addi	s3,s3,-1506 # 7b28 <malloc+0x1b06>
    4112:	a891                	j	4166 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    4114:	85da                	mv	a1,s6
    4116:	00004517          	auipc	a0,0x4
    411a:	b2250513          	addi	a0,a0,-1246 # 7c38 <malloc+0x1c16>
    411e:	00002097          	auipc	ra,0x2
    4122:	e4c080e7          	jalr	-436(ra) # 5f6a <printf>
      exit(1);
    4126:	4505                	li	a0,1
    4128:	00002097          	auipc	ra,0x2
    412c:	a98080e7          	jalr	-1384(ra) # 5bc0 <exit>
      printf("%s: chdir irefd failed\n", s);
    4130:	85da                	mv	a1,s6
    4132:	00004517          	auipc	a0,0x4
    4136:	b1e50513          	addi	a0,a0,-1250 # 7c50 <malloc+0x1c2e>
    413a:	00002097          	auipc	ra,0x2
    413e:	e30080e7          	jalr	-464(ra) # 5f6a <printf>
      exit(1);
    4142:	4505                	li	a0,1
    4144:	00002097          	auipc	ra,0x2
    4148:	a7c080e7          	jalr	-1412(ra) # 5bc0 <exit>
      close(fd);
    414c:	00002097          	auipc	ra,0x2
    4150:	a9c080e7          	jalr	-1380(ra) # 5be8 <close>
    4154:	a889                	j	41a6 <iref+0xce>
    unlink("xx");
    4156:	854e                	mv	a0,s3
    4158:	00002097          	auipc	ra,0x2
    415c:	ab8080e7          	jalr	-1352(ra) # 5c10 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4160:	397d                	addiw	s2,s2,-1
    4162:	06090063          	beqz	s2,41c2 <iref+0xea>
    if(mkdir("irefd") != 0){
    4166:	8552                	mv	a0,s4
    4168:	00002097          	auipc	ra,0x2
    416c:	ac0080e7          	jalr	-1344(ra) # 5c28 <mkdir>
    4170:	f155                	bnez	a0,4114 <iref+0x3c>
    if(chdir("irefd") != 0){
    4172:	8552                	mv	a0,s4
    4174:	00002097          	auipc	ra,0x2
    4178:	abc080e7          	jalr	-1348(ra) # 5c30 <chdir>
    417c:	f955                	bnez	a0,4130 <iref+0x58>
    mkdir("");
    417e:	8526                	mv	a0,s1
    4180:	00002097          	auipc	ra,0x2
    4184:	aa8080e7          	jalr	-1368(ra) # 5c28 <mkdir>
    link("README", "");
    4188:	85a6                	mv	a1,s1
    418a:	8556                	mv	a0,s5
    418c:	00002097          	auipc	ra,0x2
    4190:	a94080e7          	jalr	-1388(ra) # 5c20 <link>
    fd = open("", O_CREATE);
    4194:	20000593          	li	a1,512
    4198:	8526                	mv	a0,s1
    419a:	00002097          	auipc	ra,0x2
    419e:	a66080e7          	jalr	-1434(ra) # 5c00 <open>
    if(fd >= 0)
    41a2:	fa0555e3          	bgez	a0,414c <iref+0x74>
    fd = open("xx", O_CREATE);
    41a6:	20000593          	li	a1,512
    41aa:	854e                	mv	a0,s3
    41ac:	00002097          	auipc	ra,0x2
    41b0:	a54080e7          	jalr	-1452(ra) # 5c00 <open>
    if(fd >= 0)
    41b4:	fa0541e3          	bltz	a0,4156 <iref+0x7e>
      close(fd);
    41b8:	00002097          	auipc	ra,0x2
    41bc:	a30080e7          	jalr	-1488(ra) # 5be8 <close>
    41c0:	bf59                	j	4156 <iref+0x7e>
    41c2:	03300493          	li	s1,51
    chdir("..");
    41c6:	00003997          	auipc	s3,0x3
    41ca:	29298993          	addi	s3,s3,658 # 7458 <malloc+0x1436>
    unlink("irefd");
    41ce:	00004917          	auipc	s2,0x4
    41d2:	a6290913          	addi	s2,s2,-1438 # 7c30 <malloc+0x1c0e>
    chdir("..");
    41d6:	854e                	mv	a0,s3
    41d8:	00002097          	auipc	ra,0x2
    41dc:	a58080e7          	jalr	-1448(ra) # 5c30 <chdir>
    unlink("irefd");
    41e0:	854a                	mv	a0,s2
    41e2:	00002097          	auipc	ra,0x2
    41e6:	a2e080e7          	jalr	-1490(ra) # 5c10 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    41ea:	34fd                	addiw	s1,s1,-1
    41ec:	f4ed                	bnez	s1,41d6 <iref+0xfe>
  chdir("/");
    41ee:	00003517          	auipc	a0,0x3
    41f2:	21250513          	addi	a0,a0,530 # 7400 <malloc+0x13de>
    41f6:	00002097          	auipc	ra,0x2
    41fa:	a3a080e7          	jalr	-1478(ra) # 5c30 <chdir>
}
    41fe:	70e2                	ld	ra,56(sp)
    4200:	7442                	ld	s0,48(sp)
    4202:	74a2                	ld	s1,40(sp)
    4204:	7902                	ld	s2,32(sp)
    4206:	69e2                	ld	s3,24(sp)
    4208:	6a42                	ld	s4,16(sp)
    420a:	6aa2                	ld	s5,8(sp)
    420c:	6b02                	ld	s6,0(sp)
    420e:	6121                	addi	sp,sp,64
    4210:	8082                	ret

0000000000004212 <openiputtest>:
{
    4212:	7179                	addi	sp,sp,-48
    4214:	f406                	sd	ra,40(sp)
    4216:	f022                	sd	s0,32(sp)
    4218:	ec26                	sd	s1,24(sp)
    421a:	1800                	addi	s0,sp,48
    421c:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    421e:	00004517          	auipc	a0,0x4
    4222:	a4a50513          	addi	a0,a0,-1462 # 7c68 <malloc+0x1c46>
    4226:	00002097          	auipc	ra,0x2
    422a:	a02080e7          	jalr	-1534(ra) # 5c28 <mkdir>
    422e:	04054263          	bltz	a0,4272 <openiputtest+0x60>
  pid = fork();
    4232:	00002097          	auipc	ra,0x2
    4236:	986080e7          	jalr	-1658(ra) # 5bb8 <fork>
  if(pid < 0){
    423a:	04054a63          	bltz	a0,428e <openiputtest+0x7c>
  if(pid == 0){
    423e:	e93d                	bnez	a0,42b4 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4240:	4589                	li	a1,2
    4242:	00004517          	auipc	a0,0x4
    4246:	a2650513          	addi	a0,a0,-1498 # 7c68 <malloc+0x1c46>
    424a:	00002097          	auipc	ra,0x2
    424e:	9b6080e7          	jalr	-1610(ra) # 5c00 <open>
    if(fd >= 0){
    4252:	04054c63          	bltz	a0,42aa <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    4256:	85a6                	mv	a1,s1
    4258:	00004517          	auipc	a0,0x4
    425c:	a3050513          	addi	a0,a0,-1488 # 7c88 <malloc+0x1c66>
    4260:	00002097          	auipc	ra,0x2
    4264:	d0a080e7          	jalr	-758(ra) # 5f6a <printf>
      exit(1);
    4268:	4505                	li	a0,1
    426a:	00002097          	auipc	ra,0x2
    426e:	956080e7          	jalr	-1706(ra) # 5bc0 <exit>
    printf("%s: mkdir oidir failed\n", s);
    4272:	85a6                	mv	a1,s1
    4274:	00004517          	auipc	a0,0x4
    4278:	9fc50513          	addi	a0,a0,-1540 # 7c70 <malloc+0x1c4e>
    427c:	00002097          	auipc	ra,0x2
    4280:	cee080e7          	jalr	-786(ra) # 5f6a <printf>
    exit(1);
    4284:	4505                	li	a0,1
    4286:	00002097          	auipc	ra,0x2
    428a:	93a080e7          	jalr	-1734(ra) # 5bc0 <exit>
    printf("%s: fork failed\n", s);
    428e:	85a6                	mv	a1,s1
    4290:	00002517          	auipc	a0,0x2
    4294:	74050513          	addi	a0,a0,1856 # 69d0 <malloc+0x9ae>
    4298:	00002097          	auipc	ra,0x2
    429c:	cd2080e7          	jalr	-814(ra) # 5f6a <printf>
    exit(1);
    42a0:	4505                	li	a0,1
    42a2:	00002097          	auipc	ra,0x2
    42a6:	91e080e7          	jalr	-1762(ra) # 5bc0 <exit>
    exit(0);
    42aa:	4501                	li	a0,0
    42ac:	00002097          	auipc	ra,0x2
    42b0:	914080e7          	jalr	-1772(ra) # 5bc0 <exit>
  sleep(1);
    42b4:	4505                	li	a0,1
    42b6:	00002097          	auipc	ra,0x2
    42ba:	99a080e7          	jalr	-1638(ra) # 5c50 <sleep>
  if(unlink("oidir") != 0){
    42be:	00004517          	auipc	a0,0x4
    42c2:	9aa50513          	addi	a0,a0,-1622 # 7c68 <malloc+0x1c46>
    42c6:	00002097          	auipc	ra,0x2
    42ca:	94a080e7          	jalr	-1718(ra) # 5c10 <unlink>
    42ce:	cd19                	beqz	a0,42ec <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    42d0:	85a6                	mv	a1,s1
    42d2:	00003517          	auipc	a0,0x3
    42d6:	8ee50513          	addi	a0,a0,-1810 # 6bc0 <malloc+0xb9e>
    42da:	00002097          	auipc	ra,0x2
    42de:	c90080e7          	jalr	-880(ra) # 5f6a <printf>
    exit(1);
    42e2:	4505                	li	a0,1
    42e4:	00002097          	auipc	ra,0x2
    42e8:	8dc080e7          	jalr	-1828(ra) # 5bc0 <exit>
  wait(&xstatus);
    42ec:	fdc40513          	addi	a0,s0,-36
    42f0:	00002097          	auipc	ra,0x2
    42f4:	8d8080e7          	jalr	-1832(ra) # 5bc8 <wait>
  exit(xstatus);
    42f8:	fdc42503          	lw	a0,-36(s0)
    42fc:	00002097          	auipc	ra,0x2
    4300:	8c4080e7          	jalr	-1852(ra) # 5bc0 <exit>

0000000000004304 <forkforkfork>:
{
    4304:	1101                	addi	sp,sp,-32
    4306:	ec06                	sd	ra,24(sp)
    4308:	e822                	sd	s0,16(sp)
    430a:	e426                	sd	s1,8(sp)
    430c:	1000                	addi	s0,sp,32
    430e:	84aa                	mv	s1,a0
  unlink("stopforking");
    4310:	00004517          	auipc	a0,0x4
    4314:	9a050513          	addi	a0,a0,-1632 # 7cb0 <malloc+0x1c8e>
    4318:	00002097          	auipc	ra,0x2
    431c:	8f8080e7          	jalr	-1800(ra) # 5c10 <unlink>
  int pid = fork();
    4320:	00002097          	auipc	ra,0x2
    4324:	898080e7          	jalr	-1896(ra) # 5bb8 <fork>
  if(pid < 0){
    4328:	04054563          	bltz	a0,4372 <forkforkfork+0x6e>
  if(pid == 0){
    432c:	c12d                	beqz	a0,438e <forkforkfork+0x8a>
  sleep(20); // two seconds
    432e:	4551                	li	a0,20
    4330:	00002097          	auipc	ra,0x2
    4334:	920080e7          	jalr	-1760(ra) # 5c50 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    4338:	20200593          	li	a1,514
    433c:	00004517          	auipc	a0,0x4
    4340:	97450513          	addi	a0,a0,-1676 # 7cb0 <malloc+0x1c8e>
    4344:	00002097          	auipc	ra,0x2
    4348:	8bc080e7          	jalr	-1860(ra) # 5c00 <open>
    434c:	00002097          	auipc	ra,0x2
    4350:	89c080e7          	jalr	-1892(ra) # 5be8 <close>
  wait(0);
    4354:	4501                	li	a0,0
    4356:	00002097          	auipc	ra,0x2
    435a:	872080e7          	jalr	-1934(ra) # 5bc8 <wait>
  sleep(10); // one second
    435e:	4529                	li	a0,10
    4360:	00002097          	auipc	ra,0x2
    4364:	8f0080e7          	jalr	-1808(ra) # 5c50 <sleep>
}
    4368:	60e2                	ld	ra,24(sp)
    436a:	6442                	ld	s0,16(sp)
    436c:	64a2                	ld	s1,8(sp)
    436e:	6105                	addi	sp,sp,32
    4370:	8082                	ret
    printf("%s: fork failed", s);
    4372:	85a6                	mv	a1,s1
    4374:	00003517          	auipc	a0,0x3
    4378:	81c50513          	addi	a0,a0,-2020 # 6b90 <malloc+0xb6e>
    437c:	00002097          	auipc	ra,0x2
    4380:	bee080e7          	jalr	-1042(ra) # 5f6a <printf>
    exit(1);
    4384:	4505                	li	a0,1
    4386:	00002097          	auipc	ra,0x2
    438a:	83a080e7          	jalr	-1990(ra) # 5bc0 <exit>
      int fd = open("stopforking", 0);
    438e:	00004497          	auipc	s1,0x4
    4392:	92248493          	addi	s1,s1,-1758 # 7cb0 <malloc+0x1c8e>
    4396:	4581                	li	a1,0
    4398:	8526                	mv	a0,s1
    439a:	00002097          	auipc	ra,0x2
    439e:	866080e7          	jalr	-1946(ra) # 5c00 <open>
      if(fd >= 0){
    43a2:	02055463          	bgez	a0,43ca <forkforkfork+0xc6>
      if(fork() < 0){
    43a6:	00002097          	auipc	ra,0x2
    43aa:	812080e7          	jalr	-2030(ra) # 5bb8 <fork>
    43ae:	fe0554e3          	bgez	a0,4396 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    43b2:	20200593          	li	a1,514
    43b6:	8526                	mv	a0,s1
    43b8:	00002097          	auipc	ra,0x2
    43bc:	848080e7          	jalr	-1976(ra) # 5c00 <open>
    43c0:	00002097          	auipc	ra,0x2
    43c4:	828080e7          	jalr	-2008(ra) # 5be8 <close>
    43c8:	b7f9                	j	4396 <forkforkfork+0x92>
        exit(0);
    43ca:	4501                	li	a0,0
    43cc:	00001097          	auipc	ra,0x1
    43d0:	7f4080e7          	jalr	2036(ra) # 5bc0 <exit>

00000000000043d4 <killstatus>:
{
    43d4:	7139                	addi	sp,sp,-64
    43d6:	fc06                	sd	ra,56(sp)
    43d8:	f822                	sd	s0,48(sp)
    43da:	f426                	sd	s1,40(sp)
    43dc:	f04a                	sd	s2,32(sp)
    43de:	ec4e                	sd	s3,24(sp)
    43e0:	e852                	sd	s4,16(sp)
    43e2:	0080                	addi	s0,sp,64
    43e4:	8a2a                	mv	s4,a0
    43e6:	06400913          	li	s2,100
    if(xst != -1) {
    43ea:	59fd                	li	s3,-1
    int pid1 = fork();
    43ec:	00001097          	auipc	ra,0x1
    43f0:	7cc080e7          	jalr	1996(ra) # 5bb8 <fork>
    43f4:	84aa                	mv	s1,a0
    if(pid1 < 0){
    43f6:	02054f63          	bltz	a0,4434 <killstatus+0x60>
    if(pid1 == 0){
    43fa:	c939                	beqz	a0,4450 <killstatus+0x7c>
    sleep(1);
    43fc:	4505                	li	a0,1
    43fe:	00002097          	auipc	ra,0x2
    4402:	852080e7          	jalr	-1966(ra) # 5c50 <sleep>
    kill(pid1);
    4406:	8526                	mv	a0,s1
    4408:	00001097          	auipc	ra,0x1
    440c:	7e8080e7          	jalr	2024(ra) # 5bf0 <kill>
    wait(&xst);
    4410:	fcc40513          	addi	a0,s0,-52
    4414:	00001097          	auipc	ra,0x1
    4418:	7b4080e7          	jalr	1972(ra) # 5bc8 <wait>
    if(xst != -1) {
    441c:	fcc42783          	lw	a5,-52(s0)
    4420:	03379d63          	bne	a5,s3,445a <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    4424:	397d                	addiw	s2,s2,-1
    4426:	fc0913e3          	bnez	s2,43ec <killstatus+0x18>
  exit(0);
    442a:	4501                	li	a0,0
    442c:	00001097          	auipc	ra,0x1
    4430:	794080e7          	jalr	1940(ra) # 5bc0 <exit>
      printf("%s: fork failed\n", s);
    4434:	85d2                	mv	a1,s4
    4436:	00002517          	auipc	a0,0x2
    443a:	59a50513          	addi	a0,a0,1434 # 69d0 <malloc+0x9ae>
    443e:	00002097          	auipc	ra,0x2
    4442:	b2c080e7          	jalr	-1236(ra) # 5f6a <printf>
      exit(1);
    4446:	4505                	li	a0,1
    4448:	00001097          	auipc	ra,0x1
    444c:	778080e7          	jalr	1912(ra) # 5bc0 <exit>
        getpid();
    4450:	00001097          	auipc	ra,0x1
    4454:	7f0080e7          	jalr	2032(ra) # 5c40 <getpid>
      while(1) {
    4458:	bfe5                	j	4450 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    445a:	85d2                	mv	a1,s4
    445c:	00004517          	auipc	a0,0x4
    4460:	86450513          	addi	a0,a0,-1948 # 7cc0 <malloc+0x1c9e>
    4464:	00002097          	auipc	ra,0x2
    4468:	b06080e7          	jalr	-1274(ra) # 5f6a <printf>
       exit(1);
    446c:	4505                	li	a0,1
    446e:	00001097          	auipc	ra,0x1
    4472:	752080e7          	jalr	1874(ra) # 5bc0 <exit>

0000000000004476 <preempt>:
{
    4476:	7139                	addi	sp,sp,-64
    4478:	fc06                	sd	ra,56(sp)
    447a:	f822                	sd	s0,48(sp)
    447c:	f426                	sd	s1,40(sp)
    447e:	f04a                	sd	s2,32(sp)
    4480:	ec4e                	sd	s3,24(sp)
    4482:	e852                	sd	s4,16(sp)
    4484:	0080                	addi	s0,sp,64
    4486:	892a                	mv	s2,a0
  pid1 = fork();
    4488:	00001097          	auipc	ra,0x1
    448c:	730080e7          	jalr	1840(ra) # 5bb8 <fork>
  if(pid1 < 0) {
    4490:	00054563          	bltz	a0,449a <preempt+0x24>
    4494:	84aa                	mv	s1,a0
  if(pid1 == 0)
    4496:	e105                	bnez	a0,44b6 <preempt+0x40>
    for(;;)
    4498:	a001                	j	4498 <preempt+0x22>
    printf("%s: fork failed", s);
    449a:	85ca                	mv	a1,s2
    449c:	00002517          	auipc	a0,0x2
    44a0:	6f450513          	addi	a0,a0,1780 # 6b90 <malloc+0xb6e>
    44a4:	00002097          	auipc	ra,0x2
    44a8:	ac6080e7          	jalr	-1338(ra) # 5f6a <printf>
    exit(1);
    44ac:	4505                	li	a0,1
    44ae:	00001097          	auipc	ra,0x1
    44b2:	712080e7          	jalr	1810(ra) # 5bc0 <exit>
  pid2 = fork();
    44b6:	00001097          	auipc	ra,0x1
    44ba:	702080e7          	jalr	1794(ra) # 5bb8 <fork>
    44be:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    44c0:	00054463          	bltz	a0,44c8 <preempt+0x52>
  if(pid2 == 0)
    44c4:	e105                	bnez	a0,44e4 <preempt+0x6e>
    for(;;)
    44c6:	a001                	j	44c6 <preempt+0x50>
    printf("%s: fork failed\n", s);
    44c8:	85ca                	mv	a1,s2
    44ca:	00002517          	auipc	a0,0x2
    44ce:	50650513          	addi	a0,a0,1286 # 69d0 <malloc+0x9ae>
    44d2:	00002097          	auipc	ra,0x2
    44d6:	a98080e7          	jalr	-1384(ra) # 5f6a <printf>
    exit(1);
    44da:	4505                	li	a0,1
    44dc:	00001097          	auipc	ra,0x1
    44e0:	6e4080e7          	jalr	1764(ra) # 5bc0 <exit>
  pipe(pfds);
    44e4:	fc840513          	addi	a0,s0,-56
    44e8:	00001097          	auipc	ra,0x1
    44ec:	6e8080e7          	jalr	1768(ra) # 5bd0 <pipe>
  pid3 = fork();
    44f0:	00001097          	auipc	ra,0x1
    44f4:	6c8080e7          	jalr	1736(ra) # 5bb8 <fork>
    44f8:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    44fa:	02054e63          	bltz	a0,4536 <preempt+0xc0>
  if(pid3 == 0){
    44fe:	e525                	bnez	a0,4566 <preempt+0xf0>
    close(pfds[0]);
    4500:	fc842503          	lw	a0,-56(s0)
    4504:	00001097          	auipc	ra,0x1
    4508:	6e4080e7          	jalr	1764(ra) # 5be8 <close>
    if(write(pfds[1], "x", 1) != 1)
    450c:	4605                	li	a2,1
    450e:	00002597          	auipc	a1,0x2
    4512:	caa58593          	addi	a1,a1,-854 # 61b8 <malloc+0x196>
    4516:	fcc42503          	lw	a0,-52(s0)
    451a:	00001097          	auipc	ra,0x1
    451e:	6c6080e7          	jalr	1734(ra) # 5be0 <write>
    4522:	4785                	li	a5,1
    4524:	02f51763          	bne	a0,a5,4552 <preempt+0xdc>
    close(pfds[1]);
    4528:	fcc42503          	lw	a0,-52(s0)
    452c:	00001097          	auipc	ra,0x1
    4530:	6bc080e7          	jalr	1724(ra) # 5be8 <close>
    for(;;)
    4534:	a001                	j	4534 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4536:	85ca                	mv	a1,s2
    4538:	00002517          	auipc	a0,0x2
    453c:	49850513          	addi	a0,a0,1176 # 69d0 <malloc+0x9ae>
    4540:	00002097          	auipc	ra,0x2
    4544:	a2a080e7          	jalr	-1494(ra) # 5f6a <printf>
     exit(1);
    4548:	4505                	li	a0,1
    454a:	00001097          	auipc	ra,0x1
    454e:	676080e7          	jalr	1654(ra) # 5bc0 <exit>
      printf("%s: preempt write error", s);
    4552:	85ca                	mv	a1,s2
    4554:	00003517          	auipc	a0,0x3
    4558:	78c50513          	addi	a0,a0,1932 # 7ce0 <malloc+0x1cbe>
    455c:	00002097          	auipc	ra,0x2
    4560:	a0e080e7          	jalr	-1522(ra) # 5f6a <printf>
    4564:	b7d1                	j	4528 <preempt+0xb2>
  close(pfds[1]);
    4566:	fcc42503          	lw	a0,-52(s0)
    456a:	00001097          	auipc	ra,0x1
    456e:	67e080e7          	jalr	1662(ra) # 5be8 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4572:	660d                	lui	a2,0x3
    4574:	00008597          	auipc	a1,0x8
    4578:	6e458593          	addi	a1,a1,1764 # cc58 <buf>
    457c:	fc842503          	lw	a0,-56(s0)
    4580:	00001097          	auipc	ra,0x1
    4584:	658080e7          	jalr	1624(ra) # 5bd8 <read>
    4588:	4785                	li	a5,1
    458a:	02f50363          	beq	a0,a5,45b0 <preempt+0x13a>
    printf("%s: preempt read error", s);
    458e:	85ca                	mv	a1,s2
    4590:	00003517          	auipc	a0,0x3
    4594:	76850513          	addi	a0,a0,1896 # 7cf8 <malloc+0x1cd6>
    4598:	00002097          	auipc	ra,0x2
    459c:	9d2080e7          	jalr	-1582(ra) # 5f6a <printf>
}
    45a0:	70e2                	ld	ra,56(sp)
    45a2:	7442                	ld	s0,48(sp)
    45a4:	74a2                	ld	s1,40(sp)
    45a6:	7902                	ld	s2,32(sp)
    45a8:	69e2                	ld	s3,24(sp)
    45aa:	6a42                	ld	s4,16(sp)
    45ac:	6121                	addi	sp,sp,64
    45ae:	8082                	ret
  close(pfds[0]);
    45b0:	fc842503          	lw	a0,-56(s0)
    45b4:	00001097          	auipc	ra,0x1
    45b8:	634080e7          	jalr	1588(ra) # 5be8 <close>
  printf("kill... ");
    45bc:	00003517          	auipc	a0,0x3
    45c0:	75450513          	addi	a0,a0,1876 # 7d10 <malloc+0x1cee>
    45c4:	00002097          	auipc	ra,0x2
    45c8:	9a6080e7          	jalr	-1626(ra) # 5f6a <printf>
  kill(pid1);
    45cc:	8526                	mv	a0,s1
    45ce:	00001097          	auipc	ra,0x1
    45d2:	622080e7          	jalr	1570(ra) # 5bf0 <kill>
  kill(pid2);
    45d6:	854e                	mv	a0,s3
    45d8:	00001097          	auipc	ra,0x1
    45dc:	618080e7          	jalr	1560(ra) # 5bf0 <kill>
  kill(pid3);
    45e0:	8552                	mv	a0,s4
    45e2:	00001097          	auipc	ra,0x1
    45e6:	60e080e7          	jalr	1550(ra) # 5bf0 <kill>
  printf("wait... ");
    45ea:	00003517          	auipc	a0,0x3
    45ee:	73650513          	addi	a0,a0,1846 # 7d20 <malloc+0x1cfe>
    45f2:	00002097          	auipc	ra,0x2
    45f6:	978080e7          	jalr	-1672(ra) # 5f6a <printf>
  wait(0);
    45fa:	4501                	li	a0,0
    45fc:	00001097          	auipc	ra,0x1
    4600:	5cc080e7          	jalr	1484(ra) # 5bc8 <wait>
  wait(0);
    4604:	4501                	li	a0,0
    4606:	00001097          	auipc	ra,0x1
    460a:	5c2080e7          	jalr	1474(ra) # 5bc8 <wait>
  wait(0);
    460e:	4501                	li	a0,0
    4610:	00001097          	auipc	ra,0x1
    4614:	5b8080e7          	jalr	1464(ra) # 5bc8 <wait>
    4618:	b761                	j	45a0 <preempt+0x12a>

000000000000461a <reparent>:
{
    461a:	7179                	addi	sp,sp,-48
    461c:	f406                	sd	ra,40(sp)
    461e:	f022                	sd	s0,32(sp)
    4620:	ec26                	sd	s1,24(sp)
    4622:	e84a                	sd	s2,16(sp)
    4624:	e44e                	sd	s3,8(sp)
    4626:	e052                	sd	s4,0(sp)
    4628:	1800                	addi	s0,sp,48
    462a:	89aa                	mv	s3,a0
  int master_pid = getpid();
    462c:	00001097          	auipc	ra,0x1
    4630:	614080e7          	jalr	1556(ra) # 5c40 <getpid>
    4634:	8a2a                	mv	s4,a0
    4636:	0c800913          	li	s2,200
    int pid = fork();
    463a:	00001097          	auipc	ra,0x1
    463e:	57e080e7          	jalr	1406(ra) # 5bb8 <fork>
    4642:	84aa                	mv	s1,a0
    if(pid < 0){
    4644:	02054263          	bltz	a0,4668 <reparent+0x4e>
    if(pid){
    4648:	cd21                	beqz	a0,46a0 <reparent+0x86>
      if(wait(0) != pid){
    464a:	4501                	li	a0,0
    464c:	00001097          	auipc	ra,0x1
    4650:	57c080e7          	jalr	1404(ra) # 5bc8 <wait>
    4654:	02951863          	bne	a0,s1,4684 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4658:	397d                	addiw	s2,s2,-1
    465a:	fe0910e3          	bnez	s2,463a <reparent+0x20>
  exit(0);
    465e:	4501                	li	a0,0
    4660:	00001097          	auipc	ra,0x1
    4664:	560080e7          	jalr	1376(ra) # 5bc0 <exit>
      printf("%s: fork failed\n", s);
    4668:	85ce                	mv	a1,s3
    466a:	00002517          	auipc	a0,0x2
    466e:	36650513          	addi	a0,a0,870 # 69d0 <malloc+0x9ae>
    4672:	00002097          	auipc	ra,0x2
    4676:	8f8080e7          	jalr	-1800(ra) # 5f6a <printf>
      exit(1);
    467a:	4505                	li	a0,1
    467c:	00001097          	auipc	ra,0x1
    4680:	544080e7          	jalr	1348(ra) # 5bc0 <exit>
        printf("%s: wait wrong pid\n", s);
    4684:	85ce                	mv	a1,s3
    4686:	00002517          	auipc	a0,0x2
    468a:	4d250513          	addi	a0,a0,1234 # 6b58 <malloc+0xb36>
    468e:	00002097          	auipc	ra,0x2
    4692:	8dc080e7          	jalr	-1828(ra) # 5f6a <printf>
        exit(1);
    4696:	4505                	li	a0,1
    4698:	00001097          	auipc	ra,0x1
    469c:	528080e7          	jalr	1320(ra) # 5bc0 <exit>
      int pid2 = fork();
    46a0:	00001097          	auipc	ra,0x1
    46a4:	518080e7          	jalr	1304(ra) # 5bb8 <fork>
      if(pid2 < 0){
    46a8:	00054763          	bltz	a0,46b6 <reparent+0x9c>
      exit(0);
    46ac:	4501                	li	a0,0
    46ae:	00001097          	auipc	ra,0x1
    46b2:	512080e7          	jalr	1298(ra) # 5bc0 <exit>
        kill(master_pid);
    46b6:	8552                	mv	a0,s4
    46b8:	00001097          	auipc	ra,0x1
    46bc:	538080e7          	jalr	1336(ra) # 5bf0 <kill>
        exit(1);
    46c0:	4505                	li	a0,1
    46c2:	00001097          	auipc	ra,0x1
    46c6:	4fe080e7          	jalr	1278(ra) # 5bc0 <exit>

00000000000046ca <sbrkfail>:
{
    46ca:	7119                	addi	sp,sp,-128
    46cc:	fc86                	sd	ra,120(sp)
    46ce:	f8a2                	sd	s0,112(sp)
    46d0:	f4a6                	sd	s1,104(sp)
    46d2:	f0ca                	sd	s2,96(sp)
    46d4:	ecce                	sd	s3,88(sp)
    46d6:	e8d2                	sd	s4,80(sp)
    46d8:	e4d6                	sd	s5,72(sp)
    46da:	0100                	addi	s0,sp,128
    46dc:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    46de:	fb040513          	addi	a0,s0,-80
    46e2:	00001097          	auipc	ra,0x1
    46e6:	4ee080e7          	jalr	1262(ra) # 5bd0 <pipe>
    46ea:	e901                	bnez	a0,46fa <sbrkfail+0x30>
    46ec:	f8040493          	addi	s1,s0,-128
    46f0:	fa840993          	addi	s3,s0,-88
    46f4:	8926                	mv	s2,s1
    if(pids[i] != -1)
    46f6:	5a7d                	li	s4,-1
    46f8:	a085                	j	4758 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    46fa:	85d6                	mv	a1,s5
    46fc:	00002517          	auipc	a0,0x2
    4700:	3dc50513          	addi	a0,a0,988 # 6ad8 <malloc+0xab6>
    4704:	00002097          	auipc	ra,0x2
    4708:	866080e7          	jalr	-1946(ra) # 5f6a <printf>
    exit(1);
    470c:	4505                	li	a0,1
    470e:	00001097          	auipc	ra,0x1
    4712:	4b2080e7          	jalr	1202(ra) # 5bc0 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4716:	00001097          	auipc	ra,0x1
    471a:	532080e7          	jalr	1330(ra) # 5c48 <sbrk>
    471e:	064007b7          	lui	a5,0x6400
    4722:	40a7853b          	subw	a0,a5,a0
    4726:	00001097          	auipc	ra,0x1
    472a:	522080e7          	jalr	1314(ra) # 5c48 <sbrk>
      write(fds[1], "x", 1);
    472e:	4605                	li	a2,1
    4730:	00002597          	auipc	a1,0x2
    4734:	a8858593          	addi	a1,a1,-1400 # 61b8 <malloc+0x196>
    4738:	fb442503          	lw	a0,-76(s0)
    473c:	00001097          	auipc	ra,0x1
    4740:	4a4080e7          	jalr	1188(ra) # 5be0 <write>
      for(;;) sleep(1000);
    4744:	3e800513          	li	a0,1000
    4748:	00001097          	auipc	ra,0x1
    474c:	508080e7          	jalr	1288(ra) # 5c50 <sleep>
    4750:	bfd5                	j	4744 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4752:	0911                	addi	s2,s2,4
    4754:	03390563          	beq	s2,s3,477e <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4758:	00001097          	auipc	ra,0x1
    475c:	460080e7          	jalr	1120(ra) # 5bb8 <fork>
    4760:	00a92023          	sw	a0,0(s2)
    4764:	d94d                	beqz	a0,4716 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4766:	ff4506e3          	beq	a0,s4,4752 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    476a:	4605                	li	a2,1
    476c:	faf40593          	addi	a1,s0,-81
    4770:	fb042503          	lw	a0,-80(s0)
    4774:	00001097          	auipc	ra,0x1
    4778:	464080e7          	jalr	1124(ra) # 5bd8 <read>
    477c:	bfd9                	j	4752 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    477e:	6505                	lui	a0,0x1
    4780:	00001097          	auipc	ra,0x1
    4784:	4c8080e7          	jalr	1224(ra) # 5c48 <sbrk>
    4788:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    478a:	597d                	li	s2,-1
    478c:	a021                	j	4794 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    478e:	0491                	addi	s1,s1,4
    4790:	01348f63          	beq	s1,s3,47ae <sbrkfail+0xe4>
    if(pids[i] == -1)
    4794:	4088                	lw	a0,0(s1)
    4796:	ff250ce3          	beq	a0,s2,478e <sbrkfail+0xc4>
    kill(pids[i]);
    479a:	00001097          	auipc	ra,0x1
    479e:	456080e7          	jalr	1110(ra) # 5bf0 <kill>
    wait(0);
    47a2:	4501                	li	a0,0
    47a4:	00001097          	auipc	ra,0x1
    47a8:	424080e7          	jalr	1060(ra) # 5bc8 <wait>
    47ac:	b7cd                	j	478e <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    47ae:	57fd                	li	a5,-1
    47b0:	04fa0163          	beq	s4,a5,47f2 <sbrkfail+0x128>
  pid = fork();
    47b4:	00001097          	auipc	ra,0x1
    47b8:	404080e7          	jalr	1028(ra) # 5bb8 <fork>
    47bc:	84aa                	mv	s1,a0
  if(pid < 0){
    47be:	04054863          	bltz	a0,480e <sbrkfail+0x144>
  if(pid == 0){
    47c2:	c525                	beqz	a0,482a <sbrkfail+0x160>
  wait(&xstatus);
    47c4:	fbc40513          	addi	a0,s0,-68
    47c8:	00001097          	auipc	ra,0x1
    47cc:	400080e7          	jalr	1024(ra) # 5bc8 <wait>
  if(xstatus != -1 && xstatus != 2)
    47d0:	fbc42783          	lw	a5,-68(s0)
    47d4:	577d                	li	a4,-1
    47d6:	00e78563          	beq	a5,a4,47e0 <sbrkfail+0x116>
    47da:	4709                	li	a4,2
    47dc:	08e79d63          	bne	a5,a4,4876 <sbrkfail+0x1ac>
}
    47e0:	70e6                	ld	ra,120(sp)
    47e2:	7446                	ld	s0,112(sp)
    47e4:	74a6                	ld	s1,104(sp)
    47e6:	7906                	ld	s2,96(sp)
    47e8:	69e6                	ld	s3,88(sp)
    47ea:	6a46                	ld	s4,80(sp)
    47ec:	6aa6                	ld	s5,72(sp)
    47ee:	6109                	addi	sp,sp,128
    47f0:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    47f2:	85d6                	mv	a1,s5
    47f4:	00003517          	auipc	a0,0x3
    47f8:	53c50513          	addi	a0,a0,1340 # 7d30 <malloc+0x1d0e>
    47fc:	00001097          	auipc	ra,0x1
    4800:	76e080e7          	jalr	1902(ra) # 5f6a <printf>
    exit(1);
    4804:	4505                	li	a0,1
    4806:	00001097          	auipc	ra,0x1
    480a:	3ba080e7          	jalr	954(ra) # 5bc0 <exit>
    printf("%s: fork failed\n", s);
    480e:	85d6                	mv	a1,s5
    4810:	00002517          	auipc	a0,0x2
    4814:	1c050513          	addi	a0,a0,448 # 69d0 <malloc+0x9ae>
    4818:	00001097          	auipc	ra,0x1
    481c:	752080e7          	jalr	1874(ra) # 5f6a <printf>
    exit(1);
    4820:	4505                	li	a0,1
    4822:	00001097          	auipc	ra,0x1
    4826:	39e080e7          	jalr	926(ra) # 5bc0 <exit>
    a = sbrk(0);
    482a:	4501                	li	a0,0
    482c:	00001097          	auipc	ra,0x1
    4830:	41c080e7          	jalr	1052(ra) # 5c48 <sbrk>
    4834:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4836:	3e800537          	lui	a0,0x3e800
    483a:	00001097          	auipc	ra,0x1
    483e:	40e080e7          	jalr	1038(ra) # 5c48 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4842:	87ca                	mv	a5,s2
    4844:	3e800737          	lui	a4,0x3e800
    4848:	993a                	add	s2,s2,a4
    484a:	6705                	lui	a4,0x1
      n += *(a+i);
    484c:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f03a8>
    4850:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4852:	97ba                	add	a5,a5,a4
    4854:	ff279ce3          	bne	a5,s2,484c <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4858:	8626                	mv	a2,s1
    485a:	85d6                	mv	a1,s5
    485c:	00003517          	auipc	a0,0x3
    4860:	4f450513          	addi	a0,a0,1268 # 7d50 <malloc+0x1d2e>
    4864:	00001097          	auipc	ra,0x1
    4868:	706080e7          	jalr	1798(ra) # 5f6a <printf>
    exit(1);
    486c:	4505                	li	a0,1
    486e:	00001097          	auipc	ra,0x1
    4872:	352080e7          	jalr	850(ra) # 5bc0 <exit>
    exit(1);
    4876:	4505                	li	a0,1
    4878:	00001097          	auipc	ra,0x1
    487c:	348080e7          	jalr	840(ra) # 5bc0 <exit>

0000000000004880 <mem>:
{
    4880:	7139                	addi	sp,sp,-64
    4882:	fc06                	sd	ra,56(sp)
    4884:	f822                	sd	s0,48(sp)
    4886:	f426                	sd	s1,40(sp)
    4888:	f04a                	sd	s2,32(sp)
    488a:	ec4e                	sd	s3,24(sp)
    488c:	0080                	addi	s0,sp,64
    488e:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4890:	00001097          	auipc	ra,0x1
    4894:	328080e7          	jalr	808(ra) # 5bb8 <fork>
    m1 = 0;
    4898:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    489a:	6909                	lui	s2,0x2
    489c:	71190913          	addi	s2,s2,1809 # 2711 <rwsbrk+0xf9>
  if((pid = fork()) == 0){
    48a0:	c115                	beqz	a0,48c4 <mem+0x44>
    wait(&xstatus);
    48a2:	fcc40513          	addi	a0,s0,-52
    48a6:	00001097          	auipc	ra,0x1
    48aa:	322080e7          	jalr	802(ra) # 5bc8 <wait>
    if(xstatus == -1){
    48ae:	fcc42503          	lw	a0,-52(s0)
    48b2:	57fd                	li	a5,-1
    48b4:	06f50363          	beq	a0,a5,491a <mem+0x9a>
    exit(xstatus);
    48b8:	00001097          	auipc	ra,0x1
    48bc:	308080e7          	jalr	776(ra) # 5bc0 <exit>
      *(char**)m2 = m1;
    48c0:	e104                	sd	s1,0(a0)
      m1 = m2;
    48c2:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    48c4:	854a                	mv	a0,s2
    48c6:	00001097          	auipc	ra,0x1
    48ca:	75c080e7          	jalr	1884(ra) # 6022 <malloc>
    48ce:	f96d                	bnez	a0,48c0 <mem+0x40>
    while(m1){
    48d0:	c881                	beqz	s1,48e0 <mem+0x60>
      m2 = *(char**)m1;
    48d2:	8526                	mv	a0,s1
    48d4:	6084                	ld	s1,0(s1)
      free(m1);
    48d6:	00001097          	auipc	ra,0x1
    48da:	6ca080e7          	jalr	1738(ra) # 5fa0 <free>
    while(m1){
    48de:	f8f5                	bnez	s1,48d2 <mem+0x52>
    m1 = malloc(1024*20);
    48e0:	6515                	lui	a0,0x5
    48e2:	00001097          	auipc	ra,0x1
    48e6:	740080e7          	jalr	1856(ra) # 6022 <malloc>
    if(m1 == 0){
    48ea:	c911                	beqz	a0,48fe <mem+0x7e>
    free(m1);
    48ec:	00001097          	auipc	ra,0x1
    48f0:	6b4080e7          	jalr	1716(ra) # 5fa0 <free>
    exit(0);
    48f4:	4501                	li	a0,0
    48f6:	00001097          	auipc	ra,0x1
    48fa:	2ca080e7          	jalr	714(ra) # 5bc0 <exit>
      printf("couldn't allocate mem?!!\n", s);
    48fe:	85ce                	mv	a1,s3
    4900:	00003517          	auipc	a0,0x3
    4904:	48050513          	addi	a0,a0,1152 # 7d80 <malloc+0x1d5e>
    4908:	00001097          	auipc	ra,0x1
    490c:	662080e7          	jalr	1634(ra) # 5f6a <printf>
      exit(1);
    4910:	4505                	li	a0,1
    4912:	00001097          	auipc	ra,0x1
    4916:	2ae080e7          	jalr	686(ra) # 5bc0 <exit>
      exit(0);
    491a:	4501                	li	a0,0
    491c:	00001097          	auipc	ra,0x1
    4920:	2a4080e7          	jalr	676(ra) # 5bc0 <exit>

0000000000004924 <sharedfd>:
{
    4924:	7159                	addi	sp,sp,-112
    4926:	f486                	sd	ra,104(sp)
    4928:	f0a2                	sd	s0,96(sp)
    492a:	eca6                	sd	s1,88(sp)
    492c:	e8ca                	sd	s2,80(sp)
    492e:	e4ce                	sd	s3,72(sp)
    4930:	e0d2                	sd	s4,64(sp)
    4932:	fc56                	sd	s5,56(sp)
    4934:	f85a                	sd	s6,48(sp)
    4936:	f45e                	sd	s7,40(sp)
    4938:	1880                	addi	s0,sp,112
    493a:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    493c:	00003517          	auipc	a0,0x3
    4940:	46450513          	addi	a0,a0,1124 # 7da0 <malloc+0x1d7e>
    4944:	00001097          	auipc	ra,0x1
    4948:	2cc080e7          	jalr	716(ra) # 5c10 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    494c:	20200593          	li	a1,514
    4950:	00003517          	auipc	a0,0x3
    4954:	45050513          	addi	a0,a0,1104 # 7da0 <malloc+0x1d7e>
    4958:	00001097          	auipc	ra,0x1
    495c:	2a8080e7          	jalr	680(ra) # 5c00 <open>
  if(fd < 0){
    4960:	04054a63          	bltz	a0,49b4 <sharedfd+0x90>
    4964:	892a                	mv	s2,a0
  pid = fork();
    4966:	00001097          	auipc	ra,0x1
    496a:	252080e7          	jalr	594(ra) # 5bb8 <fork>
    496e:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4970:	06300593          	li	a1,99
    4974:	c119                	beqz	a0,497a <sharedfd+0x56>
    4976:	07000593          	li	a1,112
    497a:	4629                	li	a2,10
    497c:	fa040513          	addi	a0,s0,-96
    4980:	00001097          	auipc	ra,0x1
    4984:	046080e7          	jalr	70(ra) # 59c6 <memset>
    4988:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    498c:	4629                	li	a2,10
    498e:	fa040593          	addi	a1,s0,-96
    4992:	854a                	mv	a0,s2
    4994:	00001097          	auipc	ra,0x1
    4998:	24c080e7          	jalr	588(ra) # 5be0 <write>
    499c:	47a9                	li	a5,10
    499e:	02f51963          	bne	a0,a5,49d0 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    49a2:	34fd                	addiw	s1,s1,-1
    49a4:	f4e5                	bnez	s1,498c <sharedfd+0x68>
  if(pid == 0) {
    49a6:	04099363          	bnez	s3,49ec <sharedfd+0xc8>
    exit(0);
    49aa:	4501                	li	a0,0
    49ac:	00001097          	auipc	ra,0x1
    49b0:	214080e7          	jalr	532(ra) # 5bc0 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    49b4:	85d2                	mv	a1,s4
    49b6:	00003517          	auipc	a0,0x3
    49ba:	3fa50513          	addi	a0,a0,1018 # 7db0 <malloc+0x1d8e>
    49be:	00001097          	auipc	ra,0x1
    49c2:	5ac080e7          	jalr	1452(ra) # 5f6a <printf>
    exit(1);
    49c6:	4505                	li	a0,1
    49c8:	00001097          	auipc	ra,0x1
    49cc:	1f8080e7          	jalr	504(ra) # 5bc0 <exit>
      printf("%s: write sharedfd failed\n", s);
    49d0:	85d2                	mv	a1,s4
    49d2:	00003517          	auipc	a0,0x3
    49d6:	40650513          	addi	a0,a0,1030 # 7dd8 <malloc+0x1db6>
    49da:	00001097          	auipc	ra,0x1
    49de:	590080e7          	jalr	1424(ra) # 5f6a <printf>
      exit(1);
    49e2:	4505                	li	a0,1
    49e4:	00001097          	auipc	ra,0x1
    49e8:	1dc080e7          	jalr	476(ra) # 5bc0 <exit>
    wait(&xstatus);
    49ec:	f9c40513          	addi	a0,s0,-100
    49f0:	00001097          	auipc	ra,0x1
    49f4:	1d8080e7          	jalr	472(ra) # 5bc8 <wait>
    if(xstatus != 0)
    49f8:	f9c42983          	lw	s3,-100(s0)
    49fc:	00098763          	beqz	s3,4a0a <sharedfd+0xe6>
      exit(xstatus);
    4a00:	854e                	mv	a0,s3
    4a02:	00001097          	auipc	ra,0x1
    4a06:	1be080e7          	jalr	446(ra) # 5bc0 <exit>
  close(fd);
    4a0a:	854a                	mv	a0,s2
    4a0c:	00001097          	auipc	ra,0x1
    4a10:	1dc080e7          	jalr	476(ra) # 5be8 <close>
  fd = open("sharedfd", 0);
    4a14:	4581                	li	a1,0
    4a16:	00003517          	auipc	a0,0x3
    4a1a:	38a50513          	addi	a0,a0,906 # 7da0 <malloc+0x1d7e>
    4a1e:	00001097          	auipc	ra,0x1
    4a22:	1e2080e7          	jalr	482(ra) # 5c00 <open>
    4a26:	8baa                	mv	s7,a0
  nc = np = 0;
    4a28:	8ace                	mv	s5,s3
  if(fd < 0){
    4a2a:	02054563          	bltz	a0,4a54 <sharedfd+0x130>
    4a2e:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4a32:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4a36:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4a3a:	4629                	li	a2,10
    4a3c:	fa040593          	addi	a1,s0,-96
    4a40:	855e                	mv	a0,s7
    4a42:	00001097          	auipc	ra,0x1
    4a46:	196080e7          	jalr	406(ra) # 5bd8 <read>
    4a4a:	02a05f63          	blez	a0,4a88 <sharedfd+0x164>
    4a4e:	fa040793          	addi	a5,s0,-96
    4a52:	a01d                	j	4a78 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4a54:	85d2                	mv	a1,s4
    4a56:	00003517          	auipc	a0,0x3
    4a5a:	3a250513          	addi	a0,a0,930 # 7df8 <malloc+0x1dd6>
    4a5e:	00001097          	auipc	ra,0x1
    4a62:	50c080e7          	jalr	1292(ra) # 5f6a <printf>
    exit(1);
    4a66:	4505                	li	a0,1
    4a68:	00001097          	auipc	ra,0x1
    4a6c:	158080e7          	jalr	344(ra) # 5bc0 <exit>
        nc++;
    4a70:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4a72:	0785                	addi	a5,a5,1
    4a74:	fd2783e3          	beq	a5,s2,4a3a <sharedfd+0x116>
      if(buf[i] == 'c')
    4a78:	0007c703          	lbu	a4,0(a5)
    4a7c:	fe970ae3          	beq	a4,s1,4a70 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4a80:	ff6719e3          	bne	a4,s6,4a72 <sharedfd+0x14e>
        np++;
    4a84:	2a85                	addiw	s5,s5,1
    4a86:	b7f5                	j	4a72 <sharedfd+0x14e>
  close(fd);
    4a88:	855e                	mv	a0,s7
    4a8a:	00001097          	auipc	ra,0x1
    4a8e:	15e080e7          	jalr	350(ra) # 5be8 <close>
  unlink("sharedfd");
    4a92:	00003517          	auipc	a0,0x3
    4a96:	30e50513          	addi	a0,a0,782 # 7da0 <malloc+0x1d7e>
    4a9a:	00001097          	auipc	ra,0x1
    4a9e:	176080e7          	jalr	374(ra) # 5c10 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4aa2:	6789                	lui	a5,0x2
    4aa4:	71078793          	addi	a5,a5,1808 # 2710 <rwsbrk+0xf8>
    4aa8:	00f99763          	bne	s3,a5,4ab6 <sharedfd+0x192>
    4aac:	6789                	lui	a5,0x2
    4aae:	71078793          	addi	a5,a5,1808 # 2710 <rwsbrk+0xf8>
    4ab2:	02fa8063          	beq	s5,a5,4ad2 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4ab6:	85d2                	mv	a1,s4
    4ab8:	00003517          	auipc	a0,0x3
    4abc:	36850513          	addi	a0,a0,872 # 7e20 <malloc+0x1dfe>
    4ac0:	00001097          	auipc	ra,0x1
    4ac4:	4aa080e7          	jalr	1194(ra) # 5f6a <printf>
    exit(1);
    4ac8:	4505                	li	a0,1
    4aca:	00001097          	auipc	ra,0x1
    4ace:	0f6080e7          	jalr	246(ra) # 5bc0 <exit>
    exit(0);
    4ad2:	4501                	li	a0,0
    4ad4:	00001097          	auipc	ra,0x1
    4ad8:	0ec080e7          	jalr	236(ra) # 5bc0 <exit>

0000000000004adc <fourfiles>:
{
    4adc:	7171                	addi	sp,sp,-176
    4ade:	f506                	sd	ra,168(sp)
    4ae0:	f122                	sd	s0,160(sp)
    4ae2:	ed26                	sd	s1,152(sp)
    4ae4:	e94a                	sd	s2,144(sp)
    4ae6:	e54e                	sd	s3,136(sp)
    4ae8:	e152                	sd	s4,128(sp)
    4aea:	fcd6                	sd	s5,120(sp)
    4aec:	f8da                	sd	s6,112(sp)
    4aee:	f4de                	sd	s7,104(sp)
    4af0:	f0e2                	sd	s8,96(sp)
    4af2:	ece6                	sd	s9,88(sp)
    4af4:	e8ea                	sd	s10,80(sp)
    4af6:	e4ee                	sd	s11,72(sp)
    4af8:	1900                	addi	s0,sp,176
    4afa:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    4afe:	00003797          	auipc	a5,0x3
    4b02:	33a78793          	addi	a5,a5,826 # 7e38 <malloc+0x1e16>
    4b06:	f6f43823          	sd	a5,-144(s0)
    4b0a:	00003797          	auipc	a5,0x3
    4b0e:	33678793          	addi	a5,a5,822 # 7e40 <malloc+0x1e1e>
    4b12:	f6f43c23          	sd	a5,-136(s0)
    4b16:	00003797          	auipc	a5,0x3
    4b1a:	33278793          	addi	a5,a5,818 # 7e48 <malloc+0x1e26>
    4b1e:	f8f43023          	sd	a5,-128(s0)
    4b22:	00003797          	auipc	a5,0x3
    4b26:	32e78793          	addi	a5,a5,814 # 7e50 <malloc+0x1e2e>
    4b2a:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4b2e:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4b32:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    4b34:	4481                	li	s1,0
    4b36:	4a11                	li	s4,4
    fname = names[pi];
    4b38:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4b3c:	854e                	mv	a0,s3
    4b3e:	00001097          	auipc	ra,0x1
    4b42:	0d2080e7          	jalr	210(ra) # 5c10 <unlink>
    pid = fork();
    4b46:	00001097          	auipc	ra,0x1
    4b4a:	072080e7          	jalr	114(ra) # 5bb8 <fork>
    if(pid < 0){
    4b4e:	04054463          	bltz	a0,4b96 <fourfiles+0xba>
    if(pid == 0){
    4b52:	c12d                	beqz	a0,4bb4 <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    4b54:	2485                	addiw	s1,s1,1
    4b56:	0921                	addi	s2,s2,8
    4b58:	ff4490e3          	bne	s1,s4,4b38 <fourfiles+0x5c>
    4b5c:	4491                	li	s1,4
    wait(&xstatus);
    4b5e:	f6c40513          	addi	a0,s0,-148
    4b62:	00001097          	auipc	ra,0x1
    4b66:	066080e7          	jalr	102(ra) # 5bc8 <wait>
    if(xstatus != 0)
    4b6a:	f6c42b03          	lw	s6,-148(s0)
    4b6e:	0c0b1e63          	bnez	s6,4c4a <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    4b72:	34fd                	addiw	s1,s1,-1
    4b74:	f4ed                	bnez	s1,4b5e <fourfiles+0x82>
    4b76:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4b7a:	00008a17          	auipc	s4,0x8
    4b7e:	0dea0a13          	addi	s4,s4,222 # cc58 <buf>
    4b82:	00008a97          	auipc	s5,0x8
    4b86:	0d7a8a93          	addi	s5,s5,215 # cc59 <buf+0x1>
    if(total != N*SZ){
    4b8a:	6d85                	lui	s11,0x1
    4b8c:	770d8d93          	addi	s11,s11,1904 # 1770 <exectest+0x100>
  for(i = 0; i < NCHILD; i++){
    4b90:	03400d13          	li	s10,52
    4b94:	aa1d                	j	4cca <fourfiles+0x1ee>
      printf("fork failed\n", s);
    4b96:	f5843583          	ld	a1,-168(s0)
    4b9a:	00002517          	auipc	a0,0x2
    4b9e:	23e50513          	addi	a0,a0,574 # 6dd8 <malloc+0xdb6>
    4ba2:	00001097          	auipc	ra,0x1
    4ba6:	3c8080e7          	jalr	968(ra) # 5f6a <printf>
      exit(1);
    4baa:	4505                	li	a0,1
    4bac:	00001097          	auipc	ra,0x1
    4bb0:	014080e7          	jalr	20(ra) # 5bc0 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4bb4:	20200593          	li	a1,514
    4bb8:	854e                	mv	a0,s3
    4bba:	00001097          	auipc	ra,0x1
    4bbe:	046080e7          	jalr	70(ra) # 5c00 <open>
    4bc2:	892a                	mv	s2,a0
      if(fd < 0){
    4bc4:	04054763          	bltz	a0,4c12 <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    4bc8:	1f400613          	li	a2,500
    4bcc:	0304859b          	addiw	a1,s1,48
    4bd0:	00008517          	auipc	a0,0x8
    4bd4:	08850513          	addi	a0,a0,136 # cc58 <buf>
    4bd8:	00001097          	auipc	ra,0x1
    4bdc:	dee080e7          	jalr	-530(ra) # 59c6 <memset>
    4be0:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4be2:	00008997          	auipc	s3,0x8
    4be6:	07698993          	addi	s3,s3,118 # cc58 <buf>
    4bea:	1f400613          	li	a2,500
    4bee:	85ce                	mv	a1,s3
    4bf0:	854a                	mv	a0,s2
    4bf2:	00001097          	auipc	ra,0x1
    4bf6:	fee080e7          	jalr	-18(ra) # 5be0 <write>
    4bfa:	85aa                	mv	a1,a0
    4bfc:	1f400793          	li	a5,500
    4c00:	02f51863          	bne	a0,a5,4c30 <fourfiles+0x154>
      for(i = 0; i < N; i++){
    4c04:	34fd                	addiw	s1,s1,-1
    4c06:	f0f5                	bnez	s1,4bea <fourfiles+0x10e>
      exit(0);
    4c08:	4501                	li	a0,0
    4c0a:	00001097          	auipc	ra,0x1
    4c0e:	fb6080e7          	jalr	-74(ra) # 5bc0 <exit>
        printf("create failed\n", s);
    4c12:	f5843583          	ld	a1,-168(s0)
    4c16:	00003517          	auipc	a0,0x3
    4c1a:	24250513          	addi	a0,a0,578 # 7e58 <malloc+0x1e36>
    4c1e:	00001097          	auipc	ra,0x1
    4c22:	34c080e7          	jalr	844(ra) # 5f6a <printf>
        exit(1);
    4c26:	4505                	li	a0,1
    4c28:	00001097          	auipc	ra,0x1
    4c2c:	f98080e7          	jalr	-104(ra) # 5bc0 <exit>
          printf("write failed %d\n", n);
    4c30:	00003517          	auipc	a0,0x3
    4c34:	23850513          	addi	a0,a0,568 # 7e68 <malloc+0x1e46>
    4c38:	00001097          	auipc	ra,0x1
    4c3c:	332080e7          	jalr	818(ra) # 5f6a <printf>
          exit(1);
    4c40:	4505                	li	a0,1
    4c42:	00001097          	auipc	ra,0x1
    4c46:	f7e080e7          	jalr	-130(ra) # 5bc0 <exit>
      exit(xstatus);
    4c4a:	855a                	mv	a0,s6
    4c4c:	00001097          	auipc	ra,0x1
    4c50:	f74080e7          	jalr	-140(ra) # 5bc0 <exit>
          printf("wrong char\n", s);
    4c54:	f5843583          	ld	a1,-168(s0)
    4c58:	00003517          	auipc	a0,0x3
    4c5c:	22850513          	addi	a0,a0,552 # 7e80 <malloc+0x1e5e>
    4c60:	00001097          	auipc	ra,0x1
    4c64:	30a080e7          	jalr	778(ra) # 5f6a <printf>
          exit(1);
    4c68:	4505                	li	a0,1
    4c6a:	00001097          	auipc	ra,0x1
    4c6e:	f56080e7          	jalr	-170(ra) # 5bc0 <exit>
      total += n;
    4c72:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4c76:	660d                	lui	a2,0x3
    4c78:	85d2                	mv	a1,s4
    4c7a:	854e                	mv	a0,s3
    4c7c:	00001097          	auipc	ra,0x1
    4c80:	f5c080e7          	jalr	-164(ra) # 5bd8 <read>
    4c84:	02a05363          	blez	a0,4caa <fourfiles+0x1ce>
    4c88:	00008797          	auipc	a5,0x8
    4c8c:	fd078793          	addi	a5,a5,-48 # cc58 <buf>
    4c90:	fff5069b          	addiw	a3,a0,-1
    4c94:	1682                	slli	a3,a3,0x20
    4c96:	9281                	srli	a3,a3,0x20
    4c98:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    4c9a:	0007c703          	lbu	a4,0(a5)
    4c9e:	fa971be3          	bne	a4,s1,4c54 <fourfiles+0x178>
      for(j = 0; j < n; j++){
    4ca2:	0785                	addi	a5,a5,1
    4ca4:	fed79be3          	bne	a5,a3,4c9a <fourfiles+0x1be>
    4ca8:	b7e9                	j	4c72 <fourfiles+0x196>
    close(fd);
    4caa:	854e                	mv	a0,s3
    4cac:	00001097          	auipc	ra,0x1
    4cb0:	f3c080e7          	jalr	-196(ra) # 5be8 <close>
    if(total != N*SZ){
    4cb4:	03b91863          	bne	s2,s11,4ce4 <fourfiles+0x208>
    unlink(fname);
    4cb8:	8566                	mv	a0,s9
    4cba:	00001097          	auipc	ra,0x1
    4cbe:	f56080e7          	jalr	-170(ra) # 5c10 <unlink>
  for(i = 0; i < NCHILD; i++){
    4cc2:	0c21                	addi	s8,s8,8
    4cc4:	2b85                	addiw	s7,s7,1
    4cc6:	03ab8d63          	beq	s7,s10,4d00 <fourfiles+0x224>
    fname = names[i];
    4cca:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    4cce:	4581                	li	a1,0
    4cd0:	8566                	mv	a0,s9
    4cd2:	00001097          	auipc	ra,0x1
    4cd6:	f2e080e7          	jalr	-210(ra) # 5c00 <open>
    4cda:	89aa                	mv	s3,a0
    total = 0;
    4cdc:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    4cde:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4ce2:	bf51                	j	4c76 <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    4ce4:	85ca                	mv	a1,s2
    4ce6:	00003517          	auipc	a0,0x3
    4cea:	1aa50513          	addi	a0,a0,426 # 7e90 <malloc+0x1e6e>
    4cee:	00001097          	auipc	ra,0x1
    4cf2:	27c080e7          	jalr	636(ra) # 5f6a <printf>
      exit(1);
    4cf6:	4505                	li	a0,1
    4cf8:	00001097          	auipc	ra,0x1
    4cfc:	ec8080e7          	jalr	-312(ra) # 5bc0 <exit>
}
    4d00:	70aa                	ld	ra,168(sp)
    4d02:	740a                	ld	s0,160(sp)
    4d04:	64ea                	ld	s1,152(sp)
    4d06:	694a                	ld	s2,144(sp)
    4d08:	69aa                	ld	s3,136(sp)
    4d0a:	6a0a                	ld	s4,128(sp)
    4d0c:	7ae6                	ld	s5,120(sp)
    4d0e:	7b46                	ld	s6,112(sp)
    4d10:	7ba6                	ld	s7,104(sp)
    4d12:	7c06                	ld	s8,96(sp)
    4d14:	6ce6                	ld	s9,88(sp)
    4d16:	6d46                	ld	s10,80(sp)
    4d18:	6da6                	ld	s11,72(sp)
    4d1a:	614d                	addi	sp,sp,176
    4d1c:	8082                	ret

0000000000004d1e <concreate>:
{
    4d1e:	7135                	addi	sp,sp,-160
    4d20:	ed06                	sd	ra,152(sp)
    4d22:	e922                	sd	s0,144(sp)
    4d24:	e526                	sd	s1,136(sp)
    4d26:	e14a                	sd	s2,128(sp)
    4d28:	fcce                	sd	s3,120(sp)
    4d2a:	f8d2                	sd	s4,112(sp)
    4d2c:	f4d6                	sd	s5,104(sp)
    4d2e:	f0da                	sd	s6,96(sp)
    4d30:	ecde                	sd	s7,88(sp)
    4d32:	1100                	addi	s0,sp,160
    4d34:	89aa                	mv	s3,a0
  file[0] = 'C';
    4d36:	04300793          	li	a5,67
    4d3a:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4d3e:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4d42:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4d44:	4b0d                	li	s6,3
    4d46:	4a85                	li	s5,1
      link("C0", file);
    4d48:	00003b97          	auipc	s7,0x3
    4d4c:	160b8b93          	addi	s7,s7,352 # 7ea8 <malloc+0x1e86>
  for(i = 0; i < N; i++){
    4d50:	02800a13          	li	s4,40
    4d54:	acc9                	j	5026 <concreate+0x308>
      link("C0", file);
    4d56:	fa840593          	addi	a1,s0,-88
    4d5a:	855e                	mv	a0,s7
    4d5c:	00001097          	auipc	ra,0x1
    4d60:	ec4080e7          	jalr	-316(ra) # 5c20 <link>
    if(pid == 0) {
    4d64:	a465                	j	500c <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4d66:	4795                	li	a5,5
    4d68:	02f9693b          	remw	s2,s2,a5
    4d6c:	4785                	li	a5,1
    4d6e:	02f90b63          	beq	s2,a5,4da4 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4d72:	20200593          	li	a1,514
    4d76:	fa840513          	addi	a0,s0,-88
    4d7a:	00001097          	auipc	ra,0x1
    4d7e:	e86080e7          	jalr	-378(ra) # 5c00 <open>
      if(fd < 0){
    4d82:	26055c63          	bgez	a0,4ffa <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4d86:	fa840593          	addi	a1,s0,-88
    4d8a:	00003517          	auipc	a0,0x3
    4d8e:	12650513          	addi	a0,a0,294 # 7eb0 <malloc+0x1e8e>
    4d92:	00001097          	auipc	ra,0x1
    4d96:	1d8080e7          	jalr	472(ra) # 5f6a <printf>
        exit(1);
    4d9a:	4505                	li	a0,1
    4d9c:	00001097          	auipc	ra,0x1
    4da0:	e24080e7          	jalr	-476(ra) # 5bc0 <exit>
      link("C0", file);
    4da4:	fa840593          	addi	a1,s0,-88
    4da8:	00003517          	auipc	a0,0x3
    4dac:	10050513          	addi	a0,a0,256 # 7ea8 <malloc+0x1e86>
    4db0:	00001097          	auipc	ra,0x1
    4db4:	e70080e7          	jalr	-400(ra) # 5c20 <link>
      exit(0);
    4db8:	4501                	li	a0,0
    4dba:	00001097          	auipc	ra,0x1
    4dbe:	e06080e7          	jalr	-506(ra) # 5bc0 <exit>
        exit(1);
    4dc2:	4505                	li	a0,1
    4dc4:	00001097          	auipc	ra,0x1
    4dc8:	dfc080e7          	jalr	-516(ra) # 5bc0 <exit>
  memset(fa, 0, sizeof(fa));
    4dcc:	02800613          	li	a2,40
    4dd0:	4581                	li	a1,0
    4dd2:	f8040513          	addi	a0,s0,-128
    4dd6:	00001097          	auipc	ra,0x1
    4dda:	bf0080e7          	jalr	-1040(ra) # 59c6 <memset>
  fd = open(".", 0);
    4dde:	4581                	li	a1,0
    4de0:	00002517          	auipc	a0,0x2
    4de4:	a5050513          	addi	a0,a0,-1456 # 6830 <malloc+0x80e>
    4de8:	00001097          	auipc	ra,0x1
    4dec:	e18080e7          	jalr	-488(ra) # 5c00 <open>
    4df0:	892a                	mv	s2,a0
  n = 0;
    4df2:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4df4:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4df8:	02700b13          	li	s6,39
      fa[i] = 1;
    4dfc:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4dfe:	4641                	li	a2,16
    4e00:	f7040593          	addi	a1,s0,-144
    4e04:	854a                	mv	a0,s2
    4e06:	00001097          	auipc	ra,0x1
    4e0a:	dd2080e7          	jalr	-558(ra) # 5bd8 <read>
    4e0e:	08a05263          	blez	a0,4e92 <concreate+0x174>
    if(de.inum == 0)
    4e12:	f7045783          	lhu	a5,-144(s0)
    4e16:	d7e5                	beqz	a5,4dfe <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4e18:	f7244783          	lbu	a5,-142(s0)
    4e1c:	ff4791e3          	bne	a5,s4,4dfe <concreate+0xe0>
    4e20:	f7444783          	lbu	a5,-140(s0)
    4e24:	ffe9                	bnez	a5,4dfe <concreate+0xe0>
      i = de.name[1] - '0';
    4e26:	f7344783          	lbu	a5,-141(s0)
    4e2a:	fd07879b          	addiw	a5,a5,-48
    4e2e:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4e32:	02eb6063          	bltu	s6,a4,4e52 <concreate+0x134>
      if(fa[i]){
    4e36:	fb070793          	addi	a5,a4,-80 # fb0 <linktest+0x18c>
    4e3a:	97a2                	add	a5,a5,s0
    4e3c:	fd07c783          	lbu	a5,-48(a5)
    4e40:	eb8d                	bnez	a5,4e72 <concreate+0x154>
      fa[i] = 1;
    4e42:	fb070793          	addi	a5,a4,-80
    4e46:	00878733          	add	a4,a5,s0
    4e4a:	fd770823          	sb	s7,-48(a4)
      n++;
    4e4e:	2a85                	addiw	s5,s5,1
    4e50:	b77d                	j	4dfe <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4e52:	f7240613          	addi	a2,s0,-142
    4e56:	85ce                	mv	a1,s3
    4e58:	00003517          	auipc	a0,0x3
    4e5c:	07850513          	addi	a0,a0,120 # 7ed0 <malloc+0x1eae>
    4e60:	00001097          	auipc	ra,0x1
    4e64:	10a080e7          	jalr	266(ra) # 5f6a <printf>
        exit(1);
    4e68:	4505                	li	a0,1
    4e6a:	00001097          	auipc	ra,0x1
    4e6e:	d56080e7          	jalr	-682(ra) # 5bc0 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4e72:	f7240613          	addi	a2,s0,-142
    4e76:	85ce                	mv	a1,s3
    4e78:	00003517          	auipc	a0,0x3
    4e7c:	07850513          	addi	a0,a0,120 # 7ef0 <malloc+0x1ece>
    4e80:	00001097          	auipc	ra,0x1
    4e84:	0ea080e7          	jalr	234(ra) # 5f6a <printf>
        exit(1);
    4e88:	4505                	li	a0,1
    4e8a:	00001097          	auipc	ra,0x1
    4e8e:	d36080e7          	jalr	-714(ra) # 5bc0 <exit>
  close(fd);
    4e92:	854a                	mv	a0,s2
    4e94:	00001097          	auipc	ra,0x1
    4e98:	d54080e7          	jalr	-684(ra) # 5be8 <close>
  if(n != N){
    4e9c:	02800793          	li	a5,40
    4ea0:	00fa9763          	bne	s5,a5,4eae <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    4ea4:	4a8d                	li	s5,3
    4ea6:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4ea8:	02800a13          	li	s4,40
    4eac:	a8c9                	j	4f7e <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4eae:	85ce                	mv	a1,s3
    4eb0:	00003517          	auipc	a0,0x3
    4eb4:	06850513          	addi	a0,a0,104 # 7f18 <malloc+0x1ef6>
    4eb8:	00001097          	auipc	ra,0x1
    4ebc:	0b2080e7          	jalr	178(ra) # 5f6a <printf>
    exit(1);
    4ec0:	4505                	li	a0,1
    4ec2:	00001097          	auipc	ra,0x1
    4ec6:	cfe080e7          	jalr	-770(ra) # 5bc0 <exit>
      printf("%s: fork failed\n", s);
    4eca:	85ce                	mv	a1,s3
    4ecc:	00002517          	auipc	a0,0x2
    4ed0:	b0450513          	addi	a0,a0,-1276 # 69d0 <malloc+0x9ae>
    4ed4:	00001097          	auipc	ra,0x1
    4ed8:	096080e7          	jalr	150(ra) # 5f6a <printf>
      exit(1);
    4edc:	4505                	li	a0,1
    4ede:	00001097          	auipc	ra,0x1
    4ee2:	ce2080e7          	jalr	-798(ra) # 5bc0 <exit>
      close(open(file, 0));
    4ee6:	4581                	li	a1,0
    4ee8:	fa840513          	addi	a0,s0,-88
    4eec:	00001097          	auipc	ra,0x1
    4ef0:	d14080e7          	jalr	-748(ra) # 5c00 <open>
    4ef4:	00001097          	auipc	ra,0x1
    4ef8:	cf4080e7          	jalr	-780(ra) # 5be8 <close>
      close(open(file, 0));
    4efc:	4581                	li	a1,0
    4efe:	fa840513          	addi	a0,s0,-88
    4f02:	00001097          	auipc	ra,0x1
    4f06:	cfe080e7          	jalr	-770(ra) # 5c00 <open>
    4f0a:	00001097          	auipc	ra,0x1
    4f0e:	cde080e7          	jalr	-802(ra) # 5be8 <close>
      close(open(file, 0));
    4f12:	4581                	li	a1,0
    4f14:	fa840513          	addi	a0,s0,-88
    4f18:	00001097          	auipc	ra,0x1
    4f1c:	ce8080e7          	jalr	-792(ra) # 5c00 <open>
    4f20:	00001097          	auipc	ra,0x1
    4f24:	cc8080e7          	jalr	-824(ra) # 5be8 <close>
      close(open(file, 0));
    4f28:	4581                	li	a1,0
    4f2a:	fa840513          	addi	a0,s0,-88
    4f2e:	00001097          	auipc	ra,0x1
    4f32:	cd2080e7          	jalr	-814(ra) # 5c00 <open>
    4f36:	00001097          	auipc	ra,0x1
    4f3a:	cb2080e7          	jalr	-846(ra) # 5be8 <close>
      close(open(file, 0));
    4f3e:	4581                	li	a1,0
    4f40:	fa840513          	addi	a0,s0,-88
    4f44:	00001097          	auipc	ra,0x1
    4f48:	cbc080e7          	jalr	-836(ra) # 5c00 <open>
    4f4c:	00001097          	auipc	ra,0x1
    4f50:	c9c080e7          	jalr	-868(ra) # 5be8 <close>
      close(open(file, 0));
    4f54:	4581                	li	a1,0
    4f56:	fa840513          	addi	a0,s0,-88
    4f5a:	00001097          	auipc	ra,0x1
    4f5e:	ca6080e7          	jalr	-858(ra) # 5c00 <open>
    4f62:	00001097          	auipc	ra,0x1
    4f66:	c86080e7          	jalr	-890(ra) # 5be8 <close>
    if(pid == 0)
    4f6a:	08090363          	beqz	s2,4ff0 <concreate+0x2d2>
      wait(0);
    4f6e:	4501                	li	a0,0
    4f70:	00001097          	auipc	ra,0x1
    4f74:	c58080e7          	jalr	-936(ra) # 5bc8 <wait>
  for(i = 0; i < N; i++){
    4f78:	2485                	addiw	s1,s1,1
    4f7a:	0f448563          	beq	s1,s4,5064 <concreate+0x346>
    file[1] = '0' + i;
    4f7e:	0304879b          	addiw	a5,s1,48
    4f82:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4f86:	00001097          	auipc	ra,0x1
    4f8a:	c32080e7          	jalr	-974(ra) # 5bb8 <fork>
    4f8e:	892a                	mv	s2,a0
    if(pid < 0){
    4f90:	f2054de3          	bltz	a0,4eca <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    4f94:	0354e73b          	remw	a4,s1,s5
    4f98:	00a767b3          	or	a5,a4,a0
    4f9c:	2781                	sext.w	a5,a5
    4f9e:	d7a1                	beqz	a5,4ee6 <concreate+0x1c8>
    4fa0:	01671363          	bne	a4,s6,4fa6 <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    4fa4:	f129                	bnez	a0,4ee6 <concreate+0x1c8>
      unlink(file);
    4fa6:	fa840513          	addi	a0,s0,-88
    4faa:	00001097          	auipc	ra,0x1
    4fae:	c66080e7          	jalr	-922(ra) # 5c10 <unlink>
      unlink(file);
    4fb2:	fa840513          	addi	a0,s0,-88
    4fb6:	00001097          	auipc	ra,0x1
    4fba:	c5a080e7          	jalr	-934(ra) # 5c10 <unlink>
      unlink(file);
    4fbe:	fa840513          	addi	a0,s0,-88
    4fc2:	00001097          	auipc	ra,0x1
    4fc6:	c4e080e7          	jalr	-946(ra) # 5c10 <unlink>
      unlink(file);
    4fca:	fa840513          	addi	a0,s0,-88
    4fce:	00001097          	auipc	ra,0x1
    4fd2:	c42080e7          	jalr	-958(ra) # 5c10 <unlink>
      unlink(file);
    4fd6:	fa840513          	addi	a0,s0,-88
    4fda:	00001097          	auipc	ra,0x1
    4fde:	c36080e7          	jalr	-970(ra) # 5c10 <unlink>
      unlink(file);
    4fe2:	fa840513          	addi	a0,s0,-88
    4fe6:	00001097          	auipc	ra,0x1
    4fea:	c2a080e7          	jalr	-982(ra) # 5c10 <unlink>
    4fee:	bfb5                	j	4f6a <concreate+0x24c>
      exit(0);
    4ff0:	4501                	li	a0,0
    4ff2:	00001097          	auipc	ra,0x1
    4ff6:	bce080e7          	jalr	-1074(ra) # 5bc0 <exit>
      close(fd);
    4ffa:	00001097          	auipc	ra,0x1
    4ffe:	bee080e7          	jalr	-1042(ra) # 5be8 <close>
    if(pid == 0) {
    5002:	bb5d                	j	4db8 <concreate+0x9a>
      close(fd);
    5004:	00001097          	auipc	ra,0x1
    5008:	be4080e7          	jalr	-1052(ra) # 5be8 <close>
      wait(&xstatus);
    500c:	f6c40513          	addi	a0,s0,-148
    5010:	00001097          	auipc	ra,0x1
    5014:	bb8080e7          	jalr	-1096(ra) # 5bc8 <wait>
      if(xstatus != 0)
    5018:	f6c42483          	lw	s1,-148(s0)
    501c:	da0493e3          	bnez	s1,4dc2 <concreate+0xa4>
  for(i = 0; i < N; i++){
    5020:	2905                	addiw	s2,s2,1
    5022:	db4905e3          	beq	s2,s4,4dcc <concreate+0xae>
    file[1] = '0' + i;
    5026:	0309079b          	addiw	a5,s2,48
    502a:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    502e:	fa840513          	addi	a0,s0,-88
    5032:	00001097          	auipc	ra,0x1
    5036:	bde080e7          	jalr	-1058(ra) # 5c10 <unlink>
    pid = fork();
    503a:	00001097          	auipc	ra,0x1
    503e:	b7e080e7          	jalr	-1154(ra) # 5bb8 <fork>
    if(pid && (i % 3) == 1){
    5042:	d20502e3          	beqz	a0,4d66 <concreate+0x48>
    5046:	036967bb          	remw	a5,s2,s6
    504a:	d15786e3          	beq	a5,s5,4d56 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    504e:	20200593          	li	a1,514
    5052:	fa840513          	addi	a0,s0,-88
    5056:	00001097          	auipc	ra,0x1
    505a:	baa080e7          	jalr	-1110(ra) # 5c00 <open>
      if(fd < 0){
    505e:	fa0553e3          	bgez	a0,5004 <concreate+0x2e6>
    5062:	b315                	j	4d86 <concreate+0x68>
}
    5064:	60ea                	ld	ra,152(sp)
    5066:	644a                	ld	s0,144(sp)
    5068:	64aa                	ld	s1,136(sp)
    506a:	690a                	ld	s2,128(sp)
    506c:	79e6                	ld	s3,120(sp)
    506e:	7a46                	ld	s4,112(sp)
    5070:	7aa6                	ld	s5,104(sp)
    5072:	7b06                	ld	s6,96(sp)
    5074:	6be6                	ld	s7,88(sp)
    5076:	610d                	addi	sp,sp,160
    5078:	8082                	ret

000000000000507a <bigfile>:
{
    507a:	7139                	addi	sp,sp,-64
    507c:	fc06                	sd	ra,56(sp)
    507e:	f822                	sd	s0,48(sp)
    5080:	f426                	sd	s1,40(sp)
    5082:	f04a                	sd	s2,32(sp)
    5084:	ec4e                	sd	s3,24(sp)
    5086:	e852                	sd	s4,16(sp)
    5088:	e456                	sd	s5,8(sp)
    508a:	0080                	addi	s0,sp,64
    508c:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    508e:	00003517          	auipc	a0,0x3
    5092:	ec250513          	addi	a0,a0,-318 # 7f50 <malloc+0x1f2e>
    5096:	00001097          	auipc	ra,0x1
    509a:	b7a080e7          	jalr	-1158(ra) # 5c10 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    509e:	20200593          	li	a1,514
    50a2:	00003517          	auipc	a0,0x3
    50a6:	eae50513          	addi	a0,a0,-338 # 7f50 <malloc+0x1f2e>
    50aa:	00001097          	auipc	ra,0x1
    50ae:	b56080e7          	jalr	-1194(ra) # 5c00 <open>
    50b2:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    50b4:	4481                	li	s1,0
    memset(buf, i, SZ);
    50b6:	00008917          	auipc	s2,0x8
    50ba:	ba290913          	addi	s2,s2,-1118 # cc58 <buf>
  for(i = 0; i < N; i++){
    50be:	4a51                	li	s4,20
  if(fd < 0){
    50c0:	0a054063          	bltz	a0,5160 <bigfile+0xe6>
    memset(buf, i, SZ);
    50c4:	25800613          	li	a2,600
    50c8:	85a6                	mv	a1,s1
    50ca:	854a                	mv	a0,s2
    50cc:	00001097          	auipc	ra,0x1
    50d0:	8fa080e7          	jalr	-1798(ra) # 59c6 <memset>
    if(write(fd, buf, SZ) != SZ){
    50d4:	25800613          	li	a2,600
    50d8:	85ca                	mv	a1,s2
    50da:	854e                	mv	a0,s3
    50dc:	00001097          	auipc	ra,0x1
    50e0:	b04080e7          	jalr	-1276(ra) # 5be0 <write>
    50e4:	25800793          	li	a5,600
    50e8:	08f51a63          	bne	a0,a5,517c <bigfile+0x102>
  for(i = 0; i < N; i++){
    50ec:	2485                	addiw	s1,s1,1
    50ee:	fd449be3          	bne	s1,s4,50c4 <bigfile+0x4a>
  close(fd);
    50f2:	854e                	mv	a0,s3
    50f4:	00001097          	auipc	ra,0x1
    50f8:	af4080e7          	jalr	-1292(ra) # 5be8 <close>
  fd = open("bigfile.dat", 0);
    50fc:	4581                	li	a1,0
    50fe:	00003517          	auipc	a0,0x3
    5102:	e5250513          	addi	a0,a0,-430 # 7f50 <malloc+0x1f2e>
    5106:	00001097          	auipc	ra,0x1
    510a:	afa080e7          	jalr	-1286(ra) # 5c00 <open>
    510e:	8a2a                	mv	s4,a0
  total = 0;
    5110:	4981                	li	s3,0
  for(i = 0; ; i++){
    5112:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    5114:	00008917          	auipc	s2,0x8
    5118:	b4490913          	addi	s2,s2,-1212 # cc58 <buf>
  if(fd < 0){
    511c:	06054e63          	bltz	a0,5198 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    5120:	12c00613          	li	a2,300
    5124:	85ca                	mv	a1,s2
    5126:	8552                	mv	a0,s4
    5128:	00001097          	auipc	ra,0x1
    512c:	ab0080e7          	jalr	-1360(ra) # 5bd8 <read>
    if(cc < 0){
    5130:	08054263          	bltz	a0,51b4 <bigfile+0x13a>
    if(cc == 0)
    5134:	c971                	beqz	a0,5208 <bigfile+0x18e>
    if(cc != SZ/2){
    5136:	12c00793          	li	a5,300
    513a:	08f51b63          	bne	a0,a5,51d0 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    513e:	01f4d79b          	srliw	a5,s1,0x1f
    5142:	9fa5                	addw	a5,a5,s1
    5144:	4017d79b          	sraiw	a5,a5,0x1
    5148:	00094703          	lbu	a4,0(s2)
    514c:	0af71063          	bne	a4,a5,51ec <bigfile+0x172>
    5150:	12b94703          	lbu	a4,299(s2)
    5154:	08f71c63          	bne	a4,a5,51ec <bigfile+0x172>
    total += cc;
    5158:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    515c:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    515e:	b7c9                	j	5120 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    5160:	85d6                	mv	a1,s5
    5162:	00003517          	auipc	a0,0x3
    5166:	dfe50513          	addi	a0,a0,-514 # 7f60 <malloc+0x1f3e>
    516a:	00001097          	auipc	ra,0x1
    516e:	e00080e7          	jalr	-512(ra) # 5f6a <printf>
    exit(1);
    5172:	4505                	li	a0,1
    5174:	00001097          	auipc	ra,0x1
    5178:	a4c080e7          	jalr	-1460(ra) # 5bc0 <exit>
      printf("%s: write bigfile failed\n", s);
    517c:	85d6                	mv	a1,s5
    517e:	00003517          	auipc	a0,0x3
    5182:	e0250513          	addi	a0,a0,-510 # 7f80 <malloc+0x1f5e>
    5186:	00001097          	auipc	ra,0x1
    518a:	de4080e7          	jalr	-540(ra) # 5f6a <printf>
      exit(1);
    518e:	4505                	li	a0,1
    5190:	00001097          	auipc	ra,0x1
    5194:	a30080e7          	jalr	-1488(ra) # 5bc0 <exit>
    printf("%s: cannot open bigfile\n", s);
    5198:	85d6                	mv	a1,s5
    519a:	00003517          	auipc	a0,0x3
    519e:	e0650513          	addi	a0,a0,-506 # 7fa0 <malloc+0x1f7e>
    51a2:	00001097          	auipc	ra,0x1
    51a6:	dc8080e7          	jalr	-568(ra) # 5f6a <printf>
    exit(1);
    51aa:	4505                	li	a0,1
    51ac:	00001097          	auipc	ra,0x1
    51b0:	a14080e7          	jalr	-1516(ra) # 5bc0 <exit>
      printf("%s: read bigfile failed\n", s);
    51b4:	85d6                	mv	a1,s5
    51b6:	00003517          	auipc	a0,0x3
    51ba:	e0a50513          	addi	a0,a0,-502 # 7fc0 <malloc+0x1f9e>
    51be:	00001097          	auipc	ra,0x1
    51c2:	dac080e7          	jalr	-596(ra) # 5f6a <printf>
      exit(1);
    51c6:	4505                	li	a0,1
    51c8:	00001097          	auipc	ra,0x1
    51cc:	9f8080e7          	jalr	-1544(ra) # 5bc0 <exit>
      printf("%s: short read bigfile\n", s);
    51d0:	85d6                	mv	a1,s5
    51d2:	00003517          	auipc	a0,0x3
    51d6:	e0e50513          	addi	a0,a0,-498 # 7fe0 <malloc+0x1fbe>
    51da:	00001097          	auipc	ra,0x1
    51de:	d90080e7          	jalr	-624(ra) # 5f6a <printf>
      exit(1);
    51e2:	4505                	li	a0,1
    51e4:	00001097          	auipc	ra,0x1
    51e8:	9dc080e7          	jalr	-1572(ra) # 5bc0 <exit>
      printf("%s: read bigfile wrong data\n", s);
    51ec:	85d6                	mv	a1,s5
    51ee:	00003517          	auipc	a0,0x3
    51f2:	e0a50513          	addi	a0,a0,-502 # 7ff8 <malloc+0x1fd6>
    51f6:	00001097          	auipc	ra,0x1
    51fa:	d74080e7          	jalr	-652(ra) # 5f6a <printf>
      exit(1);
    51fe:	4505                	li	a0,1
    5200:	00001097          	auipc	ra,0x1
    5204:	9c0080e7          	jalr	-1600(ra) # 5bc0 <exit>
  close(fd);
    5208:	8552                	mv	a0,s4
    520a:	00001097          	auipc	ra,0x1
    520e:	9de080e7          	jalr	-1570(ra) # 5be8 <close>
  if(total != N*SZ){
    5212:	678d                	lui	a5,0x3
    5214:	ee078793          	addi	a5,a5,-288 # 2ee0 <fourteen>
    5218:	02f99363          	bne	s3,a5,523e <bigfile+0x1c4>
  unlink("bigfile.dat");
    521c:	00003517          	auipc	a0,0x3
    5220:	d3450513          	addi	a0,a0,-716 # 7f50 <malloc+0x1f2e>
    5224:	00001097          	auipc	ra,0x1
    5228:	9ec080e7          	jalr	-1556(ra) # 5c10 <unlink>
}
    522c:	70e2                	ld	ra,56(sp)
    522e:	7442                	ld	s0,48(sp)
    5230:	74a2                	ld	s1,40(sp)
    5232:	7902                	ld	s2,32(sp)
    5234:	69e2                	ld	s3,24(sp)
    5236:	6a42                	ld	s4,16(sp)
    5238:	6aa2                	ld	s5,8(sp)
    523a:	6121                	addi	sp,sp,64
    523c:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    523e:	85d6                	mv	a1,s5
    5240:	00003517          	auipc	a0,0x3
    5244:	dd850513          	addi	a0,a0,-552 # 8018 <malloc+0x1ff6>
    5248:	00001097          	auipc	ra,0x1
    524c:	d22080e7          	jalr	-734(ra) # 5f6a <printf>
    exit(1);
    5250:	4505                	li	a0,1
    5252:	00001097          	auipc	ra,0x1
    5256:	96e080e7          	jalr	-1682(ra) # 5bc0 <exit>

000000000000525a <fsfull>:
{
    525a:	7171                	addi	sp,sp,-176
    525c:	f506                	sd	ra,168(sp)
    525e:	f122                	sd	s0,160(sp)
    5260:	ed26                	sd	s1,152(sp)
    5262:	e94a                	sd	s2,144(sp)
    5264:	e54e                	sd	s3,136(sp)
    5266:	e152                	sd	s4,128(sp)
    5268:	fcd6                	sd	s5,120(sp)
    526a:	f8da                	sd	s6,112(sp)
    526c:	f4de                	sd	s7,104(sp)
    526e:	f0e2                	sd	s8,96(sp)
    5270:	ece6                	sd	s9,88(sp)
    5272:	e8ea                	sd	s10,80(sp)
    5274:	e4ee                	sd	s11,72(sp)
    5276:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    5278:	00003517          	auipc	a0,0x3
    527c:	dc050513          	addi	a0,a0,-576 # 8038 <malloc+0x2016>
    5280:	00001097          	auipc	ra,0x1
    5284:	cea080e7          	jalr	-790(ra) # 5f6a <printf>
  for(nfiles = 0; ; nfiles++){
    5288:	4481                	li	s1,0
    name[0] = 'f';
    528a:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    528e:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5292:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    5296:	4b29                	li	s6,10
    printf("writing %s\n", name);
    5298:	00003c97          	auipc	s9,0x3
    529c:	db0c8c93          	addi	s9,s9,-592 # 8048 <malloc+0x2026>
    int total = 0;
    52a0:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    52a2:	00008a17          	auipc	s4,0x8
    52a6:	9b6a0a13          	addi	s4,s4,-1610 # cc58 <buf>
    name[0] = 'f';
    52aa:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    52ae:	0384c7bb          	divw	a5,s1,s8
    52b2:	0307879b          	addiw	a5,a5,48
    52b6:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    52ba:	0384e7bb          	remw	a5,s1,s8
    52be:	0377c7bb          	divw	a5,a5,s7
    52c2:	0307879b          	addiw	a5,a5,48
    52c6:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    52ca:	0374e7bb          	remw	a5,s1,s7
    52ce:	0367c7bb          	divw	a5,a5,s6
    52d2:	0307879b          	addiw	a5,a5,48
    52d6:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    52da:	0364e7bb          	remw	a5,s1,s6
    52de:	0307879b          	addiw	a5,a5,48
    52e2:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    52e6:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    52ea:	f5040593          	addi	a1,s0,-176
    52ee:	8566                	mv	a0,s9
    52f0:	00001097          	auipc	ra,0x1
    52f4:	c7a080e7          	jalr	-902(ra) # 5f6a <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    52f8:	20200593          	li	a1,514
    52fc:	f5040513          	addi	a0,s0,-176
    5300:	00001097          	auipc	ra,0x1
    5304:	900080e7          	jalr	-1792(ra) # 5c00 <open>
    5308:	892a                	mv	s2,a0
    if(fd < 0){
    530a:	0a055663          	bgez	a0,53b6 <fsfull+0x15c>
      printf("open %s failed\n", name);
    530e:	f5040593          	addi	a1,s0,-176
    5312:	00003517          	auipc	a0,0x3
    5316:	d4650513          	addi	a0,a0,-698 # 8058 <malloc+0x2036>
    531a:	00001097          	auipc	ra,0x1
    531e:	c50080e7          	jalr	-944(ra) # 5f6a <printf>
  while(nfiles >= 0){
    5322:	0604c363          	bltz	s1,5388 <fsfull+0x12e>
    name[0] = 'f';
    5326:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    532a:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    532e:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5332:	4929                	li	s2,10
  while(nfiles >= 0){
    5334:	5afd                	li	s5,-1
    name[0] = 'f';
    5336:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    533a:	0344c7bb          	divw	a5,s1,s4
    533e:	0307879b          	addiw	a5,a5,48
    5342:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5346:	0344e7bb          	remw	a5,s1,s4
    534a:	0337c7bb          	divw	a5,a5,s3
    534e:	0307879b          	addiw	a5,a5,48
    5352:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5356:	0334e7bb          	remw	a5,s1,s3
    535a:	0327c7bb          	divw	a5,a5,s2
    535e:	0307879b          	addiw	a5,a5,48
    5362:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5366:	0324e7bb          	remw	a5,s1,s2
    536a:	0307879b          	addiw	a5,a5,48
    536e:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5372:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    5376:	f5040513          	addi	a0,s0,-176
    537a:	00001097          	auipc	ra,0x1
    537e:	896080e7          	jalr	-1898(ra) # 5c10 <unlink>
    nfiles--;
    5382:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    5384:	fb5499e3          	bne	s1,s5,5336 <fsfull+0xdc>
  printf("fsfull test finished\n");
    5388:	00003517          	auipc	a0,0x3
    538c:	cf050513          	addi	a0,a0,-784 # 8078 <malloc+0x2056>
    5390:	00001097          	auipc	ra,0x1
    5394:	bda080e7          	jalr	-1062(ra) # 5f6a <printf>
}
    5398:	70aa                	ld	ra,168(sp)
    539a:	740a                	ld	s0,160(sp)
    539c:	64ea                	ld	s1,152(sp)
    539e:	694a                	ld	s2,144(sp)
    53a0:	69aa                	ld	s3,136(sp)
    53a2:	6a0a                	ld	s4,128(sp)
    53a4:	7ae6                	ld	s5,120(sp)
    53a6:	7b46                	ld	s6,112(sp)
    53a8:	7ba6                	ld	s7,104(sp)
    53aa:	7c06                	ld	s8,96(sp)
    53ac:	6ce6                	ld	s9,88(sp)
    53ae:	6d46                	ld	s10,80(sp)
    53b0:	6da6                	ld	s11,72(sp)
    53b2:	614d                	addi	sp,sp,176
    53b4:	8082                	ret
    int total = 0;
    53b6:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    53b8:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    53bc:	40000613          	li	a2,1024
    53c0:	85d2                	mv	a1,s4
    53c2:	854a                	mv	a0,s2
    53c4:	00001097          	auipc	ra,0x1
    53c8:	81c080e7          	jalr	-2020(ra) # 5be0 <write>
      if(cc < BSIZE)
    53cc:	00aad563          	bge	s5,a0,53d6 <fsfull+0x17c>
      total += cc;
    53d0:	00a989bb          	addw	s3,s3,a0
    while(1){
    53d4:	b7e5                	j	53bc <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    53d6:	85ce                	mv	a1,s3
    53d8:	00003517          	auipc	a0,0x3
    53dc:	c9050513          	addi	a0,a0,-880 # 8068 <malloc+0x2046>
    53e0:	00001097          	auipc	ra,0x1
    53e4:	b8a080e7          	jalr	-1142(ra) # 5f6a <printf>
    close(fd);
    53e8:	854a                	mv	a0,s2
    53ea:	00000097          	auipc	ra,0x0
    53ee:	7fe080e7          	jalr	2046(ra) # 5be8 <close>
    if(total == 0)
    53f2:	f20988e3          	beqz	s3,5322 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    53f6:	2485                	addiw	s1,s1,1
    53f8:	bd4d                	j	52aa <fsfull+0x50>

00000000000053fa <textwrite>:
{
    53fa:	7179                	addi	sp,sp,-48
    53fc:	f406                	sd	ra,40(sp)
    53fe:	f022                	sd	s0,32(sp)
    5400:	ec26                	sd	s1,24(sp)
    5402:	1800                	addi	s0,sp,48
    5404:	84aa                	mv	s1,a0
  pid = fork();
    5406:	00000097          	auipc	ra,0x0
    540a:	7b2080e7          	jalr	1970(ra) # 5bb8 <fork>
  if(pid == 0) {
    540e:	c115                	beqz	a0,5432 <textwrite+0x38>
  } else if(pid < 0){
    5410:	02054963          	bltz	a0,5442 <textwrite+0x48>
  wait(&xstatus);
    5414:	fdc40513          	addi	a0,s0,-36
    5418:	00000097          	auipc	ra,0x0
    541c:	7b0080e7          	jalr	1968(ra) # 5bc8 <wait>
  if(xstatus == -1)  // kernel killed child?
    5420:	fdc42503          	lw	a0,-36(s0)
    5424:	57fd                	li	a5,-1
    5426:	02f50c63          	beq	a0,a5,545e <textwrite+0x64>
    exit(xstatus);
    542a:	00000097          	auipc	ra,0x0
    542e:	796080e7          	jalr	1942(ra) # 5bc0 <exit>
    *addr = 10;
    5432:	47a9                	li	a5,10
    5434:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    5438:	4505                	li	a0,1
    543a:	00000097          	auipc	ra,0x0
    543e:	786080e7          	jalr	1926(ra) # 5bc0 <exit>
    printf("%s: fork failed\n", s);
    5442:	85a6                	mv	a1,s1
    5444:	00001517          	auipc	a0,0x1
    5448:	58c50513          	addi	a0,a0,1420 # 69d0 <malloc+0x9ae>
    544c:	00001097          	auipc	ra,0x1
    5450:	b1e080e7          	jalr	-1250(ra) # 5f6a <printf>
    exit(1);
    5454:	4505                	li	a0,1
    5456:	00000097          	auipc	ra,0x0
    545a:	76a080e7          	jalr	1898(ra) # 5bc0 <exit>
    exit(0);
    545e:	4501                	li	a0,0
    5460:	00000097          	auipc	ra,0x0
    5464:	760080e7          	jalr	1888(ra) # 5bc0 <exit>

0000000000005468 <outofinodes>:

void
outofinodes(char *s)
{
    5468:	715d                	addi	sp,sp,-80
    546a:	e486                	sd	ra,72(sp)
    546c:	e0a2                	sd	s0,64(sp)
    546e:	fc26                	sd	s1,56(sp)
    5470:	f84a                	sd	s2,48(sp)
    5472:	f44e                	sd	s3,40(sp)
    5474:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
    5476:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
    5478:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    547c:	40000993          	li	s3,1024
    name[0] = 'z';
    5480:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
    5484:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
    5488:	41f4d71b          	sraiw	a4,s1,0x1f
    548c:	01b7571b          	srliw	a4,a4,0x1b
    5490:	009707bb          	addw	a5,a4,s1
    5494:	4057d69b          	sraiw	a3,a5,0x5
    5498:	0306869b          	addiw	a3,a3,48
    549c:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
    54a0:	8bfd                	andi	a5,a5,31
    54a2:	9f99                	subw	a5,a5,a4
    54a4:	0307879b          	addiw	a5,a5,48
    54a8:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
    54ac:	fa040a23          	sb	zero,-76(s0)
    // printf("\ncalling unlink()..\n");
    unlink(name);
    54b0:	fb040513          	addi	a0,s0,-80
    54b4:	00000097          	auipc	ra,0x0
    54b8:	75c080e7          	jalr	1884(ra) # 5c10 <unlink>
    // printf("\nopening file..\n");
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    54bc:	60200593          	li	a1,1538
    54c0:	fb040513          	addi	a0,s0,-80
    54c4:	00000097          	auipc	ra,0x0
    54c8:	73c080e7          	jalr	1852(ra) # 5c00 <open>
    if(fd < 0){
    54cc:	00054963          	bltz	a0,54de <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
    54d0:	00000097          	auipc	ra,0x0
    54d4:	718080e7          	jalr	1816(ra) # 5be8 <close>
  for(int i = 0; i < nzz; i++){
    54d8:	2485                	addiw	s1,s1,1
    54da:	fb3493e3          	bne	s1,s3,5480 <outofinodes+0x18>
    54de:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
    54e0:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    54e4:	40000993          	li	s3,1024
    name[0] = 'z';
    54e8:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
    54ec:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
    54f0:	41f4d71b          	sraiw	a4,s1,0x1f
    54f4:	01b7571b          	srliw	a4,a4,0x1b
    54f8:	009707bb          	addw	a5,a4,s1
    54fc:	4057d69b          	sraiw	a3,a5,0x5
    5500:	0306869b          	addiw	a3,a3,48
    5504:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
    5508:	8bfd                	andi	a5,a5,31
    550a:	9f99                	subw	a5,a5,a4
    550c:	0307879b          	addiw	a5,a5,48
    5510:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
    5514:	fa040a23          	sb	zero,-76(s0)
    // printf("unlink() again..\n");
    unlink(name);
    5518:	fb040513          	addi	a0,s0,-80
    551c:	00000097          	auipc	ra,0x0
    5520:	6f4080e7          	jalr	1780(ra) # 5c10 <unlink>
  for(int i = 0; i < nzz; i++){
    5524:	2485                	addiw	s1,s1,1
    5526:	fd3491e3          	bne	s1,s3,54e8 <outofinodes+0x80>
    // printf("unlink() done.. (%d)\n", i);
  }
}
    552a:	60a6                	ld	ra,72(sp)
    552c:	6406                	ld	s0,64(sp)
    552e:	74e2                	ld	s1,56(sp)
    5530:	7942                	ld	s2,48(sp)
    5532:	79a2                	ld	s3,40(sp)
    5534:	6161                	addi	sp,sp,80
    5536:	8082                	ret

0000000000005538 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5538:	7179                	addi	sp,sp,-48
    553a:	f406                	sd	ra,40(sp)
    553c:	f022                	sd	s0,32(sp)
    553e:	ec26                	sd	s1,24(sp)
    5540:	e84a                	sd	s2,16(sp)
    5542:	1800                	addi	s0,sp,48
    5544:	84aa                	mv	s1,a0
    5546:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5548:	00003517          	auipc	a0,0x3
    554c:	b4850513          	addi	a0,a0,-1208 # 8090 <malloc+0x206e>
    5550:	00001097          	auipc	ra,0x1
    5554:	a1a080e7          	jalr	-1510(ra) # 5f6a <printf>
  if((pid = fork()) < 0) {
    5558:	00000097          	auipc	ra,0x0
    555c:	660080e7          	jalr	1632(ra) # 5bb8 <fork>
    5560:	02054e63          	bltz	a0,559c <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5564:	c929                	beqz	a0,55b6 <run+0x7e>
    f(s);
    exit(0);
  } else {
    // printf("hi waiting\n");
    wait(&xstatus);
    5566:	fdc40513          	addi	a0,s0,-36
    556a:	00000097          	auipc	ra,0x0
    556e:	65e080e7          	jalr	1630(ra) # 5bc8 <wait>
    // printf("hi waiting done\n");
    if(xstatus != 0) 
    5572:	fdc42783          	lw	a5,-36(s0)
    5576:	c7b9                	beqz	a5,55c4 <run+0x8c>
      printf("FAILED\n");
    5578:	00003517          	auipc	a0,0x3
    557c:	b4050513          	addi	a0,a0,-1216 # 80b8 <malloc+0x2096>
    5580:	00001097          	auipc	ra,0x1
    5584:	9ea080e7          	jalr	-1558(ra) # 5f6a <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5588:	fdc42503          	lw	a0,-36(s0)
  }
}
    558c:	00153513          	seqz	a0,a0
    5590:	70a2                	ld	ra,40(sp)
    5592:	7402                	ld	s0,32(sp)
    5594:	64e2                	ld	s1,24(sp)
    5596:	6942                	ld	s2,16(sp)
    5598:	6145                	addi	sp,sp,48
    559a:	8082                	ret
    printf("runtest: fork error\n");
    559c:	00003517          	auipc	a0,0x3
    55a0:	b0450513          	addi	a0,a0,-1276 # 80a0 <malloc+0x207e>
    55a4:	00001097          	auipc	ra,0x1
    55a8:	9c6080e7          	jalr	-1594(ra) # 5f6a <printf>
    exit(1);
    55ac:	4505                	li	a0,1
    55ae:	00000097          	auipc	ra,0x0
    55b2:	612080e7          	jalr	1554(ra) # 5bc0 <exit>
    f(s);
    55b6:	854a                	mv	a0,s2
    55b8:	9482                	jalr	s1
    exit(0);
    55ba:	4501                	li	a0,0
    55bc:	00000097          	auipc	ra,0x0
    55c0:	604080e7          	jalr	1540(ra) # 5bc0 <exit>
      printf("OK\n");
    55c4:	00003517          	auipc	a0,0x3
    55c8:	afc50513          	addi	a0,a0,-1284 # 80c0 <malloc+0x209e>
    55cc:	00001097          	auipc	ra,0x1
    55d0:	99e080e7          	jalr	-1634(ra) # 5f6a <printf>
    55d4:	bf55                	j	5588 <run+0x50>

00000000000055d6 <runtests>:

int
runtests(struct test *tests, char *justone) {
    55d6:	1101                	addi	sp,sp,-32
    55d8:	ec06                	sd	ra,24(sp)
    55da:	e822                	sd	s0,16(sp)
    55dc:	e426                	sd	s1,8(sp)
    55de:	e04a                	sd	s2,0(sp)
    55e0:	1000                	addi	s0,sp,32
    55e2:	84aa                	mv	s1,a0
    55e4:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    55e6:	6508                	ld	a0,8(a0)
    55e8:	ed09                	bnez	a0,5602 <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    55ea:	4501                	li	a0,0
    55ec:	a82d                	j	5626 <runtests+0x50>
      if(!run(t->f, t->s)){
    55ee:	648c                	ld	a1,8(s1)
    55f0:	6088                	ld	a0,0(s1)
    55f2:	00000097          	auipc	ra,0x0
    55f6:	f46080e7          	jalr	-186(ra) # 5538 <run>
    55fa:	cd09                	beqz	a0,5614 <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    55fc:	04c1                	addi	s1,s1,16
    55fe:	6488                	ld	a0,8(s1)
    5600:	c11d                	beqz	a0,5626 <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5602:	fe0906e3          	beqz	s2,55ee <runtests+0x18>
    5606:	85ca                	mv	a1,s2
    5608:	00000097          	auipc	ra,0x0
    560c:	368080e7          	jalr	872(ra) # 5970 <strcmp>
    5610:	f575                	bnez	a0,55fc <runtests+0x26>
    5612:	bff1                	j	55ee <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    5614:	00003517          	auipc	a0,0x3
    5618:	ab450513          	addi	a0,a0,-1356 # 80c8 <malloc+0x20a6>
    561c:	00001097          	auipc	ra,0x1
    5620:	94e080e7          	jalr	-1714(ra) # 5f6a <printf>
        return 1;
    5624:	4505                	li	a0,1
}
    5626:	60e2                	ld	ra,24(sp)
    5628:	6442                	ld	s0,16(sp)
    562a:	64a2                	ld	s1,8(sp)
    562c:	6902                	ld	s2,0(sp)
    562e:	6105                	addi	sp,sp,32
    5630:	8082                	ret

0000000000005632 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5632:	7139                	addi	sp,sp,-64
    5634:	fc06                	sd	ra,56(sp)
    5636:	f822                	sd	s0,48(sp)
    5638:	f426                	sd	s1,40(sp)
    563a:	f04a                	sd	s2,32(sp)
    563c:	ec4e                	sd	s3,24(sp)
    563e:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5640:	fc840513          	addi	a0,s0,-56
    5644:	00000097          	auipc	ra,0x0
    5648:	58c080e7          	jalr	1420(ra) # 5bd0 <pipe>
    564c:	06054763          	bltz	a0,56ba <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5650:	00000097          	auipc	ra,0x0
    5654:	568080e7          	jalr	1384(ra) # 5bb8 <fork>

  if(pid < 0){
    5658:	06054e63          	bltz	a0,56d4 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    565c:	ed51                	bnez	a0,56f8 <countfree+0xc6>
    close(fds[0]);
    565e:	fc842503          	lw	a0,-56(s0)
    5662:	00000097          	auipc	ra,0x0
    5666:	586080e7          	jalr	1414(ra) # 5be8 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    566a:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    566c:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    566e:	00001997          	auipc	s3,0x1
    5672:	b4a98993          	addi	s3,s3,-1206 # 61b8 <malloc+0x196>
      uint64 a = (uint64) sbrk(4096);
    5676:	6505                	lui	a0,0x1
    5678:	00000097          	auipc	ra,0x0
    567c:	5d0080e7          	jalr	1488(ra) # 5c48 <sbrk>
      if(a == 0xffffffffffffffff){
    5680:	07250763          	beq	a0,s2,56ee <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    5684:	6785                	lui	a5,0x1
    5686:	97aa                	add	a5,a5,a0
    5688:	fe978fa3          	sb	s1,-1(a5) # fff <linktest+0x1db>
      if(write(fds[1], "x", 1) != 1){
    568c:	8626                	mv	a2,s1
    568e:	85ce                	mv	a1,s3
    5690:	fcc42503          	lw	a0,-52(s0)
    5694:	00000097          	auipc	ra,0x0
    5698:	54c080e7          	jalr	1356(ra) # 5be0 <write>
    569c:	fc950de3          	beq	a0,s1,5676 <countfree+0x44>
        printf("write() failed in countfree()\n");
    56a0:	00003517          	auipc	a0,0x3
    56a4:	a8050513          	addi	a0,a0,-1408 # 8120 <malloc+0x20fe>
    56a8:	00001097          	auipc	ra,0x1
    56ac:	8c2080e7          	jalr	-1854(ra) # 5f6a <printf>
        exit(1);
    56b0:	4505                	li	a0,1
    56b2:	00000097          	auipc	ra,0x0
    56b6:	50e080e7          	jalr	1294(ra) # 5bc0 <exit>
    printf("pipe() failed in countfree()\n");
    56ba:	00003517          	auipc	a0,0x3
    56be:	a2650513          	addi	a0,a0,-1498 # 80e0 <malloc+0x20be>
    56c2:	00001097          	auipc	ra,0x1
    56c6:	8a8080e7          	jalr	-1880(ra) # 5f6a <printf>
    exit(1);
    56ca:	4505                	li	a0,1
    56cc:	00000097          	auipc	ra,0x0
    56d0:	4f4080e7          	jalr	1268(ra) # 5bc0 <exit>
    printf("fork failed in countfree()\n");
    56d4:	00003517          	auipc	a0,0x3
    56d8:	a2c50513          	addi	a0,a0,-1492 # 8100 <malloc+0x20de>
    56dc:	00001097          	auipc	ra,0x1
    56e0:	88e080e7          	jalr	-1906(ra) # 5f6a <printf>
    exit(1);
    56e4:	4505                	li	a0,1
    56e6:	00000097          	auipc	ra,0x0
    56ea:	4da080e7          	jalr	1242(ra) # 5bc0 <exit>
      }
    }

    exit(0);
    56ee:	4501                	li	a0,0
    56f0:	00000097          	auipc	ra,0x0
    56f4:	4d0080e7          	jalr	1232(ra) # 5bc0 <exit>
  }

  close(fds[1]);
    56f8:	fcc42503          	lw	a0,-52(s0)
    56fc:	00000097          	auipc	ra,0x0
    5700:	4ec080e7          	jalr	1260(ra) # 5be8 <close>

  int n = 0;
    5704:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    5706:	4605                	li	a2,1
    5708:	fc740593          	addi	a1,s0,-57
    570c:	fc842503          	lw	a0,-56(s0)
    5710:	00000097          	auipc	ra,0x0
    5714:	4c8080e7          	jalr	1224(ra) # 5bd8 <read>
    if(cc < 0){
    5718:	00054563          	bltz	a0,5722 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    571c:	c105                	beqz	a0,573c <countfree+0x10a>
      break;
    n += 1;
    571e:	2485                	addiw	s1,s1,1
  while(1){
    5720:	b7dd                	j	5706 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5722:	00003517          	auipc	a0,0x3
    5726:	a1e50513          	addi	a0,a0,-1506 # 8140 <malloc+0x211e>
    572a:	00001097          	auipc	ra,0x1
    572e:	840080e7          	jalr	-1984(ra) # 5f6a <printf>
      exit(1);
    5732:	4505                	li	a0,1
    5734:	00000097          	auipc	ra,0x0
    5738:	48c080e7          	jalr	1164(ra) # 5bc0 <exit>
  }

  close(fds[0]);
    573c:	fc842503          	lw	a0,-56(s0)
    5740:	00000097          	auipc	ra,0x0
    5744:	4a8080e7          	jalr	1192(ra) # 5be8 <close>
  wait((int*)0);
    5748:	4501                	li	a0,0
    574a:	00000097          	auipc	ra,0x0
    574e:	47e080e7          	jalr	1150(ra) # 5bc8 <wait>
  
  return n;
}
    5752:	8526                	mv	a0,s1
    5754:	70e2                	ld	ra,56(sp)
    5756:	7442                	ld	s0,48(sp)
    5758:	74a2                	ld	s1,40(sp)
    575a:	7902                	ld	s2,32(sp)
    575c:	69e2                	ld	s3,24(sp)
    575e:	6121                	addi	sp,sp,64
    5760:	8082                	ret

0000000000005762 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    5762:	711d                	addi	sp,sp,-96
    5764:	ec86                	sd	ra,88(sp)
    5766:	e8a2                	sd	s0,80(sp)
    5768:	e4a6                	sd	s1,72(sp)
    576a:	e0ca                	sd	s2,64(sp)
    576c:	fc4e                	sd	s3,56(sp)
    576e:	f852                	sd	s4,48(sp)
    5770:	f456                	sd	s5,40(sp)
    5772:	f05a                	sd	s6,32(sp)
    5774:	ec5e                	sd	s7,24(sp)
    5776:	e862                	sd	s8,16(sp)
    5778:	e466                	sd	s9,8(sp)
    577a:	e06a                	sd	s10,0(sp)
    577c:	1080                	addi	s0,sp,96
    577e:	8a2a                	mv	s4,a0
    5780:	89ae                	mv	s3,a1
    5782:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    5784:	00003b97          	auipc	s7,0x3
    5788:	9dcb8b93          	addi	s7,s7,-1572 # 8160 <malloc+0x213e>
    
    int free0 = countfree();
    int free1 = 0;
    
    if (runtests(quicktests, justone)) {
    578c:	00004b17          	auipc	s6,0x4
    5790:	884b0b13          	addi	s6,s6,-1916 # 9010 <quicktests>
      if(continuous != 2) {
    5794:	4a89                	li	s5,2
        }
      }
    }
    // printf("done 2\n");
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5796:	00003c97          	auipc	s9,0x3
    579a:	a02c8c93          	addi	s9,s9,-1534 # 8198 <malloc+0x2176>
      if (runtests(slowtests, justone)) {
    579e:	00004c17          	auipc	s8,0x4
    57a2:	c32c0c13          	addi	s8,s8,-974 # 93d0 <slowtests>
        printf("usertests slow tests starting\n");
    57a6:	00003d17          	auipc	s10,0x3
    57aa:	9d2d0d13          	addi	s10,s10,-1582 # 8178 <malloc+0x2156>
    57ae:	a839                	j	57cc <drivetests+0x6a>
    57b0:	856a                	mv	a0,s10
    57b2:	00000097          	auipc	ra,0x0
    57b6:	7b8080e7          	jalr	1976(ra) # 5f6a <printf>
    57ba:	a081                	j	57fa <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    57bc:	00000097          	auipc	ra,0x0
    57c0:	e76080e7          	jalr	-394(ra) # 5632 <countfree>
    57c4:	06954263          	blt	a0,s1,5828 <drivetests+0xc6>
        return 1;
      }
    }
    // else
      // printf("done 1\n");
  } while(continuous);
    57c8:	06098f63          	beqz	s3,5846 <drivetests+0xe4>
    printf("usertests starting\n");
    57cc:	855e                	mv	a0,s7
    57ce:	00000097          	auipc	ra,0x0
    57d2:	79c080e7          	jalr	1948(ra) # 5f6a <printf>
    int free0 = countfree();
    57d6:	00000097          	auipc	ra,0x0
    57da:	e5c080e7          	jalr	-420(ra) # 5632 <countfree>
    57de:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    57e0:	85ca                	mv	a1,s2
    57e2:	855a                	mv	a0,s6
    57e4:	00000097          	auipc	ra,0x0
    57e8:	df2080e7          	jalr	-526(ra) # 55d6 <runtests>
    57ec:	c119                	beqz	a0,57f2 <drivetests+0x90>
      if(continuous != 2) {
    57ee:	05599863          	bne	s3,s5,583e <drivetests+0xdc>
    if(!quick) {
    57f2:	fc0a15e3          	bnez	s4,57bc <drivetests+0x5a>
      if (justone == 0)
    57f6:	fa090de3          	beqz	s2,57b0 <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    57fa:	85ca                	mv	a1,s2
    57fc:	8562                	mv	a0,s8
    57fe:	00000097          	auipc	ra,0x0
    5802:	dd8080e7          	jalr	-552(ra) # 55d6 <runtests>
    5806:	d95d                	beqz	a0,57bc <drivetests+0x5a>
        if(continuous != 2) {
    5808:	03599d63          	bne	s3,s5,5842 <drivetests+0xe0>
    if((free1 = countfree()) < free0) {
    580c:	00000097          	auipc	ra,0x0
    5810:	e26080e7          	jalr	-474(ra) # 5632 <countfree>
    5814:	fa955ae3          	bge	a0,s1,57c8 <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5818:	8626                	mv	a2,s1
    581a:	85aa                	mv	a1,a0
    581c:	8566                	mv	a0,s9
    581e:	00000097          	auipc	ra,0x0
    5822:	74c080e7          	jalr	1868(ra) # 5f6a <printf>
      if(continuous != 2) {
    5826:	b75d                	j	57cc <drivetests+0x6a>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5828:	8626                	mv	a2,s1
    582a:	85aa                	mv	a1,a0
    582c:	8566                	mv	a0,s9
    582e:	00000097          	auipc	ra,0x0
    5832:	73c080e7          	jalr	1852(ra) # 5f6a <printf>
      if(continuous != 2) {
    5836:	f9598be3          	beq	s3,s5,57cc <drivetests+0x6a>
        return 1;
    583a:	4505                	li	a0,1
    583c:	a031                	j	5848 <drivetests+0xe6>
        return 1;
    583e:	4505                	li	a0,1
    5840:	a021                	j	5848 <drivetests+0xe6>
          return 1;
    5842:	4505                	li	a0,1
    5844:	a011                	j	5848 <drivetests+0xe6>
  return 0;
    5846:	854e                	mv	a0,s3
}
    5848:	60e6                	ld	ra,88(sp)
    584a:	6446                	ld	s0,80(sp)
    584c:	64a6                	ld	s1,72(sp)
    584e:	6906                	ld	s2,64(sp)
    5850:	79e2                	ld	s3,56(sp)
    5852:	7a42                	ld	s4,48(sp)
    5854:	7aa2                	ld	s5,40(sp)
    5856:	7b02                	ld	s6,32(sp)
    5858:	6be2                	ld	s7,24(sp)
    585a:	6c42                	ld	s8,16(sp)
    585c:	6ca2                	ld	s9,8(sp)
    585e:	6d02                	ld	s10,0(sp)
    5860:	6125                	addi	sp,sp,96
    5862:	8082                	ret

0000000000005864 <main>:

int
main(int argc, char *argv[])
{
    5864:	1101                	addi	sp,sp,-32
    5866:	ec06                	sd	ra,24(sp)
    5868:	e822                	sd	s0,16(sp)
    586a:	e426                	sd	s1,8(sp)
    586c:	e04a                	sd	s2,0(sp)
    586e:	1000                	addi	s0,sp,32
    5870:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5872:	4789                	li	a5,2
    5874:	02f50263          	beq	a0,a5,5898 <main+0x34>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5878:	4785                	li	a5,1
    587a:	06a7cd63          	blt	a5,a0,58f4 <main+0x90>
  char *justone = 0;
    587e:	4601                	li	a2,0
  int quick = 0;
    5880:	4501                	li	a0,0
  int continuous = 0;
    5882:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    5884:	00000097          	auipc	ra,0x0
    5888:	ede080e7          	jalr	-290(ra) # 5762 <drivetests>
    588c:	c951                	beqz	a0,5920 <main+0xbc>
    exit(1);
    588e:	4505                	li	a0,1
    5890:	00000097          	auipc	ra,0x0
    5894:	330080e7          	jalr	816(ra) # 5bc0 <exit>
    5898:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    589a:	00003597          	auipc	a1,0x3
    589e:	92e58593          	addi	a1,a1,-1746 # 81c8 <malloc+0x21a6>
    58a2:	00893503          	ld	a0,8(s2)
    58a6:	00000097          	auipc	ra,0x0
    58aa:	0ca080e7          	jalr	202(ra) # 5970 <strcmp>
    58ae:	85aa                	mv	a1,a0
    58b0:	cd39                	beqz	a0,590e <main+0xaa>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    58b2:	00003597          	auipc	a1,0x3
    58b6:	96e58593          	addi	a1,a1,-1682 # 8220 <malloc+0x21fe>
    58ba:	00893503          	ld	a0,8(s2)
    58be:	00000097          	auipc	ra,0x0
    58c2:	0b2080e7          	jalr	178(ra) # 5970 <strcmp>
    58c6:	c931                	beqz	a0,591a <main+0xb6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    58c8:	00003597          	auipc	a1,0x3
    58cc:	95058593          	addi	a1,a1,-1712 # 8218 <malloc+0x21f6>
    58d0:	00893503          	ld	a0,8(s2)
    58d4:	00000097          	auipc	ra,0x0
    58d8:	09c080e7          	jalr	156(ra) # 5970 <strcmp>
    58dc:	cd05                	beqz	a0,5914 <main+0xb0>
  } else if(argc == 2 && argv[1][0] != '-'){
    58de:	00893603          	ld	a2,8(s2)
    58e2:	00064703          	lbu	a4,0(a2) # 3000 <fourteen+0x120>
    58e6:	02d00793          	li	a5,45
    58ea:	00f70563          	beq	a4,a5,58f4 <main+0x90>
  int quick = 0;
    58ee:	4501                	li	a0,0
  int continuous = 0;
    58f0:	4581                	li	a1,0
    58f2:	bf49                	j	5884 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    58f4:	00003517          	auipc	a0,0x3
    58f8:	8dc50513          	addi	a0,a0,-1828 # 81d0 <malloc+0x21ae>
    58fc:	00000097          	auipc	ra,0x0
    5900:	66e080e7          	jalr	1646(ra) # 5f6a <printf>
    exit(1);
    5904:	4505                	li	a0,1
    5906:	00000097          	auipc	ra,0x0
    590a:	2ba080e7          	jalr	698(ra) # 5bc0 <exit>
  char *justone = 0;
    590e:	4601                	li	a2,0
    quick = 1;
    5910:	4505                	li	a0,1
    5912:	bf8d                	j	5884 <main+0x20>
    continuous = 2;
    5914:	85a6                	mv	a1,s1
  char *justone = 0;
    5916:	4601                	li	a2,0
    5918:	b7b5                	j	5884 <main+0x20>
    591a:	4601                	li	a2,0
    continuous = 1;
    591c:	4585                	li	a1,1
    591e:	b79d                	j	5884 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5920:	00003517          	auipc	a0,0x3
    5924:	8e050513          	addi	a0,a0,-1824 # 8200 <malloc+0x21de>
    5928:	00000097          	auipc	ra,0x0
    592c:	642080e7          	jalr	1602(ra) # 5f6a <printf>
  exit(0);
    5930:	4501                	li	a0,0
    5932:	00000097          	auipc	ra,0x0
    5936:	28e080e7          	jalr	654(ra) # 5bc0 <exit>

000000000000593a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    593a:	1141                	addi	sp,sp,-16
    593c:	e406                	sd	ra,8(sp)
    593e:	e022                	sd	s0,0(sp)
    5940:	0800                	addi	s0,sp,16
  extern int main();
  main();
    5942:	00000097          	auipc	ra,0x0
    5946:	f22080e7          	jalr	-222(ra) # 5864 <main>
  exit(0);
    594a:	4501                	li	a0,0
    594c:	00000097          	auipc	ra,0x0
    5950:	274080e7          	jalr	628(ra) # 5bc0 <exit>

0000000000005954 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5954:	1141                	addi	sp,sp,-16
    5956:	e422                	sd	s0,8(sp)
    5958:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    595a:	87aa                	mv	a5,a0
    595c:	0585                	addi	a1,a1,1
    595e:	0785                	addi	a5,a5,1
    5960:	fff5c703          	lbu	a4,-1(a1)
    5964:	fee78fa3          	sb	a4,-1(a5)
    5968:	fb75                	bnez	a4,595c <strcpy+0x8>
    ;
  return os;
}
    596a:	6422                	ld	s0,8(sp)
    596c:	0141                	addi	sp,sp,16
    596e:	8082                	ret

0000000000005970 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5970:	1141                	addi	sp,sp,-16
    5972:	e422                	sd	s0,8(sp)
    5974:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5976:	00054783          	lbu	a5,0(a0)
    597a:	cb91                	beqz	a5,598e <strcmp+0x1e>
    597c:	0005c703          	lbu	a4,0(a1)
    5980:	00f71763          	bne	a4,a5,598e <strcmp+0x1e>
    p++, q++;
    5984:	0505                	addi	a0,a0,1
    5986:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5988:	00054783          	lbu	a5,0(a0)
    598c:	fbe5                	bnez	a5,597c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    598e:	0005c503          	lbu	a0,0(a1)
}
    5992:	40a7853b          	subw	a0,a5,a0
    5996:	6422                	ld	s0,8(sp)
    5998:	0141                	addi	sp,sp,16
    599a:	8082                	ret

000000000000599c <strlen>:

uint
strlen(const char *s)
{
    599c:	1141                	addi	sp,sp,-16
    599e:	e422                	sd	s0,8(sp)
    59a0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    59a2:	00054783          	lbu	a5,0(a0)
    59a6:	cf91                	beqz	a5,59c2 <strlen+0x26>
    59a8:	0505                	addi	a0,a0,1
    59aa:	87aa                	mv	a5,a0
    59ac:	4685                	li	a3,1
    59ae:	9e89                	subw	a3,a3,a0
    59b0:	00f6853b          	addw	a0,a3,a5
    59b4:	0785                	addi	a5,a5,1
    59b6:	fff7c703          	lbu	a4,-1(a5)
    59ba:	fb7d                	bnez	a4,59b0 <strlen+0x14>
    ;
  return n;
}
    59bc:	6422                	ld	s0,8(sp)
    59be:	0141                	addi	sp,sp,16
    59c0:	8082                	ret
  for(n = 0; s[n]; n++)
    59c2:	4501                	li	a0,0
    59c4:	bfe5                	j	59bc <strlen+0x20>

00000000000059c6 <memset>:

void*
memset(void *dst, int c, uint n)
{
    59c6:	1141                	addi	sp,sp,-16
    59c8:	e422                	sd	s0,8(sp)
    59ca:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    59cc:	ca19                	beqz	a2,59e2 <memset+0x1c>
    59ce:	87aa                	mv	a5,a0
    59d0:	1602                	slli	a2,a2,0x20
    59d2:	9201                	srli	a2,a2,0x20
    59d4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    59d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    59dc:	0785                	addi	a5,a5,1
    59de:	fee79de3          	bne	a5,a4,59d8 <memset+0x12>
  }
  return dst;
}
    59e2:	6422                	ld	s0,8(sp)
    59e4:	0141                	addi	sp,sp,16
    59e6:	8082                	ret

00000000000059e8 <strchr>:

char*
strchr(const char *s, char c)
{
    59e8:	1141                	addi	sp,sp,-16
    59ea:	e422                	sd	s0,8(sp)
    59ec:	0800                	addi	s0,sp,16
  for(; *s; s++)
    59ee:	00054783          	lbu	a5,0(a0)
    59f2:	cb99                	beqz	a5,5a08 <strchr+0x20>
    if(*s == c)
    59f4:	00f58763          	beq	a1,a5,5a02 <strchr+0x1a>
  for(; *s; s++)
    59f8:	0505                	addi	a0,a0,1
    59fa:	00054783          	lbu	a5,0(a0)
    59fe:	fbfd                	bnez	a5,59f4 <strchr+0xc>
      return (char*)s;
  return 0;
    5a00:	4501                	li	a0,0
}
    5a02:	6422                	ld	s0,8(sp)
    5a04:	0141                	addi	sp,sp,16
    5a06:	8082                	ret
  return 0;
    5a08:	4501                	li	a0,0
    5a0a:	bfe5                	j	5a02 <strchr+0x1a>

0000000000005a0c <gets>:

char*
gets(char *buf, int max)
{
    5a0c:	711d                	addi	sp,sp,-96
    5a0e:	ec86                	sd	ra,88(sp)
    5a10:	e8a2                	sd	s0,80(sp)
    5a12:	e4a6                	sd	s1,72(sp)
    5a14:	e0ca                	sd	s2,64(sp)
    5a16:	fc4e                	sd	s3,56(sp)
    5a18:	f852                	sd	s4,48(sp)
    5a1a:	f456                	sd	s5,40(sp)
    5a1c:	f05a                	sd	s6,32(sp)
    5a1e:	ec5e                	sd	s7,24(sp)
    5a20:	1080                	addi	s0,sp,96
    5a22:	8baa                	mv	s7,a0
    5a24:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5a26:	892a                	mv	s2,a0
    5a28:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5a2a:	4aa9                	li	s5,10
    5a2c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a2e:	89a6                	mv	s3,s1
    5a30:	2485                	addiw	s1,s1,1
    5a32:	0344d863          	bge	s1,s4,5a62 <gets+0x56>
    cc = read(0, &c, 1);
    5a36:	4605                	li	a2,1
    5a38:	faf40593          	addi	a1,s0,-81
    5a3c:	4501                	li	a0,0
    5a3e:	00000097          	auipc	ra,0x0
    5a42:	19a080e7          	jalr	410(ra) # 5bd8 <read>
    if(cc < 1)
    5a46:	00a05e63          	blez	a0,5a62 <gets+0x56>
    buf[i++] = c;
    5a4a:	faf44783          	lbu	a5,-81(s0)
    5a4e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a52:	01578763          	beq	a5,s5,5a60 <gets+0x54>
    5a56:	0905                	addi	s2,s2,1
    5a58:	fd679be3          	bne	a5,s6,5a2e <gets+0x22>
  for(i=0; i+1 < max; ){
    5a5c:	89a6                	mv	s3,s1
    5a5e:	a011                	j	5a62 <gets+0x56>
    5a60:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a62:	99de                	add	s3,s3,s7
    5a64:	00098023          	sb	zero,0(s3)
  return buf;
}
    5a68:	855e                	mv	a0,s7
    5a6a:	60e6                	ld	ra,88(sp)
    5a6c:	6446                	ld	s0,80(sp)
    5a6e:	64a6                	ld	s1,72(sp)
    5a70:	6906                	ld	s2,64(sp)
    5a72:	79e2                	ld	s3,56(sp)
    5a74:	7a42                	ld	s4,48(sp)
    5a76:	7aa2                	ld	s5,40(sp)
    5a78:	7b02                	ld	s6,32(sp)
    5a7a:	6be2                	ld	s7,24(sp)
    5a7c:	6125                	addi	sp,sp,96
    5a7e:	8082                	ret

0000000000005a80 <stat>:

int
stat(const char *n, struct stat *st)
{
    5a80:	1101                	addi	sp,sp,-32
    5a82:	ec06                	sd	ra,24(sp)
    5a84:	e822                	sd	s0,16(sp)
    5a86:	e426                	sd	s1,8(sp)
    5a88:	e04a                	sd	s2,0(sp)
    5a8a:	1000                	addi	s0,sp,32
    5a8c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5a8e:	4581                	li	a1,0
    5a90:	00000097          	auipc	ra,0x0
    5a94:	170080e7          	jalr	368(ra) # 5c00 <open>
  if(fd < 0)
    5a98:	02054563          	bltz	a0,5ac2 <stat+0x42>
    5a9c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5a9e:	85ca                	mv	a1,s2
    5aa0:	00000097          	auipc	ra,0x0
    5aa4:	178080e7          	jalr	376(ra) # 5c18 <fstat>
    5aa8:	892a                	mv	s2,a0
  close(fd);
    5aaa:	8526                	mv	a0,s1
    5aac:	00000097          	auipc	ra,0x0
    5ab0:	13c080e7          	jalr	316(ra) # 5be8 <close>
  return r;
}
    5ab4:	854a                	mv	a0,s2
    5ab6:	60e2                	ld	ra,24(sp)
    5ab8:	6442                	ld	s0,16(sp)
    5aba:	64a2                	ld	s1,8(sp)
    5abc:	6902                	ld	s2,0(sp)
    5abe:	6105                	addi	sp,sp,32
    5ac0:	8082                	ret
    return -1;
    5ac2:	597d                	li	s2,-1
    5ac4:	bfc5                	j	5ab4 <stat+0x34>

0000000000005ac6 <atoi>:

int
atoi(const char *s)
{
    5ac6:	1141                	addi	sp,sp,-16
    5ac8:	e422                	sd	s0,8(sp)
    5aca:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5acc:	00054683          	lbu	a3,0(a0)
    5ad0:	fd06879b          	addiw	a5,a3,-48
    5ad4:	0ff7f793          	zext.b	a5,a5
    5ad8:	4625                	li	a2,9
    5ada:	02f66863          	bltu	a2,a5,5b0a <atoi+0x44>
    5ade:	872a                	mv	a4,a0
  n = 0;
    5ae0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5ae2:	0705                	addi	a4,a4,1
    5ae4:	0025179b          	slliw	a5,a0,0x2
    5ae8:	9fa9                	addw	a5,a5,a0
    5aea:	0017979b          	slliw	a5,a5,0x1
    5aee:	9fb5                	addw	a5,a5,a3
    5af0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5af4:	00074683          	lbu	a3,0(a4)
    5af8:	fd06879b          	addiw	a5,a3,-48
    5afc:	0ff7f793          	zext.b	a5,a5
    5b00:	fef671e3          	bgeu	a2,a5,5ae2 <atoi+0x1c>
  return n;
}
    5b04:	6422                	ld	s0,8(sp)
    5b06:	0141                	addi	sp,sp,16
    5b08:	8082                	ret
  n = 0;
    5b0a:	4501                	li	a0,0
    5b0c:	bfe5                	j	5b04 <atoi+0x3e>

0000000000005b0e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5b0e:	1141                	addi	sp,sp,-16
    5b10:	e422                	sd	s0,8(sp)
    5b12:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5b14:	02b57463          	bgeu	a0,a1,5b3c <memmove+0x2e>
    while(n-- > 0)
    5b18:	00c05f63          	blez	a2,5b36 <memmove+0x28>
    5b1c:	1602                	slli	a2,a2,0x20
    5b1e:	9201                	srli	a2,a2,0x20
    5b20:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5b24:	872a                	mv	a4,a0
      *dst++ = *src++;
    5b26:	0585                	addi	a1,a1,1
    5b28:	0705                	addi	a4,a4,1
    5b2a:	fff5c683          	lbu	a3,-1(a1)
    5b2e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b32:	fee79ae3          	bne	a5,a4,5b26 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b36:	6422                	ld	s0,8(sp)
    5b38:	0141                	addi	sp,sp,16
    5b3a:	8082                	ret
    dst += n;
    5b3c:	00c50733          	add	a4,a0,a2
    src += n;
    5b40:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b42:	fec05ae3          	blez	a2,5b36 <memmove+0x28>
    5b46:	fff6079b          	addiw	a5,a2,-1
    5b4a:	1782                	slli	a5,a5,0x20
    5b4c:	9381                	srli	a5,a5,0x20
    5b4e:	fff7c793          	not	a5,a5
    5b52:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5b54:	15fd                	addi	a1,a1,-1
    5b56:	177d                	addi	a4,a4,-1
    5b58:	0005c683          	lbu	a3,0(a1)
    5b5c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5b60:	fee79ae3          	bne	a5,a4,5b54 <memmove+0x46>
    5b64:	bfc9                	j	5b36 <memmove+0x28>

0000000000005b66 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5b66:	1141                	addi	sp,sp,-16
    5b68:	e422                	sd	s0,8(sp)
    5b6a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5b6c:	ca05                	beqz	a2,5b9c <memcmp+0x36>
    5b6e:	fff6069b          	addiw	a3,a2,-1
    5b72:	1682                	slli	a3,a3,0x20
    5b74:	9281                	srli	a3,a3,0x20
    5b76:	0685                	addi	a3,a3,1
    5b78:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5b7a:	00054783          	lbu	a5,0(a0)
    5b7e:	0005c703          	lbu	a4,0(a1)
    5b82:	00e79863          	bne	a5,a4,5b92 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5b86:	0505                	addi	a0,a0,1
    p2++;
    5b88:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5b8a:	fed518e3          	bne	a0,a3,5b7a <memcmp+0x14>
  }
  return 0;
    5b8e:	4501                	li	a0,0
    5b90:	a019                	j	5b96 <memcmp+0x30>
      return *p1 - *p2;
    5b92:	40e7853b          	subw	a0,a5,a4
}
    5b96:	6422                	ld	s0,8(sp)
    5b98:	0141                	addi	sp,sp,16
    5b9a:	8082                	ret
  return 0;
    5b9c:	4501                	li	a0,0
    5b9e:	bfe5                	j	5b96 <memcmp+0x30>

0000000000005ba0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5ba0:	1141                	addi	sp,sp,-16
    5ba2:	e406                	sd	ra,8(sp)
    5ba4:	e022                	sd	s0,0(sp)
    5ba6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5ba8:	00000097          	auipc	ra,0x0
    5bac:	f66080e7          	jalr	-154(ra) # 5b0e <memmove>
}
    5bb0:	60a2                	ld	ra,8(sp)
    5bb2:	6402                	ld	s0,0(sp)
    5bb4:	0141                	addi	sp,sp,16
    5bb6:	8082                	ret

0000000000005bb8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5bb8:	4885                	li	a7,1
 ecall
    5bba:	00000073          	ecall
 ret
    5bbe:	8082                	ret

0000000000005bc0 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5bc0:	4889                	li	a7,2
 ecall
    5bc2:	00000073          	ecall
 ret
    5bc6:	8082                	ret

0000000000005bc8 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5bc8:	488d                	li	a7,3
 ecall
    5bca:	00000073          	ecall
 ret
    5bce:	8082                	ret

0000000000005bd0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5bd0:	4891                	li	a7,4
 ecall
    5bd2:	00000073          	ecall
 ret
    5bd6:	8082                	ret

0000000000005bd8 <read>:
.global read
read:
 li a7, SYS_read
    5bd8:	4895                	li	a7,5
 ecall
    5bda:	00000073          	ecall
 ret
    5bde:	8082                	ret

0000000000005be0 <write>:
.global write
write:
 li a7, SYS_write
    5be0:	48c1                	li	a7,16
 ecall
    5be2:	00000073          	ecall
 ret
    5be6:	8082                	ret

0000000000005be8 <close>:
.global close
close:
 li a7, SYS_close
    5be8:	48d5                	li	a7,21
 ecall
    5bea:	00000073          	ecall
 ret
    5bee:	8082                	ret

0000000000005bf0 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5bf0:	4899                	li	a7,6
 ecall
    5bf2:	00000073          	ecall
 ret
    5bf6:	8082                	ret

0000000000005bf8 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5bf8:	489d                	li	a7,7
 ecall
    5bfa:	00000073          	ecall
 ret
    5bfe:	8082                	ret

0000000000005c00 <open>:
.global open
open:
 li a7, SYS_open
    5c00:	48bd                	li	a7,15
 ecall
    5c02:	00000073          	ecall
 ret
    5c06:	8082                	ret

0000000000005c08 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5c08:	48c5                	li	a7,17
 ecall
    5c0a:	00000073          	ecall
 ret
    5c0e:	8082                	ret

0000000000005c10 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5c10:	48c9                	li	a7,18
 ecall
    5c12:	00000073          	ecall
 ret
    5c16:	8082                	ret

0000000000005c18 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5c18:	48a1                	li	a7,8
 ecall
    5c1a:	00000073          	ecall
 ret
    5c1e:	8082                	ret

0000000000005c20 <link>:
.global link
link:
 li a7, SYS_link
    5c20:	48cd                	li	a7,19
 ecall
    5c22:	00000073          	ecall
 ret
    5c26:	8082                	ret

0000000000005c28 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5c28:	48d1                	li	a7,20
 ecall
    5c2a:	00000073          	ecall
 ret
    5c2e:	8082                	ret

0000000000005c30 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c30:	48a5                	li	a7,9
 ecall
    5c32:	00000073          	ecall
 ret
    5c36:	8082                	ret

0000000000005c38 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c38:	48a9                	li	a7,10
 ecall
    5c3a:	00000073          	ecall
 ret
    5c3e:	8082                	ret

0000000000005c40 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c40:	48ad                	li	a7,11
 ecall
    5c42:	00000073          	ecall
 ret
    5c46:	8082                	ret

0000000000005c48 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c48:	48b1                	li	a7,12
 ecall
    5c4a:	00000073          	ecall
 ret
    5c4e:	8082                	ret

0000000000005c50 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5c50:	48b5                	li	a7,13
 ecall
    5c52:	00000073          	ecall
 ret
    5c56:	8082                	ret

0000000000005c58 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5c58:	48b9                	li	a7,14
 ecall
    5c5a:	00000073          	ecall
 ret
    5c5e:	8082                	ret

0000000000005c60 <trace>:
.global trace
trace:
 li a7, SYS_trace
    5c60:	48d9                	li	a7,22
 ecall
    5c62:	00000073          	ecall
 ret
    5c66:	8082                	ret

0000000000005c68 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
    5c68:	48e1                	li	a7,24
 ecall
    5c6a:	00000073          	ecall
 ret
    5c6e:	8082                	ret

0000000000005c70 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
    5c70:	48dd                	li	a7,23
 ecall
    5c72:	00000073          	ecall
 ret
    5c76:	8082                	ret

0000000000005c78 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
    5c78:	48e5                	li	a7,25
 ecall
    5c7a:	00000073          	ecall
 ret
    5c7e:	8082                	ret

0000000000005c80 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
    5c80:	48e9                	li	a7,26
 ecall
    5c82:	00000073          	ecall
 ret
    5c86:	8082                	ret

0000000000005c88 <set_ticket>:
.global set_ticket
set_ticket:
 li a7, SYS_set_ticket
    5c88:	48ed                	li	a7,27
 ecall
    5c8a:	00000073          	ecall
 ret
    5c8e:	8082                	ret

0000000000005c90 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5c90:	1101                	addi	sp,sp,-32
    5c92:	ec06                	sd	ra,24(sp)
    5c94:	e822                	sd	s0,16(sp)
    5c96:	1000                	addi	s0,sp,32
    5c98:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5c9c:	4605                	li	a2,1
    5c9e:	fef40593          	addi	a1,s0,-17
    5ca2:	00000097          	auipc	ra,0x0
    5ca6:	f3e080e7          	jalr	-194(ra) # 5be0 <write>
}
    5caa:	60e2                	ld	ra,24(sp)
    5cac:	6442                	ld	s0,16(sp)
    5cae:	6105                	addi	sp,sp,32
    5cb0:	8082                	ret

0000000000005cb2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5cb2:	7139                	addi	sp,sp,-64
    5cb4:	fc06                	sd	ra,56(sp)
    5cb6:	f822                	sd	s0,48(sp)
    5cb8:	f426                	sd	s1,40(sp)
    5cba:	f04a                	sd	s2,32(sp)
    5cbc:	ec4e                	sd	s3,24(sp)
    5cbe:	0080                	addi	s0,sp,64
    5cc0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5cc2:	c299                	beqz	a3,5cc8 <printint+0x16>
    5cc4:	0805c963          	bltz	a1,5d56 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5cc8:	2581                	sext.w	a1,a1
  neg = 0;
    5cca:	4881                	li	a7,0
    5ccc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5cd0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5cd2:	2601                	sext.w	a2,a2
    5cd4:	00003517          	auipc	a0,0x3
    5cd8:	8f450513          	addi	a0,a0,-1804 # 85c8 <digits>
    5cdc:	883a                	mv	a6,a4
    5cde:	2705                	addiw	a4,a4,1
    5ce0:	02c5f7bb          	remuw	a5,a1,a2
    5ce4:	1782                	slli	a5,a5,0x20
    5ce6:	9381                	srli	a5,a5,0x20
    5ce8:	97aa                	add	a5,a5,a0
    5cea:	0007c783          	lbu	a5,0(a5)
    5cee:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5cf2:	0005879b          	sext.w	a5,a1
    5cf6:	02c5d5bb          	divuw	a1,a1,a2
    5cfa:	0685                	addi	a3,a3,1
    5cfc:	fec7f0e3          	bgeu	a5,a2,5cdc <printint+0x2a>
  if(neg)
    5d00:	00088c63          	beqz	a7,5d18 <printint+0x66>
    buf[i++] = '-';
    5d04:	fd070793          	addi	a5,a4,-48
    5d08:	00878733          	add	a4,a5,s0
    5d0c:	02d00793          	li	a5,45
    5d10:	fef70823          	sb	a5,-16(a4)
    5d14:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5d18:	02e05863          	blez	a4,5d48 <printint+0x96>
    5d1c:	fc040793          	addi	a5,s0,-64
    5d20:	00e78933          	add	s2,a5,a4
    5d24:	fff78993          	addi	s3,a5,-1
    5d28:	99ba                	add	s3,s3,a4
    5d2a:	377d                	addiw	a4,a4,-1
    5d2c:	1702                	slli	a4,a4,0x20
    5d2e:	9301                	srli	a4,a4,0x20
    5d30:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5d34:	fff94583          	lbu	a1,-1(s2)
    5d38:	8526                	mv	a0,s1
    5d3a:	00000097          	auipc	ra,0x0
    5d3e:	f56080e7          	jalr	-170(ra) # 5c90 <putc>
  while(--i >= 0)
    5d42:	197d                	addi	s2,s2,-1
    5d44:	ff3918e3          	bne	s2,s3,5d34 <printint+0x82>
}
    5d48:	70e2                	ld	ra,56(sp)
    5d4a:	7442                	ld	s0,48(sp)
    5d4c:	74a2                	ld	s1,40(sp)
    5d4e:	7902                	ld	s2,32(sp)
    5d50:	69e2                	ld	s3,24(sp)
    5d52:	6121                	addi	sp,sp,64
    5d54:	8082                	ret
    x = -xx;
    5d56:	40b005bb          	negw	a1,a1
    neg = 1;
    5d5a:	4885                	li	a7,1
    x = -xx;
    5d5c:	bf85                	j	5ccc <printint+0x1a>

0000000000005d5e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5d5e:	7119                	addi	sp,sp,-128
    5d60:	fc86                	sd	ra,120(sp)
    5d62:	f8a2                	sd	s0,112(sp)
    5d64:	f4a6                	sd	s1,104(sp)
    5d66:	f0ca                	sd	s2,96(sp)
    5d68:	ecce                	sd	s3,88(sp)
    5d6a:	e8d2                	sd	s4,80(sp)
    5d6c:	e4d6                	sd	s5,72(sp)
    5d6e:	e0da                	sd	s6,64(sp)
    5d70:	fc5e                	sd	s7,56(sp)
    5d72:	f862                	sd	s8,48(sp)
    5d74:	f466                	sd	s9,40(sp)
    5d76:	f06a                	sd	s10,32(sp)
    5d78:	ec6e                	sd	s11,24(sp)
    5d7a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5d7c:	0005c903          	lbu	s2,0(a1)
    5d80:	18090f63          	beqz	s2,5f1e <vprintf+0x1c0>
    5d84:	8aaa                	mv	s5,a0
    5d86:	8b32                	mv	s6,a2
    5d88:	00158493          	addi	s1,a1,1
  state = 0;
    5d8c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5d8e:	02500a13          	li	s4,37
    5d92:	4c55                	li	s8,21
    5d94:	00002c97          	auipc	s9,0x2
    5d98:	7dcc8c93          	addi	s9,s9,2012 # 8570 <malloc+0x254e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    5d9c:	02800d93          	li	s11,40
  putc(fd, 'x');
    5da0:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5da2:	00003b97          	auipc	s7,0x3
    5da6:	826b8b93          	addi	s7,s7,-2010 # 85c8 <digits>
    5daa:	a839                	j	5dc8 <vprintf+0x6a>
        putc(fd, c);
    5dac:	85ca                	mv	a1,s2
    5dae:	8556                	mv	a0,s5
    5db0:	00000097          	auipc	ra,0x0
    5db4:	ee0080e7          	jalr	-288(ra) # 5c90 <putc>
    5db8:	a019                	j	5dbe <vprintf+0x60>
    } else if(state == '%'){
    5dba:	01498d63          	beq	s3,s4,5dd4 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
    5dbe:	0485                	addi	s1,s1,1
    5dc0:	fff4c903          	lbu	s2,-1(s1)
    5dc4:	14090d63          	beqz	s2,5f1e <vprintf+0x1c0>
    if(state == 0){
    5dc8:	fe0999e3          	bnez	s3,5dba <vprintf+0x5c>
      if(c == '%'){
    5dcc:	ff4910e3          	bne	s2,s4,5dac <vprintf+0x4e>
        state = '%';
    5dd0:	89d2                	mv	s3,s4
    5dd2:	b7f5                	j	5dbe <vprintf+0x60>
      if(c == 'd'){
    5dd4:	11490c63          	beq	s2,s4,5eec <vprintf+0x18e>
    5dd8:	f9d9079b          	addiw	a5,s2,-99
    5ddc:	0ff7f793          	zext.b	a5,a5
    5de0:	10fc6e63          	bltu	s8,a5,5efc <vprintf+0x19e>
    5de4:	f9d9079b          	addiw	a5,s2,-99
    5de8:	0ff7f713          	zext.b	a4,a5
    5dec:	10ec6863          	bltu	s8,a4,5efc <vprintf+0x19e>
    5df0:	00271793          	slli	a5,a4,0x2
    5df4:	97e6                	add	a5,a5,s9
    5df6:	439c                	lw	a5,0(a5)
    5df8:	97e6                	add	a5,a5,s9
    5dfa:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5dfc:	008b0913          	addi	s2,s6,8
    5e00:	4685                	li	a3,1
    5e02:	4629                	li	a2,10
    5e04:	000b2583          	lw	a1,0(s6)
    5e08:	8556                	mv	a0,s5
    5e0a:	00000097          	auipc	ra,0x0
    5e0e:	ea8080e7          	jalr	-344(ra) # 5cb2 <printint>
    5e12:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5e14:	4981                	li	s3,0
    5e16:	b765                	j	5dbe <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5e18:	008b0913          	addi	s2,s6,8
    5e1c:	4681                	li	a3,0
    5e1e:	4629                	li	a2,10
    5e20:	000b2583          	lw	a1,0(s6)
    5e24:	8556                	mv	a0,s5
    5e26:	00000097          	auipc	ra,0x0
    5e2a:	e8c080e7          	jalr	-372(ra) # 5cb2 <printint>
    5e2e:	8b4a                	mv	s6,s2
      state = 0;
    5e30:	4981                	li	s3,0
    5e32:	b771                	j	5dbe <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5e34:	008b0913          	addi	s2,s6,8
    5e38:	4681                	li	a3,0
    5e3a:	866a                	mv	a2,s10
    5e3c:	000b2583          	lw	a1,0(s6)
    5e40:	8556                	mv	a0,s5
    5e42:	00000097          	auipc	ra,0x0
    5e46:	e70080e7          	jalr	-400(ra) # 5cb2 <printint>
    5e4a:	8b4a                	mv	s6,s2
      state = 0;
    5e4c:	4981                	li	s3,0
    5e4e:	bf85                	j	5dbe <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5e50:	008b0793          	addi	a5,s6,8
    5e54:	f8f43423          	sd	a5,-120(s0)
    5e58:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5e5c:	03000593          	li	a1,48
    5e60:	8556                	mv	a0,s5
    5e62:	00000097          	auipc	ra,0x0
    5e66:	e2e080e7          	jalr	-466(ra) # 5c90 <putc>
  putc(fd, 'x');
    5e6a:	07800593          	li	a1,120
    5e6e:	8556                	mv	a0,s5
    5e70:	00000097          	auipc	ra,0x0
    5e74:	e20080e7          	jalr	-480(ra) # 5c90 <putc>
    5e78:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5e7a:	03c9d793          	srli	a5,s3,0x3c
    5e7e:	97de                	add	a5,a5,s7
    5e80:	0007c583          	lbu	a1,0(a5)
    5e84:	8556                	mv	a0,s5
    5e86:	00000097          	auipc	ra,0x0
    5e8a:	e0a080e7          	jalr	-502(ra) # 5c90 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5e8e:	0992                	slli	s3,s3,0x4
    5e90:	397d                	addiw	s2,s2,-1
    5e92:	fe0914e3          	bnez	s2,5e7a <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    5e96:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5e9a:	4981                	li	s3,0
    5e9c:	b70d                	j	5dbe <vprintf+0x60>
        s = va_arg(ap, char*);
    5e9e:	008b0913          	addi	s2,s6,8
    5ea2:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    5ea6:	02098163          	beqz	s3,5ec8 <vprintf+0x16a>
        while(*s != 0){
    5eaa:	0009c583          	lbu	a1,0(s3)
    5eae:	c5ad                	beqz	a1,5f18 <vprintf+0x1ba>
          putc(fd, *s);
    5eb0:	8556                	mv	a0,s5
    5eb2:	00000097          	auipc	ra,0x0
    5eb6:	dde080e7          	jalr	-546(ra) # 5c90 <putc>
          s++;
    5eba:	0985                	addi	s3,s3,1
        while(*s != 0){
    5ebc:	0009c583          	lbu	a1,0(s3)
    5ec0:	f9e5                	bnez	a1,5eb0 <vprintf+0x152>
        s = va_arg(ap, char*);
    5ec2:	8b4a                	mv	s6,s2
      state = 0;
    5ec4:	4981                	li	s3,0
    5ec6:	bde5                	j	5dbe <vprintf+0x60>
          s = "(null)";
    5ec8:	00002997          	auipc	s3,0x2
    5ecc:	6a098993          	addi	s3,s3,1696 # 8568 <malloc+0x2546>
        while(*s != 0){
    5ed0:	85ee                	mv	a1,s11
    5ed2:	bff9                	j	5eb0 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    5ed4:	008b0913          	addi	s2,s6,8
    5ed8:	000b4583          	lbu	a1,0(s6)
    5edc:	8556                	mv	a0,s5
    5ede:	00000097          	auipc	ra,0x0
    5ee2:	db2080e7          	jalr	-590(ra) # 5c90 <putc>
    5ee6:	8b4a                	mv	s6,s2
      state = 0;
    5ee8:	4981                	li	s3,0
    5eea:	bdd1                	j	5dbe <vprintf+0x60>
        putc(fd, c);
    5eec:	85d2                	mv	a1,s4
    5eee:	8556                	mv	a0,s5
    5ef0:	00000097          	auipc	ra,0x0
    5ef4:	da0080e7          	jalr	-608(ra) # 5c90 <putc>
      state = 0;
    5ef8:	4981                	li	s3,0
    5efa:	b5d1                	j	5dbe <vprintf+0x60>
        putc(fd, '%');
    5efc:	85d2                	mv	a1,s4
    5efe:	8556                	mv	a0,s5
    5f00:	00000097          	auipc	ra,0x0
    5f04:	d90080e7          	jalr	-624(ra) # 5c90 <putc>
        putc(fd, c);
    5f08:	85ca                	mv	a1,s2
    5f0a:	8556                	mv	a0,s5
    5f0c:	00000097          	auipc	ra,0x0
    5f10:	d84080e7          	jalr	-636(ra) # 5c90 <putc>
      state = 0;
    5f14:	4981                	li	s3,0
    5f16:	b565                	j	5dbe <vprintf+0x60>
        s = va_arg(ap, char*);
    5f18:	8b4a                	mv	s6,s2
      state = 0;
    5f1a:	4981                	li	s3,0
    5f1c:	b54d                	j	5dbe <vprintf+0x60>
    }
  }
}
    5f1e:	70e6                	ld	ra,120(sp)
    5f20:	7446                	ld	s0,112(sp)
    5f22:	74a6                	ld	s1,104(sp)
    5f24:	7906                	ld	s2,96(sp)
    5f26:	69e6                	ld	s3,88(sp)
    5f28:	6a46                	ld	s4,80(sp)
    5f2a:	6aa6                	ld	s5,72(sp)
    5f2c:	6b06                	ld	s6,64(sp)
    5f2e:	7be2                	ld	s7,56(sp)
    5f30:	7c42                	ld	s8,48(sp)
    5f32:	7ca2                	ld	s9,40(sp)
    5f34:	7d02                	ld	s10,32(sp)
    5f36:	6de2                	ld	s11,24(sp)
    5f38:	6109                	addi	sp,sp,128
    5f3a:	8082                	ret

0000000000005f3c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5f3c:	715d                	addi	sp,sp,-80
    5f3e:	ec06                	sd	ra,24(sp)
    5f40:	e822                	sd	s0,16(sp)
    5f42:	1000                	addi	s0,sp,32
    5f44:	e010                	sd	a2,0(s0)
    5f46:	e414                	sd	a3,8(s0)
    5f48:	e818                	sd	a4,16(s0)
    5f4a:	ec1c                	sd	a5,24(s0)
    5f4c:	03043023          	sd	a6,32(s0)
    5f50:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f54:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f58:	8622                	mv	a2,s0
    5f5a:	00000097          	auipc	ra,0x0
    5f5e:	e04080e7          	jalr	-508(ra) # 5d5e <vprintf>
}
    5f62:	60e2                	ld	ra,24(sp)
    5f64:	6442                	ld	s0,16(sp)
    5f66:	6161                	addi	sp,sp,80
    5f68:	8082                	ret

0000000000005f6a <printf>:

void
printf(const char *fmt, ...)
{
    5f6a:	711d                	addi	sp,sp,-96
    5f6c:	ec06                	sd	ra,24(sp)
    5f6e:	e822                	sd	s0,16(sp)
    5f70:	1000                	addi	s0,sp,32
    5f72:	e40c                	sd	a1,8(s0)
    5f74:	e810                	sd	a2,16(s0)
    5f76:	ec14                	sd	a3,24(s0)
    5f78:	f018                	sd	a4,32(s0)
    5f7a:	f41c                	sd	a5,40(s0)
    5f7c:	03043823          	sd	a6,48(s0)
    5f80:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5f84:	00840613          	addi	a2,s0,8
    5f88:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5f8c:	85aa                	mv	a1,a0
    5f8e:	4505                	li	a0,1
    5f90:	00000097          	auipc	ra,0x0
    5f94:	dce080e7          	jalr	-562(ra) # 5d5e <vprintf>
}
    5f98:	60e2                	ld	ra,24(sp)
    5f9a:	6442                	ld	s0,16(sp)
    5f9c:	6125                	addi	sp,sp,96
    5f9e:	8082                	ret

0000000000005fa0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5fa0:	1141                	addi	sp,sp,-16
    5fa2:	e422                	sd	s0,8(sp)
    5fa4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5fa6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5faa:	00003797          	auipc	a5,0x3
    5fae:	4867b783          	ld	a5,1158(a5) # 9430 <freep>
    5fb2:	a02d                	j	5fdc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5fb4:	4618                	lw	a4,8(a2)
    5fb6:	9f2d                	addw	a4,a4,a1
    5fb8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5fbc:	6398                	ld	a4,0(a5)
    5fbe:	6310                	ld	a2,0(a4)
    5fc0:	a83d                	j	5ffe <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5fc2:	ff852703          	lw	a4,-8(a0)
    5fc6:	9f31                	addw	a4,a4,a2
    5fc8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5fca:	ff053683          	ld	a3,-16(a0)
    5fce:	a091                	j	6012 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fd0:	6398                	ld	a4,0(a5)
    5fd2:	00e7e463          	bltu	a5,a4,5fda <free+0x3a>
    5fd6:	00e6ea63          	bltu	a3,a4,5fea <free+0x4a>
{
    5fda:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fdc:	fed7fae3          	bgeu	a5,a3,5fd0 <free+0x30>
    5fe0:	6398                	ld	a4,0(a5)
    5fe2:	00e6e463          	bltu	a3,a4,5fea <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fe6:	fee7eae3          	bltu	a5,a4,5fda <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5fea:	ff852583          	lw	a1,-8(a0)
    5fee:	6390                	ld	a2,0(a5)
    5ff0:	02059813          	slli	a6,a1,0x20
    5ff4:	01c85713          	srli	a4,a6,0x1c
    5ff8:	9736                	add	a4,a4,a3
    5ffa:	fae60de3          	beq	a2,a4,5fb4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5ffe:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    6002:	4790                	lw	a2,8(a5)
    6004:	02061593          	slli	a1,a2,0x20
    6008:	01c5d713          	srli	a4,a1,0x1c
    600c:	973e                	add	a4,a4,a5
    600e:	fae68ae3          	beq	a3,a4,5fc2 <free+0x22>
    p->s.ptr = bp->s.ptr;
    6012:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    6014:	00003717          	auipc	a4,0x3
    6018:	40f73e23          	sd	a5,1052(a4) # 9430 <freep>
}
    601c:	6422                	ld	s0,8(sp)
    601e:	0141                	addi	sp,sp,16
    6020:	8082                	ret

0000000000006022 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    6022:	7139                	addi	sp,sp,-64
    6024:	fc06                	sd	ra,56(sp)
    6026:	f822                	sd	s0,48(sp)
    6028:	f426                	sd	s1,40(sp)
    602a:	f04a                	sd	s2,32(sp)
    602c:	ec4e                	sd	s3,24(sp)
    602e:	e852                	sd	s4,16(sp)
    6030:	e456                	sd	s5,8(sp)
    6032:	e05a                	sd	s6,0(sp)
    6034:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    6036:	02051493          	slli	s1,a0,0x20
    603a:	9081                	srli	s1,s1,0x20
    603c:	04bd                	addi	s1,s1,15
    603e:	8091                	srli	s1,s1,0x4
    6040:	0014899b          	addiw	s3,s1,1
    6044:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    6046:	00003517          	auipc	a0,0x3
    604a:	3ea53503          	ld	a0,1002(a0) # 9430 <freep>
    604e:	c515                	beqz	a0,607a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6050:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6052:	4798                	lw	a4,8(a5)
    6054:	02977f63          	bgeu	a4,s1,6092 <malloc+0x70>
    6058:	8a4e                	mv	s4,s3
    605a:	0009871b          	sext.w	a4,s3
    605e:	6685                	lui	a3,0x1
    6060:	00d77363          	bgeu	a4,a3,6066 <malloc+0x44>
    6064:	6a05                	lui	s4,0x1
    6066:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    606a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    606e:	00003917          	auipc	s2,0x3
    6072:	3c290913          	addi	s2,s2,962 # 9430 <freep>
  if(p == (char*)-1)
    6076:	5afd                	li	s5,-1
    6078:	a895                	j	60ec <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    607a:	0000a797          	auipc	a5,0xa
    607e:	bde78793          	addi	a5,a5,-1058 # fc58 <base>
    6082:	00003717          	auipc	a4,0x3
    6086:	3af73723          	sd	a5,942(a4) # 9430 <freep>
    608a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    608c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    6090:	b7e1                	j	6058 <malloc+0x36>
      if(p->s.size == nunits)
    6092:	02e48c63          	beq	s1,a4,60ca <malloc+0xa8>
        p->s.size -= nunits;
    6096:	4137073b          	subw	a4,a4,s3
    609a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    609c:	02071693          	slli	a3,a4,0x20
    60a0:	01c6d713          	srli	a4,a3,0x1c
    60a4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    60a6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    60aa:	00003717          	auipc	a4,0x3
    60ae:	38a73323          	sd	a0,902(a4) # 9430 <freep>
      return (void*)(p + 1);
    60b2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    60b6:	70e2                	ld	ra,56(sp)
    60b8:	7442                	ld	s0,48(sp)
    60ba:	74a2                	ld	s1,40(sp)
    60bc:	7902                	ld	s2,32(sp)
    60be:	69e2                	ld	s3,24(sp)
    60c0:	6a42                	ld	s4,16(sp)
    60c2:	6aa2                	ld	s5,8(sp)
    60c4:	6b02                	ld	s6,0(sp)
    60c6:	6121                	addi	sp,sp,64
    60c8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    60ca:	6398                	ld	a4,0(a5)
    60cc:	e118                	sd	a4,0(a0)
    60ce:	bff1                	j	60aa <malloc+0x88>
  hp->s.size = nu;
    60d0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    60d4:	0541                	addi	a0,a0,16
    60d6:	00000097          	auipc	ra,0x0
    60da:	eca080e7          	jalr	-310(ra) # 5fa0 <free>
  return freep;
    60de:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    60e2:	d971                	beqz	a0,60b6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    60e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    60e6:	4798                	lw	a4,8(a5)
    60e8:	fa9775e3          	bgeu	a4,s1,6092 <malloc+0x70>
    if(p == freep)
    60ec:	00093703          	ld	a4,0(s2)
    60f0:	853e                	mv	a0,a5
    60f2:	fef719e3          	bne	a4,a5,60e4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    60f6:	8552                	mv	a0,s4
    60f8:	00000097          	auipc	ra,0x0
    60fc:	b50080e7          	jalr	-1200(ra) # 5c48 <sbrk>
  if(p == (char*)-1)
    6100:	fd5518e3          	bne	a0,s5,60d0 <malloc+0xae>
        return 0;
    6104:	4501                	li	a0,0
    6106:	bf45                	j	60b6 <malloc+0x94>
