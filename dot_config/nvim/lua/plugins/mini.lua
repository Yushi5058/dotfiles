return {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
        -- cursor location to LINE:COLUMN
        require("mini.statusline").setup({
            section_location = "%2l:%-2v"
        })
        require("mini.git").setup()
        require("mini.surround").setup()
        require("mini.diff").setup()
        require("mini.notify").setup()
        -- use mini.notify as default notifier
        vim.notify = require("mini.notify").make_notify()
    end,
}
