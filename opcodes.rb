#------------------------------------------------
# Objects containing opcodes
# https://wiki.superfamicom.org/snes/files/assembly-programming-manual-for-w65c816.pdf
# Page 34
# Remember, 65C02/65816 is little-endian
# Addressing modes:
#     imp: (implied)
#          (stack addressing is included here, though it is officially seperate)
#     acc: A (accumulator)
#     imm: #NN (immediate)
#     abs: $NNNN (absolute)
#     rel: *+/-NN OR <label> (relative)
#     bitrel: $NN,*+/-NN OR $NN,<label> (zero page,relative. only used in branch on bit (re)set)
#     absX: $NNNN,X (absolute,X)
#     absY: $NNNN,Y (absolute,Y)
#     zpage: $NN (zero page)
#            (stack zero page is included here)
#     zpageX: $NN,X (zero page,X)
#     zpageY: $NN,Y (zero page,Y)
#     zpageind: ($NN) (zero page indirect)
#     ind: ($NNNN) (indirect)
#     indX: ($NN,X) (indirect,X)
#     indY: ($NN),Y (indirect,Y)
# Another useful few links:
# http://www.llx.com/~nparker/a2/opcodes.html
# http://patpend.net/technical/6502/6502ref.html
# TODO: check against http://www.obelisk.me.uk/65C02/reference.html
#------------------------------------------------
class Opcode
	@modes = {}

	def get_modes()
		@modes
	end

	def initialize(modes)
		modes.keys.each do |mode|
			if !%i(imp acc imm abs rel bitrel absX absY zpage zpageX zpageY zpageind ind indX indY)
				puts "Invalid addressing mode #{mode}"
			end
		end
		@modes = modes
	end
end
@_65C02_OPCODES = {
	ADC: Opcode.new({
	    imm: 0x69,
	    zpage: 0x65,
	    zpageX: 0x75,
	    abs: 0x6D,
	    absX: 0x7D,
	    absY: 0x79,
		zpageind: 0x72,
	    indX: 0x61,
	    indY: 0x71
	}),
	AND: Opcode.new({
	    imm: 0x29,
	    zpage: 0x25,
	    zpageX: 0x35,
	    abs: 0x2D,
	    absX: 0x3D,
	    absY: 0x39,
		zpageind: 0x32,
	    indX: 0x21,
	    indY: 0x31
	}),
	ASL: Opcode.new({
	    acc: 0x0A,
	    zpage: 0x06,
	    zpageX: 0x16,
	    abs: 0x0E,
		absX: 0x1E
	}),
	BBR0: Opcode.new({
		bitrel: 0x0F
	}),
	BBR1: Opcode.new({
		bitrel: 0x1F
	}),
	BBR2: Opcode.new({
		bitrel: 0x2F
	}),
	BBR3: Opcode.new({
		bitrel: 0x3F
	}),
	BBR4: Opcode.new({
		bitrel: 0x4F
	}),
	BBR5: Opcode.new({
		bitrel: 0x5F
	}),
	BBR6: Opcode.new({
		bitrel: 0x6F
	}),
	BBR7: Opcode.new({
		bitrel: 0x7F
	}),
	BBS0: Opcode.new({
		bitrel: 0x8F
	}),
	BBS1: Opcode.new({
		bitrel: 0x9F
	}),
	BBS2: Opcode.new({
		bitrel: 0xAF
	}),
	BBS3: Opcode.new({
		bitrel: 0xBF
	}),
	BBS4: Opcode.new({
		bitrel: 0xCF
	}),
	BBS5: Opcode.new({
		bitrel: 0xDF
	}),
	BBS6: Opcode.new({
		bitrel: 0xEF
	}),
	BBS7: Opcode.new({
		bitrel: 0xFF
	}),
	BCC: Opcode.new({
	    rel: 0x90
	}),
	BCS: Opcode.new({
	    rel: 0xB0
	}),
	BEQ: Opcode.new({
	    rel: 0xF0
	}),
	BIT: Opcode.new({
		imm: 0x89,
	    zpage: 0x24,
		zpageX: 0x34,
	    abs: 0x2C,
		absX: 0x3C
	}),
	BMI: Opcode.new({
	    rel: 0x30,
	}),
	BNE: Opcode.new({
		rel: 0xD0,
	}),
	BPL: Opcode.new({
	    rel: 0x10,
	}),
	BRA: Opcode.new({
		rel: 0x80,
	}),
	BRK: Opcode.new({
	    imp: 0x00,
	}),
	BVC: Opcode.new({
	    rel: 0x50,
	}),
	BVS: Opcode.new({
	    rel: 0x70,
	}),
	CLC: Opcode.new({
	    imp: 0x18,
	}),
	CLD: Opcode.new({
	    imp: 0xD8,
	}),
	CLI: Opcode.new({
	    imp: 0x58,
	}),
	CLV: Opcode.new({
	    imp: 0xB8,
	}),
	CMP: Opcode.new({
	    imm: 0xC9,
	    zpage: 0xC5,
	    zpageX: 0xD5,
	    abs: 0xCD,
	    absX: 0xDD,
	    absY: 0xD9,
		zpageind: 0xD2,
	    indX: 0xC1,
	    indY: 0xD1,
	}),
	CPX: Opcode.new({
	    imm: 0xE0,
	    zpage: 0xE4,
	    abs: 0xEC,
	}),
	CPY: Opcode.new({
	    imm: 0xC0,
	    zpage: 0xC4,
	    abs: 0xCC,
	}),
	DEC: Opcode.new({
		acc: 0x3A,
	    zpage: 0xC6,
	    zpageX: 0xD6,
	    abs: 0xCE,
	    absX: 0xDE,
	}),
	DEX: Opcode.new({
	    imp: 0xCA,
	}),
	DEY: Opcode.new({
	    imp: 0x88,
	}),
	EOR: Opcode.new({
	    imm: 0x49,
	    zpage: 0x45,
	    zpageX: 0x55,
	    abs: 0x4D,
	    absX: 0x5D,
	    absY: 0x59,
		zpageind: 0x52,
	    indX: 0x41,
	    indY: 0x51,
	}),
	INC: Opcode.new({
		acc: 0x1A,
	    zpage: 0xE6,
	    zpageX: 0xF6,
	    abs: 0xEE,
	    absX: 0xFE,
	}),
	INX: Opcode.new({
	    imp: 0xE8,
	}),
	INY: Opcode.new({
	    imp: 0xC8,
	}),
	JMP: Opcode.new({
	    abs: 0x4C,
	    ind: 0x6C,
		absX: 0x7C,
	}),
	JSR: Opcode.new({
	    abs: 0x20,
	}),
	LDA: Opcode.new({
	    imm: 0xA9,
	    zpage: 0xA5,
	    zpageX: 0xB5,
	    abs: 0xAD,
	    absX: 0xBD,
	    absY: 0xB9,
		zpageind: 0xB2,
	    indX: 0xA1,
	    indY: 0xB1,
	}),
	LDX: Opcode.new({
	    imm: 0xA2,
	    zpage: 0xA6,
	    zpageY: 0xB6,
	    abs: 0xAE,
	    absY: 0xBE
	}),
	LDY: Opcode.new({
	    imm: 0xA0,
	    zpage: 0xA4,
	    zpageX: 0xB4,
	    abs: 0xAC,
	    absX: 0xBC
	}),
	LSR: Opcode.new({
	    acc: 0x4A,
	    zpage: 0x46,
	    zpageX: 0x56,
	    abs: 0x4E,
	    absX: 0x5E
	}),
	NOP: Opcode.new({
	    imp: 0xEA
	}),
	ORA: Opcode.new({
	    imm: 0x09,
	    zpage: 0x05,
	    zpageX: 0x15,
	    abs: 0x0D,
	    absX: 0x1D,
	    absY: 0x19,
		zpageind: 0x12,
	    indX: 0x01,
	    indY: 0x11
	}),
	PHA: Opcode.new({
	    imp: 0x48
	}),
	PHP: Opcode.new({
	    imp: 0x08
	}),
	PHX: Opcode.new({
		imp: 0xDA
	}),
	PHY: Opcode.new({
		imp: 0x5A
	}),
	PLA: Opcode.new({
	    imp: 0x68
	}),
	PLP: Opcode.new({
	    imp: 0x28
	}),
	PLX: Opcode.new({
		imp: 0xFA
	}),
	PLY: Opcode.new({
		imp: 0x7A
	}),
	RMB0: Opcode.new({
		zpage: 0x07
	}),
	RMB1: Opcode.new({
		zpage: 0x17
	}),
	RMB2: Opcode.new({
		zpage: 0x27
	}),
	RMB3: Opcode.new({
		zpage: 0x37
	}),
	RMB4: Opcode.new({
		zpage: 0x47
	}),
	RMB5: Opcode.new({
		zpage: 0x57
	}),
	RMB6: Opcode.new({
		zpage: 0x67
	}),
	RMB7: Opcode.new({
		zpage: 0x77
	}),
	ROL: Opcode.new({
	    acc: 0x2A,
	    zpage: 0x26,
	    zpageX: 0x36,
	    abs: 0x2E,
	    absX: 0x3E
	}),
	ROR: Opcode.new({
	    acc: 0x6A,
	    zpage: 0x66,
	    zpageX: 0x76,
	    abs: 0x6E,
	    absX: 0x7E
	}),
	RTI: Opcode.new({
	    imp: 0x40
	}),
	RTS: Opcode.new({
	    imp: 0x60
	}),
	SBC: Opcode.new({
	    imm: 0xE9,
	    zpage: 0xE5,
	    zpageX: 0xF5,
	    abs: 0xED,
	    absX: 0xFD,
	    absY: 0xF9,
		zpageind: 0xF2,
	    indX: 0xE1,
	    indY: 0xF1
	}),
	SEC: Opcode.new({
	    imp: 0x38
	}),
	SED: Opcode.new({
	    imp: 0xF8
	}),
	SEI: Opcode.new({
	    imp: 0x78
	}),
	SMB0: Opcode.new({
		zpage: 0x87
	}),
	SMB1: Opcode.new({
		zpage: 0x97
	}),
	SMB2: Opcode.new({
		zpage: 0xA7
	}),
	SMB3: Opcode.new({
		zpage: 0xB7
	}),
	SMB4: Opcode.new({
		zpage: 0xC7
	}),
	SMB5: Opcode.new({
		zpage: 0xD7
	}),
	SMB6: Opcode.new({
		zpage: 0xE7
	}),
	SMB7: Opcode.new({
		zpage: 0xF7
	}),
	STA: Opcode.new({
	    zpage: 0x85,
	    zpageX: 0x95,
	    abs: 0x8D,
	    absX: 0x9D,
	    absY: 0x99,
		zpageind: 0x92,
	    indX: 0x81,
	    indY: 0x91
	}),
	STP: Opcode.new({
		imp: 0xDB
	}),
	STX: Opcode.new({
	    zpage: 0x86,
	    zpageY: 0x96,
	    abs: 0x8E
	}),
	STY: Opcode.new({
	    zpage: 0x84,
	    zpageX: 0x94,
	    abs: 0x8C
	}),
	STZ: Opcode.new({
		zpage: 0x64,
		zpageX: 0x74,
		abs: 0x9C,
		absX: 0x9E
	}),
	TAX: Opcode.new({
	    imp: 0xAA
	}),
	TAY: Opcode.new({
	    imp: 0xA8
	}),
	TRB: Opcode.new({
		zpage: 0x14,
		abs: 0x1C,
	}),
	TSB: Opcode.new({
		zpage: 0x04,
		abs: 0x0C
	}),
	TSX: Opcode.new({
	    imp: 0xBA
	}),
	TXA: Opcode.new({
	    imp: 0x8A
	}),
	TXS: Opcode.new({
	    imp: 0x9A
	}),
	TYA: Opcode.new({
	    imp: 0x98
	}),
	WAI: Opcode.new({
		imp: 0xCB
	})
}

def noByte(name, mode, op)
	puts "#{name} (#{mode}) = genericNoByteOp #{op}"
end
def oneByte(name, mode, op)
	puts "#{name} (#{mode} b) = genericOp #{op} b"
end
def twoByte(name, mode, op)
	puts "#{name} (#{mode} b) = genericTwoByteOp #{op} b"
end
if __FILE__ == $0
	# Format as Haskell functions
	@_65C02_OPCODES.each do |k,v|
		name = k.to_s.downcase
		puts "#{name} :: AddressingMode -> Instruction"
		v.get_modes.each do |mode,op|
			case mode
				when :imp
					noByte(name, "Implied", op)
				when :acc
					noByte(name, "Accumulator", op)
				when :imm
					oneByte(name, "Immediate", op)
				when :abs
					twoByte(name, "Absolute", op)
				when :rel
					oneByte(name, "Relative", op)
				when :bitrel
					oneByte(name, "ZeroPageRelative", op)
				when :absX
					twoByte(name, "AbsoluteX", op)
				when :absY
					twoByte(name, "AbsoluteY", op)
				when :zpage
					oneByte(name, "ZeroPage", op)
				when :zpageX
					oneByte(name, "ZeroPageX", op)
				when :zpageY
					oneByte(name, "ZeroPageY", op)
				when :zpageind
					oneByte(name, "ZeroPageIndirect", op)
				when :ind
					twoByte(name, "Indirect", op)
				when :indX
					oneByte(name, "IndirectX", op)
				when :indY
					oneByte(name, "IndirectY", op)
				else
					raise "Unrecognized #{mode}"
			end
		end
		puts
	end
end
