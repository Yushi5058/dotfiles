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
                c = { "clang-format" },
                c++ = { "clang-format"},
                python = { "autopep8", "black"},

			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 10000,
				lsp_format = "fallback",
			},
		})
	end,
}
