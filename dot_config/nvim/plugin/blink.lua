vim.pack.add({
  { src = "https://github.com/saghen/blink.lib" },
})
vim.pack.add({
  { src = "https://github.com/Saghen/blink.cmp" },
})
vim.pack.add({
  { src = "https://github.com/rafamadriz/friendly-snippets" },
})

require("lazyload").on_vim_enter(function()
  vim.cmd("packadd blink.cmp")

  local cmp = require("blink.cmp")
  cmp.build():wait(60000)
  cmp.setup({
    keymap = { preset = "default" },
    completion = {
      documentation = { auto_show = false },
      trigger = { show_on_insert_on_trigger_character = true },
    },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    fuzzy = { implementation = "rust" },
  })
end)