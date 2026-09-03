return {
  'mrcjkb/rustaceanvim',
  -- To avoid being surprised by breaking changes,
  -- I recommend you set a version range
  version = '^9',
  -- This plugin implements proper lazy-loading (see :h lua-plugin-lazy).
  -- No need for lazy.nvim to lazy-load it.
  lazy = false,
  opts = {
    tools = {
        test_executor = "background",
    },
    server = {
        default_settings = {
            ["rust-analyzer"] = {
                checkOnSave = true,
                cargo = {
                    buildScripts = { enable = true, rebuildOnChange = true},
                },
            },
        },
    },
  },
}