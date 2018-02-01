require_relative "globals.rb"
require_relative "deep_dup.rb"

def flatten_chemical_formula(formulaIn)
    formula = formulaIn.deep_dup
    #puts "flatten_chemical_formula(): formula:#{formula}"
    out = []
    formula.each do |e|
        if e[:type] == :chemical
            out.push e.deep_dup
        elsif e[:type] == :parent
            modified_children = e[:children].each do |child|
                child[:subscript] = child[:subscript] * e[:subscript]
            end
            flatten_chemical_formula(modified_children).each do |e0|
                out.push e0.deep_dup
            end
        end
    end
    #puts "flatten_chemical_formula(): out:#{out}"
    return out
end

def molar_mass(formula)
    flat_formula = flatten_chemical_formula(formula)
    mass = 0
    flat_formula.each do |e|
        mass += $PeriodicTable[e[:name]] * e[:subscript]
    end
    return mass
end

def get_reaction_sums(reaction)
    out = {reactants: {}, products: {}}
    reaction[:reactants].each do |reactant|
        flatten_chemical_formula(reactant[:chemical]).each do |element|
            elementName = element[:name].to_sym
            if out[:reactants][elementName].nil?
                out[:reactants][elementName] = 0
            end
            out[:reactants][elementName] += element[:subscript] * reactant[:coefficient]
        end
    end
    reaction[:products].each do |product|
        flatten_chemical_formula(product[:chemical]).each do |element|
            elementName = element[:name].to_sym
            if out[:products][elementName].nil?
                out[:products][elementName] = 0
            end
            out[:products][elementName] += element[:subscript] * product[:coefficient]
        end
    end
    print "get_reaction_sums(): output:" if $DEBUG
    pp out if $DEBUG
    return out
end

def are_sums_balanced(sums)
    if sums[:reactants].sort == sums[:products].sort
        return true
    else
        return false
    end
end

def base_10_to_base_n(num, base, arrayLength)
    outNum = []
    while num > 0
        divMod = num.divmod(base)
        outNum << divMod[1]
        num = divMod[0]
    end
    while outNum.length < arrayLength
        outNum << 0
    end
    return outNum
end


def balance_reaction(reactionIn)
    reaction = reactionIn.deep_dup
    sums = get_reaction_sums(reaction)
    if sums[:reactants].keys.sort != sums[:products].keys.sort
        raise "Invalid chemical formula -- cannot be balanced"
    end
    # go through and fill up the coefficients 1 by 1, as if it was a base $MAX_BALANCE_SEARCH_SPACE number
    digits = reaction[:reactants].length + reaction[:products].length
    totalSearchSpace = $MAX_BALANCE_SEARCH_SPACE ** (digits)
    currentSearch = 0
    loop do
        currentSearch += 1
        coefficients = base_10_to_base_n(currentSearch, $MAX_BALANCE_SEARCH_SPACE, digits)
        if coefficients.include? 0
            next
        end
        print "balance_reaction(): coefficients:" if $DEBUG
        pp coefficients if $DEBUG
        reaction[:reactants].each_with_index do |_, i|
            reaction[:reactants][i][:coefficient] = coefficients[i]
        end
        reaction[:products].each_with_index do |_, i|
            reaction[:products][i][:coefficient] = coefficients[i + reaction[:reactants].length]
        end

        # success
        break if are_sums_balanced(get_reaction_sums(reaction))

        # exhaustion
        if currentSearch > totalSearchSpace
            raise "Can't balance equation -- search space exhausted. Increase globals.rb/$MAX_BALANCE_SEARCH_SPACE, possibly?"
        end
    end
    print "balance_reaction(): reaction:" if $DEBUG
    pp reaction if $DEBUG
    return reaction
end

def stoichiometric_chart(given, ratio1, unit1, formula1, ratioArrayCenter, ratio2, unit2, formula2)
    topLines = []
    bottomLines = []

    topLines << "#{given} #{unit1} #{formula1}"
    bottomLines << " " * topLines.last.length

    bottomLines << "#{ratio1} #{unit1}"
    topLines << "1 mol" + (" " * (bottomLines.last.length - "1 mol".length))

    topLines << "#{ratioArrayCenter[0]} mol #{formula2}"
    bottomLines << "#{ratioArrayCenter[1]} mol #{formula1}"
    if topLines.last.length < bottomLines.last.length
        topLines.last << " " * (bottomLines.last.length - topLines.last.length)
    else
        bottomLines.last << " " * (topLines.last.length - bottomLines.last.length)
    end

    topLines << "#{ratio2} #{unit2}"
    bottomLines << "1 mol" + (" " * (bottomLines.last.length - "1 mol".length))

    topLine = topLines.join(" | ")
    bottomLine = bottomLines.join(" | ")
    middleLine = "-" * topLine.length
    middleLine << " = #{(given * ratioArrayCenter[0] * ratio2)/(ratio1 * ratioArrayCenter[1]).round(3)} #{unit2} #{formula2}"
    return "#{topLine}\n#{middleLine}#\n#{bottomLine}"
end
