vim.pack.add({
  { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
})
vim.cmd("packadd tiny-inline-diagnostic.nvim")

require("lazyload").on_vim_enter(function()
  require("tiny-inline-diagnostic").setup({ preset = "ghost" })
end)