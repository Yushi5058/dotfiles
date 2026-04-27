return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"nvim-mini/mini.extra",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason").setup()

			-- 1. Install all tools natively via mason-tool-installer
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- LSPs
					"bash-language-server",
					"clangd",
					"css-lsp",
					"emmet-language-server",
					"eslint-lsp",
					"html-lsp",
					"json-lsp",
					"marksman",
					"sqlls",
					"pyright",
					"phpactor",
					"ruff",
					"tailwindcss-language-server",
					"typescript-language-server",
					"vue-language-server",

					-- Formatters & Linters
					"prettierd",
					"eslint_d",
					"stylua",
					"shfmt",
					"php-cs-fixer",
				},
			})

			-- 2. Define Custom Server Configurations (Neovim 0.12 API)

			-- ESLINT
			vim.lsp.config["eslint"] = {
				cmd = { "vscode-eslint-language-server", "--stdio" },
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
				root_markers = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", "package.json", ".git" },
				on_attach = function(client)
					client.server_capabilities.documentFormattingProvider = false
				end,
			}
			vim.lsp.enable("eslint")

			-- PYRIGHT
			vim.lsp.config["pyright"] = {
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
							typeCheckingMode = "basic",
						},
					},
				},
			}
			vim.lsp.enable("pyright")

			-- 3. Enable Remaining Standard Servers Natively
			local default_servers = {
				bashls = { cmd = { "bash-language-server", "start" }, filetypes = { "sh" }, root_markers = { ".git" } },
				clangd = {
					cmd = { "clangd" },
					filetypes = { "c", "cpp", "objc", "objcpp" },
					root_markers = { "compile_commands.json", ".git" },
				},
				cssls = {
					cmd = { "vscode-css-language-server", "--stdio" },
					filetypes = { "css", "scss", "less" },
					root_markers = { "package.json", ".git" },
				},
				html = {
					cmd = { "vscode-html-language-server", "--stdio" },
					filetypes = { "html" },
					root_markers = { "package.json", ".git" },
				},
				ts_ls = {
					cmd = { "typescript-language-server", "--stdio" },
					filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
					root_markers = { "tsconfig.json", "package.json", ".git" },
				},
			}

			for server, server_config in pairs(default_servers) do
				vim.lsp.config[server] = server_config
				vim.lsp.enable(server)
			end
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
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		config = function()
			require("tiny-inline-diagnostic").setup({ preset = "ghost" })
			vim.diagnostic.config({ virtual_text = false })
		end,
	},
}
