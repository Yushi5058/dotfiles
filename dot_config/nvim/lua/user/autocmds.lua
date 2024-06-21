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
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})
-- autoclose quickfix list when choosing one
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<CR>:cclose<CR>", { noremap = true, silent = true })
	end,
})

-- autoformat on save
vim.api.nvim_create_autocmd("BufWritePe", {
	pattern = "*",
	callback = function()
		vim.lsp.buf.format()
	end,
})
