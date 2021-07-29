" -----------------------------------
" ===================================
" ==== KV Le's Vim Configuration ====
" ===================================
" -----------------------------------

set nocompatible " Screw vi compatibility XD
" ======================
" == General Settings ==
" ======================
syntax on " Enable syntax highlighting
set spell " Spellcheck
set title " Change Terminal Title
set hidden " Allow you to change buffers without saving
set confirm
set mouse=a " Allow mouse usage
set nobackup
set autoread
set linebreak " Wrap text that is too long but without inserting EOL
set noshowmode " Disable native mode indicator (No need for two)
set lazyredraw
set scrolloff=3 " Ensure at least some number of lines is above/below the cursor
set history=500
set noerrorbells " Disable annoying sounds :)
set termguicolors " Enable 24bit RBG color in the terminal UI
set timeoutlen=350 " Delay for things to happen with multi key bindings
set inccommand=split " Live update of commands like substitution
" set foldmethod=syntax " Folds are made through syntax
set incsearch nohlsearch " Don't highlight searches and auto update while searching
set ignorecase smartcase " Ignore case unless you have casing in your searches
set splitbelow splitright " Splits occur below or to the right of the current window
set relativenumber number " Show relative number lines with regular number line on current line
filetype plugin indent on " Enable filetype detection and indentation
let mapleader = "\<Space>" " Set the leader key
set guifont=FiraCode\ NF:h16 " Set a font for GUI things
set backspace=indent,eol,start " More robust backspacing
set completeopt=menuone,noselect " For nvim-compe
set smartindent cindent autoindent " Better indenting
set wildmenu wildmode=longest,list,full " Display completion matches in a status line
set expandtab tabstop=4 shiftwidth=4 smarttab " Replace tabs with spaces

if has("win32") || has("win64")
    " Make Powershell work :)
    let &shell = "pwsh"
    let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    set shellquote= shellxquote=
endif

" Entry into Lua config
if has("nvim")
    lua require("init")
endif

" Case/Typo Insensitive Saving/Quitting
:command WQ wq
:command Wq wq
:command Qw wq
:command QW wq
:command Ww wq
:command Qq wq
:command QQ wq
:command WW wq
:command W w
:command Q q

" ==============
" == Mappings ==
" ==============
" General Shortcuts
" New write command for sudo writing
command! SudoWrite w !sudo tee > /dev/null %
" Saving :)
nnoremap <C-s> :w<Enter>
" Redo stuff
nnoremap <C-y> <C-r>
nnoremap U <C-r>
" Global substitution for things selected in visual mode
xnoremap gs y:%s/<C-r>"//g<Left><Left>
" Help is now delegated to CTRL-h
nnoremap <silent> <C-h> K

" Custom Navigation Stuff (Basically Vim Heresy)
nnoremap <silent><expr> j v:count ? "j" : "gj"
nnoremap <silent><expr> k v:count ? "k" : "gk"
nnoremap <silent> 0 g0
nnoremap gm gM
nnoremap Y y$

nnoremap <silent> H g^
nnoremap <silent> L g$
nnoremap <silent> J 10gj
nnoremap <silent> K 10gk
nnoremap <silent> <M-o> o<Esc>
nnoremap <silent> <M-O> O<Esc>

nnoremap gh <C-w>h
nnoremap gj <C-w>j
nnoremap gk <C-w>k
nnoremap gl <C-w>l
nnoremap <C-Up> <C-w>-
nnoremap <C-Down> <C-w>+
nnoremap <C-Left> <C-w><
nnoremap <C-Right> <C-w>>
nnoremap <C-w>v <C-w>v<C-w><C-l>
nnoremap <C-w><C-v> <C-w>v<C-w><C-l>
nnoremap <C-w>h <C-w>s
nnoremap <C-w><C-h> <C-w>s
nnoremap <C-w>h <C-w>s<C-w><C-j>
nnoremap <C-w><C-h> <C-w>s<C-w><C-j>

" Banner comments
nnoremap <Leader>c- I-- <Esc>A --<Esc>yyp0llv$hhhr-yykPjj<Esc>
nnoremap <Leader>c= I== <Esc>A ==<Esc>yyp0llv$hhhr=yykPjj<Esc>
nnoremap <Leader>c/ I// <Esc>A //<Esc>yyp0llv$hhhr=yykPjj<Esc>

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

" Refresh Colorscheme
function RefreshColor()
    if exists("g:colors_name")
        let current = g:colors_name
    else
        let current = "default"
    endif
    execute "colorscheme ".current
endfunction
nnoremap <silent><F5> :call RefreshColor()<Enter>

" ======================
" == GUI Vim settings ==
" ======================
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
