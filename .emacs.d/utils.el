;;; utils.el --- Odds and ends of utilities

;;; Code:
(defun json-format ()
  "Run a selected region through Python's JSON formatter."
  (interactive)
  (save-excursion
    (shell-command-on-region (mark) (point)
                             "python -m json.tool" (buffer-name) t)))
;;; utils.el ends here
