require("lazyload").on_vim_enter(function()
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      if ev.data.spec.name == "blink.cmp" then
        require("blink.cmp").build():wait(60000)
      end
    end,
  })

  vim.pack.add({
    { src = "https://github.com/Saghen/blink.cmp" },
  })
  vim.pack.add({
    { src = "https://github.com/rafamadriz/friendly-snippets" },
  })
  vim.pack.add({
    { src = "https://github.com/disrupted/blink-cmp-conventional-commits" },
  })

  require("blink.cmp").setup({
    keymap = { preset = "default" },
    completion = {
      trigger = { show_on_insert_on_trigger_character = true },
      documentation = { auto_show = true, window = { border = "double" } },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "conventional_commits" },
      providers = {
        conventional_commits = {
          name = "Conventional Commits",
          module = "blink-cmp-conventional-commits",
          enabled = function()
            return vim.bo.filetype == "gitcommit"
          end,
        },
      },
    },
    fuzzy = { implementation = "rust" },
  })
end)