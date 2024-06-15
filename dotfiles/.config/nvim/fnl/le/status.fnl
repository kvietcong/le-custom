;; Setup Status Line
(local mini-statusline (require :mini.statusline))
(local navic (require :nvim-navic))
(local which-key (require :which-key))
(local mini-bufremove (require :mini.bufremove))
(local mini-tabline (require :mini.tabline))

(set vim.o.laststatus 3)
(set vim.o.winbar "%#MiniStatuslineFilename#%=%f%=")

(λ get-statusline []
  (let [os-symbols {:unix "" :dos "" :mac ""}
        os-symbol (. os-symbols (if is_win :dos
                                    is_mac :mac
                                    :unix))
        nav-string (or (and (navic.is_available) (navic.get_location)) nil)
        (mode mode-hl) (mini-statusline.section_mode {})
        mode (mode:upper)
        git (mini-statusline.section_git {})
        diagnostics (mini-statusline.section_diagnostics {})
        filename (vfn.expand "%:~:.")
        file-info (mini-statusline.section_fileinfo {})
        file-os vim.bo.fileformat
        file-os-symbol (. os-symbols file-os)
        file-info (file-info:gsub file-os file-os-symbol)
        location "%l:%v (%p%%)"]
    (mini-statusline.combine_groups [{:hl mode-hl :strings [mode]}
                                     {:hl :MiniStatuslineDevinfo
                                      :strings [git]}
                                     {:hl :MiniStatuslineFilename
                                      :strings [diagnostics]}
                                     {:hl :MiniStatuslineDevinfo
                                      :strings [nav-string]}
                                     "%="
                                     {:hl :MiniStatuslineDevinfo
                                      :strings [os-symbol]}
                                     {:hl mode-hl :strings [filename]}
                                     {:hl :MiniStatuslineFileinfo
                                      :strings [file-info]}
                                     {:hl mode-hl :strings [location]}])))

(mini-statusline.setup {:set_vim_settings false
                        :content {:active get-statusline}})

(mini-bufremove.setup {})
(mini-tabline.setup {:tabpage_section :right})
(local next ":bn<Enter>")
(local prev ":bp<Enter>")
(which-key.register {:<Leader>b {:name "(b)uffers"
                                 :b [":Telescope buffers<Enter>"
                                     "find (b)uffer"]
                                 :f [":Telescope buffers<Enter>"
                                     "(b)uffer (f)ind"]
                                 :q [mini-bufremove.unshow_in_window
                                     "(b)uffer (q)uit [unshows buffer]"]
                                 :d [(λ []
                                       (mini-bufremove.delete 0 true))
                                     "(b)uffer (d)elete"]
                                 :c [":bd<Enter>" "(b)uffer (c)lose"]
                                 :l [next "(b)uffer next"]
                                 :h [prev "(b)uffer prev"]
                                 :o [":BO<Enter>"
                                     "(b)uffer (o)nly (Close all but this)"]}
                     :<M-l> [next "buffer next"]
                     :<M-h> [prev "buffer prev"]
                     :<M-Right> [next "buffer next"]
                     :<M-Left> [prev "buffer prev"]})

mini-statusline
