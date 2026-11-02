-- cloak.nvim: overlays sensitive values with '*' so nothing leaks while
-- streaming. Purely visual: the buffer text is never modified, only covered
-- with extmarks, so yanks/copies still give you the real value.
--
-- Two cloak.nvim quirks this config works around:
--   1. M.cloak() clears the buffer namespace before applying a pattern entry,
--      so entries matching the same file do NOT stack - the last matching
--      entry wins. Generic entries therefore go first, specific ones last.
--   2. Patterns are Lua patterns: no alternation, no {n,m}, no (?i). Key names
--      are generated in both lower and UPPER case instead.
return {
	"laytan/cloak.nvim",
	config = function()
		-- Key names whose value must never be visible: `key = value`,
		-- `key: value` and the JSON `"key": "value"` form.
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

		-- Tokens with a recognisable prefix - safe to cloak in any file, since
		-- a false positive only costs a few stars.
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

		-- Anything with a token shape gets cloaked even in source code and
		-- docs, so a key pasted into a comment cannot leak.
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

		require("cloak").setup({
			enabled = true,
			cloak_character = "*",
			highlight_group = "Comment",
			-- cloak_length would hide the real length too, but the plugin
			-- mis-renders when it exceeds the underlying text, so leave nil.
			try_all_patterns = true,
			cloak_telescope = false, -- no telescope in this config
			cloak_on_leave = false,
			patterns = {
				-- 1. generic: token shapes in code and prose
				{ file_pattern = code_files, cloak_pattern = token_patterns },
				-- 2. shell: only secret-looking keys, so `count=0` stays readable
				{
					file_pattern = shell_files,
					cloak_pattern = with_tokens(value_patterns),
				},
				-- 3. config / credentials: any secret-looking key
				{
					file_pattern = config_files,
					cloak_pattern = with_tokens(value_patterns),
				},
				-- 4. env files: blanket, every value after `=`
				{
					file_pattern = env_files,
					cloak_pattern = with_tokens({ { "=.+" } }),
				},
				-- 5. private keys / certs / vpn profiles: hide the whole file
				{
					file_pattern = key_files,
					cloak_pattern = { { "^(..*)$", replace = "" } },
				},
			},
		})

		-- Streaming helpers: `<leader>cc` hides/unhides everything, `<leader>cp`
		-- temporarily reveals the line under the cursor (re-cloaked on move).
		vim.keymap.set("n", "<leader>cc", "<cmd>CloakToggle<cr>", { desc = "Cloak: toggle" })
		vim.keymap.set("n", "<leader>cp", "<cmd>CloakPreviewLine<cr>", { desc = "Cloak: preview line" })
	end,
}
