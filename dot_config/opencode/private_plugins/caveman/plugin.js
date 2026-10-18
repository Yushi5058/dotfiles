// caveman — opencode plugin
//
// Provides dynamic caveman mode tracking for opencode:
// - Writes the mode flag on each session start (via the `event` dispatcher)
// - Parses user messages for /caveman commands and natural-language toggles
// - Injects per-turn reinforcement into the system prompt
//
// Bun ESM module; loads the existing security-hardened helpers from
// caveman-config.js via createRequire so the symlink-safe flag-write code
// lives in one place. Same trick loads caveman-parse.js (#602) so the mode-
// change parsing is a single shared source with caveman-mode-tracker.js.
//
// Layout once installed:
//   ~/.config/opencode/plugins/caveman/
//   ├── package.json
//   ├── plugin.js              ← this file
//   ├── caveman-config.cjs     ← copied sibling of src/hooks/caveman-config.js
//   └── caveman-parse.cjs      ← copied sibling of src/hooks/caveman-parse.js
//
// The always-on caveman ruleset is provided separately via
// ~/.config/opencode/AGENTS.md (Tier-3 base). This plugin handles dynamic
// state only: flag writes, slash-command parsing, natural-language
// activation, and per-turn reinforcement.
//
// Hook mapping (opencode V2 plugin API, >= 2.0.x):
//   - event.subscribe({ signal }): session-init flag write on every
//     'session.created' event rather than once per plugin-process load
//   - session.hook('prompt'): intercept user prompts for mode changes
//   - session.hook('context'): inject reinforcement per-turn into event.system
//
// V2 note: V1 plugin implementations do not run in V2. The V1 keys this file
// used to return (`event`, `chat.message`, `experimental.chat.system.transform`)
// are unreachable in V2; hooks must be registered from `setup(ctx)` on the domain
// that owns the operation. See:
// https://opencode.ai/v2/docs/build/plugins/migrate-v1
//
// Note: opencode does NOT support 'session.created' or 'tui.prompt.append'
// as named plugin-hook keys. 'session.created' is an event *type* delivered
// through the single event stream; the old direct-key handlers were
// silently ignored. See:
// https://github.com/JuliusBrussee/caveman/issues/418
// https://github.com/JuliusBrussee/caveman/issues/421

import { createRequire } from 'node:module';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { dirname, join } from 'node:path';
import { existsSync, unlinkSync, readFileSync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';

const here = dirname(fileURLToPath(import.meta.url));

// When installed: caveman-config.cjs sits next to plugin.js (copied by
// cli/install.js, renamed to .cjs because this directory's package.json
// declares "type": "module" — bare .js would be loaded as ESM). When loaded
// from the source tree (tests, dev): fall back to the canonical
// src/hooks/caveman-config.js, which lives in a directory whose own
// package.json pins "type": "commonjs". One source of truth either way.
//
// Loaded by evaluating the file as CommonJS by hand, NOT via the module
// loader: opencode runs plugins inside a compiled Bun binary where
// require() of on-disk files is rejected ("require() async module is
// unsupported") and await import() of a CJS file yields an empty namespace —
// both silently break the plugin (#418 follow-up). createRequire() still
// resolves node BUILT-INS fine in the compiled binary, which is all
// caveman-config needs (fs/path/os).
function loadConfig() {
  const installed = join(here, 'caveman-config.cjs');
  const dev = join(here, '..', '..', 'hooks', 'caveman-config.js');
  const target = existsSync(installed) ? installed : dev;
  const code = readFileSync(target, 'utf8').replace(/^#![^\n]*\n/, '');
  const mod = { exports: {} };
  // Base require on the loaded file, not plugin.js — caveman-parse.js does a
  // relative require('./caveman-config') that must resolve against src/hooks/
  // in the dev layout and against pluginDir when installed.
  new Function('module', 'exports', 'require', '__dirname', '__filename', code)(
    mod, mod.exports, createRequire(pathToFileURL(target).href), dirname(target), target
  );
  return mod.exports;
}
const config = loadConfig();

const { getDefaultMode, safeWriteFlag, readFlag } = config;

// Load the shared mode-change parser (#602) the same way loadConfig() loads
// caveman-config.js — see the doc comment above loadConfig() for why this
// can't go through require()/import() in a compiled Bun binary.
function loadParse() {
  const installed = join(here, 'caveman-parse.cjs');
  const dev = join(here, '..', '..', 'hooks', 'caveman-parse.js');
  const target = existsSync(installed) ? installed : dev;
  const code = readFileSync(target, 'utf8').replace(/^#![^\n]*\n/, '');
  const mod = { exports: {} };
  new Function('module', 'exports', 'require', '__dirname', '__filename', code)(
    mod, mod.exports, createRequire(pathToFileURL(target).href), dirname(target), target
  );
  return mod.exports;
}
const { parseModeChange, INDEPENDENT_MODES } = loadParse();

// opencode resolves its config dir from $XDG_CONFIG_HOME, else ~/.config/opencode
// on every platform — including Windows, where it uses %USERPROFILE%\.config\opencode
// (NOT %APPDATA%). os.homedir() is %USERPROFILE% on win32, so the default branch
// is already correct cross-platform.
function opencodeConfigDir() {
  if (process.env.XDG_CONFIG_HOME) {
    return path.join(process.env.XDG_CONFIG_HOME, 'opencode');
  }
  return path.join(os.homedir(), '.config', 'opencode');
}

const flagPath = path.join(opencodeConfigDir(), '.caveman-active');

function reinforcementLine(mode) {
  return 'CAVEMAN MODE ACTIVE (' + mode + ') — session ruleset applies.';
}

function applyModeChange(change) {
  if (!change) return;
  if (change.action === 'clear') {
    try { if (existsSync(flagPath)) unlinkSync(flagPath); } catch (e) {}
    return;
  }
  if (change.action === 'set' && change.mode) {
    safeWriteFlag(flagPath, change.mode);
  }
}

// Session-start logic — extracted so the `event` dispatcher (opencode >= 1.15)
// drives one shared implementation. Re-fires on every `session.created` event,
// so a new session in a long-lived plugin process re-asserts the flag.
function handleSessionCreated() {
  const mode = getDefaultMode();
  if (mode === 'off') {
    try { if (existsSync(flagPath)) unlinkSync(flagPath); } catch (e) {}
    return;
  }
  safeWriteFlag(flagPath, mode);
}

export const CavemanPlugin = {
  id: 'caveman',

  async setup(ctx) {
    // Assert the flag at plugin load as well: in one-shot `opencode run` the
    // first session.created publishes before plugin event dispatch is wired,
    // so the event handler alone misses it. The setup-time write covers that
    // race; the event handler re-asserts on every later session in long-lived
    // TUI processes.
    handleSessionCreated();

    // V2 delivers lifecycle events through an async subscription instead of a
    // returned `event` hook. The subscription is torn down by the cleanup
    // function returned from setup.
    const controller = new AbortController();

    void (async () => {
      try {
        for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
          if (event && event.type === 'session.created') handleSessionCreated();
        }
      } catch (error) {
        // A closed stream during unload is expected; anything else is left to
        // the host's plugin diagnostics rather than crashing the plugin.
        if (controller.signal.aborted) return;
        throw error;
      }
    })();

    // Intercept user messages to detect /caveman commands and natural-language
    // mode toggles. V2 runs this once per admission, before attachments and
    // skill resolution; event.prompt.text is the user's text. State changes
    // happen via the flag file, so the hook mutates nothing.
    // expandedTpl: opencode replaces a typed slash command with its command
    // file's prose before this hook sees it. unwrapQuotes: the non-interactive
    // `run` path delivers the message wrapped in literal quote characters.
    await ctx.session.hook('prompt', (event) => {
      const text = event && event.prompt && event.prompt.text;
      if (typeof text !== 'string' || !text) return;
      const change = parseModeChange(text, { getDefaultMode, expandedTpl: true, unwrapQuotes: true });
      if (change) applyModeChange(change);
    });

    // Inject the reinforcement line into the system prompt when caveman is
    // active. V2 runs this before each agent model request and expects the hook
    // to mutate event.system, an array of text parts.
    await ctx.session.hook('context', (event) => {
      if (!event || !Array.isArray(event.system)) return;
      const active = readFlag(flagPath);
      if (active && !INDEPENDENT_MODES.has(active)) {
        event.system.push({ type: 'text', text: reinforcementLine(active) });
      }
    });

    return () => controller.abort();
  },
};

export default CavemanPlugin;
