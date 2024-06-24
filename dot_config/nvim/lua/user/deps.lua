-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

local add = MiniDeps.add
add('rose-pine/neovim')
vim.cmd('colorscheme rose-pine-main')
add('ibhagwan/fzf-lua')
add('wakatime/vim-wakatime')
add({
  source = 'neovim/nvim-lspconfig',
  depends = { 'williamboman/mason.nvim' },
})

add({
  source = 'nvim-treesitter/nvim-treesitter',
  checkout = 'master',
  monitor = 'main',
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})
add('mbbill/undotree')
vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>")
