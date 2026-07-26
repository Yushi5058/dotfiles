vim.pack.add({
  { src = "https://github.com/folke/which-key.nvim" },
})
vim.cmd("packadd which-key.nvim")

require("lazyload").on_vim_enter(function()
  require("which-key").setup({})
end)