;;; utils.el --- Odds and ends of utilities

;;; Code:
(defun json-format ()
  "Run a selected region through Python's JSON formatter."
  (interactive)
  (save-excursion
    (shell-command-on-region (mark) (point)
                             "python -m json.tool" (buffer-name) t)))

;; Copy and paste with wayland
;; credit: yorickvP on Github
(setq wl-copy-process nil)
(defun wl-copy (text)
  (setq wl-copy-process (make-process :name "wl-copy"
                                      :buffer nil
                                      :command '("wl-copy" "-f" "-n")
                                      :connection-type 'pipe))
  (process-send-string wl-copy-process text)
  (process-send-eof wl-copy-process))
(defun wl-paste ()
  (if (and wl-copy-process (process-live-p wl-copy-process))
      nil ; should return nil if we're the current paste owner
    (shell-command-to-string "wl-paste -n | tr -d \r")))

;; Check for the existence of wl-copy and wl-paste
(when (or (getenv "WAYLAND_DISPLAY") (string-equal (getenv "DISPLAY") ""))
    (setq interprogram-cut-function 'wl-copy)
    (setq interprogram-paste-function 'wl-paste))

;;; utils.el ends here
