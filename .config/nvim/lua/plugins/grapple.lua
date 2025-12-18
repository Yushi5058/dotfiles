return {
	"cbochs/grapple.nvim",
	dependencies = {},
	opts = {
		scope = "git",
		icons = false,
		status = false,
	},
	config = function(_, opts)
		require("grapple").setup(opts)
		local map = vim.keymap.set
		map("n", "<leader>a", "<cmd>Grapple toggle<cr>")
		map("n", "<C-e>", "<cmd>Grapple toggle_tags<cr>")
		map("n", "<C-n>", "<cmd>Grapple cycle_tags next<cr>")
		map("n", "<C-p>", "<cmd>Grapple cycle_tags prev<cr>")
	end,
}
