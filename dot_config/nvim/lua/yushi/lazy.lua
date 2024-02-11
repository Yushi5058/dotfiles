local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("autocmds")
require("lazy").setup({
  spec = "yushi.plugins",
	install = {
		-- try to load one of these colorschemes when starting an installation during startup
		colorscheme = {	{"Catppuccin"}	},
	},
	checker = {
		-- automatically check for plugin updates
		enabled = true,
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		notify = false, -- get a notification when changes are found
	},
	disabled_plugins = {
		-- "gzip",
		-- "matchit",
		-- "matchparen",
		-- "netrwPlugin",
		-- "tarPlugin",
		-- "tohtml",
		"tutor",
		-- "zipPlugin",
	},
})

