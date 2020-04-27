(setq debug-on-error t)
(setq gc-cons-threshold 20000000)

;; Do not show the startup screen.
(setq inhibit-startup-message t)

;; Disable tool bar, menu bar, scroll bar.
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)


;; Use `command` as `meta` in macOS.
(setq mac-command-modifier 'meta)


(load-file "~/.emacs.d/downloads/sensible-defaults.el")
(sensible-defaults/use-all-settings)
(sensible-defaults/use-all-keybindings)


;; Packages

(require 'package)
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)


(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))


(setq custom-file "~/.emacs.d/custom-file.el")
(load-file custom-file)

;; Tabs
(setq-default tab-width 2)
(setq-default tab-width 2 indent-tabs-mode nil)
(setq-default indent-tabs-mode nil)

(setq js-indent-level 2)

(setq coffee-tab-width 2)

(setq python-indent 2)

(setq css-indent-offset 2)

(add-hook 'sh-mode-hook
          (lambda ()
            (setq sh-basic-offset 2
                  sh-indentation 2)))

(setq web-mode-markup-indent-offset 2)

;; Syntax Checking
(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode)
  (package-install 'exec-path-from-shell)
  (exec-path-from-shell-initialize))


;; navegations

(global-set-key (kbd "C->") 'end-of-buffer)
(global-set-key (kbd "C-<") 'beginning-of-buffer)
(global-set-key (kbd "C-M-=") 'zoom-frm-in)
(global-set-key (kbd "C-M--") 'zoom-frm-out)

;; Theme

(use-package solarized-theme
  :ensure t
  :config
  (load-theme 'solarized-dark t)
  (setq sml/theme 'dark))

(use-package smart-mode-line
  :ensure t
  )


;; autocomplete

(use-package auto-complete
  :ensure t)

;; Company
(global-company-mode t)


(use-package company
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0.3)
  (global-company-mode t))


;; Recent buffers in a new Emacs session
(use-package recentf
  :config
  (setq recentf-auto-cleanup 'never
        recentf-max-saved-items 1000
        recentf-save-file (concat user-emacs-directory ".recentf"))
  (recentf-mode t)
  :diminish nil)


;; Enhance M-x to allow easier execution of commands
(use-package smex
  :ensure t
  :config
  (setq smex-save-file (concat user-emacs-directory ".smex-items"))
  (smex-initialize)
  :bind ("M-x" . smex))


;; Git integration for Emacs
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))


;; Better handling of paranthesis when writing Lisps.
(use-package paredit
  :ensure t
  :init
  (add-hook 'clojure-mode-hook #'enable-paredit-mode)
  (add-hook 'cider-repl-mode-hook #'enable-paredit-mode)
  (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook #'enable-paredit-mode)
  :config
  (show-paren-mode t)
  :bind (("M-[" . paredit-wrap-square)
         ("M-{" . paredit-wrap-curly))
  :diminish nil)


(fset 'yes-or-no-p 'y-or-n-p)

(use-package miniedit
  :ensure t
  :commands minibuffer-edit
  :init (miniedit-install))


;; line numbers
(global-display-line-numbers-mode)

;; inf-ruby provides a REPL buffer connected to a Ruby subprocess.
;; https://github.com/nonsequitur/inf-ruby
(use-package inf-ruby
  :ensure t
  :init
  (add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)
  (add-hook 'compilation-filter-hook 'inf-ruby-auto-enter)
  )


;; projectile
(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
  (setq projectile-completion-system 'helm)
  (helm-projectile-on)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  )


(use-package helm
  :ensure t
  :config
  (require 'helm-config)
  (global-set-key (kbd "M-x") #'helm-M-x))


(use-package helm-dash
  :ensure t)

(use-package helm-descbinds
  :ensure t
  :config
  (require 'helm-descbinds)
  (helm-descbinds-mode)
  )


(use-package helm-projectile
  :ensure t)

(use-package helm-ag
  :ensure t)

(use-package projectile-rails
  :ensure t
  :config
  (projectile-rails-global-mode)
  (define-key projectile-rails-mode-map (kbd "C-c r") 'projectile-rails-command-map))


(use-package rvm
  :ensure t
  :config
  (require 'rvm)
  (rvm-use-default))

;; (use-package exec-path-from-shell
;;   :ensure t
;;   :config
;;   (exec-path-from-shell-initialize))


(use-package robe
  :ensure t
  :config
  (add-hook 'ruby-mode-hook 'robe-mode)
  (eval-after-load 'company
    '(push 'company-robe company-backends))
  (add-hook 'robe-mode-hook 'ac-robe-setup))


(use-package rubocop
  :ensure t
  :config
  (require 'rubocop))

(use-package rspec-mode
  :ensure t
  :config
  (require 'rspec-mode))


;; Fira Code Symbol

(set-face-attribute 'default nil
                    :family "Fira Code")


(defun fira-code-mode--make-alist (list)
  "Generate prettify-symbols alist from LIST."
  (let ((idx -1))
    (mapcar
     (lambda (s)
       (setq idx (1+ idx))
       (let* ((code (+ #Xe100 idx))
              (width (string-width s))
              (prefix ())
              (suffix '(?\s (Br . Br)))
              (n 1))
         (while (< n width)
           (setq prefix (append prefix '(?\s (Br . Bl))))
           (setq n (1+ n)))
         (cons s (append prefix suffix (list (decode-char 'ucs code))))))
     list)))

(defconst fira-code-mode--ligatures
  '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\"
    "{-" "[]" "::" ":::" ":=" "!!" "!=" "!==" "-}"
    "--" "---" "-->" "->" "->>" "-<" "-<<" "-~"
    "#{" "#[" "##" "###" "####" "#(" "#?" "#_" "#_("
    ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*"
    "/**" "/=" "/==" "/>" "//" "///" "&&" "||" "||="
    "|=" "|>" "^=" "$>" "++" "+++" "+>" "=:=" "=="
    "===" "==>" "=>" "=>>" "<=" "=<<" "=/=" ">-" ">="
    ">=>" ">>" ">>-" ">>=" ">>>" "<*" "<*>" "<|" "<|>"
    "<$" "<$>" "<!--" "<-" "<--" "<->" "<+" "<+>" "<="
    "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<" "<~"
    "<~~" "</" "</>" "~@" "~-" "~=" "~>" "~~" "~~>" "%%"
    "x" ":" "+" "+" "*"))

(defvar fira-code-mode--old-prettify-alist)

(defun fira-code-mode--enable ()
  "Enable Fira Code ligatures in current buffer."
  (setq-local fira-code-mode--old-prettify-alist prettify-symbols-alist)
  (setq-local prettify-symbols-alist (append (fira-code-mode--make-alist fira-code-mode--ligatures) fira-code-mode--old-prettify-alist))
  (prettify-symbols-mode t))

(defun fira-code-mode--disable ()
  "Disable Fira Code ligatures in current buffer."
  (setq-local prettify-symbols-alist fira-code-mode--old-prettify-alist)
  (prettify-symbols-mode -1))

(define-minor-mode fira-code-mode
  "Fira Code ligatures minor mode"
  :lighter " Fira Code"
  (setq-local prettify-symbols-unprettify-at-point 'right-edge)
  (if fira-code-mode
      (fira-code-mode--enable)
    (fira-code-mode--disable)))

(defun fira-code-mode--setup ()
  "Setup Fira Code Symbols"
  (set-fontset-font t '(#Xe100 . #Xe16f) "Fira Code Symbol"))


;; ivy mode

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; enable this if you want `swiper' to use it
  ;; (setq search-default-mode #'char-fold-to-regexp)
  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-c k") 'counsel-ag)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history))


;;; checking spelling

(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))


;; org-projectile
(use-package org-projectile
  :bind (("C-c n p" . org-projectile-project-todo-completing-read)
         ("C-c c" . org-capture))
  :config
  (setq org-confirm-elisp-link-function nil)
  (progn
    (setq org-projectile-projects-file
          "/Users/edipo/Dropbox/todo.org")
    (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
    (push (org-projectile-project-todo-entry) org-capture-templates))
  :ensure t)

;; org-mode

(setq org-agenda-files (list "~/Dropbox/todo.org"))

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)


                                        ; Enable habit tracking (and a bunch of other modules)
(setq org-modules (quote (
                          org-habit
                          )))

                                        ; position the habit graph on the agenda to the right of the default

(add-to-list 'org-modules 'org-habit t)


(defun org-todo-with-date (&optional arg)
  (interactive "P")
  (cl-letf* ((org-read-date-prefer-future nil)
             (my-current-time (org-read-date t t nil "when:" nil nil nil))
             ((symbol-function #'org-current-effective-time)
              #'(lambda () my-current-time)))
    (org-todo arg)
    ))


;; temp files

(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))


;; each state with ! is recorded as state change
;; in this case I'm logging TODO and DONE states
(setq org-todo-keywords
      '((sequence "TODO(t!)" "NEXT(n)" "SOMD(s)" "WAFO(w)" "|" "DONE(d!)" "CANC(c!)")))
;; I prefer to log TODO creation also
(setq org-treat-insert-todo-heading-as-state-change t)
;; log into LOGBOOK drawer
(setq org-log-into-drawer t)


;; RSS

(use-package elfeed
  :ensure t)

(setq elfeed-feeds
      '("http://nullprogram.com/feed/"
        "https://rubyweekly.com/rss/1l8l1dd3"
        "https://news.ycombinator.com/rss"
        "http://planet.emacsen.org/atom.xml"))

(global-set-key (kbd "C-x w") 'elfeed)

;; whitespaces

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; new line end of file
(setq mode-require-final-newline 't)


;; line length
(require 'whitespace)
(setq whitespace-line-column 80) ;; limit line length
(setq whitespace-style '(face lines-tail))

(add-hook 'prog-mode-hook 'whitespace-mode)(setq-default header-line-format
                                                         (list " " (make-string 120 ?-) "|"))


;; backup in one place. flat, no tree structure
(setq backup-directory-alist '(("" . "~/.emacs_backup")))


;; no lock files, please
(setq create-lockfiles nil)


(setq sml/theme 'respectful)

;; do not include encoding information when save the file
(setq ruby-insert-encoding-magic-comment nil)
