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

-- oil configuration
vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
		vim.opt_local.colorcolumn = ""
	end,
})

-- open help vertically
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("vertical_help", { clear = true }),
	pattern = "help",
	callback = function()
		vim.bo.bufhidden = "unload"
		vim.cmd.wincmd("L")
		vim.cmd.wincmd("=")
	end,
})

-- trim white space
vim.api.nvim_create_autocmd("BufWritePre", { command = "%s/\\s\\+$//e" })

-- Highlight yanked text for 150ms
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end
})
-- autoclose quickfix list when choosing one
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<CR>:cclose<CR>", { noremap = true, silent = true })
	end,
})



-- Create an augroup for Godot
vim.api.nvim_exec([[
  augroup godot
    autocmd!
    autocmd FileType gdscript lua << EOF
      -- Set fold method to expression
      vim.bo.foldmethod = 'expr'
      -- Set tabstop to 4
      vim.bo.tabstop = 4

      -- Set key mappings for Godot commands
      vim.api.nvim_buf_set_keymap(0, 'n', '<F4>', ':GodotRunLast<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<F5>', ':GodotRun<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<F6>', ':GodotRunCurrent<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<F7>', ':GodotRunFZF<CR>', { noremap = true, silent = true })
    EOF
  augroup END
]], false)
