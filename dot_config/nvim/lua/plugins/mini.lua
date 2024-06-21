return {
	"echasnovski/mini.nvim",
	version = false,
	lazy = false,
	config = function()
		require("mini.cursorword").setup()
		require("mini.indentscope").setup()
		require("mini.pairs").setup()
		require("mini.comment").setup()
		require("mini.diff").setup()
		require("mini.git").setup()
		require("mini.completion").setup()
		require("mini.notify").setup()
		require("mini.statusline").setup()
		require("mini.surround").setup()
		require("mini.animate").setup()
	end,
}
