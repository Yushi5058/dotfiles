return {
    "ibhagwan/fzf-lua",
    config = function()
        vim.ui.select = require("fzf-lua").register_ui_select()
        vim.keymap.set("n", "<leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
        vim.keymap.set("n", "<leader>fg", "<cmd>lua require('fzf-lua').live_grep()<cr>")
        vim.keymap.set("n", "<leader>fh", "<cmd>lua require('fzf-lua').helptags()<cr>")
        vim.keymap.set("n", "<leader>fd", "<cmd>lua require('fzf-lua').diagnostics_workspace()<cr>")
        vim.keymap.set("n", "<leader>fq", "<cmd>lua require('fzf-lua').quickfix()<cr>")
        vim.keymap.set("n", "<leader>fr", "<cmd>lua require('fzf-lua').lsp_references()<cr>")
    end,
}
