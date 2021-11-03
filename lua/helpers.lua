local function filebase(filepath)
	local filebase = filepath:match("(.+)%..+")
	return filebase
end

local function print_table_keys(table)
	for k,v in pairs(table) do
		print (k)
	end
end

local function table_length(table)
	local len = 0
	for k in pairs(table) do
		len=len+1
	end
	return len
end

return {
	print_table_keys = print_table_keys,
	table_length = table_length,
	filebase = filebase
}
