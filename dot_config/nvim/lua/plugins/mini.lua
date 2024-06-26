return {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
        require("mini.statusline").setup({use_icons = vim.g.have_nerd_font})
        require("mini.completion").setup()
        require("mini.git").setup()
        require("mini.diff").setup()
    end
}
