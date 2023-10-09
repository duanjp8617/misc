(require 'package)
(setq package-archives '(("gnu"    . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"  . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(setq-default
  ring-bell-function 'ignore
  create-lockfiles nil
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
(global-auto-revert-mode)                     
(save-place-mode)                               
(setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))

(global-hl-line-mode)
(blink-cursor-mode -1)

(setq inhibit-startup-message t)  ; Remove the start up message
(scroll-bar-mode -1)              ; Disable visible scrollbar
(tool-bar-mode -1)                ; Disable the toolbar
(tooltip-mode -1)                 ; Disable tooltips
(set-fringe-mode 10)              ; Give some breathing room
(menu-bar-mode -1)                ; Disable the menu bar 



;; (defconst fk/default-font-family "FiraCode Nerd Font Mono")
(defconst fk/default-font-size 100)
(defconst fk/default-icon-size 15)

;; (custom-set-faces
;;  `(default ((t (:family ,fk/default-font-family :height ,fk/default-font-size))))
;;  ;; Characters with fixed pitch face do not shown when height is 90.
;;  `(fixed-pitch-serif ((t (:height 1.2)))))

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



(column-number-mode)
(global-display-line-numbers-mode t)
(dolist (mode '(org-mode-hook
                term-mode-hook
                eshell-mode-hook
                shell-mode-hook
                treemacs-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq use-dialog-box nil) ;; Disable dialog boxes since they weren't working in Mac OSX

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

(setq-default fill-column 110)
(dolist (mode '(prog-mode-hook))
  (add-hook mode (lambda () (display-fill-column-indicator-mode 1))))
(dolist (mode '(prog-mode-hook))
  (add-hook mode (lambda () (auto-fill-mode 1))))
(dolist (mode '(text-mode-hook))
  (add-hook mode (lambda () (visual-line-mode 1))))

(use-package paren
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))

(use-package doom-themes
  :init (load-theme 'doom-dracula t))
;; (use-package doom-modeline
;;   :ensure t
;;   :init (doom-modeline-mode 1)
;;   :custom ((doom-modeline-height 25)))



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
  ("C-c p" . projectile-command-map)
  ;; :init
  ;; (setq projectile-project-search-path '("/root"))
  )

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


;; load tuareg and merlin site files
;; The prefix prior to "/emacs/site-lisp" is generated with "opam var share"
;; (load "/root/.opam/4.14.0/share/emacs/site-lisp/tuareg-site-file")
;; (push "/root/.opam/4.14.0/share/emacs/site-lisp" load-path)
;; (autoload 'merlin-mode "merlin" "Merlin mode" t)
;; (add-hook 'tuareg-mode-hook #'merlin-mode)
;; (add-hook 'caml-mode-hook #'merlin-mode)

(use-package proof-general)
(use-package company-coq)
(add-hook 'coq-mode-hook #'company-coq-mode)



