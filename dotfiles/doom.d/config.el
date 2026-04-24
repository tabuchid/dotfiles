;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Doug Tabuchi"
      user-mail-address "doug@dougtabuchi.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


(after! lsp-mode
  ;; Ensure correct Ruby LSP configuration.
  ;; The `(MODE . CLIENTS)` cons form scopes the disable to a specific
  ;; major mode — here, disable yamlls whenever the helm template derived
  ;; mode is active. Setting this globally avoids a hook-ordering race
  ;; where yaml-mode-hook's `lsp!` starts yamlls before a buffer-local
  ;; setq can take effect.
  (setq lsp-disabled-clients
        '(solargraph
          rubocop-ls
          (doug/helm-template-mode . (yamlls))))
  (setq lsp-ruby-lsp-use-bundler nil)
  )

;; Directly
(after! mise
  ;; enable globally
  (global-mise-mode 1)
  )

(add-to-list 'auto-mode-alist '("\\.env\\'" . sh-mode))

;; Helm chart templates mix Go template syntax with YAML, which yamlls
;; can't parse (produces ~170 false-positive diagnostics per file).
;; Install with `brew install helm-ls`. Defined at top level (not inside
;; `after! lsp-mode`) so the mode and auto-mode-alist entry exist before
;; any buffer is opened — otherwise yaml-mode wins the race.
(define-derived-mode doug/helm-template-mode yaml-mode "Helm"
  "yaml-mode variant for Helm chart templates. Uses helm-ls, not yamlls.")

(add-to-list 'auto-mode-alist
             '("/charts/[^/]+/templates/.*\\.ya?ml\\'" . doug/helm-template-mode))

(add-hook 'doug/helm-template-mode-hook
          (defun doug/helm-template-mode-setup ()
            ;; yamlls is blocked globally via the (MODE . CLIENTS) cons in
            ;; `lsp-disabled-clients`, so it won't attach.
            ;; Neutralize format-on-save — LSP formatter rewrites Go templating.
            (setq-local +format-with-lsp nil)
            (setq-local format-all-formatters nil)
            ;; `:lang yaml +lsp` in Doom doesn't hook `lsp-deferred` into
            ;; `yaml-mode-hook` (likely hooks yaml-ts-mode instead), so the
            ;; derived mode wouldn't auto-start lsp. Trigger it here.
            (lsp-deferred)))

(after! lsp-mode
  ;; lsp-mode 9.0+ ships `lsp-kubernetes-helm.el` which registers a `helm-ls`
  ;; client that activates via `(lsp-activate-on "helm-ls")` — i.e. when the
  ;; buffer's language-id is "helm-ls". But nothing in the default
  ;; `lsp-language-id-configuration` resolves to that; yaml files map to
  ;; "yaml" and trigger yamlls instead. Map our derived mode → "helm-ls".
  (add-to-list 'lsp-language-id-configuration
               '(doug/helm-template-mode . "helm-ls")))
