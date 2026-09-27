# Floorp (Firefox fork)

Browser: **Floorp** (AUR `floorp-bin`). Profile-based configuration.

> **Note**: `floorp.overrides.cfg` is inert — Floorp 156+ dropped the cfg loader. Prefs live in the profile's `user.js`.

## Configuration

Active profile: `~/.floorp/7r0gw7l8.default-default/user.js` (36 prefs).

| Feature | Pref / Notes |
|---------|-------------|
| Vertical Tabs | `sidebar.verticalTabs = true`. Toggle sidebar with Ctrl+B. |
| Session Restore | Restores tabs after restart/crash. Tabs load on click (`restore_on_demand`). |
| Ctrl+Tab | MRU tab order (`ctrlTab.recentlyUsedOrder`). |
| Close warning | Warns on close of multi-tab / quit (`tabs.warnOnClose*`). |
| Container Tabs | Disabled (`privacy.userContext.enabled = false`). |
| Font | Ubuntu (serif/sans-serif) + Ubuntu Mono |
| WebGL | Always enabled (`webgl.force-enabled`, `webgl.enable-webgl2`). |
| Hardware Video | VA-API decode (Intel). AV1 forced off — Tiger Lake has no hw AV1. |
| Telemetry | Disabled (`toolkit.telemetry.enabled = false`). |

Apply: edit `user.js`, restart Floorp. Managed by chezmoi on new machines.

## Spell-check dictionaries

Install manually from AMO: [Arabic](https://addons.mozilla.org/search/?q=arabic+dictionary), [French](https://addons.mozilla.org/search/?q=french+dictionary), [German](https://addons.mozilla.org/search/?q=german+dictionary).

## Extensions

Installed via extension manager / AMO. State lives in `extensions.json` / `storage.js` in the profile.

| Extension | Purpose / Config |
|-----------|------------------|
| uBlock Origin | Ad/tracker blocker. Filters: EasyList, EasyPrivacy, Peter Lowe, uBlock filters, Annoyances. Custom: `\|\|googletagmanager.com^`, `\|\|google-analytics.com^`. No cosmetic exceptions. |
| SponsorBlock | Skip YouTube sponsors/intros/outros/interactions. Auto-skip on. `→` skip, `←` back. |
| Bitwarden | Password manager. Vault timeout: never (lock with system). Auto-fill on load. Base-domain URI match. TOTP auto-copy. Biometric unlock. |
| Unhook | YouTube cleanup. Hide: shorts, related, comments, live chat, playlists, shelf, "watch next", "more from", "people also watched". Force theater mode, disable autoplay. |
| Auto Tab Discard | Discard tabs after 10 min idle. Whitelist: pinned, audio, forms, `*://mail.*`, `*://calendar.*`, `*://github.com/*`. Restore on click. |
| Gemini Voyager | Google Gemini sidebar panel (Ctrl+Shift+Y). Auto-hide on blur. Context menu "Send to Gemini". Streaming. |
| Firefox Color | Theme: Rose Pine. base `#191724`, surface `#1f1d2e`, overlay `#26233a`, muted `#6e6a86`, subtle `#908caa`, text `#e0def4`, love `#eb6f92`, gold `#f6c177`, rose `#ebbcba`, pine `#31748f`, foam `#9ccfd8`, iris `#c4a7e7`. |
| LanguageTool | Grammar & style checker. Inline suggestions in text fields. |

### Repo files

- `dot_config/floorp/floorp/floorp.overrides.cfg` — **reference only** (inert; kept for history).
- Profile `user.js` is machine-local (installed via profile setup, not tracked in repo).