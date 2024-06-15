(λ config []
  (local null-ls (require :null-ls))
  (null-ls.setup {:autostart true
                  :sources [;; Formatting
                            null-ls.builtins.formatting.gofmt
                            null-ls.builtins.formatting.stylua
                            null-ls.builtins.formatting.fnlfmt
                            null-ls.builtins.formatting.prettier
                            (require "none-ls.formatting.rustfmt")
                            (require "none-ls.formatting.trim_newlines")

                            ;; Code Actions
                            (require "none-ls.code_actions.eslint")
                            null-ls.builtins.code_actions.gitsigns

                            ;; Diagnostics
                            (require "none-ls.diagnostics.eslint")
                            (require "none-ls.diagnostics.flake8")]}))

(local lazy-spec [{1 "nvimtools/none-ls.nvim"
                   : config
                   :dependencies ["nvimtools/none-ls-extras.nvim"]
                   :event [:BufReadPre :BufNewFile]}])

lazy-spec
