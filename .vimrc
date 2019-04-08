:imap jj <Esc>					" Map Esc key to jj

"" Configure appearance
syntax enable 					" Enable syntax
set number 						" Show line number
set encoding=utf-8 				" Set encoding
set showcmd            			" Show (partial) command in status line.
set showmatch          			" Show matching brackets.
set autowrite          			" Automatically save before commands like :next and :make
set hidden             			" Hide buffers when they are abandoned

"" Set mode
set mouse=a            			" Enable mouse usage (all modes)
set nocompatible                " choose no compatibility with legacy vi
filetype plugin indent on       " load file type plugins + indentation

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

"" Load vim-plug
call plug#begin('~/.vim/plugged')
call plug#end()