;; Conjure REPL setup
(local which-key (require :le.which-key))
(local {: clean} (require :le.libf))

(set vim.g.conjure#eval#result_register "\"")
(set vim.g.conjure#mapping#prefix :<Leader>)
(set vim.g.conjure#eval#inline#highlight :DiagnosticInfo)
(set vim.g.conjure#eval#inline#prefix "~~> ")
(set vim.g.conjure#highlight#enabled true)
(set vim.g.conjure#log#hud#width 0.4)
(set vim.g.conjure#log#hud#height 0.5)
(set vim.g.conjure#log#hud#passive_close_delay 0)
; (set vim.g.conjure#filetype#fennel :conjure.client.fennel.stdio)
; (set vim.g.conjure#client#fennel#stdio#command :fennel.bat)

(λ set-keymaps [event]
  (let [prefix vim.g.conjure#mapping#prefix]
    (which-key.register {prefix {:e {:name "(e)valuate"
                                     :b "(e)valuate (b)uffer"
                                     :f "(e)valuate (f)ile [what's saved]"
                                     :e "(e)valuate form under cursor"
                                     :c "(e)valuate w/ result as appended (c)omment"
                                     :r "(e)valuate (r)oot form under cursor"
                                     :l [(λ []
                                           (vapi.nvim_feedkeys (clean "<Escape>V:ConjureEval<Enter>")
                                                               :m true))
                                         "(e)valuate (l)ine"]
                                     :w "(e)vaulate (w)ord under cursor"
                                     :m "(e)vaulate at (m)ark"
                                     :! "(e)vaulate form and replace w/ result"}
                                 :l {:name "evaluation (l)og commands"
                                     :v "(v)ertical split log buffer"
                                     :s "(s)plit log buffer"
                                     :r "soft (r)eset log buffer"
                                     :l "go to (l)atest log buffer result"
                                     :R "hard (r)eset log buffer"}}
                         :E "(E)valuate motion"}
                        {:buffer event.buffer})
    (which-key.register {prefix {:E "(E)valuate selection"}}
                        {:mode :v :buffer event.buffer})))

(vapi.nvim_create_autocmd :BufEnter
                          {:group le-group
                           :desc "Add Conjure Keymap Labels"
                           :callback set-keymaps})

{: set-keymaps}
