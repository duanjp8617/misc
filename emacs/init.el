;; -------------------------------------------------
;; configure emacs basic ui
;; -------------------------------------------------
;; remove the start up message
(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)          ; Disable the menu bar 
(setq visible-bell t)       ; Set up the visible bell

;; change font to "Fira Code Retina"
;; On Ubuntu, we need to install the font via "apt install fonts-firacode"
(set-face-attribute 'default nil :font "Fira Code Retina" :height 150)

;; load a basic theme, consider replacing it with doom-theme
(load-theme 'wombat)

;; -------------------------------------------------
;; Make ESC quit prompts
;; -------------------------------------------------
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

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
;; command-log-mode
;; M-x clm/toggle-command-log-buffer ;show a command log buffer
;; M-x globa-command-log-mode        ;enable this to see all the commands
;; -------------------------------------------------
(use-package command-log-mode)

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
;; Set frame transparency and maximize windows by default.
;; temporarily disable by default as I find it to be ineffective
;; -------------------------------------------------
;; (set-frame-parameter (selected-frame) 'alpha '(90 . 90))
;; (add-to-list 'default-frame-alist '(alpha . (90 . 90)))
;; (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
;; (add-to-list 'default-frame-alist '(fullscreen . maximized))

;; -------------------------------------------------
;; highlight matching braces
;; -------------------------------------------------
(use-package paren
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))

;; ;; 
;; (show-paren-mode 1)
;; (setq show-paren-delay 0)

;; ;; ivy and swipper are part of counsel, so we install counsel here first
;; (use-package counsel
;;   :ensure t)

;; (use-package ivy
;;   :diminish
;;   :bind (("C-s" . swiper))
;;   :config
;;   (ivy-mode 1))

;; ;; enable doom-modeline
;; (use-package doom-modeline
;;   :ensure t
;;   :init (doom-modeline-mode 1)
;;   :custom ((doom-modeline-height 15)
;;            (doom-modeline-icon nil)))
