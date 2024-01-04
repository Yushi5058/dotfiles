return {
	"Theprimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("telescope").load_extension("harpoon")
		local keymap = vim.keymap
		keymap.set("n", "<leader>a", "<cmd>lua require('harpoon.mark').add_file()<cr>")
		keymap.set("n", "<c-e>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>")
		keymap.set("n", "<c-&>", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>")
		keymap.set("n", "<c-é>", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>")
		keymap.set("n", '<c-">', "<cmd>lua require('harpoon.ui').nav_file(3)<cr>")
		keymap.set("n", "<c-'>", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>")

		keymap.set("n", "<leader>hm", "<cmd>Telescope harpoon marks<cr>")
	end,
}
