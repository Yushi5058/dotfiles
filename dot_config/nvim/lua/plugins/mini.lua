return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
        -- use icons
		require("mini.statusline").setup({ use_icons = vim.g.have_nerd_font })
		-- cursor location to LINE:COLUMN
		require("mini.statusline").section_location = function()
			return "%2l:%-2v"
		end
		require("mini.completion").setup()
		require("mini.git").setup()
		require("mini.diff").setup()
		require("mini.notify").setup()
        -- use mini.notify as default notifier
		vim.notify = require("mini.notify").make_notify()
	end,
}
