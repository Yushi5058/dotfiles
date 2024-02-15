return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"fladson/vim-kitty",
		"ziglang/zig.vim",
	},
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"javascript",
				"typescript",
				"c",
				"lua",
				"rust",
				"vimdoc",
				"vim",
				"bash",
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

		-- fix tree-sitter executable not found warning
		--  https://github.com/nvim-treesitter/nvim-treesitter/issues/2484#issuecomment-1031912446
		for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
			config.install_info.use_makefile = true
			config.install_info.cxx_standard = "c++14"
		end
	end,
}
