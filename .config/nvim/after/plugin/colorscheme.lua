require("catppuccin").setup({
    flavour = "frappe", -- latte, frappe, macchiato, mocha
    transparent_background = true, -- disables setting the background color.
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"

