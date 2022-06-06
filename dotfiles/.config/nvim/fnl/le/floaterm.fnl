;; Floating Terminal Configuration
(local which-key (require :le.which-key))

(set vim.g.floaterm_width 0.9)
(set vim.g.floaterm_height 0.9)
(set vim.g.autolose 1)

(λ clean [right-hand-side]
  (vapi.nvim_replace_termcodes right-hand-side true true true))

(which-key.register {:<C-t> [":FloatermToggle<Enter>" "Open Terminal"]})

(which-key.register {:<C-t> [(clean "<C-\\><C-n>:FloatermToggle<Enter>")
                             "Close Terminal"]
                     :<A-l> [(clean "<C-\\><C-n>:FloatermNext<Enter>")
                             "Go To Next Terminal"]
                     :<A-h> [(clean "<C-\\><C-n>:FloatermPrev<Enter>")
                             "Go To Previous Terminal"]
                     :<C-q> [(clean "<C-\\><C-n>:FloatermKill<Enter>")
                             "Quit/Kill The Current Terminal"]
                     :<C-t><C-n> [(clean "<C-\\><C-n>:FloatermNew<Enter>")
                                  "Create New Terminal"]}
                    {:mode :t})

(which-key.register {:<C-t> [":FloatTermSend<Enter>" "Send Lines to Terminal"]}
                    {:mode :v})

;; Fennel Format doesn't allow dangling booleans as returns
(values true)
