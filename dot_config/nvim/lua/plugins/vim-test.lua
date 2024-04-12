return {
	"vim-test/vim-test",
	config = function()
		vim.keymap.set("n", "<leader>tf", ":TestFile<cr>")
		vim.keymap.set("n", "<leader>tn", ":TestNearest<cr>")
		vim.cmd("let test#strategy = 'wezterm'")
	end,
}
