return {
	"andweeb/presence.nvim",
	event = "VeryLazy",
	opts = {
		neovim_image_text = "The One True Editor",
		main_image = "neovim",
		-- Use folder name if git project isn't found
		workspace_text = function(project_name)
			if project_name then
				return "Working on " .. project_name
			end
			return "Working on " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
		end,
	},
}
