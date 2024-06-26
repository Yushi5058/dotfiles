return {
     "tpope/vim-fugitive",
     config = function()
         vim.cmd("set statusline+=%{FugitiveStatusline()}")
     end
}
