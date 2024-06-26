vim.api.nvim_create_autocmd("FileType", {
    pattern = "oil",
    callback = function()
        vim.opt.relativenumber = false
        vim.opt.number = false
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    pattern = "*",
    desc = "Highlight selection on yank",
    callback = function()
        vim.highlight.on_yank({ timeout = 200, visual = true })
    end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    group = vim.api.nvim_create_augroup("edit_text", { clear = true }),
    pattern = { "gitcommit", "markdown", "txt" },
    desc = "Enable spell checking and text wrapping for certain filetypes",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})
