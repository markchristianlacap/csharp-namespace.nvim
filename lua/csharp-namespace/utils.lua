--- Utility functions for C# namespace operations
local M = {}

--- Removes a prefix from a string if present
--- @param original_string string The original string
--- @param start_to_remove string The prefix to remove
--- @return string The string with prefix removed, or original string if prefix not found
function M.remove_start(original_string, start_to_remove)
	if not original_string or not start_to_remove then
		return original_string or ""
	end
	
	if original_string:sub(1, #start_to_remove) == start_to_remove then
		return original_string:sub(#start_to_remove + 1)
	end
	return original_string
end

--- Finds all .csproj files recursively in the current working directory
--- Uses vim.fs.find for better cross-platform compatibility
--- @return table Array of tables with {path: string, name: string}
function M.find_csproj_files()
	local proj_files = {}
	local cwd = vim.fn.getcwd()

	-- Use vim.fs.find for cross-platform compatibility (Neovim 0.8+)
	if vim.fs and vim.fs.find then
		local found = vim.fs.find(function(name, _)
			return name:match("%.csproj$")
		end, {
			type = "file",
			limit = math.huge,
			path = cwd,
		})

		for _, file_path in ipairs(found) do
			local directory = vim.fn.fnamemodify(file_path, ":h")
			local filename = vim.fn.fnamemodify(file_path, ":t")
			table.insert(proj_files, { path = directory, name = filename })
		end
	else
		-- Fallback to shell command for older Neovim versions
		-- Note: This may not work on Windows without WSL/Git Bash
		local command
		if vim.fn.has("win32") == 1 then
			-- Windows: use dir command
			command = 'dir /s /b "' .. cwd .. '\\*.csproj"'
		else
			-- Unix-like: use find command
			command = "find " .. vim.fn.shellescape(cwd) .. " -name '*.csproj' -type f"
		end

		local output = vim.fn.system(command)
		if vim.v.shell_error == 0 then
			for line in output:gmatch("[^\r\n]+") do
				-- Normalize path separators
				line = line:gsub("\\", "/")
				local directory, filename = line:match("^(.-)/([^/]+)$")
				if directory and filename then
					table.insert(proj_files, { path = directory, name = filename })
				end
			end
		end
	end

	return proj_files
end

--- Checks if a string starts with a specific prefix
--- @param str string The string to check
--- @param prefix string The prefix to look for
--- @return boolean True if str starts with prefix
function M.starts_with(str, prefix)
	if not str or not prefix then
		return false
	end
	return str:sub(1, #prefix) == prefix
end

--- Searches for a value in a table where the path starts with the given value
--- Finds the most specific (longest) matching path
--- @param tbl table Array of tables with {path: string, name: string}
--- @param value string The path to search for
--- @return boolean, table|nil True and the matching entry if found, false and nil otherwise
function M.search_value_starts_with(tbl, value)
	if not tbl or not value then
		return false, nil
	end

	local best_match = nil
	local best_match_length = 0

	for _, val in ipairs(tbl) do
		if val.path and M.starts_with(value, val.path) then
			local path_length = #val.path
			-- Keep the most specific (longest) match
			if path_length > best_match_length then
				best_match = val
				best_match_length = path_length
			end
		end
	end

	if best_match then
		return true, best_match
	end
	return false, nil
end

return M
