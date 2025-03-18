;;; globals.el --- Global settings not tied to any mode
;;; Code:

; Personal information
(setq user-full-name "Ben Pedrick"
      user-mail-address "ben.pedrick@gmail.com")

; Key Bindings
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-cr" 'revert-buffer)

(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete)

; Text Defaults
(setq-default indent-tabs-mode nil)
(setq buffer-file-coding-system 'utf-8-unix)
(setq-default fill-column 80)

; Colors
(load-theme 'solarized-light t)

; Other UI
(setq inhibit-splash-screen t
      inhibit-startup-message t)
(column-number-mode 1)
(menu-bar-mode 0)
(show-paren-mode 1)

(setopt enable-recursive-minibuffers t)
(setopt completion-auto-help 'always)
(setopt completions-max-height 40)
(setopt completions-format 'one-column)
(setopt completion-auto-select 'second-tab)


; Backup directory
(setq backup-by-copying t      ; don't clobber symlinks
      ; don't litter my fs tree
      backup-directory-alist '(("." . "~/.emacs.d/saves"))
      create-lockfiles nil
      auto-save-file-name-transforms `((".*" "~/.emacs.d/saves" t))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)       ; use versioned backups

;;; globals.el ends here
