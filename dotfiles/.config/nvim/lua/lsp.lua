local map = require("helpers").map

local function setup()
    require("trouble").setup()
    require("lsp_signature").setup({
        hint_enable = true,
        hint_prefix = "✅ "
    })

    require("compe").setup {
        enabled = true;
        autocomplete = true;
        min_length = 1;
        preselect = "enable";
        source = {
            tag = true;
            path = true;
            calc = true;
            spell = true;
            emoji = true;
            buffer = true;
            nvim_lsp = true;
            nvim_lua = true;
            treesitter = true;
        };
    }
    map("i <Enter> compe#confirm('<Enter>')", "silent expr noremap")
    map("i <C-e>   compe#close('<C-e>')", "silent expr noremap")

    map("n <C-t>       :Lspsaga open_floaterm<CR>")
    map("t <C-t><C-t>  <C-\\><C-n>:Lspsaga close_floaterm<CR>")
    local on_attach = function(client, buff)
        map("n K           :Lspsaga hover_doc<Enter>", nil, buff)
        map("n gr          :Lspsaga rename<Enter>", nil, buff)
        map("n gpd         :Lspsaga preview_definition<Enter>", nil, buff)
        map("n <Leader>ca  :Lspsaga code_action<Enter>", nil, buff)
        map("v <Leader>ca  :<C-U>Lspsaga range_code_action<Enter>", nil, buff)
        map("n <Leader>f   :lua vim.lsp.buf.formatting()<Enter>", nil, buff)
        map("n <C-j>       :lua require('lspsaga.action').smart_scroll_with_saga(1)<Enter>", nil, buff)
        map("n <C-k>       :lua require('lspsaga.action').smart_scroll_with_saga(-1)<Enter>", nil, buff)
    end

    local servers = { "pyright", "hls", "clangd", "tsserver" }
    -- For some reason, the extracted VSCode servers don't work on Windows :(
    if not vim.fn.has("win32") then
        for _, server in pairs{ "cssls", "html" } do
            table.insert(servers, server)
        end
    end
    for _, server in pairs(servers) do
        local options = { on_attach = on_attach }
        require("lspconfig")[server].setup(options)
    end

    -- Lua server configuration
    local sumneko_root
    local sumneko_binary
    -- Only have Lua configured for Windows atm
    if vim.fn.has("win32") == 1 then
        sumneko_root = "D:/Custom Binaries/lua-language-server-2.3/"
        sumneko_binary = sumneko_root .. "/bin/lua-language-server"
    end
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    require("lspconfig").sumneko_lua.setup {
        cmd = { sumneko_binary, "-E", sumneko_root .. "main.lua" };
        settings = { Lua = {
            runtime = { version = "LuaJIT", path = runtime_path },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false }
        }},
        on_attach = on_attach
    }
end

local lsp = {}
lsp.setup = setup
return lsp
