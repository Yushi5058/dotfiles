return {

	"kdheepak/lazygit.nvim",
	-- optional for floating window border decoration
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{
			"<leader>gg",
			"<cmd>LazyGit<cr>",
			mode = { "n" },
			desc = "Open lazygit",
		},
	},
}

-- NOTE: add mini.diff depending of future workflow
