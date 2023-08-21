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
;; (in Emacs≥27, this is done for you before the beginning of the .emacs file).
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
;; Garbage Collection, from: https://github.com/KaratasFurkan/.emacs.d
;; -----------------------------------------------------------------------------
;; Make startup faster by reducing the frequency of garbage collection. Set
;; gc-cons-threshold (the default is 800 kilobytes) to maximum value available,
;; to prevent any garbage collection from happening during load time.

;; Note: tangle to early-init.el to make startup even faster
(setq gc-cons-threshold most-positive-fixnum)

;; Restore it to reasonable value after init. Also stop garbage collection during
;; minibuffer interaction (helm etc.).
(defconst 1mb 1048576)
(defconst 20mb 20971520)
(defconst 30mb 31457280)
(defconst 50mb 52428800)

(defun fk/defer-garbage-collection ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun fk/restore-garbage-collection ()
  (run-at-time 1 nil (lambda () (setq gc-cons-threshold 30mb))))

(add-hook 'emacs-startup-hook 'fk/restore-garbage-collection 100)
(add-hook 'minibuffer-setup-hook 'fk/defer-garbage-collection)
(add-hook 'minibuffer-exit-hook 'fk/restore-garbage-collection)

(setq read-process-output-max 1mb)  ;; lsp-mode's performance suggest

;; -----------------------------------------------------------------------------
;; from: https://github.com/KaratasFurkan/.emacs.d
;; -----------------------------------------------------------------------------
;; Resizing the Emacs frame can be a terribly expensive part of changing the
;; font. By inhibiting this, we easily halve startup times with fonts that are
;; larger than the system default.
;; (setq frame-inhibit-implied-resize t)

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
 uniquify-buffer-name-style 'forward           ; non-unique buffer name display: unique-part/non-unique-filename
 fast-but-imprecise-scrolling t                ; supposed to make scrolling faster on hold
 ;; window-resize-pixelwise t                  ; correctly resize windows by pixels (e.g. in split-window
																							 ; functions)
 native-comp-async-report-warnings-errors nil  ; disable annoying native-comp warnings
 ad-redefinition-action 'accept                ; disable annoying "ad-handle-definition: ‘some-function’ got
																							 ; redefined" warnings
 use-short-answers t                           ; e.g. `y-or-n-p' instead of `yes-or-no-p'
 help-enable-symbol-autoload t)                ; perform autoload if docs are missing from autoload objects.
(global-auto-revert-mode)                      ; keep buffers sync with the files on the disk
(save-place-mode)                              ; When you visit a file, point goes to the last place where it
																							 ; was when you previously visited the same file
;; (global-so-long-mode)                          ; better handling files with long lines?

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
 ;; frame-resize-pixelwise t             ; maximized emacs may not fit screen without this
 frame-title-format '("Emacs | %b"))  ; Emacs | buffer-name

;; -----------------------------------------------------------------------------
;; configure emacs basic ui: from emacs from scratch
;; -----------------------------------------------------------------------------
;; basic ui configure
(setq inhibit-startup-message t)  ; Remove the start up message
(scroll-bar-mode -1)              ; Disable visible scrollbar
(tool-bar-mode -1)                ; Disable the toolbar
(tooltip-mode -1)                 ; Disable tooltips
(set-fringe-mode 10)              ; Give some breathing room
(menu-bar-mode -1)                ; Disable the menu bar 

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
    (message "Font size: %s" new-height))
  (let ((new-size (if (zerop height)
                      fk/default-icon-size
                    (+ (/ height 5) treemacs--icon-size))))
    (when (fboundp 'treemacs-resize-icons)
      (treemacs-resize-icons new-size))
    (when (fboundp 'company-box-icons-resize)
      (company-box-icons-resize new-size)))
  ;; (when diff-hl-mode
  ;;   (diff-hl-maybe-redefine-bitmaps))
	)

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
;; Set frame transparency and maximize windows by default.
;; -----------------------------------------------------------------------------
;; disable transparency settings as I found it annoying
;; (set-frame-parameter (selected-frame) 'alpha '(90 . 90))
;; (add-to-list 'default-frame-alist '(alpha . (90 . 90)))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

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
;; Configure window movement
;; -----------------------------------------------------------------------------
(global-set-key [M-left] 'windmove-left)          ; move to left window
(global-set-key [M-right] 'windmove-right)        ; move to right window
(global-set-key [M-up] 'windmove-up)              ; move to upper window
(global-set-key [M-down] 'windmove-down)          ; move to lower window

;; -----------------------------------------------------------------------------
;; Tab Width
;; -----------------------------------------------------------------------------
(setq-default tab-width 2)

;; -----------------------------------------------------------------------------
;; configure tab-bar-mode
;; -----------------------------------------------------------------------------
(tab-bar-mode)
(setq tab-bar-new-tab-choice "*scratch*")
(setq tab-bar-new-tab-to 'rightmost)
;; hide tab buttons
(setq tab-bar-close-button-show nil
			 tab-bar-new-button-show nil)
;; show tab numbers
(setq tab-bar-tab-hints t)
(setq tab-bar-format '(tab-bar-format-tabs tab-bar-separator))
;; move tab bar with "M-[" and "M-]"
(global-set-key (kbd "M-[") 'tab-bar-switch-to-prev-tab)
(global-set-key (kbd "M-]") 'tab-bar-switch-to-next-tab)

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
;; command-log-mode, from emacs from scratch
;; M-x globa-command-log-mode        ;enable this to see all the commands
;; M-x clm/toggle-command-log-buffer ;show a command log buffer
;; -----------------------------------------------------------------------------
;; (use-package command-log-mode)

;; -----------------------------------------------------------------------------
;; set up ivy completion engine, from emacs from scratch
;; -----------------------------------------------------------------------------
;; ivy and swipper are part of counsel, so we install counsel here first
(use-package counsel
  :ensure t)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
				 ;; we don't use evil mode, so default key binding is fine
         ;; :map ivy-minibuffer-map
         ;; ("TAB" . ivy-alt-done)	
         ;; ("C-l" . ivy-alt-done)
         ;; ("C-j" . ivy-next-line)
         ;; ("C-k" . ivy-previous-line)
         ;; :map ivy-switch-buffer-map
         ;; ("C-k" . ivy-previous-line)
         ;; ("C-l" . ivy-done)
         ;; ("C-d" . ivy-switch-buffer-kill)
         ;; :map ivy-reverse-i-search-map
         ;; ("C-k" . ivy-previous-line)
         ;; ("C-d" . ivy-reverse-i-search-kill)
				 )
  :config
  (ivy-mode 1))

;; -----------------------------------------------------------------------------
;; configure counsel, from emacs from scratch
;; -----------------------------------------------------------------------------
(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ;; ("C-x b" . counsel-ibuffer)
				 ;; the counsel-find-file defaults to the current dired
				 ;; directory
         ("C-x C-f" . counsel-find-file)
				 ;; counsel-minibufer-history mapping does not work
         ;; :map minibuffer-local-map
         ;; ("C-r" . 'counsel-minibuffer-history)
	))

;; -----------------------------------------------------------------------------
;; enable ivy-rich, from emacs from scratch
;; -----------------------------------------------------------------------------
(use-package ivy-rich
  :init
	(ivy-rich-mode 1))

;; -----------------------------------------------------------------------------
;; enable nerd-icons
;; -----------------------------------------------------------------------------
;; we should pre-install Symbols Nerd Font Mono first
(use-package nerd-icons
  :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  (nerd-icons-font-family "Symbols Nerd Font Mono"))

;; -----------------------------------------------------------------------------
;; enable doom-modeline, from emacs from scratch
;; -----------------------------------------------------------------------------
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 25)))

;; -----------------------------------------------------------------------------
;; enable doom-themes, from emacs from scratch
;; -----------------------------------------------------------------------------
(use-package doom-themes
  :init (load-theme 'doom-dracula t))

;; -----------------------------------------------------------------------------
;; enable which-key, from emacs from scratch
;; -----------------------------------------------------------------------------
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

;; -----------------------------------------------------------------------------
;; configure help, from emacs from scratch
;; -----------------------------------------------------------------------------
;; it enhances the emacs help manuals
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; -----------------------------------------------------------------------------
;; configure dockerfile-mode, from https://github.com/KaratasFurkan/.emacs.d
;; -----------------------------------------------------------------------------
;; it messes up the init.el file after buffer evaluation, so use with caution
(use-package dockerfile-mode
  :mode "Dockerfile\\'")

;; -----------------------------------------------------------------------------
;; configure markdown-mode, from https://github.com/KaratasFurkan/.emacs.d
;; -----------------------------------------------------------------------------
(use-package markdown-mode
  :mode "\\.md\\'"
  :custom (markdown-header-scaling t))

;; -----------------------------------------------------------------------------
;; configure projectile, from emacs from scratch
;; -----------------------------------------------------------------------------
;; 1. projectile treats all the git directories with commits as projects under the configured search path
;; 2. the following configuration binds "C-c p" to invoke projectile. The which-key package can show the
;; details of how projectile works.
;; 3. "C-c p p" switches between different projects under the search path and use dired to show the project
;; directory structure
;; 4. "C-c p f" finds files within the current project.
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  ;; (when (file-directory-p "~/workspace")
	;; 	(setq projectile-project-search-path '("~/workspace")))
	(setq projectile-project-search-path '("~/workspace"))
  ;; (setq projectile-switch-project-action #'projectile-dired)
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

;; -----------------------------------------------------------------------------
;; configure magit, from emacs from scratch
;; -----------------------------------------------------------------------------
;; This can be extremly useful for configuring the git commit messages,
;; but it can take some time before I can figure it out.
;; Also, doing git in china is a pain in the butt, so I might need to mix
;; the workflow of magit with shell command (which can bypass firewalls with proxies).
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; -----------------------------------------------------------------------------
;; configure dired
;; -----------------------------------------------------------------------------
(use-package dired
  :ensure nil
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-AGFhlv --group-directories-first --time-style=long-iso")))

;; -----------------------------------------------------------------------------
;; configure dired-subtree
;; -----------------------------------------------------------------------------
;; (use-package dired-subtree
;; 	:ensure t
;; 	:after dired
;;   :custom (dired-subtree-use-backgrounds nil)
;;   :bind (:map dired-mode-map
;; 							("<tab>" . dired-subtree-toggle)
;; 							("<C-tab>". dired-subtree-cycle)
;; 							("<backtab>" . dired-subtree-remove)))

;; -----------------------------------------------------------------------------
;; configure treemacs
;; -----------------------------------------------------------------------------
;; fix a problem related with "Invalid image type 'svg'"
;; see https://github.com/Alexander-Miller/treemacs/issues/1017
(add-to-list 'image-types 'svg) 

;; treemacs seems to be a better substitute for dired
;; use "M-x treemacs-toggle-fixed-width" to unlock the ability to change window width
(use-package treemacs
	:ensure t
	:config
	(setq treemacs-is-never-other-window t)
	:bind (:map global-map
				  ([f5] . treemacs)
				  ([f6] . treemacs-select-window)))

;; -----------------------------------------------------------------------------
;; lsp basic configurations, from emacs from scratch
;; -----------------------------------------------------------------------------
;; show a nice-looking banner at the top
(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

;; configure lsp-mode
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

;; use lsp-ui
(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

;; use lsp-ivy
(use-package lsp-ivy)

;; auto-completion with company
(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

;; use company-box to improve the ui of the company pop-up
(use-package company-box
  :hook (company-mode . company-box-mode))

;; -------------------------------------------------
;; tips: open multiple shells
;; -------------------------------------------------
;; use "M-x eshell" and "M-x rename-buffer" to open multiple eshells

;; -------------------------------------------------
;; tips: window management
;; -------------------------------------------------
;; 1. enlarge window with a specified column:
;; "C-u 7" follwed by "C-x {/}", here "C-u" provides a universal argument
;; 2. "C-x 4" provides some additional commands to operate the windows
;;    Useful commands include:
;;    - "C-x 4 C-j": dired-jump-other-window
;;    - "C-x 4 d": dired-other-window
;; 3. "C-x +" balances all the opened windows
;; 4. "M-PgUp" and "M-PgDn" moves the other window without focusing it.
;; 5. "M-x windmove-swap-states-up/down/left/right" 

;; -------------------------------------------------
;; tips: tab bar mode
;; -------------------------------------------------
;; 1. "M-x tab-bar-mode" to enable tab bar mode
;; 2. use "C-x t" to operate on the tabs
;; 3. "C-x t RET" seems to work better
;; 4. in my current configuration, doom-modeline will show the tab number on the left

;; -------------------------------------------------
;; tips: dired
;; -------------------------------------------------
;; 1. use "C-x d" to enter the dired-by-name mode
;; 2. when open a file, use "C-x C-j" to jump to the root directory owning this file in dire.
;; 3. in dire window, use "^" to go up one layer of directory
