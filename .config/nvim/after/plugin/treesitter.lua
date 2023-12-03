require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "lua", "html", "javascript", "markdown", "scss", "typescript", "vue", "vim", "tsx", "bash", },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  auto_install = true,
  indent = {
  enable = true
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
