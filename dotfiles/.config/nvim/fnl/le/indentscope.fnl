(local lf (require :le.libf))
(local mini-indentscope (require :mini.indentscope))

(mini-indentscope.setup {:draw {:delay 500} :symbol "⟫"})
(vapi.nvim_create_autocmd :TermOpen
                          {:group le-group
                           :callback #(set vim.b.miniindentscope_disable true)})

;; TODO: Open issue about prevent off window drawing (Large JSON files suffer big time)
(vapi.nvim_create_autocmd :BufEnter
                          {:group le-group
                           :callback (λ [event]
                                       (when (lf.thicc-buffer? event.buf)
                                         (lf.notify_warn "This buffer is quite large! Disabling indent lines")
                                         (set vim.b.miniindentscope_disable
                                              true)))})

(vapi.nvim_command "highlight Delimiter guifg=#4C566A")

mini-indentscope
