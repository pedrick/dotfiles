(package-initialize)
;;; Load path
(add-to-list 'load-path "~/.emacs.d/org-8.0.7")
(add-to-list 'load-path "~/.emacs.d/evil")
(add-to-list 'load-path "~/.emacs.d/scripts")

;;; Keys
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)

;;; Tabs and Spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;;; Line endings
(setq buffer-file-coding-system 'utf-8-unix)

;;; Width
(setq-default fill-column 80)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;;; Colors
(load-theme 'solarized-light t)
(menu-bar-mode 0)

(require 'whitespace)
(setq whitespace-line-column 80
      whitespace-style '(face trailing lines-tail space-mark tab-mark
                              newline-mark))
(setq whitespace-display-mappings
       ;; all numbers are Unicode codepoint in decimal.
      '(
        (tab-mark 9 [9655 9] [92 9]) ; 9 TAB, 9655 WHITE RIGHT-POINTING TRIANGLE 「▷」
        ))
(global-whitespace-mode 1)

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
(require 'cython-mode)

; Evil mode
(require 'evil)
(evil-mode 1)

(define-key evil-insert-state-map "j" #'cofi/maybe-exit)

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

; Org mode
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done 'time)

; Flycheck
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
