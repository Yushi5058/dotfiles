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
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    if vim.bo.filetype ~= "gitcommit" then
      if vim.bo.filetype == "css" or vim.bo.filetype == "markdown" or vim.bo.filetype == "html" then
        vim.fn.system("prettier --write " .. vim.fn.shellescape(filepath))
      elseif vim.bo.filetype == "javascript" then
        vim.fn.system("eslint --fix " .. vim.fn.shellescape(filepath))
      elseif vim.bo.filetype == "ruby" then
        vim.fn.system("rubocop -A " .. vim.fn.shellescape(filepath))
      elseif vim.bo.filetype == "lua" then
        vim.fn.system("stylua " .. vim.fn.shellescape(filepath))
      elseif vim.bo.filetype == "C" or vim.bo.filetype == "cpp" then
        vim.fn.system("clang-format -i " .. vim.fn.shellescape(filepath))
      else
        vim.lsp.buf.format({ async = true })
      end
    end
  end,
})
