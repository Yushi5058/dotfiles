return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
        require("tiny-inline-diagnostic").setup({
            preset = "minimal" -- modern, classic, minimal, powerline, simple, nonerdfont
        })
        vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
    end,
}