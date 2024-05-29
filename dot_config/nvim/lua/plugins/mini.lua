return {
	"echasnovski/mini.nvim",
	version = false,
	lazy = false,
	config = function()
		require("mini.cursorword").setup()
		require("mini.indentscope").setup()
		require("mini.pairs").setup()
		require("mini.surround").setup()
		-- NOTE:
		-- add = 'sa', -- Add surrounding in Normal and Visual modes
		--  delete = 'sd', -- Delete surrounding
		--  find = 'sf', -- Find surrounding (to the right)
		--  find_left = 'sF', -- Find surrounding (to the left)
		--  highlight = 'sh', -- Highlight surrounding
		--  replace = 'sr', -- Replace surrounding
		require("mini.animate").setup()
		require("mini.comment").setup()
		-- NOTE:
		-- on visual mode :
		-- gc to comment
		-- gcc to comment current line
		require("mini.statusline").setup()
		require("mini.starter").setup()
		require("mini.notify").setup()
		require("mini.diff").setup()
	end,
}
