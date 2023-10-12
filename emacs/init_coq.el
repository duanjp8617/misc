;; -----------------------------------------------------------------------------
;; configure package installations, from: emacs from scratch
;; -----------------------------------------------------------------------------
(require 'package)

;; set up the package-archives
(setq package-archives '(("gnu"    . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"  . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

;; or use the following configurations outside of china
;;(setq package-archives '(("melpa" . "https://melpa.org/packages/")
;;                         ("org" . "https://orgmode.org/elpa/")
;;                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; You should be able to use require, yes, but only after running package-initialize
;; (in Emacs≥27, this is done for you before the beginning of the .emacs file)
(package-initialize)

;; refresh the archive contents defined in the 'package-archives
(unless package-archive-contents
  (package-refresh-contents))

;; install use-package, as the packages will be installed with use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; load use-package
(require 'use-package)
(setq use-package-always-ensure t)


;; -----------------------------------------------------------------------------
;; Better Defaults - General, from: https://github.com/KaratasFurkan/.emacs.d
;; -----------------------------------------------------------------------------
(setq-default
  ring-bell-function 'ignore                    ; prevent beep sound.
  ;; inhibit-startup-screen t                   ; TODO: maybe better on early-init or performance?
  ;; initial-major-mode 'fundamental-mode       ; TODO: maybe better on early-init or performance?
  ;; initial-scratch-message nil                ; TODO: maybe better on early-init?
  create-lockfiles nil                          ; .#locked-file-name
  confirm-kill-processes nil                    ; exit emacs without asking to kill processes
  backup-by-copying t                           ; prevent linked files
  require-final-newline t                       ; always end files with newline
  delete-old-versions t                         ; don't ask to delete old backup files
  revert-without-query '(".*")                  ; `revert-buffer' without confirmation
  uniquify-buffer-name-style 'forward           ; non-unique buffer name display:
                                                ; unique-part/non-unique-filename
  fast-but-imprecise-scrolling t                ; supposed to make scrolling faster zon hold
  window-resize-pixelwise t                     ; correctly resize windows by pixels (e.g. in split-window
                                                ; functions)
  native-comp-async-report-warnings-errors nil  ; disable annoying native-comp warnings
  ad-redefinition-action 'accept                ; disable annoying "ad-handle-definition: ‘some-function’ got
                                                ; redefined" warnings
  use-short-answers t                           ; e.g. `y-or-n-p' instead of `yes-or-no-p'
  help-enable-symbol-autoload t)                ; perform autoload if docs are missing from autoload objects.

(global-auto-revert-mode)                       ; keep buffers sync with the files on the disk

(save-place-mode)                               ; When you visit a file, point goes to the last place where it
                                                ; was when you previously visited the same file

;; -----------------------------------------------------------------------------
;; Set up a directory for storing backup files
;; -----------------------------------------------------------------------------
(setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))

;; -----------------------------------------------------------------------------
;; Apparence, from: https://github.com/KaratasFurkan/.emacs.d
;; -----------------------------------------------------------------------------
;; Better Defaults
(global-hl-line-mode)
(blink-cursor-mode -1)

(setq-default
  ;;truncate-lines t
  frame-resize-pixelwise t             ; maximized emacs may not fit screen without this
  )

;; -----------------------------------------------------------------------------
;; Font, from https://github.com/KaratasFurkan/.emacs.d
;; -----------------------------------------------------------------------------
;; To install this font, download FiraCode.tar.xz from nerd-font git repo at:
;; https://github.com/ryanoasis/nerd-fonts/
;; decompress the file to ~/.fonts, and then update the fc-list with:
;; fc-cache -fv
(defconst fk/default-font-family "FiraCode Nerd Font Mono")
(defconst fk/default-font-size 100)
(defconst fk/default-icon-size 15)

(defconst fk/variable-pitch-font-family "Noto Serif")

(custom-set-faces
 `(default ((t (:family ,fk/default-font-family :height ,fk/default-font-size))))
 `(variable-pitch ((t (:family ,fk/variable-pitch-font-family :height 1.0))))
 ;; Characters with fixed pitch face do not shown when height is 90.
 `(fixed-pitch-serif ((t (:height 1.2)))))

;; -----------------------------------------------------------------------------
;; Font - custom functions and font size key bindings,
;; from https://github.com/KaratasFurkan/.emacs.d
;; -----------------------------------------------------------------------------
(defun fk/adjust-font-size (height)
  "Adjust font size by given height. If height is '0', reset font
size. This function also handles icons and modeline font sizes."
  (interactive "nHeight ('0' to reset): ")
  (let ((new-height (if (zerop height)
                        fk/default-font-size
                      (+ height (face-attribute 'default :height)))))
    (set-face-attribute 'default nil :height new-height)
    (set-face-attribute 'mode-line nil :height new-height)
    (set-face-attribute 'mode-line-inactive nil :height new-height)
    (message "Font size: %s" new-height)))

(defun fk/increase-font-size ()
  "Increase font size by 0.5 (5 in height)."
  (interactive)
  (fk/adjust-font-size 5))

(defun fk/decrease-font-size ()
  "Decrease font size by 0.5 (5 in height)."
  (interactive)
  (fk/adjust-font-size -5))

(defun fk/reset-font-size ()
  "Reset font size according to the `fk/default-font-size'."
  (interactive)
  (fk/adjust-font-size 0))

(global-set-key (kbd "C-=") 'fk/increase-font-size)
(global-set-key (kbd "C--") 'fk/decrease-font-size)
(global-set-key (kbd "C-0") 'fk/reset-font-size)

;; -----------------------------------------------------------------------------
;; line numbers: from emacs from scratch
;; -----------------------------------------------------------------------------
(column-number-mode)
(global-display-line-numbers-mode t)

;; Override some modes which derive from the above
(dolist (mode '(org-mode-hook
                term-mode-hook
                eshell-mode-hook
                shell-mode-hook
                treemacs-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; -----------------------------------------------------------------------------
;; scroll one line at a time (less "jumpy" than defaults)
;; -----------------------------------------------------------------------------
;; the following 3 configs are not needed for terminal usage
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq use-dialog-box nil) ;; Disable dialog boxes since they weren't working in Mac OSX

;; -----------------------------------------------------------------------------
;; Make ESC quit prompts
;; -----------------------------------------------------------------------------
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; -----------------------------------------------------------------------------
;; Tab Width
;; -----------------------------------------------------------------------------
;; use spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
;; (setq indent-line-function 'insert-tab)

;; -----------------------------------------------------------------------------
;; configure fill mode
;; -----------------------------------------------------------------------------
;; set the fill-column value to 110
(setq-default fill-column 110)

;; insert a ruler for certain modes
(dolist (mode '(prog-mode-hook))
  (add-hook mode (lambda () (display-fill-column-indicator-mode 1))))

;; enable auto-fill-mode for programming mode
(dolist (mode '(prog-mode-hook))
  (add-hook mode (lambda () (auto-fill-mode 1))))

;; enable visual-line-mode for text-based mode
;; it seems that visual-line-mode has conflicts with fci-mode, so they can be
;; enabled simultaneously
(dolist (mode '(text-mode-hook))
  (add-hook mode (lambda () (visual-line-mode 1))))

;; -----------------------------------------------------------------------------
;; highlight matching braces, from emacs from scratch
;; -----------------------------------------------------------------------------
;; it seems that in emacs 28.2, paren is automatically enabled by default
;; in lower version, may be you should enable paren to see the matching parens
(use-package paren
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))


;; -----------------------------------------------------------------------------
;; package setups
;; -----------------------------------------------------------------------------

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . ivy-switch-buffer)
         ("M-y" . counsel-yank-pop)
         ("C-x C-f" . counsel-find-file)))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
	(ivy-rich-mode 1))

(use-package which-key
  :diminish
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 1))

(use-package projectile
  :diminish
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map))

;; -----------------------------------------------------------------------------
;; configure counsel-projectile, from emacs from scratch
;; -----------------------------------------------------------------------------
;; By loading the counsel-project, it modifies the default behavior of projectile
;; by a little bit.
;; After "C-c p p", we will first select the project, and then select a file to work on.
;; The following are copied from Emacs from scratch series video
;; Quick searching with: counsel-projectile-rg-C-c p s r (require "apt install ripgrep" on ubuntu)
;; Results to buffer with "C-c C-o"
;; select line to jump with "enter", quit the rg window with "q"
(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; invoke with M-x magit-status
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package dired
  :ensure nil
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-AGFhlv --group-directories-first --time-style=long-iso")))

(use-package dired-subtree
  :ensure t
  :after dired
  :custom (dired-subtree-use-backgrounds nil)
  :bind (:map dired-mode-map
              ("<tab>" . dired-subtree-toggle)
              ("<C-tab>". dired-subtree-cycle)))

;; Major mode for OCaml programming
;; seems to have an error when compiling ocamldebug.el, but overall it works
;; fine
(use-package tuareg
  :ensure t
  :mode (("\\.ocamlinit\\'" . tuareg-mode)))

;; Major mode for editing Dune project files
(use-package dune
  :ensure t)

;; Merlin provides advanced IDE features
(use-package merlin
  :ensure t
  :config
  (add-hook 'tuareg-mode-hook #'merlin-mode)
  (add-hook 'merlin-mode-hook #'company-mode)
  ;; we're using flycheck instead
  (setq merlin-error-after-save nil))

(use-package merlin-eldoc
  :ensure t
  :hook ((tuareg-mode) . merlin-eldoc-setup))

;; This uses Merlin internally
(use-package flycheck-ocaml
  :ensure t
  :config
  (flycheck-ocaml-setup))