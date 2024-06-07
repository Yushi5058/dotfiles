return {

    {
        "folke/neodev.nvim",
        opts = {},
        config = function()
            require("neodev").setup()
        end,
    },
    {
        'stevearc/dressing.nvim',
        opts = {},
    },
    {
        "folke/trouble.nvim",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
        opts = {}, -- for default options, refer to the configuration section for custom setup.
    },
    {
        "jiaoshijie/undotree",
        dependencies = "nvim-lua/plenary.nvim",
        config = true,
        keys = {
            { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", mode = { "n" }, desc = "Undotree Toggle" },
        },
    },
    { "tpope/vim-sleuth" },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            signs = false,
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ff", mode = { "n" }, "<cmd>Telescope find_files<cr>" },
            { "<leader>fg", mode = { "n" }, "<cmd>Telescope live_grep<cr>" },
            { "<leader>fh", mode = { "n" }, "<cmd>Telescope help_tags<cr>" },
            { "<leader>fc", mode = { "n" }, "<cmd>TodoTelescope<cr>" },
            { "<leader>fk", mode = { "n" }, "<cmd>Telescope keymaps<cr>" }
        }
    },
    {
        "wakatime/vim-wakatime",
        lazy = false,
    },
    {
        'stevearc/oil.nvim',
        config = function()
            vim.keymap.set('n', '<leader>n', function()
                require("oil").toggle_float()
            end)
            require('oil').setup({
                default_file_explorer = true,
                view_options = { show_hidden = true },
            })
        end
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },
    {
        "folke/zen-mode.nvim",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            { "<leader>z", mode = { "n" }, "<cmd>ZenMode<cr>", desc = "Toggle ZenMode" }
        }
    },
    {
        "lukas-reineke/headlines.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true, -- or `opts = {}`
    },
    {
        'IogaMaster/neocord',
        event = "VeryLazy",
        config = function()
            require("neocord").setup()
        end
    },
    {
        "ellisonleao/glow.nvim",
        keys = {
            { "<leader>gl", "<cmd>Glow<cr>", mode = { "n" }, desc = "Markdown preview" },
        },
        config = function()
            require("glow").setup()
        end,
    },
    {
        "nvim-pack/nvim-spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("spectre").setup()
            vim.keymap.set('n', '<leader>s', '<cmd>lua require("spectre").toggle()<CR>', {
                desc = "Toggle Spectre"
            })
            vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
                desc = "Search current word"
            })
            vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
                desc = "Search current word"
            })
            vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
                desc = "Search on current file"
            })
        end
    },
    {
        "cbochs/grapple.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons", lazy = true }
        },
        config = function()
            vim.keymap.set("n", "<leader>a", require("grapple").toggle)
            vim.keymap.set("n", "<c-e>", require("grapple").toggle_tags)

            vim.keymap.set("n", "<leader>&", "<cmd>Grapple select index=1<cr>")
            vim.keymap.set("n", "<leader>é", "<cmd>Grapple select index=2<cr>")
            vim.keymap.set("n", "<leader>\"", "<cmd>Grapple select index=3<cr>")
        end
    },
}
