return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	keys = {
		{ "n", "K", vim.lsp.buf.hover, {} },
		{ "n", "<leader>gd", vim.lsp.buf.definition, {} },
		{ "n", "<leader>gr", vim.lsp.buf.references, {} },
		{ "n", "<leader>ca", vim.lsp.buf.code_action, {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = vim.lsp.protocol.make_client_capabilities()

		local servers = {
			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
					-- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
					diagnostics = {
						globals = {
							"vim",
						},
						-- disable = { 'missing-fields' } },
					},
				},
			},
			clangd = {},
			tsserver = {},
			ruby_ls = {},
			html = {},
			cssls = {},
			tailwindcss = {},
			jsonls = {},
			bashls = {},
		}

		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers),
		})

		require("mason-lspconfig").setup_handlers({
			-- This is a default handler that will be called for each installed server
			-- (also for new servers that are installed during a session)
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = servers[server_name],
					filetypes = (servers[server_name] or {}).filetypes,
				})
			end,
		})
	end,
}
