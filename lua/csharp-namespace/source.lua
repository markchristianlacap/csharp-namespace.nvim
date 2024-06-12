local utils = require("csharp-namespace.utils")
local M = {}
function M.source()
	local source = {}
	local projects = utils.find_csproj_files()
	local current_dir = vim.fn.expand("%:p:h")
	local success, key = utils.search_value_starts_with(projects, current_dir)
	local namespace = ""
	if success and key ~= nil then
		namespace = namespace .. key.name:gsub(".csproj", "")
		namespace = namespace .. utils.remove_start(current_dir, key.path):gsub("/", ".")
		table.insert(source, { label = namespace })
	end
	return source
end

return M
