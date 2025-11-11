return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
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

		completion = { documentation = { auto_show = true } },

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
	config = function()
		local blink_cmp = require("blink.cmp")

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = blink_cmp.get_lsp_capabilities()

		vim.lsp.config("*", {
			capabilities = capabilities,
		})
	end,
}
