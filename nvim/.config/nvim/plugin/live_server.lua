require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/barrett-ruth/live-server.nvim" },
  })
end)