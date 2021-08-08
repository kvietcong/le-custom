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
    map("n <Leader>fcr  :Telescope lsp_references<Enter>")
    map("n <Leader>fcs  :Telescope lsp_document_symbols<Enter>")
    map("n <Leader>fca  :Telescope lsp_code_actions<Enter>")
    map("n <Leader>fci  :Telescope lsp_implementations<Enter>")
    map("n <Leader>fcd  :Telescope lsp_definitions<Enter>")
    map("n <Leader>fcD  :Telescope lsp_document_diagnostics<Enter>")
    map("n z=           :Telescope spell_suggest<Enter>")
    map("n <Leader>/    :Telescope current_buffer_fuzzy_find<Enter>")
    map("n <Leader>?    :Telescope live_grep<Enter>")

    -- Lightspeed Setup
    function Repeat_Search(reverse)
        local ls = require'lightspeed'
        ls.ft['instant-repeat?'] = true
        ls.ft:to(reverse, ls.ft['prev-t-like?'])
    end
    -- Find out why I have to use <CMD> to make this work in visual mode. Like WTF?
    map("n ; <CMD>lua Repeat_Search(false)<Enter>")
    map("x ; <CMD>lua Repeat_Search(false)<Enter>")
    map("n , <CMD>lua Repeat_Search(true)<Enter>")
    map("x , <CMD>lua Repeat_Search(true)<Enter>")

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
    vim.g.nvim_tree_indent_markers = 1
    vim.g.nvim_tree_git_hl = 1
    vim.g.nvim_tree_add_trailing = 1
    map("n <Leader>fe :NvimTreeToggle<Enter>")

    -- Wiki Vim
    vim.g.wiki_root = "~/Documents/Notes"
    vim.g.wiki_link_extension = ".md"
    vim.g.wiki_filetypes = { "md", "wiki", "markdown" }
    vim.g.wiki_journal = {
        name = "Journal",
        frequency = "daily",
        date_format = {
            daily = "%Y-%m-%d"
        }
    }

    -- Lua Pad
    require("luapad").config { count_limit = 50000 }

    -- Org Mode
    require("orgmode").setup({
      org_agenda_files = {"~/Documents/Notes/org-mode/*"},
      org_default_notes_file = "~/Documents/Notes/org-mode/Inbox.org"
    })
    require("org-bullets").setup { symbols = { "◉", "○", "✸", "✿" }}

    -- Better Wild Menu (Completion Menu)
    vim.cmd[[
        call wilder#enable_cmdline_enter()
        set wildcharm=<Tab>
        cmap <expr> <C-n> wilder#in_context() ? wilder#next() : "<C-n>"
        cmap <expr> <C-p> wilder#in_context() ? wilder#previous() : "<C-p>"
        call wilder#set_option('modes', ['/', '?', ':'])

        call wilder#set_option('pipeline', [wilder#branch(wilder#cmdline_pipeline({'fuzzy': 1, 'sorter': wilder#python_difflib_sorter(), }), wilder#python_search_pipeline({ 'pattern': 'fuzzy', }),), ])

        let g:highlighters = [wilder#pcre2_highlighter(),wilder#basic_highlighter(),]

        call wilder#set_option('renderer', wilder#renderer_mux({ ':': wilder#popupmenu_renderer({ 'highlighter': g:highlighters, }), '/': wilder#wildmenu_renderer({ 'highlighter': g:highlighters, }), }))
    ]]
end

return { setup = setup }
