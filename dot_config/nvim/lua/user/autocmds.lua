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

-- Define commands per filetype
local commands = {
  html = "prettier --write",
  css = "prettier --write",
  markdown = "prettier --write",
  javascript = "eslint --fix",
  ruby = "rubocop -A",
  lua = "stylua",
  c = "clang-format -i",
  cpp = "clang-format -i",
}

-- autoformat on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "gitcommit" then
      local ft = vim.bo.filetype
      local command = commands[ft]

      if command then
          local range = {1, vim.fn.line("$")}  -- Format entire buffer
          local output = vim.fn.systemlist(command, {
              args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
              capture_output = true,
              input = table.concat(vim.api.nvim_buf_get_lines(0, range[1] - 1, range[2], false), "\n"),
          })

        if output and #output > 0 then
          vim.api.nvim_buf_set_lines(0, range[1] - 1, range[2], false, output)
        end
             else
        vim.lsp.buf.format({ async = true })
      end
    end
  end,
})
