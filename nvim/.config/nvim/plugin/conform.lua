require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/stevearc/conform.nvim" },
  })

  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettierd", "eslint_d" },
      typescript = { "prettierd", "eslint_d" },
      javascriptreact = { "prettierd", "eslint_d" },
      typescriptreact = { "prettierd", "eslint_d" },
      vue = { "prettierd", "eslint_d" },
      html = { "prettierd" },
      css = { "prettierd" },
      php = { "php_cs_fixer" },
      python = { "ruff_format", "ruff_fix" },
      bash = { "shfmt" },
      java = { "google-java-format" },
    },
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback",
    },
  })
end)