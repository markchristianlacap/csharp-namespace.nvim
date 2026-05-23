--- C# Namespace completion source for nvim-cmp
local namespace_src = require("csharp-namespace.source")

local source = {}

--- Creates a new instance of the completion source
--- @return table The source instance
source.new = function()
	return setmetatable({}, { __index = source })
end

--- Checks if the source is available for the current buffer
--- @return boolean True if the current filetype is C#
function source:is_available()
	return vim.bo.filetype == "cs"
end

--- Returns the debug name of this source
--- @return string The source name
function source:get_debug_name()
	return "csharp-namespace"
end

--- Provides completion items when typing namespace declarations
--- @param params table Completion parameters from nvim-cmp
--- @param callback function Callback to return completion items
function source:complete(params, callback)
	local line = vim.api.nvim_get_current_line()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local col = cursor_pos[2]

	local before_cursor = line:sub(1, col)
	
	-- Only trigger after "namespace " keyword
	local after_namespace = before_cursor:match("^%s*namespace%s+([%w%.]*)$")
	
	if not after_namespace then
		callback({ items = {}, isIncomplete = false })
		return
	end
	
	local items = namespace_src.source()
	callback({ items = items, isIncomplete = false })
end

--- Resolves additional information for a completion item
--- @param completion_item table The completion item to resolve
--- @param callback function Callback to return the resolved item
function source:resolve(completion_item, callback)
	callback(completion_item)
end

--- Executes an action for a completion item
--- @param completion_item table The completion item to execute
--- @param callback function Callback after execution
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

--- Sets up completefunc for C# buffers
--- @private
local function setup_completefunc()
	local group = vim.api.nvim_create_augroup("csharp_namespace_completefunc", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "cs",
		callback = function()
			vim.bo.completefunc = function(findstart, base)
				return require("csharp-namespace.completefunc").completefunc(findstart, base)
			end
		end,
	})
	if vim.bo.filetype == "cs" then
		vim.bo.completefunc = function(findstart, base)
			return require("csharp-namespace.completefunc").completefunc(findstart, base)
		end
	end
end

--- Setup function for the plugin
--- @param opts table|nil Optional configuration options
--- @return table Module exports
return {
	setup = function(opts)
		opts = opts or {}
		if opts.nvim_cmp then
			require("cmp").register_source("csharp-namespace", get_source())
		end
		if opts.completefunc then
			setup_completefunc()
		end
	end,
}
