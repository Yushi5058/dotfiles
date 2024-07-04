local lspconfig = require("lspconfig")
capabilities = vim.lsp.protocol.make_client_capabilities()

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
lspconfig.ruby_lsp.setup({ capabilities = capabilities })
lspconfig.html.setup({ capabilities = capabilities })
lspconfig.phpactor.setup({ capabilities = capabilities })
lspconfig.cssls.setup({ capabilities = capabilities })
lspconfig.jsonls.setup({ capabilities = capabilities })
lspconfig.clangd.setup({ capabilities = capabilities })
lspconfig.emmet_ls.setup({ capabilities = capabilities })
lspconfig.tailwindcss.setup({ capabilities = capabilities })
