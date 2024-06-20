return {
	"echasnovski/mini.nvim",
	version = false,
	lazy = false,
	config = function()
		require("mini.cursorword").setup()
		require("mini.indentscope").setup()
		require("mini.pairs").setup()
		require("mini.comment").setup()
		-- NOTE:
		-- on visual mode :
		-- gc to comment
		-- on normal mode :
		-- gcc to comment
		require("mini.diff").setup()
		require("mini.git").setup()
		require("mini.completion").setup()
	end,
}
