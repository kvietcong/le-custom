" ============================
" KV Le's NeoVim Configuration
" ============================

" Plug manager configuration
call plug#begin()
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'flazz/vim-colorschemes'
    Plug 'airblade/vim-gitgutter'
    Plug 'sheerun/vim-polyglot'
    Plug 'scrooloose/nerdtree'
call plug#end()

let g:airline_theme = "deus"
let mapleader = "\<Space>"

set ruler
set spell
set showcmd
set path+=**
set linebreak
set termguicolors
set timeoutlen=500
set ignorecase smartcase
set relativenumber number
set smartindent cindent indentexpr

" Allow mouse usage
set mouse=a

" No need for two mode indicators (airline + vim)
set noshowmode

" Better searching
set incsearch nohlsearch

" Better split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
set splitbelow splitright
nnoremap <Leader>v :vs<Enter>
nnoremap <Leader>h :sp<Enter>

" Enable syntax/indenting features
syntax enable
filetype plugin indent on

" Display completion matches in a status line
set wildmenu wildmode=longest,list,full

" More robust backspacing
set backspace=indent,eol,start

" Sets tabs to 4 wide and expands them into spaces
set tabstop=4 softtabstop=2 shiftwidth=4 expandtab

" Add a semicolon to line without moving the cursor
nnoremap <Leader>; m'A;<Esc>`'

" NerdTree
map <Leader>f :NERDTreeToggle<Enter>

" Global substitution for things selected in visual mode
xnoremap gs y:%s/<C-r>"//g<Left><Left>

" Banner comment with //
nnoremap <Buffer> <Leader>/ I// <Esc>A //<Esc>yyp0llv$hhhr-yykPjj
" Banner comment with --
nnoremap <buffer> <Leader>- I-- <Esc>A --<Esc>yyp0llv$hhhr-yykPjj

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" <Unused stuff>

" Don't change cursor position on undo
" nnoremap u m'u`'

" Use system clipboard
" set clipboard=unnamedplus
