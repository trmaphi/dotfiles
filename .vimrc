" Show line number:
set number

" Map jj to <Esc>
:imap jj <Esc>

" Allows loading local executing local rc files.
set exrc

" Disallows the use of :autocmd, shell and write commands in 
" local .vimrc files.
set secure

set showcmd            " Show (partial) command in status line.
set showmatch          " Show matching brackets.
" set ignorecase         " Do case insensitive matching
set smartcase          " Do smart case matching
set incsearch          " Incremental search
set autowrite          " Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
set mouse=a            " Enable mouse usage (all modes)

