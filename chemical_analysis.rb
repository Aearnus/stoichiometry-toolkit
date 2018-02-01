require_relative "globals.rb"

def flatten_chemical_formula(formula)
    puts "flatten_chemical_formula(): formula:#{formula}"
    out = []
    formula.each do |e|
        if e[:type] == :chemical
            out << e.clone
        elsif e[:type] == :parent
            modified_children = e[:children].each do |child|
                child[:subscript] = child[:subscript] * e[:subscript]
            end
            flatten_chemical_formula(modified_children).each do |e0|
                out << e0.clone
            end
        end
    end
    puts "flatten_chemical_formula(): out:#{out}"
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
            out[:reactants][elementName] += element[:subscript]
        end
    end
    reaction[:products].each do |product|
        flatten_chemical_formula(product[:chemical]).each do |element|
            elementName = element[:name].to_sym
            if out[:products][elementName].nil?
                out[:products][elementName] = 0
            end
            out[:products][elementName] += element[:subscript]
        end
    end
    print "get_reaction_sums(): output:" if $DEBUG
    pp out if $DEBUG
    return out
end

def balance_reaction(reaction)
    sums = get_reaction_sums(reaction)
    if sums[:reactants].keys.sort != sums[:products].keys.sort
        raise "Invalid chemical formula -- cannot be balanced"
    end
end
