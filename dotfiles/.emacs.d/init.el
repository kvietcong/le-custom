;; Just Windows Things 😔
(when (eq system-type 'windows-nt)
  (message "IT'S WINDOWS")
  (setenv "HOME" (getenv "UserProfile")) ; Just to make sure
  (setq explicit-shell-file-name "powershell.exe"))

;; My Variables
(defvar le/fixed-font-size 118)
(defvar le/variable-font-size 118)
(defvar le/transparency '(96 . 92))
(defvar le/themes ; Day/Night Theme
  (list 'doom-gruvbox-light 'doom-nord))
(defvar le/leader "<SPC>")

;; General Settings
(recentf-mode t) ; Recent files
(savehist-mode t) ; Saves minibuffer histories
(save-place-mode t) ; Save your place
(setq case-fold-search nil) ; Enable case sensitivity (Why is this not default lol)
(global-display-line-numbers-mode t) ; Line numbers
(setq display-line-numbers-type 'visual) ; Set to relative line numbers

(tooltip-mode -1) ; Disable tooltips
(tool-bar-mode -1) ; Disable the toolbar
(menu-bar-mode -1) ; Disable the menu bar
(set-fringe-mode 3) ; Give some breathing room
(scroll-bar-mode -1) ; Disable visible scrollbar
(column-number-mode) ; Show column number in modeline
(setq visible-bell t)
(setq inhibit-startup-message t)

(setq select-enable-clipboard nil) ; Don't use system clipboard! (Registers pog)
(setq delete-by-moving-to-trash t)
(setq gc-cons-threshold (* 2 1000 1000))
(global-set-key (kbd "<Escape>") 'keyboard-escape-quit) ; Make Escape quit prompts
(set-frame-parameter (selected-frame) 'alpha le/transparency) ; Transparency YEET
(add-to-list 'default-frame-alist '(alpha . ,le/transparency))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized) ; Maximize window
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(set-face-attribute
 'default nil :font "CodeNewRoman NF" :height le/fixed-font-size)
(set-face-attribute
 'fixed-pitch nil :font "CodeNewRoman NF" :height le/fixed-font-size)
(set-face-attribute
 'variable-pitch nil
 :font "Arial" :height le/variable-font-size :weight 'regular)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		treemacs-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Better Backup Behavior
(defvar le/backup-directory (concat user-emacs-directory "backups"))
(if (not (file-directory-p le/backup-directory))
    (make-directory le/backup-directory t))
(setq version-control t
      make-backup-files t
      backup-by-copying t
      kept-old-versions 6
      kept-new-versions 9
      auto-save-default t
      auto-save-timeout 20
      delete-old-versions t
      vc-make-backup-files t
      auto-save-interval 200
      backup-directory-alist
      `((".*" . ,le/backup-directory))
      auto-save-file-name-transforms
          `((".*" ,le/backup-directory t)))
(setq auto-mode-alist
      (append (list '("\\.\\(vcf\\|gpg\\)$" . sensitive-minor-mode))
	      auto-mode-alist))

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
  (auto-package-update-at-time "13:00"))

;; Evil stuff
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
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  ;; TODO: Make join lines not go crazy
  ;; (evil-define-key 'normal 'global "J"
  ;;   (lambda () (interactive) (evil-next-visual-line 6)))
  (evil-define-key 'motion 'global "L" 'evil-last-non-blank)
  (evil-define-key 'motion 'global "H" 'evil-first-non-blank-of-visual-line)

  (evil-define-key 'normal 'global "U" 'evil-redo)
  (evil-define-key 'normal 'global "gk" 'evil-window-up)
  (evil-define-key 'normal 'global "gj" 'evil-window-down)
  (evil-define-key 'normal 'global "gh" 'evil-window-left)
  (evil-define-key 'normal 'global "gl" 'evil-window-right)

  ; Why does yank not go for system clipboard?
  (evil-define-key 'insert 'global (kbd "C-v") 'clipboard-yank)
  (evil-define-key '(visual insert) 'global (kbd "C-c") 'clipboard-kill-ring-save)

  ;; Find out how to make this work
  ;; Find out why I need lambda interactive pattern. Why not just quote?
  ;; (evil-define-key '(normal motion) 'global "n"
  ;;   (lambda () (interactive)
  ;;     (progn (evil-search-next) (evil-scroll-line-to-center))))
  ;; (evil-define-key '(normal motion) 'global "N"
  ;;   (lambda () (interactive)
  ;;     (progn (evil-search-previous) (evil-scroll-line-to-center))))

  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-commentary :after evil
  :config (evil-commentary-mode))

(use-package evil-collection :after evil
  :config (evil-collection-init))

(use-package evil-surround :after evil
  :config (global-evil-surround-mode t))

(use-package org-evil :after evil)

(use-package evil-snipe :after evil
  :config (evil-snipe-mode t) (evil-snipe-override-mode t)
  (setq evil-snipe-scope 'buffer))

;; Leader Stuff
(defun le/nth-leader (n &optional after)
  (let ((result ""))
    (dotimes (_ n) (setq result (concat result le/leader)))
    (concat result after)))

(use-package general :after evil
  :config
  (general-create-definer le/leader-maps
    :keymaps '(normal insert visual emacs)
    :prefix le/leader
    :global-prefix (concat "M-" le/leader))

  (le/leader-maps
    "tc" '(consult-theme :which-key "Choose Theme")
    "fb" '(consult-buffer :which-key "Find Buffers")
    "fr" '(recentf-open-files :which-key "Find Recent Files")
    "fg" 'consult-ripgrep
    "/" 'consult-line
    "ecfg" '(lambda () (interactive)
	      (find-file (expand-file-name "~/.emacs.d/init.el")))
    (le/nth-leader 2) (general-simulate-key "M-x")))

;; Other Packages
(use-package hydra :defer t)
(defhydra hydra-text-scale (:timeout 3) "Scale Text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))
(le/leader-maps "ts"
  '(hydra-text-scale/body :which-key "Scale Text"))

(use-package magit
  :commands magit-status
  :custom (magit-display-buffer-function
	   #'magit-display-buffer-same-window-except-diff-v1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :defer 0 :diminish which-key-mode
  :config (setq which-key-idle-delay 0))

(use-package all-the-icons)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode t))
(list (nth 2 (decode-time)) (nth 1 (decode-time)))
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (let ((hour (nth 2 (decode-time))))
       (if (or (>= hour 18) (<= hour 9)) ; Dark theme 6PM-9PM
		(load-theme (nth 1 le/themes) t)
		(load-theme (nth 0 le/themes) t)))
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(use-package orderless :custom (completion-styles '(orderless)))

(use-package vertico
  :custom (vertico-cycle t)
  :init (vertico-mode))

(use-package savehist :init (savehist-mode))

(use-package marginalia :after vertico
  :init (marginalia-mode))

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("<help> a" . consult-apropos)
         ("M-g o" . consult-outline)
         ("M-s r" . consult-ripgrep)))

(use-package embark
  :bind (("C-." . embark-act)
	 ("C-h B" . embark-bindings))
  :init (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :after (embark consult) :demand t
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))
(use-package dired-single :commands (dired dired-jump))
(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package emojify
  :hook (after-init . global-emojify-mode))

(cd "~")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(emojify all-the-icons-dired dired-single hydra which-key-posframe vertico use-package undo-fu rainbow-delimiters org-evil orderless nord-theme marginalia general flycheck evil-surround evil-snipe evil-commentary evil-collection embark-consult doom-themes doom-modeline auto-package-update)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
