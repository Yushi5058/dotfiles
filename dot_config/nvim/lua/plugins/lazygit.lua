return {

	"kdheepak/lazygit.nvim",
	-- optional for floating window border decoration
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "n", "<leader>gg", "<cmd>LazyGit<cr>" },
	},
}
