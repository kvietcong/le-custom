;;; ========================
;;; == Le Atlas Module 🗺️ ==
;;; ========================

;; My note-taking setup

(local {: notify-error
        : get-date
        : fd-async
        : not-falsy?
        : set-register-and-notify
        : *->string
        : type-check!} (require :le.libf))

(local {: -- : ++} (require :le.math))

(import-macros {:fstring f=} :le.macros)

(local vfn vim.fn)
(local vapi vim.api)
(local wk (require :le.which-key))

(λ path->filename [path]
  (type-check! [:string path])
  (vfn.fnamemodify path ":t:r"))

(λ get-wikilink-info-under-cursor []
  "Get Wikilink `filename` and `alias`"
  (let [[row column] (vapi.nvim_win_get_cursor 0)
        column (+ column 1) ; Change to 1 Indexed Column
        line (vapi.nvim_get_current_line)
        before (line:sub 1 (-- column))
        after (line:sub (++ column))
        char-current (or (line:char_at column) "")
        char-before (or (before:char_at -1) "")
        char-after (or (after:char_at 1) "")
        is-right (= "]" char-current)
        is-left (= "[" char-current)
        is-most-right (= "]]" (.. char-before char-current))
        is-most-left (= "[[" (.. char-current char-after))
        before-pattern (if is-most-left "" is-left "%[$"
                           (if is-most-right "%[%[[^%[]*$" "%[%[[^%[%]]*$"))
        after-pattern (if is-most-right ""
                          is-right "^%]"
                          (if is-most-left "^[^%]]*%]%]" "^[^%[%]]*%]%]"))
        before-match (before:match before-pattern)
        after-match (after:match after-pattern)
        wikilink-info (match-try (and after-match before-match
                                      (.. before-match char-current after-match))
                                 wikilink-raw
                                 (wikilink-raw:match "%[%[(.+)%]%]") wikilink
                                 (vim.split wikilink "|" true))]
    (if wikilink-info
        (do
          (if (= (length wikilink-info) 1)
              (tset wikilink-info 2 (. wikilink-info 1)))
          (tset wikilink-info :filename (path->filename (. wikilink-info 1)))
          (tset wikilink-info :alias (. wikilink-info 2))
          wikilink-info)
        (let [error-message "No Valid Link Under Your Cursor"]
          (lf.notify-error error-message)
          (values nil error-message)))))

;; TODO: File issue with how disabling still makes it auto detect around (jump around)
;; (local temp vim.g.minisurround_disable)
;; (set vim.g.minisurround_disable true)

(λ get-possible-paths-async [?callback]
  (type-check! [:function|nil ?callback])
  (fd-async {:callback ?callback :cwd vim.g.wiki_root :args [:-g "--" :*.md]}))

(λ get-possible-paths []
  (let [job (get-possible-paths-async)]
    (job:sync)))

(λ filename->filepath-async [filename ?callback]
  (type-check! [:string filename :function|nil ?callback])
  (fd-async {:callback ?callback
             :cwd vim.g.wiki_root
             :args [:-g "--" (f= "${filename}.md")]}))

(λ filename->filepath [filename]
  (type-check! [:string filename])
  (let [job (filename->filepath-async filename)]
    (job:sync)))

(λ open-wikilink-under-cursor [?will-split]
  (type-check! [:boolean|nil ?will-split])
  (match-try (get-wikilink-info-under-cursor) wikilink-info
             wikilink-info.filename filename
             (filename->filepath-async filename
                                       (λ [filepaths]
                                         ((vim.schedule_wrap #(let [file (. filepaths
                                                                            1)]
                                                                (if file
                                                                    (if ?will-split
                                                                        (vim.cmd (f= "FocusSplitNicely \"${file}\""))
                                                                        (vim.cmd (f= "e ${file}")))
                                                                    (notify-error "Couldn't Find File")))))))))

(λ choose-wikilink [callback]
  (type-check! [:function callback])
  (let [possible-paths (get-possible-paths)]
    (vim.ui.select possible-paths
                   {:prompt "Select a Note" :format_item path->filename}
                   (λ [?selection]
                     (if ?selection
                         (let [filename (path->filename ?selection)]
                           (vim.ui.input {:prompt "Alias (Nothing for No Alias)"}
                                         (λ [?alias]
                                           (callback (.. "[["
                                                         (if (not-falsy? ?alias)
                                                             (f= "${filename}|${?alias}")
                                                             filename)
                                                         "]]"))))))))))

(λ choose-wikilink-and-copy []
  (choose-wikilink set-register-and-notify))

(λ choose-wikilink-and-insert []
  (choose-wikilink (λ [?wikilink]
                     (let [[row column] (vapi.nvim_win_get_cursor 0)
                           line (vapi.nvim_get_current_line)
                           new-line (.. (line:sub 1 (++ column)) ?wikilink
                                        (line:sub (+ column 2)))]
                       (vapi.nvim_set_current_line new-line)
                       (vapi.nvim_win_set_cursor 0
                                                 [row
                                                  (+ column (length ?wikilink))])
                       (vapi.nvim_feedkeys :a :m true)))))

(λ add-save-hook []
  (vapi.nvim_create_autocmd :BufWritePre
                            {:group le_group
                             :desc "Clean up and update metadata when taking Notes"
                             :pattern [:*.md :*.mdx :*.wiki]
                             :callback #(let [is-modified (vapi.nvim_buf_get_option 0
                                                                                    :modified)
                                              {:my-date date} (get-date)
                                              cursor-position (vapi.nvim_win_get_cursor 0)]
                                          (if is-modified
                                              (vapi.nvim_command (.. "%s/edited: \\d\\d\\d\\d-\\d\\d-\\d\\dT\\d\\d:\\d\\d:\\d\\d/"
                                                                     (f= "edited: ${date}/ge"))))
                                          (vapi.nvim_command "%s/\\(^.\\+\\n\\)\\(^#\\+ .*\\n\\)/\\1\\r\\2/gec")
                                          (vapi.nvim_win_set_cursor 0
                                                                    cursor-position))}))

(λ add-keymaps []
  (vapi.nvim_create_autocmd :BufEnter
                            {:group le-group
                             :desc "Add Note Taking Keymaps"
                             :pattern [:*.md :*.mdx :*.wiki]
                             :callback (λ [event-info]
                                         (wk.register {:<Enter> [open-wikilink-under-cursor
                                                                 "Go To Wikilink"]
                                                       :<Leader><Enter> [#(open-wikilink-under-cursor true)
                                                                         "Go To Wikilink (Split)"]
                                                       :<Leader>nl [choose-wikilink-and-copy
                                                                    "Get a wikilink"]}
                                                      {:buffer event-info.buf})
                                         (wk.register {:<C-l> [choose-wikilink-and-insert
                                                               "Insert a wikilink"]}
                                                      {:buffer event-info.buf
                                                       :mode :i}))}))

(λ setup []
  (add-save-hook)
  (add-keymaps))

{: setup
 : choose-wikilink
 :choose_wikilink choose-wikilink
 : choose-wikilink-and-insert
 :choose_wikilink_and_insert choose-wikilink-and-insert
 : choose-wikilink-and-copy
 :choose_wikilink_and_copy choose-wikilink-and-copy
 : open-wikilink-under-cursor
 :open_wikilink_under_cursor open-wikilink-under-cursor}