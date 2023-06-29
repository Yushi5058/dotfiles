-- plugins.lua

-- Gestionnaire de plugins
local packer = require('packer')

return packer.startup(function()
    -- Utiliser le gestionnaire de plugins pour ajouter les plugins
    -- Ajoutez ici les plugins que vous souhaitez utiliser

    -- Controle de version Git/GitHub
    use 'tpope/vim-fugitive'

    -- Support LSP
    use 'neovim/nvim-lspconfig'

    -- Autocompletion avec cmp
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip'
        }
    }

    -- Gestion des projets
    use 'tpope/vim-projectionist'

    -- Terminal à toggle
    use {
        'akinsho/nvim-toggleterm.lua',
        config = function()
            require('toggleterm').setup()
        end
    }

    -- Colorizer pour Tailwind CSS, CSS et SCSS
    use {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup()
        end
    }

    -- Discord Presence
    use 'andweeb/presence.nvim'

    -- Wakatime
    use 'wakatime/vim-wakatime'

    -- Ajoutez d'autres plugins selon vos besoins

end)
