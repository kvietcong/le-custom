;;; ======================
;;; == Macros for me 🤖 ==
;;; ======================

;; Not really made by me (I'm too dumb to make macros on my own)
;; They are derived from other macro libraries like
;; - https://github.com/udayvir-singh/hibiscus.nvim

;; Also I can't get it to work consistently XD

; (local fennel (require :fennel))
; (local fennel (. (require :hotpot.api.fennel) :latest))

; ;; Get Fennel Module From Fennel Or My Fennel Provider
(λ get-hotpot-fennel []
  (let [hotpot-api-fennel (require :hotpot.api.fennel)]
    (hotpot-api-fennel.latest)))

(local fennel (or (require :fennel) (get-hotpot-fennel)))

(fn P [...]
  (print (fennel.view [...])))

(fn PR [...]
  (P ...)
  ...)

(fn string->fennel [string]
  (let [(is-ok result) ((fennel.parser string))]
    (if is-ok
        (print result)
        (error "Failed to Parse Expression"))))

(fn fstring [str]
  (let [args (icollect [form (str:gmatch "$([({][^$]+[})])")]
               ;; If we're interpolating a variable
               (if (form:find "^{")
                   ;; Just make inner form a symbol.
                   (sym (form:match "^{(.+)}$"))
                   ;; Else, parse the expression (Doesn't work sad)
                   ;; Doesn't work, We will just use eval instead I guess :(
                   ;; No local variables in statements ; (string->fennel form)))]
                   (fennel.eval form)))]
    `(string.format ,(str:gsub "$[({][^$]+[})]" "%%s") ,(unpack args))))

{: fstring}
