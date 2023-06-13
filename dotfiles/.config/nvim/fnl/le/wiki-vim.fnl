;; Wiki Vim
(local which-key (require :which-key))
; (local mkdnflow (require :mkdnflow))

; (mkdnflow.setup {:wrap true
;                  :perspective {:priority :current :fallback :root}
;                  :links {:style :wiki
;                          :conceal true
;                          :implicit_extension :md
;                          :transform_explicit (λ [x]
;                                                (.. "<" x :.md>))}})

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
                                   :t [":Telescope heading<Enter>"
                                       "(n)ote (t)able of contents"]}}
                      {:buffer event.buf}))

(vapi.nvim_create_autocmd :BufEnter
                          {:group le_group
                           :desc "Set note-taking keybindings for current buffer."
                           :pattern [:*.md :*.mdx :*.txt :*.wiki]
                           :callback register-note-keys})

true
