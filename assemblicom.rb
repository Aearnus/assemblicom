#================================================
# Parse command line options
#================================================
require "optparse"

options = {}
options[:instruction] = "6502"
options[:outfile] = "out.bin"
OptionParser.new do |opts|
	opts.banner = "Assemblicom: assemble 65C02 and 65816 assembly files to machine code.\nUsage: assemblicom.rb [options] [file]"
	opts.on("-i", "--instruction type", "Choose the instruction set to compile for (6502/famicom/nes or 65816/superfamicom/snes. default 6502)") do |instruction|
		options[:instruction] = instruction
		if !%w(65C02 famicom nes 65816 superfamicom snes).include? instruction
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
def assembleError(file, line, error)
	puts "#{file} L#{line}: #{error}"
end
def assembleFail(passNo)
	puts "Failed to assemble files in pass #{passNo}."
	puts "No code was generated."
	exit
end
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
valid_syntax = {
	label: /^\S+:&/,
	#TODO
}
lines_to_assemble = []
#only assemble the first assembly file, the rest are .import'ed
asm_files.first.each do |asm_line|


#================================================
# Write the machine code to disk
#================================================
#------------------------------------------------
# This does not write any console-specific
# headers, use headericom.rb to add them
# afterward.
#------------------------------------------------
