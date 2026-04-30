-- ── Diagnostics (nvim 0.12) ───────────────────────────────────────────────────
-- sign_define() is removed in 0.12; signs must go through diagnostic.config()
local sev = vim.diagnostic.severity
vim.diagnostic.config({
	severity_sort  = true,
	update_in_insert = false,
	float = { border = "rounded", source = true },
	signs = {
		text = {
			[sev.ERROR] = "",
			[sev.WARN]  = "",
			[sev.INFO]  = "",
			[sev.HINT]  = "",
		},
	},
	-- virtual_text disabled: tiny-inline-diagnostic.nvim renders inline instead
	virtual_text = false,
})

-- ── Highlight on yank ─────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("TextYankPost", {
	group    = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern  = "*",
	callback = function() vim.highlight.on_yank({ timeout = 200 }) end,
})

-- ── Spell + wrap for prose filetypes ─────────────────────────────────────────
vim.api.nvim_create_autocmd("FileType", {
	group    = vim.api.nvim_create_augroup("prose_ft", { clear = true }),
	pattern  = { "gitcommit", "markdown", "txt" },
	callback = function()
		vim.opt_local.wrap  = true
		vim.opt_local.spell = true
	end,
})

-- Format on save handled by conform's format_on_save option (conform.lua)

-- ── Help opens in a vertical split ───────────────────────────────────────────
vim.api.nvim_create_autocmd("FileType", {
	group    = vim.api.nvim_create_augroup("vertical_help", { clear = true }),
	pattern  = "help",
	callback = function()
		vim.bo.bufhidden = "unload"
		vim.cmd.wincmd("L")
		vim.cmd.wincmd("=")
	end,
})

-- ── LSP on-attach ─────────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("LspAttach", {
	group    = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then return end

		-- mini.completion auto-triggers via completefunc, not omnifunc
		vim.bo[ev.buf].completefunc = "v:lua.vim.lsp.omnifunc"

		-- Document highlight: underline all occurrences of the word under cursor
		if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local hl = vim.api.nvim_create_augroup("lsp_highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = ev.buf, group = hl, callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = ev.buf, group = hl, callback = vim.lsp.buf.clear_references,
			})
			vim.api.nvim_create_autocmd("LspDetach", {
				group    = vim.api.nvim_create_augroup("lsp_detach", { clear = true }),
				callback = function(ev2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "lsp_highlight", buffer = ev2.buf })
				end,
			})
		end

		-- Inlay hints: show parameter names and return types inline
		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		end

		-- Code lens: show actionable annotations above functions (e.g. run/test)
		if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
			vim.lsp.codelens.enable(true, { bufnr = ev.buf })
		end

		-- LSP keymaps registered through which-key for popup visibility.
		-- nvim 0.12 built-in defaults kept as-is:
		--   gra → code action   grn → rename    grr → references
		--   gri → implementation  grt → type def  grx → run codelens
		--   gO  → doc symbols    K   → hover      <C-S> → signature (insert)
		require("which-key").add({
			{ "gd",  function() require("mini.extra").pickers.lsp({ scope = "definition" })      end, desc = "Definition",     buffer = ev.buf },
			{ "grr", function() require("mini.extra").pickers.lsp({ scope = "references" })      end, desc = "References",     buffer = ev.buf },
			{ "gri", function() require("mini.extra").pickers.lsp({ scope = "implementation" })  end, desc = "Implementation", buffer = ev.buf },
			{ "grt", function() require("mini.extra").pickers.lsp({ scope = "type_definition" }) end, desc = "Type def",       buffer = ev.buf },
			{ "gO",  function() require("mini.extra").pickers.lsp({ scope = "document_symbol" }) end, desc = "Symbols",        buffer = ev.buf },
		})
	end,
})

-- Treesitter is started automatically by arborist.nvim on FileType.
