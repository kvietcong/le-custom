;; Colorscheme!
(local {: day?} (require :le.libf))

;; Nord Options
(set vim.g.nord_italic true)
(set vim.g.nord_borders true)
(set vim.g.nord_contrast true)
(set vim.g.nord_disable_background (not is_gui))

;; Gruvbox Options
(set vim.g.gruvbox_material_enable_italic 1)
(set vim.g.gruvbox_material_background :soft)
(set vim.g.gruvbox_material_diagnostic_virtual_text 1)
(set vim.g.gruvbox_material_diagnostic_text_highlight 1)
(set vim.g.gruvbox_material_diagnostic_line_highlight 1)

;; Select day/night colorscheme every 15 minutes
(local colorschemes {:day :gruvbox-material :night :nord})

(λ set-colorscheme []
  (let [is-day (day?)]
    (vim.cmd (.. "set background=" (if is-day :light :dark)))
    (vim.cmd (.. "colorscheme " (if is-day colorschemes.day colorschemes.night)))))

(set-colorscheme)

(global ColorschemeTimer
        (vfn.timer_start (* 100 60 15) set-colorscheme {:repeat -1}))

;; Make Virtual text visible with transparent backgrounds
(vapi.nvim_command "highlight NonText guifg=#6C768A")

{: set-colorscheme}
