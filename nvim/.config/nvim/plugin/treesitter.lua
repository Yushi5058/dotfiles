vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

local function setup_treesitter()
  vim.cmd("packadd nvim-treesitter")
  local ok, configs = pcall(require, "nvim-treesitter.configs")
  if ok then
    configs.setup({
      ensure_installed = "all",
      sync_install = false,
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
end

local has_treesitter, _ = pcall(require, "nvim-treesitter.configs")
if has_treesitter then
  setup_treesitter()
else
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      if ev.data and ev.data.spec and ev.data.spec.name == "nvim-treesitter" then
        vim.defer_fn(setup_treesitter, 100)
      end
    end,
  })
end