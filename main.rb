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
        puts "Original reaction:"
        puts "    #{reaction_to_string(reaction)}"
        puts "Balanced reaction:"
        puts "    #{reaction_to_string(balancedReaction)}"
        loop do
            puts "What would you like to do with this reaction?"
            puts "    Perform a (c)onversion"
            puts "    Find the (l)imiting reactant"
            programBranch = gets.chomp
            programBranch.downcase!
            if programBranch == "c"
                # TODO
            elsif programBranch == "l"
                puts "Which product is the desired product?"
                balancedReaction[:products].each_with_index do |product, i|
                    puts "(#{i}): #{chemical_formula_to_string(product[:chemical])}"
                end
                desiredProductInput = gets.chomp
                desiredProduct = balancedReaction[:products][desiredProductInput.to_i]
                reactantMasses = []
                balancedReaction[:reactants].each_with_index do |reactant, i|
                    puts "How many grams of #{chemical_formula_to_string(reactant[:chemical])} are in the reaction?"
                    reactantMasses[i] = gets.chomp.to_f
                end
                puts "Stoichiometric charts:"
                balancedReaction[:reactants].each_with_index do |reactant, i|
                    puts "\e[4m#{chemical_formula_to_string(reactant[:chemical])}:\e[0m"
                    puts stoichiometric_chart(
                                                reactantMasses[i],
                                                molar_mass(reactant[:chemical]), "g", chemical_formula_to_string(reactant[:chemical]),
                                                [desiredProduct[:coefficient], reactant[:coefficient]],
                                                molar_mass(desiredProduct[:chemical]), "g", chemical_formula_to_string(desiredProduct[:chemical])
                                             )
                    puts
                end
            end
        end
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
