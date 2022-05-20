(local Job (require :plenary.job))
(local lelua (require :lelua))
(local lefen (require :lefen))

(fn add-save-hook []
  (vapi.nvim_create_autocmd
    "BufWritePre"
    {:group le_group
     :desc "Clean up and update metadata when taking Notes"
     :pattern ["*.md" "*.mdx" "*.txt" "*.wiki"]
     :callback
     (fn []
       (let [is-modified (vapi.nvim_buf_get_option 0 "modified")
             {:my-date date} (lefen.get_date)
             cursor-position (vapi.nvim_win_get_cursor 0)]
         (when is-modified
           (vapi.nvim_command
             (.. "%s/edited: \\d\\d\\d\\d-\\d\\d-\\d\\dT\\d\\d:\\d\\d:\\d\\d/"
                 "edited: " date "/ge")))
         (vapi.nvim_command
           "%s/\\(^.\\+\\n\\)\\(^#\\+ .*\\n\\)/\\1\\r\\2/gec")
         (vapi.nvim_win_set_cursor 0 cursor-position)))
     }))


(fn get-wikilink-under-cursor []
  (var result nil)
  (local temp vim.g.minisurround_disable)
  ;; TODO: File issue with how disabling still makes it auto detect around (jump around)
  (set vim.g.minisurround_disable true)
  (let [cursor-before-yank (vapi.nvim_win_get_cursor 0)
        register-old-value (vfn.getreg "z")
        _SIDE-EFFECT-1_ (vim.cmd "normal vi[\"zy")
        cursor-after-yank (vapi.nvim_win_get_cursor 0)
        before-col (. cursor-before-yank 2)
        after-col (. cursor-after-yank 2)
        before-row (. cursor-before-yank 1)
        after-row (. cursor-after-yank 1)
        wikilink (: (vfn.getreg "z") :gsub "[%[%]]" "")
        wikilink-info (vfn.split wikilink "|" true)
        len (length wikilink-info)]
    (when (= after-row before-row)
      (if (t.contains [1 2] len)
        (do
          (when (= len 1)
            (t.insert wikilink-info (. wikilink-info 1)))
          (set wikilink-info.alias (. wikilink-info 2))
          (set wikilink-info.filename (. wikilink-info 1))
          (vfn.setreg "z" register-old-value)
          (set result wikilink-info))
        (lefen.notify-error "Invalid Link Under Cursor")))
    (vapi.nvim_win_set_cursor 0 cursor-before-yank))
  (set vim.g.minisurround_disable temp)
  result)

(fn open-wikilink-under-cursor [will-split is-sync]
  (lelua.le_atlas.open_wikilink_under_cursor will-split is-sync))

(fn get-link-and-copy []
  (lelua.le_atlas.get_link_and_copy))

(fn get-link-and-insert []
  (lelua.le_atlas.get_link_and_insert))

(fn setup [options]
  (add-save-hook))

{
 : setup
 : get-link-and-insert :get_link_and_insert get-link-and-insert
 : get-link-and-copy :get_link_and_copy get-link-and-copy
 : open-wikilink-under-cursor :open_wikilink_under_cursor open-wikilink-under-cursor
 }
