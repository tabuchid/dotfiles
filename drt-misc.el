(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(auto-compression-mode t)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(ido-mode t)
(add-to-list 'auto-mode-alist '("\\.json$" . javascript-mode))
(setq tramp-default-method "ssh")
(setq mac-command-modifier 'meta)
;(load-file "~/elisp/cedet-1.0pre6/common/cedet.el")
;(global-ede-mode 1)                      ; Enable the Project management system
;(semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion 
;(global-srecode-minor-mode 1)            ; Enable template insertion menu
(setq-default indent-tabs-mode nil)
(provide 'drt-misc)