local function augroup(name)
  return vim.api.nvim_create_augroup("yushi" .. name, { clear = true })
end

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "markdown", "txt" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt.conceallevel = 1
  end,
})


-- trim white space
vim.api.nvim_create_autocmd("BufWritePre", { command = "%s/\\s\\+$//e" })

-- Highlight yanked text for 150ms
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- autoclose quickfix list when choosing one
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<CR>", "<CR>:cclose<CR>", { noremap = true, silent = true })
  end,
})

-- autoformat on save

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
    if vim.bo.filetype ~= "gitcommit" then
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
        end
      else
        vim.lsp.buf.format({ async = true })
      end
    end
  end,
})
