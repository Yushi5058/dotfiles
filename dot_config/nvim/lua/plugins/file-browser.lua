return 
{
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
require("telescope").setup {
  extensions = {
    file_browser = {
      hijack_netrw = true,
         },
  },
}



vim.keymap.set("n","<space>pv",":Telescope file_browser path=%:p:h select_buffer=true<CR>",{ noremap = true }
)

end,
}

