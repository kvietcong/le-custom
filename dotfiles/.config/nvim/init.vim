" ==================================
" == KV Le's NeoVim Configuration ==
" ==================================

" TODO
" Which Key Setup
" Move to Lua configs (Packer, etc)

" ====================================
" == Vim Plug manager configuration ==
" ====================================
call plug#begin()
    " Colorscheme/UI Plugins
    Plug 'luochen1990/rainbow'
    Plug 'maaslalani/nordbuddy'
    Plug 'karb94/neoscroll.nvim'
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'vim-airline/vim-airline'
    Plug 'tjdevries/colorbuddy.nvim'
    Plug 'neovimhaskell/haskell-vim'
    Plug 'akinsho/nvim-bufferline.lua'
    Plug 'norcalli/nvim-colorizer.lua'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'lukas-reineke/indent-blankline.nvim', { 'branch': 'lua' }

    " Language Plugins
    Plug 'folke/lsp-colors.nvim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    " Other Utility Plugins
    Plug 'vimwiki/vimwiki'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'b3nj5m1n/kommentary'
    Plug 'nvim-lua/popup.nvim'
    Plug 'folke/which-key.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'kyazdani42/nvim-tree.lua'
    Plug 'nvim-telescope/telescope.nvim'
call plug#end()

" =====================
" == UI Vim settings ==
" =====================
if exists('g:neovide')
    let g:neovide_transparency=0.95
    let g:neovide_refresh_rate=144
    let g:neovide_cursor_trail_length=0.5
    let g:neovide_cursor_animation_length=0.1
    let g:neovide_cursor_antialiasing=v:true
elseif exists('g:fvim_loaded')
    FVimBackgroundComposition 'blur'
    FVimBackgroundOpacity 0.75
    FVimBackgroundAltOpacity 0.75
    FVimFontAntialias v:true
    FVimUIMultiGrid v:false
else
    " Transparent background in terminals
    autocmd ColorScheme * highlight! Normal ctermbg=NONE guibg=NONE
endif

" ======================
" == General Settings ==
" ======================
let g:vimsyn_embed = 'l' " Lua syntax highlighting in vimscript
let g:nord_italic = v:false " Disable italics because it's weird in Windows Terminal ☹
let g:nord_spell = 'underline' " Underlined misspelled words

syntax on " Enable syntax highlighting
set spell " Spellcheck
set hidden " Allow you to change buffers without saving
set mouse=a " Allow mouse usage
set linebreak " Wrap text that is too long but without inserting EOL
set noshowmode " Disable native mode indicator (No need for two)
set scrolloff=2 " Ensure at least some number of lines is above/below the cursor
set termguicolors " Enable 24bit RBG color in the terminal UI
colorscheme nordbuddy " Set color scheme
set incsearch nohlsearch " Don't highlight searches and auto update while searching
set ignorecase smartcase " Ignore case unless you have casing in your searches
set splitbelow splitright " Splits occur below or to the right of the current window
set relativenumber number " Show relative number lines with regular number line on current line
filetype plugin indent on " Enable filetype detection and indentation
set guifont=FiraCode\ NF:h16 " Set a font for GUI things
set backspace=indent,eol,start " More robust backspacing
set smartindent cindent autoindent " Better indenting
set wildmenu wildmode=longest,list,full " Display completion matches in a status line
set expandtab tabstop=4 shiftwidth=4 smarttab " Replace tabs with spaces

" ==============
" == Mappings ==
" ==============
let mapleader = "\<Space>" " Set the leader key
set timeoutlen=350 " Delay for things to happen with multi key bindings

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

" Git
noremap <Leader>gh :Gitsigns next_hunk<Enter>
noremap <Leader>gH :Gitsign prev_hunk<Enter>

" Better wrap navigation
nnoremap <silent><expr> j v:count ? 'j' : 'gj'
nnoremap <silent><expr> k v:count ? 'k' : 'gk'
noremap <silent> 0 g0
noremap <silent> $ g$

" Better split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Vertical and Horizontal Split respectively
nnoremap <Leader>vs :vs<Enter>
nnoremap <Leader>hs :sp<Enter>

" Banner comments
nnoremap <buffer> <Leader>c- I-- <Esc>A --<Esc>yyp0llv$hhhr-yykPjj<Esc>
nnoremap <buffer> <Leader>c= I== <Esc>A ==<Esc>yyp0llv$hhhr=yykPjj<Esc>
nnoremap <buffer> <Leader>c/ I// <Esc>A //<Esc>yyp0llv$hhhr=yykPjj<Esc>

" Spell check
" Add word to dictionary (Spelling Add)
nnoremap <Leader>sa zg
" Remove word from dictionary (Spelling Remove)
nnoremap <Leader>sr zw
" Under last dictionary task (Spelling Undo)
nnoremap <Leader>su zug

" Telescope
nnoremap <Leader>fb :Telescope buffers<Enter>
nnoremap <Leader>fg :Telescope live_grep<Enter>
nnoremap <Leader>ft :Telescope help_tags<Enter>
nnoremap <Leader>fm :Telescope man_pages<Enter>
nnoremap <Leader>ff :Telescope find_files<Enter>
" This replaces the old spell checker interface
nnoremap z=         :Telescope spell_suggest<Enter>
nnoremap <Leader>/  :Telescope current_buffer_fuzzy_find<Enter>

" Nerd Tree
nnoremap <Leader>fe :NvimTreeToggle<Enter>

" Buffer commands
nnoremap <Leader>bd :bd<Enter>
nnoremap <Leader>bn :BufferLineCycleNext<Enter>
nnoremap <Leader>bp :BufferLineCyclePrev<Enter>
nnoremap <Leader>BN :BufferLineMoveNext<Enter>
nnoremap <Leader>BP :BufferLineMovePrev<Enter>
nnoremap <Right>    :BufferLineCycleNext<Enter>
nnoremap <Left>     :BufferLineCyclePrev<Enter>
nnoremap <Up>       :BufferLineMoveNext<Enter>
nnoremap <Down>     :BufferLineMovePrev<Enter>

" Jump to the last known cursor position.
autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif

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

nnoremap <silent> K :call <SID>show_documentation()<Enter>
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

" =============
" == Configs ==
" =============
lua require('gitsigns').setup() -- "Git Signs on the side"
lua require('kommentary.config').setup() -- "Kommentary (Commenting)"
lua require('bufferline').setup() -- "Bufferline (File tabs)"
lua require('neoscroll').setup() -- "NeoScroll (Smoth scrolling for window movement)"
lua require('colorizer').setup() -- "Color highlighter"
lua require('nvim-treesitter.configs')
    \.setup{highlight={enable=true},indent={enable=true}} -- "Better Language Parsing"

let g:airline_theme = "deus" " Set Vim Airline (status bar) theme

" Configuration for colorful matching brackets
let g:rainbow_conf = {
\	'guifgs': ['Cyan1', 'PaleGreen1', 'Magenta1', 'Gold1'],
\	'ctermfgs': [51, 121, 201, 220],
\	'separately': {
\		'haskell': {
\			'parentheses': ['start=/(/ end=/)/ fold',
                           \'start=/\[/ end=/\]/ fold',
                           \'start=/\v\{\ze[^-]/ end=/}/ fold'],
\		},
\	}
\}

let g:rainbow_active = 1 " Enable colored brackets

" Neovim tree (File explorer)
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ]
let g:nvim_tree_indent_markers = 1
let g:nvim_tree_git_hl = 1
let g:nvim_tree_add_trailing = 1
let g:nvim_tree_special_files = [ 'README.md', 'Makefile', 'MAKEFILE' ]

" Vim Wiki
let g:vimwiki_list = [{'path': 'D:/Documents/Obsidian/', 'syntax': 'markdown', 'ext': '.md'}]

" Which Key
lua require("which-key").setup()

" Haskell Vim
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
