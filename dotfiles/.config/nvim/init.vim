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
set title " Change Terminal Title
set hidden " Allow you to change buffers without saving
set confirm
set mouse=a " Allow mouse usage
set undofile
set autoread
set linebreak " Wrap text that is too long but without inserting EOL
set noshowmode " Disable native mode indicator (No need for two)
set lazyredraw
" set scrolloff=3 " Ensure at least some number of lines is above/below the cursor
set history=500
set noerrorbells " Disable annoying sounds :)
set termguicolors " Enable 24bit RBG color in the terminal UI
set updatetime=250
set signcolumn=yes
set conceallevel=2
set timeoutlen=350 " Delay for things to happen with multi key bindings
set viminfo='100,f1 " Save marks and stuff
set inccommand=split " Live update of commands like substitution
set jumpoptions+=stack
set incsearch nohlsearch " Don't highlight searches and auto update while searching
set ignorecase smartcase " Ignore case unless you have casing in your searches
set spell spelllang=en_us " Spellcheck
set splitbelow splitright " Splits occur below or to the right of the current window
set relativenumber number " Show relative number lines with regular number line on current line
filetype plugin indent on " Enable filetype detection and indentation
let mapleader = "\<Space>" " Set the leader key
set backspace=indent,eol,start " More robust backspacing
" set list listchars=eol:↴
set guifont=CodeNewRoman\ NF:h14 " Set a font for GUI things
set completeopt=menuone,noselect " For nvim-compe
set smartindent cindent autoindent " Better indenting
set omnifunc=syntaxcomplete#Complete
set breakindent breakindentopt=shift:0
set wildmenu wildmode=longest,list,full " Display completion matches in a status line
set expandtab tabstop=4 shiftwidth=4 smarttab " Replace tabs with spaces
set foldenable foldmethod=syntax foldlevel=6 " Dang I wish I could do both syntax and indent folding

" Make Powershell work :)
if has("win32")
    let &shell = "pwsh"
    let &shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
    let &shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    let &shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    set shellquote= shellxquote=
endif

" Entry into Lua config
if has("nvim")
    lua require("init")
else
    colorscheme nord
endif

" Make capital quitting quit all
:cabbrev WQ wqa
:cabbrev Q qa

:cabbrev msgs messages
:cabbrev mclear messages clear
:command! BO %bd | e# | bd# " (Buffer Only) Close all buffers but the current one

" ==============
" == Mappings ==
" ==============
" General Shortcuts
" New write command for sudo writing
command! SudoWrite w !sudo tee > /dev/null %
" Saving :)
nnoremap <C-s> :w<Enter>
" Redo stuff
nnoremap U <C-r>
" Global substitution for things selected in visual mode
xnoremap gs y:%s/<C-r>"//g<Left><Left>
" Help is now delegated to CTRL-h
nnoremap <C-h> K
noremap <M-x> :
noremap <Leader><Leader><Leader> :
nnoremap Q q:
" "Regular" Copy and Paste
inoremap <C-v> <Esc>"+pa
vnoremap <C-c> "+y<Esc>

" Custom Navigation Stuff
nnoremap <expr> j v:count ? "j" : "gj"
nnoremap <expr> k v:count ? "k" : "gk"
vnoremap <expr> j v:count ? "j" : "gj"
vnoremap <expr> k v:count ? "k" : "gk"
nnoremap N Nzzzv
nnoremap n nzzzv
nnoremap gm gM
nnoremap gM gm
nnoremap 0 g0
vnoremap 0 g0
nnoremap Y y$

nnoremap H g^
nnoremap L g$
vnoremap H g^
vnoremap L g$
nnoremap <M-o> o<Esc>
nnoremap <M-O> O<Esc>
" I have to find a more ergonomic way to scroll up and down
nnoremap \\ <C-d>
nnoremap \|\| <C-u>

nnoremap <Leader>w <C-w>
nnoremap <C-S-Up> <C-w>+
nnoremap <C-S-Down> <C-w>-
nnoremap <C-Up> <C-w>>
nnoremap <C-Down> <C-w><
nnoremap <C-w>v <C-w>v<C-w><C-l>
nnoremap <C-w><C-v> <C-w>v<C-w><C-l>

" Finer Undoing
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap = =<C-g>u
inoremap ] ]<C-g>u
inoremap } }<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u

" Banner comments
nnoremap <Leader>c- I-- <Esc>A --<Esc>yyp0llv$hhhr-yykPjj<Esc>
nnoremap <Leader>c= I== <Esc>A ==<Esc>yyp0llv$hhhr=yykPjj<Esc>
nnoremap <Leader>c/ I// <Esc>A //<Esc>yyp0llv$hhhr=yykPjj<Esc>

" Spell check (wtf are the defaults lol)
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
function! RefreshColor()
    if exists("g:colors_name")
        let current = g:colors_name
    else
        let current = "default"
    endif
    execute "colorscheme ".current
endfunction
nnoremap <F5> :call RefreshColor()<Enter>

