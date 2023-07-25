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
(setq interprogram-cut-function 'wl-copy)
(setq interprogram-paste-function 'wl-paste)

;; Communicate with a chatbot in emacs
(defcustom chatbot-openai-secret-key nil
  "Secret key for access the OpenAI API")

(defcustom chatbot-openai-model "gpt-3.5-turbo"
  "Which model to use with the OpenAI API")

(defun chatbot-call (query)
  (interactive (if (chatbot-validate-config)
                   (let ((query (read-string "Enter a chatbot query: ")))
                     (list query))
                 (list nil)))
  (if query
      (chatbot-send-query query)))

(defun chatbot-call-buffer ()
  (interactive)
  (if (chatbot-validate-config)
      (progn
        (message (concat "Sending buffer " (buffer-name) " to chatbot"))
        (chatbot-send-query (buffer-string)))))

(defun chatbot-call-region ()
  (interactive)
  (if (chatbot-validate-config)
      (progn
        (message "Sending region to chatbot")
        (let ((region-string (buffer-substring (region-beginning) (region-end))))
          (chatbot-send-query region-string)))))

(defun chatbot-validate-config ()
  (if (not chatbot-openai-secret-key)
      (progn (message "chatbot-openai-secret-key is nil. Must be set to your secret key for the chatbot to work.")
             nil)
    t))

(defun chatbot-send-query (query)
  (let ((url-request-method "POST")
        (url-request-extra-headers
         `(("Authorization" . ,(concat "Bearer " chatbot-openai-secret-key))
           ("Content-Type" . "application/json")))
        (url-request-data (encode-coding-string
                           (json-encode `(("model" . ,chatbot-openai-model)
                                          ("messages" (("role" . "user")
                                                       ("content" . ,query)))))
                           'utf-8)))
    (url-retrieve "https://api.openai.com/v1/chat/completions"
                  'chatbot-handle-url-response)))

(defun chatbot-handle-url-response (status)
  (delete-region (point-min) (+ 1 url-http-end-of-headers))
  (let ((status-error (plist-get status :error)))
    (if status-error
        (message "Got error: %s %s" status-error (buffer-string))
      (chatbot-write-response-to-buffer (current-buffer))))
  (kill-buffer))

(defun chatbot-write-response-to-buffer (response-buffer)
  (with-current-buffer response-buffer
    (let* ((data (json-parse-buffer))
           (choices (gethash "choices" data))
           (message (gethash "message" (aref choices 0)))
           (content (gethash "content" message)))
      (with-current-buffer (get-buffer-create "*chatbot*")
        (end-of-buffer)
        (insert content)
        (insert "\n\n")
        (display-buffer (current-buffer))))))

;;; utils.el ends here
