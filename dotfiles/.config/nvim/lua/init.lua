--[[
    TODO: Clean up my Configuration Modules
    TODO: Checkout Neorg when I think seems stable/mature enough to move my notes
          (i.e. when there's a pandoc option to convert markdown to neorg)
]]

local safe_setup = require("helpers").safe_setup

-- Plugin Setup
safe_setup("plugins")
-- UI Setup
safe_setup("ui")
-- Navigation Setup
safe_setup("navigation")
-- Treesitter Setup
safe_setup("treesitter")
-- LSP Setup
safe_setup("lsp")
