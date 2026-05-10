vim.pack.add({
  { src = "https://github.com/MunifTanjim/nui.nvim", start = true },
})
vim.pack.add({
  { src = "https://github.com/kndndrj/nvim-dbee" },
})

require("lazyload").on_vim_enter(function()
  local ok, _ = pcall(require, "dbee")
  if ok then
    require("dbee").setup()

    vim.keymap.set("n", "<leader>bt", function() require("dbee").toggle() end, { desc = "DBee: Toggle UI" })
    vim.keymap.set("n", "<leader>be", function() require("dbee").execute() end, { desc = "DBee: Execute Query" })
    vim.keymap.set("n", "<leader>bs", function() require("dbee").sidebar_toggle() end, { desc = "DBee: Toggle Sidebar" })
    vim.keymap.set("n", "<leader>ba", function() require("dbee").execute() end, { desc = "DBee: Action (Execute)" })
    vim.keymap.set("n", "<leader>bq", function() require("dbee").close() end, { desc = "DBee: Quit/Close" })
  end
end)