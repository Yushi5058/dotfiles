return {
	'mrjones2014/smart-splits.nvim',
	opts = {
		resize_mode = {
			silent = true,
			hooks = {
				on_enter = function()
					vim.notify("Entering resize mode")
				end,
				on_leave = function()
					vim.notify("Existing resize mode")
				end
			}
		}
	},
	keys = {
		-- resizing splits
		{ "<A-h>",             mode = { "n" }, "<cmd> lua require('smart-splits').resize_left<cr>" },
		{ "<A-j>",             mode = { "n" }, "<cmd> lua require('smart-splits').resize_down<cr>" },
		{ "<A-k>",             mode = { "n" }, "<cmd> lua require('smart-splits').resize_up<cr>" },
		{ "<A-l>",             mode = { "n" }, "<cmd> lua require('smart-splits').resize_right<cr>" },
		-- moving between splits
		{ "<C-h>",             mode = { "n" }, "<cmd> lua require('smart-splits').move_cursor_left<cr>" },
		{ "<C-j>",             mode = { "n" }, "<cmd> lua require('smart-splits').move_cursor_down<cr>" },
		{ "<C-k>",             mode = { "n" }, "<cmd> lua require('smart-splits').move_cursor_up<cr>" },
		{ "<C-l>",             mode = { "n" }, "<cmd> lua require('smart-splits').move_cursor_right<cr>" },
		{ "<C-\\>",            mode = { "n" }, "<cmd> lua require('smart-splits').move_cursor_previous<cr>" },
		-- swapping buffers between windows
		{ "<leader><leader>h", mode = { "n" }, "<cmd>lua require('smart-splits').swap_buf_left<cr>" },
		{ "<leader><leader>j", mode = { "n" }, "<cmd>lua require('smart-splits').swap_buf_down<cr>" },
		{ "<leader><leader>k", mode = { "n" }, "<cmd>lua require('smart-splits').swap_buf_up<cr>" },
		{ "<leader><leader>l", mode = { "n" }, "<cmd>lua require('smart-splits').swap_buf_right<cr>" },
	}
}
