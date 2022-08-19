
user-sample.elf:     file format elf32-tradlittlemips
user-sample.elf


Disassembly of section .text:

80100000 <_ftext>:
D:\Project\lab\nscscc2022_single_v2\fpga_template_utf8_v1.00\asm/user-sample.s:8
80100000:	34080001 	li	t0,0x1
D:\Project\lab\nscscc2022_single_v2\fpga_template_utf8_v1.00\asm/user-sample.s:9
80100004:	34090001 	li	t1,0x1
D:\Project\lab\nscscc2022_single_v2\fpga_template_utf8_v1.00\asm/user-sample.s:10
80100008:	34020000 	li	v0,0x0
D:\Project\lab\nscscc2022_single_v2\fpga_template_utf8_v1.00\asm/user-sample.s:11
8010000c:	34030008 	li	v1,0x8
D:\Project\lab\nscscc2022_single_v2\fpga_template_utf8_v1.00\asm/user-sample.s:12
80100010:	3c048040 	lui	a0,0x8040

80100014 <loop>:
D:\Project\lab\nscscc2022_single_v2\fpga_template_utf8_v1.00\asm/user-sample.s:15
80100014:	01095021 	addu	t2,t0,t1
D:\Project\lab\nscscc2022_single_v2\fpga_template_utf8_v1.00\asm/user-sample.s:16
80100018:	35280000 	ori	t0,t1,0x0
D:\Project\lab\nscscc2022_single_v2\fpga_template_utf8_v1.00\asm/user-sample.s:17
8010001c:	35490000 	ori	t1,t2,0x0
D:\Project\lab\nscscc2022_single_v2\fpga_template_utf8_v1.00\asm/user-sample.s:18
80100020:	ac890000 	sw	t1,0(a0)
D:\Project\lab\nscscc2022_single_v2\fpga_template_utf8_v1.00\asm/user-sample.s:19
80100024:	24840004 	addiu	a0,a0,4
D:\Project\lab\nscscc2022_single_v2\fpga_template_utf8_v1.00\asm/user-sample.s:20
80100028:	24000000 	li	zero,0
D:\Project\lab\nscscc2022_single_v2\fpga_template_utf8_v1.00\asm/user-sample.s:21
8010002c:	24420001 	addiu	v0,v0,1
D:\Project\lab\nscscc2022_single_v2\fpga_template_utf8_v1.00\asm/user-sample.s:23
80100030:	1443fff8 	bne	v0,v1,80100014 <loop>
D:\Project\lab\nscscc2022_single_v2\fpga_template_utf8_v1.00\asm/user-sample.s:24
80100034:	34000000 	li	zero,0x0
D:\Project\lab\nscscc2022_single_v2\fpga_template_utf8_v1.00\asm/user-sample.s:26
80100038:	03e00008 	jr	ra
D:\Project\lab\nscscc2022_single_v2\fpga_template_utf8_v1.00\asm/user-sample.s:27
8010003c:	34000000 	li	zero,0x0

Disassembly of section .MIPS.abiflags:

00400098 <__bss_start-0x7fd0ffa8>:
  400098:	02200000 	0x2200000
  40009c:	05000101 	bltz	t0,4004a4 <__start+0x4004a4>
  4000a0:	00000000 	nop
	...

Disassembly of section .reginfo:

004000b0 <.reginfo>:
  4000b0:	8000071c 	lb	zero,1820(zero)
	...
  4000c4:	80118030 	lb	s1,-32720(zero)

Disassembly of section .debug_aranges:

00000000 <__start>:
   0:	0000001c 	0x1c
   4:	00000002 	srl	zero,zero,0x0
   8:	00040000 	sll	zero,a0,0x0
   c:	00000000 	nop
  10:	80100000 	lb	s0,0(zero)
  14:	00000040 	ssnop
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
   0:	00000074 	teq	zero,zero,0x1
   4:	00000002 	srl	zero,zero,0x0
   8:	01040000 	0x1040000
   c:	00000000 	nop
  10:	80100000 	lb	s0,0(zero)
  14:	80100040 	lb	s0,64(zero)
  18:	72657375 	q16slr	xr13,xr12,xr5,xr9,9
  1c:	6d61732d 	0x6d61732d
  20:	2e656c70 	sltiu	a1,s3,27760
  24:	3a440073 	xori	a0,s2,0x73
  28:	6f72505c 	0x6f72505c
  2c:	7463656a 	jalx	18d95a8 <__start+0x18d95a8>
  30:	62616c5c 	0x62616c5c
  34:	63736e5c 	0x63736e5c
  38:	32636373 	andi	v1,s3,0x6373
  3c:	5f323230 	0x5f323230
  40:	676e6973 	0x676e6973
  44:	765f656c 	jalx	97d95b0 <__start+0x97d95b0>
  48:	70665c32 	0x70665c32
  4c:	745f6167 	jalx	17d859c <__start+0x17d859c>
  50:	6c706d65 	0x6c706d65
  54:	5f657461 	0x5f657461
  58:	38667475 	xori	a2,v1,0x7475
  5c:	2e31765f 	sltiu	s1,s1,30303
  60:	615c3030 	0x615c3030
  64:	47006d73 	bz.b	$w0,1b634 <__start+0x1b634>
  68:	4120554e 	0x4120554e
  6c:	2e322053 	sltiu	s2,s1,8275
  70:	392e3432 	xori	t6,t1,0x3432
  74:	80010030 	lb	at,48(zero)

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	b	4408 <__start+0x4408>
   4:	12011106 	beq	s0,at,4420 <__start+0x4420>
   8:	1b080301 	0x1b080301
   c:	13082508 	beq	t8,t0,9430 <__start+0x9430>
  10:	00000005 	lsa	zero,zero,zero,0x1

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	00000046 	rorv	zero,zero,zero
   4:	00240002 	ror	zero,a0,0x0
   8:	01010000 	0x1010000
   c:	000d0efb 	0xd0efb
  10:	01010101 	0x1010101
  14:	01000000 	0x1000000
  18:	00010000 	sll	zero,at,0x0
  1c:	72657375 	q16slr	xr13,xr12,xr5,xr9,9
  20:	6d61732d 	0x6d61732d
  24:	2e656c70 	sltiu	a1,s3,27760
  28:	00000073 	tltu	zero,zero,0x1
  2c:	05000000 	bltz	t0,30 <__start+0x30>
  30:	10000002 	b	3c <__start+0x3c>
  34:	4b4b1980 	c2	0x14b1980
  38:	4b4d4b4b 	c2	0x14d4b4b
  3c:	4b4b4b4b 	c2	0x14b4b4b
  40:	4c4b4c4b 	0x4c4b4c4b
  44:	0004024b 	0x4024b
  48:	Address 0x0000000000000048 is out of bounds.


Disassembly of section .gnu.attributes:

00000000 <.gnu.attributes>:
   0:	00000f41 	0xf41
   4:	756e6700 	jalx	5b99c00 <__start+0x5b99c00>
   8:	00070100 	sll	zero,a3,0x4
   c:	05040000 	0x5040000
