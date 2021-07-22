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
    map("n <Leader>fo   :Telescope oldfiles<Enter>")
    map("n <Leader>fg   :Telescope live_grep<Enter>")
    map("n <Leader>fh   :Telescope help_tags<Enter>")
    map("n <Leader>fm   :Telescope man_pages<Enter>")
    map("n <Leader>ff   :Telescope find_files<Enter>")
    map("n <Leader>ft   :Telescope treesitter<Enter>")
    map("n <Leader>fcr  :Telescope lsp_references<Enter>")
    map("n <Leader>fcs  :Telescope lsp_document_symbols<Enter>")
    map("n <Leader>fca  :Telescope lsp_code_actions<Enter>")
    map("n <Leader>fci  :Telescope lsp_implementations<Enter>")
    map("n <Leader>fcd  :Telescope lsp_definitions<Enter>")
    map("n <Leader>fcD  :Telescope lsp_document_diagnostics<Enter>")
    map("n z=           :Telescope spell_suggest<Enter>")
    map("n <Leader>/    :Telescope current_buffer_fuzzy_find<Enter>")

    -- Bufferline (File tabs)
    require("bufferline").setup { options = {
        show_close_icon = false,
        seperator_style = "thin",
    }}
    map("n <Leader>bd     :bd<Enter>")
    map("n <Leader>bn     :BufferLineCycleNext<Enter>")
    map("n <Leader>bp     :BufferLineCyclePrev<Enter>")
    map("n <Leader>bmn    :BufferLineMoveNext<Enter>")
    map("n <Leader>bmp    :BufferLineMovePrev<Enter>")
    map("n <Right>        :BufferLineCycleNext<Enter>")
    map("n <Left>         :BufferLineCyclePrev<Enter>")
    map("n <Up>           :BufferLineMoveNext<Enter>")
    map("n <Down>         :BufferLineMovePrev<Enter>")

    -- Lightspeed Setup
    --- Enables Lightspeed to use , and ; as repeats
    --- @param reverse boolean If serach direction should be reversed
    function Repeat_Search(reverse)
      local ls = require'lightspeed'
      ls.ft["instant-repeat?"] = true
      ls.ft:to(reverse, ls.ft["prev-t-like?"])
    end
    map("n ; :lua Repeat_Search(false)<Enter>")
    map("x ; :lua Repeat_Search(false)<Enter>")
    map("n , :lua Repeat_Search(true)<Enter>")
    map("x , :lua Repeat_Search(true)<Enter>")

    -- Neovim tree (File explorer)
    vim.g.nvim_tree_indent_markers = 1
    vim.g.nvim_tree_git_hl = 1
    vim.g.nvim_tree_add_trailing = 1
    map("n <Leader>fe :NvimTreeToggle<Enter>")
end

local navigation = {}
navigation.setup = setup
return navigation
