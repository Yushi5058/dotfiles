-- leader key and netRW navigation
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- move the highlighted lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- move the lines side by side
vim.keymap.set("n", "J", "mzJ`z")


-- copy the highlighted text in the clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
-- delete the highlighted text
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- cancel the Q command I guess
vim.keymap.set("n", "Q", "<nop>")

-- format the code I guess
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)


-- fz find in the whole file 
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- fz find in the same line
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")


-- fz find to change in the whole file easily
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- make a file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
