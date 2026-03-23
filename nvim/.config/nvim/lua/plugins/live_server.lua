return {
	"barrett-ruth/live-server.nvim",
	build = "bun install -g live-server",
	cmd = { "LiveServerStart", "LiveServerStop" },
	config = true,
}
