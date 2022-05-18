; ==============================
; == Le Fennel Module (lefen) ==
; ==============================

; Just me playin' around with Fennel in Neovim

(global P
  (fn [...] (vim.pretty_print ...)))

; A note for weary travelers like me. os.date uses C's
; strftime under the hood. Vim's builtin strftime does too.
; Now most websites don't have all the format specifiers
; so it's best to go to the man pages of C's strftime
; directly. It took me quite a while to discover this
; and I finally found %V was what I was looking for.
(fn get-date [format]
  "Retrieve Current Date Information"
  (if
    (and (not= format nil) (not= format ""))
    (os.date format)

    {:year (tonumber (os.date "%Y"))
     :month (tonumber (os.date "%m"))
     :day (tonumber (os.date "%d"))
     :hour (tonumber (os.date "%H"))
     :minute (tonumber (os.date "%M"))
     :second (tonumber (os.date "%S"))
     :my-date (os.date "%Y-%m-%dT%H:%M:%S")
     :my_date (os.date "%Y-%m-%dT%H:%M:%S")
     :format (os.date)}))

(fn is-day? []
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
    (vim.fn.setreg "\"" item)
    (vim.notify
      final-message "info" { : title })))

; Module Export
{
    : is-day? :is_day is-day?
    : get-date :get_date get-date
    : set-register-and-notify :set_register_and_notify set-register-and-notify
}
