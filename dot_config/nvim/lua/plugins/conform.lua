return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier", "eslint" },
				ruby = { "rubocop", "rubyfmt" },
			},
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })

				require("conform").setup({
					format_on_save = {
						-- These options will be passed to conform.format()
						timeout_ms = 500,
						lsp_fallback = true,
					},
				})
			end,
		})
	end,
}
