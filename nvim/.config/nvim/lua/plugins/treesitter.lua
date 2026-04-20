return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdateSync",
	opts = {
		ensure_installed = { "markdown", "markdown_inline", "lua", "vim", "vimdoc" },
		auto_install = false,
		sync_install = false,
		highlight = { enable = true },
		indent = { enable = true },
	},
}