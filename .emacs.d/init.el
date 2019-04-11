(setq debug-on-error t)
(setq delete-old-versions -1 ); delete excess backup versions silently
(setq version-control t ); use version control
(setq vc-make-backup-files t ); make backups file even when in version controlled dir
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")) ) ; which directory to put backups file
(setq vc-follow-symlinks t ); don't ask for confirmation when opening symlinked file
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) ) ;transform backups file name
(setq inhibit-startup-screen t ); inhibit useless and old-school startup screen
(setq coding-system-for-write 'utf-8 )
(setq sentence-end-double-space nil); sentence SHOULD end with only a point.
(setq default-fill-column 80); toggle wrapping text at the 80th character
(setq initial-scratch-message "Welcome in Emacs") ; print a default message in the empty scratch buffer opened at startupa
(scroll-bar-mode 0)
(menu-bar-mode 0)
(tool-bar-mode 0)
(blink-cursor-mode 0)

(set-default 'indent-tabs-mode nil)
(setq css-indent-offset 2)
(setq visible-bell nil)
;; Make sure we always use UTF-8.
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(load-library "iso-transl")

(setq gc-cons-threshold 50000000) ;; allow for more allocated memory before triggering the gc
(setq line-number-display-limit-width 10000)
(setq gnutls-min-prime-bits 4096)
(setq uniquify-buffer-name-style 'forward)

(setq custom-file "~/.emacs.d/etc/custom.el")
(load custom-file)

(when (memq system-type '(darwin windows-nt))
  (setq ring-bell-function 'ignore))

(when (eq system-type 'darwin)
  (setq ns-use-srgb-colorspace nil
        ns-right-alternate-modifier nil))

;; Always ask for y/n keypress instead of typing out 'yes' or 'no'
(defalias 'yes-or-no-p 'y-or-n-p)

;; Automatically save buffers before launching M-x compile and friends,
;; instead of asking you if you want to save.
(setq compilation-ask-about-save nil)

;; Make the selection work like most people expect.
(delete-selection-mode t)
(transient-mark-mode t)

;; Automatically update unmodified buffers whose files have changed.
(global-auto-revert-mode 1)

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

(setq mouse-yank-at-point t)
(setq save-interprogram-paste-before-kill t)
(setq use-dialog-box nil)


(require 'package)
(setq package-enable-at-startup nil) ; tells emacs not to load any packages before starting up
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")))
(add-to-list 'package-archives
             '("tromey" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

;;(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)
;;(add-to-list 'package-pinned-packages '(magit . "melpa-stable") t)

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package) ; unless it is already installed
  (package-refresh-contents) ; updage packages archive
  (package-install 'use-package)) ; and install the most recent version of use-package

;; Define he following variables to remove the compile-log warnings
;; when defining ido-ubiquitous
;; (defvar ido-cur-item nil)
;; (defvar ido-default-item nil)
;; (defvar ido-cur-list nil)
;; (defvar predicate nil)
;; (defvar inherit-input-method nil)

;; Sane indentation default
(setq tab-width 2)
(setq js-indent-level 2)

;; The packages you want installed. You can also install these
;; manually with M-x package-install
;; Add in your own as you wish:
(defvar my-packages
  '(;; makes handling lisp expressions much, much easier
    ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
    paredit

    ;; key bindings and code colorization for Clojure
    ;; https://github.com/clojure-emacs/clojure-mode
    clojure-mode

    ;; extra syntax highlighting for clojure
    clojure-mode-extra-font-locking

    ;; integration with a Clojure REPL
    ;; https://github.com/clojure-emacs/cider
   ;; cider

    ;; allow ido usage in as many contexts as possible. see
    ;; customizations/navigation.el line 23 for a description
    ;; of ido
    ido-completing-read+

    ;; Enhances M-x to allow easier execution of commands. Provides
    ;; a filterable list of possible commands in the minibuffer
    ;; http://www.emacswiki.org/emacs/Smex
    smex

    ;; project navigation
    projectile

    ;; colorful parenthesis matching
    rainbow-delimiters

    ;; edit html tags like sexps
    tagedit

    ;; git integration
    magit))

;; On OS X, an Emacs instance started from the graphical user
;; interface will have a different environment than a shell in a
;; terminal window, because OS X does not run a shell during the
;; login. Obviously this will lead to unexpected results when
;; calling external utilities like make from Emacs.
;; This library works around this problem by copying important
;; environment variables from the user's shell.
;; https://github.com/purcell/exec-path-from-shell
(if (eq system-type 'darwin)
    (add-to-list 'my-packages 'exec-path-from-shell))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


(require 'use-package)

;; keybindings
(use-package general :ensure t
  :config
  (general-evil-setup)
  (setq general-default-keymaps 'evil-normal-state-map)
  ;; unbind space from dired map to allow for git status
  (general-define-key :keymaps 'dired-mode-map "SPC" nil)
  (general-define-key
   :keymaps 'visual
   "SPC ;"   'comment-or-uncomment-region)
  (general-define-key
   :keymaps 'normal
   "SPC b d" 'kill-this-buffer
   "SPC b b" 'switch-to-buffer
   "SPC f d" 'find-user-init-file
   "SPC f t" 'find-user-todo-file
   "SPC q"   'save-buffers-kill-terminal
   "SPC a d" 'dired
   "SPC TAB" 'switch-to-previous-buffer
   "C-+" 'text-scale-increase
   "C--" 'text-scale-decrease
   "C-=" '(lambda () (interactive) (text-scale-set 1))))

(defun find-user-init-file ()
  "Edit the `user-init-file', in another window."
  (interactive)
  (find-file-other-window user-init-file))

(defconst user-todo-file "~/Dropbox/org/todo.org")

(defun find-user-todo-file ()
  "Edit the `user-todo-file', in another window."
  (interactive)
  (find-file-other-window user-todo-file))

(defun switch-to-previous-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

;; cider
(use-package cider
  :ensure t)

;; evil
(use-package evil
  :ensure t
  :init
  (progn
    (setq evil-want-C-u-scroll t)
    (evil-mode 1)
    (evil-declare-change-repeat 'company-complete)))

(use-package evil-surround
  :ensure t
  :init
  (progn
    (global-evil-surround-mode 1)
    (evil-define-key 'visual evil-surround-mode-map "s" 'evil-surround-region)
    (evil-define-key 'visual evil-surround-mode-map "S" 'evil-substitute)))

;; escape on quick fd
(use-package evil-escape :ensure t
  :diminish evil-escape-mode
  :config
  (evil-escape-mode))

(use-package exec-path-from-shell
  :ensure t
  :config
  (setq exec-path-from-shell-check-startup-files nil)
  (unless (eq system-type 'windows-nt)
      (exec-path-from-shell-initialize)))

;; Ivy things
(use-package ivy
  :ensure t
  :diminish ivy-mode
  :demand t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-height 15)
  (setq ivy-count-format "(%d/%d) ")
  :general
  (general-define-key
   :keymaps 'ivy-minibuffer-map
   "C-j" 'ivy-next-line
   "C-k" 'ivy-previous-line))

(use-package counsel :ensure t
  :general
  (general-define-key
   :keymaps 'normal
   "SPC f f" 'counsel-find-file
   "SPC h f" 'counsel-describe-function
   "SPC u"   'counsel-unicode-char
   "SPC p f" 'counsel-git
   "SPC p s" 'counsel-rg
   "SPC SPC" 'counsel-M-x))

(use-package swiper :ensure t
  :general
  (general-define-key
   :keymaps 'normal
   "SPC s" 'swiper))

(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-load-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)

;; which-key
(use-package which-key :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode 1))

;; company
(use-package company
  :ensure t
  :diminish company-mode
  :config
  (global-company-mode)
  (setq company-idle-delay 0.25)
  :general
  (general-define-key
   :keymaps 'insert
   "C-SPC" 'company-complete)
  (general-define-key
   :keymaps 'company-active-map
   "<tab>" 'company-complete-selection
   "C-j" 'company-select-next
   "C-k" 'company-select-previous))

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode)
  :general
  (general-define-key
   :keymaps 'insert
   "C-M-SPC" 'yas-expand))

(use-package diminish
  :ensure t
  :config
  (diminish 'undo-tree-mode))
;; magit
(use-package magit :ensure t
  :general
  (general-define-key
   :keymaps 'normal
   "SPC g s" 'magit-status)
  :config
  (use-package evil-magit :ensure t)
  (setq magit-completing-read-function 'ivy-completing-read))

(use-package forge :ensure t)

;; Undo all themes
;; (mapcar #'disable-theme custom-enabled-themes)

(use-package doom-themes
  :ensure t
  :preface (defvar region-fg nil)
  :config
  (load-theme 'doom-dracula t)
  (set-face-attribute 'default nil :family "PragmataPro" :width 'normal)
  (set-face-attribute 'default nil :height 130))

(use-package powerline
  :ensure t
  :config
  (powerline-center-evil-theme))

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :init
  (progn
    (setq sp-message-width nil
          sp-show-pair-from-inside t
          sp-autoescape-string-quote nil
          sp-cancel-autoskip-on-backward-movement nil))
  :config
  (progn
    (sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)
    (sp-local-pair 'minibuffer-inactive-mode "`" nil :actions nil)
    (sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
    (sp-local-pair 'emacs-lisp-mode "`" nil :actions nil)
    (sp-local-pair 'lisp-interaction-mode "'" nil :actions nil)
    (sp-local-pair 'lisp-interaction-mode "`" nil :actions nil)

    (sp-local-pair 'LaTeX-mode "\"" nil :actions nil)
    (sp-local-pair 'LaTeX-mode "'" nil :actions nil)
    (sp-local-pair 'LaTeX-mode "`" nil :actions nil)
    (sp-local-pair 'latex-mode "\"" nil :actions nil)
    (sp-local-pair 'latex-mode "'" nil :actions nil)
    (sp-local-pair 'latex-mode "`" nil :actions nil)
    (sp-local-pair 'TeX-mode "\"" nil :actions nil)
    (sp-local-pair 'TeX-mode "'" nil :actions nil)
    (sp-local-pair 'TeX-mode "`" nil :actions nil)
    (sp-local-pair 'tex-mode "\"" nil :actions nil)
    (sp-local-pair 'tex-mode "'" nil :actions nil)
    (sp-local-pair 'tex-mode "`" nil :actions nil))
    (smartparens-global-mode)
    (show-smartparens-global-mode))

(use-package neotree
  :ensure t
  :general
  (general-define-key
   :keymaps 'normal
   "SPC f t" 'neotree-toggle))

(use-package restclient :ensure t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package rust-mode :ensure t)

(use-package cargo
  :ensure t
  :general
  (general-define-key :keymaps 'rust-mode-map
                      :states '(normal visual)
                      ", c b" 'cargo-process-build
                      ", c t" 'cargo-process-test
                      ", c r" 'cargo-process-run))

;; haskell
(use-package haskell-mode
  :ensure t
  :config
  (setq haskell-interactive-popup-error nil))

(use-package intero
  :ensure t
  :config
  (add-to-list 'intero-blacklist "~/.xmonad/")
  :general
  (general-define-key :keymaps 'intero-mode-map
                      :states '(normal visual)
                      ", i" 'intero-info
                      ", t" 'intero-type-at
                      ", l" 'intero-repl-load
                      ", c" 'intero-repl-clear-buffer
                      ", r" 'intero-restart
                      ", m t" 'intero-targets
                      ", g g" 'intero-goto-definition))

;; purescript
(use-package flycheck
  :ensure t
  :general
  (general-define-key
   :keymaps 'normal
   "SPC e n" 'flycheck-next-error
   "SPC e p" 'flycheck-previous-error))
(use-package purescript-mode
  :ensure t
  :diminish 'purescript-indentation-mode)

(use-package xah-math-input
  :load-path "~/.emacs.d/lisp"
  :general
  (general-define-key
   :keymaps 'insert
   "M-SPC" 'xah-math-input-change-to-symbol))

(defun kc/purescript-hook ()
  "My PureScript mode hook"
  (turn-on-purescript-indentation)
  (psc-ide-mode)
  (company-mode)
  (flycheck-mode)
  (setq-local flycheck-check-syntax-automatically '(mode-enabled save)))

(use-package psc-ide
  :ensure t
  ;; :load-path "~/code/psc-ide-emacs/"
  :init (add-hook 'purescript-mode-hook 'kc/purescript-hook)
  :config (setq psc-ide-editor-mode t)
  :general
  (general-define-key :keymaps 'purescript-mode-map
                      :states '(normal visual)
                      ", s" 'psc-ide-server-start
                      ", l" 'psc-ide-load-all
                      ", q" 'psc-ide-server-quit
                      ", t" 'psc-ide-show-type
                      ", b" 'psc-ide-rebuild
                      ", g g" 'psc-ide-goto-definition
                      ", a i" 'psc-ide-add-import))

(use-package tex-site
  :ensure auctex
  :mode ("\\.tex\\'" . TeX-latex-mode))

(use-package company-auctex
  :defer t
  :ensure t)

(use-package org-ref :ensure t)

(use-package org
  :mode (("\\.org$" . org-mode))
  :ensure org-plus-contrib
  :general
  (general-define-key :keymaps 'org-mode-map
                      :states '(normal visual)
                      "SPC m e" 'org-export-dispatch))

(use-package ethan-wspace
  :ensure t
  :diminish 'ethan-wspace-mode
  :init (setq mode-require-final-newline nil
              require-final-newline nil)
  :config (global-ethan-wspace-mode 1))

(use-package fill-column-indicator
  :ensure t
  :general
  (general-define-key
   :keymaps 'normal
   "SPC t f" 'fci-mode)
  :config
  (progn
    (defun kc/on-off-fci-before-company(command)
      (when (string= "show" command)
        (turn-off-fci-mode))
      (when (string= "hide" command)
        (turn-on-fci-mode)))
    (advice-add 'company-call-frontends :before #'kc/on-off-fci-before-company)))

;; Place downloaded elisp files in ~/.emacs.d/vendor. You'll then be able
;; to load them.
;;
;; For example, if you download yaml-mode.el to ~/.emacs.d/vendor,
;; then you can add the following code to this file:
;;
;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;;
;; Adding this code will make Emacs enter yaml mode whenever you open
;; a .yml file
(add-to-list 'load-path "~/.emacs.d/vendor")

;; Add a directory to our load path so that when you `load` things
;; below, Emacs knows where to look for the corresponding file.
(add-to-list 'load-path "~/.emacs.d/customizations")

;; Sets up exec-path-from-shell so that Emacs will use the correct
;; environment variables
(load "shell-integration.el")

;; These customizations make it easier for you to navigate files,
;; switch buffers, and choose options from the minibuffer.
(load "navigation.el")

;; These customizations change the way emacs looks and disable/enable
;; some user interface elements
;; (load "ui.el")

(add-to-list 'default-frame-alist
                       '(font . "DejaVu Sans Mono-12"))


(setq debug-on-error nil)
