;;; .emacs --- Doug Tabuchi's Emacs configuration -*- emacs-lisp -*-

;; Copyright (C) 1997 -- 2009 Doug Tabuchi <Doug@DougTabuchi.com>

;; Author: Doug Tabuchi <Doug@DougTabuchi.com>
;; Keywords: local

;; This file is NOT part of GNU Emacs.

;; This is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 2, or (at your option) any later
;; version.

;; This file is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with Emacs; see the file COPYING, or type `C-h C-c'. If not,
;; write to the Free Software Foundation at this address:

;;   Free Software Foundation
;;   51 Franklin Street, Fifth Floor
;;   Boston, MA 02110-1301
;;   USA
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(current-language-environment "UTF-8")
 '(inhibit-startup-screen t)
 '(show-paren-mode t)
 '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))
 '(tool-bar-mode nil)
 '(transient-mark-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "#2e3436" :foreground "#eeeeec" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :family "apple-monaco")))))

(add-to-list 'load-path "~/dotfiles")
;(add-to-list 'load-path "~/dotfiles/ecb-2.40")
(add-to-list 'load-path "~/dotfiles/remember")
(add-to-list 'load-path "~/dotfiles/mmm-mode-0.4.8")
;(load "~/dotfiles/Pymacs-0.24-beta1/pymacs.el")
(load "~/dotfiles/mmm-mako/mmm-mako.el")
(setenv "PYMACS_PYTHON" "/usr/local/bin/python")

;(require 'pymacs) 
(require 'mmm-auto)
(setq mmm-global-mode 'maybe)
(mmm-add-mode-ext-class 'html-mode "\\.php\\'" 'html-php)
(add-to-list 'auto-mode-alist '("\\.mako\\'" . html-mode))
(mmm-add-mode-ext-class 'html-mode "\\.mako\\'" 'mako)
(global-set-key "\M-p"  'mmm-parse-buffer)
(setq paste-kill-url t)
(setq paste-show-in-browser t)
;(autoload 'pymacs-apply "pymacs")
;(autoload 'pymacs-call "pymacs")
;(autoload 'pymacs-eval "pymacs" nil t)
;(autoload 'pymacs-exec "pymacs" nil t)
;(autoload 'pymacs-load "pymacs" nil t)
;(eval-after-load "pymacs"
;  '(add-to-list 'pymacs-load-path "~/dotfiles/pastemacs"))
;(pymacs-load "pastemacs" "paste-")

(require 'erc)
(require 'drt-selftest)
(require 'drt-term)
(require 'drt-defuns)
(require 'drt-bindings)
(require 'org)
(require 'drt-org-config)
(require 'midnight)
(require 'maxframe)
(require 'ido)
(require 'remember)
(require 'drt-misc) 
