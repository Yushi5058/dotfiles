vim.pack.add({
  { src = "https://github.com/mfussenegger/nvim-jdtls" },
})

require("lazyload").on_vim_enter(function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
      require("jdtls").start_or_attach({})
    end,
  })
end)