require_relative "chemical_parser.rb"
require_relative "chemical_analysis.rb"

if __FILE__ == $0
    puts %Q(┌────────────────────────────────────────────────────┐
│░█▀▀░▀█▀░█▀█░▀█▀░█▀▀░█░█░▀█▀░█▀█░█▄█░█▀▀░▀█▀░█▀▄░█░█│
│░▀▀█░░█░░█░█░░█░░█░░░█▀█░░█░░█░█░█░█░█▀▀░░█░░█▀▄░░█░│
│░▀▀▀░░▀░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░░▀░░▀░▀░░▀░│
└────────────────────────────────────────────────────┘)
    puts "Hello, and welcome to the stoichiometry toolbox. Type `r` for a reaction or `f` for a single chemical formula, then strike `Return`."
    programMode = gets.chomp.downcase
    if programMode == "r"
        puts "Input the reactant(s), separated by a `+`. Note: do not add the coefficients. They will be automatically generated."
        reactantStrings = gets.chomp.gsub(/\s/, "").split("+")
        reactantFormulas = reactantStrings.map { |reactantString| parse_chemical_formula(lex_chemical_formula(reactantString)) }
        puts "Input the product(s), separated by a `+`."
        productStrings = gets.chomp.gsub(/\s/, "").split("+")
        productFormulas = productStrings.map { |productString| parse_chemical_formula(lex_chemical_formula(productString)) }
        reaction = create_reaction_from_chemicals(reactantFormulas, productFormulas)
        print "main(): reaction:" if $DEBUG
        pp reaction if $DEBUG
        balancedReaction = balance_reaction(reaction)
    elsif programMode == "f"
        puts "Input a chemical formula."
        formula = parse_chemical_formula(lex_chemical_formula(gets.chomp))
        print "main(): formula:" if $DEBUG
        pp formula if $DEBUG
        puts "Molar mass: #{molar_mass(formula).round(1)} g."
    else
        puts "Invalid program mode. Exiting..."
    end
end
