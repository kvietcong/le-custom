-- Install packer if needed
local packer_bootstrap
local packer_path = data_path .. "/site/pack/packer/start/packer.nvim"
if vfn.empty(vfn.glob(packer_path, nil, nil)) > 0 then
    packer_bootstrap = vfn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        packer_path,
    })
    vapi.nvim_command("packadd packer.nvim")
end

-- Install all the plugins
local packer = require("packer")
packer.startup({
    function(use)
        use("wbthomason/packer.nvim")
        use("dstein64/vim-startuptime") -- Run :StartupTime
        use("lewis6991/impatient.nvim") -- Cache Lua Plugins

        -- Common Dependencies
        use("nvim-lua/popup.nvim")
        use("nvim-lua/plenary.nvim")
        use("kyazdani42/nvim-web-devicons")

        -- Quality of Life
        use("tpope/vim-eunuch")
        use("tpope/vim-repeat")
        use("ggandor/leap.nvim")
        use("folke/which-key.nvim")
        use("voldikss/vim-floaterm")
        use("echasnovski/mini.nvim")
        use("TimUntersberger/neogit")
        use("sindrets/winshift.nvim")

        use({
            "nanotee/zoxide.vim",
            cmd = { "Z" },
        })
        use({
            "glacambre/firenvim",
            run = function()
                vim.fn["firenvim#install"](0)
            end,
        })

        -- Neovim Development
        use("Olical/conjure")
        use("folke/lua-dev.nvim")
        use("rktjmp/hotpot.nvim")
        use("bakpakin/fennel.vim")
        use("nanotee/luv-vimdocs")
        use("milisims/nvim-luaref")
        use("rafcamlet/nvim-luapad")
        use("wlangstroth/vim-racket")
        use({ "eraserhd/parinfer-rust", run = "cargo build --release" })

        -- Pretty Things
        use("folke/zen-mode.nvim")
        use("rcarriga/nvim-notify")
        use("shaunsingh/nord.nvim")
        use("p00f/nvim-ts-rainbow")
        use("stevearc/dressing.nvim")
        use("lewis6991/gitsigns.nvim")
        use("sainnhe/gruvbox-material")
        use("mrjones2014/legendary.nvim")
        use("norcalli/nvim-colorizer.lua")
        use("akinsho/nvim-bufferline.lua")

        use({
            "neovimhaskell/haskell-vim",
            ft = { "haskell" },
        })

        -- Writing
        use("crispgm/telescope-heading.nvim")

        use({
            "lervag/wiki.vim",
            ft = { "markdown", "wiki" },
        })
        use({
            "godlygeek/tabular",
            ft = { "markdown", "wiki" },
        })
        use({
            "jbyuki/carrot.nvim",
            ft = { "markdown", "wiki" },
        })
        use({
            "preservim/vim-markdown",
            ft = { "markdown", "wiki" },
        })

        -- Pickers/Finders
        use("tversteeg/registers.nvim")
        use("nvim-telescope/telescope.nvim")
        use("olacin/telescope-gitmoji.nvim")
        use("kvietcong/telescope-emoji.nvim")
        use("nvim-telescope/telescope-packer.nvim")
        use("nvim-telescope/telescope-symbols.nvim")
        use("nvim-telescope/telescope-ui-select.nvim")
        use("nvim-telescope/telescope-file-browser.nvim")
        use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

        -- Treesitter
        use("SmiteshP/nvim-gps")
        use("lewis6991/spellsitter.nvim")
        use("nvim-treesitter/nvim-treesitter")
        use("nvim-treesitter/nvim-treesitter-refactor")
        use("nvim-treesitter/nvim-treesitter-textobjects")
        use("JoosepAlviste/nvim-ts-context-commentstring")

        -- LSP
        use("neovim/nvim-lspconfig")
        use("ray-x/lsp_signature.nvim")
        use("jose-elias-alvarez/null-ls.nvim")
        use("williamboman/nvim-lsp-installer")

        -- Completion
        use("hrsh7th/cmp-omni")
        use("hrsh7th/cmp-calc")
        use("L3MON4D3/LuaSnip")
        use("hrsh7th/nvim-cmp")
        use("hrsh7th/cmp-path")
        use("f3fora/cmp-spell")
        use("hrsh7th/cmp-emoji")
        use("tzachar/fuzzy.nvim")
        use("hrsh7th/cmp-buffer")
        use("ray-x/cmp-treesitter")
        use("onsails/lspkind.nvim")
        use("hrsh7th/cmp-nvim-lsp")
        use("PaterJason/cmp-conjure")
        use("tzachar/cmp-fuzzy-buffer")
        use("saadparwaiz1/cmp_luasnip")
        use("kdheepak/cmp-latex-symbols")
        use("hrsh7th/cmp-nvim-lsp-signature-help")
        use("hrsh7th/cmp-nvim-lsp-document-symbol")

        packer.clean()
        packer.install()

        if packer_bootstrap then
            packer.sync()
        end
    end,
    config = {
        display = {
            open_fn = function()
                return require("packer.util").float({ border = "single" })
            end,
        },
        profile = {
            enable = true,
            threshold = 0.01,
        },
    },
})

return packer
