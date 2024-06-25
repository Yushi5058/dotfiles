return {
	"stevearc/oil.nvim",
	config = function()
		require("oil").setup({
			view_options = {
				show_hidden = true,
			},
		})
		vim.keymap.set("n", "<leader>n", "<cmd>lua require('oil').toggle_float()<cr>")
	end,
}
