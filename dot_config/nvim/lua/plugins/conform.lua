require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "eslint" },
				html = { "prettier" },
				css = { "prettier" },
				php = { "php_cs_fixer" },
			},
		})
		-- format on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})
