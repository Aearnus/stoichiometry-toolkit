require_relative "globals.rb"

def flatten_chemical_formula(formula)
    out = []
    formula.each do |e|
        if e[:type] == :chemical
            out << e.clone
        elsif e[:type] == :parent
            modified_children = e[:children].map { |child| child[:subscript] = child[:subscript] * e[:subscript]}
            flatten_chemical_formula(modified_children).each do |e0|
                out << e0.clone
            end
        end
    end
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
