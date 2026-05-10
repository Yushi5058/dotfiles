require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/cbochs/grapple.nvim" },
  })

  require("grapple").setup({
    scope = "git",
    icons = false,
    status = false,
  })

  vim.keymap.set("n", "<leader>a", "<cmd>Grapple toggle<cr>", { desc = "Tag file" })
  vim.keymap.set("n", "<C-e>", "<cmd>Grapple toggle_tags<cr>", { desc = "Grapple menu" })
  vim.keymap.set("n", "<C-n>", "<cmd>Grapple cycle_tags next<cr>", { desc = "Next tag" })
  vim.keymap.set("n", "<C-p>", "<cmd>Grapple cycle_tags prev<cr>", { desc = "Prev tag" })
end)