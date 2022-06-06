;; Load Fennel Integration
(local hotpot (require :hotpot))

(hotpot.setup {:provide_require_fennel true
               :compiler {:modules {:correlate true}}})

(vapi.nvim_create_autocmd :BufEnter
                          {:group le-group
                           :desc "Setup Fennel Specific Things"
                           :pattern [:*.fnl]
                           :callback (λ []
                                       (vim.cmd "abbreviate <buffer> l\\ λ")
                                       (vim.cmd "abbreviate <buffer> (l\\ (λ"))})

hotpot
