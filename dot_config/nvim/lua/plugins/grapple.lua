return {
	"cbochs/grapple.nvim",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", lazy = true }
	},
	config = function()
		vim.keymap.set("n", "<leader>a", require("grapple").toggle)
		vim.keymap.set("n", "<c-e>", require("grapple").toggle_tags)

		vim.keymap.set("n", "<C-&>", "<cmd>Grapple select index=1<cr>")
		vim.keymap.set("n", "<C-é>", "<cmd>Grapple select index=2<cr>")
		vim.keymap.set("n", "<C-\">", "<cmd>Grapple select index=3<cr>")
	end
}
