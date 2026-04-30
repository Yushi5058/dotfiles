return {
	"saghen/blink.cmp",
	dependencies = {
		"saghen/blink.lib",
		"rafamadriz/friendly-snippets",
		"disrupted/blink-cmp-conventional-commits",
	},
	build = function()
		require("blink.cmp").build():wait(60000)
	end,

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = { preset = "default" },

		completion = {
			trigger    = { show_on_insert_on_trigger_character = true },
			documentation = { auto_show = true, window = { border = "double" } },
		},

		-- (Default) list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "conventional_commits" },
			providers = {
				conventional_commits = {
					name = "Conventional Commits",
					module = "blink-cmp-conventional-commits",
					enabled = function()
						return vim.bo.filetype == "gitcommit"
					end,
					---@module 'blink-cmp-conventional-commits'
					---@type blink-cmp-conventional-commits.Options
					opts = {},
				},
			},
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"`
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "rust" },
	},
}
