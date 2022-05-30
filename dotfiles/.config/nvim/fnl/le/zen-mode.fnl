;; Zen Mode (Minimal Mode)
(local zen-mode (require :zen-mode))
(local which-key (require :le.which-key))

(zen-mode.setup {:window {:width 90 :backdrop 0.6}
                 :on_open (λ []
                            (vim.cmd :FocusDisable)
                            (pcall #(vapi.nvim_set_keymap :n :<Escape>
                                                          ":ZenMode<Enter>" {})))
                 :on_close (λ []
                             (vim.cmd :FocusEnable)
                             (pcall #(vapi.nvim_del_keymap :n :<Escape>)))})

(which-key.register {:<Leader>z [":ZenMode<Enter>" "(z)en mode"]})

zen-mode
