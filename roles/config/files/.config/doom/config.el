;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "exu"
      user-mail-address "mrc@frm01.net")

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
(setq doom-font (font-spec :family "monospace" :size 11.0 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "sans" :size 12.0))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq catppuccin-flavor 'macchiato)
(setq doom-theme 'catppuccin)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;;(setq org-directory "~/org/")


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

(setq
 projectile-project-search-path '("~/gitprojects/"))

;; Set POSIX shell for emacs internals. Use fish in vterm
(setq shell-file-name (executable-find
                       "bash"))
(setq-default vterm-shell
              "/usr/bin/fish")
(setq-default explicit-shell-file-name
              "/usr/bin/fish")

(after! hl-todo
  (setq hl-todo-keyword-faces
        '(("TODO"   . "#EACD4B")
          ("FIXME"   . "#F43633")
          ("NOTE"           . "#8ED34E")
          ("DEPRECATED"     . "#7F7F7F")
          ("HACK"           . "#7D5587")
          ("REVIEW"         . "#3DADC6")
          ("OHGODTHEHORROR"   . "#FC7702"))))

;; Set tab width to 4 spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;; enable case insensitive matching for 'auto-mode-alist'
;; see https://www.gnu.org/software/emacs/manual/html_node/emacs/Choosing-Modes.html
;; disabled by doom-start.el
(setq auto-mode-case-fold t)

;; work around emacs hanging when opening any python requirements.txt file
;; see issue https://github.com/doomemacs/doomemacs/issues/5998
;;  (advice-add #'pip-requirements-fetch-packages :override #'ignore)

(use-package! auto-virtualenv
  :config
  ;;(setq auto-virtualenv-verbose t)
  (setq auto-virtualenv-reload-lsp t)
  (auto-virtualenv-setup))

;; justfile recipe execution
(use-package! justl
  :config
  (map! :leader
        (:prefix ("j" . "justl")
         :desc "Open the justl buffer"
         "j" 'justl
         :desc "List and execute recipes"
         "e" 'justl-exec-recipe-in-dir))
  (map! :n "e" 'justl-exec-recipe))

;; quit doom without confirmation
;; https://github.com/doomemacs/doomemacs/issues/2688#issuecomment-596684817
(setq confirm-kill-emacs nil)

;; comment/uncomment keybinding
(map! :leader
      (:prefix ("t")
       :desc "Comment/Uncomment region"
       "k" 'comment-or-uncomment-region
       :desc "Sort lines"
       "s" 'sort-lines))

;; Quit Emacs with SPC-q-f
;; Original keybinding quits the current frame
;; I'm used to this keybinding exiting emacs and get confused when that is not the case
(map! :leader
      (:prefix ("q")
       :desc "Quit Emacs"
       "f" 'evil-quit-all))

;; set yaml indentation
(setq-hook! 'yaml-ts-mode-hook yaml-indent 2)
(setq-hook! 'yaml-ts-mode-hook yaml-indent-offset 2)

;; set mode for systemd files
(add-to-list 'auto-mode-alist '("\\.service\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.timer\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.target\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.mount\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.automount\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.slice\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.socket\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.path\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.netdev\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.network\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.link\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.pod\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.container\\'" . conf-unix-mode))

;; Corfu configuration
(setq corfu-auto        t
      corfu-auto-delay  0.1
      corfu-auto-prefix 2)
(add-hook! 'corfu-mode-hook
           ;; Settings only for Corfu
           ;; (setq-local completion-styles '(basic orderless)
           ;;             completion-category-overrides nil
           ;;             completion-category-defaults nil)
           ;; Cape (used by corfu) configuration
           (setq-local completion-at-point-functions
                       (mapcar #'cape-company-to-capf
                               (list #'company-ansible)))
           )
;; (add-hook 'corfu-mode-hook
;;           (lambda ()
;;             ;; Settings only for Corfu
;;             ;; (setq-local completion-styles '(basic orderless)
;;             ;;             completion-category-overrides nil
;;             ;;             completion-category-defaults nil)
;;             ;; Cape (used by corfu) configuration
;;             (setq-local completion-at-point-functions
;;                         (mapcar #'cape-company-to-capf
;;                                 (list #'company-ansible)))
;;             ))

;; gleam-mode
(use-package! gleam-ts-mode
  :mode (rx ".gleam" eos))

(after! treesit
  (add-to-list 'auto-mode-alist '("\\.gleam$" . gleam-ts-mode)))

(after! gleam-ts-mode
  (unless (treesit-language-available-p 'gleam)
    (gleam-ts-install-grammar)))

;; Eglot LSP
;; Documentation: https://discourse.doomemacs.org/t/set-up-lsp-mode-or-eglot-for-insert-language-here/62#how-to-use-a-custom-server-12
;; powershell
;; (set-eglot-client! 'powershell-mode '("pwsh" "-NoLogo" "-NoProfile" "-Command" "/opt/powershell-editor-services/PowerShellEditorServices/Start-EditorServices.ps1" "-HostName" "Emacs" "-HostProfileId" "Emacs" "-HostVersion" "1.0.0" "-Stdio"))
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               `(powershell-mode . ,(eglot-alternatives
                                     '(("pwsh" "-NoLogo" "-NoProfile" "-Command" "/opt/powershell-editor-services/PowerShellEditorServices/Start-EditorServices.ps1" "-HostName" "Emacs" "-HostProfileId" "Emacs" "-HostVersion" "1.0.0" "-Stdio"))))))
;; fish
(set-eglot-client! 'fish-mode '("fish-lsp" "start"))
;; gleam
;; (set-eglot-client! 'gleam-ts-mode '("gleam" "lsp"))
(set-eglot-client! 'gleam-ts-mode '"gleam" "lsp")
;; ansible
;; (set-eglot-client! '(yaml-ts-mode yaml-mode) '("ansible-language-server" "--stdio"))
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               `((yaml-ts-mode yaml-mode) . ,(eglot-alternatives
                                              '(("ansible-language-server" "--stdio"))))))

;; python hook use ruff as formatter (disable lsp format)
(setq-hook! 'python-mode-hook +format-with 'ruff)

;; yaml hook use prettier-yaml as formatter (disable lsp format)
(setq-hook! 'yaml-ts-mode-hook +format-with 'prettier-yaml)

;; json hook use prettier-json as formatter (disable lsp format)
(setq-hook! 'json-mode-hook +format-with 'prettier-json)

;; markdown hook use prettier-markdown as formatter
(setq-hook! 'markdown-mode-hook +format-with 'prettier-markdown)

;; terraform/tofu files formatter
(after! terraform-mode
  (set-formatter! 'tofu'("terraform" "fmt" "-") :modes '(terraform-mode)))
(setq-hook! 'terraform-mode-hook +format-with 'tofu)

;; set mode for awx files
(add-to-list 'auto-mode-alist '("\\.awx\\'" . yaml-ts-mode))

;; enable ansible-mode for yaml
(add-hook! 'yaml-ts-mode-hook 'ansible-mode)
