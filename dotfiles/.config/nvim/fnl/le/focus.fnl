;; Automatic Window Resizing
(local focus (require :focus))
(local which-key (require :le.which-key))

(focus.setup {:signcolumn false
              :cursorline true
              :hybridnumber true
              :excluded_filetypes [:netrw]})

(which-key.register {:s [":FocusSplitNicely<Enter>" "(w)indow (s)plit"]
                     := [":FocusEqualise<Enter>" "(w)indow (=)equalize"]
                     :t [":FocusToggle<Enter>" "(w)indow focusing (t)oggle"]}
                    {:prefix :<Leader>w})

focus