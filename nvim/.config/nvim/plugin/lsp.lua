require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/williamboman/mason.nvim" },
  })
  vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
  })

  vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
  require("mason").setup()

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
      "html", "css", "scss",
      "javascript", "javascriptreact",
      "typescript", "typescriptreact",
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
        framework          = "symfony",
        phpExecutable      = "/usr/bin/php",
        symfonyConsolePath = "bin/console",
        diagnostics        = { twigCsFixer = true },
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
      "astro", "css", "eruby", "html", "htmlangular", "htmldjango",
      "javascriptreact", "less", "pug", "sass", "scss", "svelte",
      "templ", "typescriptreact", "vue", "php", "twig",
    },
    root_markers = { ".git" },
  })

  vim.lsp.enable({
    "bashls", "clangd", "cssls", "html", "jsonls", "marksman",
    "pyright", "ruff", "sqlls", "tailwindcss", "ts_ls", "volar",
    "eslint", "twiggy_language_server", "phpactor", "emmet_language_server",
  })
end)