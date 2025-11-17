return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			-- list of servers for mason to install
			ensure_installed = {
				"lua_ls",
				"bashls",
				"clangd",
				"cssls",
				"djls",
				"emmet_ls",
				"html",
				"intelephense",
				"marksman",
				"postgres_lsp",
				"pyright",
				"tailwindcss",
				"ts_ls",
				"vue_ls",
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
		opts = {
			ensure_installed = {
				"prettierd", -- prettier formatter
				"stylua", -- lua formatter
				"ruff", -- python formatter
				"pylint",
				"eslint_d",
			},
		},
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
}
