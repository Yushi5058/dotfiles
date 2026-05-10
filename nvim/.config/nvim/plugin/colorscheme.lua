require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
  })

  vim.cmd("colorscheme rose-pine-moon")
end)