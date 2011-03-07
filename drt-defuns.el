;;; Electric Pairs
;; (add-hook 'python-mode-hook
;;      (lambda ()
;;       (define-key python-mode-map "\"" 'electric-pair)
;;       (define-key python-mode-map "\'" 'electric-pair)
;;       (define-key python-mode-map "(" 'electric-pair)
;;       (define-key python-mode-map "[" 'electric-pair)
;;       (define-key python-mode-map "{" 'electric-pair)))
;; (defun electric-pair ()
;;   "Insert character pair without sournding spaces"
;;   (interactive)
;;   (let (parens-require-spaces)
;;     (insert-pair)))
;; ;;; bind RET to py-newline-and-indent
;; (add-hook 'python-mode-hook '(lambda () 
;;      (define-key python-mode-map "\C-m" 'newline-and-indent)))

(provide 'drt-defuns)