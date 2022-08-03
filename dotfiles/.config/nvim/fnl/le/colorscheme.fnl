;; Colorscheme!
(local {: day? : nil? : boolean?} (require :le.libf))

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

(local colorschemes {:day :gruvbox-material :night :nord})

(var was-day nil)
(var override-was-day nil)
(λ set-colorscheme [?override-is-day]
  (if (boolean? ?override-is-day)
    (set override-was-day ?override-is-day))
  (let [is-day (if (nil? override-was-day) (day?) override-was-day)]
    (when (not= is-day was-day)
      (set was-day is-day)
      (vim.cmd (.. "set background=" (if is-day :light :dark)))
      (vim.cmd (.. "colorscheme "
                   (if is-day colorschemes.day colorschemes.night)))
      ;; Make virtual text visible with transparent backgrounds
      (vapi.nvim_command "highlight NonText guifg=#6C768A")
      ;; Make matching parenthesis easier to see.
      (vapi.nvim_command "highlight MatchParen guifg=#ECEFF4 guibg=#BF616A"))))

(set-colorscheme)

;; Select day/night colorscheme every 15 minutes
(global ColorschemeTimer
        (vfn.timer_start (* 100 60 15) set-colorscheme {:repeat -1}))

{: set-colorscheme}
