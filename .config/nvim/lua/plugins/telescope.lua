return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = {
			'nvim-lua/plenary.nvim',
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-tree/nvim-web-devicons",
		},
    config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")


			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous, -- move to prev result
							["<C-j>"] = actions.move_selection_next, -- move to next result
						}
					}
				}
			})

			telescope.load_extension("fzf")
			vim.keymap.set('n', '<leader>ff', "<cmd>Telescope find_files<cr>")
			vim.keymap.set('n', '<leader>fg', "<cmd>Telescope live_grep<cr>")
		end
	},
}
