;;; packages.el --- Package configuration

;;; Code:
(require 'use-package)

; Package settings
(require 'package)
(setq package-archives '(("gnu"       . "https://elpa.gnu.org/packages/")
                         ("melpa"     . "https://melpa.org/packages/")))

(use-package auto-complete
  :config
  (global-auto-complete-mode 1)
  (ac-flyspell-workaround))

(use-package autorevert
  :config
  (global-auto-revert-mode 1))

(use-package cc-mode
  :defines
  c-basic-offset
  evil-shift-width
  :config
  (setq c-basic-offset 4
        tab-width 4
        evil-shift-width 4
        indent-tabs-mode nil)
  :hook (java-mode . (lambda () (c-set-offset 'arglist-intro '+)))
  :after (evil))

(use-package dired
  :config
  (setq dired-listing-switches "-alh"))

(use-package ediff
  :config
  (setq ediff-split-window-function 'split-window-horizontally))

(use-package evil
  :defer nil
  :config
  (message "Starting evil mode")
  (evil-mode 1)
  (setq evil-want-C-i-jump nil)  ; Don't bind <TAB>
  (setq evil-auto-indent t)

  (evil-define-command cofi/maybe-exit ()
    :repeat change
    (interactive)
    (let ((modified (buffer-modified-p)))
      (insert "j")
      (let ((evt (read-event (format "Insert %c to exit insert state" ?k)
                             nil 0.5)))
        (cond
         ((null evt) (message ""))
         ((and (integerp evt) (char-equal evt ?k))
          (delete-char -1)
          (set-buffer-modified-p modified)
          (push 'escape unread-command-events))
         (t (setq unread-command-events (append unread-command-events
                                                (list evt))))))))

  (evil-define-key 'normal org-mode-map (kbd "TAB") #'org-cycle)

  ; Git settings
  (evil-set-initial-state 'git-commit-mode 'insert)
  (evil-set-initial-state 'git-rebase-mode 'normal)
  :bind (:map evil-insert-state-map
              ("j" . #'cofi/maybe-exit)
              ([remap newline] . evil-ret-and-indent))
  :hook ((flycheck-error-list-mode . evil-emacs-state)
         (org-capture-mode . evil-insert-state)
         (yaml-mode . (lambda () (setq evil-shift-width 2)))))

(use-package flycheck
  :config
  (global-flycheck-mode)
  (setq-default flycheck-flake8-maximum-line-length 80)
  :hook ((js-mode . (lambda () (flycheck-select-checker 'javascript-eslint)))
         (typescript-mode . (lambda () (flycheck-select-checker 'typescript-tslint)))))

(use-package flyspell
  :hook ((git-commit-mode . flyspell-mode)
         (python-mode . flyspell-prog-mode)
         (org-mode . flyspell-prog-mode)))

(use-package git-commit
  :mode ("COMMIT_EDITMSG\\$" . git-commit-mode))

(use-package haskell-mode
  :hook (haskell-mode . 'turn-on-haskell-indentation))

(use-package helm
  :defines
  helm-ff-skip-boring-files
  :config
  (helm-mode 1)
  (setq helm-ff-skip-boring-files t)
  (add-to-list 'helm-boring-file-regexp-list "\\.pyc$")
  :bind (("C-x C-f" . helm-find-files)
         ("M-x" . helm-M-x)
         :map helm-map
         ("<tab>" . helm-execute-persistent-action)
         ; make TAB work in terminal
         ("C-i" . helm-execute-persistent-action)
         ; list actions using C-z
         ("C-z" . helm-select-action)))

(use-package imenu
  :config
  (setq imenu-auto-rescan t))

(use-package jedi-mode
  :defines
  jedi:complete-on-dot
  :config
  (setq jedi:complete-on-dot t)
  :hook (python-mode . jedi:setup))

(use-package js)

(use-package magit-mode
  :config
  (evil-define-key 'normal git-rebase-mode-map
    (kbd "C-p") 'git-rebase-move-line-up
    (kbd "C-n") 'git-rebase-move-line-down
    "e" 'git-rebase-edit
    "r" 'git-rebase-reword
    "p" 'git-rebase-pick
    "dd" 'git-rebase-kill-line
    "f" 'git-rebase-fixup
    "s" 'git-rebase-squash)
  :hook (git-commit-mode . (lambda () (set-fill-column 72))))

(use-package make-mode
  :config
  (modify-syntax-entry ?= "'"))

(use-package org-mode
  :defines
  org-capture-templates
  org-log-done
  org-src-fontify-natively
  :init
  (setq org-capture-templates
        '(("t" "todo" entry (file "~/.todos.org")
           "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
          ("n" "note" entry (file "")
           "* %? :NOTE:\n%U\n%a\n")))
  :config
  (setq org-log-done 'time)
  (setq org-src-fontify-natively t)
  :bind (("\C-cl" . org-store-link)
         ("\C-cc" . org-capture)
         ("\C-ca" . org-agenda)
         ("\C-cb" . org-iswitchb)))

(use-package projectile
  :defines
  projectile-completion-system
  projectile-use-git-grep
  :init
  (setq projectile-completion-system 'helm)
  (setq projectile-use-git-grep t)
  :config
  (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)
  (projectile-mode)
  (helm-projectile-on))

(use-package python
  :defines
  python-indent-offset
  :config
  (setq tab-width 4
        evil-shift-width 4
        python-indent-offset 4))

(use-package rainbow-delimiters-mode
  :hook (python-mode . rainbow-delimiters-mode))

(use-package scss-mode
  :config
  (setq scss-compile-at-save nil))

(use-package semantic-mode
  :config
  (semantic-mode 1)
  :bind("C-c j" . helm-semantic-or-imenu))

(use-package smart-mode-line
  :config
  (sml/setup))

(use-package terraform-mode)

(use-package text-mode
  :hook (text-mode . turn-on-auto-fill))

(use-package typescript-mode
  :config
  (setq typescript-indent-level 2))

(use-package undo-tree
  :config
  (global-undo-tree-mode)
  (setq undo-tree-visualizer-timestamps t)
  (setq undo-tree-visualizer-diff t)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))))

(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'reverse)
  (setq uniquify-separator "|")
  (setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified
  (setq uniquify-ignore-buffers-re "^\\*")) ; don't muck with special buffers

(use-package whitespace
  :config
  (global-whitespace-mode 1)
  (setq whitespace-line-column 80
        whitespace-style '(face trailing lines-tail space-mark tab-mark
                                newline-mark)
        whitespace-display-mappings
        ;; all numbers are Unicode codepoint in decimal.
        '((tab-mark 9 [9655 9] [92 9]) ; 9 TAB, 9655 WHITE RIGHT-POINTING TRIANGLE 「▷」
          ))
  :hook (java-mode . (lambda () (setq whitespace-line-column 100))))

(use-package yaml-mode
  :mode "\\.sls$")

(use-package yasnippet
  :defines
  yas-snippet-dirs
  yas-prompt-functions
  :init
  ; Snippet directories are loaded in order. If there are duplicate entries, the
  ; first one is taken. So if I want to override anything in yasnippet-snippets, I
  ; can add something of the same name to custom-snippets.
  (setq yas-snippet-dirs
        '("~/.emacs.d/snippets/custom-snippets"
          "~/.emacs.d/snippets/yasnippet-snippets"))
  (setq yas-prompt-functions '(yas-x-prompt yas-dropdown-prompt yas-completing-prompt))
  :config
  (yas-global-mode 1))

;;; packages.el ends here
