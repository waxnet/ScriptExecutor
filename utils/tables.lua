tables = {}
do
	tables.countDictKeys = function(dict)
		local count = 0
		for _ in pairs(dict) do
			count = count + 1
		end
		return count
	end
	
	tables.separateTable = function(originalTable)
		local separatedTables = {}
		local currentTable = {}
		local count = 0

		-- sorted list of the scripts
		local sortedScripts = {}
		for key, value in pairs(originalTable) do
			table.insert(sortedScripts, {key = key, value = value})
		end
		table.sort(sortedScripts, function(a, b)
			return (a.value.index < b.value.index)
		end)

		-- separate the scripts into groups of 5
		for _, script in ipairs(sortedScripts) do
			table.insert(currentTable, script.value)
			count = count + 1

			if count == 5 then
				table.insert(separatedTables, currentTable)
				currentTable = {}
				count = 0
			end
		end
		if next(currentTable) ~= nil then
			table.insert(separatedTables, currentTable)
		end

		return separatedTables
	end
end
