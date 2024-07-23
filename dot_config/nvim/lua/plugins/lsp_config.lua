local lspconfig = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
local servers = {
	lua_ls = {
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
			},
		},
	},
	tsserver = {},
	html = { filetypes = { "php" } },
	gdscript = {},
	gdshader_lsp = {},
	cssls = {},
	jsonls = {},
	clangd = {},
	intelephense = {},
	emmet_ls = {},
	tailwindcss = {},
}

require("mason").setup()
local ensure_installed = vim.tbl_keys(servers or {})
local filtered_servers = vim.tbl_filter(function(server)
	return server ~= "gdscript" and server ~= "gdshader_lsp"
end, ensure_installed)
vim.list_extend(filtered_servers, {
	"stylua", -- Used to format Lua code
	"eslint_d", -- format js and ts
	"prettierd", -- format css, html, markdown
	"php-cs-fixer", -- format php
})
require("mason-tool-installer").setup({ ensure_installed = filtered_servers })

require("mason-lspconfig").setup({
	handlers = {
		function(server_name)
			local server = servers[server_name] or {}
			-- This handles overriding only values explicitly passed
			-- by the server configuration above. Useful when disabling
			-- certain features of an LSP (for example, turning off formatting for tsserver)
			server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			lspconfig[server_name].setup(server)
		end,
	},
})
