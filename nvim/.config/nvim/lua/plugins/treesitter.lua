return {
	"https://github.com/arborist-ts/arborist.nvim",
	config = function()
		require("arborist").setup({
			prefer_wasm = false,
			update_cadence = "weekly",
			compiler = "zig",
		})
	end,
}
