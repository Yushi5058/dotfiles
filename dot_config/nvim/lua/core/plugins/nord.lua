-- lua/plugins/nord.lua
return {
	"shaunsingh/nord.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.nord_contrast = true
		vim.g.nord_borders = true
		vim.g.nord_disable_background = false
		vim.cmd.colorscheme("nord")

		local function set_picker_highlights()
			vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { bg = "#5e81ac", fg = "#eceff4", bold = true })
			vim.api.nvim_set_hl(0, "MiniPickMatchRanges", { fg = "#88c0d0", bold = true })
			vim.api.nvim_set_hl(0, "MiniPickPrompt", { fg = "#88c0d0", bold = true })
		end
		set_picker_highlights()
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = set_picker_highlights,
		})
	end,
}
