;; .emacs.d/init.el

;; ===================================
;; MELPA Package Support
;; ===================================
;; Enables basic packaging support
(require 'package)

;; Emacs comes with package.el for installing packages.
;; Try M-x list-packages to see what's available
;; Adds the Melpa and org archive to the list of available repositories
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")
			 ("elpa" . "https://elpa.gnu.org/packages/")
			 ))


;; Initializes the package infrastructure
;; Load and activate emacs packages. Do this first so that the
;; packages are loaded before you start trying to modify them.
;; This also sets the load path.
(package-initialize)

;; If there are no archived package contents, refresh them
;; Download the ELPA archive description if needed.
;; This informs Emacs about the latest versions of all packages, and
;; makes them available for download.
(when (not package-archive-contents)
  (package-refresh-contents))


;; ==================================
;; use-package
;; macro for isolating package configuration in init.el file
;; ==================================

(when (not (package-installed-p 'use-package))  ;; ensure use-package is installed
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package)
  (setq use-package-verbose t))


;; ===================================
;; UI Customization
;; ===================================

(setq inhibit-startup-message t)    ;; Hide the startup message
(setq inhibit-splash-screen t)      ;; Disable the splash screen (to enable it agin, replace the t with 0)
(global-visual-line-mode t)         ;; all documents are word-wrapped

;; Window size
(setq default-frame-alist
      '((top . 200) (left . 400)
        (width . 100) (height . 80)        
	))
(setq initial-frame-alist '((top . 10) (left . 30)))

;; Frame customization
(tool-bar-mode -1)                  ;; Hide toolbar
(scroll-bar-mode -1)                ;; Hide scroll bar
(set-window-margins (selected-window) 2 2)    ;; add left/right padding

;; load material theme
(use-package material-theme
  :ensure t
  :config
  (load-theme 'material t)
  )

;;get nice icons in modeline
(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))


;; INTERACTION -----
(setq use-short-answers t)             ;; When emacs asks for "yes" or "no", let "y" or "n" suffice
(setq confirm-kill-emacs 'yes-or-no-p) ;; Confirm to quit

;; Uses system trash rather than deleting forever
(setq trash-directory  "~/.Trash")
(setq delete-by-moving-to-trash t)

;; set up some better emacs defaults
(use-package better-defaults
  :ensure t)


;; ==================================
;; Bindings
;; ==================================

;; Mac configuration/Compatibility
(setq mac-command-modifier       'super
      mac-option-modifier        'meta
      mac-control-modifier       'control
      mac-right-command-modifier  nil
      mac-right-option-modifier  'hyper)

;; Scrolling
(global-set-key (quote [s-down]) (quote scroll-up-line))
(global-set-key (quote [s-up]) (quote scroll-down-line))

;; Preserve the cursor position relative to the screen when scrolling
(setq scroll-preserve-screen-position 'always)

;; Move up/down paragraph
(global-set-key (kbd "M-n") #'forward-paragraph)
(global-set-key (kbd "M-p") #'backward-paragraph)


;; ==================================
;; helpful coding packages
;; ==================================

;; autocomplete
(use-package company
  :ensure t
  )

;; minor mode to keep code always indented
(use-package aggressive-indent
  :ensure t)

;; makes handling lisp expressions much, much easier
;; keeps parentheses balanced
;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
(use-package paredit
  :ensure t
  :bind
  (:map paredit-mode-map
	("M-r" . nil))
  ("M-R" . paredit-raise-sexp)
  (:map paredit-mode-map 
	("RET" . nil))
  )

;; colorful parenthesis matching
(use-package rainbow-delimiters
  :ensure t)

;; git integration
(use-package magit
  :ensure t)

;; on-the-fly syntax checking
(use-package flycheck
  :ensure t)


;; =================================
;; emacs-lisp-mode customization
;; =================================
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'company-mode)
(add-hook 'emacs-lisp-mode-hook 'aggressive-indent-mode)
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)



;; =================================
;; python customization
;; =================================

;; emacs package for python editing
(use-package elpy
  :ensure t)

;; reformat python buffers using "black" formatter on save
(use-package blacken
  :ensure t)

;; Enable elpy
(elpy-enable)

;; Enable Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))



;; =================================
;; clojure customization
;; ================================

;; key bindings and code colorization for Clojure
;; https://github.com/clojure-emacs/clojure-mode
(use-package clojure-mode
  :ensure t
  :hook
  (clojure-mode . paredit-mode)
  (clojure-mode . rainbow-delimiters-mode)
  (clojure-mode . company-mode)
  (clojure-mode . linum-mode)
  (clojure-mode . aggressive-indent-mode)
  )

;; extra syntax highlighting for clojure
(use-package clojure-mode-extra-font-locking
  :ensure t)

;; integration with a Clojure REPL
;; https://github.com/clojure-emacs/cider
(use-package cider
  :ensure t
  :hook
  (cider-repl-mode . paredit-mode)
  (cider-repl-mode . rainbow-delimiters-mode)
  (cider-repl-mode . company-mode)
  (cider-repl-mode . linum-mode)
  (cider-mode . company-mode)
  (cider-repl-mode . aggressive-indent-mode)
  :pin melpa-stable)

;; one of the best clojure packages
(use-package clj-refactor
  :ensure t)




;; =================================
;; org customization
;; =================================

(defun org-mode-hide-stars ()
  (font-lock-add-keywords
   nil
   '(("^\\*+ "
      (0
       (prog1 nil
         (put-text-property (match-beginning 0) (match-end 0)
                            'face (list :foreground
                                        (face-attribute
                                         'default :background)))))))))
(use-package org
  :hook
  (org-mode . visual-line-mode)
  (org-mode . variable-pitch-mode)
  (org-mode . org-mode-hide-stars)
  :ensure t
  :config
  (setq org-ellipsis " ▼")
  (setq org-startup-indented t)
  (setq org-blank-before-new-entry t)
  (setq org-hide-stars t)
  )

;; ================================
;; Org Headings
;; The first one found in the system from the list below is used and the same font is used for the different levels, in varying sizes
;; https://github.com/zzamboni/dot-emacs/blob/master/init.org#beautifying-org-mode
;; ================================
(require 'ox-md)
(let* ((variable-tuple
        (cond ((x-list-fonts   "ETBembo")         '(:font   "ETBembo"))
              ((x-list-fonts   "Source Sans Pro") '(:font   "Source Sans Pro"))
              ((x-list-fonts   "Lucida Grande")   '(:font   "Lucida Grande"))
              ((x-list-fonts   "Verdana")         '(:font   "Verdana"))
              ((x-family-fonts "Sans Serif")      '(:family "Sans Serif"))
              (nil (warn "Cannot find a Sans Serif Font."))))
       (base-font-color (face-foreground 'default nil 'default))
       (headline `(:inherit default :weight bold
			    :foreground ,base-font-color
			    )))

  (custom-theme-set-faces
   'user
   `(org-level-8        ((t (,@headline ,@variable-tuple))))
   `(org-level-7        ((t (,@headline ,@variable-tuple))))
   `(org-level-6        ((t (,@headline ,@variable-tuple))))
   `(org-level-5        ((t (,@headline ,@variable-tuple))))
   `(org-level-4        ((t (,@headline ,@variable-tuple
					:height 1.2
					:foreground "#e8d9c3"))))
   `(org-level-3        ((t (,@headline ,@variable-tuple
					:height 1.2
					:foreground "#e8d9c3"))))
   `(org-level-2        ((t (,@headline ,@variable-tuple
					:height 1.2
					:box nil
					:background nil
					:foreground "#e8d9c3"))))
   `(org-level-1        ((t (,@headline ,@variable-tuple
					:height 1.2
					:box nil					
					:background nil
					:foreground "#e8d9c3"))))
   `(org-headline-done  ((t (,@headline ,@variable-tuple :strike-through t))))
   `(org-document-title ((t (,@headline ,@variable-tuple
                                        :height 1.5 :underline nil))))
   `(variable-pitch ((t (:family "ETBembo" :height 180 :weight thin))))
   ;; `(fixed-pitch ((t (:family "Fira Code Retina" :height 160))))
   ;; `(org-hide ((t (:inherit fixed-pitch))))
   `(org-indent ((t (:inherit (org-hide fixed-pitch)))))
   )
  ;; (enable-them 'user)
  )


;; (set-face-attribute 'org-hide nil :inherit 'fixed-pitch)    ;; get the text under headers to also indent
(require 'cl)
(defun org-indent-use-stars-for-strings ()
  "Initialize the indentation strings with stars instead of spaces."
  (setq org-indent-strings (make-vector (1+ org-indent-max) nil))
  (aset org-indent-strings 0 nil)
  (loop for i from 1 to org-indent-max do
    (aset org-indent-strings i
          (org-add-props
          (concat (make-string (1- i) ?*) ; <- THIS IS THE ONLY CHANGE
              (char-to-string org-indent-boundary-char))
          nil 'face 'org-indent))))

(advice-add 'org-indent-initialize :after #'org-indent-use-stars-for-strings)

(use-package org-indent
  :ensure nil
  :diminish
  :custom
  (org-indent-indentation-per-level 4))


(use-package org-superstar
  :after org
  :ensure t
  :hook (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-headline-bullet-list '("⁖" "⁖" "○" "✸" "✿"))
  )


;; remove auto id generation
(defun html-body-id-filter (output backend info)
  "Remove random ID attributes generated by Org."
  (when (eq backend 'md)
    (replace-regexp-in-string
     "<a id=\"[[:alpha:]-]*org[[:alnum:]]\\{7\\}\"></a>"
     ""
     output t)))

(add-to-list 'org-export-filter-final-output-functions 'html-body-id-filter)



;; Set margins for modes

(use-package visual-fill-column
  :ensure t
  )


(use-package writeroom-mode
  :ensure t
  :hook org-mode
  :after org
  :config
  (setq writeroom-extra-line-spacing 6)
  (setq writeroom-fullscreen-effect nil)
  )

;; =================================
;; org roam customization
;; =================================

(use-package emacsql
  :ensure t)

(use-package emacsql-sqlite
  :ensure t)


(use-package org-roam
  :ensure t
  :after org
  :init
  (setq org-roam-v2-ack t)    ;; acknowledge V2 upgrade
  :custom
  (org-roam-directory "~/Documents/org_roam/")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("m" "main" plain
      "%?"
         :if-new (file+head "main/${slug}.org"
                            "#+title: ${title}\n")
         :immediate-finish t
         :unnarrowed t)
     ("r" "reference" plain
      "%?"
         :if-new
         (file+head "reference/${title}.org" "#+title: ${title}\n")
         :immediate-finish t
         :unnarrowed t)
     ("a" "article" plain
      "%?"
         :if-new
         (file+head "articles/${title}.org" "#+title: ${title}\n#+filetags: :article:\n")
         :immediate-finish t
         :unnarrowed t)))
  :bind (("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert)
         ("C-c n o" . org-id-get-create)
         ("C-c n t" . org-roam-tag-add)
         ("C-c n a" . org-roam-alias-add)
         ("C-c n l" . org-roam-buffer-toggle))
  :config
  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    (condition-case nil
	(file-name-nondirectory
	 (directory-file-name
	  (file-name-directory
	   (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (error "")))
  (setq org-roam-node-display-template
      (concat "${type:15} ${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (setq org-roam-db-location "~/.emacs.d/org-roam.db")
  ;; Org roam - run functions on file changes to maintain cache consistency
  (org-roam-db-autosync-mode)

  )

;; =================================
;; ein (emacs ipython notebook) customization
;; =================================

(use-package ein
  :ensure t)



;; ====================================
;; web-mode customization
;; ====================================

;; (require 'web-mode)
;; (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(use-package web-mode
  :ensure t
  :mode
  ("\\.phtml\\'" . web-mode)
  ("\\.tpl\\.php\\'" . web-mode)
  ("\\.[agj]sp\\'" . web-mode)
  ("\\.as[cp]x\\'" . web-mode)
  ("\\.erb\\'" . web-mode)
  ("\\.mustache\\'" . web-mode)
  ("\\.djhtml\\'" . web-mode)
  ("\\.html?\\'" . web-mode))

;; User-Defined init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-export-backends '(ascii html icalendar latex md odt))
 '(package-selected-packages
   '(aggressive-indent rainbow-delimiters queue all-the-icons clj-refactor cider clojure-mode-extra-font-locking clojure-mode paredit ein writeroom-mode web-mode use-package popup org-superstar org-roam material-theme markdown-mode magit impatient-mode flycheck f emacsql-sqlite elpy blacken better-defaults async)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-document-title ((t (:inherit default :weight bold :foreground "#ffffff" :font "ETBembo" :height 1.5 :underline nil))))
 '(org-headline-done ((t (:inherit default :weight bold :foreground "#ffffff" :font "ETBembo" :strike-through t))))
 '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
 '(org-level-1 ((t (:inherit default :weight bold :foreground "#ffffff" :font "ETBembo" :height 1.2 :box nil :background nil :foreground "#e8d9c3"))))
 '(org-level-2 ((t (:inherit default :weight bold :foreground "#ffffff" :font "ETBembo" :height 1.2 :box nil :background nil :foreground "#e8d9c3"))))
 '(org-level-3 ((t (:inherit default :weight bold :foreground "#ffffff" :font "ETBembo" :height 1.2 :foreground "#e8d9c3"))))
 '(org-level-4 ((t (:inherit default :weight bold :foreground "#ffffff" :font "ETBembo" :height 1.2 :foreground "#e8d9c3"))))
 '(org-level-5 ((t (:inherit default :weight bold :foreground "#ffffff" :font "ETBembo"))))
 '(org-level-6 ((t (:inherit default :weight bold :foreground "#ffffff" :font "ETBembo"))))
 '(org-level-7 ((t (:inherit default :weight bold :foreground "#ffffff" :font "ETBembo"))))
 '(org-level-8 ((t (:inherit default :weight bold :foreground "#ffffff" :font "ETBembo"))))
 '(variable-pitch ((t (:family "ETBembo" :height 180 :weight thin)))))
