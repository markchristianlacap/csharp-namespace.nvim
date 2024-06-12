local namespace_src = require("csharp-namespace.source")
local source = {}
local opts = {
	ignore = {},
	only_semantic_versions = false,
	only_latest_version = false,
}

source.new = function()
	local self = setmetatable({}, { __index = source })
	return self
end

function source:is_available()
	local filetype = vim.bo.filetype
	return filetype == "cs"
end

function source:get_debug_name()
	return "csharp-namespace"
end

function source:complete(params, callback)
	local line = vim.api.nvim_get_current_line()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local col = cursor_pos[2]

	local before_cursor = string.sub(line, 1, col)
	local after_namespace = before_cursor:match("^%s*namespace%s+([%w%.]*)$")
	if not after_namespace then
		callback({ items = {}, isIncomplete = false })
	else
		local items = namespace_src.source()
		callback({ items = items, isIncomplete = false })
	end
end

function source:resolve(completion_item, callback)
	callback(completion_item)
end

function source:execute(completion_item, callback)
	callback(completion_item)
end

require("cmp").register_source("csharp-namespace", source.new())

return {
	setup = function(_opts)
		if _opts then
			opts = vim.tbl_deep_extend("force", opts, _opts)
		end
	end,
}
