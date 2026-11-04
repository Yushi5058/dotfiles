# Obscuro — screen-share masking for Floorp

Custom build of [`Yushi5058/obscuro`](https://github.com/Yushi5058/obscuro), a
fork of [`intezer/obscuro`](https://github.com/intezer/obscuro) with Shadow DOM
penetration and attribute masking for SPAs. It masks emails, phone numbers,
tokens, IPs, names, password fields and anything marked `data-sensitive="true"`
while you share your screen.

The fork is a Git submodule of this repo, so the extension source, the PII rules
and the packaged XPI all live together.

## Layout

| Path | Purpose |
|------|---------|
| `scripts/obscuro/src` | Git submodule: `git@github.com:Yushi5058/obscuro.git`, branch `main`. |
| `scripts/obscuro/config.json` | PII rules. Source of truth, copied into the build. |
| `scripts/obscuro/update.sh` | Pull, build, apply rules/manifest, package the XPI. |
| `scripts/obscuro/obscuro-custom.xpi` | Packaged add-on committed to the repo. |
| `scripts/obscuro/test_obscuro.html` | Mock page with every supported data type. |
| `scripts/obscuro/verify-dom.js` | Headless jsdom check of blur and scramble modes. |
| `.chezmoiscripts/run_onchange_after_obscuro-xpi.sh.tmpl` | Rebuilds the XPI when `config.json` changes. |
| `scripts/setup-obscuro.sh` | Legacy upstream-clone builder. Superseded by `update.sh`. |

The submodule is pinned to the commit recorded in the parent repo. Clone it once:

```bash
cd ~/.local/share/chezmoi
git submodule update --init --recursive
```

`.gitmodules` records `branch = main`, so `update.sh` follows `main` by default.
The old `shadow-dom-support` branch was merged into `main` (fast-forward to
`dda163c`); no need to check it out anymore.

## Build and package

```bash
cd ~/.local/share/chezmoi

# Pull the submodule branch, install deps if missing, build, package
./scripts/obscuro/update.sh

# Build the current checkout without touching the network
./scripts/obscuro/update.sh --no-pull

# Rebuild automatically when config.json or the submodule source changes
./scripts/obscuro/update.sh --watch
```

`update.sh` does, in order:

1. `git fetch`, checkout the `.gitmodules` branch (`main`), `pull --ff-only`.
2. `npm install` only when `src/node_modules` is missing.
3. `npm run build` (`tsc && node build.js`) into `src/dist`.
4. Validate `config.json` (JSON shape and every regex compiles).
5. Copy `scripts/obscuro/config.json` to `dist/config.json`.
6. Inject the Gecko block into `dist/manifest.json`:
   `id = obscuro-custom@yushi61.local`, `strict_min_version = 115.0`,
   `data_collection_permissions.required = ["none"]`.
7. Resize the mislabeled upstream 16/48 px icons from `icon128.png`.
8. Zip `dist/*` at the archive root to `scripts/obscuro/obscuro-custom.xpi`.

Builds write only to `src/dist` and `src/node_modules`, both gitignored inside
the submodule, so the gitlink stays clean.

Environment overrides: `OBSCURO_BRANCH` (branch to build) and `OBSCURO_ID`
(Gecko id).

## Changing the rules (automatic rebuild)

Rules are edited in `scripts/obscuro/config.json` only. Never edit
`src/dist/config.json` — it is regenerated on every build.

1. Edit `scripts/obscuro/config.json`.
2. Run `chezmoi apply` (or `./scripts/obscuro/update.sh --watch` while editing).
3. Commit `config.json` together with the rebuilt `obscuro-custom.xpi`, plus the
   `scripts/obscuro/src` pointer if the submodule moved.

Automation: `run_onchange_after_obscuro-xpi.sh.tmpl` embeds the SHA-256 of
`config.json`. Chezmoi runs it only when that hash changes, and it calls
`update.sh --no-pull`. Editing rules and applying is therefore enough to produce
a fresh XPI. The script skips silently when `node`/`npm` are missing.

Current rule set (`version: 2`, 23 selectors, 11 regex):

| Data | Regex / selector |
|------|------------------|
| Name | `\bechakroun01\b`, `\b(?:Elias(?:\s+Chakroun)?|Chakroun)\b` (`gi`) |
| Email | `[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+` (`gi`) |
| Moroccan phone | `(?<!\d)(\+?212\|0)([ \-_/]*)(\d[ \-_/]*){9}(?![ \-_/]*\d)` |
| E.164 phone | `(?<!\w)\+[1-9]\d{6,14}(?!\w)` |
| GitHub token | `\bgh[pousr]_[A-Za-z0-9]{20,255}\b` |
| Stripe live key | `\bsk_live_[A-Za-z0-9]{16,}\b` |
| Bearer token | `\bBearer\s+[A-Za-z0-9._~+/-]{8,}=*` (`gi`) |
| Private IPv4 | `10.x.x.x`, `192.168.x.x`, `172.16–31.x.x` |
| Any IPv4 / IPv6 | Public addresses are masked too |
| Password inputs | `input[type='password']`, `autocomplete=current-password/new-password` |
| Names / profiles | `[autocomplete='name']`, `[autocomplete='given-name']`, `[autocomplete='family-name']`, `.username`, `.user-name`, `.author-name`, `.profile-name`, `.display-name`, `[data-testid*='user-name']`, `[data-testid*='profile-name']` |
| Google account links | `[aria-label*='Google Account']`, `[aria-label*='Compte Google']`, `a[href*='accounts.google.com']` |
| Marked elements | `[data-sensitive='true']`, `.ssn`, `.credit-card`, `.blur`, `.hide` |

`ignore.selectors` and `ignore.regex` keep things like `support@mycompany.com`
and `demo<number>@example.com` visible.

The extension reads `config.json` only when `chrome.storage.sync` is empty. After
a rebuild, use the popup's **Reset** or **Import** action to load the new rules
into an existing install.

## Load in Floorp

Floorp profiles live in `~/.floorp/<profile>/` (not `~/.mozilla/firefox`).
Find the active one in `about:support` → **Profile Directory**, or read
`~/.floorp/profiles.ini`: the `[Install…]` section's `Default=` wins over the
`[Profile…]` `Default=1`. This machine uses
`~/.floorp/7r0gw7l8.default-default/`.

### One-time signature setup

The XPI is self-built and unsigned. Floorp 159 refuses it until signature
enforcement and scope auto-disable are both turned off. Add both prefs to the
active profile's `user.js` (create it if missing):

```js
// ~/.floorp/<profile>/user.js
user_pref("xpinstall.signatures.required", false);
user_pref("extensions.autoDisableScopes", 0);
```

`user.js` is reapplied on every start, so Floorp cannot silently reset them.
With only the signature pref the add-on still loads as `userDisabled`, so keep
both. Restart Floorp after adding them.

### Install from about:addons

1. Build the XPI (see above), or use the committed
   `scripts/obscuro/obscuro-custom.xpi`.
2. Open `about:addons`.
3. Click the gear icon → **Install Add-on From File…**
4. Select `~/.local/share/chezmoi/scripts/obscuro/obscuro-custom.xpi`.
5. Approve **Access your data for all websites**. Without host access the
   content script never runs on normal pages.
6. Click the Obscuro toolbar icon and switch **Enabled / Blur / Scramble**.

### Sideload fallback

If the file picker rejects the unsigned XPI, drop it into the profile and
restart. Sideloaded XPIs are only scanned at startup.

```bash
PROFILE="$HOME/.floorp/7r0gw7l8.default-default"
mkdir -p "$PROFILE/extensions"
cp ~/.local/share/chezmoi/scripts/obscuro/obscuro-custom.xpi \
   "$PROFILE/extensions/obscuro-custom@yushi61.local.xpi"
pkill -x floorp; sleep 2; floorp >/dev/null 2>&1 &
```

The filename must match the Gecko id. After the restart, `about:addons` should
list **Obscuro** as enabled. What a healthy entry looks like in
`<profile>/extensions.json`:

```json
{"id":"obscuro-custom@yushi61.local","version":"1.1.0","active":true,
 "userDisabled":false,"appDisabled":false,"location":"app-profile",
 "signedState":0}
```

`signedState: 0` is expected — the XPI is unsigned.

### Temporary add-on (development)

For quick iteration without repackaging:

```bash
python3 -m http.server 8000 --bind 127.0.0.1 \
  --directory ~/.local/share/chezmoi
```

Open `about:debugging#/runtime/this-firefox` → **Load Temporary Add-on…** →
`scripts/obscuro/src/dist/manifest.json`, then open
<http://127.0.0.1:8000/scripts/obscuro/test_obscuro.html>.

Temporary add-ons disappear when Floorp closes.

## Updating or removing

```bash
cd ~/.local/share/chezmoi

# update: pull main, rebuild, repackage
./scripts/obscuro/update.sh

# reinstall in Floorp
cp scripts/obscuro/obscuro-custom.xpi \
   "$HOME/.floorp/7r0gw7l8.default-default/extensions/obscuro-custom@yushi61.local.xpi"
pkill -x floorp; sleep 2; floorp >/dev/null 2>&1 &

# or from about:addons: remove the old entry, then Install Add-on From File again

# remove: delete the XPI (and optionally the two prefs), restart Floorp
rm "$HOME/.floorp/7r0gw7l8.default-default/extensions/obscuro-custom@yushi61.local.xpi"
```

After pulling new upstream commits, commit the updated `scripts/obscuro/src`
pointer together with the rebuilt XPI.

## Verification

Run the test page through the compiled scripts in jsdom:

```bash
cd ~/.local/share/chezmoi
DOM_TMP=$(mktemp -d)
STAGE=$(mktemp -d)
npm install --prefix "$DOM_TMP" --no-audit --no-fund --silent jsdom@26
cp scripts/obscuro/test_obscuro.html "$STAGE/"
ln -s "$PWD/scripts/obscuro/src/dist" "$STAGE/dist"
NODE_PATH="$DOM_TMP/node_modules" \
  node scripts/obscuro/verify-dom.js "$STAGE"
rm -rf "$DOM_TMP" "$STAGE"
```

Expected output:

```text
blur mode:     {"blurred":25,"censored":18,"scrambled":0,"errors":0}
scramble mode: {"blurred":1,"censored":22,"scrambled":28,"errors":0}
css form-control fallback: present

DOM verification OK
```

It asserts that blur marks text matches, password inputs, `data-sensitive`
inputs and selector targets with `.blurred`; that scramble replaces text and
marks form controls `.scrambled`, keeping the original in
`data-obscuro-original`; that ignore rules stay untouched; and that the
form-control CSS fallback is present.

Lint the packaged extension:

```bash
cd ~/.local/share/chezmoi/scripts/obscuro/src
npx --yes web-ext@8 lint --source-dir dist --output text
```

Expected: `errors 0`, `notices 0`, `warnings 0`.

Check the archive itself — files must be at the root, not inside `dist/`:

```bash
unzip -l ~/.local/share/chezmoi/scripts/obscuro/obscuro-custom.xpi
unzip -p ~/.local/share/chezmoi/scripts/obscuro/obscuro-custom.xpi manifest.json \
  | python3 -m json.tool | head -20
```

Headless smoke test (installs as a temporary add-on):

```bash
python3 -m http.server 8000 --bind 127.0.0.1 \
  --directory ~/.local/share/chezmoi &

npx --yes web-ext@8 run \
  --source-dir ~/.local/share/chezmoi/scripts/obscuro/src/dist \
  --firefox /usr/sbin/floorp \
  --args=--headless \
  --start-url http://127.0.0.1:8000/scripts/obscuro/test_obscuro.html \
  --no-reload --no-input
```

The log should contain
`Installed .../src/dist as a temporary add-on`.

Permanent sideload was verified on Floorp 159: with both prefs the XPI came up
`active:true`, `location:app-profile`, `signedState:0`. With no prefs, or with
only the signature pref, it stayed `userDisabled:true`.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `update.sh` says submodule missing | `git submodule update --init --recursive`. |
| Build fails on a regex | `update.sh` validates every pattern; fix `config.json`, then rerun. |
| Add-on missing from `about:addons` | XPI must be at `<profile>/extensions/obscuro-custom@yushi61.local.xpi` with `manifest.json` at the zip root. Rebuild, then fully restart Floorp. |
| `Install Add-on From File` refuses the XPI | Both prefs from the signature setup are required. Or use the sideload fallback. |
| Listed but disabled / `active:false` | Check both prefs in `user.js`; click **Enable** in `about:addons`; check `about:debugging#/runtime/this-firefox` for a load error. |
| Listed, enabled, nothing masked | Host access not granted, or the tab was already open. Grant **Access your data for all websites** and reload. |
| Toolbar icon missing | `about:addons` → Obscuro → **Pin to toolbar**. |
| Rule changes ignored | `chrome.storage.sync` already holds a config. Popup → **Reset** or **Import** `src/dist/config.json`. |
| XPI not rebuilt after editing `config.json` | Run `chezmoi apply` (hash-gated script), or `./scripts/obscuro/update.sh --no-pull`. |
| Works after temporary load, gone after restart | Expected for `about:debugging`; use the permanent install. |

Signing through AMO (`web-ext sign` with API keys) is the alternative if you do
not want to disable signature checks.

## Notes

- Obscuro masks the rendered page, not devtools, page source, network requests,
  or a terminal window.
- Blur mode leaves the original text in the DOM; scramble mode replaces it.
- Shadow DOM and `aria-label` / `title` / `alt` attributes are handled by the
  fork, so SPA badges (Gemini, Google account chips) are masked too.
- `src/dist/` is the loadable extension directory. Do not serve it as the test
  page.
- The submodule is a fork, not a build workspace: upstream changes are pulled
  into `main`, and this repo only tracks the commit pointer.
