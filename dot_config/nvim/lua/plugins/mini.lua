return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		require("mini.statusline").setup({ use_icons = vim.g.have_nerd_font })
		-- You can configure sections in the statusline by overriding their
		-- default behavior. For example, here we set the section for
		-- cursor location to LINE:COLUMN
		---@diagnostic disable-next-line: duplicate-set-field
		require("mini.statusline").section_location = function()
			return "%2l:%-2v"
		end
		require("mini.completion").setup()
		require("mini.git").setup()
		require("mini.diff").setup()
	end,
}
