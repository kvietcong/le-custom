;;; ================================
;;; == Le Fennel Module (le.libf) ==
;;; ================================

;; A fennel library with useful functions?
;; Essentially me playin' around with Fennel in Neovim.

(local vfn vim.fn)
(local vapi vim.api)
(local Job (require :plenary.job))
(local {: view} (require :fennel))

;; Helper table to keep track of dynamically generated things
(local M {})

(λ id [...]
  ...)

(local map t.map)
(local list? t.islist)
(local empty? t.isempty)
(local keys t.keys)
(local contains? t.contains)

(λ type? [type-condition ?x]
  (match type-condition
    (where type-condition (= (type type-condition) :function)) (type-condition ?x)
    :list (list? ?x)
    _ (= (type ?x) type-condition)))

(local all-types [:nil
                  :boolean
                  :number
                  :string
                  :function
                  :userdata
                  :thread
                  :table])

;; Create Type Checkers
;; - `<TYPE>?`
;; - `get_is_<TYPE>`
(each [_ lua-type (ipairs all-types)]
  (let [checker (λ [?x]
                  (type? lua-type ?x))]
    (tset M (.. lua-type "?") checker)
    (tset M (.. :get_is_ lua-type) checker)))

;; Given a list of pairs, check types
;; The pairs are <Type String or Type Predicate> and <Value>
;; If anything fails, an error is thrown. If successful, the function returns true.
;; Type strings may also be unions of multiple types (i.e. :string|table|nil)
;; TODO: Move a lot of the logic into `type?`
(λ type-check! [to-check]
  (for [i 1 (length to-check) 2]
    (let [string? M.string?
          type-conditions (. to-check i)
          value (. to-check (+ i 1))
          checks (icollect [_ type-condition (ipairs (if (string? type-conditions)
                                                         (vfn.split type-conditions
                                                                    "|")
                                                         [type-conditions]))]
                   (type? type-condition value))]
      (assert (vim.tbl_contains checks true)
              (if (string? type-conditions)
                  (.. "Type Mismatch! Expected: " type-conditions)
                  "Failed to match type predicates"))))
  true)

;; A Certified JavaScript Moment
(fn falsy? [x]
  (or (not x) (= x "") (and (M.table? x) (empty? x)) (= x 0)))

(fn not-falsy? [x]
  (not (falsy? x)))

(λ reverse-get [table target]
  (type-check! [:table table])
  (var found nil)
  (each [key value (pairs table)]
    :until
    (not= found nil)
    (if (= value target) (set found key)))
  found)

(λ notify-level [message level ?custom-title]
  (type-check! [:string message :number level :string|nil ?custom-title])
  (vim.notify message level
              {:title (or ?custom-title
                          (: (reverse-get vim.log.levels level) :gsub "^%l"
                             string.upper))}))

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
    (tset M (.. :notify- level) notifier)
    (tset M (.. :notify_ level) notifier)
    (tset M (.. :notify- level-l) notifier)
    (tset M (.. :notify_ level-l) notifier)))

(λ head [xs]
  (type-check! [list? xs])
  (. xs 1))

;; Expensive AF
(λ tail [xs]
  (type-check! [list? xs])
  [(select 2 (unpack xs))])

(λ fold* [folder ?initial foldable iterator-maker]
  (type-check! [:function folder])
  (accumulate [accumulated ?initial key next (iterator-maker foldable)]
    (folder accumulated next key)))

(λ fold [folder ?initial foldable]
  "Fold a table's keys and values (NOT STRICT ON ORDER)"
  (fold* folder ?initial foldable pairs))

(λ foldl [folder ?initial foldable]
  "Fold a sequence from the left"
  (fold* folder ?initial foldable ipairs))

(λ compose [f1 f2]
  (λ [...]
    (f1 (f2 ...))))

;; Not particularly nice XD
(λ foldr [folder ?initial foldable]
  "Fold a sequence from the right"
  (fold* (λ [?acc ?next]
           (folder ?next ?acc)) ?initial foldable
         (compose ipairs vfn.reverse)))

;; Head and Last using fold but I think it's inefficient.
;; Got from the Haskell wiki though and kept it b/c it's cool
(local head! (partial foldr #(values $1) nil))
(local last! (partial foldl #(values $2) nil))

(λ reduce [folder foldable]
  (foldl folder (head foldable) (tail foldable)))

;; Weird I implemented scan in terms of fold lol.
(λ scan* [scanner foldable iterator-maker]
  (type-check! [:function scanner])
  (var result [(head foldable)])
  (let [new-scanner (λ [...]
                      (local scan (scanner ...))
                      (t.insert result scan)
                      scan)]
    (fold* new-scanner (head foldable) (tail foldable) iterator-maker))
  result)

(λ scan [scanner foldable]
  (scan* scanner foldable pairs))

(λ scanl [scanner foldable]
  (scan* scanner foldable ipairs))

(λ for-each [table function]
  (each [index value (ipairs table)]
    (function value index)))

(λ ! [function]
  (λ [...]
    (not (function ...))))

;; A note for weary travelers like me. os.date uses C's
;; strftime under the hood. Vim's builtin strftime does too.
;; Now most websites don't have all the format specifiers
;; so it's best to go to the man pages of C's strftime
;; directly. It took me quite a while to discover this
;; and I finally found %V was what I was looking for.
(λ get-date [?format]
  (type-check! [:string|nil ?format])
  (let [datetime os.date
        my-date (datetime "%Y-%m-%dT%H:%M:%S")
        offset (datetime "%z")
        offset-hr (string.sub offset 1 3)
        offset-min (string.sub offset 4)
        my-date (.. my-date offset-hr ":" offset-min)]
    (if (falsy? ?format) {:year (tonumber (datetime "%Y"))
                          :month (tonumber (datetime "%m"))
                          :week (tonumber (datetime "%V"))
                          :day (tonumber (datetime "%d"))
                          :hour (tonumber (datetime "%H"))
                          :minute (tonumber (datetime "%M"))
                          :second (tonumber (datetime "%S"))
                          : my-date
                          :my_date my-date
                          :format datetime}
        (datetime ?format))))

(λ day? []
  (let [date-info (get-date)
        hour date-info.hour]
    (and (< 6 hour) (< hour 18))))

(λ set-register-and-notify [item ?message ?title]
  (type-check! [:string item :string|function|nil ?message :string|nil ?title])
  (let [title (or ?title "Register Set")]
    (var final-message ?message)
    (if (= (type final-message) :function)
        (set final-message (final-message item)))
    (set final-message (or final-message (.. "\"" item "\" Ready to Paste")))
    (vfn.setreg "\"" item)
    (vim.notify final-message :info {: title})))

(λ get-locals [?stack-max]
  (type-check! [:number|nil ?stack-max])
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
  (type-check! [:table options])
  (when options.cwd ; WHY YOU SO WACK WINDOWS
    (if is_win (set options.cwd (options.cwd:gsub "~" :$HOME)))
    (set options.cwd (vfn.expand options.cwd)))
  (let [callback options.callback
        callback-table (if callback
                           {:on_exit (λ [job]
                                       (let [result (job:result)
                                             result (icollect [_ item (ipairs result)]
                                                      (item:gsub "\\\\" "/"))]
                                         (callback result)))}
                           {})
        job-options (t.extend :keep {:command :fd} options callback-table)
        job (Job:new job-options)]
    (job:start)
    job))

(λ clean [right-hand-side]
  (vapi.nvim_replace_termcodes right-hand-side true true true))

(λ KiB->B [KiB]
  (* KiB 1024))

(λ thicc-buffer? [?buf-number]
  (let [buf-number (or ?buf-number 0)
        buf-name (vapi.nvim_buf_get_name buf-number)
        buf-size (vim.fn.getfsize buf-name)
        line-amount (vim.api.nvim_buf_line_count buf-number)]
    (or (> buf-size (KiB->B 100))
        (> line-amount 10_000))))

; Module Export
(t.extend :keep {: !
                 : fold
                 : foldl
                 : fold*
                 : scan*
                 : scan
                 : scanl
                 : head
                 : map
                 : reduce
                 : type?
                 : keys
                 : contains?
                 :get_does_contain contains?
                 : list?
                 :get_is_list list?
                 :get_is_type type?
                 : type-check!
                 :TYPE_CHECK type-check!
                 :fold_ fold*
                 :to_string view
                 :*->string view
                 : view
                 :reverse_get reverse-get
                 : notify-level
                 : reverse-get
                 :notify_level notify-level
                 : set-register-and-notify
                 :set_register_and_notify set-register-and-notify
                 : fd-async
                 :fd_async fd-async
                 : get-date
                 :get_date get-date
                 : day?
                 :get_is_day day?
                 : empty?
                 :get_is_empty empty?
                 : falsy?
                 :get_is_falsy falsy?
                 : not-falsy?
                 :get_is_not_falsy not-falsy?
                 : get-locals
                 :get_locals get-locals
                 : clean
                 :get_is_thicc_buffer thicc-buffer?
                 : thicc-buffer?} M)
