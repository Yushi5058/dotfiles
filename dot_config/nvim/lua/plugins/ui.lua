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
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            {
                modes = {
                    test = {
                        mode = "diagnostics",
                        preview = {
                            type = "split",
                            relative = "win",
                            position = "right",
                            size = 0.3,
                        },
                    },
                },
            }
        },
        keys = {
            { "<leader>xx", "<cmd>lua require('trouble').toggle()<cr>", mode = { "n" }, desc = "Trouble toggle" },
            {
                "<leader>xw",
                "<cmd>lua require('trouble').toggle('workspace_diagnostics')<cr>",
                mode = { "n" },
                desc = "Trouble Workspace Diagnostics",
            },
            {
                "<leader>xd",
                "<cmd>lua require('trouble').toggle('document_diagnostics')<cr>",
                mode = { "n" },
                desc = "Trouble Document Diagnostics",
            },
            {
                "<leader>xq",
                "<cmd>lua require('trouble').toggle('quickfix')<cr>",
                mode = { "n" },
                desc = "Trouble Quickfix",
            },
        },
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
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
            vim.keymap.set("n", "fk", builtin.keymaps, {})
        end,
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
}
