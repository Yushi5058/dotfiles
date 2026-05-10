require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/folke/snacks.nvim" },
  })

  require("snacks").setup({
    picker = { enabled = true },
  })

  vim.keymap.set("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
  vim.keymap.set("n", "<leader>sc", function() Snacks.picker.commands() end, { desc = "Commands" })
end)