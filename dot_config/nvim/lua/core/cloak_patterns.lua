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
--      are generated in both lower and UPPER case instead.
local M = {}

-- Key names whose value must never be visible: `key = value`, `key: value`
-- and the JSON `"key": "value"` form.
local secret_keys = {
	"password",
	"passwd",
	"passphrase",
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
	"_authtoken", -- .npmrc / .pypirc, matched before the generic token
	"credentials",
	"connection_string",
	"database_url",
	"db_password",
	"root_password",
	"dsn",
}

local function key_value_patterns(keys)
	local out = {}
	for _, key in ipairs(keys) do
		for _, name in ipairs({ key, key:upper() }) do
			out[#out + 1] = { "(" .. name .. "%s*[:=]%s*).+", replace = "%1" }
			out[#out + 1] = { '("' .. name .. '"%s*:%s*).+', replace = "%1" }
		end
	end
	return out
end

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
	"SG%.[%w_%-]+%.[%w_%-]+", -- SendGrid key
	"eyJ[%w_%-]+%.[%w_%-]+%.[%w_%-]+", -- JWT
	"%d+:AA[%w_%-]+", -- Telegram bot token
	{ "(%f[%w]Bearer%s+)[%w%-%._~+/]+=*", replace = "%1" }, -- Authorization: Bearer
	{ "([Cc]ookie%s*:%s*).+", replace = "%1" }, -- Cookie / Set-Cookie
	{ "(discord%.com/api/webhooks/%d+/)[%w_%-]+", replace = "%1" }, -- Discord webhook token
}

-- `key: value` style, plus credentials embedded in URLs.
local value_patterns = key_value_patterns(secret_keys)
vim.list_extend(value_patterns, {
	-- postgres://user:PASSWORD@host/db -> keeps scheme, user and '@'
	{ "(://[^:%s/]+:)([^@%s]+)(@)", replace = "%1%3" },
	{ "([Pp]assword%s+).+", replace = "%1" }, -- .netrc style
	{ "([Aa]uthorization%s*:%s*).+", replace = "%1" },
	{ "([Pp]rivate%-?[Kk]ey%s*[:=]%s*).+", replace = "%1" },
	-- Azure SAS token: ...?sv=...&sig=SECRET
	{ "([Ss]ig=)[%w%%%+/=]+", replace = "%1" },
	-- AWS presigned URL: ...&X-Amz-Signature=SECRET
	{ "([Xx]%-[Aa]mz%-[Ss]ignature=)[%w]+", replace = "%1" },
})

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

-- Source code and docs: token patterns only. Config extensions are
-- deliberately absent here so the specific entries below win.
local code_files = {
	"*.lua",
	"*.py",
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
	"*.rst",
	"*.adoc",
	"*.tex",
	"*.html",
	"*.css",
	"*.scss",
	"*.nix",
	"*.mk",
	"Makefile",
	"dockerfile",
	"Dockerfile",
}

-- Ordered: generic first, specific last (last matching entry wins).
M.patterns = {
	-- 1. generic: token shapes in code and prose
	{ file_pattern = code_files, cloak_pattern = token_patterns },
	-- 2. shell: only secret-looking keys, so `count=0` stays readable
	{ file_pattern = shell_files, cloak_pattern = with_tokens(value_patterns) },
	-- 3. config / credentials: any secret-looking key
	{ file_pattern = config_files, cloak_pattern = with_tokens(value_patterns) },
	-- 4. env files: blanket, every value after `=`
	{ file_pattern = env_files, cloak_pattern = with_tokens({ { "=.+" } }) },
	-- 5. private keys / certs / vpn profiles: hide the whole file
	{ file_pattern = key_files, cloak_pattern = { { "^(..*)$", replace = "" } } },
}

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
function M.spans(line, patterns)
	local out, pos = {}, 1
	while pos <= #line do
		local first, last, chosen, has_capture
		for _, inner in ipairs(patterns) do
			local f, l, cap = line:find(inner[1], pos)
			if f and (not first or f < first or (f == first and l > last)) then
				first, last, chosen, has_capture = f, l, inner, cap ~= nil
			end
		end
		if not first then
			break
		end
		local whole = line:sub(first, last)
		local prefix
		if has_capture and chosen.replace then
			prefix = whole:gsub(chosen[1], chosen.replace, 1)
		else
			prefix = whole:sub(1, 1)
		end
		-- Longest common prefix/suffix between the match and its visible form
		-- leaves exactly the hidden bytes (`%1%3` reorders, so this can be in
		-- the middle of the match).
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
	local patterns = M.patterns_for(vim.api.nvim_buf_get_name(buf_id))
	if not patterns then
		return table.concat(lines, "\n")
	end
	local out = {}
	for i, line in ipairs(lines) do
		out[i] = M.redact_line(line, patterns)
	end
	return table.concat(out, "\n")
end

function M.cloak_buffer(buf_id, patterns)
	vim.api.nvim_buf_clear_namespace(buf_id, ns, 0, -1)
	local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
	for row, line in ipairs(lines) do
		for _, span in ipairs(M.spans(line, patterns)) do
			vim.api.nvim_buf_set_extmark(buf_id, ns, row - 1, span.first - 1, {
				hl_mode = "combine",
				virt_text = { { span.text, require("cloak").opts.highlight_group } },
				virt_text_pos = "overlay",
			})
		end
	end
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
	local patterns = M.patterns_for(head:match("^([^%z]*)%z"))
	if not patterns then
		return item
	end
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
