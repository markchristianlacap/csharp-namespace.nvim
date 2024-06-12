local M = {}

function M.remove_start(original_string, start_to_remove)
	-- Check if the original string starts with the substring to remove
	if original_string:sub(1, #start_to_remove) == start_to_remove then
		-- If it does, remove the substring
		return original_string:sub(#start_to_remove + 1)
	else
		-- If not, return the original string unchanged
		return original_string
	end
end

-- Function to find .csproj files recursively
function M.find_csproj_files()
	local proj_files = {}
	-- Get the current working directory
	local cwd = vim.fn.getcwd()

	-- Construct the command
	local command = "find " .. cwd .. " -name '*.csproj' -exec realpath {} \\;"

	-- Execute the command and capture the output
	local output = vim.fn.system(command)
	-- Loop through each line in the output
	for line in output:gmatch("[^\r\n]+") do
		-- Extract the directory and filename using Lua's pattern matching
		local directory, filename = string.match(line, "(.-)/([^/]+)$")
		if directory and filename then
			table.insert(proj_files, { path = directory, name = filename })
		end
	end
	return proj_files
end

function M.starts_with(str, prefix)
	return string.sub(str, 1, string.len(prefix)) == prefix
end

function M.search_value_starts_with(tbl, value)
	for _, val in pairs(tbl) do
		local result = M.starts_with(value, val.path)
		if result then
			return true, val -- Value found, return true and the corresponding key
		end
	end
	return false, nil -- Value not found
end

return M
