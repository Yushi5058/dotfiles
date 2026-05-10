require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
  })

  require("tiny-inline-diagnostic").setup({ preset = "ghost" })
end)