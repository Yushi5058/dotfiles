return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "eslint", "prettier", "prettierd" },
				ruby = { "rubocop" },
				markdown = { "prettier", "prettierd" },
				css = { "prettier", "prettierd" },
				html = { "prettier", "prettierd" },
				c = { "clang-format" },
				python = { "ruff_fix", "ruff_format" },
				kotlin = { "ktfmt" },
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_fallback = true,
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
