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

		-- cloak.nvim rescans every pattern at every byte position and calls
		-- vim.fn helpers inside that loop. With a broad secret-key set that is
		-- ~1 s on a 2000-line file, so reuse the shared pure-Lua scanner.
		local cloak = require("cloak")
		cloak.cloak = function(pattern)
			cloak.uncloak()
			local buf = vim.api.nvim_get_current_buf()
			if cloak_patterns.cloak_buffer(buf, pattern.cloak_pattern, cloak.opts.uncloaked_line_num) then
				vim.opt_local.wrap = false
			end
		end

		-- Streaming helpers: `<leader>cc` hides/unhides everything, `<leader>cp`
		-- temporarily reveals the line under the cursor (re-cloaked on move).
		vim.keymap.set("n", "<leader>cc", "<cmd>CloakToggle<cr>", { desc = "Cloak: toggle" })
		vim.keymap.set("n", "<leader>cp", "<cmd>CloakPreviewLine<cr>", { desc = "Cloak: preview line" })

		-- `<leader>cy` copies the line/selection to the clipboard with the same
		-- redaction applied, so pasting a config into chat never carries the
		-- real value. Plain yanks stay untouched.
		vim.keymap.set({ "n", "x" }, "<leader>cy", function()
			local first, last
			if vim.fn.mode():match("^[vV\22]") then
				first, last = vim.fn.line("v"), vim.fn.line(".")
				if first > last then
					first, last = last, first
				end
			else
				first, last = vim.fn.line("."), vim.fn.line(".")
			end
			local text = cloak_patterns.redact_lines(vim.api.nvim_get_current_buf(), first, last)
			vim.fn.setreg("+", text)
			vim.notify("Cloak: copied redacted text", vim.log.levels.INFO)
		end, { desc = "Cloak: copy redacted to clipboard" })

		-- LSP hover/signature help and diagnostics floats are not file buffers,
		-- so cloak.nvim's file-pattern autocmds never touch them. Cloak them with
		-- the generic token + secret-key set instead.
		cloak_patterns.patch_lsp_floats()
		cloak_patterns.watch_floats()

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
