return {
	{
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
					"gdscript",
					"embedded_template"
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
	},
	{
		"alker0/chezmoi.vim",
		lazy = false,
		init = function()
			-- This option is required.
			vim.g["chezmoi#use_tmp_buffer"] = true
			-- add other options here if needed.
		end,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({
				enable_tailwind = true,
			})
			vim.keymap.set("n", "<c-h", "<cmd>HighlightColors Toggle<cr>")
		end
	},
	{
		"habamax/vim-godot"
	},
	{ "vim-ruby/vim-ruby" },
	{ "tpope/vim-rails" }
}
