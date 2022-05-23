(local ll (require :le_lua))
(local lf (require :le-fnl))
(local wk (require :which-key))

(fn -- [x] (- x 1))
(local dec --)

(fn ++ [x] (+ x 1))
(local inc ++)

(fn get-wikilink-info-under-cursor* []
  (let [cursor (vapi.nvim_win_get_cursor 0)
        line (vapi.nvim_get_current_line)
        column (+ (. cursor 2) 1)
        all-before (line:sub 1 (-- column))
        all-after (line:sub (++ column))
        ; TODO: See if there's a better way to get char at
        current (line:sub column column)
        before (all-before:sub -1 -1)
        after (all-after:sub 1 1)
        is-lb (= "[" current)
        is-lbb (= "[" before)
        is-rb (= "]" current)
        is-rbb (= "]" after)
        before-pattern (if is-rbb "" is-rb "%[$" "%[%[[^%[%]]+$")
        before-match (all-before:match before-pattern)
        after-pattern (if is-lbb "" is-lb "^%]" "^[^%[%]]+%]%]")
        after-match (all-after:match after-pattern)
        wikilink (if (and before-match after-match)
                   (.. before-match current after-match)
                   nil)
        wikilink-info
        (if wikilink
          (vim.split (wikilink:gsub "[%[%]]" "") "|" true)
          nil)
        len (length (or wikilink-info []))]
    ;; Cleanup
    (if (t.contains [1 2] len)
      (do
        (when (= len 1)
          (t.insert wikilink-info (. wikilink-info 1)))
        (set wikilink-info.alias (. wikilink-info 2))
        (set wikilink-info.filename (. wikilink-info 1))
        wikilink-info)
      (lf.notify-error "Invalid Link Under Cursor"))
    (values wikilink-info all-after after-pattern after-match)))

(fn get-wikilink-info-under-cursor []
  "Get Wikilink `filename` and `alias`"
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
    (vapi.nvim_win_set_cursor 0 cursor-before-yank)
    (set vim.g.minisurround_disable temp)
    (when (= after-row before-row)
      (if (t.contains [1 2] len)
        (do
          (when (= len 1)
            (t.insert wikilink-info (. wikilink-info 1)))
          (set wikilink-info.alias (. wikilink-info 2))
          (set wikilink-info.filename (. wikilink-info 1))
          (vfn.setreg "z" register-old-value)
          wikilink-info)
        (lf.notify-error "Invalid Link Under Cursor")))))

(fn open-wikilink-under-cursor [will-split]
  (let [wikilink-info (get-wikilink-info-under-cursor)]
    (if wikilink-info
      (let [filename wikilink-info.filename]
        (ll.le_atlas.wiki_filename_to_filepath_async
          (fn [filepaths]
            (let [file (. filepaths 1)]
              (if file
                ((vim.schedule_wrap
                   (fn []
                     (if will-split
                       (vim.cmd (.. "vsplit " file))
                       (vim.cmd (.. "e " file))))))
                (lf.notify-error "Couldn't Find File"))))
          filename))
      (lf.notify-error "No Link Under Your Cursor"))))

(fn choose-wikilink-and-copy []
  (ll.le_atlas.get_link_and_copy))

(fn choose-wikilink-and-insert []
  (ll.le_atlas.get_link_and_insert))

(fn add-save-hook []
  (vapi.nvim_create_autocmd
    "BufWritePre"
    {:group le_group
     :desc "Clean up and update metadata when taking Notes"
     :pattern ["*.md" "*.mdx" "*.wiki"]
     :callback
     (fn [event-info]
       (let [is-modified (vapi.nvim_buf_get_option 0 "modified")
             {:my-date date} (lf.get_date)
             cursor-position (vapi.nvim_win_get_cursor 0)]
         (when is-modified
           (vapi.nvim_command
             (.. "%s/edited: \\d\\d\\d\\d-\\d\\d-\\d\\dT\\d\\d:\\d\\d:\\d\\d/"
                 "edited: " date "/ge")))
         (vapi.nvim_command
           "%s/\\(^.\\+\\n\\)\\(^#\\+ .*\\n\\)/\\1\\r\\2/gec")
         (vapi.nvim_win_set_cursor 0 cursor-position)))
     }))

(fn add-keymaps []
  (vapi.nvim_create_autocmd
    "BufEnter"
    {:group le-group
     :desc "Add Note Taking Keymaps"
     :pattern ["*.md" "*.mdx" "*.wiki"]
     :callback
     (fn [event-info]
       (wk.register
         {
          :<Enter> [open-wikilink-under-cursor "Go To Wikilink"]
          :<Leader><Enter> [(fn [] (open-wikilink-under-cursor true)) "Go To Wikilink (Split)"]
          :<Leader>nl [choose-wikilink-and-copy "Get a wikilink"]
          }
         { :buffer event-info.buf })
       (wk.register
         {
          :<C-l> [choose-wikilink-and-insert "Insert a wikilink"]
          }
         { :buffer event-info.buf :mode "i" }))
     }))

(fn setup []
  (add-save-hook)
  (add-keymaps))

{
 : setup
 : choose-wikilink-and-insert :choose_wikilink_and_insert choose-wikilink-and-insert
 : choose-wikilink-and-copy :choose_wikilink_and_copy choose-wikilink-and-copy
 : open-wikilink-under-cursor :open_wikilink_under_cursor open-wikilink-under-cursor
 }
