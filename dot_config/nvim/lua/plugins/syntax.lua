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
	"NvChad/nvim-colorizer.lua",
	lazy = true,
	config = function()
		require("colorizer").setup({
			filetypes = {
				"css",
				"javascript",
				html = { mode = "foreground" },
			},
			user_default_options = {
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				mode = "background", -- Set the display mode.
				-- True is same as normal
				tailwind = true, -- Enable tailwind colors
				sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
				virtualtext = "■",
				always_update = false,
			},
		})
	end,
}
