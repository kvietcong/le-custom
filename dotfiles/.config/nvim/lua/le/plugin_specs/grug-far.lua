local config = function()
    local files = require("mini.files")
    local lib = require("le.lib")
    local wk = require("which-key")

    local grug_far = require("grug-far")
    grug_far.setup({
        windowCreationCommand = "",
        transient = true,
        startInInsertMode = false,
        prefills = {
            flags = "--smart-case",
        },
    })
    wk.add({ "<Leader>fr", ":GrugFar<Enter>", desc = "find and replace" })

    local file_substitute = function()
        local search = lib.get_visual_selection():gsub("(.-)%s*$", "%1")
        local flags = { "--smart-case" }
        if
            vim.iter({ "\n", "\r" }):any(function(to_search)
                return search:find(to_search) ~= nil
            end)
        then
            table.insert(flags, "--multiline")
        end

        grug_far.open({
            prefills = {
                paths = vim.fn.expand("%"),
                search = lib.regex_escape(search),
                replacement = search,
                flags = vim.iter(flags):join(" "),
            },
        })
    end
    wk.add({
        mode = { "v" },
        {
            "gs",
            file_substitute,
            desc = "global substitution (current file)",
        },
    })

    local go_out = function()
        vim.api.nvim_feedkeys(lib.clean("<C-o>"), "n", false)
    end

    local escape = function()
        local instance = grug_far.get_instance(0)
        local inputs =
            require("grug-far.inputs").getValues(instance._context, instance._buf)
        inputs.search = lib.regex_escape(inputs.search)
        inputs.flags = inputs.flags:gsub("%s*%-%-fixed%-strings", "")
        instance:update_input_values(inputs)
        lib.notify_info("Replaced selection w/ regex escaped selection")
    end
    vim.api.nvim_create_autocmd("FileType", {
        group = LE_GROUP,
        pattern = { "grug-far" },
        callback = function()
            wk.add({
                buffer = 0,
                mode = { "n" },
                noremap = false,
                { "q", go_out, desc = "Close Grug Far" },
                { "<F5>", "<localleader>f", desc = "Refresh Grug Far" },
                { "<Leader>re", escape, desc = "regex escape search" },
            })
        end,
    })

    local files_grug_far_replace = function()
        local cur_entry_path = files.get_fs_entry().path
        local prefills = { paths = vim.fs.dirname(cur_entry_path) }
        files.close()
        grug_far.open({
            prefills = prefills,
        })
    end

    vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
            vim.keymap.set(
                "n",
                "gs",
                files_grug_far_replace,
                { buffer = args.data.buf_id, desc = "Search in directory" }
            )
        end,
    })
end

local lazy_spec = {
    "MagicDuck/grug-far.nvim",
    config = config,
    dependencies = {
        "echasnovski/mini.nvim",
    },
}

return lazy_spec
