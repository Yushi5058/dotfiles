return {

	{
		"ellisonleao/glow.nvim",
		keys = {
			{ "<leader>gl", "<cmd>Glow<cr>", mode = { "n" }, desc = "Markdown preview" },
		},
		config = function()
			require("glow").setup()
		end,
	},
}
