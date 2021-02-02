" ==================================
" == KV Le's NeoVim Configuration ==
" ==================================

" Plug manager configuration
call plug#begin()
    Plug 'flazz/vim-colorschemes'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    Plug 'airblade/vim-gitgutter'
    Plug 'sheerun/vim-polyglot'
    Plug 'scrooloose/nerdtree'

    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-endwise'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'

    Plug 'habamax/vim-godot'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

let g:airline_theme = "deus"
let mapleader = "\<Space>"

set ruler
set spell
set hidden
set showcmd
set path+=**
set modeline
set linebreak
set scrolloff=2
set nocompatible
set termguicolors
set ignorecase smartcase
set relativenumber number
set timeoutlen=500 updatetime=500
set smartindent cindent autoindent
set expandtab tabstop=4 shiftwidth=4 smarttab

" Allow mouse usage
set mouse=a

" No need for two mode indicators (airline + vim)
set noshowmode

" Better searching
set incsearch nohlsearch

" Better wrap navigation
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
noremap <silent> 0 g0
noremap <silent> $ g$

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

" Add a semicolon to line without moving the cursor
nnoremap <Leader>; m'A;<Esc>`'

" NerdTree
map <Leader>f :NERDTreeToggle<Enter>

" Global substitution for things selected in visual mode
xnoremap gs y:%s/<C-r>"//g<Left><Left>

" Banner comments
nnoremap <buffer> <Leader>- I-- <Esc>A --<Esc>yyp0llv$hhhr-yykPjj
nnoremap <buffer> <Leader>= I== <Esc>A ==<Esc>yyp0llv$hhhr=yykPjj
nnoremap <buffer> <Leader>/ I// <Esc>A //<Esc>yyp0llv$hhhr=yykPjj

" Jump to the last known cursor position.
autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif

" VSCode specific configuration
if exists("g:vscode")
    source $HOME/.config/nvim/vscode.vim
endif

" Godot Settings
func! GodotSettings() abort
    " setlocal foldmethod=expr
    setlocal tabstop=4
    nnoremap <buffer> <F4> :GodotRunLast<CR>
    nnoremap <buffer> <F5> :GodotRun<CR>
    nnoremap <buffer> <F6> :GodotRunCurrent<CR>
    nnoremap <buffer> <F7> :GodotRunFZF<CR>
endfunc
augroup godot | au!
    au FileType gdscript call GodotSettings()
augroup end

" COC configuration
autocmd CursorHold * silent call CocActionAsync('highlight')

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

nmap <F2> <Plug>(coc-rename)
highlight CocFloating guibg=none ctermbg=none

" <Unused stuff>

" Don't change cursor position on undo
" nnoremap u m'u`'

" Use system clipboard
" set clipboard=unnamedplus
