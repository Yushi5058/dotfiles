return {
	"nvim-mini/mini.nvim",
	keys = {
		-- ── Picker ──────────────────────────────────────────────────────────
		{ "<leader>ff", "<cmd>Pick files<cr>",      desc = "Files" },
		{ "<leader>fg", "<cmd>Pick grep_live<cr>",  desc = "Grep" },
		{ "<leader>fd", "<cmd>Pick diagnostic<cr>", desc = "Diagnostics" },
		{ "<leader>fh", "<cmd>Pick help<cr>",       desc = "Help" },
		{ "<leader>fb", "<cmd>Pick buffers<cr>",    desc = "Buffers" },
		-- ── Explorer ────────────────────────────────────────────────────────
		{ "<leader>e", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, desc = "Explorer" },
	},
	config = function()
		require("mini.icons").setup()
		MiniIcons.mock_nvim_web_devicons()

		-- Picker
		require("mini.pick").setup({ mappings = { move_down = "<C-j>", move_up = "<C-k>" } })
		require("mini.extra").setup()

		-- Editing helpers
		require("mini.surround").setup()
		require("mini.ai").setup({ n_lines = 500 })
		require("mini.pairs").setup()

		-- UI
		require("mini.indentscope").setup()
		require("mini.statusline").setup({
			use_icons        = vim.g.have_nerd_font,
			section_location = "%2l:%-2v",
		})

		-- Notifications: replaces vim.notify with a floating history-aware popup
		require("mini.notify").setup()
		vim.notify = require("mini.notify").make_notify()

		-- Workspace
		require("mini.files").setup()
		require("mini.cmdline").setup()
		require("mini.diff").setup()
		require("mini.git").setup()
	end,
}
