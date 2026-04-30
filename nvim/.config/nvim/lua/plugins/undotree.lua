-- nvim 0.12 built-in undotree — no external plugin needed.
-- packadd loads it on first use; subsequent calls are instant.
vim.keymap.set("n", "<leader>u", function()
	vim.cmd("packadd nvim.undotree | Undotree")
end, { desc = "Undotree" })

return {}
