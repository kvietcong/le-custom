------------------------
-- Telescope Setup 🔭 --
------------------------

-- local actions = require("telescope.actions")
local telescope = require("telescope")
local whichkey = require("le.which-key")
local lf = require("le.libf")

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
            require("telescope.themes").get_ivy({
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
        gitmoji = {
            action = function(entry)
                vim.ui.input(
                    { prompt = "Enter commit msg: " .. entry.value .. " " },
                    function(msg)
                        if not msg then
                            return
                        end
                        local commit_message = entry.value .. " " .. msg
                        lf.set_register_and_notify(commit_message)
                    end
                )
            end,
        },
    },
})

require("telescope-emoji").setup({
    action = function(emoji)
        lf.set_register_and_notify(emoji.value)
    end,
})

telescope.load_extension("fzf")
telescope.load_extension("undo")
telescope.load_extension("emoji")
telescope.load_extension("gitmoji")
telescope.load_extension("heading")
telescope.load_extension("ui-select")
telescope.load_extension("file_browser")

vapi.nvim_create_autocmd("User", {
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
            a = { ":Telescope<Enter>", "(f)ind (a)ll built in pickers" },
            b = { ":Telescope buffers<Enter>", "(f)ind (b)uffers" },
            B = { ":Lexplore 30<Enter>", "(f)ile (B)rowser" },
            c = { ":Telescope commands<Enter>", "(f)ind (c)ommands" },
            d = { ":Telescope diagnostics<Enter>", "(f)ind (d)iagnostics" },
            e = { ":Telescope emoji<Enter>", "(f)ind (e)mojis! 😎" },
            ["<C-e>"] = {
                ":Telescope symbols<Enter>",
                "(f)ind (e)mojis/symbols! (Advanced) 😎 λ",
            },
            -- TODO: Configure file browser to do things?
            E = { ":Telescope file_browser<Enter>", "(f)ile (E)xplorer" },
            f = { ":Telescope find_files<Enter>", "(f)ind (f)iles" },
            g = { ":Telescope live_grep<Enter>", "(g)rep project" },
            h = { ":Telescope help_tags<Enter>", "(f)ind (h)elp" },
            k = { require("legendary").find, "(f)ind (k)eymaps" },
            m = { ":Telescope marks<Enter>", "(f)ind (m)arks" },
            M = { ":Telescope man_pages<Enter>", "(f)ind (M)an pages" },
            r = { ":Telescope oldfiles<Enter>", "(f)ind (r)ecent files" },
            t = { ":Telescope treesitter<Enter>", "(f)ind (t)reesitter symbols" },
        },
        ["/"] = { ":Telescope current_buffer_fuzzy_find<Enter>", "Fuzzy Find In File" },
        ["?"] = { ":Telescope live_grep<Enter>", "Fuzzy Find Across Project" },
        gm = { ":Telescope gitmoji<Enter>", "(g)it (m)essage helper" },
    },
    gr = { ":Telescope lsp_references<Enter>", "Find References" },
    ["z="] = { ":Telescope spell_suggest<Enter>", "Spelling Suggestions" },
})

return telescope
