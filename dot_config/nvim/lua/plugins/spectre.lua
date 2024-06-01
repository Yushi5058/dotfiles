return {
	"nvim-pack/nvim-spectre",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("spectre").setup()

		vim.keymap.set("n", "<leader>s", "<cmd>lua require('spectre').toggle()<cr>")
	end
}
