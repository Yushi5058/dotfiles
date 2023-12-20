return {
 "nvim-treesitter/nvim-treesitter",
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "c", "lua", "javascript", "typescript", "rust", "html", "css" },
          sync_install = false,
          highlight = { enable = true },
          additional_vim_regex_highlighting = false,
        })
    end

}
