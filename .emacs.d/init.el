;;; init.el --- Where all the magic begins
;;
;; Taken from https://github.com/mwfogleman/config on 2014-12-30
;;
;; This file allows Emacs to initialize my customizations
;; in Emacs lisp embedded in *one* literate Org-mode file.

;; This sets up the load path so that we can override it
(package-initialize nil)
;; Override the packages with the git version of Org and other packages
(add-to-list 'load-path "~/.emacs.d/site-lisp/org-mode/lisp/")

;; Load the rest of the packages
(package-initialize t)
(setq package-enable-at-startup nil)

;; Keep emacs Custom-settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

(require 'org)
(org-babel-load-file "~/.emacs.d/ben.org")

;;; init.el ends here
