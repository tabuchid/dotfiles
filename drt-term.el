(require 'term)
(defun visit-ansi-term ()
  "If we are in an *ansi-term*, rename it.
If there is no *ansi-term*, run it.
If there is one running, switch to that buffer."
  (interactive)
  (if (equal "*ansi-term*" (buffer-name))
      (call-interactively 'rename-buffer)
      (if (get-buffer "*ansi-term*")
   (switch-to-buffer "*ansi-term*")
   (ansi-term "/bin/bash"))))
(global-set-key (kbd "<f2>") 'visit-ansi-term)
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

(defun dev ()
  (interactive) 
  (remote-term "dev" "ssh" "dev.fanfeedr.com"))

(defun test ()
  (interactive) 
  (remote-term "dev" "ssh" "test.fanfeedr.com"))

(defun web1 ()
  (interactive) 
  (remote-term "web1" "ssh" "web1"))

(defun web2 ()
  (interactive) 
  (remote-term "web2" "ssh" "web2"))
(defun assets ()
  (interactive) 
  (remote-term "assets" "ssh" "assets.fanfeedr.com"))

(defun doug ()
  (interactive) 
  (remote-term "doug" "ssh" "tabuchid@dougtabuchi.com"))

(defun drt-fc12 ()
  (interactive) 
  (remote-term "drt-fc12" "ssh" "drt-fc12.local"))

(provide 'drt-term)