return {
	{
		"williamboman/mason.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function(_, opts)
			require("mason").setup(opts)

			-- Mason only manages packages it installs itself; system binaries
			-- are invisible to it. Keep this list in sync with the servers
			-- enabled in lsp.lua — missing ones install async on startup.
			local ensure = {
				"bash-language-server",
				"clangd",
				"css-lsp",
				"emmet-language-server",
				"eslint-lsp",
				"html-lsp",
				"json-lsp",
				"lua-language-server",
				"marksman",
				"omnisharp",
				"phpactor",
				"pyright",
				"ruff",
				"sqlls",
				"tailwindcss-language-server",
				"twiggy-language-server",
				"typescript-language-server",
				"vue-language-server",
			}

			local registry_ok, registry = pcall(require, "mason-registry")
			if not registry_ok then
				return
			end
			for _, name in ipairs(ensure) do
				local pkg = registry.get_package(name)
				if pkg and not pkg:is_installed() then
					vim.notify("Mason: installing " .. name, vim.log.levels.INFO)
					pkg:install()
				end
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			-- nvim 0.12 ships a builtin :lsp command, so nvim-lspconfig skips
			-- registering :LspInfo — restore it as an alias.
			if vim.fn.exists(":LspInfo") == 0 then
				vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", {
					desc = "Alias to :checkhealth vim.lsp",
				})
			end
			vim.lsp.config("bashls", {
				cmd = { "bash-language-server", "start" },
				filetypes = { "sh", "bash" },
				root_markers = { ".git" },
			})

			vim.lsp.config("clangd", {
				cmd = { "clangd" },
				filetypes = { "c", "cpp", "objc", "objcpp" },
				root_markers = { "compile_commands.json", ".git" },
			})

			vim.lsp.config("cssls", {
				cmd = { "vscode-css-language-server", "--stdio" },
				filetypes = { "css", "scss", "less" },
				root_markers = { "package.json", ".git" },
			})

			vim.lsp.config("html", {
				cmd = { "vscode-html-language-server", "--stdio" },
				filetypes = { "html" },
				root_markers = { "package.json", ".git" },
			})

			vim.lsp.config("lua_ls", {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = { enable = false },
					},
				},
			})

			vim.lsp.config("jsonls", {
				cmd = { "vscode-json-language-server", "--stdio" },
				filetypes = { "json", "jsonc" },
				root_markers = { "package.json", ".git" },
			})

			vim.lsp.config("marksman", {
				cmd = { "marksman", "server" },
				filetypes = { "markdown" },
				root_markers = { ".marksman.toml", ".git" },
			})

			vim.lsp.config("pyright", {
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

			vim.lsp.config("ruff", {
				cmd = { "ruff", "server" },
				filetypes = { "python" },
				root_markers = { "pyproject.toml", "ruff.toml", ".git" },
			})

			vim.lsp.config("sqlls", {
				cmd = { "sql-language-server", "up", "--method", "stdio" },
				filetypes = { "sql" },
				root_markers = { ".git" },
			})

			vim.lsp.config("tailwindcss", {
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

			vim.lsp.config("ts_ls", {
				cmd = { "typescript-language-server", "--stdio" },
				filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
				root_markers = { "tsconfig.json", "package.json", ".git" },
			})

			vim.lsp.config("volar", {
				cmd = { "vue-language-server", "--stdio" },
				filetypes = { "vue" },
				root_markers = { "package.json", "tsconfig.json", ".git" },
			})

			vim.lsp.config("omnisharp", {
				cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
				filetypes = { "cs", "csharp", "vb" },
				root_markers = { "*.sln", "*.csproj", ".git" },
				init_options = {
					enable_editorconfig_support = true,
					enable_roslyn_analyzers = true,
					organize_imports_on_format = true,
					enable_import_completion = true,
				},
			})

			vim.lsp.config("eslint", {
				cmd = { "vscode-eslint-language-server", "--stdio" },
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
				root_markers = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", "package.json", ".git" },
				on_attach = function(client)
					client.server_capabilities.documentFormattingProvider = false
				end,
			})

			vim.lsp.config("twiggy_language_server", {
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

			vim.lsp.config("phpactor", {
				cmd = { "phpactor", "language-server" },
				filetypes = { "php" },
				root_markers = { ".git", "composer.json", ".phpactor.json", ".phpactor.yml" },
				workspace_required = true,
				init_options = { ["symfony.enabled"] = true },
			})

			vim.lsp.config("emmet_language_server", {
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
				"lua_ls",
				"marksman",
				"omnisharp",
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
	},
}
