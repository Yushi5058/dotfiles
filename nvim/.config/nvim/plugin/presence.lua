vim.pack.add({
  { src = "https://github.com/andweeb/presence.nvim" },
})

require("lazyload").on_vim_enter(function()
  vim.cmd("packadd presence.nvim")
  require("presence").setup({})
end)
