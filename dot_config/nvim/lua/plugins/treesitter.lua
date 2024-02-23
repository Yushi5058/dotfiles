return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"javascript",
				"typescript",
				"c",
				"lua",
				"vimdoc",
				"vim",
				"bash",
				"ruby",
				"markdown",
				"markdown_inline",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
				disable = function()
					-- check if 'filetype' option includes 'chezmoitmpl'
					if string.find(vim.bo.filetype, "chezmoitmpl") then
						return true
					end
				end,
			},
			indent = { enable = true },
		})
	end,
}
