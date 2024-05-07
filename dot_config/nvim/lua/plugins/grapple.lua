return {
	"cbochs/grapple.nvim",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", lazy = true }
	},
	config = function()
		vim.keymap.set("n", "<leader>m", require("grapple").toggle)
		vim.keymap.set("n", "<leader>M", require("grapple").toggle_tags)

		vim.keymap.set("n", "<leader>&", "<cmd>Grapple select index=1<cr>")
		vim.keymap.set("n", "<leader>é", "<cmd>Grapple select index=2<cr>")
		vim.keymap.set("n", "<leader>\"", "<cmd>Grapple select index=3<cr>")
	end
}
