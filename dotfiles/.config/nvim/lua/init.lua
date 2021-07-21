--[[
    TODO: Clean up my Configuration Modules
    TODO: Checkout Neorg when I think seems stable/mature enough to move my notes
          (i.e. when there's a pandoc option to convert markdown to neorg)
]]

-- Retrieve Plugins
require("plugins").setup()
-- LSP Setup
require("lsp").setup()
-- Treesitter Setup
require("treesitter").setup()
-- Navigation Setup
require("navigation").setup()
-- UI Setup
require("ui").setup()

