;; GUI Settings
(local which-key (require :le.which-key))

(set vim.g.neovide_no_idle false)
(set vim.g.neovide_refresh_rate 165)
(set vim.g.neovide_transparency 0.98)
(set vim.g.neovide_cursor_antialiasing true)
(set vim.g.neovide_cursor_vfx_mode :railgun)
(set vim.g.neovide_cursor_animation_length 0.1)
(set vim.g.neovide_cursor_vfx_particle_phase 3)
(set vim.g.neovide_cursor_vfx_particle_density 30)

;; GUI Font Resizing
;; Thank you so much https://github.com/neovide/neovide/issues/1301#issuecomment-1119370546
(when is_gui
  (set vim.g.gui_font_default_size 14)
  (set vim.g.gui_font_size vim.g.gui_font_default_size)
  (set vim.g.gui_font_face "CodeNewRoman NF")
  (let [refresh-gui-font #(set vim.opt.guifont
                               (string.format "%s:h%s" vim.g.gui_font_face
                                              vim.g.gui_font_size))
        nudge-gui-font #(do
                          (set vim.g.gui_font_size (+ vim.g.gui_font_size $1))
                          (refresh-gui-font))
        reset-gui-font #(do
                          (set vim.g.gui_font_size vim.g.gui_font_default_size)
                          (refresh-gui-font))]
    (reset-gui-font)
    (which-key.register {:name "(f)ont"
                         :r {:k [#(nudge-gui-font 2) "Bigger Font"]
                             :j [#(nudge-gui-font -2) "Smaller Font"]
                             :+ [#(nudge-gui-font 2) "Bigger Font"]
                             :- [#(nudge-gui-font -2) "Smaller Font"]
                             := [reset-gui-font "Reset Font"]}}
                        {:prefix :<Leader><Leader>f})))

(when is_nvui
  (vim.cmd "NvuiOpacity 0.95")
  (vim.cmd "NvuiTitlebarFontSize 13")
  (vim.cmd "NvuiCmdCenterXPos 0.5")
  (vim.cmd "NvuiCmdCenterYPos 0.5")
  (vim.cmd "NvuiCmdline v:true")
  (vim.cmd "NvuiCmdFontSize 14")
  (vim.cmd "NvuiCmdBigFontScaleFactor 1.25")
  (vim.cmd "NvuiSnapshotLimit 10")
  (vim.cmd "NvuiScrollAnimationDuration 0.5"))
