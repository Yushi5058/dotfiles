
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)


-- Fugitive command aliases
vim.cmd([[
command! -nargs=* Gcc execute 'G commit -m ' .. <q-args>
command! Gpush G push origin main
command! -nargs=* Ga G add <args>
]])

