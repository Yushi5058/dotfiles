vim.pack.add({
  { src = "https://github.com/lervag/vimtex" },
})

require("lazyload").on_vim_enter(function()
  vim.cmd("packadd vimtex")

  vim.g.vimtex_view_method = "zathura"
  vim.g.vimtex_compiler_method = "latexmk"
end)
