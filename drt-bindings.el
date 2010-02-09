(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)
(global-set-key "\eg"    'goto-line)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key [(meta return)] 'toggle-fullscreen)
;; Diff the current buffer with the file contents
(global-set-key (kbd "C-c w")
   (lambda () (interactive) (diff-buffer-with-file (current-buffer))))
(provide 'drt-bindings)