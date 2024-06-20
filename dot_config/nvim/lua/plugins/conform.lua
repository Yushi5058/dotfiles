return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "biome" },
				ruby = { "rubocop" },
				markdown = { "prettier", "prettierd" },
				css = { "biome", "prettier", "prettierd" },
				html = { "prettier", "prettierd" },
				c = { "clang-format" },
				sh = { "shfmt" },
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 10000, -- important for rubocop
				lsp_fallback = true,
			},
			format_after_save = {
				lsp_format = "fallback",
			},
			formatters = {
				rubocop = {
					args = { "-a", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" },
				},
			},
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})
	end,
}
