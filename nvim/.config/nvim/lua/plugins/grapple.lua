return {
	"cbochs/grapple.nvim",
	opts = {
		scope = "git",
		icons = false,
		status = false,
	},
	keys = {
		{ "<leader>a", "<cmd>Grapple toggle<cr>", desc = "Tag file" },
		{ "<C-e>", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple menu" },
		{ "<C-n>", "<cmd>Grapple cycle_tags next<cr>", desc = "Next tag" },
		{ "<C-p>", "<cmd>Grapple cycle_tags prev<cr>", desc = "Prev tag" },
	},
}
