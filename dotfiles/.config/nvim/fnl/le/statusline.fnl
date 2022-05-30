;; Setup Status Line
(local mini-statusline (require :mini.statusline))

(set vim.go.laststatus (if is_firenvim 0 3))

(λ get-statusline []
  (let [os-symbols {:unix "" :dos "" :mac ""}
        os-symbol (. os-symbols (if is_win :dos
                                    is_mac :mac
                                    :unix))
        gps (require :nvim-gps)
        gps-string (or (and (gps.is_available) (gps.get_location)) nil)
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
                                      :strings [gps-string]}
                                     "%="
                                     {:hl :MiniStatuslineDevinfo
                                      :strings [os-symbol]}
                                     {:hl mode-hl :strings [filename]}
                                     {:hl :MiniStatuslineFileinfo
                                      :strings [file-info]}
                                     {:hl mode-hl :strings [location]}])))

(mini-statusline.setup {:set_vim_settings false
                        :content {:active get-statusline}})

mini-statusline
