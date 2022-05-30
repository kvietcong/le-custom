;; Leap Movement
(local leap (require :leap))

(leap.setup {:special_keys {:repeat_search :<Enter>
                            :next_match :<Enter>
                            :prev_match :<Tab>
                            :next_group :<Space>
                            :prev_group :<Tab>
                            :eol :<Space>}})

(leap.set_default_keymaps)

;; Disable conceal while leaping
(local conceal-level vim.o.conceallevel)
(vapi.nvim_create_autocmd :User
                          {:group le-group
                           :pattern :LeapEnter
                           :callback #(set vim.opt_local.conceallevel 0)})

(vapi.nvim_create_autocmd :User
                          {:group le-group
                           :pattern :LeapLeave
                           :callback #(set vim.opt_local.conceallevel
                                           conceal-level)})

leap
