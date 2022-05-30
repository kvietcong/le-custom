;; Easy window movement
(local winshift (require :winshift))
(local which-key (require :le.which-key))

(winshift.setup {:focused_hl_group :CursorLine})

(which-key.register {:<Leader>wm [":WinShift<Enter>" "(w)indow (m)ove mode"]})

;; I would like to question the author's choice
;; to set the library within the metatable
winshift
