return {
  "stevearc/conform.nvim",
  opts = {
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
      rust = { "rustfmt" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback"
    },
    formatters = {
      stylua = {
        condition = function(_, ctx)
          return vim.fs.find({ "stylua.toml", ".stylua.toml" }, {
            path = ctx.filename, upward = true, stop = vim.uv.os_homedir()
          })[1] ~= nil
        end,
      },
      prettierd = {
        condition = function(_, ctx)
          return vim.fs.find({
            ".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.cjs", ".prettierrc.mjs",
            "prettier.config.js", "prettier.config.cjs", "prettier.config.mjs"
          }, { path = ctx.filename, upward = true, stop = vim.uv.os_homedir() })[1] ~= nil
        end,
      },
      eslint_d = {
        condition = function(_, ctx)
          return vim.fs.find({ ".eslintrc", ".eslintrc.js", ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml" }, {
            path = ctx.filename, upward = true, stop = vim.uv.os_homedir()
          })[1] ~= nil
        end,
      },
      php_cs_fixer = {
        condition = function(_, ctx)
          return vim.fs.find({ ".php-cs-fixer.php", ".php-cs-fixer.dist.php", "php-cs-fixer.php" }, {
            path = ctx.filename, upward = true, stop = vim.uv.os_homedir()
          })[1] ~= nil
        end,
      },
      ruff_format = {
        condition = function(_, ctx)
          return vim.fs.find({ "pyproject.toml", "ruff.toml", ".ruff.toml" }, {
            path = ctx.filename, upward = true, stop = vim.uv.os_homedir()
          })[1] ~= nil
        end,
      },
      ruff_fix = {
        condition = function(_, ctx)
          return vim.fs.find({ "pyproject.toml", "ruff.toml", ".ruff.toml" }, {
            path = ctx.filename, upward = true, stop = vim.uv.os_homedir()
          })[1] ~= nil
        end,
      },
      shfmt = {
        condition = function(_, ctx)
          return vim.fs.find({ ".shfmt", ".editorconfig" }, {
            path = ctx.filename, upward = true, stop = vim.uv.os_homedir()
          })[1] ~= nil
        end,
      },
      google_java_format = {
        condition = function(_, ctx)
          return vim.fs.find({ "pom.xml", "build.gradle", "build.gradle.kts" }, {
            path = ctx.filename, upward = true, stop = vim.uv.os_homedir()
          })[1] ~= nil
        end,
      },
      rustfmt = {
        condition = function(_, ctx)
          return vim.fs.find({ "rustfmt.toml", ".rustfmt.toml" }, {
            path = ctx.filename, upward = true, stop = vim.uv.os_homedir()
          })[1] ~= nil
        end,
      },
    },
  },
}