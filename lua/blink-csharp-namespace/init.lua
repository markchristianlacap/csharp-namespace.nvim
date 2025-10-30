--- C# Namespace completion source for blink.cmp
local namespace_src = require("csharp-namespace.source")

---@class blink-csharp-namespace.Options
---@field prefix_min_len? number Minimum prefix length to trigger completion

local namespace = {}

--- Creates a new instance of the blink.cmp source
--- @param opts blink-csharp-namespace.Options|nil Optional configuration
--- @return table The source instance
function namespace.new(opts)
	opts = opts or {}
	return setmetatable({}, { __index = namespace })
end

--- Provides completions for blink.cmp
--- @param context table The completion context from blink.cmp
--- @param resolve function Callback to return completion items
function namespace:get_completions(context, resolve)
	local line = vim.api.nvim_get_current_line()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local col = cursor_pos[2]

	local before_cursor = line:sub(1, col)
	
	-- Only trigger after "namespace " keyword
	local after_namespace = before_cursor:match("^%s*namespace%s+([%w%.]*)$")
	
	if not after_namespace then
		resolve()
		return
	end
	
	local items = namespace_src.source()
	resolve({
		is_incomplete_forward = false,
		is_incomplete_backward = false,
		items = items,
	})
end

return namespace
