(local hydra (require :hydra))
(local keymap-util (require :hydra.keymap-util))

(local c keymap-util.cmd)
(local pc keymap-util.pcmd)

(local splits (require :smart-splits))
(local winshift (require :winshift))
(local winshift-lib (require :winshift.lib))

(splits.setup {})
(winshift.setup {})

(hydra {:name "Window Manipulation"
        :hint "
  ^^            🪟 Window Manipulation 🪟

  ^^              👆 _k_        ^^  Split Vertically    _v_
  [Resize] 👈 _h_ 🟰 _=_ 👉 _l_     Split Horizontally  _s_
  ^^              👇 _j_        ^^
  ^^                ^ ^         ^^  Select Other Window _w_
  ^^              👆 _K_        ^^
  [Move]   👈 _H_ ✨ _m_ 👉 _L_     Close Other Windows _o_
  ^^              👇 _J_        ^^  Close This Window  _c_ _q_  ^

                     ❌ _<Esc>_ ❌
 "
        :body :<Leader>wm
        :mode :n
        :config {:invoke_on_body true
                 :hint {:border :shadow :type :window :position :middle}}
        :heads [[:H (c "WinShift left")]
                [:J (c "WinShift down")]
                [:K (c "WinShift up")]
                [:L (c "WinShift right")]
                [:m (c :WinShift) {:exit true}]
                [:h #(splits.resize_left 2)]
                [:j #(splits.resize_down 2)]
                [:k #(splits.resize_up 2)]
                [:l #(splits.resize_right 2)]
                ["=" :<C-w>=]
                [:s (pc :split :E36)]
                [:w #(vim.fn.win_gotoid (winshift-lib.pick_window))]
                [:v (pc :vsplit :E36)]
                [:o :<C-w>o {:exit true :desc "close other splits"}]
                [:c (pc :close :E444)]
                [:q (pc :close :E444) {:desc "close window"}]
                [:<Esc> nil {:exit true}]]})

(hydra {:name "Vim Options"
        :hint "
^^^^^^             🔧 Vim Options 🔧

^^^^^^  _w_: %{wrap} wrap
^^^^^^  _n_: %{nu} number
^^^^^^  _s_: %{spell} spell
^^^^^^  _c_: %{cul} cursor line
^^^^^^  _v_: %{ve} virtual edit
^^^^^^  _r_: %{rnu} relative number
^^^^^^  _l_: %{list} list (show invisible characters)  ^

^^^^^^                ❌ _<Esc>_ ❌

"
        :body :<Leader>o
        :mode [:n :x]
        :config {:invoke_on_body true
                 :hint {:border :shadow :position :middle}}
        :heads [[:n #(set vim.o.number (not vim.o.number))]
                [:r
                 #(if vim.o.relativenumber (set vim.o.relativenumber false)
                      (do
                        (set vim.o.number true)
                        (set vim.o.relativenumber true)))]
                [:v
                 #(if (= vim.o.virtualedit :all) (set vim.o.virtualedit :block)
                      (set vim.o.virtualedit :all))]
                [:l #(set vim.o.list (not vim.o.list))]
                [:s #(set vim.o.spell (not vim.o.spell))]
                [:w #(set vim.o.wrap (not vim.o.wrap))]
                [:c #(set vim.o.cursorline (not vim.o.cursorline))]
                [:<Esc> nil {:exit true :desc false}]]})

hydra
