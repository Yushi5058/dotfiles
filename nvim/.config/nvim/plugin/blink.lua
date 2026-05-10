vim.pack.add({
  { src = "https://github.com/hrsh7th/nvim-cmp" },
})
vim.pack.add({
  { src = "https://github.com/hrsh7th/cmp-vsnip" },
})
vim.pack.add({
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
})
vim.pack.add({
  { src = "https://github.com/hrsh7th/cmp-nvim-lua" },
})
vim.pack.add({
  { src = "https://github.com/hrsh7th/cmp-buffer" },
})
vim.pack.add({
  { src = "https://github.com/hrsh7th/cmp-path" },
})
vim.pack.add({
  { src = "https://github.com/rafamadriz/friendly-snippets" },
})

require("lazyload").on_vim_enter(function()
  vim.cmd("packadd nvim-cmp")

local cmp = require("cmp")
cmp.setup({
  snippet = { expand = function(args)
    vim.snippet.expand(args.body)
  end,
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "nvim_lua" },
    { name = "buffer" },
    { name = "path" },
  }),
})

vim.keymap.set("n", "<leader>e", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, { desc = "Explorer" })