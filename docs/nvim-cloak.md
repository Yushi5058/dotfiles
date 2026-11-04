# Neovim secret redaction (cloak.nvim)

`cloak.nvim` overlays sensitive values with `*` using extmarks. The buffer text
is never modified, so a plain yank still copies the real value. Use
`<leader>cy` to copy a line or selection with the same redaction applied.

Config lives in `dot_config/nvim/lua/core/plugins/cloak.lua` and the patterns
in `dot_config/nvim/lua/core/cloak_patterns.lua`.

## What is hidden

| File class | Behaviour |
| --- | --- |
| Code and prose (`*.py`, `*.js`, `*.md`, `*.http`, …) | Token shapes, secret-key assignments, URL credentials |
| Shell (`*.sh`, `.zshrc`, …) | Secret-key assignments only, so `COUNT=0` stays readable |
| Config (`*.json`, `*.yaml`, `*.toml`, `.npmrc`, …) | Token shapes and secret-key assignments |
| Env (`.env`, `*.env`, `.envrc`) | Every value after `=` |
| Keys and certs (`id_rsa`, `*.pem`, `*.key`, `*.ovpn`, …) | Whole file, including single-character lines |

Floating windows (LSP hover, signature help, diagnostics) and mini.pick grep
results/previews are redacted with the generic token + secret-key set.

## Key matching

Key names are normalized (lowercase, separators removed) and checked against a
secret list plus a suffix list. This makes all common spellings match without
generating a pattern per variant:

- `api_key`, `API_KEY`, `apiKey`, `ApiKey`, `X-Api-Key` → `apikey`
- `my_token`, `csrf_token`, `TOKEN_1` → suffix `token`
- `client-secret`, `client_secret` → suffix `secret`

Assignments (`key = value`, `key: value`) and the JSON `"key": "value"` form
hide everything after the separator on that line. Generic keys stay visible:
`count = 0`, `tokenizer = "x"`, `normal = "hello"`.

Token shapes are hidden even without a key, for example AWS, GitHub, GitLab,
Slack, OpenAI/Anthropic, Stripe, Google, npm, PyPI, Hugging Face, Groq, xAI,
Perplexity, Replicate, Supabase, Shopify, Doppler, Linear, SendGrid, JWT,
Telegram, Bearer and Discord webhook tokens.

## External changes

Edits made inside Neovim are re-cloaked by the plugin's `TextChanged` and
`TextChangedI` autocmds. Files can also change on disk without a buffer edit:
AI agents, formatters, `git checkout`, and other editors write the file
directly. `cloak_patterns.watch_files()` attaches a libuv `fs_event` watcher to
every loaded buffer that matches a cloak pattern. When the file changes it
debounces the event, reloads the buffer with `:checktime` if there are no
unsaved edits, and re-cloaks the new contents. Atomic saves (write to a
temporary file, then rename) re-arm the watcher on the new inode. Watchers are
removed on `BufUnload`, `BufDelete`, and `BufWipeout`.

## Performance

Upstream `cloak.nvim` rescans every pattern at every byte position and calls
`vim.fn` helpers inside that loop. With a broad secret-key set that took about
1 s on a 2000-line file. `plugins/cloak.lua` replaces `cloak.cloak` with the
shared pure-Lua scanner from `cloak_patterns.lua`; the same file takes about
55 ms and produces identical spans. The scanner is also used by `<leader>cy`,
LSP floats and the mini.pick patch.

## Known limits

- Redaction is visual. Plain yanks and external tools still see the real text.
- A secret-key assignment hides the rest of the line, including a trailing
  comment.
- Suffix matching can over-redact a harmless name such as `tokens = 42`; a false
  positive only costs stars.
- Tokens without a known prefix and without a secret-looking key are not
  detected.
