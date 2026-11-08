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
	end,
}
