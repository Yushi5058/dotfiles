return {
  "saghen/blink.lib",
  {
    "saghen/blink.cmp",
    dependencies = { "saghen/blink.lib", "rafamadriz/friendly-snippets" },
    opts = {
      keymap = { preset = "default" },
      completion = {
        documentation = { auto_show = false },
        trigger = { show_on_insert_on_trigger_character = true },
      },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      fuzzy = { implementation = "rust" },
    },
    config = function(_, opts)
      require("blink.cmp").build():wait(60000)
      require("blink.cmp").setup(opts)
    end,
  },
  "rafamadriz/friendly-snippets",
}