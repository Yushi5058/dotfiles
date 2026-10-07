return {
	"williamboman/mason.nvim",
	"neovim/nvim-lspconfig",
	config = function()
		local lspconfig = require("lspconfig")

		lspconfig.bashls.setup({
			cmd = { "bash-language-server", "start" },
			filetypes = { "sh", "bash" },
			root_markers = { ".git" },
		})

		lspconfig.clangd.setup({
			cmd = { "clangd" },
			filetypes = { "c", "cpp", "objc", "objcpp" },
			root_markers = { "compile_commands.json", ".git" },
		})

		lspconfig.cssls.setup({
			cmd = { "vscode-css-language-server", "--stdio" },
			filetypes = { "css", "scss", "less" },
			root_markers = { "package.json", ".git" },
		})

		lspconfig.html.setup({
			cmd = { "vscode-html-language-server", "--stdio" },
			filetypes = { "html" },
			root_markers = { "package.json", ".git" },
		})

		lspconfig.jsonls.setup({
			cmd = { "vscode-json-language-server", "--stdio" },
			filetypes = { "json", "jsonc" },
			root_markers = { "package.json", ".git" },
		})

		lspconfig.marksman.setup({
			cmd = { "marksman", "server" },
			filetypes = { "markdown" },
			root_markers = { ".marksman.toml", ".git" },
		})

		lspconfig.pyright.setup({
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
		})

		lspconfig.ruff.setup({
			cmd = { "ruff", "server" },
			filetypes = { "python" },
			root_markers = { "pyproject.toml", "ruff.toml", ".git" },
		})

		lspconfig.sqlls.setup({
			cmd = { "sql-language-server", "up", "--method", "stdio" },
			filetypes = { "sql" },
			root_markers = { ".git" },
		})

		lspconfig.tailwindcss.setup({
			cmd = { "tailwindcss-language-server", "--stdio" },
			filetypes = {
				"html",
				"css",
				"scss",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
			},
			root_markers = { "tailwind.config.js", "tailwind.config.ts", "package.json", ".git" },
		})

		lspconfig.ts_ls.setup({
			cmd = { "typescript-language-server", "--stdio" },
			filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
			root_markers = { "tsconfig.json", "package.json", ".git" },
		})

		lspconfig.volar.setup({
			cmd = { "vue-language-server", "--stdio" },
			filetypes = { "vue" },
			root_markers = { "package.json", "tsconfig.json", ".git" },
		})

		lspconfig.omnisharp.setup({
			cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
			filetypes = { "cs", "csharp", "vb" },
			root_markers = { "sln", "csproj", ".git" },
			enable_editorconfig_support = true,
			enable_roslyn_analyzers = true,
			organize_imports_on_format = true,
			enable_import_completion = true,
		})
		lspconfig.eslint.setup({
			cmd = { "vscode-eslint-language-server", "--stdio" },
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
			root_markers = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", "package.json", ".git" },
			on_attach = function(client)
				client.server_capabilities.documentFormattingProvider = false
			end,
		})

		lspconfig.twiggy_language_server.setup({
			cmd = { "twiggy-language-server", "--stdio" },
			filetypes = { "twig" },
			root_markers = { "composer.json", ".git" },
			settings = {
				twiggy = {
					framework = "symfony",
					phpExecutable = "/usr/bin/php",
					symfonyConsolePath = "bin/console",
					diagnostics = { twigCsFixer = true },
				},
			},
		})

		lspconfig.phpactor.setup({
			cmd = { "phpactor", "language-server" },
			filetypes = { "php" },
			root_markers = { ".git", "composer.json", ".phpactor.json", ".phpactor.yml" },
			workspace_required = true,
			init_options = { ["symfony.enabled"] = true },
		})

		lspconfig.emmet_language_server.setup({
			cmd = { "emmet-language-server", "--stdio" },
			filetypes = {
				"astro",
				"css",
				"eruby",
				"html",
				"htmlangular",
				"htmldjango",
				"javascriptreact",
				"less",
				"pug",
				"sass",
				"scss",
				"svelte",
				"templ",
				"typescriptreact",
				"vue",
				"php",
				"twig",
			},
			root_markers = { ".git" },
		})

		vim.lsp.enable({
			"bashls",
			"clangd",
			"cssls",
			"html",
			"jsonls",
			"marksman",
			"pyright",
			"ruff",
			"sqlls",
			"tailwindcss",
			"ts_ls",
			"volar",
			"eslint",
			"twiggy_language_server",
			"phpactor",
			"emmet_language_server",
		})
	end,
}
