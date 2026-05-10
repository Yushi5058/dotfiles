require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
  })

  require("nvim-highlight-colors").setup({})
end)