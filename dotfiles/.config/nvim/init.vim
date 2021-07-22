" --------------------------------------
" ======================================
" ==== KV Le's NeoVim Configuration ====
" ======================================
" --------------------------------------

" =====================
" == UI Vim settings ==
" =====================
if exists("g:neovide")
    let g:neovide_transparency=0.95
    let g:neovide_refresh_rate=144
    let g:neovide_cursor_trail_length=0.5
    let g:neovide_cursor_animation_length=0.1
    let g:neovide_cursor_antialiasing=v:true
elseif exists("g:fvim_loaded")
    FVimBackgroundComposition "blur"
    FVimBackgroundOpacity 0.75
    FVimBackgroundAltOpacity 0.75
    FVimFontAntialias v:true
    FVimUIMultiGrid v:false
endif

" ======================
" == General Settings ==
" ======================
syntax on " Enable syntax highlighting
set spell " Spellcheck
set hidden " Allow you to change buffers without saving
set mouse=a " Allow mouse usage
let mapleader = "\<Space>" " Set the leader key
set linebreak " Wrap text that is too long but without inserting EOL
set noshowmode " Disable native mode indicator (No need for two)
set scrolloff=8 " Ensure at least some number of lines is above/below the cursor
set noerrorbells " Disable annoying sounds :)
set termguicolors " Enable 24bit RBG color in the terminal UI
set timeoutlen=350 " Delay for things to happen with multi key bindings
" set foldmethod=syntax " Folds are made through syntax
set incsearch nohlsearch " Don't highlight searches and auto update while searching
set ignorecase smartcase " Ignore case unless you have casing in your searches
set splitbelow splitright " Splits occur below or to the right of the current window
set relativenumber number " Show relative number lines with regular number line on current line
filetype plugin indent on " Enable filetype detection and indentation
set guifont=FiraCode\ NF:h16 " Set a font for GUI things
set backspace=indent,eol,start " More robust backspacing
set completeopt=menuone,noselect " For nvim-compe
set smartindent cindent autoindent " Better indenting
set wildmenu wildmode=longest,list,full " Display completion matches in a status line
set expandtab tabstop=4 shiftwidth=4 smarttab " Replace tabs with spaces

if has('win32') || has('win64')
    set shell=pwsh
endif

" Entry into Lua config
lua require("init")

" ==============
" == Mappings ==
" ==============
" General Shortcuts
" Move to the start of the line
nnoremap <Leader>, ^
" Move to the end of the line
nnoremap <Leader>. $
" New write command for sudo writing
command! SudoWrite w !sudo tee > /dev/null %
" Saving :)
nnoremap <C-s> :w<Enter>
" Redoing (For some reason I can't remap <C-y>)
nnoremap <C-Z> <C-r>
nnoremap <C-y> <C-r>
" Global substitution for things selected in visual mode
xnoremap gs y:%s/<C-r>"//g<Left><Left>

" "Better" wrap navigation
nmap <silent><expr> j v:count ? "j" : "gj"
nmap <silent><expr> k v:count ? "k" : "gk"
noremap <silent> 0 g0
noremap <silent> $ g$

" Better split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Banner comments
nnoremap <buffer> <Leader>c- I-- <Esc>A --<Esc>yyp0llv$hhhr-yykPjj<Esc>
nnoremap <buffer> <Leader>c= I== <Esc>A ==<Esc>yyp0llv$hhhr=yykPjj<Esc>
nnoremap <buffer> <Leader>c/ I// <Esc>A //<Esc>yyp0llv$hhhr=yykPjj<Esc>

" Spell check
" Add word to dictionary (Spelling Add)
nnoremap <Leader>sa zg
" Remove word from dictionary (Spelling Remove)
nnoremap <Leader>sr zw
" Go to next spelling error (Spelling Next)
nnoremap <Leader>sn ]s
" Go to previous spelling error (Spelling Previous)
nnoremap <Leader>sp [s
" Under last dictionary task (Spelling Undo)
nnoremap <Leader>su zug

" Jump to the last known cursor position.
autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# "commit"
    \ |   exe "normal! g`\""
    \ | endif
