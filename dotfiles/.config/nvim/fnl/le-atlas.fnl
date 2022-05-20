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
             {:my-date date} (lefen.get_date)]
         (when is-modified
           (vapi.nvim_command
             (.. "%s/edited: \\d\\d\\d\\d-\\d\\d-\\d\\dT\\d\\d:\\d\\d:\\d\\d/"
                 "edited: " date "/ge")))
         (vapi.nvim_command
           "%s/\\(^.\\+\\n\\)\\(^#\\+ .*\\n\\)/\\1\\r\\2/gec")))
     }))

(fn get_wikilink_under_cursor []
  (var result nil)
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
  result)

(fn open-wikilink-under-cursor [will-split is-sync]
  (lelua.le_atlas.open_wikilink_under_cursor will-split is-sync))

(fn insert-link []
  (lelua.le_atlas.insert_link))

(fn setup [options]
  (add-save-hook))

{
 : setup
 : insert-link :insert_link insert-link
 : open-wikilink-under-cursor :open_wikilink_under_cursor open-wikilink-under-cursor
 }
