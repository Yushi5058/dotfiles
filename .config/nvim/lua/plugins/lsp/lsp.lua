return {
	"saghen/blink.cmp",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local blink_cmp = require("blink.cmp")
		local capabilities = blink_cmp.get_lsp_capabilities()

		vim.lsp.config("*", {
			capabilities = capabilities,
		})
	end,
}
