return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "eslint_d" },
				html = { "prettierd" },
				css = { "prettierd" },
				markdown = { "prettierd" },
				php = { "php_cs_fixer" },
				python = { "black", "autopep8" },
				c = { "clang-format" },
				cplus = { "clang-format" },
				bash = { "beautysh" },
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 10000,
				lsp_format = "fallback",
			},
		})
	end,
}
