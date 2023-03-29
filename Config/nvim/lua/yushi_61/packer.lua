

vim.cmd [[ packadd packer.nvim ]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
  'nvim-telescope/telescope.nvim', tag = '0.1.1',
-- or                            , branch = '0.1.x',
  requires = { {'nvim-lua/plenary.nvim'} }
}
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

  use { "catppuccin/nvim", as = "catppuccin" }
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use "terrortylor/nvim-comment"
  require('nvim_comment').setup()

  use('nvim-treesitter/playground')
  use('theprimeagen/harpoon')
  use("theprimeagen/refactoring.nvim")
  use('mbbill/undotree')
  use('tpope/vim-fugitive')
  use {
  'lewis6991/gitsigns.nvim',
  config = function()
      require('gitsigns').setup {
           signs = {
    add          = { text = '+' },
    delete       = { text = '-' },
    untracked    = { text = '?' },
  },
      }
  end
}
  use("nvim-treesitter/nvim-treesitter-context")
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
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
	  }
  }
  use("eandrju/cellular-automaton.nvim")
  use("jiangmiao/auto-pairs")
  use ("alvan/vim-closetag")
  use ("wakatime/vim-wakatime")

end)
