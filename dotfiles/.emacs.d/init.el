;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)

;; Set Colorscheme
(unless (package-installed-p 'nord-theme)
  (package-install 'nord-theme))
(load-theme 'nord t)

;; Evil stuff
(setq evil-want-C-d-scroll nil)
(setq evil-want-C-w-delete nil)
(setq evil-want-Y-yank-to-eol t)
(setq evil-vsplit-window-right t)
(setq evil-vsplit-window-below t)
(setq evil-respect-visual-line-mode t)
(unless (package-installed-p 'evil)
  (package-install 'evil))
(require 'evil)
(evil-mode 1)
(evil-define-key 'normal 'global "j" "gj")
(evil-define-key 'normal 'global "k" "gk")
(evil-define-key 'normal 'global "J" "10gj")
(evil-define-key 'normal 'global "K" "10gk")
(evil-define-key 'normal 'global "H" "g^")
(evil-define-key 'normal 'global "L" "g$")

;; Miscellaneous
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
