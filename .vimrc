" Options
colorscheme retrobox
set background=dark
set mouse=a
set signcolumn=no
set number
set relativenumber
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set undodir=$HOME/.vim/undodir
set undofile
set smarttab
set expandtab
set showcmd
set breakindent
set ignorecase
set smartcase
set smartindent
set showmatch
set incsearch
set clipboard=""
set encoding=utf-8
set termguicolors
set hlsearch
set completeopt=menu,menuone,noinsert
set noswapfile
set nobackup
set splitright
set scrolloff=10
set colorcolumn=80
set updatetime=50
set timeoutlen=300
set wildmenu
set nowrap

" Keymaps
" Disable space in normal mode for leader key
nnoremap <space> <nop>
vnoremap <space> <nop>

" Move line up/down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Dealing with word wrap
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'

" Sane behavior of searching
nnoremap <expr> n 'Nn'[v:searchforward]
xnoremap <expr> n 'Nn'[v:searchforward]
onoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]
xnoremap <expr> N 'nN'[v:searchforward]
onoremap <expr> N 'nN'[v:searchforward]

" Escape search highlight / insert mode
nnoremap jk :nohlsearch<CR>
inoremap jk <Esc>
vnoremap jk <Esc>

" Yank to the clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y
vnoremap <leader>Y "+Y

" Paste from the clipboard
nnoremap <leader>p "+p
vnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>P "+P

" Delete line to the void register
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" Keymaps for splits
nnoremap sv :vsplit<CR>
nnoremap sh :split<CR>

" Navigate between splits
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j

" Resize splits
nnoremap <A-h> 10<C-w><
nnoremap <A-l> 10<C-w>>
nnoremap <A-j> 10<C-w>+
nnoremap <A-k> 10<C-w>-
