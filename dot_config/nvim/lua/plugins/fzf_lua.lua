return {
	"ibhagwan/fzf-lua",
	config = function()
		require("fzf-lua").register_ui_select(function(_, items)
			local min_h, max_h = 0.15, 0.70
			local h = (#items + 4) / vim.o.lines
			if h < min_h then
				h = min_h
			elseif h > max_h then
				h = max_h
			end
			return { winopts = { height = h, width = 0.60, row = 0.40 } }
		end)
		vim.keymap.set("n", "<leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
		vim.keymap.set("n", "<leader>fg", "<cmd>lua require('fzf-lua').live_grep()<cr>")
		vim.keymap.set("n", "<leader>fh", "<cmd>lua require('fzf-lua').helptags()<cr>")
		vim.keymap.set("n", "<leader>fd", "<cmd>lua require('fzf-lua').diagnostics_workspace()<cr>")
		vim.keymap.set("n", "<leader>fq", "<cmd>lua require('fzf-lua').quickfix()<cr>")
	end,
}
