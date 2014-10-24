(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("59e21cf73dc1452801d0ff2b53cac27272569a0320a6081f5ee09f310683deb7" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" default))))

(package-initialize)
;;; Load path
(add-to-list 'load-path "~/.emacs.d/scripts")

;;; Keys
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-cr" 'revert-buffer)

;;; Tabs and Spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

; File settings
(setq auto-mode-alist (cons '("\\.sls$" . yaml-mode) auto-mode-alist))

;;; Line endings
(setq buffer-file-coding-system 'utf-8-unix)

;;; Width
(setq-default fill-column 80)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;;; Colors
(load-theme 'solarized-light t)
(menu-bar-mode 0)

(autoload 'whitespace "whitespace" "Whitespace mode" t)
(global-whitespace-mode 1)
(eval-after-load "whitespace"
  '(progn
     (setq whitespace-line-column 80
           whitespace-style '(face trailing lines-tail space-mark tab-mark
                                   newline-mark))
     (setq whitespace-display-mappings
           ;; all numbers are Unicode codepoint in decimal.
           '(
             (tab-mark 9 [9655 9] [92 9]) ; 9 TAB, 9655 WHITE RIGHT-POINTING TRIANGLE 「▷」
             ))))

;;; Other UI
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;;; Backup Directory
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.emacs.d/saves"))    ; don't litter my fs tree
   auto-save-file-name-transforms
    `((".*" "~/.emacs.d/saves" t))
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

;;; Custom functions
(defun json-format ()
  (interactive)
  (save-excursion
    (shell-command-on-region (mark) (point)
                             "python -m json.tool" (buffer-name) t)))

;;; Mode settings
(show-paren-mode 1)
(column-number-mode 1)
(setq-default indent-tabs-mode nil)


; Cython mode
(autoload 'cython-mode "cython-mode" "Cython mode" t)

; Ediff
(autoload 'ediff "ediff" "Ediff mode" t)
(eval-after-load "ediff"
  (setq ediff-split-window-function 'split-window-horizontally))

; Evil mode
(autoload 'evil "evil" "Evil mode" t)
(evil-mode 1)
(eval-after-load "evil"
  '(progn
     (setq evil-want-C-i-jump nil)  ; Don't bind <TAB>
     (setq evil-auto-indent t)
     (define-key evil-insert-state-map "j" #'cofi/maybe-exit)
     (define-key evil-insert-state-map [remap newline] 'evil-ret-and-indent)

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
                                                   (list evt))))))))))

; Flycheck
(autoload 'flycheck "flycheck" "Flycheck mode" t)
(global-flycheck-mode 1)
(eval-after-load "flycheck"
  '(progn
     (setq-default flycheck-flake8-maximum-line-length 80)
     (add-hook 'flycheck-error-list-mode-hook
               '(lambda () (evil-emacs-state 1)))))

; Haskell mode
(add-hook 'haskell-mode-hook
          'turn-on-haskell-indentation)

; Helm mode
(autoload 'helm "helm" "Helm mode" t)
(helm-mode 1)

(eval-after-load "helm"
  '(progn
     (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebihnd tab to do persistent action
     (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
     (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

     (setq helm-ff-skip-boring-files t)
     (cl-loop for ext in '("\\.pyc$")
              do (add-to-list 'helm-boring-file-regexp-list "\\.pyc$"))))

; Java mode
(defun my-java-indent-setup ()
        (c-set-offset 'arglist-intro '+))
(eval-after-load "cc-mode"
  '(progn
     (add-hook 'java-mode-hook
               (lambda ()
                 (setq c-basic-offset 4
                       tab-width 4
                       indent-tabs-mode t)
                 (setq whitespace-display-mappings '())
                 (my-java-indent-setup)
                 ))))

; Magit mode
(autoload 'magit "magit" "Magit mode" t)
(eval-after-load 'magit
  '(progn
     (evil-define-key 'normal git-rebase-mode-map
       (kbd "C-p") 'git-rebase-move-line-up
       (kbd "C-n") 'git-rebase-move-line-down
       "e" 'git-rebase-edit
       "r" 'git-rebase-reword
       "p" 'git-rebase-pick
       "dd" 'git-rebase-kill-line
       "f" 'git-rebase-fixup
       "s" 'git-rebase-squash)))

; Makefile mode
(add-hook 'makefile-mode-hook
          (lambda ()
            (modify-syntax-entry ?= "'")))

; Org mode
(autoload 'org "org" "Org mode" t)
(eval-after-load "org"
  '(progn
     (global-set-key "\C-cl" 'org-store-link)
     (global-set-key "\C-cc" 'org-capture)
     (global-set-key "\C-ca" 'org-agenda)
     (global-set-key "\C-cb" 'org-iswitchb)
     (setq org-log-done 'time)))

; Python mode
(autoload 'python "python" "Python mode" t)
(eval-after-load "python"
  '(add-hook 'python-mode-hook
             (lambda ()
               (setq tab-width 4)
               (setq python-indent-offset 4))))

; Scss-mode
(autoload 'scss-mode "scss-mode" "Scss mode" t)
(eval-after-load "scss-mode"
  '(add-hook 'scss-mode-hook
             (lambda ()
               (setq scss-compile-at-save nil))))

; Smart-mode-line
(require 'smart-mode-line)
(sml/setup)

; Undo-tree mode
(autoload 'undo-tree "undo-tree" "Undo-Tree mode" t)
(global-undo-tree-mode)
(eval-after-load "undo-tree"
  '(progn
     (setq undo-tree-visualizer-timestamps t)
     (setq undo-tree-visualizer-diff t)))

; Uniquify
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "|")
(setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

;;; Package settings
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "http://melpa.milkbox.net/packages/")
                         ("tromey"    . "http://tromey.com/elpa/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-selection ((t (:background "none" :underline t)))))
;;; init.el ends here
