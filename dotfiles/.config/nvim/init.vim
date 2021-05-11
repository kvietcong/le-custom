" ==================================
" == KV Le's NeoVim Configuration ==
" ==================================
" Vim Plug manager configuration
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
    Plug 'nvim-lua/plenary.nvim'
    Plug 'kyazdani42/nvim-tree.lua'
    Plug 'nvim-telescope/telescope.nvim'
call plug#end()

" ================
" GUI Vim settings
" ================
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

" ================
" General Settings
" ================
let g:vimsyn_embed = 'l' " Lua syntax highlighting in vimscript
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
set ignorecase smartcase " Ignore case unless you have casing in your seraches
set splitbelow splitright " Splits occur below or to the right of the current window
set relativenumber number " Show relative number lines with regular number line on current line
filetype plugin indent on " Enable filetype detection and indentation
set guifont=FiraCode\ NF:h16 " Set a font for GUI things
set backspace=indent,eol,start " More robust backspacing
set smartindent cindent autoindent " Better indenting
set wildmenu wildmode=longest,list,full " Display completion matches in a status line
set expandtab tabstop=4 shiftwidth=4 smarttab " Replace tabs with spaces

" ========
" Mappings
" ========
let mapleader = "\<Space>" " Set the leader key
set timeoutlen=1000 " Prevent too much leader key lag

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
nnoremap <Leader>vs :vs<Enter>
nnoremap <Leader>hs :sp<Enter>

" Global substitution for things selected in visual mode
xnoremap gs y:%s/<C-r>"//g<Left><Left>

" Banner comments
nnoremap <buffer> <Leader>c- I-- <Esc>A --<Esc>yyp0llv$hhhr-yykPjj
nnoremap <buffer> <Leader>c= I== <Esc>A ==<Esc>yyp0llv$hhhr=yykPjj
nnoremap <buffer> <Leader>c/ I// <Esc>A //<Esc>yyp0llv$hhhr=yykPjj

" Telescope bindings
nnoremap <leader>fb :Telescope buffers<cr>
nnoremap <leader>fg :Telescope live_grep<cr>
nnoremap <leader>fr :Telescope registers<cr>
nnoremap <leader>fh :Telescope help_tags<cr>
nnoremap <leader>ff :Telescope find_files<cr>
nnoremap <leader>fs :Telescope spell_suggest<cr>
nnoremap <leader>/  :Telescope current_buffer_fuzzy_find<cr>

" Nerd Tree
nnoremap <leader>fe :NvimTreeToggle<CR>

" Buffer commands
nnoremap <leader>bd :bd<CR>
nnoremap <leader>bn :BufferLineCycleNext<CR>
nnoremap <leader>bp :BufferLineCyclePrev<CR>
nnoremap <leader>BN :BufferLineMoveNext<CR>
nnoremap <leader>BP :BufferLineMovePrev<CR>

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

" =======
" Configs
" =======
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

" Haskell Vim
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
