opcodes = {}
DATA.read.scan(/^\|  (\S+)\s+\|   ([A-Z]{3}).+\|    (\S{2})   \|.+\|.+\|$/).each do |codes|
	if opcodes[codes[1]].nil?
		opcodes[codes[1]] = []
	end
	opcodes[codes[1]].push([codes[0], codes[2]])
end
def modeConvert(m)
	case m
	when "Accumulator"
		"acc"
	when "Immediate"
		"imm"
	when "Implied"
		"imp"
	when "Indirect"
		"ind"
	when "Relative"
		"rel"
	when "ZeroPage"
		"zpage"
	when "ZeroPage,X"
		"zpageX"
	when "ZeroPage,Y"
		"zpageY"
	when "Absolute"
		"abs"
	when "Absolute,X"
		"absX"
	when "Absolute,Y"
		"absY"
	when "(Indirect,X)"
		"indX"
	when "(Indirect),Y"
		"indY"
	else
		"PLEASE FIX ME"
	end
end
p opcodes
opcodes.each_pair do |opcode, modes|
	puts "#{opcode}: Opcode.new({"
	modes.each do |mode|
		puts "    #{modeConvert(mode[0])}: 0x#{mode[1]},"
	end
	puts "}),"
end
__END__
ADC               Add memory to accumulator with carry                ADC

Operation:  A + M + C -> A, C                         N Z C I D V
													  / / / _ _ /
							  (Ref: 2.2.1)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Immediate     |   ADC #Oper           |    69   |    2    |    2     |
|  ZeroPage      |   ADC Oper            |    65   |    2    |    3     |
|  ZeroPage,X    |   ADC Oper,X          |    75   |    2    |    4     |
|  Absolute      |   ADC Oper            |    6D   |    3    |    4     |
|  Absolute,X    |   ADC Oper,X          |    7D   |    3    |    4*    |
|  Absolute,Y    |   ADC Oper,Y          |    79   |    3    |    4*    |
|  (Indirect,X)  |   ADC (Oper,X)        |    61   |    2    |    6     |
|  (Indirect),Y  |   ADC (Oper),Y        |    71   |    2    |    5*    |
+----------------+-----------------------+---------+---------+----------+
* Add 1 if page boundary is crossed.


AND                  "AND" memory with accumulator                    AND

Operation:  A /\ M -> A                               N Z C I D V
													  / / _ _ _ _
							 (Ref: 2.2.3.0)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Immediate     |   AND #Oper           |    29   |    2    |    2     |
|  ZeroPage      |   AND Oper            |    25   |    2    |    3     |
|  ZeroPage,X    |   AND Oper,X          |    35   |    2    |    4     |
|  Absolute      |   AND Oper            |    2D   |    3    |    4     |
|  Absolute,X    |   AND Oper,X          |    3D   |    3    |    4*    |
|  Absolute,Y    |   AND Oper,Y          |    39   |    3    |    4*    |
|  (Indirect,X)  |   AND (Oper,X)        |    21   |    2    |    6     |
|  (Indirect),Y  |   AND (Oper),Y        |    31   |    2    |    5     |
+----------------+-----------------------+---------+---------+----------+
* Add 1 if page boundary is crossed.


ASL          ASL Shift Left One Bit (Memory or Accumulator)           ASL
				 +-+-+-+-+-+-+-+-+
Operation:  C <- |7|6|5|4|3|2|1|0| <- 0
				 +-+-+-+-+-+-+-+-+                    N Z C I D V
													  / / / _ _ _
							   (Ref: 10.2)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Accumulator   |   ASL A               |    0A   |    1    |    2     |
|  ZeroPage      |   ASL Oper            |    06   |    2    |    5     |
|  ZeroPage,X    |   ASL Oper,X          |    16   |    2    |    6     |
|  Absolute      |   ASL Oper            |    0E   |    3    |    6     |
|  Absolute, X   |   ASL Oper,X          |    1E   |    3    |    7     |
+----------------+-----------------------+---------+---------+----------+


BCC                     BCC Branch on Carry Clear                     BCC
													  N Z C I D V
Operation:  Branch on C = 0                           _ _ _ _ _ _
							 (Ref: 4.1.1.3)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Relative      |   BCC Oper            |    90   |    2    |    2*    |
+----------------+-----------------------+---------+---------+----------+
* Add 1 if branch occurs to same page.
* Add 2 if branch occurs to different page.


BCS                      BCS Branch on carry set                      BCS

Operation:  Branch on C = 1                           N Z C I D V
													  _ _ _ _ _ _
							 (Ref: 4.1.1.4)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Relative      |   BCS Oper            |    B0   |    2    |    2*    |
+----------------+-----------------------+---------+---------+----------+
* Add 1 if branch occurs to same  page.
* Add 2 if branch occurs to next  page.


BEQ                    BEQ Branch on result zero                      BEQ
													  N Z C I D V
Operation:  Branch on Z = 1                           _ _ _ _ _ _
							 (Ref: 4.1.1.5)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Relative      |   BEQ Oper            |    F0   |    2    |    2*    |
+----------------+-----------------------+---------+---------+----------+
* Add 1 if branch occurs to same  page.
* Add 2 if branch occurs to next  page.


BIT             BIT Test bits in memory with accumulator              BIT

Operation:  A /\ M, M7 -> N, M6 -> V

Bit 6 and 7 are transferred to the status register.   N Z C I D V
If the result of A /\ M is zero then Z = 1, otherwise M7/ _ _ _ M6
Z = 0
							 (Ref: 4.2.1.1)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  ZeroPage      |   BIT Oper            |    24   |    2    |    3     |
|  Absolute      |   BIT Oper            |    2C   |    3    |    4     |
+----------------+-----------------------+---------+---------+----------+


BMI                    BMI Branch on result minus                     BMI

Operation:  Branch on N = 1                           N Z C I D V
													  _ _ _ _ _ _
							 (Ref: 4.1.1.1)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Relative      |   BMI Oper            |    30   |    2    |    2*    |
+----------------+-----------------------+---------+---------+----------+
* Add 1 if branch occurs to same page.
* Add 1 if branch occurs to different page.


BNE                   BNE Branch on result not zero                   BNE

Operation:  Branch on Z = 0                           N Z C I D V
													  _ _ _ _ _ _
							 (Ref: 4.1.1.6)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Relative      |   BMI Oper            |    D0   |    2    |    2*    |
+----------------+-----------------------+---------+---------+----------+
* Add 1 if branch occurs to same page.
* Add 2 if branch occurs to different page.


BPL                     BPL Branch on result plus                     BPL

Operation:  Branch on N = 0                           N Z C I D V
													  _ _ _ _ _ _
							 (Ref: 4.1.1.2)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Relative      |   BPL Oper            |    10   |    2    |    2*    |
+----------------+-----------------------+---------+---------+----------+
* Add 1 if branch occurs to same page.
* Add 2 if branch occurs to different page.


BRK                          BRK Force Break                          BRK

Operation:  Forced Interrupt PC + 2 toS P toS         N Z C I D V
													  _ _ _ 1 _ _
							   (Ref: 9.11)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   BRK                 |    00   |    1    |    7     |
+----------------+-----------------------+---------+---------+----------+
1. A BRK command cannot be masked by setting I.


BVC                   BVC Branch on overflow clear                    BVC

Operation:  Branch on V = 0                           N Z C I D V
													  _ _ _ _ _ _
							 (Ref: 4.1.1.8)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Relative      |   BVC Oper            |    50   |    2    |    2*    |
+----------------+-----------------------+---------+---------+----------+
* Add 1 if branch occurs to same page.
* Add 2 if branch occurs to different page.


BVS                    BVS Branch on overflow set                     BVS

Operation:  Branch on V = 1                           N Z C I D V
													  _ _ _ _ _ _
							 (Ref: 4.1.1.7)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Relative      |   BVS Oper            |    70   |    2    |    2*    |
+----------------+-----------------------+---------+---------+----------+
* Add 1 if branch occurs to same page.
* Add 2 if branch occurs to different page.


CLC                       CLC Clear carry flag                        CLC

Operation:  0 -> C                                    N Z C I D V
													  _ _ 0 _ _ _
							  (Ref: 3.0.2)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   CLC                 |    18   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+


CLD                      CLD Clear decimal mode                       CLD

Operation:  0 -> D                                    N A C I D V
													  _ _ _ _ 0 _
							  (Ref: 3.3.2)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   CLD                 |    D8   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+


CLI                  CLI Clear interrupt disable bit                  CLI

Operation: 0 -> I                                     N Z C I D V
													  _ _ _ 0 _ _
							  (Ref: 3.2.2)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   CLI                 |    58   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+


CLV                      CLV Clear overflow flag                      CLV

Operation: 0 -> V                                     N Z C I D V
													  _ _ _ _ _ 0
							  (Ref: 3.6.1)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   CLV                 |    B8   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+


CMP                CMP Compare memory and accumulator                 CMP

Operation:  A - M                                     N Z C I D V
													  / / / _ _ _
							  (Ref: 4.2.1)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Immediate     |   CMP #Oper           |    C9   |    2    |    2     |
|  ZeroPage      |   CMP Oper            |    C5   |    2    |    3     |
|  ZeroPage,X    |   CMP Oper,X          |    D5   |    2    |    4     |
|  Absolute      |   CMP Oper            |    CD   |    3    |    4     |
|  Absolute,X    |   CMP Oper,X          |    DD   |    3    |    4*    |
|  Absolute,Y    |   CMP Oper,Y          |    D9   |    3    |    4*    |
|  (Indirect,X)  |   CMP (Oper,X)        |    C1   |    2    |    6     |
|  (Indirect),Y  |   CMP (Oper),Y        |    D1   |    2    |    5*    |
+----------------+-----------------------+---------+---------+----------+
* Add 1 if page boundary is crossed.

CPX                  CPX Compare Memory and Index X                   CPX
													  N Z C I D V
Operation:  X - M                                     / / / _ _ _
							   (Ref: 7.8)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Immediate     |   CPX *Oper           |    E0   |    2    |    2     |
|  ZeroPage      |   CPX Oper            |    E4   |    2    |    3     |
|  Absolute      |   CPX Oper            |    EC   |    3    |    4     |
+----------------+-----------------------+---------+---------+----------+

CPY                  CPY Compare memory and index Y                   CPY
													  N Z C I D V
Operation:  Y - M                                     / / / _ _ _
							   (Ref: 7.9)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Immediate     |   CPY *Oper           |    C0   |    2    |    2     |
|  ZeroPage      |   CPY Oper            |    C4   |    2    |    3     |
|  Absolute      |   CPY Oper            |    CC   |    3    |    4     |
+----------------+-----------------------+---------+---------+----------+


DEC                   DEC Decrement memory by one                     DEC

Operation:  M - 1 -> M                                N Z C I D V
													  / / _ _ _ _
							   (Ref: 10.7)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  ZeroPage      |   DEC Oper            |    C6   |    2    |    5     |
|  ZeroPage,X    |   DEC Oper,X          |    D6   |    2    |    6     |
|  Absolute      |   DEC Oper            |    CE   |    3    |    6     |
|  Absolute,X    |   DEC Oper,X          |    DE   |    3    |    7     |
+----------------+-----------------------+---------+---------+----------+


DEX                   DEX Decrement index X by one                    DEX

Operation:  X - 1 -> X                                N Z C I D V
													  / / _ _ _ _
							   (Ref: 7.6)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   DEX                 |    CA   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+


DEY                   DEY Decrement index Y by one                    DEY

Operation:  X - 1 -> Y                                N Z C I D V
													  / / _ _ _ _
							   (Ref: 7.7)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   DEY                 |    88   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+


EOR            EOR "Exclusive-Or" memory with accumulator             EOR

Operation:  A EOR M -> A                              N Z C I D V
													  / / _ _ _ _
							 (Ref: 2.2.3.2)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Immediate     |   EOR #Oper           |    49   |    2    |    2     |
|  ZeroPage      |   EOR Oper            |    45   |    2    |    3     |
|  ZeroPage,X    |   EOR Oper,X          |    55   |    2    |    4     |
|  Absolute      |   EOR Oper            |    4D   |    3    |    4     |
|  Absolute,X    |   EOR Oper,X          |    5D   |    3    |    4*    |
|  Absolute,Y    |   EOR Oper,Y          |    59   |    3    |    4*    |
|  (Indirect,X)  |   EOR (Oper,X)        |    41   |    2    |    6     |
|  (Indirect),Y  |   EOR (Oper),Y        |    51   |    2    |    5*    |
+----------------+-----------------------+---------+---------+----------+
* Add 1 if page boundary is crossed.

INC                    INC Increment memory by one                    INC
													  N Z C I D V
Operation:  M + 1 -> M                                / / _ _ _ _
							   (Ref: 10.6)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  ZeroPage      |   INC Oper            |    E6   |    2    |    5     |
|  ZeroPage,X    |   INC Oper,X          |    F6   |    2    |    6     |
|  Absolute      |   INC Oper            |    EE   |    3    |    6     |
|  Absolute,X    |   INC Oper,X          |    FE   |    3    |    7     |
+----------------+-----------------------+---------+---------+----------+

INX                    INX Increment Index X by one                   INX
													  N Z C I D V
Operation:  X + 1 -> X                                / / _ _ _ _
							   (Ref: 7.4)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   INX                 |    E8   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+


INY                    INY Increment Index Y by one                   INY

Operation:  X + 1 -> X                                N Z C I D V
													  / / _ _ _ _
							   (Ref: 7.5)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   INY                 |    C8   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+


JMP                     JMP Jump to new location                      JMP

Operation:  (PC + 1) -> PCL                           N Z C I D V
			(PC + 2) -> PCH   (Ref: 4.0.2)            _ _ _ _ _ _
							  (Ref: 9.8.1)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Absolute      |   JMP Oper            |    4C   |    3    |    3     |
|  Indirect      |   JMP (Oper)          |    6C   |    3    |    5     |
+----------------+-----------------------+---------+---------+----------+


JSR          JSR Jump to new location saving return address           JSR

Operation:  PC + 2 toS, (PC + 1) -> PCL               N Z C I D V
						(PC + 2) -> PCH               _ _ _ _ _ _
							   (Ref: 8.1)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Absolute      |   JSR Oper            |    20   |    3    |    6     |
+----------------+-----------------------+---------+---------+----------+


LDA                  LDA Load accumulator with memory                 LDA

Operation:  M -> A                                    N Z C I D V
													  / / _ _ _ _
							  (Ref: 2.1.1)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Immediate     |   LDA #Oper           |    A9   |    2    |    2     |
|  ZeroPage      |   LDA Oper            |    A5   |    2    |    3     |
|  ZeroPage,X    |   LDA Oper,X          |    B5   |    2    |    4     |
|  Absolute      |   LDA Oper            |    AD   |    3    |    4     |
|  Absolute,X    |   LDA Oper,X          |    BD   |    3    |    4*    |
|  Absolute,Y    |   LDA Oper,Y          |    B9   |    3    |    4*    |
|  (Indirect,X)  |   LDA (Oper,X)        |    A1   |    2    |    6     |
|  (Indirect),Y  |   LDA (Oper),Y        |    B1   |    2    |    5*    |
+----------------+-----------------------+---------+---------+----------+
* Add 1 if page boundary is crossed.


LDX                   LDX Load index X with memory                    LDX

Operation:  M -> X                                    N Z C I D V
													  / / _ _ _ _
							   (Ref: 7.0)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Immediate     |   LDX #Oper           |    A2   |    2    |    2     |
|  ZeroPage      |   LDX Oper            |    A6   |    2    |    3     |
|  ZeroPage,Y    |   LDX Oper,Y          |    B6   |    2    |    4     |
|  Absolute      |   LDX Oper            |    AE   |    3    |    4     |
|  Absolute,Y    |   LDX Oper,Y          |    BE   |    3    |    4*    |
+----------------+-----------------------+---------+---------+----------+
* Add 1 when page boundary is crossed.


LDY                   LDY Load index Y with memory                    LDY
													  N Z C I D V
Operation:  M -> Y                                    / / _ _ _ _
							   (Ref: 7.1)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Immediate     |   LDY #Oper           |    A0   |    2    |    2     |
|  ZeroPage      |   LDY Oper            |    A4   |    2    |    3     |
|  ZeroPage,X    |   LDY Oper,X          |    B4   |    2    |    4     |
|  Absolute      |   LDY Oper            |    AC   |    3    |    4     |
|  Absolute,X    |   LDY Oper,X          |    BC   |    3    |    4*    |
+----------------+-----------------------+---------+---------+----------+
* Add 1 when page boundary is crossed.


LSR          LSR Shift right one bit (memory or accumulator)          LSR

				 +-+-+-+-+-+-+-+-+
Operation:  0 -> |7|6|5|4|3|2|1|0| -> C               N Z C I D V
				 +-+-+-+-+-+-+-+-+                    0 / / _ _ _
							   (Ref: 10.1)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Accumulator   |   LSR A               |    4A   |    1    |    2     |
|  ZeroPage      |   LSR Oper            |    46   |    2    |    5     |
|  ZeroPage,X    |   LSR Oper,X          |    56   |    2    |    6     |
|  Absolute      |   LSR Oper            |    4E   |    3    |    6     |
|  Absolute,X    |   LSR Oper,X          |    5E   |    3    |    7     |
+----------------+-----------------------+---------+---------+----------+


NOP                         NOP No operation                          NOP
													  N Z C I D V
Operation:  No Operation (2 cycles)                   _ _ _ _ _ _

+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   NOP                 |    EA   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+


ORA                 ORA "OR" memory with accumulator                  ORA

Operation: A V M -> A                                 N Z C I D V
													  / / _ _ _ _
							 (Ref: 2.2.3.1)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Immediate     |   ORA #Oper           |    09   |    2    |    2     |
|  ZeroPage      |   ORA Oper            |    05   |    2    |    3     |
|  ZeroPage,X    |   ORA Oper,X          |    15   |    2    |    4     |
|  Absolute      |   ORA Oper            |    0D   |    3    |    4     |
|  Absolute,X    |   ORA Oper,X          |    1D   |    3    |    4*    |
|  Absolute,Y    |   ORA Oper,Y          |    19   |    3    |    4*    |
|  (Indirect,X)  |   ORA (Oper,X)        |    01   |    2    |    6     |
|  (Indirect),Y  |   ORA (Oper),Y        |    11   |    2    |    5     |
+----------------+-----------------------+---------+---------+----------+
* Add 1 on page crossing


PHA                   PHA Push accumulator on stack                   PHA

Operation:  A toS                                     N Z C I D V
													  _ _ _ _ _ _
							   (Ref: 8.5)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   PHA                 |    48   |    1    |    3     |
+----------------+-----------------------+---------+---------+----------+


PHP                 PHP Push processor status on stack                PHP

Operation:  P toS                                     N Z C I D V
													  _ _ _ _ _ _
							   (Ref: 8.11)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   PHP                 |    08   |    1    |    3     |
+----------------+-----------------------+---------+---------+----------+


PLA                 PLA Pull accumulator from stack                   PLA

Operation:  A fromS                                   N Z C I D V
													  _ _ _ _ _ _
							   (Ref: 8.6)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   PLA                 |    68   |    1    |    4     |
+----------------+-----------------------+---------+---------+----------+


PLP               PLP Pull processor status from stack                PLA

Operation:  P fromS                                   N Z C I D V
													   From Stack
							   (Ref: 8.12)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   PLP                 |    28   |    1    |    4     |
+----------------+-----------------------+---------+---------+----------+


ROL          ROL Rotate one bit left (memory or accumulator)          ROL

			 +------------------------------+
			 |         M or A               |
			 |   +-+-+-+-+-+-+-+-+    +-+   |
Operation:   +-< |7|6|5|4|3|2|1|0| <- |C| <-+         N Z C I D V
				 +-+-+-+-+-+-+-+-+    +-+             / / / _ _ _
							   (Ref: 10.3)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Accumulator   |   ROL A               |    2A   |    1    |    2     |
|  ZeroPage      |   ROL Oper            |    26   |    2    |    5     |
|  ZeroPage,X    |   ROL Oper,X          |    36   |    2    |    6     |
|  Absolute      |   ROL Oper            |    2E   |    3    |    6     |
|  Absolute,X    |   ROL Oper,X          |    3E   |    3    |    7     |
+----------------+-----------------------+---------+---------+----------+


ROR          ROR Rotate one bit right (memory or accumulator)         ROR

			 +------------------------------+
			 |                              |
			 |   +-+    +-+-+-+-+-+-+-+-+   |
Operation:   +-> |C| -> |7|6|5|4|3|2|1|0| >-+         N Z C I D V
				 +-+    +-+-+-+-+-+-+-+-+             / / / _ _ _
							   (Ref: 10.4)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Accumulator   |   ROR A               |    6A   |    1    |    2     |
|  ZeroPage      |   ROR Oper            |    66   |    2    |    5     |
|  ZeroPage,X    |   ROR Oper,X          |    76   |    2    |    6     |
|  Absolute      |   ROR Oper            |    6E   |    3    |    6     |
|  Absolute,X    |   ROR Oper,X          |    7E   |    3    |    7     |
+----------------+-----------------------+---------+---------+----------+

  Note: ROR instruction is available on MCS650X microprocessors after
		June, 1976.


RTI                    RTI Return from interrupt                      RTI
													  N Z C I D V
Operation:  P fromS PC fromS                           From Stack
							   (Ref: 9.6)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   RTI                 |    40   |    1    |    6     |
+----------------+-----------------------+---------+---------+----------+


RTS                    RTS Return from subroutine                     RTS
													  N Z C I D V
Operation:  PC fromS, PC + 1 -> PC                    _ _ _ _ _ _
							   (Ref: 8.2)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   RTS                 |    60   |    1    |    6     |
+----------------+-----------------------+---------+---------+----------+


SBC          SBC Subtract memory from accumulator with borrow         SBC
					-
Operation:  A - M - C -> A                            N Z C I D V
	   -                                              / / / _ _ /
  Note:C = Borrow             (Ref: 2.2.2)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Immediate     |   SBC #Oper           |    E9   |    2    |    2     |
|  ZeroPage      |   SBC Oper            |    E5   |    2    |    3     |
|  ZeroPage,X    |   SBC Oper,X          |    F5   |    2    |    4     |
|  Absolute      |   SBC Oper            |    ED   |    3    |    4     |
|  Absolute,X    |   SBC Oper,X          |    FD   |    3    |    4*    |
|  Absolute,Y    |   SBC Oper,Y          |    F9   |    3    |    4*    |
|  (Indirect,X)  |   SBC (Oper,X)        |    E1   |    2    |    6     |
|  (Indirect),Y  |   SBC (Oper),Y        |    F1   |    2    |    5     |
+----------------+-----------------------+---------+---------+----------+
* Add 1 when page boundary is crossed.


SEC                        SEC Set carry flag                         SEC

Operation:  1 -> C                                    N Z C I D V
													  _ _ 1 _ _ _
							  (Ref: 3.0.1)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   SEC                 |    38   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+


SED                       SED Set decimal mode                        SED
													  N Z C I D V
Operation:  1 -> D                                    _ _ _ _ 1 _
							  (Ref: 3.3.1)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   SED                 |    F8   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+


SEI                 SEI Set interrupt disable status                  SED
													  N Z C I D V
Operation:  1 -> I                                    _ _ _ 1 _ _
							  (Ref: 3.2.1)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   SEI                 |    78   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+


STA                  STA Store accumulator in memory                  STA

Operation:  A -> M                                    N Z C I D V
													  _ _ _ _ _ _
							  (Ref: 2.1.2)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  ZeroPage      |   STA Oper            |    85   |    2    |    3     |
|  ZeroPage,X    |   STA Oper,X          |    95   |    2    |    4     |
|  Absolute      |   STA Oper            |    8D   |    3    |    4     |
|  Absolute,X    |   STA Oper,X          |    9D   |    3    |    5     |
|  Absolute,Y    |   STA Oper, Y         |    99   |    3    |    5     |
|  (Indirect,X)  |   STA (Oper,X)        |    81   |    2    |    6     |
|  (Indirect),Y  |   STA (Oper),Y        |    91   |    2    |    6     |
+----------------+-----------------------+---------+---------+----------+


STX                    STX Store index X in memory                    STX

Operation: X -> M                                     N Z C I D V
													  _ _ _ _ _ _
							   (Ref: 7.2)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  ZeroPage      |   STX Oper            |    86   |    2    |    3     |
|  ZeroPage,Y    |   STX Oper,Y          |    96   |    2    |    4     |
|  Absolute      |   STX Oper            |    8E   |    3    |    4     |
+----------------+-----------------------+---------+---------+----------+


STY                    STY Store index Y in memory                    STY

Operation: Y -> M                                     N Z C I D V
													  _ _ _ _ _ _
							   (Ref: 7.3)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  ZeroPage      |   STY Oper            |    84   |    2    |    3     |
|  ZeroPage,X    |   STY Oper,X          |    94   |    2    |    4     |
|  Absolute      |   STY Oper            |    8C   |    3    |    4     |
+----------------+-----------------------+---------+---------+----------+


TAX                TAX Transfer accumulator to index X                TAX

Operation:  A -> X                                    N Z C I D V
													  / / _ _ _ _
							   (Ref: 7.11)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   TAX                 |    AA   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+


TAY                TAY Transfer accumulator to index Y                TAY

Operation:  A -> Y                                    N Z C I D V
													  / / _ _ _ _
							   (Ref: 7.13)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   TAY                 |    A8   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+


TSX              TSX Transfer stack pointer to index X                TSX

Operation:  S -> X                                    N Z C I D V
													  / / _ _ _ _
							   (Ref: 8.9)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   TSX                 |    BA   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+

TXA                TXA Transfer index X to accumulator                TXA
													  N Z C I D V
Operation:  X -> A                                    / / _ _ _ _
							   (Ref: 7.12)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   TXA                 |    8A   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+

TXS              TXS Transfer index X to stack pointer                TXS
													  N Z C I D V
Operation:  X -> S                                    _ _ _ _ _ _
							   (Ref: 8.8)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   TXS                 |    9A   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+

TYA                TYA Transfer index Y to accumulator                TYA

Operation:  Y -> A                                    N Z C I D V
													  / / _ _ _ _
							   (Ref: 7.14)
+----------------+-----------------------+---------+---------+----------+
| Addressing Mode| Assembly Language Form| OP CODE |No. Bytes|No. Cycles|
+----------------+-----------------------+---------+---------+----------+
|  Implied       |   TYA                 |    98   |    1    |    2     |
+----------------+-----------------------+---------+---------+----------+
