;;; ========================
;;; == Le Atlas Module 🗺️ ==
;;; ========================

;; My custom note-taking setup

(local {: notify-error
        : notify-info
        : get-date
        : fd-async
        : not-falsy?
        : set-register-and-notify
        : *->string
        : type-check!
        : head} (require :le.libf))

(local {: -- : ++} (require :le.math))

(local get-weekly (require :templates/weekly))
(local get-monthly (require :templates/monthly))

(import-macros {:fstring f=} :le.macros)

(local vfn vim.fn)
(local vapi vim.api)
(local wk (require :le.which-key))

(λ path->filename [path]
  (type-check! [:string path])
  (vfn.fnamemodify path ":t:r"))

;; Wait, what the frick is this disgusting monstrosity?
(λ raw-wikilink-under-cursor []
  (let [[row column] (vapi.nvim_win_get_cursor 0)
        column (+ column 1) ; Change to 1 Indexed Column
        line (vapi.nvim_get_current_line)
        (before after) (values (line:sub 1 (-- column)) (line:sub (++ column)))
        char-current (or (line:char_at column) "")
        char-before (or (before:char_at -1) "")
        char-after (or (after:char_at 1) "")
        (is-right is-left) (values (= "]" char-current) (= "[" char-current))
        is-most-right (= "]]" (.. char-before char-current))
        is-most-left (= "[[" (.. char-current char-after))
        before-pattern (if is-most-left "" is-left "%[$"
                           (if is-most-right "%[%[[^%[]*$" "%[%[[^%[%]]*$"))
        after-pattern (if is-most-right ""
                          is-right "^%]"
                          (if is-most-left "^[^%]]*%]%]" "^[^%[%]]*%]%]"))
        before-match (before:match before-pattern)
        after-match (after:match after-pattern)]
    (if (and after-match before-match char-current)
        (.. before-match char-current after-match))))

;; TODO: Verify Wikilink Based on Raw Form
(λ good-raw-wikilink? [?raw-wikilink]
  (or (and ?raw-wikilink true) false))

(λ raw-wikilink->wikilink-info [raw-wikilink]
  (let [wikilink-info (match-try (raw-wikilink:match "%[%[(.+)%]%]") wikilink
                                 (vim.split wikilink "|" true))]
    (when wikilink-info
      (if (= (length wikilink-info) 1)
          (t.insert wikilink-info (. wikilink-info 1)))
      ;; TODO: Find a way to communicate subheadings
      (tset wikilink-info :filename
            (path->filename (-> wikilink-info
                                (. 1)
                                (vim.split "#")
                                (. 1))))
      (tset wikilink-info :alias (. wikilink-info 2)))
    wikilink-info))

(λ good-wikilink-info? [?wikilink-info]
  (if (not ?wikilink-info) false
      (?wikilink-info.filename:match "[\\/%$%^%%*%?]") false
      true))

(λ wikilink-info-under-cursor []
  (or (match-try (raw-wikilink-under-cursor) raw-wikilink
                 (good-raw-wikilink? raw-wikilink) true
                 (raw-wikilink->wikilink-info raw-wikilink) wikilink-info
                 (good-wikilink-info? wikilink-info) true wikilink-info)
      nil))

;; TODO: File issue with how disabling still makes it auto detect around (jump around)
;; (local temp vim.g.minisurround_disable)
;; (set vim.g.minisurround_disable true)

(λ get-possible-paths [?callback]
  (type-check! [:function|nil ?callback])
  (if ?callback
      (fd-async {:callback ?callback
                 :cwd vim.g.wiki_root
                 :args [:-g "--" :*.md]})
      (let [job (get-possible-paths)]
        (job:sync))))

(λ filename->filepath [filename ?callback]
  (type-check! [:string filename :function|nil ?callback])
  (fd-async {:callback (vim.schedule_wrap ?callback)
             :cwd vim.g.wiki_root
             :args [:-g "--" (f= "${filename}.md")]}))

(λ get-weekly-note-name []
  (let [date (get-date)
        week (date.format "%V")]
    (f= "${date.year}-W${week}")))

(λ get-monthly-note-name []
  ((. (get-date) :format) "%Y-%m"))

(λ open-first-filepath [filepaths ?will-split ?on-error]
  (type-check! [:function|nil ?on-error])
  (let [file (head filepaths)]
    (if file
        (let [file (vfn.fnameescape file)]
          (if ?will-split
              (vim.cmd (f= "vsplit ${file}"))
              (vim.cmd (f= "e ${file}"))))
        (if ?on-error
            (?on-error file)
            (notify-error "Couldn't Find File")))))

(λ open-filename [filename ?will-split ?on-error]
  (filename->filepath filename
                      (λ [filepaths]
                        (open-first-filepath filepaths ?will-split ?on-error))))

(λ open-wikilink-under-cursor [?will-split]
  (type-check! [:boolean|nil ?will-split])
  (match-try (wikilink-info-under-cursor) wikilink-info wikilink-info.filename
             filename (open-filename filename ?will-split)
             (catch nil (notify-error "Invalid Wikilink Under Cursor"))))

;; TODO: Scuffed AF. Gotta make this whole chain cleaner. Rely on external tools?
(λ open-weekly-note [?will-split]
  (type-check! [:boolean|nil ?will-split])
  (let [weekly-note-name (get-weekly-note-name)]
    (open-filename weekly-note-name ?will-split #(do
                                                   (notify-info "Creating new weekly note buffer")
                                                   (vim.cmd (f= "e Journal/Weekly\\ Reviews/${weekly-note-name}.md"))
                                                   (vim.api.nvim_buf_set_lines 0
                                                                               0
                                                                               0
                                                                               true
                                                                               (vfn.split (get-weekly)
                                                                                          "
"))))))

(λ open-monthly-note [?will-split]
  (type-check! [:boolean|nil ?will-split])
  (let [monthly-note-name (get-monthly-note-name)]
    (open-filename monthly-note-name ?will-split #(do
                                                    (notify-info "Creating new monthly note buffer")
                                                    (vim.cmd (f= "e Journal/Weekly\\ Reviews/${monthly-note-name}.md"))
                                                    (vim.api.nvim_buf_set_lines 0
                                                                                0
                                                                                0
                                                                                true
                                                                                (vfn.split (get-monthly)
                                                                                           "
"))))))

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
                                              (vapi.nvim_command (.. "%s/edited: \\d\\d\\d\\d-\\d\\d-\\d\\dT\\d\\d:\\d\\d:\\d\\d[+-]\\d\\d:\\d\\d"
                                                                     (f= "/edited: ${date}/ge"))))
                                          (vapi.nvim_command "%s/\\(^.\\+\\n\\)\\(^#\\+ .*\\n\\)/\\1\\r\\2/gec")
                                          (vapi.nvim_win_set_cursor 0
                                                                    cursor-position))}))

(λ add-keymaps-to-buffer [event-info]
  (wk.register {:<Enter> [open-wikilink-under-cursor "Go To Wikilink"]
                :<Leader><Enter> [#(open-wikilink-under-cursor true)
                                  "Go To Wikilink (Split)"]
                ;; TODO: Add prev and next
                :<Leader>nww [#(open-weekly-note) "Go to Weekly Note"]
                :<Leader>nmm [#(open-monthly-note) "Go to Monthly Note"]
                :<Leader>nWW [#(open-weekly-note true)
                              "Go to Weekly Note (Split)"]
                :<Leader>nMM [#(open-monthly-note true)
                              "Go to Monthly Note (Split)"]
                :<Leader>nl [choose-wikilink-and-copy "Get a wikilink"]}
               {:buffer event-info.buf})
  (wk.register {:<C-l> [choose-wikilink-and-insert "Insert a wikilink"]}
               {:buffer event-info.buf :mode :i}))

(λ add-keymaps []
  (vapi.nvim_create_autocmd :BufEnter
                            {:group le-group
                             :desc "Add Note Taking Keymaps"
                             :pattern [:*.md :*.mdx :*.wiki]
                             :callback add-keymaps-to-buffer}))

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
 :open_wikilink_under_cursor open-wikilink-under-cursor
 : open-weekly-note
 :open_weekly_note open-weekly-note
 : open-monthly-note
 :open_monthly_note open-monthly-note
 :get_possible_paths get-possible-paths
 : get-possible-paths
 :path_to_filename path->filename
 : path->filename}
