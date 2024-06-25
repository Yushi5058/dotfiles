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
local formatters = {
	html = format_cmd("prettier --write %"),
	css = format_cmd("prettier --write %"),
	javascript = format_cmd("eslint --fix %"),
	lua = format_cmd("stylua %"),
	ruby = format_cmd("rubocop -A %"),
	c = format_cmd("clang-format -i %"),
	cpp = format_cmd("clang-format -i %"),
}

-- Auto command to format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		local ft = vim.bo.filetype
		if formatters[ft] then
			formatters[ft]()
		else
			vim.lsp.buf.format({ async = false })
		end
	end,
})
