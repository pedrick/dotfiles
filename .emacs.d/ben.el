
(setq user-full-name "Ben Pedrick"
      user-mail-address "ben.pedrick@gmail.com")

(add-to-list 'load-path "~/.emacs.d/scripts")

(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-cr" 'revert-buffer)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

(setq buffer-file-coding-system 'utf-8-unix)

(setq-default fill-column 80)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

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

(load-theme 'solarized-light t)

(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(column-number-mode 1)
(menu-bar-mode 0)
(show-paren-mode 1)

(setq auto-mode-alist (cons '("\\.sls$" . yaml-mode) auto-mode-alist))

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

(defun json-format ()
  (interactive)
  (save-excursion
    (shell-command-on-region (mark) (point)
                             "python -m json.tool" (buffer-name) t)))

(autoload 'auto-complete-mode "auto-complete-mode" "Auto-complete mode" t)
(global-auto-complete-mode 1)
(eval-after-load "auto-complete-mode"
  '(progn
     (setq ac-ignore-case nil)))

(autoload 'cython-mode "cython-mode" "Cython mode" t)

(autoload 'ediff "ediff" "Ediff mode" t)
(eval-after-load "ediff"
  '(progn
     (setq ediff-split-window-function 'split-window-horizontally)))

(autoload 'evil "evil" "Evil mode" t)
(evil-mode 1)
(eval-after-load "evil"
  '(progn
     (setq evil-want-C-i-jump nil)  ; Don't bind <TAB>
     (setq evil-auto-indent t)
     (define-key evil-insert-state-map "j" #'cofi/maybe-exit)
     (define-key evil-insert-state-map [remap newline] 'evil-ret-and-indent)

     (evil-define-key 'normal org-mode-map (kbd "TAB") #'org-cycle)

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

(autoload 'flycheck "flycheck" "Flycheck mode" t)
(global-flycheck-mode 1)
(eval-after-load "flycheck"
  '(progn
     (setq-default flycheck-flake8-maximum-line-length 80)
     (add-hook 'flycheck-error-list-mode-hook
               '(lambda () (evil-emacs-state 1)))))

(add-hook 'haskell-mode-hook
          'turn-on-haskell-indentation)

(autoload 'helm "helm" "Helm mode" t)
(helm-mode 1)

(eval-after-load "helm"
  '(progn
    ; rebind tab to do persistent action
     (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
     ; make TAB works in terminal
     (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
     ; list actions using C-z
     (define-key helm-map (kbd "C-z")  'helm-select-action)

     (setq helm-ff-skip-boring-files t)
     (cl-loop for ext in '("\\.pyc$")
              do (add-to-list 'helm-boring-file-regexp-list "\\.pyc$"))))

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

(autoload 'magit "magit" "Magit mode" t)
(eval-after-load 'evil
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

(add-hook 'makefile-mode-hook
          (lambda ()
            (modify-syntax-entry ?= "'")))

(autoload 'org "org" "Org mode" t)
(eval-after-load "org"
  '(progn
     (global-set-key "\C-cl" 'org-store-link)
     (global-set-key "\C-cc" 'org-capture)
     (global-set-key "\C-ca" 'org-agenda)
     (global-set-key "\C-cb" 'org-iswitchb)
     (setq org-log-done 'time)
     (setq org-src-fontify-natively t)))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (emacs-lisp . t)))

(autoload 'python "python" "Python mode" t)
(eval-after-load "python"
  '(add-hook 'python-mode-hook
             (lambda ()
               (setq tab-width 4)
               (setq python-indent-offset 4))))

(autoload 'scss-mode "scss-mode" "Scss mode" t)
(eval-after-load "scss-mode"
  '(add-hook 'scss-mode-hook
             (lambda ()
               (setq scss-compile-at-save nil))))

(require 'smart-mode-line)
(sml/setup)

(autoload 'undo-tree "undo-tree" "Undo-Tree mode" t)
(global-undo-tree-mode)
(eval-after-load "undo-tree"
  '(progn
     (setq undo-tree-visualizer-timestamps t)
     (setq undo-tree-visualizer-diff t)))

(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "|")
(setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "http://melpa.milkbox.net/packages/")
                         ("tromey"    . "http://tromey.com/elpa/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))