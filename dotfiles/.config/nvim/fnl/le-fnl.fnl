;;; ===============================
;;; == Le Fennel Module (le-fnl) ==
;;; ===============================

;;; Just me playin' around with Fennel in Neovim

(local Job (require :plenary.job))

;; Helper table to keep track of dynamically generated things
(local M {})

(fn id [...] ...)

(fn reverse-get [table target]
  (var found nil)
  (each [key value (pairs table)] :until (not= found nil)
    (when (= value target) (set found key)))
  found)

(fn notify-level [message level custom-title]
  (vim.notify
    message
    level
    {:title
     (or custom-title
         (: (reverse-get vim.log.levels level)
            :gsub "^%l" string.upper))
     }))

;; Dynamically generate notify shortcuts
;; TODO: File issue on nvim-notify about Trace and Debug
;;       not working
(tset M :notify {})
(each [level level-number (pairs vim.log.levels)]
  (let [level-l (string.lower level)]
    (fn notifier [message custom-title]
      (notify-level message level-number custom-title))
    (tset M.notify level-number notifier)
    (tset M.notify level-number notifier)
    (tset M (.. "notify-" level) notifier)
    (tset M (.. "notify_" level) notifier)
    (tset M (.. "notify-" level-l) notifier)
    (tset M (.. "notify_" level-l) notifier)))

(fn fold* [folder initial foldable iterator-maker]
  (accumulate [accumulated initial
               key next (iterator-maker foldable)]
              (folder accumulated next key)))

(fn foldl [folder initial foldable]
  "Fold a sequence from the left"
  (fold* folder initial foldable ipairs))

(fn fold [folder initial foldable]
  "Fold a table's keys and values (NOT STRICT ON ORDER)"
  (fold* folder initial foldable pairs))

;; A note for weary travelers like me. os.date uses C's
;; strftime under the hood. Vim's builtin strftime does too.
;; Now most websites don't have all the format specifiers
;; so it's best to go to the man pages of C's strftime
;; directly. It took me quite a while to discover this
;; and I finally found %V was what I was looking for.
(fn get-date [format]
  "Retrieve Current Date Information"
  (let [dt os.date]
    (if
      (and (not= format nil) (not= format ""))
      (dt format)

      {:year (tonumber (dt "%Y"))
       :month (tonumber (dt "%m"))
       :day (tonumber (dt "%d"))
       :hour (tonumber (dt "%H"))
       :minute (tonumber (dt "%M"))
       :second (tonumber (dt "%S"))
       :my-date (dt "%Y-%m-%dT%H:%M:%S")
       :my_date (dt "%Y-%m-%dT%H:%M:%S")
       :format (dt)})))

(fn day? []
  (let [date-info (get-date)
        hour date-info.hour]
    (and (> hour 6) (< hour 18))))

(fn set-register-and-notify [item message title]
  (let [title (or title "Register Set")]
    (var final-message message)
    (when (= (type final-message) "function")
      (set final-message (final-message item)))
    (set final-message
         (or
           final-message
           (.. "\"" item "\" Ready to Paste")))
    (vfn.setreg "\"" item)
    (vim.notify
      final-message "info" { : title })))

(fn get-locals [stack-max]
  (local locals {})
  (var j 1)
  (var remaining? true)
  (for [i 1 (or stack-max 2)]
    (while remaining?
      (let [(name value) (debug.getlocal 2 j)]
        (if (not= name nil)
          (tset locals name value)
          (set remaining? false))
        (set j (+ j 1)))))
  locals)

(fn falsy? [item]
  (or (not item) (= item "") (= item {}) (= item 0)))

(fn not-falsy? [x] (not (falsy? x)))

(fn fd-async [options]
  (when options.cwd
    (if is_win (set options.cwd (options.cwd:gsub "~" "$HOME")))
    (set options.cwd (vfn.expand options.cwd)))
  (let [callback options.callback
        callback-table
        (if callback
           {:on_exit (λ [job] (callback (job:result)))}
           {})
        job-options
        (t.extend
          "keep"
          {:command "fd"}
          options
          callback-table)
        job (Job:new job-options)]
    (job:start)
    job))

; Module Export
(t.extend "keep" {
 : fold
 : foldl
 : fold* :fold_ fold*

 : fd-async :fd_async fd-async

 : reverse-get :reverse_get reverse-get
 : notify-level :notify_level notify-level

 : day? :get_is_day day?
 : get-date :get_date get-date

 : falsy? :get_is_falsy falsy?
 : not-falsy? :get_is_not_falsy not-falsy?

 : set-register-and-notify :set_register_and_notify set-register-and-notify

 : get-locals :get_locals get-locals
 } M)
