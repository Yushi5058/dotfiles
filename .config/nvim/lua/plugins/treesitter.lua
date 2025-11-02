return {
	"nvim-treesitter/nvim-treesitter",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "lua", "vimdoc", "javascript", "typescript", "c", "vim", "html", "css", "json", "php" },
			highlight = { enable = true },
			additional_vim_regex_highlighting = false,
		})
	end,
}
