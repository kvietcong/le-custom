;; Wiki Vim
(local which-key (require :which-key))

(set vim.g.wiki_index_name "- Index -")
(set vim.g.wiki_mappings_use_defaults :none)
(set vim.g.wiki_root "~/Documents/Notes")
(set vim.g.wiki_filetypes {:md :markdown})
(set vim.g.wiki_link_toggle_on_follow false)
(set vim.g.wiki_link_extension :md)
(set vim.g.wiki_journal
     {:name "Journal/Weekly Reviews"
      :frequency :weekly
      :date_format {:daily "%Y-%m-%d" :weekly "%Y-W%V"}})

(λ register-note-keys [event]
  (which-key.register {:<Leader>n {:name "(n)otes"
                                   :i ["<Plug>(wiki-index)" "(n)ote (i)ndex"]
                                   :b ["<Plug>(wiki-graph-find-backlinks)"
                                       "(n)ote (b)acklinks"]
                                   :t [":Telescope heading<Enter>"
                                       "(n)ote (t)able of contents"]
                                   :w {:name "(w)eekly"
                                       :w ["<Plug>(wiki-journal)"
                                           "(n)ote (w)eekly current"]
                                       :l ["<Plug>(wiki-journal-next)"
                                           "(n)ote (w)eekly next"]
                                       :h ["<Plug>(wiki-journal-prev)"
                                           "(n)ote (w)eekly previous"]}}
                       :<Leader>el [":CarrotEval<Enter>"
                                    "(e)valuate (l)ua code block"]
                       :<Leader><Leader><Enter> ["<Plug>(wiki-link-toggle)"
                                                 "Create or Toggle Link"]}
                      {:buffer event.buf}))

(vapi.nvim_create_autocmd :BufEnter
                          {:group le_group
                           :desc "Set note-taking keybindings for current buffer."
                           :pattern [:*.md :*.mdx :*.txt :*.wiki]
                           :callback register-note-keys})

(values true)
