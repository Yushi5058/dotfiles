return {
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local keymap = vim.keymap
      keymap.set("n", "<space>pv", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>", { noremap = true })
    end,
  },
}
