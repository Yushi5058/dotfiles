-- Pattern definitions and redaction helpers for cloak.nvim.
--
-- Kept out of the plugin spec so the mini.pick integration (which needs the
-- same patterns over plain strings and over a preview scratch buffer) can
-- reuse them, and so they can be exercised from a headless test.
--
-- Two cloak.nvim quirks drive the layout below:
--   1. M.cloak() clears the buffer namespace before applying a pattern entry,
--      so entries matching the same file do NOT stack - the last matching
--      entry wins. Generic entries therefore go first, specific ones last.
--   2. Patterns are Lua patterns: no alternation, no {n,m}, no (?i). Key names
--      are matched after normalization instead of generating every spelling.
local M = {}

-- Key names whose value must never be visible. Matching is done on the
-- normalized name (lowercase, separators removed), so `api_key`, `API_KEY`,
-- `apiKey`, `ApiKey` and `X-Api-Key` all resolve to `apikey`. A suffix match
-- additionally catches prefixed names such as `my_token` or `csrf_token`.
local secret_keys = {
	"password",
	"passwd",
	"passphrase",
	"passcode",
	"pwd",
	"secret",
	"client_secret",
	"api_key",
	"apikey",
	"api_secret",
	"private_key",
	"signing_key",
	"encryption_key",
	"master_key",
	"access_key",
	"access_key_id",
	"secret_key",
	"secret_access_key",
	"account_key", -- Azure storage
	"auth_token",
	"access_token",
	"refresh_token",
	"session_token",
	"sas_token",
	"token",
	"_authtoken", -- .npmrc / .pypirc
	"credential",
	"credentials",
	"connection_string",
	"database_url",
	"db_password",
	"root_password",
	"cookie",
	"jwt",
	"salt",
	"nonce",
	"bearer",
	"webhook",
	"webhook_url",
	"dsn",
	"authorization", -- Authorization: Bearer/Basic ...
}

local secret_key_set = {}
for _, key in ipairs(secret_keys) do
	secret_key_set[key:lower():gsub("[^%w]", "")] = true
end

local secret_suffixes = {
	"password",
	"passwd",
	"passphrase",
	"passcode",
	"pwd",
	"secret",
	"token",
	"apikey",
	"accesskey",
	"privatekey",
	"secretkey",
	"credential",
	"credentials",
	"cookie",
	"jwt",
	"salt",
	"nonce",
	"webhook",
	"dsn",
	"signature",
}

local function is_secret_key(name)
	local norm = name:lower():gsub("[^%w]", "")
	if norm == "" then
		return false
	end
	if secret_key_set[norm] then
		return true
	end
	local singular = norm:sub(-1) == "s" and norm:sub(1, -2) or norm
	local undecorated = norm:gsub("%d+$", "")
	local undecorated_singular = undecorated:sub(-1) == "s" and undecorated:sub(1, -2) or undecorated
	for _, suffix in ipairs(secret_suffixes) do
		if
			norm:sub(-#suffix) == suffix
			or singular:sub(-#suffix) == suffix
			or undecorated:sub(-#suffix) == suffix
			or undecorated_singular:sub(-#suffix) == suffix
		then
			return true
		end
	end
	return false
end

-- One pattern for `key = value` / `key: value` and one for JSON `"key": value`.
-- The key is validated with `is_secret_key`, so `count = 0` stays readable
-- while `TOKEN = "..."` is hidden even when the value has no token prefix.
local key_patterns = {
	{ "([%w_%-]+)(%s*[:=]%s*)", secret_keys = true, to_eol = true },
	{ '"(.-)"(%s*:%s*)', secret_keys = true, to_eol = true },
}

-- Tokens with a recognisable prefix - safe to cloak in any file, since a false
-- positive only costs a few stars.
local token_patterns = {
	"AKIA[%u%d]+", -- AWS access key id
	"ASIA[%u%d]+", -- AWS temporary access key id
	"gh[pousr]_[%w]+", -- GitHub classic tokens
	"github_pat_[%w_]+", -- GitHub fine-grained tokens
	"glpat%-[%w_%-]+", -- GitLab personal access token
	"xox[abposr]%-[%w%-]+", -- Slack tokens
	"%f[%w]sk%-[%w%-_]+", -- OpenAI / Anthropic keys
	"sk_live_[%w]+", -- Stripe secret key
	"rk_live_[%w]+", -- Stripe restricted key
	"AIza[%w_%-]+", -- Google API key
	"npm_[%w]+", -- npm token
	"pypi%-[%w_%-]+", -- PyPI token
	"hf_[%w]+", -- Hugging Face token
	"gsk_[%w]+", -- Groq API key
	"xai%-[%w]+", -- xAI API key
	"pplx%-[%w]+", -- Perplexity API key
	"r8_[%w]+", -- Replicate API token
	"sbp_[%w]+", -- Supabase access token
	"shpat_[%w]+", -- Shopify admin API token
	"dop_v1_[%w]+", -- Doppler token
	"lin_api_[%w]+", -- Linear API key
	"SG%.[%w_%-]+%.[%w_%-]+", -- SendGrid key
	"eyJ[%w_%-]+%.[%w_%-]+%.[%w_%-]+", -- JWT
	"%d+:AA[%w_%-]+", -- Telegram bot token
	{ "(%f[%w]Bearer%s+)[%w%-%._~+/]+=*", replace = "%1" }, -- Authorization: Bearer
	{ "([Cc]ookie%s*:%s*).+", replace = "%1" }, -- Cookie / Set-Cookie
	{ "(discord%.com/api/webhooks/%d+/)[%w_%-]+", replace = "%1" }, -- Discord webhook token
}

-- cloak.nvim keeps the first character of a capture-less match visible. An
-- empty replacement hides the whole token instead, so a pasted `ghp_...` does
-- not leak its first character. (A leading capture such as `(%s*)` would work
-- too, but it makes the matcher retry at every byte position, which is ~10x
-- slower on large buffers.)
for i, pattern in ipairs(token_patterns) do
	if type(pattern) == "string" then
		token_patterns[i] = { pattern, replace = "" }
	end
end

-- `key: value` style is handled by `key_patterns`; these cover credentials
-- embedded in URLs and other shapes that are not a key/value pair.
local value_patterns = {
	-- postgres://user:PASSWORD@host/db -> keeps scheme, user and '@'
	{ "(://[^:%s/]+:)([^%s/]+)(@)", replace = "%1%3" },
	{ "([Pp]assword%s+)([^=:].*)", replace = "%1" }, -- .netrc style
	-- Azure SAS token: ...?sv=...&sig=SECRET
	{ "([Ss]ig=)[%w%%%+/=]+", replace = "%1" },
	-- AWS presigned URL: ...&X-Amz-Signature=SECRET
	{ "([Xx]%-[Aa]mz%-[Ss]ignature=)[%w]+", replace = "%1" },
}
vim.list_extend(value_patterns, key_patterns)

-- Anything with a token shape gets cloaked even in source code and docs, so a
-- key pasted into a comment cannot leak.
local function with_tokens(list)
	local merged = vim.deepcopy(token_patterns)
	vim.list_extend(merged, list)
	return merged
end

local env_files = { ".env", ".env.*", "*.env", "*.env.*", ".envrc", "*.envrc" }

local key_files = {
	"id_rsa",
	"id_dsa",
	"id_ecdsa",
	"id_ed25519",
	"*.pem",
	"*.key",
	"*.ppk",
	"*.p12",
	"*.pfx",
	"*.ovpn",
	"*.asc",
	"*.gpg",
	"*.kdbx",
}

local config_files = {
	"*.yml",
	"*.yaml",
	"*.json",
	"*.jsonc",
	"*.toml",
	"*.ini",
	"*.cfg",
	"*.conf",
	"*.properties",
	"*.tf",
	"*.tfvars",
	"*.tfvars.json",
	"*.tfstate",
	"*.hcl",
	"*.xml",
	"credentials",
	"config",
	"kubeconfig",
	"hosts.yml",
	".netrc",
	".npmrc",
	".pypirc",
	".git-credentials",
	".htpasswd",
	"htpasswd",
}

local shell_files = {
	"*.sh",
	"*.bash",
	"*.zsh",
	"*.fish",
	"*.ps1",
	".bashrc",
	".bash_profile",
	".zshrc",
	".zprofile",
	".zshenv",
	".zlogin",
	".profile",
}

-- Source code and docs: token shapes plus secret-key assignments and
-- credentials embedded in URLs. Generic keys (`count = 0`) stay readable
-- because only the names in `secret_keys` are matched; a pasted token under
-- `TOKEN`/`API_KEY`/`password` is hidden even without a recognisable prefix.
local code_files = {
	"*.lua",
	"*.py",
	"*.pyi",
	"*.ipynb",
	"*.js",
	"*.mjs",
	"*.cjs",
	"*.ts",
	"*.tsx",
	"*.jsx",
	"*.vue",
	"*.svelte",
	"*.go",
	"*.rs",
	"*.c",
	"*.h",
	"*.cpp",
	"*.hpp",
	"*.cc",
	"*.cs",
	"*.java",
	"*.kt",
	"*.kts",
	"*.php",
	"*.rb",
	"*.pl",
	"*.sql",
	"*.md",
	"*.txt",
	"*.log",
	"*.rst",
	"*.adoc",
	"*.tex",
	"*.html",
	"*.css",
	"*.scss",
	"*.nix",
	"*.mk",
	"*.http",
	"*.rest",
	"*.hurl",
	"*.dart",
	"*.scala",
	"*.gradle",
	"*.groovy",
	"*.proto",
	"*.graphql",
	"*.gql",
	"*.r",
	"*.R",
	"*.jl",
	"*.ex",
	"*.exs",
	"*.erl",
	"*.hrl",
	"*.hs",
	"*.clj",
	"*.cljs",
	"*.cljc",
	"*.edn",
	"*.zig",
	"*.swift",
	"*.m",
	"*.mm",
	"Makefile",
	"dockerfile",
	"Dockerfile",
}

-- Ordered: generic first, specific last (last matching entry wins).
M.patterns = {
	-- 1. code and prose: token shapes plus secret-key assignments
	{ file_pattern = code_files, cloak_pattern = with_tokens(value_patterns) },
	-- 2. shell: only secret-looking keys, so `count=0` stays readable
	{ file_pattern = shell_files, cloak_pattern = with_tokens(value_patterns) },
	-- 3. config / credentials: any secret-looking key
	{ file_pattern = config_files, cloak_pattern = with_tokens(value_patterns) },
	-- 4. env files: blanket, every value after `=`
	{ file_pattern = env_files, cloak_pattern = with_tokens({ { "=.+" } }) },
	-- 5. private keys / certs / vpn profiles: hide the whole file
	{ file_pattern = key_files, cloak_pattern = { { "^(.*)$", replace = "" } } },
}

-- Floats (LSP hover, signature help, diagnostics) are not files, so there is no
-- path to match. Use the config-level set: token shapes plus secret-looking
-- keys. A false positive only costs a few stars.
M.float_patterns = with_tokens(value_patterns)

local ns = vim.api.nvim_create_namespace("cloak")

-- Last matching entry wins, mirroring the autocmd order created by setup().
function M.patterns_for(path)
	if type(path) ~= "string" or path == "" then
		return nil
	end
	local base = vim.fn.fnamemodify(path, ":t")
	if base == "" then
		return nil
	end
	local found
	for _, entry in ipairs(require("cloak").opts.patterns) do
		local file_patterns = entry.file_pattern
		if type(file_patterns) == "string" then
			file_patterns = { file_patterns }
		end
		for _, file_pattern in ipairs(file_patterns) do
			if vim.fn.match(base, vim.fn.glob2regpat(file_pattern)) ~= -1 then
				found = entry.cloak_pattern
				break
			end
		end
	end
	return found
end

-- Same "earliest match, longest wins" scan cloak uses, but over a plain string
-- so it can be applied to picker items. Returns the byte range of the *hidden*
-- part only, plus the replacement text: cloak keeps the first character of a
-- capture-less match visible, and a `replace` prefix is kept as-is, so the
-- stars are placed where the secret actually was.
local function find_entry(line, entry, pos)
	local start = pos
	while true do
		local first, last, capture = line:find(entry[1], start)
		if not first then
			return nil
		end
		if not entry.secret_keys or is_secret_key(capture or "") then
			return first, last, capture
		end
		-- Not a secret key: resume after the separator so the same key is not
		-- matched again character by character.
		start = last + 1
	end
end

function M.spans(line, patterns)
	local out, pos = {}, 1
	while pos <= #line do
		local first, last, chosen
		for _, inner in ipairs(patterns) do
			-- cloak.setup() normalizes string entries to tables, but
			-- `M.float_patterns` is built from the locals and stays mixed.
			local pat = type(inner) == "string" and { inner } or inner
			local f, l = find_entry(line, pat, pos)
			if f and (not first or f < first or (f == first and l > last)) then
				first, last, chosen = f, l, pat
			end
		end
		if not first then
			break
		end
		if chosen.to_eol then
			-- The pattern ends at the separator; hide everything after it.
			local hidden_start = last + 1
			local hidden = vim.fn.strchars(line:sub(hidden_start))
			if hidden > 0 then
				out[#out + 1] = { first = hidden_start, last = #line, text = string.rep("*", hidden) }
			end
			pos = #line + 1
		else
			local whole = line:sub(first, last)
			local prefix
			if chosen.replace ~= nil then
				prefix = whole:gsub(chosen[1], chosen.replace, 1)
			else
				prefix = whole:sub(1, 1)
			end
			-- Longest common prefix/suffix between the match and its visible
			-- form leaves exactly the hidden bytes (`%1%3` reorders, so this
			-- can be in the middle of the match).
			local common_prefix = 0
			local max_prefix = math.min(#whole, #prefix)
			while common_prefix < max_prefix and whole:byte(common_prefix + 1) == prefix:byte(common_prefix + 1) do
				common_prefix = common_prefix + 1
			end
			local common_suffix = 0
			local max_suffix = math.min(#whole - common_prefix, #prefix - common_prefix)
			while
				common_suffix < max_suffix
				and whole:byte(#whole - common_suffix) == prefix:byte(#prefix - common_suffix)
			do
				common_suffix = common_suffix + 1
			end
			local hidden_start = first + common_prefix
			local hidden_last = last - common_suffix
			local hidden = vim.fn.strchars(line:sub(hidden_start, hidden_last))
			if hidden > 0 then
				out[#out + 1] = { first = hidden_start, last = hidden_last, text = string.rep("*", hidden) }
			end
			pos = last + 1
		end
	end
	return out
end

function M.redact_line(line, patterns)
	local parts, pos = {}, 1
	for _, span in ipairs(M.spans(line, patterns)) do
		parts[#parts + 1] = line:sub(pos, span.first - 1)
		parts[#parts + 1] = span.text
		pos = span.last + 1
	end
	parts[#parts + 1] = line:sub(pos)
	return table.concat(parts)
end

-- Redacted text for a 1-based inclusive line range of `buf_id`, joined with
-- newlines so it can go straight into a register. Used by the `<leader>cy`
-- clipboard mapping: a cloaked line still yanks its real value otherwise.
function M.redact_lines(buf_id, first, last)
	local lines = vim.api.nvim_buf_get_lines(buf_id, first - 1, last, false)
	-- Unnamed scratch buffers have no path, so no file pattern can match; fall
	-- back to the generic set instead of copying the raw line.
	local patterns = M.patterns_for(vim.api.nvim_buf_get_name(buf_id)) or M.float_patterns
	local out = {}
	for i, line in ipairs(lines) do
		out[i] = M.redact_line(line, patterns)
	end
	return table.concat(out, "\n")
end

function M.cloak_buffer(buf_id, patterns, skip_line)
	vim.api.nvim_buf_clear_namespace(buf_id, ns, 0, -1)
	local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
	local found = false
	for row, line in ipairs(lines) do
		if row ~= skip_line then
			for _, span in ipairs(M.spans(line, patterns)) do
				found = true
				vim.api.nvim_buf_set_extmark(buf_id, ns, row - 1, span.first - 1, {
					hl_mode = "combine",
					virt_text = { { span.text, require("cloak").opts.highlight_group } },
					virt_text_pos = "overlay",
				})
			end
		end
	end
	return found
end

-- Cloak a floating window's buffer. Hover/signature/diagnostic floats are
-- `nofile` scratch buffers with no path, so `M.float_patterns` is used.
function M.cloak_floating(win_id)
	win_id = win_id or vim.api.nvim_get_current_win()
	if not vim.api.nvim_win_is_valid(win_id) then
		return
	end
	if vim.api.nvim_win_get_config(win_id).relative == "" then
		return
	end
	M.cloak_buffer(vim.api.nvim_win_get_buf(win_id), M.float_patterns)
end

-- LSP sets the float buffer contents before opening the window, and an existing
-- hover float can be updated in place (`_update_win`) without a BufWinEnter, so
-- wrap the one function every LSP float goes through.
function M.patch_lsp_floats()
	if M._lsp_floats_patched then
		return
	end
	M._lsp_floats_patched = true

	local open = vim.lsp.util.open_floating_preview
	vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
		local buf_id, win_id = open(contents, syntax, opts)
		if win_id and vim.api.nvim_win_is_valid(win_id) then
			M.cloak_floating(win_id)
		end
		return buf_id, win_id
	end
end

-- Cover floats not created through the LSP helper (diagnostic plugins, custom
-- UI). WinEnter is too late for unfocused floats, so use BufWinEnter and look up
-- the window displaying the buffer.
function M.watch_floats()
	local group = vim.api.nvim_create_augroup("CloakFloats", { clear = true })
	vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
		group = group,
		callback = function(args)
			if args.event == "BufWinEnter" then
				local win_id = vim.fn.bufwinid(args.buf)
				if win_id ~= -1 then
					M.cloak_floating(win_id)
				end
			else
				M.cloak_floating()
			end
		end,
	})
end

-- mini.pick items are `path\0lnum\0col\0text` strings; redact the text part.
function M.redact_item(item)
	if type(item) ~= "string" then
		return item
	end
	local head, text = item:match("^(.*%z)(.*)$")
	if not head then
		return item
	end
	local patterns = M.patterns_for(head:match("^([^%z]*)%z")) or M.float_patterns
	return head .. M.redact_line(text, patterns)
end

-- Path behind a picker item: file items are strings, buffer items are tables.
function M.item_path(item)
	if type(item) == "table" then
		local buf = item.bufnr or item.buf_id or item.buf
		if type(buf) == "number" and vim.api.nvim_buf_is_valid(buf) then
			return vim.api.nvim_buf_get_name(buf)
		end
		return item.path
	end
	if type(item) ~= "string" then
		return nil
	end
	return item:match("^(.-)%z") or item
end

-- cloak only patches telescope's previewer, so a mini.pick grep list and its
-- preview buffer would render secrets verbatim. Patch both entry points.
function M.patch_minipick()
	local ok, mp = pcall(require, "mini.pick")
	if not ok or type(mp) ~= "table" or mp._cloak_patched then
		return ok
	end
	mp._cloak_patched = true

	local set_items = mp.set_picker_items
	mp.set_picker_items = function(items, opts)
		if type(items) == "table" then
			local redacted = {}
			for i = 1, #items do
				redacted[i] = M.redact_item(items[i])
			end
			items = redacted
		end
		return set_items(items, opts)
	end

	local preview = mp.default_preview
	mp.default_preview = function(buf_id, item, opts)
		preview(buf_id, item, opts)
		-- Clear first: the preview buffer is reused, so marks from a previous
		-- (cloaked) item must not survive a switch to a harmless one.
		vim.api.nvim_buf_clear_namespace(buf_id, ns, 0, -1)
		local patterns = M.patterns_for(M.item_path(item))
		if patterns then
			M.cloak_buffer(buf_id, patterns)
		end
	end

	return true
end

return M
