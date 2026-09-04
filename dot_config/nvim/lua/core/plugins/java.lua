return { "mfussenegger/nvim-jdtls",
config = function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
      require("jdtls").start_or_attach({})
    end,
})
end
}