;;; packages.el --- Package configuration

;;; Code:
(require 'use-package)

; Package settings
(require 'package)
(setq package-archives '(("gnu"       . "https://elpa.gnu.org/packages/")
                         ("melpa"     . "https://melpa.org/packages/")))

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

(use-package company
  :after eglot
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :hook (eglot-managed-mode . company-mode))

(use-package consult
  :bind (("C-c C-j" . consult-imenu)))

(use-package dired
  :config
  (setq dired-listing-switches "-alh"))

(use-package ediff
  :config
  (setq ediff-split-window-function 'split-window-horizontally))

(use-package eglot
  :defer t
  :hook ((js-mode . eglot-ensure)
         (python-mode . eglot-ensure)
         (typescript-mode . eglot-ensure)))

(use-package evil
  :defer nil
  :config
  (evil-mode 1)
  (setq evil-want-C-i-jump nil)  ; Don't bind <TAB>
  (setq evil-auto-indent t)
  (setq evil-undo-system 'undo-tree)

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
         (flymake-diagnostics-buffer-mode . evil-emacs-state)
         (org-capture-mode . evil-insert-state)
         (xref--xref-buffer-mode . evil-emacs-state)
         (yaml-mode . (lambda () (setq evil-shift-width 2)))))

(use-package flymake
  :bind (("C-c ! l" . flymake-show-buffer-diagnostics)))

(use-package flyspell
  :hook ((git-commit-mode . flyspell-mode)
         (python-mode . flyspell-prog-mode)
         (org-mode . flyspell-prog-mode)))

(use-package git-commit
  :mode ("COMMIT_EDITMSG\\$" . git-commit-mode))

(use-package gptel)

(use-package haskell-mode
  :hook (haskell-mode . 'turn-on-haskell-indentation))

(use-package js)

(use-package magit
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

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

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

(use-package org-roam
  :custom
  (org-roam-directory "~/org-roam")
  :config
  (org-roam-setup))

(use-package python
  :defines
  python-indent-offset
  :config
  (setq tab-width 4
        evil-shift-width 4
        python-indent-offset 4))

(use-package rainbow-delimiters-mode
  :hook (python-mode . rainbow-delimiters-mode))

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

(use-package vertico
  :init
  (vertico-mode))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

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

;;; packages.el ends here
