# Obscuro — screen-share masking for Floorp

Local build of [`intezer/obscuro`](https://github.com/intezer/obscuro) configured
for Firefox/Floorp. It masks emails, phone numbers, tokens, IPs, password fields
and anything marked `data-sensitive="true"` while you share your screen.

## Files

| Path | Purpose |
|------|---------|
| `scripts/setup-obscuro.sh` | Clone, install, configure, build, verify, optionally package/serve. |
| `scripts/obscuro/config.json` | Obscuro rule template copied into the clone before every build. |
| `scripts/obscuro/test_obscuro.html` | Mock test page with every supported data type. |
| `scripts/obscuro/verify-dom.js` | Headless jsdom check of blur and scramble modes. |

The clone lives outside the dotfiles repo at `~/src/obscuro` (override with
`OBSCURO_DIR`). The script overwrites the clone's `config.json`, adds the Gecko
manifest block (`id`, `strict_min_version`, `data_collection_permissions`),
normalizes the mislabeled upstream 16/48 px icons from `icon128.png`, appends a
form-control blur fallback to `src/content.css`, and builds into
`~/src/obscuro/dist`.

## Build and verify

```bash
cd ~/.local/share/chezmoi

# Build + manifest/config/regex checks
./scripts/setup-obscuro.sh

# Also run the built content script against the test page in jsdom
./scripts/setup-obscuro.sh --dom

# Also run web-ext lint (0 errors/warnings expected)
./scripts/setup-obscuro.sh --lint

# Also produce ~/src/obscuro/obscuro-firefox.xpi
./scripts/setup-obscuro.sh --package

# Reuse an existing node_modules
./scripts/setup-obscuro.sh --skip-install
```

The build fails unless `dist/` contains `manifest.json`, `config.json`,
`types.js`, `scrambler.js`, `content.js`, `popup.js`, `popup.html`, `popup.css`,
`content.css` and the three icons.

## Load in Floorp

1. Serve the test page:

   ```bash
   python3 -m http.server 8000 --bind 127.0.0.1 --directory ~/src/obscuro
   ```

2. In Floorp open `about:debugging#/runtime/this-firefox`.

3. Click **Load Temporary Add-on…** and select
   `~/src/obscuro/dist/manifest.json`.

4. Open <http://127.0.0.1:8000/test_obscuro.html>.

5. Click the Obscuro toolbar icon to switch **Enabled / Blur / Scramble**.

Temporary add-ons disappear when Floorp closes. Load again after every restart.
If Floorp asks for host access, allow **Access your data for all websites**.

For a permanent install, sign the XPI through AMO or set
`xpinstall.signatures.required=false` in a developer build. The unsigned
`obscuro-firefox.xpi` produced by `--package` is for inspection / signing.

### Headless smoke test

`web-ext` can install the temporary add-on and open the test page without the
GUI. Floorp must accept `--headless`:

```bash
python3 -m http.server 8000 --bind 127.0.0.1 --directory ~/src/obscuro &

npx --yes web-ext@8 run \
  --source-dir ~/src/obscuro/dist \
  --firefox /usr/sbin/floorp \
  --args=--headless \
  --start-url http://127.0.0.1:8000/test_obscuro.html \
  --no-reload --no-input
```

The log should contain:

```text
Installed /home/yushi61/src/obscuro/dist as a temporary add-on
```

Stop it with Ctrl+C; this only proves install + page load. `--dom` checks the
masking behavior.

## Rules

`scripts/obscuro/config.json` is copied to `dist/config.json` on every build.
The extension only reads it the first time `chrome.storage.sync` is empty; after
that use the popup's **Reset** or **Import** action to pick up rule changes.

| Data | Regex / selector |
|------|------------------|
| Email | `[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+` (`gi`) |
| Moroccan phone | `(?<!\d)(\+?212\|0)([ \-_/]*)(\d[ \-_/]*){9}(?![ \-_/]*\d)` |
| E.164 phone | `(?<!\w)\+[1-9]\d{6,14}(?!\w)` |
| GitHub token | `\bgh[pousr]_[A-Za-z0-9]{20,255}\b` |
| Stripe live key | `\bsk_live_[A-Za-z0-9]{16,}\b` |
| Bearer token | `\bBearer\s+[A-Za-z0-9._~+/-]{8,}=*` (`gi`) |
| Private IPv4 | `10.x.x.x`, `192.168.x.x`, `172.16–31.x.x` |
| Any IPv4 / IPv6 | Existing Obscuro patterns (public IPs are masked too) |
| Password inputs | `input[type='password']`, `autocomplete=current-password/new-password` |
| Marked elements | `[data-sensitive='true']`, `.ssn`, `.credit-card`, `.blur`, `.hide` |

Ignore rules keep `support@mycompany.com` and `demo<number>@example.com` visible.
Edit them in the template, then rebuild.

## Verification

`--dom` runs the real test page through `dist/scrambler.js` + `dist/content.js`
in jsdom and asserts:

- blur mode marks text matches, password inputs, `data-sensitive` inputs and
  selector targets with `.blurred`;
- scramble mode replaces text and marks form controls `.scrambled`, with the
  original value kept in `data-obscuro-original` for restore;
- ignore rules stay untouched;
- the form-control CSS fallback is present.

Last local run:

```text
blur mode:     {"blurred":25,"censored":18,"scrambled":0,"errors":0}
scramble mode: {"blurred":1,"censored":22,"scrambled":28,"errors":0}
css form-control fallback: present
DOM verification OK
```

`web-ext lint` on `dist/` reports:

```text
errors          0
notices         0
warnings        0
```

Local smoke test: `web-ext run --firefox /usr/sbin/floorp --args=--headless`
installed `obscuro@yushi61.local` as a temporary add-on and loaded
`http://127.0.0.1:8123/test_obscuro.html` (HTTP 200).

## Notes

- Obscuro masks the rendered page, not devtools, page source, network requests,
  or a terminal window.
- Blur mode leaves the original text in the DOM; scramble mode replaces it.
- `dist/` is the loadable extension. Do not serve `dist/` as the test page.
- The clone is a build workspace, not a fork. Re-running the script reapplies the
  template, Gecko block and CSS fallback.
