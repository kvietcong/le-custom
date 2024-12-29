local config = function()
    local files = require("mini.files")
    local bufremove = require("mini.bufremove")
    local wk = require("which-key")

    local grug_far = require("grug-far")
    grug_far.setup({
        windowCreationCommand = "",
        prefills = {
            flags = "--smart-case",
        },
    })
    wk.add({ "<Leader>fr", ":GrugFar<Enter>", desc = "find and replace" })

    local buf_delete = function()
        bufremove.delete(0, true)
    end
    vim.api.nvim_create_autocmd("FileType", {
        group = le_group,
        pattern = { "grug-far" },
        callback = function()
            wk.add({
                buffer = 0,
                noremap = false,
                { "q", buf_delete, desc = "Close Grug Far" },
                { "<F5>", "<localleader>f", desc = "Refresh Grug Far" },
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
