return {
	{
		"wakatime/vim-wakatime",
		lazy = false,
		config = function()
			vim.cmd([[packadd wakatime/vim-wakatime]])
		end,
	},
}
