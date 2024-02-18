return {
	"mrjones2014/legendary.nvim",
	priority = 10000,
	lazy = false,
	keys = {
		{ "n", "<leader>k", "<cmd>Legendary<cr>" },
	},
	config = function()
		require("legendary").setup({
			keymaps = {},
			lazy_nvim = { auto_register = true },
		})
	end,
}
