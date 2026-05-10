require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/nvim-pack/nvim-spectre" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
  })

  vim.keymap.set("n", "<leader>S", function() require("spectre").toggle() end, { desc = "Spectre toggle" })
  vim.keymap.set("n", "<leader>Sw", function() require("spectre").open_visual({ select_word = true }) end, { desc = "Search word" })
  vim.keymap.set("v", "<leader>Sw", function() require("spectre").open_visual() end, { desc = "Search selection" })
  vim.keymap.set("n", "<leader>Sp", function() require("spectre").open_file_search({ select_word = true }) end, { desc = "Search in file" })
end)