require "pp"
require_relative "globals.rb"

def lex_chemical_formula(formulaString)
	formulaArrayWithNil = formulaString.scan(/([A-Z][a-z]?)([0-9]*)|(\()|(\))([0-9]*)/)
	formulaArray = formulaArrayWithNil.map { |token| token.nil? ? "" : token }
	return formulaArray
end

def find_paren_pair_length(formulaArray, openIndex)
	outLength = 0
	parenDepth = 1
	while parenDepth > 0 do
		openIndex += 1
		# if there's another open paren
		if !formulaArray[openIndex][2].nil?
			parenDepth += 1
		elsif !formulaArray[openIndex][3].nil?
			parenDepth -= 1
		end
		outLength += 1
		puts "find_paren_pair_length(): formulaArray[openIndex (#{openIndex})]:#{formulaArray[openIndex]} ():#{parenDepth} L:#{outLength}" if $DEBUG
	end
	return outLength
end

def parse_chemical_formula(formulaArray)
	puts "parse_chemical_formula(): formulaArray:#{formulaArray}" if $DEBUG
	# array indices (may not be populated):
	# 0: chemical name
	# 1: chemical subscript
	# 2: open paren
	# 3: close paren
	# 4: close paren subscript
	out = []
	iterationsToSkip = 0
	formulaArray.each_with_index do |token, index|
		# skip over nested parens
		if (iterationsToSkip > 0)
			iterationsToSkip -= 1
			next
		end
		out << $ChemicalTemplate.clone
		if !token[0].nil?
			# if the lexer produces a chemical symbol
			out[-1][:type] = :chemical
			out[-1][:name] = token[0]
			if token[1].empty?
				out[-1][:subscript] = 1
			else
				out[-1][:subscript] = token[1].to_i
			end
		elsif !token[2].nil?
			# if the lexer produces an open paren, begin recursion
			# first, make sure to skip to after the corresponding close paren
			# subtract one so that the parser hits the close paren
			iterationsToSkip = find_paren_pair_length(formulaArray, index) - 1
			out[-1][:type] = :parent
			out[-1][:children] = parse_chemical_formula(formulaArray[index + 1 .. index + 1 + iterationsToSkip])
			# set the coefficient using the paren length
			endParenToken = formulaArray[index + 1 + iterationsToSkip]
			puts "parse_chemical_formula(): iterationsToSkip:#{iterationsToSkip} endParenToken:#{endParenToken}" if $DEBUG
			if endParenToken[4].empty?
				out[-1][:subscript] = 1
			else
				out[-1][:subscript] = endParenToken[4].to_i
			end
		elsif !token[3].nil?
			# if you run into a close paren (that wasn't skipped over)
			out.pop
		end
	end
	return out
end

def reaction_to_string(reaction)
	out = ""
	reactantStrings = []
	reaction[:reactants].each do |reactant|
		reactantStrings << "#{reactant[:coefficient] > 1 ? reactant[:coefficient] : ""}#{chemical_formula_to_string(reactant[:chemical])}"
    end
	productStrings = []
    reaction[:products].each do |product|
		productStrings << "#{product[:coefficient] > 1 ? product[:coefficient] : ""}#{chemical_formula_to_string(product[:chemical])}"
    end
	out << reactantStrings.join(" + ") << " → " << productStrings.join(" + ")
	return out
end
def chemical_formula_to_string(formula)
	out = ""
	formula.each do |chemical|
		if chemical[:type] == :chemical
			out << chemical[:name]
			out << ((chemical[:subscript] > 1) ? chemical[:subscript].to_s : "")
		elsif chemical[:type] == :parent
			out << "("
			out << chemical_formula_to_string(chemical[:children])
			out << ")"
			out << chemical[:subscript].to_s
		end
	end
	return out
end

def create_reaction_from_chemicals(reactants, products)
	reaction = $ReactionTemplate.clone
	reactants.each do |reactant|
		molecule = $MoleculeTemplate.clone
		molecule[:chemical] = reactant
		reaction[:reactants] << molecule
	end
	products.each do |product|
		molecule = $MoleculeTemplate.clone
		molecule[:chemical] = product
		reaction[:products] << molecule
	end
	return reaction
end
