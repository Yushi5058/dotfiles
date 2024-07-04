local map = vim.keymap.set
        map("n","<leader>a", "<cmd>Grapple toggle<cr>")
        map("n","<C-e>", "<cmd>Grapple toggle_tags<cr>")
        map("n","<C-n>", "<cmd>Grapple cycle_tags next<cr>")
        map("n","<C-p>", "<cmd>Grapple cycle_tags prev<cr>")
