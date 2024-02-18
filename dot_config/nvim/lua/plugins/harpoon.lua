return {
	"theprimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{
			"<c-e>",
			function()
				require("harpoon.ui").toggle_quick_menu()
			end,
			mode = { "n" },
			desc = "Open Harpoon Menu",
		},
		{
			"<leader>a",
			function()
				require("harpoon.mark").add_file()
			end,
			mode = { "n" },
			desc = "Add file to harpoon",
		},
		{
			"<leader>r",
			function()
				require("harpoon.mark").rm_file()
			end,
			mode = { "n" },
			desc = "Remove file from harpoon",
		},
		{
			"<leader>c",
			function()
				require("harpoon.mark").clear_all()
			end,
			mode = { "n" },
			desc = "Clear harpoon menu",
		},
		{
			"<c-&>",
			function()
				require("harpoon.ui").nav_file(1)
			end,
			mode = { "n" },
			desc = "Navigate to file 1",
		},
		{
			"<c-é>",
			function()
				require("harpoon.ui").nav_file(2)
			end,
			mode = { "n" },
			desc = "Navigate to file 2",
		},
		{
			'<c-">',
			function()
				require("harpoon.ui").nav_file(3)
			end,
			mode = { "n" },
			desc = "Navigate to file 3",
		},
		{
			"<c-'>",
			function()
				require("harpoon.ui").nav_file(4)
			end,
			mode = { "n" },
			desc = "Navigate to file 4",
		},
	},
}
