;; Fancy GUI Tab/Buffer Line
(local which-key (require :le.which-key))
(local bufferline (require :bufferline))
(local mini-bufremove (require :le.bufremove))

(local options {:show_close_icon false
                :diagnostics :nvim_lsp
                :separator_style :thick
                :tab_size 20
                ;; Persisting order doesn't work for some reason
                :persist_buffer_sort true
                :sort_by :directory
                :right_mouse_command (λ [buffer]
                                       (mini-bufremove.delete buffer true))
                :middle_mouse_command (λ [buffer]
                                        (mini-bufremove.unshow buffer))
                :indicator {:icon " ⨠ "}
                :buffer_close_icon :x})

(when (not is_firenvim)
  (bufferline.setup {: options})
  (which-key.register {:<Leader>b {:name "(b)uffers"
                                   :b [":Telescope buffers<Enter>"
                                       "find (b)uffer"]
                                   :f [":Telescope buffers<Enter>"
                                       "(b)uffer (f)ind"]
                                   :q [mini-bufremove.unshow_in_window
                                       "(b)uffer (q)uit [unshows buffer]"]
                                   :d [(λ []
                                         (mini-bufremove.delete 0 true))
                                       "(b)uffer (d)elete"]
                                   :c [":bd<Enter>" "(b)uffer (c)lose"]
                                   :l [":BufferLineCycleNext<Enter>"
                                       "(b)uffer next"]
                                   :h [":BufferLineCyclePrev<Enter>"
                                       "(b)uffer prev"]
                                   :j [":BufferLineMoveNext<Enter>"
                                       "(b)uffer move next"]
                                   :k [":BufferLineMovePrev<Enter>"
                                       "(b)uffer move prev"]
                                   :o [":BO<Enter>"
                                       "(b)uffer (o)nly (Close all but this)"]}
                       :<M-l> [":BufferLineCycleNext<Enter>" "buffer next"]
                       :<M-h> [":BufferLineCyclePrev<Enter>" "buffer prev"]
                       :<M-L> [":BufferLineMoveNext<Enter>" "buffer move next"]
                       :<M-H> [":BufferLineMovePrev<Enter>" "buffer move prev"]
                       :<M-Right> [":BufferLineCycleNext<Enter>" "buffer next"]
                       :<M-Left> [":BufferLineCyclePrev<Enter>" "buffer prev"]
                       :<M-S-Right> [":BufferLineMoveNext<Enter>"
                                     "buffer move next"]
                       :<M-S-Left> [":BufferLineMovePrev<Enter>"
                                    "buffer move prev"]}))

bufferline
