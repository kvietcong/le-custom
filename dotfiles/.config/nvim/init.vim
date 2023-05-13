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
set nottimeout
set scrolloff=2 " Ensure at least some number of lines is above/below the cursor
set history=500
set noerrorbells " Disable annoying sounds :)
set termguicolors " Enable 24bit RBG color in the terminal UI
set updatetime=250
set signcolumn=yes
set timeoutlen=300 " Delay for things to happen with multi key bindings
set listchars=eol:↴
set viminfo='100,f1 " Save marks and stuff
set formatoptions-=cro " Disable auto commenting
set incsearch nohlsearch " Don't highlight searches and auto update while searching
set ignorecase smartcase " Ignore case unless you have casing in your searches
set lazyredraw noswapfile " Performance
set spell spelllang=en_us " Spellcheck
set splitbelow splitright " Splits occur below or to the right of the current window
set relativenumber number " Show relative number lines with regular number line on current line
filetype plugin indent on " Enable filetype detection and indentation
set backspace=indent,eol,start " More robust backspacing
set smartindent cindent autoindent " Better indenting
set conceallevel=2 concealcursor=nc
set omnifunc=syntaxcomplete#Complete
set breakindent breakindentopt=shift:0
set completeopt=menuone,noselect,preview
set expandtab tabstop=4 shiftwidth=4 smarttab " Replace tabs with spaces
set foldenable foldmethod=indent foldlevel=60 " Dang I wish I could do both syntax and indent folding
set guifont=CodeNewRoman\ NF:h14,FiraCode\ NF,CaskaydiaCove\ NF " Set a font for GUI things

let mapleader = "\<Space>"
let g:netrw_banner = 0

" Make Powershell work :)
if has("win32")
    let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
    let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    let &shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
    let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    set shellquote= shellxquote=
endif

" Entry into Lua config
if has("nvim")
    " Ensure init is freshly loaded
    lua package.loaded.init = nil
    lua require("init")

    set inccommand=split " Live update of commands like substitution
    set jumpoptions+=stack

    autocmd TermOpen * setlocal nonu
    autocmd TermOpen * setlocal nornu
    autocmd TermOpen * setlocal nospell
else
    colorscheme nord

    set undodir=~/.vim/undos
    autocmd TerminalOpen * setlocal nonu
    autocmd TerminalOpen * setlocal nornu
    autocmd TerminalOpen * setlocal nospell
endif

tnoremap <Escape><Escape><Escape> <C-\><C-n>
tnoremap <M-Escape><M-Escape><M-Escape> <C-\><C-n>

" Make capital quitting quit all
:cabbrev WQ wqa
:cabbrev Q qa

:command! M messages
:command! MC messages clear
:command! BO %bd | e# | bd# " (Buffer Only) Close all buffers but the current one

" ==============
" == Mappings ==
" ==============

" Saving :)
nnoremap <C-s> :w<Enter>

" Re/Undo stuff
nnoremap U <C-r>
noremap <C-z> u
noremap <C-S-z> u
noremap <C-y> <C-r>

" Reload config
nnoremap <silent> <Leader><Leader>r :source $MYVIMRC<Enter>

" Global substitution for things selected in visual mode
xnoremap gs y:%s/<C-r>"//g<Left><Left>

" Help is now delegated to CTRL-h
nnoremap <C-h> K

" Other ways to reach command mode (Emacs moment XD)
noremap <M-x> :
inoremap <M-x> <Escape>:
noremap <Leader><Leader><Leader> :

" Alternate between two buffers or windows
nnoremap <S-Tab> <C-^>
nnoremap <C-Tab> <C-w><C-p>

" Better Exit
nnoremap <Leader><Leader>q :qa<Enter>

" "Regular" Copy and Paste in various places
inoremap <C-v> <Esc>"+pa
vnoremap <C-c> "+y<Esc>
cnoremap <C-v> <C-r>+

" Custom Navigation Stuff
nnoremap <expr> j v:count ? "j" : "gj"
nnoremap <expr> k v:count ? "k" : "gk"
vnoremap <expr> j v:count ? "j" : "gj"
vnoremap <expr> k v:count ? "k" : "gk"
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
vnoremap <C-d> <C-d>zz
vnoremap <C-u> <C-u>zz
nnoremap <C-j> <C-d>zz
nnoremap <C-k> <C-u>zz
vnoremap <C-j> <C-d>zz
vnoremap <C-k> <C-u>zz
nnoremap <C-Down> <C-d>zz
nnoremap <C-Up> <C-u>zz
vnoremap <C-Down> <C-d>zz
vnoremap <C-Up> <C-u>zz
nnoremap <Leader>H g^
nnoremap <Leader>L g$
vnoremap <Leader>H g^
vnoremap <Leader>L g$
nnoremap gm gM
nnoremap gM gm
vnoremap gm gM
vnoremap gM gm
nnoremap Y y$

" Enter Empty Lines
nnoremap <M-o> o<Escape>k
nnoremap <M-O> O<Escape>j

" Easier Window Commanding
nnoremap <Leader>w <C-w>

" Keep pasted value on replace
vnoremap p "_dP

" Text Movement
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
nnoremap <M-Down> :m .+1<CR>==
nnoremap <M-Up> :m .-2<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi
inoremap <M-Down> <Esc>:m .+1<CR>==gi
inoremap <M-Up> <Esc>:m .-2<CR>==gi
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv
vnoremap <M-Down> :m '>+1<CR>gv=gv
vnoremap <M-Up> :m '<-2<CR>gv=gv

" Fold Manipulation
nnoremap <Leader><Leader>ff zA

" Finer Undoing
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap = =<C-g>u
inoremap ] ]<C-g>u
inoremap } }<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u

" cd into directory of current buffer
nnoremap <silent> <Leader>cd :cd %:p:h<CR>

" Better Marks?
nnoremap ' `
nnoremap ` '

" Banner comments
nnoremap <Leader>c- I-- <Esc>A --<Esc>yyp0llv$hhhr-yykPjj<Esc>
nnoremap <Leader>c= I== <Esc>A ==<Esc>yyp0llv$hhhr=yykPjj<Esc>
nnoremap <Leader>c/ I// <Esc>A //<Esc>yyp0llv$hhhr=yykPjj<Esc>

" Spell check (wtf are the defaults lol)
" Add word to dictionary (Spelling Add)
nnoremap <Leader><Leader>sa zg
" Remove word from dictionary (Spelling Remove)
nnoremap <Leader><Leader>sr zw
" Go to next spelling error (Spelling Next)
nnoremap <Leader><Leader>sl ]s
" Go to previous spelling error (Spelling Previous)
nnoremap <Leader><Leader>sh [s
" Under last dictionary task (Spelling Undo)
nnoremap <Leader><Leader>su zug

" Some insert mode mappings (Terminal input sucks. IDK how the two noremaps even work)
inoremap <C-BS> <C-W>
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

" Jump to the last known cursor position.
autocmd! BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# "commit"
    \ |   exe "normal! g`\""
    \ | endif

" Make configuration files indent based on indent
autocmd! BufNewFile,BufRead *.json,*.toml,*.yml,*.yaml set foldmethod=indent

