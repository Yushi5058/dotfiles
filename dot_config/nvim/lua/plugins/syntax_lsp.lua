return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		opts = {
			inlay_hints = {
				enabled = false,
			},
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
								"on_attach",
							},
							-- disable = { 'missing-fields' } },
						},
					},
				},
				tsserver = {},
				solargraph = {},
				html = { "eruby", "erb" },
				cssls = {},
				tailwindcss = {},
				jsonls = {},
				bashls = {},
				clangd = {},
				emmet_ls = {},
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
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"javascript",
					"typescript",
					"c",
					"lua",
					"vimdoc",
					"vim",
					"ruby",
					"html",
					"css",
					"json",
				},
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
					disable = function()
						-- check if 'filetype' option includes 'chezmoitmpl'
						if string.find(vim.bo.filetype, "chezmoitmpl") then
							return true
						end
					end,
				},
				indent = { enable = true },
			})
		end,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({
				enable_tailwind = true,
			})
		end,
	},
}
