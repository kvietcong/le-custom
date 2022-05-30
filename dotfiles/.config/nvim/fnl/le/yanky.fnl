;; Kill Ring Feature (Better Copy/Paste)
(local yanky (require :yanky))

(yanky.setup {})

(vim.keymap.set :n :y "<Plug>(YankyYank)" {})
(vim.keymap.set :x :y "<Plug>(YankyYank)" {})
(vim.keymap.set :n :p "<Plug>(YankyPutAfter)" {})
(vim.keymap.set :n :P "<Plug>(YankyPutBefore)" {})
(vim.keymap.set :x :p "<Plug>(YankyPutAfter)" {})
(vim.keymap.set :x :P "<Plug>(YankyPutBefore)" {})
(vim.keymap.set :n :gp "<Plug>(YankyGPutAfter)" {})
(vim.keymap.set :n :gP "<Plug>(YankyGPutBefore)" {})
(vim.keymap.set :x :gp "<Plug>(YankyGPutAfter)" {})
(vim.keymap.set :x :gP "<Plug>(YankyGPutBefore)" {})
(vim.keymap.set :n :<c-n> "<Plug>(YankyCycleForward)" {})
(vim.keymap.set :n :<c-p> "<Plug>(YankyCycleBackward)" {})

yanky
