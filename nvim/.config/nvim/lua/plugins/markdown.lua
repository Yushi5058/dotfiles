return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = { completions = { lsp = { enabled = true } } },
	config = function()
		vim.keymap.set("n", "<leader>g", "<cmd>RenderMarkdown preview<cr>")
	end,
}
