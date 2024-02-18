return {
	"mrjones2014/legendary.nvim",
	priority = 10000,
	lazy = false,
	config = function()
		require("legendary").setup({
			keymaps = {},
			lazy_nvim = { auto_register = true },
		})
	end,
}
