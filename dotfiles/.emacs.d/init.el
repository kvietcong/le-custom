;; Package Manager Setup
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "04:00"))

;; Evil stuff
(use-package undo-fu)
(use-package evil
  :init
  (setq evil-cross-lines t)
  ;; (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-d-scroll nil)
  (setq evil-want-C-w-delete nil)
  (setq evil-want-Y-yank-to-eol t)
  (setq evil-undo-system 'undo-fu)
  (setq evil-vsplit-window-right t)
  (setq evil-vsplit-window-below t)
  (setq evil-respect-visual-line-mode t)
  :config
  (evil-mode t)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  ;; Find out why I need lambda interactive pattern. Why not just quote?
  (evil-define-key '(normal visual) 'global "J"
    (lambda () (interactive) (evil-next-visual-line 6)))
  (evil-define-key '(normal visual) 'global "K"
    (lambda () (interactive) (evil-previous-visual-line 6)))
  (evil-define-key '(normal visual) 'global "L" 'evil-end-of-visual-line)
  (evil-define-key '(normal visual) 'global "H" 'evil-first-non-blank-of-visual-line)

  (evil-define-key 'normal 'global "U" 'evil-redo)
  (evil-define-key 'normal 'global (kbd "C-j") 'evil-join)

  (evil-define-key 'normal 'global "gj" 'evil-window-down)
  (evil-define-key 'normal 'global "gk" 'evil-window-up)
  (evil-define-key 'normal 'global "gl" 'evil-window-right)
  (evil-define-key 'normal 'global "gh" 'evil-window-left)

  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package all-the-icons)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode t))

;; Miscellaneous
(recentf-mode t) ; Recent files
(tooltip-mode -1) ; Disable tooltips
(tool-bar-mode -1) ; Disable the toolbar
(menu-bar-mode -1) ; Disable the menu bar
(set-fringe-mode 3) ; Give some breathing room
(scroll-bar-mode -1) ; Disable visible scrollbar
(column-number-mode) ; Show column number in modeline
(setq visible-bell t)
(setq case-fold-search nil) ; Enable case sensitivity (Why is this not default lol)
(setq inhibit-startup-message t)
(global-display-line-numbers-mode t) ; Line numbers
(setq display-line-numbers-type 'visual) ; Set to relative line numbers
(global-set-key (kbd "<Escape>") 'keyboard-escape-quit) ; Make Escape quit prompts
(set-frame-parameter (selected-frame) 'alpha '(98 . 92)) ; Transparency YEET
(add-to-list 'default-frame-alist '(alpha . (98 . 92)))
(set-face-attribute 'default nil :font "CodeNewRoman NF" :height 118) ; Default Font
(set-face-attribute 'fixed-pitch nil :font "CodeNewRoman NF" :height 118) ; Mono Font
(set-face-attribute 'variable-pitch nil :font "Arial" :height 118 :weight 'regular) ; Variable Font

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 0))

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-nord t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
