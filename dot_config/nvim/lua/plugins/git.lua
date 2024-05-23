return {

	"kdheepak/lazygit.nvim",
	-- optional for floating window border decoration
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function ()
		vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>")
	end
	,
	{
        "lewis6991/gitsigns.nvim",
        lazy = true,
        config = function()
            require("gitsigns").setup()
        end,
    },
}
-- NOTE: add mini.diff depending of future workflow
