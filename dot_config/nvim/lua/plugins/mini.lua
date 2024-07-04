return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		-- cursor location to LINE:COLUMN
		require("mini.statusline").setup({
			section_location = "%2l:%-2v",
		})
		require("mini.git").setup()
		require("mini.surround").setup()
		require("mini.diff").setup()
		require("mini.notify").setup()
		-- require("mini.icons").setup()
		require("mini.indentscope").setup()
		-- use mini.notify as default notifier
		vim.notify = require("mini.notify").make_notify()
	end,
}
