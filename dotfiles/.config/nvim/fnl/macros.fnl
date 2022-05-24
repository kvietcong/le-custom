;;; Macros for usage
;; Not really made by me (I'm too dumb to make macros on my own)
;; They are derived from other macro libraries like
;; - https://github.com/udayvir-singh/hibiscus.nvim

(local fennel (require :fennel))

(fn ast [expression]
  (let [(ok out) ((fennel.parser expression "fstring"))]
    out))

(fn fstring-og [str]
  (local args [])
  (each [to-interpolate (str:gmatch "$([({][^$]+[})])")]
    (if (to-interpolate:find "^{")
        (table.insert args (sym (to-interpolate:match "^{(.+)}$")))
        (table.insert args (ast to-interpolate))))
  `(string.format ,(str:gsub "$[({][^$]+[})]" "%%s") ,(unpack args)))

(fn fstring [str]
  (let [args
        (icollect [to-interpolate (str:gmatch "$([({][^$]+[})])")]
                  (if (to-interpolate:find "^{") ; if interpolating variable
                    (sym (to-interpolate:match "^{(.+)}$"))
                    (ast to-interpolate)))]
  `(string.format ,(str:gsub "$[({][^$]+[})]" "%%s") ,(unpack args))))

{
 : fstring
 : fstring-og
 : ast
 }
