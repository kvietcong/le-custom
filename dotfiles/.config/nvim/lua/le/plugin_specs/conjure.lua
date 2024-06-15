local config = function()
    local which_key = require("which-key")
    local _local_1_ = require("le.libf")
    local clean = _local_1_["clean"]
    vim.g["conjure#eval#result_register"] = '"'
    vim.g["conjure#mapping#prefix"] = "<Leader>"
    vim.g["conjure#eval#inline#highlight"] = "DiagnosticInfo"
    vim.g["conjure#eval#inline#prefix"] = "~~> "
    vim.g["conjure#highlight#enabled"] = true
    vim.g["conjure#log#hud#width"] = 0.4
    vim.g["conjure#log#hud#height"] = 0.5
    vim.g["conjure#log#hud#passive_close_delay"] = 0
    vim.g["conjure#extract#tree_sitter#enabled"] = true
    vim.g["conjure#filetypes"] = {
        "fennel",
        "lua",
        "python",
        "racket",
        "janet",
        "clojure",
    }
    local function set_keymaps(event)
        _G.assert(
            (nil ~= event),
            "Missing argument event on C:/Users/minec/AppData/Local/nvim/fnl/le/plugin_specs/conjure.fnl:18"
        )
        local prefix = vim.g["conjure#mapping#prefix"]
        local function _2_()
            return vapi.nvim_feedkeys(clean("<Escape>V:ConjureEval<Enter>"), "m", true)
        end
        which_key.register({
            [prefix] = {
                e = {
                    name = "(e)valuate",
                    b = "(e)valuate (b)uffer",
                    f = "(e)valuate (f)ile [what's saved]",
                    e = "(e)valuate form under cursor",
                    c = "(e)valuate w/ result as appended (c)omment",
                    r = "(e)valuate (r)oot form under cursor",
                    l = { _2_, "(e)valuate (l)ine" },
                    w = "(e)vaulate (w)ord under cursor",
                    m = "(e)vaulate at (m)ark",
                    ["!"] = "(e)vaulate form and replace w/ result",
                },
                l = {
                    name = "evaluation (l)og commands",
                    v = "(v)ertical split log buffer",
                    s = "(s)plit log buffer",
                    r = "soft (r)eset log buffer",
                    l = "go to (l)atest log buffer result",
                    R = "hard (r)eset log buffer",
                },
            },
            E = "(E)valuate motion",
        }, { buffer = event.buffer })
        return which_key.register(
            { [prefix] = { E = "(E)valuate selection" } },
            { mode = "v", buffer = event.buffer }
        )
    end
    return vapi.nvim_create_autocmd("BufEnter", {
        group = le_group,
        desc = "Add Conjure Keymap Labels",
        callback = set_keymaps,
    })
end

local lazy_spec = { { "Olical/conjure", config = config } }

return lazy_spec
