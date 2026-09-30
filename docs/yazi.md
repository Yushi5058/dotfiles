# Yazi reference

Terminal file manager. Config: `~/.config/yazi/{yazi,keymap,theme}.toml` + `init.lua`.
Interactive keybind help: press `~` (or `F1`) inside yazi, browse with `j`/`k`, `Enter` to run.

## Custom keybindings (keymap.toml)

| Keys | Action |
|---|---|
| `l` | smart-enter: enter child dir, or open file if it's a file |
| `M` | mount: mount/unmount drives |
| `F` | smart-filter: interactive filtering |
| `c` `m` | chmod on selected files |
| `C` | compress/extract with ouch |
| `c` `p` | pandoc: interactive format conversion |
| `~` | help overlay (same as default) |

Note: custom `l` overrides the default `enter` binding (which it wraps).

## Navigation & selection

| Keys | Action |
|---|---|
| `h` / `l` | parent dir / enter child (default; `l` is smart-enter here) |
| `j` / `k` | next / previous file |
| `g` `g` / `G` | top / bottom |
| `H` / `L` | back / forward in directory history |
| `<C-u>` / `<C-d>` | cursor up / down half page |
| `<C-b>` / `<C-f>` | cursor up / down full page |
| `<Home>` / `<End>` | top / bottom |
| `Space` | toggle selection on hovered |
| `<C-a>` | select all |
| `<C-r>` | invert selection |
| `v` | enter visual (selection) mode |
| `V` | visual mode (unset) |
| `<Esc>` | exit visual / clear selection / cancel |

## Operations

| Keys | Action |
|---|---|
| `y` | yank (copy) selected files |
| `x` | yank --cut (cut) selected files |
| `Y` / `X` | cancel yank status |
| `p` / `P` | paste (P = force overwrite) |
| `-` / `_` | symlink absolute / relative |
| `<C-->` | hardlink |
| `d` / `D` | trash / permanently delete |
| `a` / `A` | create file / bulk create |
| `r` | rename (cursor before extension) |
| `o` / `O` | open / open interactively |
| `<Enter>` / `<S-Enter>` | open / open interactive |
| `<Tab>` | spot hovered file (preview pane) |
| `w` | show task manager |

## Shell, search & filters

| Keys | Action |
|---|---|
| `;` | run shell command (interactive, non-blocking) |
| `:` | run shell command (blocking) |
| `s` | search files by name via fd |
| `S` | search files by content via ripgrep |
| `<C-s>` | cancel ongoing search |
| `f` | filter files (smart) |
| `/` / `?` | find next / previous |
| `n` / `N` | jump to next / previous found |
| `z` / `Z` | fzf jump / zoxide jump |
| `.` | toggle hidden files |
| `K` / `J` | seek up / down in preview |

## Tabs

| Keys | Action |
|---|---|
| `t` `t` | new tab in CWD |
| `t` `r` | rename current tab |
| `1`-`9` | switch to tab N |
| `[` / `]` | previous / next tab |
| `{` / `}` | swap with previous / next tab |
| `<C-c>` | close current tab (quit if last) |

## Go-to & sorting

| Keys | Action |
|---|---|
| `g` `h` | go home (`~`) |
| `g` `c` | go to `~/.config` |
| `g` `d` | go to `~/Downloads` |
| `g` `t` | go to trash bin |
| `g` `<Space>` | jump interactively |
| `g` `f` | follow hovered symlink |
| `,` `m` / `M` | sort by mtime (or reverse) |
| `,` `s` / `S` | sort by size (or reverse) |
| `,` `a` / `A` | sort alphabetically (or reverse) |
| `,` `e` / `E` | sort by extension (or reverse) |
| `,` `n` / `N` | sort naturally (or reverse) |

## Copy-path shortcuts

| Keys | Action |
|---|---|
| `c` `c` | copy file path |
| `c` `C` | copy file URL |
| `c` `d` / `c` `D` | copy dir path / URL |
| `c` `f` | copy filename |
| `c` `n` | copy filename without extension |

## Misc (defaults)

| Keys | Action |
|---|---|
| `q` / `Q` | quit (Q also skips cwd-file output) |
| `<C-z>` | suspend process |
| `m` `s` / `p` / `b` / `m` / `o` / `n` | linemode: size / perms / btime / mtime / owner / none |

## Openers (yazi.toml)

| Extension | Action |
|---|---|
| archive (`zip`/`tar`/`7z`/`rar`/`xz`/`zstd`/...) | preview via ouch; `C` extracts |
| video/audio | play via mpv |
| `pdf` | zathura |
| text/code | `$EDITOR` |

## Plugins

| Plugin | Purpose |
|---|---|
| `full-border` | rounded borders on all widgets (init.lua) |
| `smart-enter` | `l` = enter dir or open file |
| `mount` | mount/unmount filesystems (`M`) |
| `smart-filter` | interactive filtering (`F`) |
| `chmod` | chmod on selection (`c` `m`) |
| `ouch` | compress/extract archives (`C`), archive previewer |
| `pandoc` | document conversion via pandoc (`c` `p`) |

## Notes

- Config is chezmoi-managed (`dot_config/yazi/` → `~/.config/yazi/`); `package.toml` pins plugin revisions + hashes.
- Stale ya package cache can break `ya pkg install` — `scripts/sync-packages.sh` purges `~/.cache/yazi/packages` and retries.