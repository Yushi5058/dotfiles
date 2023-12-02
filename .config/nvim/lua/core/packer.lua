vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'


    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use { "catppuccin/nvim", as = "catppuccin" }
	use "wakatime/vim-wakatime"
	use "lukas-reineke/indent-blankline.nvim"
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}
	use "tpope/vim-commentary"
	use "lewis6991/gitsigns.nvim"
	use "tpope/vim-fugitive"
    use "github/copilot.vim"
	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use "nvim-treesitter/playground"
	use {
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires = { {"nvim-lua/plenary.nvim"} }
	}
	use "j-hui/fidget.nvim"
	use "mbbill/undotree"
	use "folke/neodev.nvim"
	use {
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	}
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v1.x',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'hrsh7th/cmp-nvim-lsp'},
			-- Snippets
			{'L3MON4D3/LuaSnip'},
			{'saadparwaiz1/cmp_luasnip'},
		}
	}
	use "theprimeagen/refactoring.nvim"
	use({
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup {
				icons = false,
				-- your configuration comes here
				-- or leave it empty to use the default settings
    			-- refer to the configuration section below
			}
        end
    })
			use ({
				"folke/which-key.nvim",
				config = function()
					vim.o.timeout = true
					vim.o.timeoutlen = 500
					require("which-key").setup {
						-- your configuration comes here
						-- or leave it empty to use the default settings
						-- refer to the configuration section below
					}
				end
	})

end)




