return {
	"tpope/vim-fugitive",
	config = function()
		local keymap = vim.keymap

		keymap.set("n", "<leader>ga", "<cmd>G add")
		keymap.set("n", "<leader>gc", "<cmd>G commit -m")
		keymap.set("n", "<leader>gpush", "<cmd>G push origin main")
		keymap.set("n", "<leader>gs", "<cmd>G status<cr>")
	end,
}
