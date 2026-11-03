#!/usr/bin/env bash
# Build, configure, package and verify the Obscuro extension for Firefox/Floorp.
#
# Usage:
#   scripts/setup-obscuro.sh                 # clone, install, configure, build, verify
#   scripts/setup-obscuro.sh --serve         # same, then serve the test page
#   scripts/setup-obscuro.sh --package       # also produce obscuro-firefox.xpi
#   scripts/setup-obscuro.sh --dom           # also verify the built scripts in jsdom
#   scripts/setup-obscuro.sh --lint          # also run web-ext lint against dist/
#   scripts/setup-obscuro.sh --skip-install  # reuse an existing node_modules
#
# Environment:
#   OBSCURO_DIR   clone location (default: ~/src/obscuro)
#   OBSCURO_PORT  test-page HTTP port (default: 8000)
set -euo pipefail

REPO_URL="https://github.com/intezer/obscuro.git"
SRC_DIR="${OBSCURO_DIR:-$HOME/src/obscuro}"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/obscuro"
PORT="${OBSCURO_PORT:-8000}"

DO_SERVE=0
DO_PACKAGE=0
DO_DOM=0
DO_LINT=0
SKIP_INSTALL=0

usage() {
  sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'
}

while (( $# )); do
  case "$1" in
    --serve) DO_SERVE=1 ;;
    --package) DO_PACKAGE=1 ;;
    --dom) DO_DOM=1 ;;
    --lint) DO_LINT=1 ;;
    --skip-install) SKIP_INSTALL=1 ;;
    --port) shift; PORT="${1:?--port needs a value}" ;;
    -h|--help) usage; exit 0 ;;
    *) echo "setup-obscuro: unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

log() { printf '\n==> %s\n' "$*"; }
die() { printf 'setup-obscuro: %s\n' "$*" >&2; exit 1; }

log "Checking toolchain"
for tool in node npm git python3; do
  command -v "$tool" >/dev/null 2>&1 || die "missing required tool: $tool"
done
printf 'node %s\nnpm  %s\ngit  %s\n' "$(node --version)" "$(npm --version)" "$(git --version | awk '{print $3}')"

if [[ ! -d "$TEMPLATE_DIR" ]]; then
  die "missing template directory: $TEMPLATE_DIR"
fi
for f in config.json test_obscuro.html; do
  [[ -f "$TEMPLATE_DIR/$f" ]] || die "missing template: $TEMPLATE_DIR/$f"
done

log "Repository"
if [[ ! -d "$SRC_DIR/.git" ]]; then
  mkdir -p "$(dirname -- "$SRC_DIR")"
  git clone "$REPO_URL" "$SRC_DIR"
else
  echo "Using existing clone: $SRC_DIR"
fi
printf 'HEAD %s\n' "$(git -C "$SRC_DIR" log -1 --oneline)"

log "Dependencies"
if (( SKIP_INSTALL )); then
  [[ -d "$SRC_DIR/node_modules" ]] || die "--skip-install given but node_modules is missing"
  echo "Skipping install (--skip-install)"
elif [[ -f "$SRC_DIR/package-lock.json" ]]; then
  ( cd "$SRC_DIR" && npm ci )
else
  ( cd "$SRC_DIR" && npm install )
fi

log "Applying Obscuro rules"
cp "$TEMPLATE_DIR/config.json" "$SRC_DIR/config.json"
cp "$TEMPLATE_DIR/test_obscuro.html" "$SRC_DIR/test_obscuro.html"

log "Applying Firefox/Gecko manifest settings"
node - "$SRC_DIR/manifest.json" <<'NODE'
const fs = require('fs');
const path = process.argv[2];
const manifest = JSON.parse(fs.readFileSync(path, 'utf8'));
manifest.browser_specific_settings = {
  ...(manifest.browser_specific_settings || {}),
  gecko: {
    ...((manifest.browser_specific_settings || {}).gecko || {}),
    id: 'obscuro@yushi61.local',
    strict_min_version: '115.0',
    data_collection_permissions: { required: ['none'] },
  },
};
fs.writeFileSync(path, JSON.stringify(manifest, null, 2) + '\n');
NODE

log "Applying form-control scramble fallback"
CSS_MARKER="obscuro-form-controls"
if ! grep -qF "$CSS_MARKER" "$SRC_DIR/src/content.css"; then
  cat >> "$SRC_DIR/src/content.css" <<'CSS'

/* obscuro-form-controls: in scramble mode there are no text nodes inside an
   input/textarea, so keep the control blurred instead of exposing its value. */
input.scrambled,
textarea.scrambled,
select.scrambled {
  filter: blur(6px) !important;
}
CSS
else
  echo "CSS fallback already present"
fi

log "Normalizing icon sizes"
if command -v magick >/dev/null 2>&1; then
  magick "$SRC_DIR/icons/icon128.png" -resize 16x16 "$SRC_DIR/icons/icon16.png"
  magick "$SRC_DIR/icons/icon128.png" -resize 48x48 "$SRC_DIR/icons/icon48.png"
  echo "icon16 16x16, icon48 48x48 (from icon128)"
elif command -v convert >/dev/null 2>&1; then
  convert "$SRC_DIR/icons/icon128.png" -resize 16x16 "$SRC_DIR/icons/icon16.png"
  convert "$SRC_DIR/icons/icon128.png" -resize 48x48 "$SRC_DIR/icons/icon48.png"
  echo "icon16 16x16, icon48 48x48 (from icon128)"
else
  echo "ImageMagick not found; keeping upstream icon files (web-ext may warn about sizes)"
fi

log "Building"
( cd "$SRC_DIR" && npm run build )

log "Verifying build output"
for f in \
  manifest.json config.json types.js scrambler.js content.js \
  popup.js popup.html popup.css content.css \
  icons/icon16.png icons/icon48.png icons/icon128.png
do
  [[ -f "$SRC_DIR/dist/$f" ]] || die "missing build output: dist/$f"
done
grep -qF "$CSS_MARKER" "$SRC_DIR/dist/content.css" || die "form-control CSS fallback missing from dist"

log "Verifying manifest and rules"
node - "$SRC_DIR/dist/config.json" "$SRC_DIR/dist/manifest.json" <<'NODE'
const fs = require('fs');

const configPath = process.argv[2];
const manifestPath = process.argv[3];
const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
const failures = [];
const check = (ok, message) => { if (!ok) failures.push(message); };

check(manifest.manifest_version === 3, 'manifest_version must be 3');
check(!!manifest.browser_specific_settings?.gecko?.id, 'browser_specific_settings.gecko.id missing');
check(manifest.browser_specific_settings?.gecko?.strict_min_version === '115.0', 'gecko.strict_min_version mismatch');
check(
  (manifest.browser_specific_settings?.gecko?.data_collection_permissions?.required || []).includes('none'),
  'gecko.data_collection_permissions.required must include "none"'
);
check(manifest.action?.default_popup === 'popup.html', 'action.default_popup missing');
check((manifest.content_scripts?.[0]?.js || []).join(',') === 'types.js,scrambler.js,content.js', 'content_scripts.js list mismatch');
check((manifest.web_accessible_resources?.[0]?.resources || []).includes('config.json'), 'config.json not web accessible');
check(Array.isArray(config.selectors) && config.selectors.includes("[data-sensitive='true']"), 'data-sensitive selector missing');
check(config.selectors.includes("input[type='password']"), 'password input selector missing');
check(config.selectors.includes("input[autocomplete='current-password']"), 'current-password selector missing');
check(Array.isArray(config.regex) && config.regex.length >= 8, 'expected at least 8 regex rules');

const regexes = config.regex.map((rule) => {
  try {
    return new RegExp(rule.pattern, rule.flags || 'g');
  } catch (error) {
    failures.push(`invalid regex ${rule.pattern}: ${error.message}`);
    return null;
  }
}).filter(Boolean);
const ignoreRegexes = (config.ignore?.regex || []).map((rule) => new RegExp(rule.pattern, rule.flags || 'g'));

const matches = (text) => regexes.some((regex) => {
  regex.lastIndex = 0;
  return regex.test(text);
});
const ignored = (text) => ignoreRegexes.some((regex) => {
  regex.lastIndex = 0;
  return regex.test(text);
});

const shouldMatch = {
  email: ['alice@example.com', 'bob.smith+test@corp.co.ma'],
  moroccan_phone: ['+212 6 12 34 56 78', '0612345678', '06-12-34-56-78', '+212612345678'],
  e164_phone: ['+33612345678', '+14155552671'],
  github_token: ['ghp_1234567890abcdefghijklmnopqrstuvwxyz'],
  stripe_key: ['sk_live_1234567890abcdefghijkl'],
  bearer_token: ['Bearer eyJhbGciOiJIUzI1NiJ9.fake_payload.fake_signature'],
  private_ip: ['10.0.0.42', '192.168.1.10', '172.16.5.9', '172.31.255.254'],
  public_ip: ['8.8.8.8'],
  ipv6: ['2001:db8::1'],
};
for (const [kind, samples] of Object.entries(shouldMatch)) {
  for (const sample of samples) {
    check(matches(sample), `${kind} not matched: ${sample}`);
  }
}

const shouldNotMatch = ['hello world', 'version 1.2.3'];
for (const sample of shouldNotMatch) {
  check(!matches(sample), `false positive: ${sample}`);
}

check(ignored('support@mycompany.com'), 'ignore rule for support@mycompany.com not active');
check(ignored('demo42@example.com'), 'ignore rule for demo42@example.com not active');
check(!ignored('alice@example.com'), 'ignore rule is too broad: alice@example.com ignored');

if (failures.length) {
  console.error('\nVerification failed:');
  for (const failure of failures) console.error(`  - ${failure}`);
  process.exit(1);
}

console.log(`manifest: MV${manifest.manifest_version}, gecko id ${manifest.browser_specific_settings.gecko.id}`);
console.log(`config: ${config.selectors.length} selectors, ${config.regex.length} regex rules, ${(config.ignore?.regex || []).length} ignore regex rules`);
console.log(`regex samples: ${Object.values(shouldMatch).reduce((n, list) => n + list.length, 0)} matched, ${shouldNotMatch.length} false-positive checks passed`);
console.log('rules: email, Moroccan phone, E.164, GitHub/Stripe/Bearer tokens, private/public IPv4, IPv6');
NODE

if (( DO_DOM )); then
  log "Verifying content script in jsdom"
  DOM_TMP="$(mktemp -d "${TMPDIR:-/tmp}/obscuro-dom.XXXXXX")"
  trap 'rm -rf "$DOM_TMP"' EXIT
  npm install --prefix "$DOM_TMP" --no-audit --no-fund --silent jsdom@26 >/dev/null
  NODE_PATH="$DOM_TMP/node_modules" node "$TEMPLATE_DIR/verify-dom.js" "$SRC_DIR"
  rm -rf "$DOM_TMP"
  trap - EXIT
fi

if (( DO_LINT )); then
  log "Linting with web-ext"
  ( cd "$SRC_DIR" && npx --yes web-ext@8 lint --source-dir dist --output text )
fi

if (( DO_PACKAGE )); then
  log "Packaging unsigned XPI"
  XPI="$SRC_DIR/obscuro-firefox.xpi"
  rm -f "$XPI"
  if command -v zip >/dev/null 2>&1; then
    ( cd "$SRC_DIR/dist" && zip -qr "$XPI" . )
  else
    python3 - "$SRC_DIR/dist" "$XPI" <<'PY'
import os
import sys
import zipfile

root, out = sys.argv[1], sys.argv[2]
with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as archive:
    for base, _, files in os.walk(root):
        for name in files:
            full = os.path.join(base, name)
            archive.write(full, os.path.relpath(full, root))
PY
  fi
  echo "Created $XPI"
  echo "Unsigned XPI: permanent install needs signing, or set xpinstall.signatures.required=false in a developer build."
fi

log "Next steps"
cat <<EOF
1. Start the test server (foreground):
     python3 -m http.server $PORT --bind 127.0.0.1 --directory "$SRC_DIR"

2. Open Floorp and load the extension temporarily:
     about:debugging#/runtime/this-firefox
     -> This Firefox -> Load Temporary Add-on...
     -> select "$SRC_DIR/dist/manifest.json"

3. Open the test page:
     http://127.0.0.1:$PORT/test_obscuro.html

4. Click the Obscuro toolbar icon to toggle enabled / Blur / Scramble.
   The password field and data-sensitive fields must stay masked in both modes.

Notes:
- Temporary add-ons disappear when Floorp closes. Reload after every restart.
- Floorp may ask for host access on first install. Allow "Access your data for all websites".
- Re-run this script after changing scripts/obscuro/config.json or test_obscuro.html.
EOF

if (( DO_SERVE )); then
  log "Serving $SRC_DIR on http://127.0.0.1:$PORT"
  exec python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$SRC_DIR"
fi
