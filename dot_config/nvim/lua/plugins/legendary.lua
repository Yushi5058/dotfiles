return {
	"mrjones2014/legendary.nvim",
	priority = 10000,
	lazy = false,
	keys = {
		"<",
		"<cmd>Legendary<cr>",
		mode = { "n" },
		desc = "Open legendary",
	},
	config = function()
		require("legendary").setup({
			keymaps = {},
			extensions = {
				lazy_nvim = true,
			},
		})
	end,
}
