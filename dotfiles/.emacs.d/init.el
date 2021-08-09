(use-package undo-fu)
(use-package evil
  :init
  (setq evil-cross-lines t)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-d-scroll t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-w-delete nil)
  (setq evil-want-Y-yank-to-eol t)
  (setq evil-undo-system 'undo-fu)
  (setq evil-vsplit-window-right t)
  (setq evil-vsplit-window-below t)
  (setq evil-respect-visual-line-mode t)
  :config
  (evil-mode t)
  (evil-define-key 'normal 'global "U" 'evil-redo)
  (evil-define-key 'motion 'global "j" 'evil-next-visual-line)
  (evil-define-key 'motion 'global "k" 'evil-previous-visual-line)
  (evil-define-key 'motion 'global "L" 'evil-last-non-blank)
  (evil-define-key 'motion 'global "H" 'evil-first-non-blank-of-visual-line)

  (evil-define-key 'normal 'global "gk" 'evil-window-up)
  (evil-define-key 'normal 'global "gj" 'evil-window-down)
  (evil-define-key 'normal 'global "gh" 'evil-window-left)
  (evil-define-key 'normal 'global "gl" 'evil-window-right)

  ;; Why does yank not go for system clipboard?
  (evil-define-key 'insert 'global (kbd "C-v") 'clipboard-yank)
  (evil-define-key 'visual 'global (kbd "C-c") 'clipboard-kill-ring-save)

  (evil-define-command evil-search-next-and-scroll-to-center (count)
    "Goes to the next search and centers the screen on the cursor"
    (interactive "<c>")
    (progn (evil-search-next) (evil-scroll-line-to-center count)))
  (evil-define-command evil-search-prev-and-scroll-to-center (count)
    "Goes to the prev search and centers the screen on the cursor"
    (interactive "<c>")
    (progn (evil-search-previous) (evil-scroll-line-to-center count)))
  (evil-define-key '(normal motion) 'global "n" 'evil-search-next-and-scroll-to-center)
  (evil-define-key '(normal motion) 'global "N" 'evil-search-prev-and-scroll-to-center)

  (evil-ex-define-cmd "kill-everything" 'le/shutdown)
  (evil-ex-define-cmd ":" 'execute-extended-command)
  (evil-ex-define-cmd ";" 'execute-extended-command)
  (evil-ex-define-cmd "hv" 'helpful-variable)
  (evil-ex-define-cmd "hf" 'helpful-function)
  (evil-ex-define-cmd "hs" 'helpful-symbol)
  (evil-ex-define-cmd "hk" 'helpful-key)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (evil-set-initial-state 'messages-buffer-mode 'normal))
(use-package evil-commentary :after evil :config (evil-commentary-mode))
(use-package evil-surround :after evil :config (global-evil-surround-mode t))
(use-package evil-collection :after evil
  :config
  (setq evil-collection-magit-want-horizontal-movement t)
  (evil-collection-init))
(use-package evil-snipe :after evil
  :config (evil-snipe-mode +1) (evil-snipe-override-mode +1)
  (setq evil-snipe-scope 'visible
        evil-snipe-show-prompt nil))
