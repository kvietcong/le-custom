;; Fancy Notifications
(local notify (require :notify))

(notify.setup {:stages :slide :timeout 3000})

(set vim.notify notify)

notify
