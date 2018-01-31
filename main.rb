require_relative "chemical_parser.rb"
require_relative "chemical_analysis.rb"

if __FILE__ == $0
    loop do
    	i = gets.chomp
    	input = lex_chemical_formula(i)
    	#p input
    	#mass = 0
    	#input.each do |element|
    	#	if element[1] == ""
    	#		element[1] = 1
    	#	end
    	#	mass += table[element[0]] * element[1].to_f
    	#end
    	#puts "#{mass.round(1)} amu"
    	formula = parse_chemical_formula(lex_chemical_formula(i))
    	puts "parsed formula:"
    	pp formula
    	puts "parsed chemical name: #{chemical_formula_to_string(formula)}"
    end
end
