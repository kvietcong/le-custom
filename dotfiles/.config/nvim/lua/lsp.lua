local map = require("helpers").map

local function setup()
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

    local on_attach = function(client, buff)
        map("n gd           :lua vim.lsp.buf.definition()<Enter>", nil, buff)
        map("n <Leader>rn   :lua vim.lsp.buf.rename()<Enter>", nil, buff)
        map("n <Leader>cs   :lua vim.lsp.buf.signature_help()<Enter>", nil, buff)
        map("n <Leader>ch   :lua vim.lsp.buf.hover()<Enter>", nil, buff)
        map("n <Leader>ca   :lua vim.lsp.buf.code_action()<Enter>", nil, buff)
        map("n <Leader>cf   :lua vim.lsp.buf.formatting()<Enter>", nil, buff)
    end

    -- TODO: For some reason, the extracted VSCode servers (HTML, CSS) don't work on Windows :(
    local servers = { "tsserver", "pyright", "hls", "clangd", "cssls", "html", "rust_analyzer", "emmet_ls" }
    for _, server in pairs(servers) do
        local settings = {
            on_attach = on_attach
        }

        require("lspconfig")[server].setup(settings)
    end

    -- Lua Specific Server Configuration
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

return { setup = setup }
