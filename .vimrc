" Use Vim settings rather than Vi settings
set nocompatible
set backspace=indent,eol,start

" Enable syntax highlighting
syntax on
filetype plugin indent on

" Encoding
set encoding=utf-8

" Indentation
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

" Display
set number
set relativenumber
set cursorline
set showmatch
set incsearch
set hlsearch

" Use Neovim config if available
if has('nvim')
  let $MYVIMRC = stdpath('config') .. '/init.vim'
  let $MYGVIMRC = stdpath('config') .. '/ginit.vim'
  exe 'source' stdpath('config') .. '/init.vim'
endif
