---@class blink-cmp-rg.Options
---@field prefix_min_len? number
---@field get_command? fun(context: blink.cmp.Context, prefix: string): string[]
---@field get_prefix? fun(context: blink.cmp.Context): string[]
local namespace_src = require("csharp-namespace.source")
local namespace = {}

---@param opts blink-cmp-rg.Options
function namespace.new(opts)
  opts = opts or {}
  return setmetatable({}, { __index = namespace })
end

function namespace:get_completions(context, resolve)
  local line = vim.api.nvim_get_current_line()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local col = cursor_pos[2]

  local before_cursor = string.sub(line, 1, col)
  local after_namespace = before_cursor:match("^%s*namespace%s+([%w%.]*)$")
  if not after_namespace then
    resolve()
    return
  end
  local items = namespace_src.source()
  resolve({
    is_incomplete_forward = false, is_incomplete_backward = false, items = items
  })
end

return namespace
