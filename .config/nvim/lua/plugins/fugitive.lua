return {
	"tpope/vim-fugitive",
	config = function()
		local keymap = vim.keymap

		keymap.set("n", "<leader>ga", ":G add ")
		keymap.set("n", "<leader>gc", "<:G commit -m ")
		keymap.set("n", "<leader>gpush", "<cmd>G push origin main<cr>")
		keymap.set("n", "<leader>gs", "<cmd>G status<cr>")
	end,
}
