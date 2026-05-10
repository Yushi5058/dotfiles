require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  })

  require("render-markdown").setup({ completions = { lsp = { enabled = true } } })

  vim.keymap.set("n", "<leader>g", "<cmd>RenderMarkdown preview<cr>", { desc = "Markdown Preview" })
end)