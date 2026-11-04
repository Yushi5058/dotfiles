#!/usr/bin/env bash
# Update the Obscuro fork submodule, rebuild, and repackage the Floorp XPI.
#
# PII rules live in scripts/obscuro/config.json and are copied into
# dist/config.json after the build, so the submodule working tree stays clean.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/../.." && pwd)"
SRC_DIR="$SCRIPT_DIR/src"
DIST="$SRC_DIR/dist"
CONFIG_TEMPLATE="$SCRIPT_DIR/config.json"
XPI="$SCRIPT_DIR/obscuro-custom.xpi"

SUBMODULE="scripts/obscuro/src"
BRANCH="${OBSCURO_BRANCH:-$(git config -f "$ROOT_DIR/.gitmodules" \
  submodule."$SUBMODULE".branch 2>/dev/null || true)}"
BRANCH="${BRANCH:-main}"
GECKO_ID="${OBSCURO_ID:-obscuro-custom@yushi61.local}"

DO_PULL=1
DO_WATCH=0

usage() {
  cat <<'EOF'
Usage: scripts/obscuro/update.sh [--no-pull] [--watch]

  (no flags)   pull the submodule branch, install deps if missing, build, package
  --no-pull    build the current checkout without touching the network
  --watch      keep running and rebuild when config.json or src/ changes

Environment:
  OBSCURO_BRANCH  branch to build (default: branch from .gitmodules)
  OBSCURO_ID      Gecko add-on id (default: obscuro-custom@yushi61.local)
EOF
}

while (( $# )); do
  case "$1" in
    --no-pull) DO_PULL=0 ;;
    --watch) DO_WATCH=1 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'update-obscuro: unknown option: %s\n\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

die() { printf 'update-obscuro: %s\n' "$*" >&2; exit 1; }
log() { printf '==> %s\n' "$*"; }

[[ -e "$SRC_DIR/.git" ]] || die "submodule missing at $SRC_DIR (run: git submodule update --init --recursive)"
[[ -f "$CONFIG_TEMPLATE" ]] || die "missing PII rule template: $CONFIG_TEMPLATE"
command -v npm >/dev/null 2>&1 || die "npm not found"
command -v node >/dev/null 2>&1 || die "node not found"

validate_config() {
  log "Validating PII rules"
  node - "$CONFIG_TEMPLATE" <<'NODE'
const fs = require('fs');
const file = process.argv[2];
const config = JSON.parse(fs.readFileSync(file, 'utf8'));
if (!Array.isArray(config.selectors)) throw new Error('config.selectors must be an array');
if (!Array.isArray(config.regex)) throw new Error('config.regex must be an array');
config.regex.forEach((rule, i) => {
  if (typeof rule.pattern !== 'string') {
    throw new Error(`regex[${i}].pattern must be a string`);
  }
  try {
    new RegExp(rule.pattern, rule.flags || '');
  } catch (error) {
    throw new Error(`regex[${i}] invalid: ${error.message}`);
  }
});
console.log(`config OK: ${config.selectors.length} selectors, ${config.regex.length} regex rules`);
NODE
}

pull_branch() {
  log "Updating submodule ($BRANCH)"
  git -C "$SRC_DIR" fetch --prune origin
  git -C "$SRC_DIR" checkout "$BRANCH"
  git -C "$SRC_DIR" pull --ff-only origin "$BRANCH"
}

install_deps() {
  if [[ ! -d "$SRC_DIR/node_modules" ]]; then
    log "Installing dependencies"
    ( cd "$SRC_DIR" && npm install --no-audit --no-fund )
  else
    log "Dependencies present, skipping install"
  fi
}

build_and_package() {
  validate_config

  log "Building"
  ( cd "$SRC_DIR" && npm run build )

  for f in \
    manifest.json config.json types.js scrambler.js content.js \
    popup.js popup.html popup.css content.css \
    icons/icon16.png icons/icon48.png icons/icon128.png
  do
    [[ -f "$DIST/$f" ]] || die "build output missing: dist/$f"
  done

  log "Applying PII rules and Gecko manifest"
  cp "$CONFIG_TEMPLATE" "$DIST/config.json"
  node - "$DIST/manifest.json" "$GECKO_ID" <<'NODE'
const fs = require('fs');
const [file, id] = process.argv.slice(2);
const manifest = JSON.parse(fs.readFileSync(file, 'utf8'));
manifest.browser_specific_settings = {
  ...(manifest.browser_specific_settings || {}),
  gecko: {
    ...((manifest.browser_specific_settings || {}).gecko || {}),
    id,
    strict_min_version: '115.0',
    data_collection_permissions: { required: ['none'] },
  },
};
fs.writeFileSync(file, JSON.stringify(manifest, null, 2) + '\n');
NODE

  # The upstream 16/48 px icons are 128 px copies; resize if ImageMagick exists.
  if command -v magick >/dev/null 2>&1; then
    magick "$DIST/icons/icon128.png" -resize 16x16 "$DIST/icons/icon16.png"
    magick "$DIST/icons/icon128.png" -resize 48x48 "$DIST/icons/icon48.png"
  fi

  log "Packaging $XPI"
  rm -f "$XPI"
  if command -v zip >/dev/null 2>&1; then
    ( cd "$DIST" && zip -qr "$XPI" . -x '.*' )
  else
    python3 - "$DIST" "$XPI" <<'PY'
import os, sys, zipfile
src, out = sys.argv[1], sys.argv[2]
with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as z:
    for root, _dirs, files in os.walk(src):
        for name in files:
            full = os.path.join(root, name)
            z.write(full, os.path.relpath(full, src))
PY
  fi

  [[ -s "$XPI" ]] || die "packaging failed"

  log "Done: $XPI ($(du -h "$XPI" | cut -f1))"
  printf '\nXPI ready for Floorp/Firefox.\n'
  printf '  about:addons -> gear -> Install Add-on From File... -> %s\n' "$XPI"
  printf '  or sideload: cp %s ~/.floorp/<profile>/extensions/%s.xpi && restart Floorp\n' "$XPI" "$GECKO_ID"
  printf 'Submodule now at %s. Commit scripts/obscuro/src if it moved.\n' \
    "$(git -C "$SRC_DIR" rev-parse --short HEAD)"
}

if (( DO_PULL )); then
  pull_branch
fi
install_deps
build_and_package

if (( DO_WATCH )); then
  snapshot() {
    {
      sha256sum "$CONFIG_TEMPLATE"
      git -C "$SRC_DIR" rev-parse HEAD
      find "$SRC_DIR/src" "$SRC_DIR/manifest.json" -type f \
        -printf '%T@ %s %p\n' | sort
    } | sha256sum | cut -d' ' -f1
  }

  last="$(snapshot)"
  log "Watching config.json and submodule src/ (Ctrl+C to stop)"
  while sleep 2; do
    now="$(snapshot)"
    if [[ "$now" != "$last" ]]; then
      last="$now"
      log "Change detected, rebuilding"
      if "$SCRIPT_DIR/update.sh" --no-pull; then
        log "Rebuild OK"
      else
        log "Rebuild failed; waiting for next change"
      fi
    fi
  done
fi
