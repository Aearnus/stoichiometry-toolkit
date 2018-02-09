require_relative "chemical_parser.rb"
require_relative "chemical_analysis.rb"

def askForUnit()
    puts "(l): liters","(mc): molecules","(g): grams"
    unit = gets.chomp.downcase
    if unit == "l"
        return :liters
    elsif unit == "mc"
        return :molecules
    elsif unit == "g"
        return :grams
    end
end
def unitToAbbr(unit)
    if unit == :liters
        return "L"
    elsif unit == :molecules
        return "mc"
    elsif unit == :grams
        return "g"
    end
end

if __FILE__ == $0
    puts %Q(┌────────────────────────────────────────────────────┐
│░█▀▀░▀█▀░█▀█░▀█▀░█▀▀░█░█░▀█▀░█▀█░█▄█░█▀▀░▀█▀░█▀▄░█░█│
│░▀▀█░░█░░█░█░░█░░█░░░█▀█░░█░░█░█░█░█░█▀▀░░█░░█▀▄░░█░│
│░▀▀▀░░▀░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░░▀░░▀░▀░░▀░│
└────────────────────────────────────────────────────┘)
    loop do
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
                puts "    Perform a stoichiometric (c)onversion"
                puts "    Find the (l)imiting reactant"
                puts "    (Q)uit to the main page"
                programBranch = gets.chomp
                programBranch.downcase!
                if programBranch == "c"
                    puts "What unit are you asking for?"
                    wantedUnit = askForUnit()
                    puts "What unit are you given?"
                    givenUnit = askForUnit()
                    #TODO
                    stoichiometric_chart(, , unitToAbbr(givenUnit), , , unitToAbbr(wantedUnit), )
                elsif programBranch == "p"
                    get_chemical_sum
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
                elsif programBranch == "q"
                    break
                end
            end
        elsif programMode == "f"
            puts "Input a chemical formula."
            formula = parse_chemical_formula(lex_chemical_formula(gets.chomp))
            print "main(): formula:" if $DEBUG
            pp formula if $DEBUG
            molarMass = molar_mass(formula)[:mass].round(1)
            puts "Molar mass equation:"
            puts "    #{molar_mass(formula)[:string]}"
            puts "Molar mass:"
            puts "    #{molarMass} g."
            puts "Percent composition:"
            get_chemical_sum(formula).each do |chemSym, count|
                puts "\e[4m#{chemSym.to_s}:\e[0m"
                topLine = (count * $PeriodicTable[chemSym.to_s].round(1))
                bottomLine = molarMass
                puts "     #{topLine} "
                puts "    " + ("-" * ([topLine.to_s.length,bottomLine.to_s.length].max + 2)) + " = #{100* topLine / bottomLine}%"
                puts "     #{bottomLine} "
            end
        else
            puts "Invalid program mode. Exiting..."
        end
    end
end
