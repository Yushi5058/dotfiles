return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"olimorris/neotest-rspec"
	},
	config = function ()
		require("neotest").setup({
			adapters = {
				require("neotest-rspec")
			}
		})

		vim.keymap.set("n", "<leader>tn", ":lua require('neotest').run.run()<cr>")
		vim.keymap.set("n", "<leader>tf", ":lua require('neotest').run.run(vim.fn.expand('%'))<cr>")
	end
}
