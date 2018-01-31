$DEBUG = true

$PeriodicTable = {}
File.read("periodic_table").split(?\n).each do |line|
	ps = line.split(/\s+/)
	$PeriodicTable[ps[2]] = ps[0].to_f
end

$ChemicalTemplate = {
	type: :chemical, #chemical (populate name) or group (populate children)
	name: "", #1-2 letter abbreviation
	children: [], #child element
	subscript: 1
}

$MoleculeTemplate = {
    chemical: [], # [$ChemicalTemplate]
    coefficient: 1
}

$ReactionTemplate = {
    reactants: [
        # [$MoleculeTemplate],
        # [$MoleculeTemplate],
        # [$MoleculeTemplate],
        # ...
    ],
    products: [
        # [$MoleculeTemplate],
        # [$MoleculeTemplate],
        # [$MoleculeTemplate],
        # ...
    ]
}
