local lspconfig = require("lspconfig")
capabilities = vim.lsp.protocol.make_client_capabilities()

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "phpactor", "tsserver", "tailwindcss", "cssls", "html", "emmet_ls" },
})
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			runtime = {
				version = "LUAJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
			completion = {
				callSnippet = "Replace",
			},
			capabilities = capabilities,
		},
	},
})
lspconfig.tsserver.setup({ capabilities = capabilities })
lspconfig.html.setup({ capabilities = capabilities })
lspconfig.intelephense.setup({ capabilities = capabilities })
lspconfig.cssls.setup({ capabilities = capabilities })
lspconfig.jsonls.setup({ capabilities = capabilities })
lspconfig.clangd.setup({ capabilities = capabilities })
lspconfig.emmet_ls.setup({ capabilities = capabilities })
lspconfig.tailwindcss.setup({ capabilities = capabilities })
