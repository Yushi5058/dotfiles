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
	virtual_text = false,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group    = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern  = "*",
	callback = function() vim.highlight.on_yank({ timeout = 200 }) end,
})

vim.api.nvim_create_autocmd("FileType", {
	group    = vim.api.nvim_create_augroup("prose_ft", { clear = true }),
	pattern  = { "gitcommit", "markdown", "txt" },
	callback = function()
		vim.opt_local.wrap  = true
		vim.opt_local.spell = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group    = vim.api.nvim_create_augroup("vertical_help", { clear = true }),
	pattern  = "help",
	callback = function()
		vim.bo.bufhidden = "unload"
		vim.cmd.wincmd("L")
		vim.cmd.wincmd("=")
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group    = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then return end

		vim.bo[ev.buf].completefunc = "v:lua.vim.lsp.omnifunc"

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

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
			vim.lsp.codelens.enable(true, { bufnr = ev.buf })
		end

		require("which-key").add({
			{ "gd",  function() require("mini.extra").pickers.lsp({ scope = "definition" })      end, desc = "Definition",     buffer = ev.buf },
			{ "grr", function() require("mini.extra").pickers.lsp({ scope = "references" })      end, desc = "References",     buffer = ev.buf },
			{ "gri", function() require("mini.extra").pickers.lsp({ scope = "implementation" })  end, desc = "Implementation", buffer = ev.buf },
			{ "grt", function() require("mini.extra").pickers.lsp({ scope = "type_definition" }) end, desc = "Type def",       buffer = ev.buf },
			{ "gO",  function() require("mini.extra").pickers.lsp({ scope = "document_symbol" }) end, desc = "Symbols",        buffer = ev.buf },
		})
	end,
})