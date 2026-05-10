vim.keymap.set("n", "<leader>u", function()
  vim.cmd("packadd nvim.undotree | Undotree")
end, { desc = "Undotree" })