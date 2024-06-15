(λ config []
  (local flash (require :flash))
  (flash.setup {:modes
                {:char {:highlight { :backdrop false}}
                 :search { :enabled false}}})
  (vim.keymap.set [:n :x :o] :s flash.jump {:desc "Flash mode"})
  (vim.keymap.set [:x :o] :S flash.treesitter {:desc "Flash mode (Treesitter)"}))

(local keys [[:s] [:S]])

(local lazy-spec [{1 "folke/flash.nvim"
                   : config
                   : keys}])

lazy-spec
