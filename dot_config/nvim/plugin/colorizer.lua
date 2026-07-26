vim.pack.add({
  { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
})
vim.cmd("packadd nvim-highlight-colors")

require("lazyload").on_vim_enter(function()
  require("nvim-highlight-colors").setup({})
end)