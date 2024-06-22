return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({})
      vim.keymap.set("n", "<leader>ff", "<cmd>lua require('fzf-lua').files(cwd='~/<folder>')<CR>", { silent = true })
      vim.keymap.set("n", "<leader>fg", "<cmd>lua require('fzf-lua').live_grep()<cr>")
      vim.keymap.set("n", "<leader>fh", "<cmd>lua require('fzf-lua').helptags()<cr>")
      vim.keymap.set("n", "<leader>fd", "<cmd>lua require('fzf-lua').diagnostics_workspace()<cr>")
      vim.keymap.set("n", "<leader>fq", "<cmd>lua require('fzf-lua').quickfix()<cr>")
      vim.keymap.set("n", "<leader>fu", "<cmd>lua require('fzf-lua').changes()<cr>")
    end,
  },
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },
}
