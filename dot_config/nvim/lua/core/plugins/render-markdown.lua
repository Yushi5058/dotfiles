return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown", "codecompanion" },
	opts = {
		file_types = { "markdown" },
		heading = { enabled = true, sign = true, icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " } },
		code = { enabled = true, sign = true, style = "full", width = "full", border = "thin" },
		bullet = { enabled = true, icons = { "●", "○", "◆", "◇" } },
		checkbox = { enabled = true, unchecked = { icon = "󰄱 " }, checked = { icon = "󰱒 " } },
		pipe_table = { enabled = true, style = "normal" },
		link = { enabled = true, footnote = { enabled = true } },
	},
}
