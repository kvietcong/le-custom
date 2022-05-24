;;; ===============================
;;; == Le Fennel Module (le-fnl) ==
;;; ===============================

;;; Just me playin' around with Fennel in Neovim

(local Job (require :plenary.job))
(local vfn vim.fn)
(local vapi vim.api)

;; Helper table to keep track of dynamically generated things
(local M {})

(λ id [...] ...)

(local empty? vim.tbl_isempty)

(λ table? [?table] (= (type ?table) "table"))

(fn falsy? [x]
  (or (not x) (= x "") (and (table? x) (empty? x)) (= x 0)))

(fn not-falsy? [x] (not (falsy? x)))

(λ reverse-get [table target]
  (var found nil)
  (each [key value (pairs table)] :until (not= found nil)
    (if (= value target) (set found key)))
  found)

(λ notify-level [message level ?custom-title]
  (vim.notify
    message
    level
    {:title
     (or ?custom-title
         (: (reverse-get vim.log.levels level)
            :gsub "^%l" string.upper))
     }))

(λ inc [x] (+ x 1))
(local ++ inc)
(λ dec [x] (- x 1))
(local -- dec)

(λ max [x y] (if (>= x y) x y))
(λ min [x y] (if (<= x y) x y))
(λ clamp [min# max# x] (max min# (min max# x)))
(λ clamp+0 [max# x] (clamp 0 max# x))
(λ clamp-0 [min# x] (clamp min# 0 x))
(λ inc-pos [pos inc-by] [(. pos 1) (+ (. pos 2) inc-by)])
(λ dec-pos [pos dec-by] [(. pos 1) (max 0 (- (. pos 2) dec-by))])

;; Dynamically generate notify shortcuts
;; TODO: File issue on nvim-notify about Trace and Debug
;;       not working
(tset M :notify {})
(each [level level-number (pairs vim.log.levels)]
  (let [level-l (string.lower level)]
    (λ notifier [message ?custom-title]
      (notify-level message level-number ?custom-title))
    (tset M.notify level-number notifier)
    (tset M.notify level-number notifier)
    (tset M (.. "notify-" level) notifier)
    (tset M (.. "notify_" level) notifier)
    (tset M (.. "notify-" level-l) notifier)
    (tset M (.. "notify_" level-l) notifier)))

(λ fold* [folder initial foldable iterator-maker]
  (accumulate [accumulated initial
               key next (iterator-maker foldable)]
              (folder accumulated next key)))

(λ foldl [folder initial foldable]
  "Fold a sequence from the left"
  (fold* folder initial foldable ipairs))

(λ fold [folder initial foldable]
  "Fold a table's keys and values (NOT STRICT ON ORDER)"
  (fold* folder initial foldable pairs))

;; A note for weary travelers like me. os.date uses C's
;; strftime under the hood. Vim's builtin strftime does too.
;; Now most websites don't have all the format specifiers
;; so it's best to go to the man pages of C's strftime
;; directly. It took me quite a while to discover this
;; and I finally found %V was what I was looking for.
(λ get-date [?format]
  "Retrieve Current Date Information"
  (let [datetime os.date]
    (if (falsy? ?format)
      {:year (tonumber (datetime "%Y"))
       :month (tonumber (datetime "%m"))
       :day (tonumber (datetime "%d"))
       :hour (tonumber (datetime "%H"))
       :minute (tonumber (datetime "%M"))
       :second (tonumber (datetime "%S"))
       :my-date (datetime "%Y-%m-%dT%H:%M:%S")
       :my_date (datetime "%Y-%m-%dT%H:%M:%S")
       :format datetime}
      (datetime ?format))))

(λ day? []
  (let [date-info (get-date)
        hour date-info.hour]
    (and (> hour 6) (< hour 18))))

(λ set-register-and-notify [item ?message ?title]
  (let [title (or ?title "Register Set")]
    (var final-message ?message)
    (if (= (type final-message) "function")
      (set final-message (final-message item)))
    (set final-message
         (or
           final-message
           (.. "\"" item "\" Ready to Paste")))
    (vfn.setreg "\"" item)
    (vim.notify
      final-message "info" { : title })))

(λ get-locals [?stack-max]
  (local locals {})
  (var j 1)
  (var remaining? true)
  (for [i 1 (or ?stack-max 2)]
    (while remaining?
      (let [(name value) (debug.getlocal 2 j)]
        (if (not= name nil)
          (tset locals name value)
          (set remaining? false))
        (set j (+ j 1)))))
  locals)

(λ fd-async [options]
  (when options.cwd ; WHY YOU SO WACK WINDOWS
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
(t.extend
  "keep"
  {
   : fold
   : foldl
   : fold* :fold_ fold*

   : reverse-get :reverse_get reverse-get
   : notify-level :notify_level notify-level

   : set-register-and-notify :set_register_and_notify set-register-and-notify

   : inc : ++
   : dec : --
   : max : min

   : inc-pos :inc_pos inc-pos
   : dec-pos :dec_pos dec-pos

   : clamp
   : clamp+0 :clamp_pos0 clamp+0
   : clamp-0 :clamp_neg0 clamp-0

   : fd-async :fd_async fd-async

   : day? :get_is_day day?
   : get-date :get_date get-date

   : empty? :get_is_empty empty?
   : table? :get_is_table table?
   : falsy? :get_is_falsy falsy?
   : not-falsy? :get_is_not_falsy not-falsy?

   : get-locals :get_locals get-locals
   }
  M)
