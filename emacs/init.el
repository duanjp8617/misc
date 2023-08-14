;; -------------------------------------------------
;; configure emacs basic ui
;; -------------------------------------------------
;; basic ui configure
(setq inhibit-startup-message t)  ; Remove the start up message
(scroll-bar-mode -1)              ; Disable visible scrollbar
(tool-bar-mode -1)                ; Disable the toolbar
(tooltip-mode -1)                 ; Disable tooltips
(set-fringe-mode 10)              ; Give some breathing room
(menu-bar-mode -1)                ; Disable the menu bar 
(setq visible-bell t)             ; Set up the visible bell

;; change font to "FiraCode Nerd Font Mono"
;; To install this font, download FiraCode.tar.xz from nerd-font git repo at:
;; https://github.com/ryanoasis/nerd-fonts/
;; decompress the file to ~/.fonts, and then update the fc-list with:
;; fc-cache -fv
(set-face-attribute 'default nil :font "FiraCode Nerd Font Mono" :height 120)

;; Set frame transparency and maximize windows by default.
;; disable transparency settings as I found it annoying
;; (set-frame-parameter (selected-frame) 'alpha '(90 . 90))
;; (add-to-list 'default-frame-alist '(alpha . (90 . 90)))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; -------------------------------------------------
;; line numbers
;; -------------------------------------------------
(column-number-mode)
(global-display-line-numbers-mode t)

;; Override some modes which derive from the above
(dolist (mode '(org-mode-hook
								term-mode-hook
								eshell-mode-hook
							  shell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; -------------------------------------------------
;; scroll one line at a time (less "jumpy" than defaults)
;; -------------------------------------------------
;; the following 3 configs are not needed for terminal usage
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq use-dialog-box nil) ;; Disable dialog boxes since they weren't working in Mac OSX

;; -------------------------------------------------
;; Make ESC quit prompts
;; -------------------------------------------------
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; -------------------------------------------------
;; Configure window movement
;; -------------------------------------------------
(global-set-key [M-left] 'windmove-left)          ; move to left window
(global-set-key [M-right] 'windmove-right)        ; move to right window
(global-set-key [M-up] 'windmove-up)              ; move to upper window
(global-set-key [M-down] 'windmove-down)          ; move to lower window

;; -------------------------------------------------
;; Tab Width
;; -------------------------------------------------
(setq-default tab-width 2)

;; -------------------------------------------------
;; configure package installations
;; -------------------------------------------------
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

;; -------------------------------------------------
;; highlight matching braces
;; -------------------------------------------------
;; it seems that in emacs 28.2, paren is automatically enabled by default
;; in lower version, may be you should enable paren to see the matching parens
(use-package paren
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))

;; -------------------------------------------------
;; command-log-mode
;; M-x globa-command-log-mode        ;enable this to see all the commands
;; M-x clm/toggle-command-log-buffer ;show a command log buffer
;; -------------------------------------------------
(use-package command-log-mode)

;; -------------------------------------------------
;; set up ivy completion engine
;; -------------------------------------------------
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

;; -------------------------------------------------
;; enable nerd-icons
;; -------------------------------------------------
;; we should pre-install Symbols Nerd Font Mono first
(use-package nerd-icons
  :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  (nerd-icons-font-family "Symbols Nerd Font Mono"))

;; -------------------------------------------------
;; enable doom-modeline
;; -------------------------------------------------
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 25)))

;; -------------------------------------------------
;; enable doom-themes
;; -------------------------------------------------
(use-package doom-themes
  :init (load-theme 'doom-dracula t))

;; -------------------------------------------------
;; enable which-key
;; -------------------------------------------------
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

;; -------------------------------------------------
;; enable which-key
;; -------------------------------------------------
(use-package ivy-rich
  :init
	(ivy-rich-mode 1))

;; -------------------------------------------------
;; configure counsel
;; -------------------------------------------------
(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
				 ;; counsel-minibufer-history mapping does not work
         ;; :map minibuffer-local-map
         ;; ("C-r" . 'counsel-minibuffer-history)
	))

;; -------------------------------------------------
;; configure help
;; -------------------------------------------------
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

;; -------------------------------------------------
;; configure dockerfile-mode
;; -------------------------------------------------
;; it messes up the init.el file after buffer evaluation, so use with caution
;; (use-package dockerfile-mode
;; 	:config (dockerfile-mode))
;; ;; dockerfile-mode adds its only regexp matching to the auto-mode-alist
;; (add-to-list 'auto-mode-alist '("\\(.+\.Dockerfile\\|Dockerfile\..+\\)" . dockerfile-mode))

;; -------------------------------------------------
;; configure projectile
;; -------------------------------------------------
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
  ;; (setq projectile-project-search-path '("~/workspace")))
	(setq projectile-project-search-path '("~/"))
  (setq projectile-switch-project-action #'projectile-dired))

;; -------------------------------------------------
;; configure counsel-projectile
;; -------------------------------------------------
;; By loading the counsel-project, it modifies the default behavior of projectile
;; by a little bit.
;; After "C-c p p", we will first select the project, and then select a file to work on.
;; The following are copied from Emacs from scratch series video
;; Quick searching with: counsel-projectile-rg-C-c p s r (require "apt install ripgrep" on ubuntu)
;; Results to buffer with "C-c C-o"
;; select line to jump with "enter", quit the rg window with "q"
(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; This can be extremly useful for configuring the git commit messages,
;; but it can take some time before I can figure it out.
;; Also, doing git in china is a pain in the butt, so I might need to mix
;; the workflow of magit with shell command (which can bypass firewalls with proxies).
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))
