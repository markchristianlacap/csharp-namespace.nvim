--- Entry point for csharp-namespace.nvim

return {
	setup = function(opts)
		opts = opts or {}
		if opts.nvim_cmp then
			require("cmp").register_source("csharp-namespace", require("csharp-namespace.completion.nvim-cmp"))
		end
		if opts.completefunc then
			local group = vim.api.nvim_create_augroup("csharp_namespace_completefunc", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				pattern = "cs",
				callback = function()
					vim.bo.completefunc = function(findstart, base)
						return require("csharp-namespace.completion.completefunc").completefunc(findstart, base)
					end
				end,
			})
			if vim.bo.filetype == "cs" then
				vim.bo.completefunc = function(findstart, base)
					return require("csharp-namespace.completion.completefunc").completefunc(findstart, base)
				end
			end
		end
	end,
}
