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
    }
},
{
    "wakatime/vim-wakatime",
    lazy = false,
},
{
'stevearc/oil.nvim',
opts = {
    default_file_explorer = true,
    view_options = {
        show_hidden = true
    }
},
keys = {
    {"<leader>n", mode = {"n"}, "<cmd>lua require('oil').toggle_float()"}
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
    keys = {
        {"<leader>s", mode = {"n"}, "<cmd>lua require('spectre').toggle()<cr>"},
        {"<leader>sw", mode = {"n"}, "<cmd>lua require('spectre').open_visual({select_word=true})<cr>"},
        {"<leader>sw", mode = {"v"}, "<cmd>lua require('spectre').open_visual()<cr>"},
        {"<leader>sp", mode = {"n"}, "<cmd>lua require('spectre').open_file_search({select_word=true})<cr>"},
    },
    {
        "cbochs/grapple.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons", lazy = true }
        },
        keys = {
            { "<leader>a",  mode = { "n" }, "<cmd>lua require('grapple').toggle<cr>" },
            { "<c-e>",      mode = { "n" }, "<cmd>lua require('grapple').toggle_tags<cr>" },
            { "<leader>&",  mode = { "n" }, "<cmd>Grapple select index=1<cr>" },
            { "<leader>é",  mode = { "n" }, "<cmd>Grapple select index=2<cr>" },
            { "<leader>\"", mode = { "n" }, "<cmd>Grapple select index=3<cr>" },
        },
        {
            "epwalsh/pomo.nvim",
            version = "*", -- Recommended, use latest release instead of latest commit
            lazy = true,
            cmd = { "TimerStart", "TimerRepeat" },
            opts = {
                -- See below for full list of options 👇
                sticky = false
            },
        },
        {
            'mrjones2014/legendary.nvim',
            priority = 10000,
            lazy = false,
            -- sqlite is only needed if you want to use frecency sorting
            -- dependencies = { 'kkharji/sqlite.lua' }
            opts = {
                extensions = {
                    lazy_nvim = true
                }
            },
        }
    }
