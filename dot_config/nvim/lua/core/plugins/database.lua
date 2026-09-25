return {
  "kndndrj/nvim-dbee",
  dependencies = { "MunifTanjim/nui.nvim" },
  build = function ()
    require("dbee").install()
  end,
  config = function()
    require("dbee").setup()

    vim.keymap.set("n", "<leader>bt", function() require("dbee").toggle() end, { desc = "DBee: Toggle UI" })
    vim.keymap.set("n", "<leader>be", function() require("dbee").execute() end, { desc = "DBee: Execute Query" })
    vim.keymap.set("n", "<leader>bs", function() require("dbee").open() end, { desc = "DBee: Open/Reset UI" })
    vim.keymap.set("n", "<leader>ba", function() require("dbee").execute() end, { desc = "DBee: Action (Execute)" })
    vim.keymap.set("n", "<leader>bq", function() require("dbee").close() end, { desc = "DBee: Quit/Close" })
  end,
}