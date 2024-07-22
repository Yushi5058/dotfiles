-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require("mini.deps").setup({ path = { package = path_package } })

local add = MiniDeps.add

-- Add to current session (install if absent)

add({
	source = "neovim/nvim-lspconfig",
	-- Supply dependencies near target plugin
	depends = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "WhoIsSethDaniel/mason-tool-installer.nvim" },

})
add({
	source = "nvim-treesitter/nvim-treesitter",
	-- Use 'master' while monitoring updates in 'main'
	checkout = "master",
	monitor = "main",
	-- Perform action after every checkout
	hooks = {
		post_checkout = function()
			vim.cmd("TSUpdate")
		end,
	},
})
add("wakatime/vim-wakatime")
add("cbochs/grapple.nvim")
add({
	source = "barrett-ruth/live-server.nvim",
	hooks = {
		post_checkout = function()
			vim.cmd("!bun i -g live-server")
		end,
	},
})
add({
	source = "L3MON4D3/LuaSnip",
	depends = {
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
	},
})
add({
	source = "hrsh7th/nvim-cmp",
	depends = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-buffer",
	},
})
add("stevearc/conform.nvim")
add({
	source = "tpope/vim-dadbod",
	depends = { "kristijanhusak/vim-dadbod-completion", "kristijanhusak/vim-dadbod-ui" },
})
add({"MagicDuck/grug-far.nvim")
