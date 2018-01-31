require_relative "chemical_parser.rb"
require_relative "chemical_analysis.rb"

if __FILE__ == $0
    loop do
        puts %Q(┌────────────────────────────────────────────────────┐
│░█▀▀░▀█▀░█▀█░▀█▀░█▀▀░█░█░▀█▀░█▀█░█▄█░█▀▀░▀█▀░█▀▄░█░█│
│░▀▀█░░█░░█░█░░█░░█░░░█▀█░░█░░█░█░█░█░█▀▀░░█░░█▀▄░░█░│
│░▀▀▀░░▀░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░░▀░░▀░▀░░▀░│
└────────────────────────────────────────────────────┘)
    	i = gets.chomp
    	input = lex_chemical_formula(i)
    	formula = parse_chemical_formula(lex_chemical_formula(i))
    	puts "parsed formula:" if $DEBUG
    	pp formula if $DEBUG
    	puts "parsed chemical name: #{chemical_formula_to_string(formula)}" if $DEBUG
    end
end
