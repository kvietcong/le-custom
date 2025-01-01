local config = function()
    local telescope = require("telescope")
    local wk = require("which-key")
    local themes = require("telescope.themes")

    telescope.setup({
        defaults = {
            layout_config = {
                prompt_position = "top",
            },
            layout_strategy = "flex",
            sorting_strategy = "ascending",
            file_ignore_patterns = { "node_modules" },
        },
        extensions = {
            smart_open = {
                match_algorithm = "fzf",
                disable_devicons = false,
            },
            ["ui-select"] = {
                themes.get_ivy({
                    layout_strategy = "center",
                    layout_config = {
                        width = 0.333,
                        height = 0.666,
                    },
                }),
            },
        },
    })

    vim.api.nvim_create_autocmd("User", {
        group = LE_GROUP,
        pattern = "TelescopePreviewerLoaded",
        callback = function()
            vim.opt_local.wrap = true
        end,
        -- [TODO]: Open issue on why wrap only works after you go to the file
        -- then come back
    })

    wk.add({
        { "<Leader>f", group = "find something" },
        {
            "<Leader>fa",
            ":Telescope<Enter>",
            desc = "telescope pickers",
        },
        { "<Leader>fb", ":Telescope buffers<Enter>", desc = "buffers" },
        { "<Leader>fc", ":Telescope commands<Enter>", desc = "commands" },
        { "<Leader>ff", ":Telescope find_files<Enter>", desc = "files" },
        {
            "<Leader>fF",
            ":Telescope find_files hidden=true<Enter>",
            desc = "files (+hidden)",
        },
        {
            "<Leader>fg",
            ":Telescope live_grep preview={timeout=1000}<Enter>",
            desc = "grep",
        },
        { "<Leader>fh", ":Telescope help_tags<Enter>", desc = "help" },
        { "<Leader>fn", ":Fidget history<Enter>", desc = "notifications" },
        { "<Leader>fn", ":Fidget history<Enter>", desc = "notifications" },
    })
end

local lazy_spec = {
    {
        "nvim-telescope/telescope.nvim",
        config = config,
        dependencies = {
            "folke/which-key.nvim",
            "keyvchan/telescope-find-pickers.nvim",
        },
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "mkdir build; zig cc -O3 -Wall -Werror -fpic -std=gnu99 -shared src/fzf.c -o build/libfzf.dll",
        config = function()
            require("telescope").load_extension("fzf")
        end,
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
    },
}

return lazy_spec
