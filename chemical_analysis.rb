$PeriodicTable = {}
File.read("periodic_table").split(?\n).each do |line|
	ps = line.split(/\s+/)
	$PeriodicTable[ps[2]] = ps[0].to_f
end
