;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Roman Zaynetdinov"
      user-mail-address "john@example.com")

(setq-default delete-by-moving-to-trash t)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Hack" :size 17))
;;      doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Sync/org/")

(after! org-capture
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/Sync/org/tasks.org" "Tasks")
           "* TODO %?\n%T\n%i\n%a")
          ("j" "Journal" entry (file+olp+datetree "~/Sync/org/journal.org")
           "* %?\n%U\n%i")
          ("w" "Work log" entry (file+olp+datetree "~/Sync/org/work-log.org")
           "* %?\t:work:lekane:\n%u\n%i")
          ("n" "Note" entry (file+headline "~/Sync/org/notes.org" "Notes")
           "* %?\n%U\n%i"))))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Trigger Hydra when program hits a breakpoint
(add-hook 'dap-stopped-hook
          (lambda (arg) (call-interactively #'dap-hydra)))

;; Remove ".project" marker
(after! projectile
  (setq projectile-project-root-files-bottom-up
        '(".projectile"
          ".git")))

(after! lsp-mode
  (lsp-ui-mode))

(setq gc-cons-threshold 100000000)

(after! lsp-java
  ;; Set Java formatting
  ;; (setq lsp-java-format-settings-url "/../java_formatting.xml")
  ;; LS requires Java 11
  ;; (setq lsp-java-java-path "/usr/lib/jvm/java-11-openjdk/bin/java")

  (setq lsp-java-vmargs '("-XX:+UseParallelGC" "-XX:GCTimeRatio=4" "-XX:AdaptiveSizePolicyWeight=90" "-Dsun.zip.disableMemoryMapping=true" "-Xmx2G" "-Xms100m"))
  (setq lsp-java-completion-max-results 10)
  (setq lsp-java-autobuild-enabled nil))

(after! lsp-ui
  (setq lsp-ui-doc-max-height 15
        lsp-ui-doc-max-width 80
        ;; Consider using `+lookup/documentation' instead
        lsp-ui-doc-enable t))

;; Case insensitive completion in eshell
(setq eshell-cmpl-ignore-case t)

(defun kill-buffer-and-window ()
  (interactive)
  (kill-current-buffer)
  (+workspace/close-window-or-workspace))

(map! :n "SPC w x" #'kill-buffer-and-window)

(after! magit
  (setq git-commit-summary-max-length 70))

(setq js-indent-level 2)
(setq typescript-indent-level 2)
