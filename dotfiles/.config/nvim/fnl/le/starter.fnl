;; Fancy Start Screen
(local mini-starter (require :mini.starter))

(mini-starter.setup {:enabled (not is_firenvim) :header HeaderString})

mini-starter