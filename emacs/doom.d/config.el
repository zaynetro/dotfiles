;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Roman Zaynetdinov"
      user-mail-address "john@doe.com")

(setq-default delete-by-moving-to-trash t)

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))

;; (setq doom-font (font-spec :family "Fira Code" :size 13 :weight 'medium))
(setq doom-font (font-spec :family "Fantasque Sans Mono" :size 15))


;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-light)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Sync/org/")


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

;; Trigger Hydra when program hits a breakpoint
(add-hook 'dap-stopped-hook
          (lambda (arg) (call-interactively #'dap-hydra)))

;; Remove ".project" marker
;; (after! projectile
;;   (setq projectile-project-root-files-bottom-up
;;         '(".projectile"
;;           ".git")))

(setq gc-cons-threshold 100000000)

(setq eshell-cmpl-ignore-case t)

(after! magit
  (setq git-commit-summary-max-length 70))

(setq js-indent-level 2)
(setq typescript-indent-level 2)

;; From https://emacs-lsp.github.io/lsp-mode/page/main-features/
(setq company-minimum-prefix-length 2
      company-idle-delay 0.2)

;; C-SPC is default for company mode. On Mac it is used to change language input.
;; Hence, migrate to C-c + Tab (Control + c and then tab).
(map! :prefix "C-c"
      :desc "Invoke completion"
      :i
      "TAB"
      #'company-complete)

;; Remember frame size of Emacs
;; https://discord.com/channels/406534637242810369/406554085794381833/843557872755540008
(when-let (dims (doom-store-get 'last-frame-size))
  (cl-destructuring-bind ((left . top) width height fullscreen) dims
    (setq initial-frame-alist
          (append initial-frame-alist
                  `((left . ,left)
                    (top . ,top)
                    (width . ,width)
                    (height . ,height)
                    (fullscreen . ,fullscreen))))))

(defun save-frame-dimensions ()
  (doom-store-put 'last-frame-size
                  (list (frame-position)
                        (frame-width)
                        (frame-height)
                        (frame-parameter nil 'fullscreen))))

(add-hook 'kill-emacs-hook #'save-frame-dimensions)

;; Increase/decrease font size by one
(setq doom-font-increment 1)

;; Enable plugin (see packages.el for github source)
;; (use-package! lsp-tailwindcss)

;; Run in add-on mode (allows to run multiple servers for a single file)
;; (use-package lsp-tailwindcss
;;   :init
;;   (setq lsp-tailwindcss-add-on-mode t))

;; (setq lsp-elixir-server-command '("elixir-ls"))

(after! lsp-mode
  ;; https://github.com/emacs-lsp/lsp-mode/issues/3577#issuecomment-1709232622
  (delete 'lsp-terraform lsp-client-packages))
