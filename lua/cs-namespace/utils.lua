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
	local csproj_files = {}
	local start_dir = vim.fn.getcwd() -- Get the current working directory

	-- Recursive function to find .csproj files
	local function search_dir(dir)
		local files = vim.fn.readdir(dir)

		for _, file in ipairs(files) do
			local filepath = dir .. "/" .. file
			if vim.fn.isdirectory(filepath) == 1 then
				search_dir(filepath) -- Recursively search directories
			elseif filepath:match("%.csproj$") then
				-- Extract the directory path and filename
				local path = vim.fn.fnamemodify(filepath, ":h")
				local name = vim.fn.fnamemodify(filepath, ":t")
				table.insert(csproj_files, { path = path, name = name })
			end
		end
	end
	search_dir(start_dir) -- Start searching from the current directory
	return csproj_files
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
