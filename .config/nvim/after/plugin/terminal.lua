local buffer_term = require('buffer-term')

buffer_term.setup() -- default config

vim.keymap.set({ 'n', 't' }, '<leader>t', function() buffer_term.toggle('a') end) -- toggle terminal 
