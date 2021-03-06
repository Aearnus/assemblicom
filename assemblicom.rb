#================================================
# Parse command line options
#================================================
require "optparse"

options = {}
options[:instruction] = "65C02"
options[:outfile] = "out.bin"
OptionParser.new do |opts|
	opts.banner = "Assemblicom: assemble 65C02 and 65816 assembly files to machine code.\nUsage: assemblicom.rb [options] [file]"
	opts.on("-i", "--instruction type", "Choose the instruction set to compile for (6502/famicom/nes or 65816/superfamicom/snes. default 6502)") do |instruction|
		options[:instruction] = instruction
		if !%w(6502 famicom nes 65816 superfamicom snes).include? instruction
			puts "Unrecognized instruction set #{instruction}"
			exit
		end
	end
	opts.on("-c", "--config file", "Choose the file to configure (S)NES ROM (will be created)") do
		options[:config] = config
	end
	opts.on("-o", "--output file", "Choose the file to output to (default out.bin)") do |outfile|
		options[:outfile] = outfile
	end
	opts.on("-h", "--help", "Display the help menu") do
		puts opts
		exit
	end
end.parse!
if ARGV.empty?
	puts "You must provide an input file, use --help for options."
	exit
else
	options[:infile] = []
	while !ARGV.empty?
		options[:infile] << ARGV.shift
	end
end
p options

#================================================
# Parse the assembly into machine code
#================================================
def assembleError(file, line, error)
	puts "#{file} L#{line}: #{error}"
end
def assembleFail(passNo)
	puts "Failed to assemble files in pass #{passNo}."
	puts "No code was generated."
	exit
end
#------------------------------------------------
# Load the assembly file(s) into memory
# Clean the whitespace, remove comments
#------------------------------------------------
def cleanAsmLine(line)
	return line.strip.split(";")[0]
end
asm_files = {}
options[:infile].each do |asm_file|
	asm_files[asm_file] = []
	File.open(asm_file).each do |asm_file_line|
		asm_files[asm_file].push(cleanAsmLine(asm_file_line))
	end
end
p asm_files
#------------------------------------------------
# Pass 1: Assembler directives
# The directives run in order from top -> bottom
#------------------------------------------------
directive_regex = /^\.(\S+)\s+(.+)$/
def thereAreMoreDirectives(_asm_files, regex)
	_asm_files.each_pair do |_, asm_lines|
		asm_lines.each do |asm_line|
			if asm_line =~ regex
				return true
			end
		end
	end
	return false
end
defintions = {}
while thereAreMoreDirectives(asm_files, directive_regex)
	needToRecurse = false
	asm_files.each_pair do |file_name, asm_lines|
		asm_lines.each_with_index do |asm_line, line_index|
			directive_match = asm_line.scan(directive_regex)
			#one and ONLY one directive per line
			next if directive_match.empty?
			next if directive_match.length > 1
			directive = directive_match.first
			case directive.shift
			when "define"
				definition = directive.first.split(" ")
				keyWord = definition.first
				valueWords = definition[1..-1].join(" ")
				asm_lines.each_with_index do |_asm_line, _line_index|
					puts "Checking for definition #{keyWord} -> #{valueWords} on line #{_asm_line}"
					asm_files[file_name][_line_index].sub!(keyWord, valueWords)
				end
				asm_files[file_name].delete_at(line_index)
				needToRecurse = true
				break
			when "include"
				#insert the other file into this one
				file_to_include = directive.join(" ")
				if !asm_files.keys.include? file_to_include
					assembleError(file_name, line_index, "Included file #{file_to_include} not found or not assembled.")
					assembleFail(1)
				end
				asm_files[file_name].delete_at(line_index)
				asm_files[file_name].insert(line_index, asm_files[file_to_include])
				asm_files[file_name].flatten!
				asm_files.delete(file_to_include)
				needToRecurse = true
				break
			end
			break if needToRecurse
		end
	end
end
p asm_files

#------------------------------------------------
# Pass 2: Syntax validity check/markers
#------------------------------------------------
# Addressing modes:
#     imp: (implied)
#          (stack addressing is included here, though it is officially seperate)
#     acc: A (accumulator)
#     imm: #NN (immediate)
#     abs: $NNNN (absolute)
#     rel: *+/-NNNN OR <label> (relative)
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
#------------------------------------------------
def nhex(n)
	return /[0-9A-F]{#{n}}/
end
mnem = /[A-Z]{3,4}/
valid_syntax = {
	label: /^\S+:$/,
	imp: /^#{mnem}$/,
	acc: /^#{mnem}\s+A$/,
	imm: /^#{mnem}\s+##{nhex(2)}$/,
	abs: /^#{mnem}\s+\$#{nhex(4)}$/,
	relhex: /^#{mnem}\s+\*[+-]#{nhex(2)}$/,
	rellabel: /^#{mnem}\s+\S+$/,
	bitrelhex: /^#{mnem}\s+\$#{nhex(2)},\*[+-]#{nhex(2)}$/,
	bitrellabel: /^#{mnem}\s+\$#{nhex(2)},\S+$/,
	absX: /^#{mnem}\s+\$#{nhex(4)},X$/,
	absY: /^#{mnem}\s+\$#{nhex(4)},Y$/,
	zpage: /^#{mnem}\s+\$#{nhex(2)}$/,
	zpageX: /^#{mnem}\s+\$#{nhex(2)},X$/,
	zpageY: /^#{mnem}\s+\$#{nhex(2)},Y$/,
	zpageind: /^#{mnem}\s+\(\$#{nhex(2)}\)$/,
	ind: /^#{mnem}\s+\(\$#{nhex(4)}\)$/,
	indX: /^#{mnem}\s+\(\$#{nhex(2)},X\)$/,
	indY: /^#{mnem}\s+\(\$#{nhex(2)}\),Y$/
}
def getLineType(line, _valid_syntax)
	_valid_syntax.each_pair do |mode, reg|
		return mode if line =~ reg
	end
	return :invalid
end
lines_to_assemble = []
#only assemble the first assembly file, the rest are .import'ed
asm_files.first.last.each_with_index do |asm_line, line_index|
	puts "#{asm_index}: #{asm_line}"
	line_type = getLineType(asm_line)
	if line_type == :invalid
		assembleError(asm_files.first.first, line_index, "Syntax error")
	end
	lines_to_assemble << {asm: asm_line, syntax: line_type}
end
p lines_to_assemble


#================================================
# Write the machine code to disk
#================================================
#------------------------------------------------
# This does not write any console-specific
# headers, use headericom.rb to add them
# afterward.
#------------------------------------------------
