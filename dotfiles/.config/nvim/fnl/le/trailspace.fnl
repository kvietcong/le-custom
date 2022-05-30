;; Trailing Space Stuff
(local mini-trailspace (require :mini.trailspace))

(mini-trailspace.setup {})

;; Trim on Save
(vapi.nvim_create_autocmd :BufWritePre
                          {:group le-group
                           :desc "Trim trailing spaces on save."
                           :callback mini-trailspace.trim})

mini-trailspace
