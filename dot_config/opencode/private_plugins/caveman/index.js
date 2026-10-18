// caveman — OpenCode V2 plugin entrypoint.
//
// OpenCode V2 discovers plugin package directories under the global config
// directory (~/.config/opencode/plugins/) and resolves each one by trying
// `<dir>/server.<ext>` first, then `<dir>/index.<ext>`. The implementation
// lives in ./plugin.js next to the shared helpers it loads at runtime
// (caveman-config.cjs, caveman-parse.cjs); this file only re-exports it so the
// directory is discoverable. See https://opencode.ai/v2/docs/plugins#discover.

export { default, CavemanPlugin } from './plugin.js';
