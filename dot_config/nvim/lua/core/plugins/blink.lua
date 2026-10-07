return {
	"saghen/blink.lib",
	{
		"saghen/blink.cmp",
		dependencies = { "saghen/blink.lib", "rafamadriz/friendly-snippets" },
		opts = {
			keymap = { preset = "default" },
			completion = {
				menu = {
					draw = {
						components = {
							-- customize the drawing of kind icons
							kind_icon = {
								text = function(ctx)
									-- default kind icon
									local icon = ctx.kind_icon
									-- if LSP source, check for color derived from documentation
									if ctx.item.source_name == "LSP" then
										local color_item = require("nvim-highlight-colors").format(
											ctx.item.documentation,
											{ kind = ctx.kind }
										)
										if color_item and color_item.abbr ~= "" then
											icon = color_item.abbr
										end
									end
									return icon .. ctx.icon_gap
								end,
								highlight = function(ctx)
									-- default highlight group
									local highlight = "BlinkCmpKind" .. ctx.kind
									-- if LSP source, check for color derived from documentation
									if ctx.item.source_name == "LSP" then
										local color_item = require("nvim-highlight-colors").format(
											ctx.item.documentation,
											{ kind = ctx.kind }
										)
										if color_item and color_item.abbr_hl_group then
											highlight = color_item.abbr_hl_group
										end
									end
									return highlight
								end,
							},
						},
					},
				},
				documentation = { auto_show = false },
				trigger = { show_on_insert_on_trigger_character = true },
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					lsp = { score_offset = 1000 },
					snippets = { score_offset = -100, max_items = 2, min_keyword_length = 3 },
					buffer = { score_offset = -150, min_keyword_length = 3 },
				},
			},
			fuzzy = { implementation = "rust" },
		},
		config = function(_, opts)
			require("blink.cmp").build()
		end,
	},
}
