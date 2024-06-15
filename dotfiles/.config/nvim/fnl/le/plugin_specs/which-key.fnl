(λ config []
  (local which-key (require :which-key))
  (which-key.setup {:window {:position :bottom :winblend 7}
                    :layout {:align :center :width {:max 80}}}))

(local lazy-spec [{1 "folke/which-key.nvim"
                   : config
                   :lazy false
                   :priority 1000}])

lazy-spec
