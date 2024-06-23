local lspconfig = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
local servers = {
  "lua_ls",
  "tsserver",
  "solargraph",
  "html",
  "cssls",
  "jsonls",
  "clangd",
  "emmet_ls"
}

require("mason").setup()
for _, server in ipairs(servers) do
  lspconfig[server].setup {
    capabilities = capabilities
  }
end

-- add html lsp to erb
lspconfig.html.setup {
  filetypes = { "erb", "eruby" }
}

-- lua_ls lsp configuration
lspconfig.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  }
}


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
