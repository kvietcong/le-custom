(λ config []
  (local legendary (require :legendary))
  (legendary.setup {}))

(local lazy-spec [{1 "mrjones2014/legendary.nvim"
                   : config
                   :lazy false
                   :priority 1000}])

lazy-spec
