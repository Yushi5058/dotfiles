return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>a",":lua require('harpoon.mark').add_file()<cr>")
    keymap.set("n", "<C-e>",":lua require('harpoon.ui').toggle_quick_menu()<cr>")
    keymap.set("n", "<C-&>",":lua require('harpoon.ui').nav_file(1)<cr>")
    keymap.set("n", "<C-é>",":lua require('harpoon.ui').nav_file(2)<cr>")
    keymap.set("n", "<C-\">",":lua require('harpoon.ui').nav_file(3)<cr>")
    keymap.set("n", "<C-\'>", ":lua require('harpoon.ui').nav_file(4)<cr>")

      end,
}








