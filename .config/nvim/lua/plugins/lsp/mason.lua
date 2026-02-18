return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			-- list of servers for mason to install
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
			handlers = {
				-- Standard handler for most servers
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,

				-- Special handler for ESLint to prevent it from messing up formatting
				["eslint"] = function()
					require("lspconfig").eslint.setup({
						on_attach = function(client, bufnr)
							-- DISABLE formatting capability so Conform handles it instead
							client.server_capabilities.documentFormattingProvider = false
						end,
					})
				end,
			},
		},
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig",
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				-- Web (JS/TS/HTML/CSS)
				"prettierd", -- Faster wrapper for prettier
				"eslint_d", -- Faster wrapper for eslint

				-- Lua
				"stylua", -- The standard for Lua formatting

				-- Shell Scripting
				"shfmt", -- Formats bash/zsh scripts
				-- "shellcheck", -- (Optional) If you want a linter for bash logic

				-- Python
				-- Note: If you have "ruff" in mason-lspconfig, you technically
				-- have the binary, but adding it here ensures updates.
				"ruff",
				-- Php
				"php-cs-fixer",
			},

			-- Auto-install the above immediately
			run_on_start = true,
		},
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup({
				preset = "ghost",
			})
			vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
		end,
	},
	{
		"mfussenegger/nvim-jdtls",
		dependencies = {
			"williamboman/mason.nvim",
		},
		ft = { "java" }, -- Only load the plugin code when you open a Java file
		config = function()
			vim.lsp.enable("jdtls")
			local jdtls = require("jdtls")

			-- Helper function for shorter code
			local map = vim.keymap.set

			-- 1. Organize Imports
			map("n", "<A-o>", jdtls.organize_imports, { desc = "Organize Imports" })

			-- 2. Extract Variable
			map("n", "crv", jdtls.extract_variable, { desc = "Extract Variable" })
			map("v", "crv", function()
				jdtls.extract_variable(true)
			end, { desc = "Extract Variable (Visual)" })

			-- 3. Extract Constant
			map("n", "crc", jdtls.extract_constant, { desc = "Extract Constant" })
			map("v", "crc", function()
				jdtls.extract_constant(true)
			end, { desc = "Extract Constant (Visual)" })

			-- 4. Extract Method (Visual only)
			map("v", "crm", function()
				jdtls.extract_method(true)
			end, { desc = "Extract Method" })
		end,
	},
}
