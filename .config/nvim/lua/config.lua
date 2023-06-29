-- config.lua

-- Indentation
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Activation de la coloration syntaxique
vim.cmd('syntax enable')

-- Affichage des numéros de ligne
vim.wo.number = true

-- Utilisation de la police Hack Italic
vim.cmd('set guifont=Hack\\ Italic:h12')

-- Largeur de la fenêtre de code
vim.o.colorcolumn = "80"
vim.wo.colorcolumn = "80"

-- Désactivation des flèches
vim.o.termguicolors = true
vim.o.ttimeoutlen = 0
vim.cmd('tnoremap <Esc> <C-\\><C-n>')
vim.cmd('inoremap <Esc> <C-\\><C-n>')

-- Utilisation de hjkl pour la navigation
vim.cmd('nnoremap <silent> <Up> <Nop>')
vim.cmd('nnoremap <silent> <Down> <Nop>')
vim.cmd('nnoremap <silent> <Left> <Nop>')
vim.cmd('nnoremap <silent> <Right> <Nop>')
vim.cmd('inoremap <silent> <Up> <Nop>')
vim.cmd('inoremap <silent> <Down> <Nop>')
vim.cmd('inoremap <silent> <Left> <Nop>')
vim.cmd('inoremap <silent> <Right> <Nop>')

-- Copier dans le presse-papiers
vim.o.clipboard = 'unnamedplus'

-- Historique des commandes
vim.o.history = 1000
