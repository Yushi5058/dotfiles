require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  })

  require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    sync_install = false,
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  })
end)