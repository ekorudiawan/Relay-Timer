
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8535
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 128 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8535
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 607
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x025F
	.EQU __DSTACK_SIZE=0x0080
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _jam=R5
	.DEF _menit=R4
	.DEF _detik=R7
	.DEF _x=R6
	.DEF _tanggal=R9
	.DEF _bulan=R8
	.DEF _tahun=R11
	.DEF __lcd_x=R10
	.DEF __lcd_y=R13
	.DEF __lcd_maxx=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x53,0x65,0x74,0x20,0x54,0x69,0x6D,0x65
	.DB  0x72,0x20,0x42,0x65,0x62,0x61,0x6E,0x31
	.DB  0x0,0x53,0x65,0x74,0x20,0x54,0x69,0x6D
	.DB  0x65,0x72,0x20,0x4F,0x6E,0x20,0x20,0x20
	.DB  0x20,0x0,0x25,0x64,0x0,0x53,0x65,0x74
	.DB  0x20,0x54,0x69,0x6D,0x65,0x72,0x20,0x4F
	.DB  0x66,0x66,0x20,0x20,0x20,0x0,0x53,0x65
	.DB  0x74,0x74,0x69,0x6E,0x67,0x20,0x46,0x69
	.DB  0x6E,0x69,0x73,0x68,0x20,0x20,0x0,0x53
	.DB  0x65,0x74,0x20,0x54,0x69,0x6D,0x65,0x72
	.DB  0x20,0x42,0x65,0x62,0x61,0x6E,0x32,0x0
	.DB  0x53,0x65,0x74,0x20,0x54,0x69,0x6D,0x65
	.DB  0x72,0x20,0x42,0x65,0x62,0x61,0x6E,0x33
	.DB  0x0,0x53,0x65,0x74,0x20,0x54,0x69,0x6D
	.DB  0x65,0x72,0x20,0x42,0x65,0x62,0x61,0x6E
	.DB  0x34,0x0,0x54,0x34,0x20,0x4F,0x6E,0x20
	.DB  0x20,0x3E,0x20,0x25,0x32,0x64,0x3A,0x25
	.DB  0x32,0x64,0x20,0x0,0x54,0x34,0x20,0x4F
	.DB  0x66,0x66,0x20,0x3E,0x20,0x25,0x32,0x64
	.DB  0x3A,0x25,0x32,0x64,0x20,0x0,0x54,0x33
	.DB  0x20,0x4F,0x6E,0x20,0x20,0x3E,0x20,0x25
	.DB  0x32,0x64,0x3A,0x25,0x32,0x64,0x20,0x0
	.DB  0x54,0x33,0x20,0x4F,0x66,0x66,0x20,0x3E
	.DB  0x20,0x25,0x32,0x64,0x3A,0x25,0x32,0x64
	.DB  0x20,0x0,0x54,0x32,0x20,0x4F,0x6E,0x20
	.DB  0x20,0x3E,0x20,0x25,0x32,0x64,0x3A,0x25
	.DB  0x32,0x64,0x20,0x0,0x54,0x32,0x20,0x4F
	.DB  0x66,0x66,0x20,0x3E,0x20,0x25,0x32,0x64
	.DB  0x3A,0x25,0x32,0x64,0x20,0x0,0x54,0x31
	.DB  0x20,0x4F,0x6E,0x20,0x20,0x3E,0x20,0x25
	.DB  0x32,0x64,0x3A,0x25,0x32,0x64,0x20,0x0
	.DB  0x54,0x31,0x20,0x4F,0x66,0x66,0x20,0x3E
	.DB  0x20,0x25,0x32,0x64,0x3A,0x25,0x32,0x64
	.DB  0x20,0x0,0x4A,0x61,0x6D,0x20,0x3D,0x3E
	.DB  0x20,0x25,0x32,0x64,0x3A,0x25,0x32,0x64
	.DB  0x3A,0x25,0x32,0x64,0x20,0x0,0x54,0x67
	.DB  0x6C,0x20,0x3D,0x3E,0x20,0x25,0x32,0x64
	.DB  0x2F,0x25,0x32,0x64,0x2F,0x25,0x32,0x64
	.DB  0x20,0x0
_0x2040003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x11
	.DW  _0x49
	.DW  _0x0*2

	.DW  0x11
	.DW  _0x49+17
	.DW  _0x0*2+17

	.DW  0x11
	.DW  _0x49+34
	.DW  _0x0*2+37

	.DW  0x11
	.DW  _0x49+51
	.DW  _0x0*2+54

	.DW  0x11
	.DW  _0x4D
	.DW  _0x0*2+71

	.DW  0x11
	.DW  _0x4D+17
	.DW  _0x0*2+17

	.DW  0x11
	.DW  _0x4D+34
	.DW  _0x0*2+37

	.DW  0x11
	.DW  _0x4D+51
	.DW  _0x0*2+54

	.DW  0x11
	.DW  _0x51
	.DW  _0x0*2+88

	.DW  0x11
	.DW  _0x51+17
	.DW  _0x0*2+17

	.DW  0x11
	.DW  _0x51+34
	.DW  _0x0*2+37

	.DW  0x11
	.DW  _0x51+51
	.DW  _0x0*2+54

	.DW  0x11
	.DW  _0x55
	.DW  _0x0*2+105

	.DW  0x11
	.DW  _0x55+17
	.DW  _0x0*2+17

	.DW  0x11
	.DW  _0x55+34
	.DW  _0x0*2+37

	.DW  0x11
	.DW  _0x55+51
	.DW  _0x0*2+54

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0xE0

	.CSEG
;/*****************************************************
;PROSEDUR PENGGUNAAN
;SECARA DEFAULT TAMPILAN LCD AKAN MENAMPILKAN JAM DAN TANGGAL
;UNTUK MELAKUKAN PENGATURAN WAKTU NYALA/MATI SETIAP BEBAN DAPAT MENEKAN TOMBOL PUSHBUTTON
;SETELAH TOMBOL DITEKAN ANDA AKAN DIMINTA UNTUK MEMASUKKAN WAKTU ON DAN WAKTU OFF MELALUI KEYPAD
;PADA SAAT DI LCD MUNCUL TULISAN TIMER ON KETIK JAM YANG AKAN DIMASUKKAN KE SETTINGAN
;FORMAT DATA YANG DIMASUKKAN ADALAH SEBAGAI BERIKUT
;CONTOH :
;08*15
;KEMUDIAN DIAKHIRI DENGAN MENEKAN #
;FORMAT JAM ADALAH 24 JAM
;SETINGAN JAM AKAN OTOMATIS DIMASUKKAN KE EEPROM
;ANDA BISA MELIHAT SETTINGAN NYALA/MATI SETIAP BEBAN DENGAN MENEKAN HURUF 'A' 'B' 'C' ATAU 'D' PADA KEYPAD, PADA SAAT LCD MENAMPILKAN JAM DAN TANGGAL
;*****************************************************/
;
;#include <mega8535.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;
;// I2C Bus functions
;#asm
   .equ __i2c_port=0x15 ;PORTC
   .equ __sda_bit=1
   .equ __scl_bit=0
; 0000 0019 #endasm
;#include <i2c.h>
;
;// DS1307 Real Time Clock functions
;#include <ds1307.h>
;
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;
;#define  SW_BEBAN1   PINB.0
;#define  SW_BEBAN2   PINB.1
;#define  SW_BEBAN3   PINB.2
;#define  SW_BEBAN4   PINB.3
;
;#define  BEBAN1      PORTC.4
;#define  BEBAN2      PORTC.5
;#define  BEBAN3      PORTC.6
;#define  BEBAN4      PORTC.7
;
;#define  DDR_KEYPAD  DDRD
;#define  KEYPAD_OUT  PORTD
;#define  KEYPAD_IN   PIND
;
;unsigned char jam, menit, detik;
;unsigned char x, tanggal, bulan, tahun;
;
;unsigned char jamTimerOn[4], menitTimerOn[4], jamTimerOff[4], menitTimerOff[4];
;eeprom unsigned char _jamTimerOn[4], _menitTimerOn[4], _jamTimerOff[4], _menitTimerOff[4];
;
;char dataKeypad[16];
;char bufferLcd1[16], bufferLcd2[16];
;
;void bacaRTC() {
; 0000 0039 void bacaRTC() {

	.CSEG
_bacaRTC:
; 0000 003A    rtc_get_time(&jam,&menit,&detik);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x0
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x0
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RCALL SUBOPT_0x0
	RCALL _rtc_get_time
; 0000 003B    rtc_get_date(&x,&tanggal,&bulan,&tahun);
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL SUBOPT_0x0
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RCALL SUBOPT_0x0
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x0
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	RCALL SUBOPT_0x0
	RCALL _rtc_get_date
; 0000 003C }
	RET
;
;void clearDataKeypad() {
; 0000 003E void clearDataKeypad() {
_clearDataKeypad:
; 0000 003F    int i;
; 0000 0040    for(i=0;i<16;i++) {
	RCALL __SAVELOCR2
;	i -> R16,R17
	RCALL SUBOPT_0x1
_0x4:
	__CPWRN 16,17,16
	BRGE _0x5
; 0000 0041       dataKeypad[i]=0;
	LDI  R26,LOW(_dataKeypad)
	LDI  R27,HIGH(_dataKeypad)
	RCALL SUBOPT_0x2
; 0000 0042    }
	RCALL SUBOPT_0x3
	RJMP _0x4
_0x5:
; 0000 0043 }
	RCALL __LOADLOCR2P
	RET
;
;void scanKeypad(char limiter, int display, unsigned char startX, unsigned char startY) {
; 0000 0045 void scanKeypad(char limiter, int display, unsigned char startX, unsigned char startY) {
_scanKeypad:
	PUSH R15
; 0000 0046    unsigned char counter=0;
; 0000 0047    bit selesai = 0;
; 0000 0048    clearDataKeypad();
	ST   -Y,R17
;	limiter -> Y+5
;	display -> Y+3
;	startX -> Y+2
;	startY -> Y+1
;	counter -> R17
;	selesai -> R15.0
	CLR  R15
	LDI  R17,0
	RCALL _clearDataKeypad
; 0000 0049    while(!selesai) {
_0x6:
	SBRC R15,0
	RJMP _0x8
; 0000 004A       lcd_gotoxy(startX,startY);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x4
	RCALL _lcd_gotoxy
; 0000 004B       KEYPAD_OUT=0b01111111;
	LDI  R30,LOW(127)
	RCALL SUBOPT_0x5
; 0000 004C       delay_ms(30);
; 0000 004D       if(KEYPAD_IN.0==0) {
	SBIC 0x10,0
	RJMP _0x9
; 0000 004E          if(limiter=='*') {
	LDD  R26,Y+5
	CPI  R26,LOW(0x2A)
	BRNE _0xA
; 0000 004F             selesai = 1;
	RCALL SUBOPT_0x6
; 0000 0050          }
; 0000 0051          else {
	RJMP _0xB
_0xA:
; 0000 0052             dataKeypad[counter]='*';
	RCALL SUBOPT_0x7
	LDI  R26,LOW(42)
	RCALL SUBOPT_0x8
; 0000 0053             if(display) {
	BREQ _0xC
; 0000 0054                lcd_gotoxy(counter+startX,startY);
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 0055                lcd_putchar(dataKeypad[counter]);
	RCALL SUBOPT_0xB
; 0000 0056             }
; 0000 0057             counter++;
_0xC:
	SUBI R17,-1
; 0000 0058          }
_0xB:
; 0000 0059          delay_ms(200);
	RCALL SUBOPT_0xC
; 0000 005A       }
; 0000 005B       if(KEYPAD_IN.1==0) {
_0x9:
	SBIC 0x10,1
	RJMP _0xD
; 0000 005C          if(limiter=='7') {
	LDD  R26,Y+5
	CPI  R26,LOW(0x37)
	BRNE _0xE
; 0000 005D             selesai = 1;
	RCALL SUBOPT_0x6
; 0000 005E          }
; 0000 005F          else {
	RJMP _0xF
_0xE:
; 0000 0060             dataKeypad[counter]='7';
	RCALL SUBOPT_0x7
	LDI  R26,LOW(55)
	RCALL SUBOPT_0x8
; 0000 0061             if(display) {
	BREQ _0x10
; 0000 0062                lcd_gotoxy(counter+startX,startY);
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 0063                lcd_putchar(dataKeypad[counter]);
	RCALL SUBOPT_0xB
; 0000 0064             }
; 0000 0065             counter++;
_0x10:
	SUBI R17,-1
; 0000 0066          }
_0xF:
; 0000 0067          delay_ms(200);
	RCALL SUBOPT_0xC
; 0000 0068       }
; 0000 0069       if(KEYPAD_IN.2==0) {
_0xD:
	SBIC 0x10,2
	RJMP _0x11
; 0000 006A          if(limiter=='4') {
	LDD  R26,Y+5
	CPI  R26,LOW(0x34)
	BRNE _0x12
; 0000 006B             selesai = 1;
	RCALL SUBOPT_0x6
; 0000 006C          }
; 0000 006D          else {
	RJMP _0x13
_0x12:
; 0000 006E             dataKeypad[counter]='4';
	RCALL SUBOPT_0x7
	LDI  R26,LOW(52)
	RCALL SUBOPT_0x8
; 0000 006F             if(display) {
	BREQ _0x14
; 0000 0070                lcd_gotoxy(counter+startX,startY);
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 0071                lcd_putchar(dataKeypad[counter]);
	RCALL SUBOPT_0xB
; 0000 0072             }
; 0000 0073             counter++;
_0x14:
	SUBI R17,-1
; 0000 0074          }
_0x13:
; 0000 0075          delay_ms(200);
	RCALL SUBOPT_0xC
; 0000 0076       }
; 0000 0077       if(KEYPAD_IN.3==0) {
_0x11:
	SBIC 0x10,3
	RJMP _0x15
; 0000 0078          if(limiter=='1') {
	LDD  R26,Y+5
	CPI  R26,LOW(0x31)
	BRNE _0x16
; 0000 0079             selesai = 1;
	RCALL SUBOPT_0x6
; 0000 007A          }
; 0000 007B          else {
	RJMP _0x17
_0x16:
; 0000 007C             dataKeypad[counter]='1';
	RCALL SUBOPT_0x7
	LDI  R26,LOW(49)
	RCALL SUBOPT_0x8
; 0000 007D             if(display) {
	BREQ _0x18
; 0000 007E                lcd_gotoxy(counter+startX,startY);
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 007F                lcd_putchar(dataKeypad[counter]);
	RCALL SUBOPT_0xB
; 0000 0080             }
; 0000 0081             counter++;
_0x18:
	SUBI R17,-1
; 0000 0082          }
_0x17:
; 0000 0083          delay_ms(200);
	RCALL SUBOPT_0xC
; 0000 0084       }
; 0000 0085       KEYPAD_OUT=0b10111111;
_0x15:
	LDI  R30,LOW(191)
	RCALL SUBOPT_0x5
; 0000 0086       delay_ms(30);
; 0000 0087       if(KEYPAD_IN.0==0) {
	SBIC 0x10,0
	RJMP _0x19
; 0000 0088          if(limiter=='0') {
	LDD  R26,Y+5
	CPI  R26,LOW(0x30)
	BRNE _0x1A
; 0000 0089             selesai = 1;
	RCALL SUBOPT_0x6
; 0000 008A          }
; 0000 008B          else {
	RJMP _0x1B
_0x1A:
; 0000 008C             dataKeypad[counter]='0';
	RCALL SUBOPT_0x7
	LDI  R26,LOW(48)
	RCALL SUBOPT_0x8
; 0000 008D             if(display) {
	BREQ _0x1C
; 0000 008E                lcd_gotoxy(counter+startX,startY);
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 008F                lcd_putchar(dataKeypad[counter]);
	RCALL SUBOPT_0xB
; 0000 0090             }
; 0000 0091             counter++;
_0x1C:
	SUBI R17,-1
; 0000 0092          }
_0x1B:
; 0000 0093          delay_ms(200);
	RCALL SUBOPT_0xC
; 0000 0094       }
; 0000 0095       if(KEYPAD_IN.1==0) {
_0x19:
	SBIC 0x10,1
	RJMP _0x1D
; 0000 0096          if(limiter=='8') {
	LDD  R26,Y+5
	CPI  R26,LOW(0x38)
	BRNE _0x1E
; 0000 0097             selesai = 1;
	RCALL SUBOPT_0x6
; 0000 0098          }
; 0000 0099          else {
	RJMP _0x1F
_0x1E:
; 0000 009A             dataKeypad[counter]='8';
	RCALL SUBOPT_0x7
	LDI  R26,LOW(56)
	RCALL SUBOPT_0x8
; 0000 009B             if(display) {
	BREQ _0x20
; 0000 009C                lcd_gotoxy(counter+startX,startY);
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 009D                lcd_putchar(dataKeypad[counter]);
	RCALL SUBOPT_0xB
; 0000 009E             }
; 0000 009F             counter++;
_0x20:
	SUBI R17,-1
; 0000 00A0          }
_0x1F:
; 0000 00A1          delay_ms(200);
	RCALL SUBOPT_0xC
; 0000 00A2       }
; 0000 00A3       if(KEYPAD_IN.2==0) {
_0x1D:
	SBIC 0x10,2
	RJMP _0x21
; 0000 00A4          if(limiter=='5') {
	LDD  R26,Y+5
	CPI  R26,LOW(0x35)
	BRNE _0x22
; 0000 00A5             selesai = 1;
	RCALL SUBOPT_0x6
; 0000 00A6          }
; 0000 00A7          else {
	RJMP _0x23
_0x22:
; 0000 00A8             dataKeypad[counter]='5';
	RCALL SUBOPT_0x7
	LDI  R26,LOW(53)
	RCALL SUBOPT_0x8
; 0000 00A9             if(display) {
	BREQ _0x24
; 0000 00AA                lcd_gotoxy(counter+startX,startY);
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 00AB                lcd_putchar(dataKeypad[counter]);
	RCALL SUBOPT_0xB
; 0000 00AC             }
; 0000 00AD             counter++;
_0x24:
	SUBI R17,-1
; 0000 00AE          }
_0x23:
; 0000 00AF          delay_ms(200);
	RCALL SUBOPT_0xC
; 0000 00B0       }
; 0000 00B1       if(KEYPAD_IN.3==0) {
_0x21:
	SBIC 0x10,3
	RJMP _0x25
; 0000 00B2          if(limiter=='2') {
	LDD  R26,Y+5
	CPI  R26,LOW(0x32)
	BRNE _0x26
; 0000 00B3             selesai = 1;
	RCALL SUBOPT_0x6
; 0000 00B4          }
; 0000 00B5          else {
	RJMP _0x27
_0x26:
; 0000 00B6             dataKeypad[counter]='2';
	RCALL SUBOPT_0x7
	LDI  R26,LOW(50)
	RCALL SUBOPT_0x8
; 0000 00B7             if(display) {
	BREQ _0x28
; 0000 00B8                lcd_gotoxy(counter+startX,startY);
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 00B9                lcd_putchar(dataKeypad[counter]);
	RCALL SUBOPT_0xB
; 0000 00BA             }
; 0000 00BB             counter++;
_0x28:
	SUBI R17,-1
; 0000 00BC          }
_0x27:
; 0000 00BD          delay_ms(200);
	RCALL SUBOPT_0xC
; 0000 00BE       }
; 0000 00BF       KEYPAD_OUT=0b11011111;
_0x25:
	LDI  R30,LOW(223)
	RCALL SUBOPT_0x5
; 0000 00C0       delay_ms(30);
; 0000 00C1       if(KEYPAD_IN.0==0) {
	SBIC 0x10,0
	RJMP _0x29
; 0000 00C2          if(limiter=='#') {
	LDD  R26,Y+5
	CPI  R26,LOW(0x23)
	BRNE _0x2A
; 0000 00C3             selesai = 1;
	RCALL SUBOPT_0x6
; 0000 00C4          }
; 0000 00C5          else {
	RJMP _0x2B
_0x2A:
; 0000 00C6             dataKeypad[counter]='#';
	RCALL SUBOPT_0x7
	LDI  R26,LOW(35)
	RCALL SUBOPT_0x8
; 0000 00C7             if(display) {
	BREQ _0x2C
; 0000 00C8                lcd_gotoxy(counter+startX,startY);
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 00C9                lcd_putchar(dataKeypad[counter]);
	RCALL SUBOPT_0xB
; 0000 00CA             }
; 0000 00CB             counter++;
_0x2C:
	SUBI R17,-1
; 0000 00CC          }
_0x2B:
; 0000 00CD          delay_ms(200);
	RCALL SUBOPT_0xC
; 0000 00CE       }
; 0000 00CF       if(KEYPAD_IN.1==0) {
_0x29:
	SBIC 0x10,1
	RJMP _0x2D
; 0000 00D0          if(limiter=='9') {
	LDD  R26,Y+5
	CPI  R26,LOW(0x39)
	BRNE _0x2E
; 0000 00D1             selesai = 1;
	RCALL SUBOPT_0x6
; 0000 00D2          }
; 0000 00D3          else {
	RJMP _0x2F
_0x2E:
; 0000 00D4             dataKeypad[counter]='9';
	RCALL SUBOPT_0x7
	LDI  R26,LOW(57)
	RCALL SUBOPT_0x8
; 0000 00D5             if(display) {
	BREQ _0x30
; 0000 00D6                lcd_gotoxy(counter+startX,startY);
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 00D7                lcd_putchar(dataKeypad[counter]);
	RCALL SUBOPT_0xB
; 0000 00D8             }
; 0000 00D9             counter++;
_0x30:
	SUBI R17,-1
; 0000 00DA          }
_0x2F:
; 0000 00DB          delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0xD
; 0000 00DC       }
; 0000 00DD       if(KEYPAD_IN.2==0) {
_0x2D:
	SBIC 0x10,2
	RJMP _0x31
; 0000 00DE          if(limiter=='6') {
	LDD  R26,Y+5
	CPI  R26,LOW(0x36)
	BRNE _0x32
; 0000 00DF             selesai = 1;
	RCALL SUBOPT_0x6
; 0000 00E0          }
; 0000 00E1          else {
	RJMP _0x33
_0x32:
; 0000 00E2             dataKeypad[counter]='6';
	RCALL SUBOPT_0x7
	LDI  R26,LOW(54)
	RCALL SUBOPT_0x8
; 0000 00E3             if(display) {
	BREQ _0x34
; 0000 00E4                lcd_gotoxy(counter+startX,startY);
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 00E5                lcd_putchar(dataKeypad[counter]);
	RCALL SUBOPT_0xB
; 0000 00E6             }
; 0000 00E7             counter++;
_0x34:
	SUBI R17,-1
; 0000 00E8          }
_0x33:
; 0000 00E9          delay_ms(200);
	RCALL SUBOPT_0xC
; 0000 00EA       }
; 0000 00EB       if(KEYPAD_IN.3==0) {
_0x31:
	SBIC 0x10,3
	RJMP _0x35
; 0000 00EC          if(limiter=='3') {
	LDD  R26,Y+5
	CPI  R26,LOW(0x33)
	BRNE _0x36
; 0000 00ED             selesai = 1;
	RCALL SUBOPT_0x6
; 0000 00EE          }
; 0000 00EF          else {
	RJMP _0x37
_0x36:
; 0000 00F0             dataKeypad[counter]='3';
	RCALL SUBOPT_0x7
	LDI  R26,LOW(51)
	RCALL SUBOPT_0x8
; 0000 00F1             if(display) {
	BREQ _0x38
; 0000 00F2                lcd_gotoxy(counter+startX,startY);
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 00F3                lcd_putchar(dataKeypad[counter]);
	RCALL SUBOPT_0xB
; 0000 00F4             }
; 0000 00F5             counter++;
_0x38:
	SUBI R17,-1
; 0000 00F6          }
_0x37:
; 0000 00F7          delay_ms(200);
	RCALL SUBOPT_0xC
; 0000 00F8       }
; 0000 00F9       KEYPAD_OUT=0b11101111;
_0x35:
	LDI  R30,LOW(239)
	RCALL SUBOPT_0x5
; 0000 00FA       delay_ms(30);
; 0000 00FB       if(KEYPAD_IN.0==0) {
	SBIC 0x10,0
	RJMP _0x39
; 0000 00FC          if(limiter=='D') {
	LDD  R26,Y+5
	CPI  R26,LOW(0x44)
	BRNE _0x3A
; 0000 00FD             selesai = 1;
	RCALL SUBOPT_0x6
; 0000 00FE          }
; 0000 00FF          else {
	RJMP _0x3B
_0x3A:
; 0000 0100             dataKeypad[counter]='D';
	RCALL SUBOPT_0x7
	LDI  R26,LOW(68)
	RCALL SUBOPT_0x8
; 0000 0101             if(display) {
	BREQ _0x3C
; 0000 0102                lcd_gotoxy(counter+startX,startY);
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 0103                lcd_putchar(dataKeypad[counter]);
	RCALL SUBOPT_0xB
; 0000 0104             }
; 0000 0105             counter++;
_0x3C:
	SUBI R17,-1
; 0000 0106          }
_0x3B:
; 0000 0107          delay_ms(200);
	RCALL SUBOPT_0xC
; 0000 0108       }
; 0000 0109       if(KEYPAD_IN.1==0) {
_0x39:
	SBIC 0x10,1
	RJMP _0x3D
; 0000 010A          if(limiter=='C') {
	LDD  R26,Y+5
	CPI  R26,LOW(0x43)
	BRNE _0x3E
; 0000 010B             selesai = 1;
	RCALL SUBOPT_0x6
; 0000 010C          }
; 0000 010D          else {
	RJMP _0x3F
_0x3E:
; 0000 010E             dataKeypad[counter]='C';
	RCALL SUBOPT_0x7
	LDI  R26,LOW(67)
	RCALL SUBOPT_0x8
; 0000 010F             if(display) {
	BREQ _0x40
; 0000 0110                lcd_gotoxy(counter+startX,startY);
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 0111                lcd_putchar(dataKeypad[counter]);
	RCALL SUBOPT_0xB
; 0000 0112             }
; 0000 0113             counter++;
_0x40:
	SUBI R17,-1
; 0000 0114          }
_0x3F:
; 0000 0115          delay_ms(200);
	RCALL SUBOPT_0xC
; 0000 0116       }
; 0000 0117       if(KEYPAD_IN.2==0) {
_0x3D:
	SBIC 0x10,2
	RJMP _0x41
; 0000 0118          if(limiter=='B') {
	LDD  R26,Y+5
	CPI  R26,LOW(0x42)
	BRNE _0x42
; 0000 0119             selesai = 1;
	RCALL SUBOPT_0x6
; 0000 011A          }
; 0000 011B          else {
	RJMP _0x43
_0x42:
; 0000 011C             dataKeypad[counter]='B';
	RCALL SUBOPT_0x7
	LDI  R26,LOW(66)
	RCALL SUBOPT_0x8
; 0000 011D             if(display) {
	BREQ _0x44
; 0000 011E                lcd_gotoxy(counter+startX,startY);
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 011F                lcd_putchar(dataKeypad[counter]);
	RCALL SUBOPT_0xB
; 0000 0120             }
; 0000 0121             counter++;
_0x44:
	SUBI R17,-1
; 0000 0122          }
_0x43:
; 0000 0123          delay_ms(200);
	RCALL SUBOPT_0xC
; 0000 0124       }
; 0000 0125       if(KEYPAD_IN.3==0) {
_0x41:
	SBIC 0x10,3
	RJMP _0x45
; 0000 0126          if(limiter=='A') {
	LDD  R26,Y+5
	CPI  R26,LOW(0x41)
	BRNE _0x46
; 0000 0127             selesai = 1;
	RCALL SUBOPT_0x6
; 0000 0128          }
; 0000 0129          else {
	RJMP _0x47
_0x46:
; 0000 012A             dataKeypad[counter]='A';
	RCALL SUBOPT_0x7
	LDI  R26,LOW(65)
	RCALL SUBOPT_0x8
; 0000 012B             if(display) {
	BREQ _0x48
; 0000 012C                lcd_gotoxy(counter+startX,startY);
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 012D                lcd_putchar(dataKeypad[counter]);
	RCALL SUBOPT_0xB
; 0000 012E             }
; 0000 012F             counter++;
_0x48:
	SUBI R17,-1
; 0000 0130          }
_0x47:
; 0000 0131          delay_ms(200);
	RCALL SUBOPT_0xC
; 0000 0132       }
; 0000 0133    }
_0x45:
	RJMP _0x6
_0x8:
; 0000 0134 }
	LDD  R17,Y+0
	ADIW R28,6
	POP  R15
	RET
;
;void menuSetting1() {
; 0000 0136 void menuSetting1() {
_menuSetting1:
	PUSH R15
; 0000 0137    char jOn[3], dOn[3], jOff[3], dOff[3];
; 0000 0138    bit inputSalah = 0;
; 0000 0139    int i;
; 0000 013A    lcd_clear();
	RCALL SUBOPT_0xE
;	jOn -> Y+11
;	dOn -> Y+8
;	jOff -> Y+5
;	dOff -> Y+2
;	inputSalah -> R15.0
;	i -> R16,R17
; 0000 013B    lcd_gotoxy(0,0);
; 0000 013C    lcd_puts("Set Timer Beban1");
	__POINTW1MN _0x49,0
	RCALL SUBOPT_0xF
; 0000 013D    delay_ms(1000);
	RCALL SUBOPT_0x10
; 0000 013E 
; 0000 013F    for(i=0;i<3;i++) {
	RCALL SUBOPT_0x1
_0x4B:
	RCALL SUBOPT_0x11
	BRGE _0x4C
; 0000 0140       jOn[i]=0;
	RCALL SUBOPT_0x12
; 0000 0141       dOn[i]=0;
	RCALL SUBOPT_0x13
; 0000 0142       jOff[i]=0;
	RCALL SUBOPT_0x14
; 0000 0143       dOff[i]=0;
	RCALL SUBOPT_0x15
; 0000 0144    }
	RCALL SUBOPT_0x3
	RJMP _0x4B
_0x4C:
; 0000 0145 
; 0000 0146    lcd_clear();
	RCALL SUBOPT_0x16
; 0000 0147    lcd_gotoxy(0,0);
; 0000 0148    lcd_puts("Set Timer On    ");
	__POINTW1MN _0x49,17
	RCALL SUBOPT_0xF
; 0000 0149    scanKeypad('#',1,0,1);
	RCALL SUBOPT_0x17
; 0000 014A    jOn[0]=dataKeypad[0];
	RCALL SUBOPT_0x18
; 0000 014B    jOn[1]=dataKeypad[1];
; 0000 014C    dOn[0]=dataKeypad[3];
; 0000 014D    dOn[1]=dataKeypad[4];
; 0000 014E    sscanf(jOn,"%d",&jamTimerOn[0]);
	LDI  R30,LOW(_jamTimerOn)
	LDI  R31,HIGH(_jamTimerOn)
	RCALL SUBOPT_0x19
; 0000 014F    sscanf(dOn,"%d",&menitTimerOn[0]);
	RCALL SUBOPT_0x1A
	LDI  R30,LOW(_menitTimerOn)
	LDI  R31,HIGH(_menitTimerOn)
	RCALL SUBOPT_0x19
; 0000 0150    // SIMPAN KE EEPROM
; 0000 0151    _jamTimerOn[0] = jamTimerOn[0];
	LDS  R30,_jamTimerOn
	RCALL SUBOPT_0x1B
	RCALL __EEPROMWRB
; 0000 0152    _menitTimerOn[0] = menitTimerOn[0];
	LDS  R30,_menitTimerOn
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
; 0000 0153 
; 0000 0154    lcd_clear();
; 0000 0155    lcd_gotoxy(0,0);
; 0000 0156    lcd_puts("Set Timer Off   ");
	__POINTW1MN _0x49,34
	RCALL SUBOPT_0xF
; 0000 0157    scanKeypad('#',1,0,1);
	RCALL SUBOPT_0x17
; 0000 0158 
; 0000 0159    jOff[0]=dataKeypad[0];
	RCALL SUBOPT_0x1E
; 0000 015A    jOff[1]=dataKeypad[1];
; 0000 015B    dOff[0]=dataKeypad[3];
; 0000 015C    dOff[1]=dataKeypad[4];
; 0000 015D 
; 0000 015E    sscanf(jOff,"%d",&jamTimerOff[0]);
	LDI  R30,LOW(_jamTimerOff)
	LDI  R31,HIGH(_jamTimerOff)
	RCALL SUBOPT_0x19
; 0000 015F    sscanf(dOff,"%d",&menitTimerOff[0]);
	RCALL SUBOPT_0x1F
	LDI  R30,LOW(_menitTimerOff)
	LDI  R31,HIGH(_menitTimerOff)
	RCALL SUBOPT_0x19
; 0000 0160 
; 0000 0161    // SIMPAN KE EEPROM
; 0000 0162    _jamTimerOff[0] = jamTimerOff[0];
	LDS  R30,_jamTimerOff
	RCALL SUBOPT_0x20
	RCALL __EEPROMWRB
; 0000 0163    _menitTimerOff[0] = menitTimerOff[0];
	LDS  R30,_menitTimerOff
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x1D
; 0000 0164 
; 0000 0165    lcd_clear();
; 0000 0166    lcd_gotoxy(0,0);
; 0000 0167    lcd_puts("Setting Finish  ");
	__POINTW1MN _0x49,51
	RJMP _0x20C0008
; 0000 0168    delay_ms(1000);
; 0000 0169 }

	.DSEG
_0x49:
	.BYTE 0x44
;
;void menuSetting2() {
; 0000 016B void menuSetting2() {

	.CSEG
_menuSetting2:
	PUSH R15
; 0000 016C    char jOn[3], dOn[3], jOff[3], dOff[3];
; 0000 016D    bit inputSalah = 0;
; 0000 016E    int i;
; 0000 016F    lcd_clear();
	RCALL SUBOPT_0xE
;	jOn -> Y+11
;	dOn -> Y+8
;	jOff -> Y+5
;	dOff -> Y+2
;	inputSalah -> R15.0
;	i -> R16,R17
; 0000 0170    lcd_gotoxy(0,0);
; 0000 0171    lcd_puts("Set Timer Beban2");
	__POINTW1MN _0x4D,0
	RCALL SUBOPT_0xF
; 0000 0172    delay_ms(1000);
	RCALL SUBOPT_0x10
; 0000 0173 
; 0000 0174    for(i=0;i<3;i++) {
	RCALL SUBOPT_0x1
_0x4F:
	RCALL SUBOPT_0x11
	BRGE _0x50
; 0000 0175       jOn[i]=0;
	RCALL SUBOPT_0x12
; 0000 0176       dOn[i]=0;
	RCALL SUBOPT_0x13
; 0000 0177       jOff[i]=0;
	RCALL SUBOPT_0x14
; 0000 0178       dOff[i]=0;
	RCALL SUBOPT_0x15
; 0000 0179    }
	RCALL SUBOPT_0x3
	RJMP _0x4F
_0x50:
; 0000 017A 
; 0000 017B    lcd_clear();
	RCALL SUBOPT_0x16
; 0000 017C    lcd_gotoxy(0,0);
; 0000 017D    lcd_puts("Set Timer On    ");
	__POINTW1MN _0x4D,17
	RCALL SUBOPT_0xF
; 0000 017E    scanKeypad('#',1,0,1);
	RCALL SUBOPT_0x17
; 0000 017F    jOn[0]=dataKeypad[0];
	RCALL SUBOPT_0x18
; 0000 0180    jOn[1]=dataKeypad[1];
; 0000 0181    dOn[0]=dataKeypad[3];
; 0000 0182    dOn[1]=dataKeypad[4];
; 0000 0183    sscanf(jOn,"%d",&jamTimerOn[1]);
	__POINTW1MN _jamTimerOn,1
	RCALL SUBOPT_0x19
; 0000 0184    sscanf(dOn,"%d",&menitTimerOn[1]);
	RCALL SUBOPT_0x1A
	__POINTW1MN _menitTimerOn,1
	RCALL SUBOPT_0x19
; 0000 0185 
; 0000 0186    // SIMPAN KE EEPROM
; 0000 0187    _jamTimerOn[1] = jamTimerOn[1];
	RCALL SUBOPT_0x22
	__GETB1MN _jamTimerOn,1
	RCALL __EEPROMWRB
; 0000 0188    _menitTimerOn[1] = menitTimerOn[1];
	RCALL SUBOPT_0x23
	__GETB1MN _menitTimerOn,1
	RCALL SUBOPT_0x1D
; 0000 0189 
; 0000 018A    lcd_clear();
; 0000 018B    lcd_gotoxy(0,0);
; 0000 018C    lcd_puts("Set Timer Off   ");
	__POINTW1MN _0x4D,34
	RCALL SUBOPT_0xF
; 0000 018D    scanKeypad('#',1,0,1);
	RCALL SUBOPT_0x17
; 0000 018E 
; 0000 018F    jOff[0]=dataKeypad[0];
	RCALL SUBOPT_0x1E
; 0000 0190    jOff[1]=dataKeypad[1];
; 0000 0191    dOff[0]=dataKeypad[3];
; 0000 0192    dOff[1]=dataKeypad[4];
; 0000 0193 
; 0000 0194    sscanf(jOff,"%d",&jamTimerOff[1]);
	__POINTW1MN _jamTimerOff,1
	RCALL SUBOPT_0x19
; 0000 0195    sscanf(dOff,"%d",&menitTimerOff[1]);
	RCALL SUBOPT_0x1F
	__POINTW1MN _menitTimerOff,1
	RCALL SUBOPT_0x19
; 0000 0196 
; 0000 0197    // SIMPAN KE EEPROM
; 0000 0198    _jamTimerOff[1] = jamTimerOff[1];
	RCALL SUBOPT_0x24
	__GETB1MN _jamTimerOff,1
	RCALL __EEPROMWRB
; 0000 0199    _menitTimerOff[1] = menitTimerOff[1];
	RCALL SUBOPT_0x25
	__GETB1MN _menitTimerOff,1
	RCALL SUBOPT_0x1D
; 0000 019A 
; 0000 019B    lcd_clear();
; 0000 019C    lcd_gotoxy(0,0);
; 0000 019D    lcd_puts("Setting Finish  ");
	__POINTW1MN _0x4D,51
	RJMP _0x20C0008
; 0000 019E    delay_ms(1000);
; 0000 019F }

	.DSEG
_0x4D:
	.BYTE 0x44
;
;void menuSetting3() {
; 0000 01A1 void menuSetting3() {

	.CSEG
_menuSetting3:
	PUSH R15
; 0000 01A2    char jOn[3], dOn[3], jOff[3], dOff[3];
; 0000 01A3    bit inputSalah = 0;
; 0000 01A4    int i;
; 0000 01A5    lcd_clear();
	RCALL SUBOPT_0xE
;	jOn -> Y+11
;	dOn -> Y+8
;	jOff -> Y+5
;	dOff -> Y+2
;	inputSalah -> R15.0
;	i -> R16,R17
; 0000 01A6    lcd_gotoxy(0,0);
; 0000 01A7    lcd_puts("Set Timer Beban3");
	__POINTW1MN _0x51,0
	RCALL SUBOPT_0xF
; 0000 01A8    delay_ms(1000);
	RCALL SUBOPT_0x10
; 0000 01A9 
; 0000 01AA    for(i=0;i<3;i++) {
	RCALL SUBOPT_0x1
_0x53:
	RCALL SUBOPT_0x11
	BRGE _0x54
; 0000 01AB       jOn[i]=0;
	RCALL SUBOPT_0x12
; 0000 01AC       dOn[i]=0;
	RCALL SUBOPT_0x13
; 0000 01AD       jOff[i]=0;
	RCALL SUBOPT_0x14
; 0000 01AE       dOff[i]=0;
	RCALL SUBOPT_0x15
; 0000 01AF    }
	RCALL SUBOPT_0x3
	RJMP _0x53
_0x54:
; 0000 01B0 
; 0000 01B1    lcd_clear();
	RCALL SUBOPT_0x16
; 0000 01B2    lcd_gotoxy(0,0);
; 0000 01B3    lcd_puts("Set Timer On    ");
	__POINTW1MN _0x51,17
	RCALL SUBOPT_0xF
; 0000 01B4    scanKeypad('#',1,0,1);
	RCALL SUBOPT_0x17
; 0000 01B5    jOn[0]=dataKeypad[0];
	RCALL SUBOPT_0x18
; 0000 01B6    jOn[1]=dataKeypad[1];
; 0000 01B7    dOn[0]=dataKeypad[3];
; 0000 01B8    dOn[1]=dataKeypad[4];
; 0000 01B9    sscanf(jOn,"%d",&jamTimerOn[2]);
	__POINTW1MN _jamTimerOn,2
	RCALL SUBOPT_0x19
; 0000 01BA    sscanf(dOn,"%d",&menitTimerOn[2]);
	RCALL SUBOPT_0x1A
	__POINTW1MN _menitTimerOn,2
	RCALL SUBOPT_0x19
; 0000 01BB 
; 0000 01BC    // SIMPAN KE EEPROM
; 0000 01BD    _jamTimerOn[2] = jamTimerOn[2];
	RCALL SUBOPT_0x26
	__GETB1MN _jamTimerOn,2
	RCALL __EEPROMWRB
; 0000 01BE    _menitTimerOn[2] = menitTimerOn[2];
	RCALL SUBOPT_0x27
	__GETB1MN _menitTimerOn,2
	RCALL SUBOPT_0x1D
; 0000 01BF    lcd_clear();
; 0000 01C0    lcd_gotoxy(0,0);
; 0000 01C1    lcd_puts("Set Timer Off   ");
	__POINTW1MN _0x51,34
	RCALL SUBOPT_0xF
; 0000 01C2    scanKeypad('#',1,0,1);
	RCALL SUBOPT_0x17
; 0000 01C3 
; 0000 01C4    jOff[0]=dataKeypad[0];
	RCALL SUBOPT_0x1E
; 0000 01C5    jOff[1]=dataKeypad[1];
; 0000 01C6    dOff[0]=dataKeypad[3];
; 0000 01C7    dOff[1]=dataKeypad[4];
; 0000 01C8 
; 0000 01C9    sscanf(jOff,"%d",&jamTimerOff[2]);
	__POINTW1MN _jamTimerOff,2
	RCALL SUBOPT_0x19
; 0000 01CA    sscanf(dOff,"%d",&menitTimerOff[2]);
	RCALL SUBOPT_0x1F
	__POINTW1MN _menitTimerOff,2
	RCALL SUBOPT_0x19
; 0000 01CB 
; 0000 01CC    // SIMPAN KE EEPROM
; 0000 01CD    _jamTimerOff[2] = jamTimerOff[2];
	RCALL SUBOPT_0x28
	__GETB1MN _jamTimerOff,2
	RCALL __EEPROMWRB
; 0000 01CE    _menitTimerOff[2] = menitTimerOff[2];
	RCALL SUBOPT_0x29
	__GETB1MN _menitTimerOff,2
	RCALL SUBOPT_0x1D
; 0000 01CF 
; 0000 01D0    lcd_clear();
; 0000 01D1    lcd_gotoxy(0,0);
; 0000 01D2    lcd_puts("Setting Finish  ");
	__POINTW1MN _0x51,51
	RJMP _0x20C0008
; 0000 01D3    delay_ms(1000);
; 0000 01D4 }

	.DSEG
_0x51:
	.BYTE 0x44
;
;void menuSetting4() {
; 0000 01D6 void menuSetting4() {

	.CSEG
_menuSetting4:
	PUSH R15
; 0000 01D7    char jOn[3], dOn[3], jOff[3], dOff[3];
; 0000 01D8    bit inputSalah = 0;
; 0000 01D9    int i;
; 0000 01DA    lcd_clear();
	RCALL SUBOPT_0xE
;	jOn -> Y+11
;	dOn -> Y+8
;	jOff -> Y+5
;	dOff -> Y+2
;	inputSalah -> R15.0
;	i -> R16,R17
; 0000 01DB    lcd_gotoxy(0,0);
; 0000 01DC    lcd_puts("Set Timer Beban4");
	__POINTW1MN _0x55,0
	RCALL SUBOPT_0xF
; 0000 01DD    delay_ms(1000);
	RCALL SUBOPT_0x10
; 0000 01DE 
; 0000 01DF    for(i=0;i<3;i++) {
	RCALL SUBOPT_0x1
_0x57:
	RCALL SUBOPT_0x11
	BRGE _0x58
; 0000 01E0       jOn[i]=0;
	RCALL SUBOPT_0x12
; 0000 01E1       dOn[i]=0;
	RCALL SUBOPT_0x13
; 0000 01E2       jOff[i]=0;
	RCALL SUBOPT_0x14
; 0000 01E3       dOff[i]=0;
	RCALL SUBOPT_0x15
; 0000 01E4    }
	RCALL SUBOPT_0x3
	RJMP _0x57
_0x58:
; 0000 01E5 
; 0000 01E6    lcd_clear();
	RCALL SUBOPT_0x16
; 0000 01E7    lcd_gotoxy(0,0);
; 0000 01E8    lcd_puts("Set Timer On    ");
	__POINTW1MN _0x55,17
	RCALL SUBOPT_0xF
; 0000 01E9    scanKeypad('#',1,0,1);
	RCALL SUBOPT_0x17
; 0000 01EA    jOn[0]=dataKeypad[0];
	RCALL SUBOPT_0x18
; 0000 01EB    jOn[1]=dataKeypad[1];
; 0000 01EC    dOn[0]=dataKeypad[3];
; 0000 01ED    dOn[1]=dataKeypad[4];
; 0000 01EE    sscanf(jOn,"%d",&jamTimerOn[3]);
	__POINTW1MN _jamTimerOn,3
	RCALL SUBOPT_0x19
; 0000 01EF    sscanf(dOn,"%d",&menitTimerOn[3]);
	RCALL SUBOPT_0x1A
	__POINTW1MN _menitTimerOn,3
	RCALL SUBOPT_0x19
; 0000 01F0 
; 0000 01F1    // SIMPAN KE EEPROM
; 0000 01F2    _jamTimerOn[3] = jamTimerOn[3];
	RCALL SUBOPT_0x2A
	__GETB1MN _jamTimerOn,3
	RCALL __EEPROMWRB
; 0000 01F3    _menitTimerOn[3] = menitTimerOn[3];
	RCALL SUBOPT_0x2B
	__GETB1MN _menitTimerOn,3
	RCALL SUBOPT_0x1D
; 0000 01F4 
; 0000 01F5    lcd_clear();
; 0000 01F6    lcd_gotoxy(0,0);
; 0000 01F7    lcd_puts("Set Timer Off   ");
	__POINTW1MN _0x55,34
	RCALL SUBOPT_0xF
; 0000 01F8    scanKeypad('#',1,0,1);
	RCALL SUBOPT_0x17
; 0000 01F9 
; 0000 01FA    jOff[0]=dataKeypad[0];
	RCALL SUBOPT_0x1E
; 0000 01FB    jOff[1]=dataKeypad[1];
; 0000 01FC    dOff[0]=dataKeypad[3];
; 0000 01FD    dOff[1]=dataKeypad[4];
; 0000 01FE 
; 0000 01FF    sscanf(jOff,"%d",&jamTimerOff[3]);
	__POINTW1MN _jamTimerOff,3
	RCALL SUBOPT_0x19
; 0000 0200    sscanf(dOff,"%d",&menitTimerOff[3]);
	RCALL SUBOPT_0x1F
	__POINTW1MN _menitTimerOff,3
	RCALL SUBOPT_0x19
; 0000 0201 
; 0000 0202    // SIMPAN KE EEPROM
; 0000 0203    _jamTimerOff[3] = jamTimerOff[3];
	RCALL SUBOPT_0x2C
	__GETB1MN _jamTimerOff,3
	RCALL __EEPROMWRB
; 0000 0204    _menitTimerOff[3] = menitTimerOff[3];
	RCALL SUBOPT_0x2D
	__GETB1MN _menitTimerOff,3
	RCALL SUBOPT_0x1D
; 0000 0205 
; 0000 0206    lcd_clear();
; 0000 0207    lcd_gotoxy(0,0);
; 0000 0208    lcd_puts("Setting Finish  ");
	__POINTW1MN _0x55,51
_0x20C0008:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _lcd_puts
; 0000 0209    delay_ms(1000);
	RCALL SUBOPT_0x10
; 0000 020A }
	RCALL __LOADLOCR2
	ADIW R28,14
	POP  R15
	RET

	.DSEG
_0x55:
	.BYTE 0x44
;
;void main(void)
; 0000 020D {

	.CSEG
_main:
; 0000 020E // Declare your local variables here
; 0000 020F 
; 0000 0210 // Input/Output Ports initialization
; 0000 0211 // Port A initialization
; 0000 0212 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0213 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0214 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0215 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0216 
; 0000 0217 // Port B initialization
; 0000 0218 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0219 // State7=T State6=T State5=T State4=T State3=P State2=P State1=P State0=P
; 0000 021A PORTB=0x0F;
	LDI  R30,LOW(15)
	OUT  0x18,R30
; 0000 021B DDRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 021C 
; 0000 021D // Port C initialization
; 0000 021E // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 021F // State7=1 State6=1 State5=1 State4=1 State3=T State2=T State1=T State0=T
; 0000 0220 PORTC=0xF0;
	LDI  R30,LOW(240)
	OUT  0x15,R30
; 0000 0221 DDRC=0xF0;
	OUT  0x14,R30
; 0000 0222 
; 0000 0223 // Port D initialization
; 0000 0224 // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0225 // State7=P State6=P State5=P State4=P State3=0 State2=0 State1=0 State0=0
; 0000 0226 PORTD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 0227 DDRD=0xF0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 0228 
; 0000 0229 // Timer/Counter 0 initialization
; 0000 022A // Clock source: System Clock
; 0000 022B // Clock value: Timer 0 Stopped
; 0000 022C // Mode: Normal top=0xFF
; 0000 022D // OC0 output: Disconnected
; 0000 022E TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 022F TCNT0=0x00;
	OUT  0x32,R30
; 0000 0230 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0231 
; 0000 0232 // Timer/Counter 1 initialization
; 0000 0233 // Clock source: System Clock
; 0000 0234 // Clock value: Timer1 Stopped
; 0000 0235 // Mode: Normal top=0xFFFF
; 0000 0236 // OC1A output: Discon.
; 0000 0237 // OC1B output: Discon.
; 0000 0238 // Noise Canceler: Off
; 0000 0239 // Input Capture on Falling Edge
; 0000 023A // Timer1 Overflow Interrupt: Off
; 0000 023B // Input Capture Interrupt: Off
; 0000 023C // Compare A Match Interrupt: Off
; 0000 023D // Compare B Match Interrupt: Off
; 0000 023E TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 023F TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0240 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0241 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0242 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0243 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0244 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0245 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0246 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0247 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0248 
; 0000 0249 // Timer/Counter 2 initialization
; 0000 024A // Clock source: System Clock
; 0000 024B // Clock value: Timer2 Stopped
; 0000 024C // Mode: Normal top=0xFF
; 0000 024D // OC2 output: Disconnected
; 0000 024E ASSR=0x00;
	OUT  0x22,R30
; 0000 024F TCCR2=0x00;
	OUT  0x25,R30
; 0000 0250 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0251 OCR2=0x00;
	OUT  0x23,R30
; 0000 0252 
; 0000 0253 // External Interrupt(s) initialization
; 0000 0254 // INT0: Off
; 0000 0255 // INT1: Off
; 0000 0256 // INT2: Off
; 0000 0257 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0258 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0259 
; 0000 025A // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 025B TIMSK=0x00;
	OUT  0x39,R30
; 0000 025C 
; 0000 025D // USART initialization
; 0000 025E // USART disabled
; 0000 025F UCSRB=0x00;
	OUT  0xA,R30
; 0000 0260 
; 0000 0261 // Analog Comparator initialization
; 0000 0262 // Analog Comparator: Off
; 0000 0263 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0264 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0265 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0266 
; 0000 0267 // ADC initialization
; 0000 0268 // ADC disabled
; 0000 0269 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 026A 
; 0000 026B // SPI initialization
; 0000 026C // SPI disabled
; 0000 026D SPCR=0x00;
	OUT  0xD,R30
; 0000 026E 
; 0000 026F // TWI initialization
; 0000 0270 // TWI disabled
; 0000 0271 TWCR=0x00;
	OUT  0x36,R30
; 0000 0272 
; 0000 0273 // I2C Bus initialization
; 0000 0274 i2c_init();
	RCALL _i2c_init
; 0000 0275 
; 0000 0276 // DS1307 Real Time Clock initialization
; 0000 0277 // Square wave output on pin SQW/OUT: Off
; 0000 0278 // SQW/OUT pin state: 0
; 0000 0279 rtc_init(0,0,0);
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x2E
	RCALL _rtc_init
; 0000 027A 
; 0000 027B // Alphanumeric LCD initialization
; 0000 027C // Connections specified in the
; 0000 027D // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 027E // RS - PORTA Bit 0
; 0000 027F // RD - PORTA Bit 1
; 0000 0280 // EN - PORTA Bit 2
; 0000 0281 // D4 - PORTA Bit 4
; 0000 0282 // D5 - PORTA Bit 5
; 0000 0283 // D6 - PORTA Bit 6
; 0000 0284 // D7 - PORTA Bit 7
; 0000 0285 // Characters/line: 16
; 0000 0286 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 0287 lcd_clear();
	RCALL SUBOPT_0x16
; 0000 0288 lcd_gotoxy(0,0);
; 0000 0289 
; 0000 028A // UNCOMMENT BARIS INI JIKA INGIN SETTING RTC
; 0000 028B //rtc_set_time(21,27,0);
; 0000 028C //rtc_set_date(3,22,3,13);
; 0000 028D 
; 0000 028E 
; 0000 028F // MATIKAN SEMUA RELAY
; 0000 0290 BEBAN1=0;
	CBI  0x15,4
; 0000 0291 BEBAN2=0;
	CBI  0x15,5
; 0000 0292 BEBAN3=0;
	CBI  0x15,6
; 0000 0293 BEBAN4=0;
	CBI  0x15,7
; 0000 0294 
; 0000 0295 // AMBIL DATA DARI EEPROM
; 0000 0296 jamTimerOn[0] = _jamTimerOn[0];
	RCALL SUBOPT_0x2F
; 0000 0297 menitTimerOn[0] = _menitTimerOn[0];
; 0000 0298 jamTimerOff[0] = _jamTimerOff[0];
; 0000 0299 menitTimerOff[0] = _menitTimerOff[0];
; 0000 029A jamTimerOn[1] = _jamTimerOn[1];
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x30
; 0000 029B menitTimerOn[1] = _menitTimerOn[1];
	RCALL SUBOPT_0x31
; 0000 029C jamTimerOff[1] = _jamTimerOff[1];
	RCALL SUBOPT_0x32
; 0000 029D menitTimerOff[1] = _menitTimerOff[1];
	RCALL SUBOPT_0x33
; 0000 029E jamTimerOn[2] = _jamTimerOn[2];
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x34
; 0000 029F menitTimerOn[2] = _menitTimerOn[2];
	RCALL SUBOPT_0x35
; 0000 02A0 jamTimerOff[2] = _jamTimerOff[2];
	RCALL SUBOPT_0x36
; 0000 02A1 menitTimerOff[2] = _menitTimerOff[2];
	RCALL SUBOPT_0x37
; 0000 02A2 jamTimerOn[3] = _jamTimerOn[3];
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x38
; 0000 02A3 menitTimerOn[3] = _menitTimerOn[3];
	RCALL SUBOPT_0x39
; 0000 02A4 jamTimerOff[3] = _jamTimerOff[3];
	RCALL SUBOPT_0x3A
; 0000 02A5 menitTimerOff[3] = _menitTimerOff[3];
	RCALL SUBOPT_0x3B
; 0000 02A6 
; 0000 02A7 while (1) {
_0x61:
; 0000 02A8    char key = 0;
; 0000 02A9    KEYPAD_OUT=0b11101111;
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
;	key -> Y+0
	LDI  R30,LOW(239)
	RCALL SUBOPT_0x5
; 0000 02AA    delay_ms(30);
; 0000 02AB    if(KEYPAD_IN.0==0) {
	SBIC 0x10,0
	RJMP _0x64
; 0000 02AC       // AMBIL DATA DARI EEPROM
; 0000 02AD       jamTimerOn[3] = _jamTimerOn[3];
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x38
; 0000 02AE       menitTimerOn[3] = _menitTimerOn[3];
	RCALL SUBOPT_0x39
; 0000 02AF       jamTimerOff[3] = _jamTimerOff[3];
	RCALL SUBOPT_0x3A
; 0000 02B0       menitTimerOff[3] = _menitTimerOff[3];
	RCALL SUBOPT_0x3B
; 0000 02B1       sprintf(bufferLcd1,"T4 On  > %2d:%2d ",jamTimerOn[3],menitTimerOn[3]);
	RCALL SUBOPT_0x3C
	__POINTW1FN _0x0,122
	RCALL SUBOPT_0x0
	__GETB1MN _jamTimerOn,3
	RCALL SUBOPT_0x3D
	__GETB1MN _menitTimerOn,3
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3E
; 0000 02B2       sprintf(bufferLcd2,"T4 Off > %2d:%2d ",jamTimerOff[3],menitTimerOff[3]);
	__POINTW1FN _0x0,140
	RCALL SUBOPT_0x0
	__GETB1MN _jamTimerOff,3
	RCALL SUBOPT_0x3D
	__GETB1MN _menitTimerOff,3
	RJMP _0xA0
; 0000 02B3       lcd_clear();
; 0000 02B4       lcd_gotoxy(0,0);
; 0000 02B5       lcd_puts(bufferLcd1);
; 0000 02B6       lcd_gotoxy(0,1);
; 0000 02B7       lcd_puts(bufferLcd2);
; 0000 02B8       delay_ms(2000);
; 0000 02B9    }
; 0000 02BA    else if(KEYPAD_IN.1==0) {
_0x64:
	SBIC 0x10,1
	RJMP _0x66
; 0000 02BB       // AMBIL DATA DARI EEPROM
; 0000 02BC       jamTimerOn[2] = _jamTimerOn[2];
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x34
; 0000 02BD       menitTimerOn[2] = _menitTimerOn[2];
	RCALL SUBOPT_0x35
; 0000 02BE       jamTimerOff[2] = _jamTimerOff[2];
	RCALL SUBOPT_0x36
; 0000 02BF       menitTimerOff[2] = _menitTimerOff[2];
	RCALL SUBOPT_0x37
; 0000 02C0       sprintf(bufferLcd1,"T3 On  > %2d:%2d ",jamTimerOn[2],menitTimerOn[2]);
	RCALL SUBOPT_0x3C
	__POINTW1FN _0x0,158
	RCALL SUBOPT_0x0
	__GETB1MN _jamTimerOn,2
	RCALL SUBOPT_0x3D
	__GETB1MN _menitTimerOn,2
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3E
; 0000 02C1       sprintf(bufferLcd2,"T3 Off > %2d:%2d ",jamTimerOff[2],menitTimerOff[2]);
	__POINTW1FN _0x0,176
	RCALL SUBOPT_0x0
	__GETB1MN _jamTimerOff,2
	RCALL SUBOPT_0x3D
	__GETB1MN _menitTimerOff,2
	RJMP _0xA0
; 0000 02C2       lcd_clear();
; 0000 02C3       lcd_gotoxy(0,0);
; 0000 02C4       lcd_puts(bufferLcd1);
; 0000 02C5       lcd_gotoxy(0,1);
; 0000 02C6       lcd_puts(bufferLcd2);
; 0000 02C7       delay_ms(2000);
; 0000 02C8    }
; 0000 02C9    else if(KEYPAD_IN.2==0) {
_0x66:
	SBIC 0x10,2
	RJMP _0x68
; 0000 02CA       // AMBIL DATA DARI EEPROM
; 0000 02CB       jamTimerOn[1] = _jamTimerOn[1];
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x30
; 0000 02CC       menitTimerOn[1] = _menitTimerOn[1];
	RCALL SUBOPT_0x31
; 0000 02CD       jamTimerOff[1] = _jamTimerOff[1];
	RCALL SUBOPT_0x32
; 0000 02CE       menitTimerOff[1] = _menitTimerOff[1];
	RCALL SUBOPT_0x33
; 0000 02CF       sprintf(bufferLcd1,"T2 On  > %2d:%2d ",jamTimerOn[1],menitTimerOn[1]);
	RCALL SUBOPT_0x3C
	__POINTW1FN _0x0,194
	RCALL SUBOPT_0x0
	__GETB1MN _jamTimerOn,1
	RCALL SUBOPT_0x3D
	__GETB1MN _menitTimerOn,1
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3E
; 0000 02D0       sprintf(bufferLcd2,"T2 Off > %2d:%2d ",jamTimerOff[1],menitTimerOff[1]);
	__POINTW1FN _0x0,212
	RCALL SUBOPT_0x0
	__GETB1MN _jamTimerOff,1
	RCALL SUBOPT_0x3D
	__GETB1MN _menitTimerOff,1
	RJMP _0xA0
; 0000 02D1       lcd_clear();
; 0000 02D2       lcd_gotoxy(0,0);
; 0000 02D3       lcd_puts(bufferLcd1);
; 0000 02D4       lcd_gotoxy(0,1);
; 0000 02D5       lcd_puts(bufferLcd2);
; 0000 02D6       delay_ms(2000);
; 0000 02D7    }
; 0000 02D8    else if(KEYPAD_IN.3==0) {
_0x68:
	SBIC 0x10,3
	RJMP _0x6A
; 0000 02D9       // AMBIL DATA DARI EEPROM
; 0000 02DA       jamTimerOn[0] = _jamTimerOn[0];
	RCALL SUBOPT_0x2F
; 0000 02DB       menitTimerOn[0] = _menitTimerOn[0];
; 0000 02DC       jamTimerOff[0] = _jamTimerOff[0];
; 0000 02DD       menitTimerOff[0] = _menitTimerOff[0];
; 0000 02DE       sprintf(bufferLcd1,"T1 On  > %2d:%2d ",jamTimerOn[0],menitTimerOn[0]);
	RCALL SUBOPT_0x3C
	__POINTW1FN _0x0,230
	RCALL SUBOPT_0x0
	LDS  R30,_jamTimerOn
	RCALL SUBOPT_0x3D
	LDS  R30,_menitTimerOn
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3E
; 0000 02DF       sprintf(bufferLcd2,"T1 Off > %2d:%2d ",jamTimerOff[0],menitTimerOff[0]);
	__POINTW1FN _0x0,248
	RCALL SUBOPT_0x0
	LDS  R30,_jamTimerOff
	RCALL SUBOPT_0x3D
	LDS  R30,_menitTimerOff
_0xA0:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
; 0000 02E0       lcd_clear();
	RCALL SUBOPT_0x16
; 0000 02E1       lcd_gotoxy(0,0);
; 0000 02E2       lcd_puts(bufferLcd1);
	LDI  R30,LOW(_bufferLcd1)
	LDI  R31,HIGH(_bufferLcd1)
	RCALL SUBOPT_0xF
; 0000 02E3       lcd_gotoxy(0,1);
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x3F
; 0000 02E4       lcd_puts(bufferLcd2);
; 0000 02E5       delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	RCALL SUBOPT_0xD
; 0000 02E6    }
; 0000 02E7    if(!SW_BEBAN1) {
_0x6A:
	SBIC 0x16,0
	RJMP _0x6B
; 0000 02E8       menuSetting1();
	RCALL _menuSetting1
; 0000 02E9    }
; 0000 02EA    else if(!SW_BEBAN2) {
	RJMP _0x6C
_0x6B:
	SBIC 0x16,1
	RJMP _0x6D
; 0000 02EB       menuSetting2();
	RCALL _menuSetting2
; 0000 02EC    }
; 0000 02ED    else if(!SW_BEBAN3) {
	RJMP _0x6E
_0x6D:
	SBIC 0x16,2
	RJMP _0x6F
; 0000 02EE       menuSetting3();
	RCALL _menuSetting3
; 0000 02EF    }
; 0000 02F0    else if(!SW_BEBAN4) {
	RJMP _0x70
_0x6F:
	SBIC 0x16,3
	RJMP _0x71
; 0000 02F1       menuSetting4();
	RCALL _menuSetting4
; 0000 02F2    }
; 0000 02F3    else{
	RJMP _0x72
_0x71:
; 0000 02F4       lcd_clear();
	RCALL _lcd_clear
; 0000 02F5       bacaRTC();
	RCALL _bacaRTC
; 0000 02F6       sprintf(bufferLcd1,"Jam => %2d:%2d:%2d ",jam,menit,detik);
	RCALL SUBOPT_0x3C
	__POINTW1FN _0x0,266
	RCALL SUBOPT_0x0
	MOV  R30,R5
	RCALL SUBOPT_0x3D
	MOV  R30,R4
	RCALL SUBOPT_0x3D
	MOV  R30,R7
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x40
; 0000 02F7       lcd_gotoxy(0,0);
	RCALL SUBOPT_0x2E
	RCALL _lcd_gotoxy
; 0000 02F8       lcd_puts(bufferLcd1);
	LDI  R30,LOW(_bufferLcd1)
	LDI  R31,HIGH(_bufferLcd1)
	RCALL SUBOPT_0xF
; 0000 02F9       sprintf(bufferLcd2,"Tgl => %2d/%2d/%2d ",tanggal,bulan,tahun);
	LDI  R30,LOW(_bufferLcd2)
	LDI  R31,HIGH(_bufferLcd2)
	RCALL SUBOPT_0x0
	__POINTW1FN _0x0,286
	RCALL SUBOPT_0x0
	MOV  R30,R9
	RCALL SUBOPT_0x3D
	MOV  R30,R8
	RCALL SUBOPT_0x3D
	MOV  R30,R11
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x40
; 0000 02FA       lcd_gotoxy(0,1);
	RCALL SUBOPT_0x3F
; 0000 02FB       lcd_puts(bufferLcd2);
; 0000 02FC 
; 0000 02FD       // AMBIL DATA DARI EEPROM
; 0000 02FE       jamTimerOn[0] = _jamTimerOn[0];
	RCALL SUBOPT_0x2F
; 0000 02FF       menitTimerOn[0] = _menitTimerOn[0];
; 0000 0300       jamTimerOff[0] = _jamTimerOff[0];
; 0000 0301       menitTimerOff[0] = _menitTimerOff[0];
; 0000 0302 
; 0000 0303       if(jam==jamTimerOn[0]&&menit==menitTimerOn[0]) {
	LDS  R30,_jamTimerOn
	CP   R30,R5
	BRNE _0x74
	LDS  R30,_menitTimerOn
	CP   R30,R4
	BREQ _0x75
_0x74:
	RJMP _0x73
_0x75:
; 0000 0304          BEBAN1 = 1;
	SBI  0x15,4
; 0000 0305       }
; 0000 0306       else if(jam==jamTimerOff[0]&&menit==menitTimerOff[0]) {
	RJMP _0x78
_0x73:
	LDS  R30,_jamTimerOff
	CP   R30,R5
	BRNE _0x7A
	LDS  R30,_menitTimerOff
	CP   R30,R4
	BREQ _0x7B
_0x7A:
	RJMP _0x79
_0x7B:
; 0000 0307          BEBAN1 = 0;
	CBI  0x15,4
; 0000 0308       }
; 0000 0309 
; 0000 030A       // AMBIL DATA DARI EEPROM
; 0000 030B       jamTimerOn[1] = _jamTimerOn[1];
_0x79:
_0x78:
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x30
; 0000 030C       menitTimerOn[1] = _menitTimerOn[1];
	RCALL SUBOPT_0x31
; 0000 030D       jamTimerOff[1] = _jamTimerOff[1];
	RCALL SUBOPT_0x32
; 0000 030E       menitTimerOff[1] = _menitTimerOff[1];
	RCALL SUBOPT_0x33
; 0000 030F 
; 0000 0310       if(jam==jamTimerOn[1]&&menit==menitTimerOn[1]) {
	__GETB1MN _jamTimerOn,1
	CP   R30,R5
	BRNE _0x7F
	__GETB1MN _menitTimerOn,1
	CP   R30,R4
	BREQ _0x80
_0x7F:
	RJMP _0x7E
_0x80:
; 0000 0311          BEBAN2 = 1;
	SBI  0x15,5
; 0000 0312       }
; 0000 0313       else if(jam==jamTimerOff[1]&&menit==menitTimerOff[1]){
	RJMP _0x83
_0x7E:
	__GETB1MN _jamTimerOff,1
	CP   R30,R5
	BRNE _0x85
	__GETB1MN _menitTimerOff,1
	CP   R30,R4
	BREQ _0x86
_0x85:
	RJMP _0x84
_0x86:
; 0000 0314          BEBAN2 = 0;
	CBI  0x15,5
; 0000 0315       }
; 0000 0316 
; 0000 0317       // AMBIL DATA DARI EEPROM
; 0000 0318       jamTimerOn[2] = _jamTimerOn[2];
_0x84:
_0x83:
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x34
; 0000 0319       menitTimerOn[2] = _menitTimerOn[2];
	RCALL SUBOPT_0x35
; 0000 031A       jamTimerOff[2] = _jamTimerOff[2];
	RCALL SUBOPT_0x36
; 0000 031B       menitTimerOff[2] = _menitTimerOff[2];
	RCALL SUBOPT_0x37
; 0000 031C       if(jam==jamTimerOn[2]&&menit==_menitTimerOn[2]) {
	__GETB1MN _jamTimerOn,2
	CP   R30,R5
	BRNE _0x8A
	RCALL SUBOPT_0x27
	RCALL __EEPROMRDB
	CP   R30,R4
	BREQ _0x8B
_0x8A:
	RJMP _0x89
_0x8B:
; 0000 031D          BEBAN3 = 1;
	SBI  0x15,6
; 0000 031E       }
; 0000 031F       else if(jam==jamTimerOff[2]&&menit==_menitTimerOff[2]){
	RJMP _0x8E
_0x89:
	__GETB1MN _jamTimerOff,2
	CP   R30,R5
	BRNE _0x90
	RCALL SUBOPT_0x29
	RCALL __EEPROMRDB
	CP   R30,R4
	BREQ _0x91
_0x90:
	RJMP _0x8F
_0x91:
; 0000 0320          BEBAN3 = 0;
	CBI  0x15,6
; 0000 0321       }
; 0000 0322 
; 0000 0323       // AMBIL DATA DARI EEPROM
; 0000 0324       jamTimerOn[3] = _jamTimerOn[3];
_0x8F:
_0x8E:
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x38
; 0000 0325       menitTimerOn[3] = _menitTimerOn[3];
	RCALL SUBOPT_0x39
; 0000 0326       jamTimerOff[3] = _jamTimerOff[3];
	RCALL SUBOPT_0x3A
; 0000 0327       menitTimerOff[3] = _menitTimerOff[3];
	RCALL SUBOPT_0x3B
; 0000 0328 
; 0000 0329       if(jam==jamTimerOn[3]&&menit==menitTimerOn[3]) {
	__GETB1MN _jamTimerOn,3
	CP   R30,R5
	BRNE _0x95
	__GETB1MN _menitTimerOn,3
	CP   R30,R4
	BREQ _0x96
_0x95:
	RJMP _0x94
_0x96:
; 0000 032A          BEBAN4 = 1;
	SBI  0x15,7
; 0000 032B       }
; 0000 032C       else if(jam==jamTimerOff[3]&&menit==menitTimerOff[3]) {
	RJMP _0x99
_0x94:
	__GETB1MN _jamTimerOff,3
	CP   R30,R5
	BRNE _0x9B
	__GETB1MN _menitTimerOff,3
	CP   R30,R4
	BREQ _0x9C
_0x9B:
	RJMP _0x9A
_0x9C:
; 0000 032D          BEBAN4 = 0;
	CBI  0x15,7
; 0000 032E       }
; 0000 032F    }
_0x9A:
_0x99:
_0x72:
_0x70:
_0x6E:
_0x6C:
; 0000 0330    delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0xD
; 0000 0331 }
	ADIW R28,1
	RJMP _0x61
; 0000 0332 }
_0x9F:
	RJMP _0x9F
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x41
	ADIW R26,2
	RCALL SUBOPT_0x42
	BREQ _0x2000010
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x43
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	RCALL SUBOPT_0x41
	ADIW R26,2
	RCALL SUBOPT_0x44
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	RCALL SUBOPT_0x41
	RCALL __GETW1P
	TST  R31
	BRMI _0x2000014
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x44
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x45
	ST   X+,R30
	ST   X,R31
_0x2000015:
	RCALL __LOADLOCR2
	RJMP _0x20C0006
__print_G100:
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x46
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x46
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0x47
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x49
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x4C
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x4C
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	RCALL SUBOPT_0x4D
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	RCALL SUBOPT_0x4D
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x4E
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x4E
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x4E
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0x46
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x4D
	RJMP _0x2000054
_0x2000053:
	RCALL SUBOPT_0x4F
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x46
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x4D
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x4E
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x49
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x46
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x49
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL SUBOPT_0x42
	BRNE _0x2000072
	RCALL SUBOPT_0x45
	RJMP _0x20C0007
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,12
	RCALL SUBOPT_0x50
	RCALL SUBOPT_0x4D
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL SUBOPT_0x50
	RCALL SUBOPT_0x0
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	RCALL SUBOPT_0x0
	MOVW R30,R28
	ADIW R30,10
	RCALL SUBOPT_0x0
	RCALL __print_G100
	MOVW R18,R30
	RCALL SUBOPT_0x4F
	RCALL SUBOPT_0x51
	MOVW R30,R18
_0x20C0007:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
_get_buff_G100:
	ST   -Y,R17
	RCALL SUBOPT_0x52
	RCALL SUBOPT_0x51
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200007A
	RCALL SUBOPT_0x51
	RJMP _0x200007B
_0x200007A:
	RCALL SUBOPT_0x52
	ADIW R26,1
	RCALL SUBOPT_0x42
	BREQ _0x200007C
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R26,Z+1
	LDD  R27,Z+2
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200007D
	RCALL SUBOPT_0x52
	ADIW R26,1
	RCALL SUBOPT_0x44
_0x200007D:
	RJMP _0x200007E
_0x200007C:
	LDI  R17,LOW(0)
_0x200007E:
_0x200007B:
	MOV  R30,R17
	LDD  R17,Y+0
_0x20C0006:
	ADIW R28,5
	RET
__scanf_G100:
	SBIW R28,5
	RCALL __SAVELOCR6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STD  Y+8,R30
	STD  Y+8+1,R31
	MOV  R20,R30
_0x200007F:
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ADIW R30,1
	STD  Y+17,R30
	STD  Y+17+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000081
	RCALL SUBOPT_0x53
	BREQ _0x2000082
_0x2000083:
	IN   R30,SPL
	IN   R31,SPH
	RCALL SUBOPT_0x0
	PUSH R20
	RCALL SUBOPT_0x49
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2000086
	RCALL SUBOPT_0x53
	BRNE _0x2000087
_0x2000086:
	RJMP _0x2000085
_0x2000087:
	RCALL SUBOPT_0x54
	BRGE _0x2000088
	RCALL SUBOPT_0x45
	RJMP _0x20C0004
_0x2000088:
	RJMP _0x2000083
_0x2000085:
	MOV  R20,R19
	RJMP _0x2000089
_0x2000082:
	CPI  R19,37
	BREQ PC+2
	RJMP _0x200008A
	LDI  R21,LOW(0)
_0x200008B:
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LPM  R19,Z+
	STD  Y+17,R30
	STD  Y+17+1,R31
	CPI  R19,48
	BRLO _0x200008F
	CPI  R19,58
	BRLO _0x200008E
_0x200008F:
	RJMP _0x200008D
_0x200008E:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200008B
_0x200008D:
	CPI  R19,0
	BRNE _0x2000091
	RJMP _0x2000081
_0x2000091:
_0x2000092:
	IN   R30,SPL
	IN   R31,SPH
	RCALL SUBOPT_0x0
	PUSH R20
	RCALL SUBOPT_0x49
	POP  R20
	MOV  R18,R30
	ST   -Y,R30
	RCALL _isspace
	CPI  R30,0
	BREQ _0x2000094
	RCALL SUBOPT_0x54
	BRGE _0x2000095
	RCALL SUBOPT_0x45
	RJMP _0x20C0004
_0x2000095:
	RJMP _0x2000092
_0x2000094:
	CPI  R18,0
	BRNE _0x2000096
	RJMP _0x2000097
_0x2000096:
	MOV  R20,R18
	CPI  R21,0
	BRNE _0x2000098
	LDI  R21,LOW(255)
_0x2000098:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x200009C
	RCALL SUBOPT_0x55
	IN   R30,SPL
	IN   R31,SPH
	RCALL SUBOPT_0x0
	PUSH R20
	RCALL SUBOPT_0x49
	POP  R20
	MOVW R26,R16
	ST   X,R30
	RCALL SUBOPT_0x54
	BRGE _0x200009D
	RCALL SUBOPT_0x45
	RJMP _0x20C0004
_0x200009D:
	RJMP _0x200009B
_0x200009C:
	CPI  R30,LOW(0x73)
	BRNE _0x20000A6
	RCALL SUBOPT_0x55
_0x200009F:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BREQ _0x20000A1
	IN   R30,SPL
	IN   R31,SPH
	RCALL SUBOPT_0x0
	PUSH R20
	RCALL SUBOPT_0x49
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x20000A3
	RCALL SUBOPT_0x53
	BREQ _0x20000A2
_0x20000A3:
	RCALL SUBOPT_0x54
	BRGE _0x20000A5
	RCALL SUBOPT_0x45
	RJMP _0x20C0004
_0x20000A5:
	RJMP _0x20000A1
_0x20000A2:
	PUSH R17
	PUSH R16
	RCALL SUBOPT_0x3
	MOV  R30,R19
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x200009F
_0x20000A1:
	MOVW R26,R16
	RCALL SUBOPT_0x51
	RJMP _0x200009B
_0x20000A6:
	LDI  R30,LOW(1)
	STD  Y+10,R30
	MOV  R30,R19
	CPI  R30,LOW(0x64)
	BREQ _0x20000AB
	CPI  R30,LOW(0x69)
	BRNE _0x20000AC
_0x20000AB:
	LDI  R30,LOW(0)
	STD  Y+10,R30
	RJMP _0x20000AD
_0x20000AC:
	CPI  R30,LOW(0x75)
	BRNE _0x20000AE
_0x20000AD:
	LDI  R18,LOW(10)
	RJMP _0x20000A9
_0x20000AE:
	CPI  R30,LOW(0x78)
	BRNE _0x20000AF
	LDI  R18,LOW(16)
	RJMP _0x20000A9
_0x20000AF:
	CPI  R30,LOW(0x25)
	BRNE _0x20000B2
	RJMP _0x20000B1
_0x20000B2:
	RJMP _0x20C0005
_0x20000A9:
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x20000B3:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BREQ _0x20000B5
	IN   R30,SPL
	IN   R31,SPH
	RCALL SUBOPT_0x0
	PUSH R20
	RCALL SUBOPT_0x49
	POP  R20
	MOV  R19,R30
	CPI  R30,LOW(0x21)
	BRSH _0x20000B6
	RCALL SUBOPT_0x54
	BRGE _0x20000B7
	RCALL SUBOPT_0x45
	RJMP _0x20C0004
_0x20000B7:
	RJMP _0x20000B8
_0x20000B6:
	LDD  R30,Y+10
	CPI  R30,0
	BRNE _0x20000B9
	CPI  R19,45
	BRNE _0x20000BA
	LDI  R30,LOW(255)
	STD  Y+10,R30
	RJMP _0x20000B3
_0x20000BA:
	LDI  R30,LOW(1)
	STD  Y+10,R30
_0x20000B9:
	CPI  R18,16
	BRNE _0x20000BC
	ST   -Y,R19
	RCALL _isxdigit
	CPI  R30,0
	BREQ _0x20000B8
	RJMP _0x20000BE
_0x20000BC:
	ST   -Y,R19
	RCALL _isdigit
	CPI  R30,0
	BRNE _0x20000BF
_0x20000B8:
	MOV  R20,R19
	RJMP _0x20000B5
_0x20000BF:
_0x20000BE:
	CPI  R19,97
	BRLO _0x20000C0
	SUBI R19,LOW(87)
	RJMP _0x20000C1
_0x20000C0:
	CPI  R19,65
	BRLO _0x20000C2
	SUBI R19,LOW(55)
	RJMP _0x20000C3
_0x20000C2:
	SUBI R19,LOW(48)
_0x20000C3:
_0x20000C1:
	MOV  R30,R18
	RCALL SUBOPT_0x4F
	RCALL SUBOPT_0x56
	RCALL __MULW12U
	MOVW R26,R30
	MOV  R30,R19
	RCALL SUBOPT_0x56
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0x4D
	RJMP _0x20000B3
_0x20000B5:
	RCALL SUBOPT_0x55
	LDD  R30,Y+10
	RCALL SUBOPT_0x4F
	LDI  R31,0
	SBRC R30,7
	SER  R31
	RCALL __MULW12U
	MOVW R26,R16
	ST   X+,R30
	ST   X,R31
_0x200009B:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RJMP _0x20000C4
_0x200008A:
_0x20000B1:
	IN   R30,SPL
	IN   R31,SPH
	RCALL SUBOPT_0x0
	PUSH R20
	RCALL SUBOPT_0x49
	POP  R20
	CP   R30,R19
	BREQ _0x20000C5
	RCALL SUBOPT_0x54
	BRGE _0x20000C6
	RCALL SUBOPT_0x45
	RJMP _0x20C0004
_0x20000C6:
_0x2000097:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BRNE _0x20000C7
	RCALL SUBOPT_0x45
	RJMP _0x20C0004
_0x20000C7:
	RJMP _0x2000081
_0x20000C5:
_0x20000C4:
_0x2000089:
	RJMP _0x200007F
_0x2000081:
_0x20C0005:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
_0x20C0004:
	RCALL __LOADLOCR6
	ADIW R28,19
	RET
_sscanf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,3
	RCALL __SAVELOCR2
	MOVW R26,R28
	ADIW R26,7
	RCALL __ADDW2R15
	RCALL SUBOPT_0x42
	BRNE _0x20000C8
	RCALL SUBOPT_0x45
	RJMP _0x20C0003
_0x20000C8:
	MOVW R26,R28
	ADIW R26,1
	RCALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,7
	RCALL SUBOPT_0x50
	STD  Y+3,R30
	STD  Y+3+1,R31
	MOVW R26,R28
	ADIW R26,5
	RCALL SUBOPT_0x50
	RCALL SUBOPT_0x0
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_get_buff_G100)
	LDI  R31,HIGH(_get_buff_G100)
	RCALL SUBOPT_0x0
	MOVW R30,R28
	ADIW R30,8
	RCALL SUBOPT_0x0
	RCALL __scanf_G100
_0x20C0003:
	RCALL __LOADLOCR2
	ADIW R28,5
	POP  R15
	RET

	.CSEG
_rtc_init:
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2020003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2020003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2020004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2020004:
	RCALL SUBOPT_0x57
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x58
	RCALL SUBOPT_0x4
	RCALL _i2c_write
	RCALL _i2c_stop
	RJMP _0x20C0002
_rtc_get_time:
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x2E
	RCALL _i2c_write
	RCALL SUBOPT_0x59
	RCALL SUBOPT_0x5A
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x41
	ST   X,R30
	RCALL SUBOPT_0x2E
	RCALL _i2c_read
	ST   -Y,R30
	RCALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	RCALL _i2c_stop
	ADIW R28,6
	RET
_rtc_get_date:
	RCALL SUBOPT_0x57
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x58
	RCALL SUBOPT_0x59
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _i2c_read
	RCALL SUBOPT_0x4F
	ST   X,R30
	RCALL SUBOPT_0x5A
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x41
	ST   X,R30
	RCALL SUBOPT_0x2E
	RCALL _i2c_read
	ST   -Y,R30
	RCALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RCALL _i2c_stop
	ADIW R28,8
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G102:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2040004
	SBI  0x1B,4
	RJMP _0x2040005
_0x2040004:
	CBI  0x1B,4
_0x2040005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2040006
	SBI  0x1B,5
	RJMP _0x2040007
_0x2040006:
	CBI  0x1B,5
_0x2040007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2040008
	SBI  0x1B,6
	RJMP _0x2040009
_0x2040008:
	CBI  0x1B,6
_0x2040009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x204000A
	SBI  0x1B,7
	RJMP _0x204000B
_0x204000A:
	CBI  0x1B,7
_0x204000B:
	__DELAY_USB 11
	SBI  0x1B,2
	__DELAY_USB 27
	CBI  0x1B,2
	__DELAY_USB 27
	RJMP _0x20C0001
__lcd_write_data:
	LD   R30,Y
	RCALL SUBOPT_0x5B
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	RCALL SUBOPT_0x5B
	__DELAY_USW 200
	RJMP _0x20C0001
_lcd_gotoxy:
	LD   R30,Y
	RCALL SUBOPT_0x56
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	RCALL SUBOPT_0x5C
	LDD  R10,Y+1
	LDD  R13,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x5C
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0xD
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x5C
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x5C
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0xD
	LDI  R30,LOW(0)
	MOV  R13,R30
	MOV  R10,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040011
	CP   R10,R12
	BRLO _0x2040010
_0x2040011:
	RCALL SUBOPT_0x2E
	INC  R13
	ST   -Y,R13
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x20C0001
_0x2040010:
	INC  R10
	SBI  0x1B,0
	LD   R30,Y
	RCALL SUBOPT_0x5C
	CBI  0x1B,0
	RJMP _0x20C0001
_lcd_puts:
	ST   -Y,R17
_0x2040014:
	RCALL SUBOPT_0x52
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2040014
_0x2040016:
	LDD  R17,Y+0
_0x20C0002:
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x1A,4
	SBI  0x1A,5
	SBI  0x1A,6
	SBI  0x1A,7
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R12,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0xD
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x5B
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x5E
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x5B
	RCALL SUBOPT_0x5E
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x5C
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x5C
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x5C
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x5C
	RCALL _lcd_clear
_0x20C0001:
	ADIW R28,1
	RET

	.CSEG
_isdigit:
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
_isspace:
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
_isxdigit:
    ldi  r30,1
    ld   r31,y+
    subi r31,0x30
    brcs isxdigit0
    cpi  r31,10
    brcs isxdigit1
    andi r31,0x5f
    subi r31,7
    cpi  r31,10
    brcs isxdigit0
    cpi  r31,16
    brcs isxdigit1
isxdigit0:
    clr  r30
isxdigit1:
    ret

	.CSEG
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG
_bcd2bin:
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret

	.DSEG
_jamTimerOn:
	.BYTE 0x4
_menitTimerOn:
	.BYTE 0x4
_jamTimerOff:
	.BYTE 0x4
_menitTimerOff:
	.BYTE 0x4

	.ESEG
__jamTimerOn:
	.BYTE 0x4
__menitTimerOn:
	.BYTE 0x4
__jamTimerOff:
	.BYTE 0x4
__menitTimerOff:
	.BYTE 0x4

	.DSEG
_dataKeypad:
	.BYTE 0x10
_bufferLcd1:
	.BYTE 0x10
_bufferLcd2:
	.BYTE 0x10
__base_y_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 142 TIMES, CODE SIZE REDUCTION:139 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x2:
	ADD  R26,R16
	ADC  R27,R17
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	__ADDWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x4:
	LDD  R30,Y+2
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x5:
	OUT  0x12,R30
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RCALL SUBOPT_0x0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	SET
	BLD  R15,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:153 WORDS
SUBOPT_0x7:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_dataKeypad)
	SBCI R31,HIGH(-_dataKeypad)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x8:
	STD  Z+0,R26
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x9:
	LDD  R30,Y+2
	ADD  R30,R17
	ST   -Y,R30
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA:
	RCALL _lcd_gotoxy
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0xB:
	LD   R30,Z
	ST   -Y,R30
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xD:
	RCALL SUBOPT_0x0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xE:
	SBIW R28,12
	RCALL __SAVELOCR2
	CLR  R15
	RCALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xF:
	RCALL SUBOPT_0x0
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	__CPWRN 16,17,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	MOVW R26,R28
	ADIW R26,11
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	MOVW R26,R28
	ADIW R26,8
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	MOVW R26,R28
	ADIW R26,5
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	MOVW R26,R28
	ADIW R26,2
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x16:
	RCALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x0
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _scanKeypad
	LDS  R30,_dataKeypad
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x18:
	STD  Y+11,R30
	__GETB1MN _dataKeypad,1
	STD  Y+12,R30
	__GETB1MN _dataKeypad,3
	STD  Y+8,R30
	__GETB1MN _dataKeypad,4
	STD  Y+9,R30
	MOVW R30,R28
	ADIW R30,11
	RCALL SUBOPT_0x0
	__POINTW1FN _0x0,34
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:73 WORDS
SUBOPT_0x19:
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sscanf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1A:
	MOVW R30,R28
	ADIW R30,8
	RCALL SUBOPT_0x0
	__POINTW1FN _0x0,34
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(__jamTimerOn)
	LDI  R27,HIGH(__jamTimerOn)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(__menitTimerOn)
	LDI  R27,HIGH(__menitTimerOn)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	RCALL __EEPROMWRB
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x1E:
	STD  Y+5,R30
	__GETB1MN _dataKeypad,1
	STD  Y+6,R30
	__GETB1MN _dataKeypad,3
	STD  Y+2,R30
	__GETB1MN _dataKeypad,4
	STD  Y+3,R30
	MOVW R30,R28
	ADIW R30,5
	RCALL SUBOPT_0x0
	__POINTW1FN _0x0,34
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1F:
	MOVW R30,R28
	ADIW R30,2
	RCALL SUBOPT_0x0
	__POINTW1FN _0x0,34
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(__jamTimerOff)
	LDI  R27,HIGH(__jamTimerOff)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(__menitTimerOff)
	LDI  R27,HIGH(__menitTimerOff)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	__POINTW2MN __jamTimerOn,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	__POINTW2MN __menitTimerOn,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	__POINTW2MN __jamTimerOff,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	__POINTW2MN __menitTimerOff,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	__POINTW2MN __jamTimerOn,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	__POINTW2MN __menitTimerOn,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	__POINTW2MN __jamTimerOff,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	__POINTW2MN __menitTimerOff,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	__POINTW2MN __jamTimerOn,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	__POINTW2MN __menitTimerOn,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	__POINTW2MN __jamTimerOff,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	__POINTW2MN __menitTimerOff,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x2F:
	RCALL SUBOPT_0x1B
	RCALL __EEPROMRDB
	STS  _jamTimerOn,R30
	RCALL SUBOPT_0x1C
	RCALL __EEPROMRDB
	STS  _menitTimerOn,R30
	RCALL SUBOPT_0x20
	RCALL __EEPROMRDB
	STS  _jamTimerOff,R30
	RCALL SUBOPT_0x21
	RCALL __EEPROMRDB
	STS  _menitTimerOff,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x30:
	RCALL __EEPROMRDB
	__PUTB1MN _jamTimerOn,1
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x31:
	RCALL __EEPROMRDB
	__PUTB1MN _menitTimerOn,1
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x32:
	RCALL __EEPROMRDB
	__PUTB1MN _jamTimerOff,1
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x33:
	RCALL __EEPROMRDB
	__PUTB1MN _menitTimerOff,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x34:
	RCALL __EEPROMRDB
	__PUTB1MN _jamTimerOn,2
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x35:
	RCALL __EEPROMRDB
	__PUTB1MN _menitTimerOn,2
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x36:
	RCALL __EEPROMRDB
	__PUTB1MN _jamTimerOff,2
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x37:
	RCALL __EEPROMRDB
	__PUTB1MN _menitTimerOff,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x38:
	RCALL __EEPROMRDB
	__PUTB1MN _jamTimerOn,3
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x39:
	RCALL __EEPROMRDB
	__PUTB1MN _menitTimerOn,3
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3A:
	RCALL __EEPROMRDB
	__PUTB1MN _jamTimerOff,3
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3B:
	RCALL __EEPROMRDB
	__PUTB1MN _menitTimerOff,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3C:
	LDI  R30,LOW(_bufferLcd1)
	LDI  R31,HIGH(_bufferLcd1)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x3D:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3E:
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
	LDI  R30,LOW(_bufferLcd2)
	LDI  R31,HIGH(_bufferLcd2)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3F:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LDI  R30,LOW(_bufferLcd2)
	LDI  R31,HIGH(_bufferLcd2)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	LDI  R24,12
	RCALL _sprintf
	ADIW R28,16
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x41:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	RCALL __GETW1P
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x43:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x44:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x45:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x46:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x0
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x47:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x48:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:38 WORDS
SUBOPT_0x49:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x0
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	RCALL SUBOPT_0x47
	RJMP SUBOPT_0x48

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4B:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4C:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4D:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x50:
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x51:
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x52:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x53:
	ST   -Y,R19
	RCALL _isspace
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x54:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LD   R26,X
	CPI  R26,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x55:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	SBIW R30,4
	STD  Y+15,R30
	STD  Y+15+1,R31
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	ADIW R26,4
	LD   R16,X+
	LD   R17,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x56:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x57:
	RCALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	RJMP _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	ST   -Y,R30
	RJMP _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	RCALL _i2c_stop
	RCALL _i2c_start
	LDI  R30,LOW(209)
	RJMP SUBOPT_0x58

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x5A:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _i2c_read
	ST   -Y,R30
	RJMP _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5B:
	ST   -Y,R30
	RJMP __lcd_write_nibble_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5C:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5D:
	__DELAY_USW 400
	LDI  R30,LOW(48)
	RJMP SUBOPT_0x5B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5E:
	__DELAY_USW 400
	RET


	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2
_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,27
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,53
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	ld   r23,y+
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
