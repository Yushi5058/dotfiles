return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
	},
	event = "VeryLazy",
	opts = {
		adapters = {
			gemini = {
				name = "gemini",
				env = {
					api_key = os.getenv("GEMINI_API_KEY"),
					model = "gemini-3-pro-preview-05-20",
				},
			},
			minimax = {
				name = "minimax",
				env = {
					api_key = os.getenv("MINIMAX_API_KEY"),
					endpoint = "https://api.minimax.chat/v1",
					model = "MiniMax-M2.5-Free",
				},
			},
		},
		strategies = {
			chat = {
				name = "Chat",
				keymaps = {
					send = {
						modes = { n = "<C-s>", i = "<C-s>" },
						opts = {},
						description = "Send message",
					},
					close = {
						modes = { n = "<C-c>", i = "<C-c>" },
						opts = {},
						description = "Close chat",
					},
					stop = {
						modes = { n = "<leader>ccq" },
						opts = {},
						description = "Stop generation",
					},
					options = {
						modes = { n = "?" },
						description = "Show keymaps",
					},
				},
			},
			inline = {
				name = "Inline",
				keymaps = {
					stop = {
						modes = { n = "<leader>ccq" },
						opts = {},
						description = "Stop generation",
					},
					toggle = {
						modes = { n = "<leader>cci" },
						opts = {},
						description = "Toggle inline mode",
					},
				},
			},
			inline_diff = {
				name = "InlineDiff",
				keymaps = {
					accept_change = {
						modes = { n = "<leader>cca" },
						opts = {},
						description = "Accept change",
					},
					reject_change = {
						modes = { n = "<leader>ccr" },
						opts = {},
						description = "Reject change",
					},
					next_hunk = {
						modes = { n = "<leader>ccn" },
						opts = {},
						description = "Next hunk",
					},
					previous_hunk = {
						modes = { n = "<leader>ccp" },
						opts = {},
						description = "Previous hunk",
					},
				},
			},
		},
		interactions = {
			chat = {
				keymaps = {
					send = {
						modes = { n = "<C-s>", i = "<C-s>" },
						opts = {},
					},
					close = {
						modes = { n = "<C-c>", i = "<C-c>" },
						opts = {},
					},
				},
			},
		},
	},
	keys = {
		{
			"<leader>cca",
			"<cmd>CodeCompanionActions<cr>",
			desc = "CodeCompanion Actions",
		},
		{
			"<leader>ccc",
			"<cmd>CodeCompanionChat Toggle<cr>",
			desc = "CodeCompanion Chat",
		},
		{
			"<leader>cce",
			"<cmd>CodeCompanionChat Add<cr>",
			desc = "CodeCompanion Add to Chat",
		},
	},
}