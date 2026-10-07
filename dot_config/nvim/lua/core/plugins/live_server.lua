return {
	"barrettruth/live-server.nvim",
	url = "https://forge.barrettruth.com/barrettruth/live-server.nvim",
	cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
	ft = { "html", "css", "javascript", "typescript", "jsx", "tsx" },
	config = function()
		-- setup with defaults or vim.g.live_server
		require("live-server").setup(vim.g.live_server or {})
	end,
}
