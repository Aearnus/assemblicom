#------------------------------------------------
# Objects containing opcodes
# Remember, 65C02/65816 is little-endian
# Addressing modes:
#     imp: implied
#     acc: A (accumulator)
#     imm: #NN (immediate)
#     zpage: $NN (zero page)
#     zpageX: $NN,X (zero page,X)
#     zpageY: $NN,Y (zero page,Y)
#     rel: *+/-NN (relative)
#     abs: $NNNN (absolute)
#     absX: $NNNN,X (absolute,X)
#     absY: $NNNN,Y (absolute,Y)
#     ind: ($NNNN) (indirect)
#     indX: ($NN,X) (indirect,X)
#     indY: ($NN),Y (indirect,Y)
#------------------------------------------------
class Opcode
	@@modes = {}
	def initialize(modes)
		modes.keys.each do |mode|
			if !%i(imp ind acc imm zpage zpageX abs absX absY indX indY)
				puts "Invalid addressing mode #{mode}"
			end
		end
		@@modes = modes
	end
end
6502_OPCODES = {
	ADC: Opcode.new({
	    imm: 0x69,
	    zpage: 0x65,
	    zpageX: 0x75,
	    abs: 0x6D,
	    absX: 0x7D,
	    absY: 0x79,
	    indX: 0x61,
	    indY: 0x71,
	}),
	AND: Opcode.new({
	    imm: 0x29,
	    zpage: 0x25,
	    zpageX: 0x35,
	    abs: 0x2D,
	    absX: 0x3D,
	    absY: 0x39,
	    indX: 0x21,
	    indY: 0x31,
	}),
	ASL: Opcode.new({
	    acc: 0x0A,
	    zpage: 0x06,
	    zpageX: 0x16,
	    abs: 0x0E,
	}),
	BCC: Opcode.new({
	    rel: 0x90,
	}),
	BCS: Opcode.new({
	    rel: 0xB0,
	}),
	BEQ: Opcode.new({
	    rel: 0xF0,
	}),
	BIT: Opcode.new({
	    zpage: 0x24,
	    abs: 0x2C,
	}),
	BMI: Opcode.new({
	    rel: 0x30,
	    rel: 0xD0,
	}),
	BPL: Opcode.new({
	    rel: 0x10,
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
	    indX: 0x41,
	    indY: 0x51,
	}),
	INC: Opcode.new({
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
	    indX: 0xA1,
	    indY: 0xB1,
	}),
	LDX: Opcode.new({
	    imm: 0xA2,
	    zpage: 0xA6,
	    zpageY: 0xB6,
	    abs: 0xAE,
	    absY: 0xBE,
	}),
	LDY: Opcode.new({
	    imm: 0xA0,
	    zpage: 0xA4,
	    zpageX: 0xB4,
	    abs: 0xAC,
	    absX: 0xBC,
	}),
	LSR: Opcode.new({
	    acc: 0x4A,
	    zpage: 0x46,
	    zpageX: 0x56,
	    abs: 0x4E,
	    absX: 0x5E,
	}),
	NOP: Opcode.new({
	    imp: 0xEA,
	}),
	ORA: Opcode.new({
	    imm: 0x09,
	    zpage: 0x05,
	    zpageX: 0x15,
	    abs: 0x0D,
	    absX: 0x1D,
	    absY: 0x19,
	    indX: 0x01,
	    indY: 0x11,
	}),
	PHA: Opcode.new({
	    imp: 0x48,
	}),
	PHP: Opcode.new({
	    imp: 0x08,
	}),
	PLA: Opcode.new({
	    imp: 0x68,
	}),
	PLP: Opcode.new({
	    imp: 0x28,
	}),
	ROL: Opcode.new({
	    acc: 0x2A,
	    zpage: 0x26,
	    zpageX: 0x36,
	    abs: 0x2E,
	    absX: 0x3E,
	}),
	ROR: Opcode.new({
	    acc: 0x6A,
	    zpage: 0x66,
	    zpageX: 0x76,
	    abs: 0x6E,
	    absX: 0x7E,
	}),
	RTI: Opcode.new({
	    imp: 0x40,
	}),
	RTS: Opcode.new({
	    imp: 0x60,
	}),
	SBC: Opcode.new({
	    imm: 0xE9,
	    zpage: 0xE5,
	    zpageX: 0xF5,
	    abs: 0xED,
	    absX: 0xFD,
	    absY: 0xF9,
	    indX: 0xE1,
	    indY: 0xF1,
	}),
	SEC: Opcode.new({
	    imp: 0x38,
	}),
	SED: Opcode.new({
	    imp: 0xF8,
	}),
	SEI: Opcode.new({
	    imp: 0x78,
	}),
	STA: Opcode.new({
	    zpage: 0x85,
	    zpageX: 0x95,
	    abs: 0x8D,
	    absX: 0x9D,
	    absY: 0x99,
	    indX: 0x81,
	    indY: 0x91,
	}),
	STX: Opcode.new({
	    zpage: 0x86,
	    zpageY: 0x96,
	    abs: 0x8E,
	}),
	STY: Opcode.new({
	    zpage: 0x84,
	    zpageX: 0x94,
	    abs: 0x8C,
	}),
	TAX: Opcode.new({
	    imp: 0xAA,
	}),
	TAY: Opcode.new({
	    imp: 0xA8,
	}),
	TSX: Opcode.new({
	    imp: 0xBA,
	}),
	TXA: Opcode.new({
	    imp: 0x8A,
	}),
	TXS: Opcode.new({
	    imp: 0x9A,
	}),
	TYA: Opcode.new({
	    imp: 0x98,
	})
}
