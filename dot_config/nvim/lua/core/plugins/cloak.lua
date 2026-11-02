-- cloak.nvim: overlays sensitive values with '*' so nothing leaks while
-- streaming. Purely visual: the buffer text is never modified, only covered
-- with extmarks, so yanks/copies still give you the real value.
--
-- Patterns and the mini.pick integration live in `core.cloak_patterns` so both
-- can be reused and tested. See that file for the layering rules.
return {
	"laytan/cloak.nvim",
	config = function()
		local cloak_patterns = require("core.cloak_patterns")

		require("cloak").setup({
			enabled = true,
			cloak_character = "*",
			highlight_group = "Comment",
			-- cloak_length would hide the real length too, but the plugin
			-- mis-renders when it exceeds the underlying text, so leave nil.
			try_all_patterns = true,
			cloak_telescope = false, -- no telescope in this config
			cloak_on_leave = false,
			patterns = cloak_patterns.patterns,
		})

		-- Streaming helpers: `<leader>cc` hides/unhides everything, `<leader>cp`
		-- temporarily reveals the line under the cursor (re-cloaked on move).
		vim.keymap.set("n", "<leader>cc", "<cmd>CloakToggle<cr>", { desc = "Cloak: toggle" })
		vim.keymap.set("n", "<leader>cp", "<cmd>CloakPreviewLine<cr>", { desc = "Cloak: preview line" })

		-- mini.pick: redact grep/diagnostic result lines and cloak the preview
		-- buffer. mini.pick may not be on the runtimepath yet while lazy loads
		-- specs, so patch after startup and again on first picker start.
		vim.schedule(function()
			cloak_patterns.patch_minipick()
		end)
		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniPickStart",
			callback = function()
				cloak_patterns.patch_minipick()
			end,
		})
	end,
}
