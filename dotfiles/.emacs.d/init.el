;; Auto-Generated from Emacs.org

(require 'server)
(unless (server-running-p) (server-start))
(add-hook
 'emacs-startup-hook
 (lambda ()
   (message
    "*** Emacs loaded in %s with %d garbage collections."
    (format "%.2f seconds"
            (float-time
             (time-subtract after-init-time before-init-time)))
    gcs-done)))

(defun le/shutdown ()
  "Save Buffers, Quit, and Shutdown (Kill) Server"
  (interactive) (save-some-buffers) (kill-emacs))

(defvar le/fixed-font-size 118)
(defvar le/variable-font-size 110)
(defvar le/themes ; Day/Night Theme
  (list 'doom-gruvbox-light 'doom-nord))
(defvar le/leader "<SPC>")
(defvar le/world-times
  '(("America/Los_Angeles" "Seattle")
    ("Asia/Ho-Chi-Minh" "Saigon")
    ("Asia/Tokyo" "Tokyo")
    ("Asia/Seoul" "Seoul")
    ("America/New_York" "New York")))
(defvar le/fixed-font "CodeNewRoman NF")
(defvar le/variable-font "Merriweather")
(defvar le/backup-directory (concat user-emacs-directory "backups"))
(defvar le/window-width 100)

(when (eq system-type 'windows-nt)
  (message "IT'S WINDOWS")
  (setenv "HOME" (getenv "UserProfile"))
  (set-default-coding-systems 'utf-8)
  (setq le/world-times
        '(("PST8PDT" "Seattle, Washington")
          ("UTC-7" "Saigon, Vietnam")
          ("JST-9" "Tokyo")
          ("KST" "Seoul, Korea")
          ("EST5EDT" "New York, US")))
  (setq explicit-shell-file-name "powershell.exe"))

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
;; (setq use-package-verbose t) ; For debugging

(use-package auto-package-update :custom
  (auto-package-update-interval 4)
  (auto-package-update-hide-results t)
  (auto-package-update-prompt-before-update t))

(cd "~") ; Start in Home Directory
(recentf-mode t) ; Save recent files
(savehist-mode t) ; Save minibuffer histories
(save-place-mode t) ; Save file cursor placement
(setq select-enable-clipboard nil) ; Find out why evil auto-pastes into clipboard
(setq-default indent-tabs-mode nil) ; Tabs to Spaces
(setq-default delete-by-moving-to-trash t)
(global-set-key (kbd "<Escape>") 'keyboard-quit) ; Universal Keybinds
(global-set-key (kbd "C-M-u") 'universal-argument)
(global-set-key (kbd "<Escape>") 'keyboard-escape-quit)
(add-to-list 'default-frame-alist '(alpha . (96 . 92))) ; Transparency YEET
(set-frame-parameter (selected-frame) 'alpha '(96 . 92))

(tooltip-mode -1) ; Disable tooltips
(tool-bar-mode -1) ; Disable the toolbar
(menu-bar-mode -1) ; Disable the menu bar
(scroll-bar-mode -1) ; Disable visible scrollbar
(column-number-mode) ; Show column number in modeline
(setq visible-bell t)
(setq scroll-margin 5) ; Have bottom padding in terms of lines
(setq-default word-wrap t)
(setq image-transform-resize t)
(setq inhibit-startup-message t)
(setq-default display-fill-column-indicator-column 81) ; Set column border
(add-hook 'prog-mode-hook 'display-fill-column-indicator-mode)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)

(setq-default display-line-numbers-type 'visual ; Set to relative line numbers
              display-line-numbers-width 5)
(global-display-line-numbers-mode t) ; Enable line numbers

;; Disable for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq mouse-wheel-scroll-amount '(2 ((shift) . nil))
      mouse-wheel-progressive-speed nil
      scroll-conservatively 1000000000000000
      scroll-step 1
      auto-window-vscroll nil
      scroll-preserve-screen-position 1
      mouse-wheel-follow-mouse 't)

(defun le/set-fonts ()
  "Set fonts for graphical client"
  (set-face-attribute
   'default nil :font le/fixed-font :height le/fixed-font-size)
  (set-face-attribute
   'fixed-pitch nil :font le/fixed-font :height le/fixed-font-size)
  (set-face-attribute
   'variable-pitch nil :font le/variable-font :height le/variable-font-size))

(if (daemonp)
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                (setq doom-modeline-icon t)
                (with-selected-frame frame (le/set-fonts))))
  (le/set-fonts))

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
      `((".*" ,le/backup-directory t))
      auto-mode-alist
      (append (list '("\\.\\(vcf\\|gpg\\)$" . sensitive-minor-mode))
              auto-mode-alist))

(setq display-time-world-list le/world-times)
(setq display-time-world-time-format "%A, %d %B %H:%M")

(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.25
        which-key-popup-type 'side-window
        which-key-side-window-location 'bottom))

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

  ;; Find out how to make this work
  ;; Find out why I need lambda interactive pattern. Why not just quote?
  ;; (evil-define-key '(normal motion) 'global "n"
  ;;   (lambda () (interactive)
  ;;     (evil-search-next) (evil-scroll-line-to-center)))

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

;; I feel like with how many mappings there are, I'll need this someday
(defun le/nth-leader (n &optional after)
  "Repeat Leader n times"
  (let ((result ""))
    (dotimes (_ n) (setq result (concat result le/leader)))
    (concat result after)))

(use-package general
  :config
  (general-create-definer le/leader-maps
    :keymaps '(normal insert visual emacs)
    :prefix le/leader
    :global-prefix (concat "M-" le/leader))
  ;; Thank God for this
  ;; https://github.com/emacs-evil/evil-magit/issues/14#issuecomment-626583736
  (general-define-key
   :keymaps 'transient-base-map
   "<escape>" 'transient-quit-one) ;; Allow exiting transient menus in Magit

  (le/leader-maps
    "=" 'zoom
    "z" '(writeroom-mode :which-key "Zen Mode")
    "tt" '(consult-theme :which-key "Choose Theme")
    "gg" '(magit :which-key "Magit")
    "/" '(consult-line :which-key "Fuzzy Find in Buffer")

    "b"  '(:ignore t :which-key "Buffer ...")
    "bk" '(kill-this-buffer :which-key "Kill This Buffer")
    "bK" '(kill-buffer :which-key "Kill Some Buffer")

    "f"  '(:ignore t :which-key "Find ...")
    "fb" '(consult-buffer :which-key "Find Buffers")
    "fe" '(treemacs :which-key "File Tree")
    "fE" '(dired-jump :which-key "File Explorer")
    "ff" '(project-find-file :which-key "Find File in Project")
    "fg" '(consult-ripgrep :which-key "Grep Project")
    "fr" '(consult-recent-file :which-key "Find Recent Files")

    "x"  '(:ignore t :which-key "Execute ...")
    "xr" '(eval-region :which-key "Execute Region")
    "xb" '(eval-buffer :which-key "Execute Buffer")
    "xe" '(eval-last-sexp :which-key "Execute Expression")

    "o"  '(:ignore t :which-key "Organization ...")
    "oo" '(consult-outline :which-key "Outline")
    "ol" '(org-latex-preview :which-key "LaTeX Preview")
    "op" '(org-toggle-pretty-entities :which-key "Pretty Entities")
    "ox" '(org-execute-src-block :which-key "Execute Source Block")
    "oX" '(org-execute-buffer :which-key "Execute Buffer")

    "w" (general-simulate-key "C-w")
    "h" (general-simulate-key "C-h")
    "pp" '(projectile-command-map :which-key "Projectile")
    (le/nth-leader 2) (general-simulate-key "M-x")))

(use-package vertico :custom (vertico-cycle t) :init (vertico-mode))
(use-package emacs
  :init
  (defun crm-indicator (args)
    (cons (concat "[CRM] " (car args)) (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
  (setq enable-recursive-minibuffers t))

(use-package marginalia :after vertico :init (marginalia-mode))

(use-package orderless :init
  (defun le/flex-style (pattern _index _total)
    "Flexible (Fuzzy) search dispatcher (completion mode)"
    (when (string-suffix-p "~" pattern)
      `(orderless-flex . ,(substring pattern 0 -1))))
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        orderless-style-dispatchers '(le/flex-style)
        completion-category-overrides '((file (styles partial-completion)))))

(use-package company :hook (lsp-mode . company-mode)
  :custom (company-minimum-prefix-length 2) (company-idle-delay 0.25))
(use-package company-box :hook (company-mode . company-box-mode))

(defun le/org-mode-setup ()
  (setq org-preview-latex-image-directory (concat user-emacs-directory ".cache/"))
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(defun le/org-font-setup ()
  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 2.00)
                  (org-level-2 . 1.75)
                  (org-level-3 . 1.50)
                  (org-level-4 . 1.40)
                  (org-level-5 . 1.30)
                  (org-level-6 . 1.20)
                  (org-level-7 . 1.15)
                  (org-level-8 . 1.10)))
    (set-face-attribute
     (car face) nil
     :font (concat le/variable-font " black") :weight 'bold :height (cdr face)))

  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org :hook (org-mode . le/org-mode-setup)
  :config
  (general-define-key :states '(normal) :keymaps 'org-mode-map "gk" nil)
  (general-define-key :states '(normal) :keymaps 'org-mode-map "gj" nil)
  (setq-default org-ellipsis " ++"
                org-hide-leading-stars nil
                org-hide-block-startup t
                org-todo-keywords
                '((sequence "TODO(t)" "FIX(f)" "URGENT(u)" "NOTE(n)"
                            "WARN(w)" "|" "DONE(d!)")))
  (le/org-font-setup))

(use-package org-bullets :after org :hook (org-mode . org-bullets-mode)
  :custom (org-bullets-bullet-list '("◎" "○" "●" "○" "●" "○" "●")))

(defun le/org-mode-visual-fill ()
  (setq visual-fill-column-width le/window-width
        visual-fill-column-center-text t)
  (visual-fill-column-mode t))
(use-package visual-fill-column :hook (org-mode . le/org-mode-visual-fill))

(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("hs" . "src haskell"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("lua" . "src lua"))
(add-to-list 'org-structure-template-alist '("js" . "src js"))
(add-to-list 'org-structure-template-alist '("sh" . "src sh"))
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t) (haskell . t) (lua . t) (sql . t) (js . t)
   (java . t) (latex . t) (C . t) (python . t)))

(defun le/tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "./Emacs.org"))
    (let ((org-confirm-babel-evaluate nil))
      (message "Tangling Configuration")
      (org-babel-tangle))))
(add-hook 'org-mode-hook
          (lambda () (add-hook 'after-save-hook #'le/tangle-config)))

(use-package lsp-mode
  :commands lsp
  :hook ((lsp-mode . lsp-enable-which-key-integration)))
(use-package lsp-ui :hook (lsp-mode . lsp-ui-mode))

(use-package haskell-mode :defer t)
(use-package lsp-haskell :hook (haskell-mode . lsp))

(use-package lsp-pyright :defer t)

;; Markdown
(use-package markdown-mode
  :mode "\\.md\\'"
  :config
  (setq markdown-command "multimarkdown")
  (defun le/set-markdown-header-font-sizes ()
    (dolist (face '((markdown-header-face-1 . 2.5)
                    (markdown-header-face-2 . 2.0)
                    (markdown-header-face-3 . 1.5)
                    (markdown-header-face-4 . 1.2)
                    (markdown-header-face-5 . 1.1)))
      (set-face-attribute (car face) nil :weight 'normal :height (cdr face))))
  (defun le/markdown-mode-hook ()
    (le/set-markdown-header-font-sizes))
  (add-hook 'markdown-mode-hook 'le/markdown-mode-hook))

;; Git Interface
(use-package magit :commands (magit magit-status))

;; Git Gutter
(use-package diff-hl :hook (prog-mode . diff-hl-mode))

;; White Space Trimmer
(use-package ws-butler :config (ws-butler-global-mode t))

;; Temporary Keybinds (Need to do more with this)
(use-package hydra :defer t)
(defhydra hydra-text-scale (:timeout 3) "Scale Text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))
(le/leader-maps "ts"
  '(hydra-text-scale/body :which-key "Scale Text"))

;; File Explorer
(use-package dired :ensure nil ;; Built in
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))
(use-package dired-single :after dired)
(use-package all-the-icons-dired :after dired
  :hook (dired-mode . all-the-icons-dired-mode))

;; Give Extra Help
(use-package helpful :defer t :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-command] . helpful-command)
  ([remap describe-key] . helpful-key))

;; Project Stuff
(use-package projectile :defer 0
  :diminish projectile-mode :config (projectile-mode)
  :init
  (when (file-directory-p "~/Documents/Projects")
    (setq projectile-project-search-path '("~/Documents/Projects")))
  (setq projectile-switch-project-action #'projectile-dired))

;; Some rich actions
(use-package consult :defer 0
  :config
  (autoload 'projectile-project-root "projectile")
  (setq consult-project-root-function #'projectile-project-root))

;; Icons to allow cool UI
(use-package all-the-icons
  :config
  ;; Make sure the icon fonts are good to go
  (set-fontset-font t 'unicode (font-spec :family "all-the-icons") nil 'append)
  (set-fontset-font t 'unicode (font-spec :family "file-icons") nil 'append)
  (set-fontset-font t 'unicode (font-spec :family "Material Icons") nil 'append)
  (set-fontset-font t 'unicode (font-spec :family "github-octicons") nil 'append)
  (set-fontset-font t 'unicode (font-spec :family "FontAwesome") nil 'append)
  (set-fontset-font t 'unicode (font-spec :family "Weather Icons") nil 'append))

;; Zen Mode
(use-package writeroom-mode :commands writeroom-mode
  :config
  (setq writeroom-width le/window-width
        writeroom-mode-line t
        writeroom-header-line t
        writeroom-added-width-left (- 0 (writeroom-full-line-number-width) -1)
        writeroom-restore-window-config t
        writeroom-global-effects '(writeroom-set-fullscreen)))

;; Focusing Windows
(use-package zoom :commands zoom
  :config (custom-set-variables '(zoom-size '(0.618 . 0.618))))

;; Colored Parenthesis
(use-package rainbow-delimiters :hook (prog-mode . rainbow-delimiters-mode))

;; File Tree
(use-package treemacs :commands treemacs)
(use-package lsp-treemacs :after (treemacs lsp))
(use-package treemacs-evil :after (treemacs evil))
(use-package treemacs-magit :after (treemacs magit))

;; Cool Mode Line
(use-package doom-modeline :init (doom-modeline-mode t))
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  ;; Setting theme based on time
  (let* ((time-info (decode-time))
         (time (+ (nth 2 time-info) (/ (nth 1 time-info) 100.0))))
    (if (or (>= time 17.30) (<= time 8.30))
        (load-theme (nth 1 le/themes) t)
      (load-theme (nth 0 le/themes) t)))
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

;; Emojis lol
(use-package emojify
  :hook (after-init . global-emojify-mode)
  :config (emojify-set-emoji-styles (list 'unicode 'github)))

;; Highlight indent levels
(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (highlight-indent-guides-mode t)
  :custom
  (highlight-indent-guides-method 'character)
  (highlight-indent-guides-responsive 'top)
  (highlight-indent-guides-auto-character-face-perc 15))

;; Tab Bar
(use-package centaur-tabs
  :config
  (setq centaur-tabs-style "rounded"
        centaur-tabs-height 28
        centaur-tabs-set-icons t
        centaur-tabs-cycle-scope 'tabs
        centaur-tabs-modified-marker "•"
        centaur-tabs-set-modified-marker t
        centaur-tabs-set-bar 'left)
  (centaur-tabs-mode t)
  :hook
  (dashboard-mode . centaur-tabs-local-mode)
  (term-mode . centaur-tabs-local-mode)
  (calendar-mode . centaur-tabs-local-mode)
  (org-agenda-mode . centaur-tabs-local-mode)
  (helpful-mode . centaur-tabs-local-mode)
  :bind
  ("M-h" . centaur-tabs-backward)
  ("M-l" . centaur-tabs-forward))

;; Cool Dashboard
(use-package dashboard
  :config
  (setq dashboard-set-init-info t
        dashboard-set-file-icons t
        dashboard-center-content t
        dashboard-set-heading-icons t
        dashboard-startup-banner (expand-file-name "~/.emacs.d/dash-logo.png")
        initial-buffer-choice (lambda () (get-buffer "*dashboard*"))
        dashboard-banner-logo-title "Welcome to Le Emacs 🚀"
        dashboard-set-navigator t
        dashboard-items '((agenda . 5) (bookmarks . 5)
                          (projects . 5) (recents  . 5))
        dashboard-navigator-buttons
        `(((,(all-the-icons-octicon "mark-github" :height 1.0 :v-adjust 0.0)
            "GitHub" "GitHub Profile"
            (lambda (&rest _) (browse-url "https://github.com/kvietcong")))
           (,(all-the-icons-faicon "linkedin" :height 1.0 :v-adjust 0.0)
            "LinkedIn" "LinkedIn Profile"
            (lambda (&rest _)
              (browse-url "https://www.linkedin.com/in/kvietcongle")))
           (,(all-the-icons-faicon "reddit-alien" :height 1.0 :v-adjust 0.0)
            "Reddit" "Reddit Home Page"
            (lambda (&rest _) (browse-url "https://www.reddit.com/")))
           (,(all-the-icons-faicon "youtube-play" :height 1.0 :v-adjust 0.0)
            "YouTube" "YouTube Home Page"
            (lambda (&rest _) (browse-url "https://www.youtube.com/"))))))
  (dashboard-setup-startup-hook)
  :hook ((after-init . dashboard-refresh-buffer)))

;; Highlight large cursor movememnts
(use-package beacon
  :init (beacon-mode 1)
  :config (setq beacon-blink-when-point-moves-vertically 5
                beacon-blink-when-window-scrolls nil
                beacon-blink-when-focused t))
