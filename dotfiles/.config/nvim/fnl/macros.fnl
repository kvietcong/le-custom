;;; ======================
;;; == Macros for me 🤖 ==
;;; ======================

;; Not really made by me (I'm too dumb to make macros on my own)
;; They are derived from other macro libraries like
;; - https://github.com/udayvir-singh/hibiscus.nvim

;; Also I can't get it to work consistently XD

(local fennel (require :fennel))

; ;; Get Fennel Module From Fennel Or My Fennel Provider
; (λ get-fennel []
;   (let [hotpot-api-fennel (require :hotpot.api.fennel)]
;     (hotpot-api-fennel.latest)))
; (λ fennel [] (or (require :fennel) (get-fennel)))

(fn P [...]
  (print (fennel.view [...])))

(fn PR [...]
  (P ...)
  ...)

(fn string->fennel [string]
  (let [(is-ok result) ((fennel.parser string))]
    (if is-ok
        result
        (error "Failed to Parse Expression"))))

(fn fstring [str]
  (let [args (icollect [form (str:gmatch "$([({][^$]+[})])")]
               ;; If we're interpolating a variable
               (if (form:find "^{")
                   ;; Just make inner form a symbol.
                   (sym (form:match "^{(.+)}$"))
                   ;; Else, parse the expression
                   (string->fennel form)))]
    `(string.format ,(str:gsub "$[({][^$]+[})]" "%%s") ,(unpack args))))

{: fstring}
