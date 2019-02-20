" Dein.vim based vimrc
" Checkout https://github.com/Shougo/dein.vim
" 
" Some configs courtesy of @jin

""""""""""
"""Dein"""
""""""""""

# Set encoding for :set list
scriptencoding utf-8
set encoding=utf-8

"" Start of Dein cfg

if &compatible
  set nocompatible
endif
set runtimepath+=~/.vim/dein.repo

" TODOs
" 
"
" file browser
" NeoBundle 'scrooloose/nerdtree'
"
" fuzzy file finder
" NeoBundle "kien/ctrlp.vim"
"
" Add support for autocomplete for
"  - js
"  - latex
"
" Add support for syntax highlighting for
"  - less
" Preview markdown files with html?

if dein#load_state('~/.vim/dein.plugins')
  call dein#begin('~/.vim/dein.plugins')
  call dein#add('~/.vim/dein.repo')
  " Autocomplete
  call dein#add('Shougo/neocomplete.vim') " https://github.com/Shougo/neocomplete.vim
  call dein#add('Raimondi/delimitMate') " https://github.com/Raimondi/delimitMate
  " Syntatic Parsers
  call dein#add('vim-syntastic/syntastic') " https://github.com/vim-syntastic/syntastic
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

""""""""""""""""""
"""Standard Vim"""
""""""""""""""""""

set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

set number relativenumber
set encoding=utf-8
set mouse=a

" Suppress default message at launch
set shortmess+=I

" Increase performance when dealing with long strings
set lazyredraw

" set nobackup
" no viminfo files
set viminfo=
set backupdir=/tmp
set directory=/tmp

"" Whitespace stuff
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab "" Indent start of lines with shiftwidth, not tabstop

"" Nicer autocomplete in command mode
set wildmode=longest,list

" Allow backspace to work everywhere
set backspace=indent,eol,start

"" Enable vim omnicompletion
set omnifunc=syntaxcomplete#Complete

"" Soft wrap long lines
set wrap

"" Searching stuff
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Spellcheck for markdown and text files
"" Refer to plugins for NeoComplete Autocomplete
autocmd BufRead,BufNewFile *.md,*.txt,*.mdown,*.markdown setlocal spell spelllang=en_us textwidth=79 complete+=kspell

"" Python PEP8 style
" au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

"" Java style
" au FileType java set softtabstop=4 tabstop=4 shiftwidth=4

"" Use system clipboard
set clipboard=unnamed

"" Persistent undo
set undofile
set undodir=/tmp

"" MacVim default font and size
set guifont=Inconsolata-dz:h12

"" No error and visual bells
set noerrorbells
set visualbell t_vb=

"" Keep at least * lines around cursor
set scrolloff=6

"" -- PANES --
"" Set vsp and sp to open a new pane to the right and below by default
set splitbelow
set splitright

colorscheme delek

"""""""""""""""""""
""""Keymappings""""
"""""""""""""""""""
"" Set <leader> to ','
let mapleader = ","

"" Maintain selection after indentation [Visual]
" vmap > >gv
" vmap < <gv

"" Moves cursor to the midscreen while going through search terms
nnoremap N Nzz
nnoremap n nzz

"" Quicker pane switching
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"" Set ':' to ';'
nnoremap ; :

"" 'j' and 'k' as they should be
nnoremap j gj
nnoremap k gk

"" Sudo write a file
cmap w!! w !sudo tee % >/dev/null

"""""""""""""
"""Plugins"""
"""""""""""""

""""
"" Shougo/neocomplete
""""

" Disable AutoComplPop.
" let g:acp_enableAtStartup = 0

" Use neocomplete.
let g:neocomplete#enable_at_startup = 1

" Use smartcase.
let g:neocomplete#enable_smart_case = 1

" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 2

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

""""
"" Raimondi/delimitMate
""""

"" Disable delimiteMate for Rust source
let delimitMate_excluded_ft = "rust,ml,ocaml"



""""
"" vim-syntastic/syntastic
""""

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Aggregate errors from more than 1 checker
let g:syntastic_aggregate_errors = 1

" Checkers
" Ref - https://github.com/vim-syntastic/syntastic/blob/master/doc/syntastic-checkers.txt
let g:syntastic_python_checkers = ['pylint', 'python']
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']

" TODO
" Ansible yaml support for Syntastic - http://erikzaadi.com/2015/11/15/linting-ansible-yaml-in-vim/
au BufNewFile,BufRead *.yaml set filetype=yaml.ansible
