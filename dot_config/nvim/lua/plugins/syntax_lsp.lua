return function()
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
              disable = { "missing-fields" },
            },
          },
        },
        tsserver = {},
        solargraph = {},
        html = { "eruby", "erb" },
        cssls = {},
        tailwindcss = {},
        jsonls = {},
        clangd = {},
        emmet_ls = {},
      }

      require("mason").setup()


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
        },
      })
    end
