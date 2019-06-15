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

"" Netrw config
"" let g:netrw_banner = 0          " remove top banner
"" let g:netrw_liststyle = 3       " view mode of netrw
"" let g:netrw_browse_split = 4    " change how files opened: 4. open file in previous window
"" let g:netrw_altv = 1            
"" let g:netrw_winsize = 25        " set the width of directory explorer: 25% of the page
"" augroup ProjectDrawer           " launch after enter vim
""   autocmd!
""   autocmd VimEnter * :Vexplore  " open vim in vertical split
"" augroup END

"" Load vim-plug
call plug#begin('~/.vim/plugged')
call plug#end()
