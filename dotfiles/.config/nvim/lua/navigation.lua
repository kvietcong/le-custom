local map = require("helpers").map

local function setup()
    -- Telescope (Fuzzy Finder) Setup
    require("telescope").setup { defaults = {
        layout_config = {
            prompt_position = "top",
        },
        layout_strategy = "flex",
        sorting_strategy = "ascending",
        set_env = { ["COLORTERM"] = "truecolor" },
    }}
    map("n <Leader>fa   :Telescope<Enter>")
    map("n <Leader>fb   :Telescope buffers<Enter>")
    map("n <Leader>fr   :Telescope oldfiles<Enter>")
    map("n <Leader>fg   :Telescope live_grep<Enter>")
    map("n <Leader>fh   :Telescope help_tags<Enter>")
    map("n <Leader>fm   :Telescope man_pages<Enter>")
    map("n <Leader>ff   :Telescope find_files<Enter>")
    map("n <Leader>ft   :Telescope treesitter<Enter>")
    map("n <Leader>fT   :TodoTelescope<Enter>")
    map("n <Leader>fs   :Telescope lsp_document_symbols<Enter>")
    map("n <Leader>fd   :Telescope lsp_document_diagnostics<Enter>")
    map("n gr           :Telescope lsp_references<Enter>")
    map("n z=           :Telescope spell_suggest<Enter>")
    map("n <Leader>/    :Telescope current_buffer_fuzzy_find<Enter>")
    map("n <Leader>?    :Telescope live_grep<Enter>")

    -- Bufferline (File tabs)
    require("bufferline").setup { options = {
        show_close_icon = false,
        diagnostics = "nvim_lsp",
        seperator_style = "thick"
    }}
    map("n <Leader>bk   :bd<Enter>")
    map("n <M-l>        :BufferLineCycleNext<Enter>")
    map("n <M-h>        :BufferLineCyclePrev<Enter>")
    map("n <Leader>bn   :BufferLineCycleNext<Enter>")
    map("n <Leader>bp   :BufferLineCyclePrev<Enter>")
    map("n <M-j>        :BufferLineMoveNext<Enter>")
    map("n <M-k>        :BufferLineMovePrev<Enter>")
    map("n <Leader>bmn  :BufferLineMoveNext<Enter>")
    map("n <Leader>bmp  :BufferLineMovePrev<Enter>")

    -- Neovim tree (File explorer)
    require("nvim-tree").setup()
    vim.g.nvim_tree_indent_markers = 1
    vim.g.nvim_tree_git_hl = 1
    vim.g.nvim_tree_add_trailing = 1
    map("n <Leader>fe :NvimTreeToggle<Enter>")

    -- Wiki Vim
    vim.g.wiki_mappings_use_defaults = "none"
    vim.g.wiki_root = "~/Documents/Notes"
    vim.g.wiki_link_extension = ".md"
    vim.g.wiki_filetypes = { "md", "markdown" }
    vim.g.wiki_journal = {
        name = "Journal",
        frequency = "daily",
        date_format = {
            daily = "%Y-%m-%d"
        }
    }
    vim.g.wiki_index_name = "- Index -.md"
    map("n <Leader>ww <Plug>(wiki-index)")
    map("n <Enter> <Plug>(wiki-link-follow)")
    map("n <Leader>wb <Plug>(wiki-graph-find-backlinks)")

    -- Lua Pad
    require("luapad").config { count_limit = 50000 }


    -- Lightspeed Setup (Allows for repeat searches)
    vim.cmd[[
        let g:lightspeed_last_motion = ""
        augroup lightspeed_last_motion
        autocmd!
        autocmd User LightspeedSxEnter let g:lightspeed_last_motion = "sx"
        autocmd User LightspeedFtEnter let g:lightspeed_last_motion = "ft"
        augroup end
        map <expr> ; g:lightspeed_last_motion == "sx" ? "<Plug>Lightspeed_;_sx" : "<Plug>Lightspeed_;_ft"
        map <expr> , g:lightspeed_last_motion == "sx" ? "<Plug>Lightspeed_,_sx" : "<Plug>Lightspeed_,_ft"
    ]]
end

return { setup = setup }
