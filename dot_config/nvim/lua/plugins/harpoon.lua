return {
	"theprimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.lua",
	},
	config = function()
		require("harpoon").setup()

		local harpoon_ui = require("harpoon.ui")
		local harpoon_mark = require("harpoon.mark")

		vim.keymap.set("n", "<c-e>", function()
			harpoon_ui.toggle_quick_menu()
		end)

		-- Add current file to harpoon
		vim.keymap.set("n", "<leader>a", function()
			harpoon_mark.add_file()
		end)

		-- Remove current file from harpoon
		vim.keymap.set("n", "<leader>r", function()
			harpoon_mark.rm_file()
		end)

		-- Remove all files from harpoon
		vim.keymap.set("n", "<leader>c", function()
			harpoon_mark.clear_all()
		end)

		-- Quickly jump to harpooned files
		vim.keymap.set("n", "<c-&>", function()
			harpoon_ui.nav_file(1)
		end)
		vim.keymap.set("n", "<c-é>", function()
			harpoon_ui.nav_file(2)
		end)
		vim.keymap.set("n", '<c-">', function()
			harpoon_ui.nav_file(3)
		end)
		vim.keymap.set("n", "<c-'>", function()
			harpoon_ui.nav_file(4)
		end)
	end,
}
