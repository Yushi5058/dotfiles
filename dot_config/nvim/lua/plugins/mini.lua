-- require("mini.completion").setup()
-- waiting for mini.snippets
require("mini.pick").setup()
require("mini.extra").setup()
local map = vim.keymap.set

map("n", "<leader>ff", "<cmd>Pick files<cr>")
map("n", "<leader>fg", "<cmd>Pick grep_live<cr>")
map("n", "<leader>fd", "<cmd>Pick diagnostic<cr>")
map("n", "<leader>fl", "<cmd>Pick lsp<cr>")
map("n", "<leader>fh", "<cmd>Pick help<cr>")
require("mini.statusline").setup({
	section_location = "%2l:%-2v",
})
require("mini.git").setup()
require("mini.surround").setup()
require("mini.diff").setup()
require("mini.notify").setup()
-- use mini.notify as default notifier
vim.notify = require("mini.notify").make_notify()

require("mini.files").setup()
map("n", "<leader>n", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>")
require("mini.fuzzy").setup()

local hipatterns = require("mini.hipatterns")
hipatterns.setup({
	highlighters = {
		hex_color = hipatterns.gen_highlighter.hex_color(),
	},
})

require("mini.indentscope").setup()
require("mini.icons").setup()
require("mini.ai").setup()
