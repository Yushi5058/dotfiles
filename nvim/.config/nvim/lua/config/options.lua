-- ── Leader (must be set before lazy loads plugins) ────────────────────────────
vim.g.mapleader      = " "
vim.g.maplocalleader = " "


vim.opt.background     = "dark"
vim.opt.termguicolors  = true
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.cursorline     = false
vim.opt.signcolumn     = "yes"   -- always show; prevents layout shift on diagnostics
vim.opt.colorcolumn    = "80"
vim.opt.showmode       = false   -- mode shown by statusline instead
vim.opt.wrap           = false
vim.g.have_nerd_font   = true

-- ── Arabic / RTL ──────────────────────────────────────────────────────────────
vim.opt.arabicshape = true
vim.opt.termbidi    = true

-- ── Editing ───────────────────────────────────────────────────────────────────
vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 4
vim.opt.softtabstop = 4
vim.opt.expandtab   = true
vim.opt.smarttab    = true
vim.opt.autoindent  = true
vim.opt.smartindent = true
vim.opt.breakindent = true  -- wrapped lines preserve indentation

-- ── Search ────────────────────────────────────────────────────────────────────
vim.opt.ignorecase = false
vim.opt.smartcase  = true
vim.opt.incsearch  = true
vim.opt.hlsearch   = false
vim.opt.showmatch  = true
vim.opt.inccommand = "split"  -- live preview of :s substitutions in a split

-- ── Completion ────────────────────────────────────────────────────────────────
-- blink.cmp manages the completion menu; noinsert prevents auto-selecting.
vim.opt.completeopt = "menu,menuone,noselect,noinsert"

-- ── Files ─────────────────────────────────────────────────────────────────────
vim.opt.undodir  = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup   = false

-- ── UI / UX ───────────────────────────────────────────────────────────────────
vim.opt.mouse      = "a"
vim.opt.scrolloff  = 10
vim.opt.splitright = true
vim.opt.updatetime = 50   -- faster CursorHold (used for LSP highlights)
vim.opt.timeoutlen = 300  -- which-key popup delay
vim.opt.clipboard  = ""   -- explicit: use <leader>y/p for system clipboard

-- ── Cursor shape ──────────────────────────────────────────────────────────────
vim.opt.guicursor = {
	"n-v-c:block",
	"i-ci-ve:ver25",
	"r-cr:hor20",
	"o:hor50",
	"a:blinkwait700-blinkoff400-blinkon250",
	"sm:block-blinkwait175-blinkoff150-blinkon175",
}
