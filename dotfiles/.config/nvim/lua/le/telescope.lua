------------------------
-- Telescope Setup 🔭 --
------------------------

-- local actions = require("telescope.actions")
local telescope = require("telescope")
local whichkey = require("le.which-key")
local lf = require("le.libf")
local themes = require("telescope.themes")

telescope.setup({
    defaults = {
        mappings = {
            i = {
                -- ["<Esc>"] = actions.close,
            },
        },
        layout_config = {
            prompt_position = "top",
        },
        layout_strategy = "flex",
        sorting_strategy = "ascending",
        file_ignore_patterns = { "node_modules" },
    },
    extensions = {
        ["ui-select"] = {
            themes.get_ivy({
                layout_strategy = "center",
                layout_config = {
                    width = 0.333,
                    height = 0.666,
                },
            }),
        },
        heading = {
            treesitter = true,
        },
    },
})

require("telescope-emoji").setup({
    action = function(emoji)
        lf.set_register_and_notify(emoji.value)
    end,
})

telescope.load_extension("fzf")
telescope.load_extension("emoji")
telescope.load_extension("heading")
telescope.load_extension("ui-select")
telescope.load_extension("file_browser")
telescope.load_extension("find_pickers")

vapi.nvim_create_autocmd("User", {
    group = le_group,
    pattern = "TelescopePreviewerLoaded",
    callback = function()
        vim.opt_local.wrap = true
    end,
    -- TODO: Open issue on why wrap only works after you go to the file
    -- then come back
})

-- Telescope Keymaps
whichkey.register({
    ["<Leader>"] = {
        f = {
            name = "(f)ind something (Telescope Pickers)",
            a = {
                function()
                    telescope.extensions.find_pickers.find_pickers(themes.get_ivy({
                        layout_strategy = "center",
                        layout_config = {
                            width = 0.333,
                            height = 0.666,
                        },
                    }))
                end,
                "(f)ind (a)ll built in pickers",
            },
            b = { ":Telescope buffers<Enter>", "(f)ind (b)uffers" },
            B = { ":Lexplore 30<Enter>", "(f)ile (B)rowser" },
            c = { ":Telescope commands<Enter>", "(f)ind (c)ommands" },
            e = { ":Telescope emoji<Enter>", "(f)ind (e)mojis! 😎" },
            f = { ":Telescope find_files<Enter>", "(f)ind (f)iles" },
            g = { ":Telescope live_grep<Enter>", "(g)rep project" },
            h = { ":Telescope help_tags<Enter>", "(f)ind (h)elp" },
            k = { require("legendary").find, "(f)ind (k)eymaps" },
            m = { ":Telescope marks<Enter>", "(f)ind (m)arks" },
            r = { ":Telescope oldfiles<Enter>", "(f)ind (r)ecent files" },
            t = { ":Telescope treesitter<Enter>", "(f)ind (t)reesitter symbols" },
        },
        ["/"] = { ":Telescope current_buffer_fuzzy_find<Enter>", "Fuzzy Find In File" },
        ["?"] = { ":Telescope live_grep<Enter>", "Fuzzy Find Across Project" },
    },
    gr = { ":Telescope lsp_references<Enter>", "Find References" },
})

return telescope
