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
				ruby_lsp = {},
				html = { "eruby", "erb" },
				cssls = {},
				tailwindcss = {},
				jsonls = {},
				bashls = {},
				clangd = {},
				emmet_ls = {},
				rubocop = {},
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
					"bash",
					"ruby",
					"markdown",
					"markdown_inline",
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
		"alker0/chezmoi.vim",
		lazy = false,
		init = function()
			-- This option is required.
			vim.g["chezmoi#use_tmp_buffer"] = true
			-- add other options here if needed.
		end,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({
				enable_tailwind = true,
			})
		end,
		keys = {
			{ "<c-h>", mode = { "n" }, "<cmd>HighlightColors Toggle<cr>" },
		},
	},
	{
		"stevearc/aerial.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader>ta", mode = { "n" }, "<cmd>AerialToggle! right<cr>" },
		},
		config = function()
			require("aerial").setup({
				-- optionally use on_attach to set keymaps when aerial has attached to a buffer
				on_attach = function(bufnr)
					-- Jump forwards/backwards with '{' and '}'
					vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,
			})
		end,
	},
}
