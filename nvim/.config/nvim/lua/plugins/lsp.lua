return {
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			{ "williamboman/mason.nvim" },
			"neovim/nvim-lspconfig",
			"nvim-mini/mini.extra",
		},
		keys = {
			{
				"gd",
				function()
					require("mini.extra").pickers.lsp({ scope = "definition" })
				end,
				desc = "Definition",
			},
			{
				"gr",
				function()
					require("mini.extra").pickers.lsp({ scope = "references" })
				end,
				desc = "References",
			},
			{
				"gi",
				function()
					require("mini.extra").pickers.lsp({ scope = "implementation" })
				end,
				desc = "Implementation",
			},
			{
				"gt",
				function()
					require("mini.extra").pickers.lsp({ scope = "type_definition" })
				end,
				desc = "Type Definition",
			},
			{
				"gs",
				function()
					require("mini.extra").pickers.lsp({ scope = "document_symbol" })
				end,
				desc = "Symbols",
			},

			{ "ga", vim.lsp.buf.code_action, desc = "Action", mode = { "n", "x" } },
			{ "gn", vim.lsp.buf.rename, desc = "Rename" },
		},
		config = function()
			-- 1. Setup Mason first
			require("mason").setup()

			-- 2. Import lspconfig to populate the server database
			-- This prevents the "not a valid entry" errors
			local lspconfig = require("lspconfig")

			-- 3. Define custom configurations using the NEW native API
			-- This replaces the old 'handlers' block
			vim.lsp.config("eslint", {
				on_attach = function(client)
					client.server_capabilities.documentFormattingProvider = false
				end,
			})

			-- 4. Setup mason-lspconfig with automatic_enable
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"clangd",
					"cssls",
					"emmet_language_server",
					"djlsp",
					"eslint",
					"html",
					"jsonls",
					"marksman",
					"postgres_lsp",
					"pyright",
					"phpactor",
					"ruff",
					"tailwindcss",
					"ts_ls",
					"twiggy_language_server",
					"vue_ls",
				},
				-- This automatically calls vim.lsp.enable() for installed servers
				automatic_enable = true,
			})
		end,
	},

	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
		keys = {
			{
				"co",
				function()
					require("jdtls").organize_imports()
				end,
				desc = "Organize Imports",
			},
			{
				"cv",
				function()
					require("jdtls").extract_variable()
				end,
				desc = "Extract Variable",
			},
			{
				"cv",
				function()
					require("jdtls").extract_variable(true)
				end,
				mode = "v",
				desc = "Extract Variable",
			},
			{
				"cc",
				function()
					require("jdtls").extract_constant()
				end,
				desc = "Extract Constant",
			},
			{
				"cc",
				function()
					require("jdtls").extract_constant(true)
				end,
				mode = "v",
				desc = "Extract Constant",
			},
			{
				"cf",
				function()
					require("jdtls").extract_method(true)
				end,
				mode = "v",
				desc = "Extract Method",
			},
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"prettierd",
				"eslint_d",
				"stylua",
				"shfmt",
				"ruff",
				"php-cs-fixer",
			},
			run_on_start = true,
		},
	},

	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		config = function()
			require("tiny-inline-diagnostic").setup({ preset = "ghost" })
			vim.diagnostic.config({ virtual_text = false })
		end,
	},
}
