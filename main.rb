require_relative "chemical_parser.rb"
require_relative "chemical_analysis.rb"

if __FILE__ == $0
    loop do
        puts %Q(┌────────────────────────────────────────────────────┐
│░█▀▀░▀█▀░█▀█░▀█▀░█▀▀░█░█░▀█▀░█▀█░█▄█░█▀▀░▀█▀░█▀▄░█░█│
│░▀▀█░░█░░█░█░░█░░█░░░█▀█░░█░░█░█░█░█░█▀▀░░█░░█▀▄░░█░│
│░▀▀▀░░▀░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░░▀░░▀░▀░░▀░│
└────────────────────────────────────────────────────┘)
        puts "please input a reactant"
    	reactant_string = gets.chomp
    	reactant_formula = parse_chemical_formula(lex_chemical_formula(reactant_string))
    	puts "parsed formula:" if $DEBUG
    	pp reactant_formula if $DEBUG
    	puts "parsed chemical name: #{chemical_formula_to_string(reactant_formula)}" if $DEBUG
        puts "please input a product"
    	product_string = gets.chomp
    	product_formula = parse_chemical_formula(lex_chemical_formula(product_string))
    	puts "parsed formula:" if $DEBUG
    	pp product_formula if $DEBUG
    	puts "parsed chemical name: #{chemical_formula_to_string(product_formula)}" if $DEBUG
        reaction = create_reaction_from_chemicals([reactant_formula], [product_formula])
        balance_reaction(reaction)
    end
end
