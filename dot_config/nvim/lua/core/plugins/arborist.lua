return {
	"arborist-ts/arborist.nvim",
	config = function()
		require("arborist").setup({
			update_cadence = "weekly",
			disable = {
				indent = { "markdown" },
				highlight = { "csv" },
			},
			-- `install_popular` already covers the core languages; these are
			-- the extra parsers used by this setup.
			ensure_installed = {
				"astro",
				"blade",
				"c_sharp",
				"fish",
				"gitcommit",
				"gitignore",
				"json5",
				"php",
				"powershell",
				"query",
				"razor",
				"scss",
				"sql",
				"svelte",
				"twig",
				"vue",
			},
		})
	end,
}
