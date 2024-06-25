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

vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("format_on_save", { clear = true }),
    pattern = "*",
    desc = "Run LSP formatting on a file on save",
    callback = function()
        if vim.fn.exists(":Format") > 0 then
            vim.cmd.Format()
        end
    end,
})

-- Function to execute shell commands
local function format_cmd(cmd)
    return function()
        vim.cmd(string.format("silent !%s", cmd))
        vim.cmd("edit!")
    end
end

-- Define formatters for each file type
-- Define commands per filetype
local commands = {
    html = "prettier --stdin-filepath",
    css = "prettier --stdin-filepath",
    markdown = "prettier --stdin-filepath",
    javascript = "eslint --fix --stdin --stdin-filename",
    ruby = "rubocop -A --stdin",
    lua = "stylua --stdin-filepath",
    c = "clang-format",
    cpp = "clang-format",
}

-- autoformat on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local ft = vim.bo.filetype
        local command = commands[ft]

        if command then
            local filename = vim.api.nvim_buf_get_name(0)
            local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
            local cmd = command .. " " .. vim.fn.shellescape(filename)

            local output = vim.fn.systemlist(cmd, content)
            if vim.v.shell_error == 0 then
                vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
            else
                print("Error running: " .. cmd)
                vim.lsp.buf.format({ async = true })
            end
        else
            return
        end
    end,
})
