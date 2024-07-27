return {
	"NvChad/nvim-colorizer.lua",
	config = function()
		require("colorizer").setup({
			filetypes = { "css", "html", "scss" },
			user_default_options = {
				RRGGBBAA = true,
				rgb_fn = true,
				hsl_fn = true,
				tailwind = true,
				sass = { enable = true, parsers = { "css" } },
				always_update = true,
			},
		})
	end,
}
