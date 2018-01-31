require "pp"

$ChemicalTemplate = {
	type: :parent	, #chemical (populate name) or group (populate children)
	name: "", #1-2 letter abbreviation
	children: [], #child element
	subscript: 0,
}

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
		puts "find_paren_pair_length(): formulaArray[openIndex (#{openIndex})]:#{formulaArray[openIndex]} ():#{parenDepth} L:#{outLength}"
	end
	return outLength
end

def parse_chemical_formula(formulaArray)
	puts "parse_chemical_formula(): formulaArray:#{formulaArray}"
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
			puts "parse_chemical_formula(): iterationsToSkip:#{iterationsToSkip} endParenToken:#{endParenToken}"
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
