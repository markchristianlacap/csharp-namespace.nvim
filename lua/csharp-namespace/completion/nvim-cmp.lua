--- C# Namespace completion source for nvim-cmp
local namespace_src = require("csharp-namespace.source")

local source = {}

source.new = function()
	return setmetatable({}, { __index = source })
end

function source:is_available()
	return vim.bo.filetype == "cs"
end

function source:get_debug_name()
	return "csharp-namespace"
end

function source:complete(params, callback)
	local line = vim.api.nvim_get_current_line()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local col = cursor_pos[2]

	local before_cursor = line:sub(1, col)

	local after_namespace = before_cursor:match("^%s*namespace%s+([%w%.]*)$")

	if not after_namespace then
		callback({ items = {}, isIncomplete = false })
		return
	end

	local items = namespace_src.source()
	callback({ items = items, isIncomplete = false })
end

function source:resolve(completion_item, callback)
	callback(completion_item)
end

function source:execute(completion_item, callback)
	callback(completion_item)
end

local source_instance = nil

local function get_source()
	if not source_instance then
		source_instance = source.new()
	end
	return source_instance
end

return get_source()
