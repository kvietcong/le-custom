;; Git Porcelain for Neovim
(local neogit (require :neogit))
(local which-key (require :le.which-key))

(neogit.setup {:kind :vsplit
               :disable_commit_confirmation true
               :mappings {:status {:<Escape> :Close}}})

(which-key.register {:<Leader>gg [":Neogit<Enter>" "(g)it Neo(g)it menu"]})

neogit
