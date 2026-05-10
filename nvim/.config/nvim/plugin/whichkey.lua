require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/folke/which-key.nvim" },
  })

  require("which-key").setup({})
end)