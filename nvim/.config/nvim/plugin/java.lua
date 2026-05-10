require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/nvim-java/nvim-jdtls" },
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
      require("jdtls").start_or_attach({})
    end,
  })
end)