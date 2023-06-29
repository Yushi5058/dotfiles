-- mappings.lua

local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

-- Utiliser l'espace comme leader
vim.g.mapleader = ' '

-- Mappings pour Git et GitHub
map('n', '<leader>gs', ':Git<CR>', options)
map('n', '<leader>ga', ':Git add %<CR>', options)
map('n', '<leader>gc', ':Git commit<CR>', options)
map('n', '<leader>gp', ':Git push<CR>', options)

-- Mappings pour le formattage du code avec Prettier
map('n', '<leader>f', ':Prettier<CR>', options)

-- Mappings pour Harpoon
map('n', '<leader>oa', ':HarpoonAdd<CR>', options)
map('n', '<leader>or', ':HarpoonRemove<CR>', options)
map('n', '<leader>on', ':HarpoonNext<CR>', options)
map('n', '<leader>op', ':HarpoonPrev<CR>', options)

-- Mappings pour les diagnostics d'erreurs
map('n', '<leader>e', ':TroubleToggle<CR>', options)

-- Mappings pour split deux sessions nvim et naviguer entre les fenêtres
map('n', '<leader>ss', ':vsplit<CR>:bprevious<CR>', options)
map('n', '<leader>sd', ':vsplit<CR>:bnext<CR>', options)

-- Ajoutez d'autres mappings selon vos besoins

