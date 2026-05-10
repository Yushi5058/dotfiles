require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/nvim-mini/mini.nvim" },
  })

  require("mini.icons").setup()
  MiniIcons.mock_nvim_web_devicons()

  require("mini.pick").setup({ mappings = { move_down = "<C-j>", move_up = "<C-k>" } })
  require("mini.extra").setup()

  require("mini.surround").setup()
  require("mini.ai").setup({ n_lines = 500 })
  require("mini.pairs").setup()

  require("mini.indentscope").setup()
  require("mini.statusline").setup({
    use_icons        = vim.g.have_nerd_font,
    section_location = "%2l:%-2v",
  })

  require("mini.notify").setup()
  vim.notify = require("mini.notify").make_notify()

  require("mini.files").setup()
  require("mini.cmdline").setup()
  require("mini.diff").setup()
  require("mini.git").setup()

  vim.keymap.set({ "n", "v" }, "<space>", "<nop>", { silent = true })

  require("which-key").add({
    { "<leader>f", group = "find" },
    { "<leader>s", group = "snacks" },
    { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    { "<leader>y", '"+y', desc = "Yank → clipboard",  mode = { "n", "v" } },
    { "<leader>p", '"+p', desc = "Paste ← clipboard", mode = { "n", "v" } },
    { "<leader>d", '"_d', desc = "Delete → void",     mode = { "n", "v" } },
    { "sv", "<cmd>vsplit<cr>", desc = "Split vertical" },
    { "sh", "<cmd>split<cr>",  desc = "Split horizontal" },
    { "<C-h>", "<C-w>h", desc = "Window ←" },
    { "<C-j>", "<C-w>j", desc = "Window ↓" },
    { "<C-k>", "<C-w>k", desc = "Window ↑" },
    { "<C-l>", "<C-w>l", desc = "Window →" },
    { "<C-Left>",  "10<C-w><", desc = "Resize ←" },
    { "<C-Right>", "10<C-w>>", desc = "Resize →" },
    { "<C-Up>",    "10<C-w>+", desc = "Resize ↑" },
    { "<C-Down>",  "10<C-w>-", desc = "Resize ↓" },
    { "jk", "<cmd>nohlsearch<cr>", desc = "Clear highlights", mode = "n" },
    { "jk", "<Esc>",               desc = "Escape",           mode = { "i", "v" } },
    { "n", "'Nn'[v:searchforward]", desc = "Next match", expr = true, mode = { "n", "x", "o" } },
    { "N", "'nN'[v:searchforward]", desc = "Prev match", expr = true, mode = { "n", "x", "o" } },
    { "J", ":m '>+1<CR>gv=gv", desc = "Move block ↓", mode = "v" },
    { "K", ":m '<-2<CR>gv=gv", desc = "Move block ↑", mode = "v" },
    { "k", "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Up",   mode = "n" },
    { "j", "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Down", mode = "n" },
    { "<leader>ff", "<cmd>Pick files<cr>",      desc = "Files" },
    { "<leader>fg", "<cmd>Pick grep_live<cr>",  desc = "Grep" },
    { "<leader>fd", "<cmd>Pick diagnostic<cr>", desc = "Diagnostics" },
    { "<leader>fh", "<cmd>Pick help<cr>",       desc = "Help" },
    { "<leader>fb", "<cmd>Pick buffers<cr>",    desc = "Buffers" },
    { "<leader>e", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, desc = "Explorer" },
    { "<leader>b", group = "database" },
    { "<leader>S", group = "spectre/search" },
  })
end)