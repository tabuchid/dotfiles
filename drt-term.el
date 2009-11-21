(require 'term)
(defun at ()
      (interactive)
      (ansi-term "bash" "localhost"))
;; Use this for remote so I can specify command line arguments
(defun remote-term (new-buffer-name cmd &rest switches)
  (setq term-ansi-buffer-name (concat "*" new-buffer-name "*"))
  (setq term-ansi-buffer-name (generate-new-buffer-name term-ansi-buffer-name))
  (setq term-ansi-buffer-name (apply 'term-ansi-make-term term-ansi-buffer-name cmd nil switches))
  (set-buffer term-ansi-buffer-name)
  (term-mode)
  (term-char-mode)
  (term-set-escape-char ?\C-x)
  (switch-to-buffer term-ansi-buffer-name))

(defun stage ()
  (interactive) 
  (remote-term "stage" "ssh" "stage"))

(defun assets ()
  (interactive) 
  (remote-term "assets" "ssh" "assets.fanfeedr.com"))

(defun doug ()
  (interactive) 
  (remote-term "doug" "ssh" "tabuchid@dougtabuchi.com"))

(provide 'drt-term)