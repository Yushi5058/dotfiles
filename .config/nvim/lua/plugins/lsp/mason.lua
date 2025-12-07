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
}
