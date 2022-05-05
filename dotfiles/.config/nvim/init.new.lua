-- Remaking my config based off of the starter lua config @ https://github.com/nvim-lua/kickstart.nvim
local helpers = require("helpers")
local is_day = helpers.is_day

-- Install packer
local packer_bootstrap
local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
      "git", "clone", "--depth", "1",
      "https://github.com/wbthomason/packer.nvim", install_path
  })
  vim.api.nvim_command "packadd packer.nvim"
end

local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", { command = "source <afile> | PackerCompile", group = packer_group, pattern = "init.lua" })

local packer = require("packer")

packer.startup(function(use)
    use "wbthomason/packer.nvim" -- Package manager
    use "numToStr/Comment.nvim" -- "gc" to comment visual regions/lines
    use { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } } -- UI to select things (files, grep results, open buffers...)
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    use "shaunsingh/nord.nvim" -- Theme inspired by cool stuff
    use "nvim-lualine/lualine.nvim" -- Fancier statusline
    use "lukas-reineke/indent-blankline.nvim" -- Add indentation guides even on blank lines
    use { "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } } -- Add git related info in the signs columns and popups
    use "nvim-treesitter/nvim-treesitter" -- Highlight, edit, and navigate code using a fast incremental parsing library
    use "nvim-treesitter/nvim-treesitter-textobjects" -- Additional textobjects for treesitter
    use "neovim/nvim-lspconfig" -- Collection of configurations for built-in LSP client
    use "hrsh7th/nvim-cmp" -- Autocompletion plugin
    use "hrsh7th/cmp-nvim-lsp"
    use "saadparwaiz1/cmp_luasnip"
    use "L3MON4D3/LuaSnip" -- Snippets plugin

    if packer_bootstrap then
        packer.sync()
    end
end)

-- Colorscheme Options
vim.g.nord_borders = true
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_background = "soft"
vim.g.gruvbox_material_diagnostic_virtual_text = 1
vim.g.gruvbox_material_diagnostic_text_highlight = 1
vim.g.gruvbox_material_diagnostic_line_highlight = 1

-- Select day/night colorscheme
local lualine_colors = {
    nord = "nord",
    ["gruvbox-material"] = "gruvbox_light",
}
local colorschemes = { day = "gruvbox-material", night = "nord" }
local colorscheme
if is_day() then
    colorscheme = colorschemes.day
    vim.cmd[[set background=light]]
else
    colorscheme = colorschemes.night
end

-- Set Colorscheme
vim.cmd("colorscheme " .. colorscheme)

-- Set Status Bar
require("lualine").setup { options = {
    icons_enabled = true,
    theme = lualine_colors[colorscheme],
    component_separators = "|",
    section_separators = "",
}}

-- Setup Easy Commenting
require("Comment").setup()

-- Remap space as leader key #TODO
-- vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

-- Highlight on yank #TODO
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- Indent blankline
require("indent_blankline").setup {
    char = "┊",
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
    show_trailing_blankline_indent = true,
}

-- Gitsigns
require("gitsigns").setup()

-- Color Previews in Code
require("colorizer").setup()

-- Fancy TODO Highlighting
require("todo-comments").setup()

-- Telescope
require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
            },
        },
        layout_config = {
            prompt_position = "top",
        },
        layout_strategy = "flex",
        sorting_strategy = "ascending",
        set_env = { ["COLORTERM"] = "truecolor" },
    }
}
-- map("n <Leader>fa   :Telescope<Enter>")
-- map("n <Leader>fb   :Telescope buffers<Enter>")
-- map("n <Leader>fr   :Telescope oldfiles<Enter>")
-- map("n <Leader>fg   :Telescope live_grep<Enter>")
-- map("n <Leader>fh   :Telescope help_tags<Enter>")
-- map("n <Leader>fm   :Telescope man_pages<Enter>")
-- map("n <Leader>ff   :Telescope find_files<Enter>")
-- map("n <Leader>ft   :Telescope treesitter<Enter>")
-- map("n <Leader>fT   :TodoTelescope<Enter>")
-- map("n <Leader>fs   :Telescope lsp_document_symbols<Enter>")
-- map("n <Leader>fd   :Telescope lsp_document_diagnostics<Enter>")
-- map("n gr           :Telescope lsp_references<Enter>")
-- map("n z=           :Telescope spell_suggest<Enter>")
-- map("n <Leader>/    :Telescope current_buffer_fuzzy_find<Enter>")
-- map("n <Leader>?    :Telescope live_grep<Enter>")

-- Enable telescope fzf native #TODO
-- require("telescope").load_extension "fzf"

-- Add leader shortcuts #TODO
-- vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers)
-- vim.keymap.set("n", "<leader>sf", function()
--     require("telescope.builtin").find_files { previewer = false }
-- end)
-- vim.keymap.set("n", "<leader>/", require("telescope.builtin").current_buffer_fuzzy_find)
-- vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags)
-- vim.keymap.set("n", "<leader>st", require("telescope.builtin").tags)
-- vim.keymap.set("n", "<leader>sd", require("telescope.builtin").grep_string)
-- vim.keymap.set("n", "<leader>sp", require("telescope.builtin").live_grep)
-- vim.keymap.set("n", "<leader>so", function()
--     require("telescope.builtin").tags { only_current_buffer = true }
-- end)
-- vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles)

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require("nvim-treesitter.configs").setup {
    highlight = {
        enable = true, -- false will disable the whole extension
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    indent = {
        enable = true,
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
    },
}

-- Diagnostic keymaps #TODO
-- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- LSP settings
local lspconfig = require "lspconfig"
local on_attach = function(_, bufnr)
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wl", function()
        vim.inspect(vim.lsp.buf.list_workspace_folders())
    end, opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>so", require("telescope.builtin").lsp_document_symbols, opts)
    vim.api.nvim_create_user_command("Format", vim.lsp.buf.formatting, {})
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- Enable the following language servers
local servers = { "clangd", "rust_analyzer", "pyright", "tsserver" }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

-- Example custom server
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you"re using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

-- luasnip setup
local luasnip = require("luasnip")

-- nvim-cmp setup
local cmp = require "cmp"
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
    },
}

