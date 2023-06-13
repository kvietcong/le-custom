;; Below is essentially Olical's nvim-local-fennel for
;; Hotpot instead of Aniseed.
;; It allows you to have fennel configuration files that
;; are auto-run when you enter a directory.
;; The file searched for is `.lnvim.fnl`
(local {: notify-info} (require :le.libf))

(λ parent [dir]
  "Parent of a directory or nil."
  (let [candidate (vfn.fnamemodify dir ":h")]
    (when (and (not= dir candidate) (vfn.isdirectory candidate))
      candidate)))

(λ parents [dir]
  "All parents of a directory."
  (var result [])
  (var dir (parent dir))
  (while dir
    (table.insert result 1 dir)
    (set dir (parent dir)))
  result)

(λ file-readable? [path]
  "Is the file readable?"
  (= 1 (vfn.filereadable path)))

(λ file-newer? [a b]
  (< (vfn.getftime b) (vfn.getftime a)))

(local hotpot-compile (require :hotpot.api.compile))
(λ compile-file-to [src dest]
  (let [(success code) (hotpot-compile.compile-file src)]
    (if success
        (do
          (let [dest-file (io.open dest :w+)]
            (dest-file:write code)
            (dest-file:close)))
        (P :ERROR))))

;; Iterate over all directories from the root to the cwd.
;; For every .lnvim.fnl, compile it to .lvim.lua (if required) and execute it.
;; If a .lua is found without a .fnl, delete the .lua to clean up.
(vapi.nvim_create_autocmd [:VimEnter :DirChanged]
                          {:callback #(let [cwd (vapi.nvim_exec :pwd true)
                                            cwd (cwd:gsub "\\" "/")
                                            dirs (parents cwd)]
                                        (table.insert dirs cwd)
                                        (each [_ dir (ipairs dirs)]
                                          (let [src (.. dir :/.lnvim.fnl)
                                                dest (.. dir :/.lnvim.lua)]
                                            (if (file-readable? src)
                                                (do
                                                  (when (file-newer? src dest)
                                                    (compile-file-to src dest))
                                                  (vim.cmd (.. "luafile " dest))
                                                  (notify-info (.. "Compiled "
                                                                   src)))
                                                (when (file-readable? dest)
                                                  (vfn.delete dest))))))})

true
