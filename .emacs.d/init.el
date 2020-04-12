;;; init.el --- Where all the magic begins
;;; Code:
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Keep emacs Custom-settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

; Load my configuration
(load (expand-file-name "globals.el" user-emacs-directory))
(load (expand-file-name "packages.el" user-emacs-directory))
(load (expand-file-name "utils.el" user-emacs-directory))

; Load any local configuration
(defvar local-config-file (expand-file-name "local.el" user-emacs-directory))

(if (file-exists-p local-config-file)
    (load local-config-file))
;;; init.el ends here
