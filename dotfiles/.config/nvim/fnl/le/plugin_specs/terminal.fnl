(λ config []
  (local which-key (require :which-key))
  (local {: clean} (require :le.libf))

  (set vim.g.floaterm_width 0.9)
  (set vim.g.floaterm_height 0.9)
  (set vim.g.autolose 1)

  (which-key.register {:<C-t> [":FloatermToggle<Enter>" "Open Terminal"]})

  (which-key.register {:<C-t> [(clean "<C-\\><C-n>:FloatermToggle<Enter>")
                               "Close Terminal"]
                       :<A-l> [(clean "<C-\\><C-n>:FloatermNext<Enter>")
                               "Go To Next Terminal"]
                       :<A-h> [(clean "<C-\\><C-n>:FloatermPrev<Enter>")
                               "Go To Previous Terminal"]
                       :<A-q> [(clean "<C-\\><C-n>:FloatermKill<Enter>:FloatermToggle<Enter>")
                               "Quit/Kill The Current Terminal"]
                       :<A-n> [(clean "<C-\\><C-n>:FloatermNew<Enter>")
                               "Create New Terminal"]}
                      {:mode :t})

  (which-key.register {:<C-t> [":FloatermSend<Enter>:FloatermShow<Enter>"
                               "Send Lines to Terminal"]}
                      {:mode :v}))

(local lazy-spec [{1 "voldikss/vim-floaterm"
                   : config}])

lazy-spec
