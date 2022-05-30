(local mini-indentscope (require :mini.indentscope))

(when is_going_hard
  (mini-indentscope.setup {:draw {:delay 500} :symbol "⟫"})
  (vapi.nvim_create_autocmd :TermOpen
                            {:group le-group
                             :callback #(set vim.b.miniindentscope_disable true)}))

(vapi.nvim_command "highlight Delimiter guifg=#4C566A")

mini-indentscope
