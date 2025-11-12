return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	event = "VimEnter",
	dependencies = {
		{ "rafamadriz/friendly-snippets" },
		{ "folke/lazydev.nvim", opts = {} },
	},
	version = "1.*",
	opts = {
		keymap = { preset = "default" },

		appearance = {

			nerd_font_variant = "mono",
		},

		completion = { documentation = { auto_show = false } },

		sources = {
			default = { "lsp", "path", "snippets", "lazydev" },
			providers = {
				lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
			},
		},

		fuzzy = { implementation = "lua" },
		signature = { enabled = true },
	},
}
