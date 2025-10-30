--- Source module for generating C# namespace completions
local utils = require("csharp-namespace.utils")

local M = {}

--- Cache for project files to avoid repeated file system scans
local project_cache = nil
local cache_time = 0
local CACHE_DURATION = 5000 -- 5 seconds in milliseconds

--- Clears the project cache
function M.clear_cache()
	project_cache = nil
	cache_time = 0
end

--- Gets cached project files or scans for new ones
--- @return table Array of project files
local function get_projects()
	local current_time = vim.loop.now()
	
	-- Return cached results if still valid
	if project_cache and (current_time - cache_time) < CACHE_DURATION then
		return project_cache
	end
	
	-- Scan for project files and cache the results
	project_cache = utils.find_csproj_files()
	cache_time = current_time
	
	return project_cache
end

--- Generates namespace completion items based on current file location
--- @return table Array of completion items
function M.source()
	local items = {}
	
	-- Get current file directory
	local current_file = vim.fn.expand("%:p")
	if not current_file or current_file == "" then
		return items
	end
	
	local current_dir = vim.fn.expand("%:p:h")
	if not current_dir or current_dir == "" then
		return items
	end
	
	-- Find matching project
	local projects = get_projects()
	local success, project = utils.search_value_starts_with(projects, current_dir)
	
	if success and project then
		-- Build namespace from project name and relative path
		local namespace = project.name:gsub("%.csproj$", "")
		local relative_path = utils.remove_start(current_dir, project.path)
		
		if relative_path and relative_path ~= "" then
			-- Convert path separators to namespace separators
			local namespace_suffix = relative_path:gsub("^[/\\]+", ""):gsub("[/\\]+", ".")
			if namespace_suffix ~= "" then
				namespace = namespace .. "." .. namespace_suffix
			end
		end
		
		table.insert(items, {
			label = namespace,
			kind = vim.lsp.protocol.CompletionItemKind.Module or 9,
			documentation = "Namespace based on project structure",
		})
	end
	
	return items
end

return M
