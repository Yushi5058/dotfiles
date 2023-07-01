vim.api.nvim_set_keymap('n', '<leader>gs', ':G status', {noremap = true, silent = true})
-- Raccourci pour push origin main
vim.api.nvim_set_keymap('n', '<leader>gp', ':G push origin main<CR>', { noremap = true })

-- Raccourci pour commit avec un message
vim.api.nvim_set_keymap('n', '<leader>gc', ':G commit -m', { noremap = true })

-- Raccourci pour ajouter un fichier
vim.api.nvim_set_keymap('n', '<leader>ga', ':G add', { noremap = true })


