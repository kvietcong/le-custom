(λ config []
  (local mason (require :mason))
  (local mason-lspconfig (require :mason-lspconfig))
  (mason.setup)
  (mason-lspconfig.setup {:ensure_installed lsp-servers}))

(local lazy-spec [{1 "williamboman/mason.nvim"
                   : config
                   :dependencies ["williamboman/mason-lspconfig.nvim"]}])

lazy-spec
