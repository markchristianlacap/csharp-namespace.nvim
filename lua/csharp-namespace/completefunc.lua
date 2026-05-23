--- C# Namespace completion source for Vim's completefunc
local namespace_src = require("csharp-namespace.source")

local M = {}

--- Completefunc for C# namespace completions
--- Called by Vim's insert-mode completion (<C-x><C-u>)
--- @param findstart number 1 to find start column, 0 to return completions
--- @param base string The text from start column to cursor
--- @return integer|table Column number or completion dictionary
function M.completefunc(findstart, base)
	if findstart == 1 then
		local line = vim.api.nvim_get_current_line()
		local col = vim.api.nvim_win_get_cursor(0)[2]

		local before_cursor = line:sub(1, col)
		local s, e = before_cursor:find("^%s*namespace%s+")
		if not s then
			return -2
		end
		return e + 1
	end

	local items = namespace_src.source()
	local words = {}
	for _, item in ipairs(items) do
		if item.label:lower():find(base:lower(), 1, true) == 1 then
			table.insert(words, item.label)
		end
	end
	return { words = words }
end

return M
