return {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
        require("mini.statusline").setup({use_icons = vim.g.have_nerd_font})
        require("mini.completion").setup()
    end
}
