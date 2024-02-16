return {

	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"olimorris/neotest-rspec",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-rspec"),
			},
		})

		vim.keymap.set("n", "<leader>tf", function()
			require("neotest").run.run(vim.fn.expand("%"))
			vim.keympa.set("n", "<leader>tl", function()
				require("neotest").run.run()
			end)
		end)
	end,
}
