return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
	opts = { completions = { lsp = { enabled = true } } },
	keys = {
		{ "<leader>g", "<cmd>RenderMarkdown preview<cr>", desc = "Markdown Preview" },
	},
}
