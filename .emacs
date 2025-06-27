(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(epg-gpg-program "gpg")
 '(package-selected-packages
   '(corfu-terminal expand-region odin-mode visual-regexp
                    visual-regexp-steroids))
 '(package-vc-selected-packages '((odin-mode :url "https://github.com/mattt-b/odin-mode"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(eglot-highlight-symbol-face ((t (:inherit bold :foreground "yellow"))))
 '(eglot-inlay-hint-face ((t (:inherit shadow))))
 '(flymake-end-of-line-diagnostics-face ((t (:inherit nil :box nil :height 1.0))))
 '(mc/cursor-face ((t (:background "#FFAAAA" :foreground "#000000" :inverse-video nil))))
 '(mode-line ((t (:box nil))))
 '(mode-line-inactive ((t (:box nil)))))

(use-package package :config (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))
(use-package use-package-core :custom (use-package-always-defer 1))

(use-package emacs
  :custom
  (inhibit-splash-screen 1)
  (initial-scratch-message nil)
  (enable-recursive-minibuffers t)
  (minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))
  (tab-width 4)
  (use-short-answers 1)
  (dabbrev-case-fold-search nil)
  (ring-bell-function 'ignore)
  (visible-cursor nil)
  (mode-line-format '("%e"
                      " "
                      (:eval (swb/editor-mode))
                      " "
                      "%b"
                      (:eval (propertize (if buffer-read-only " read-only" "") 'face 'shadow))
                      (:eval (propertize (if (buffer-modified-p) " unsaved" "") 'face 'warning))
                      " "
                      (:eval (propertize default-directory 'face 'shadow))
                      mode-line-format-right-align
                      (:eval (if flymake-mode flymake-mode-line-format ""))
                      "  "))
  :config
  (defun swb/editor-mode () (if swb/simple-mode (propertize "NORMAL" 'face 'bold) (propertize "INSERT" 'face 'warning)))
  (tool-bar-mode 0)
  (menu-bar-mode 0)
  (set-frame-parameter (selected-frame) 'alpha-background 80)
  (add-to-list 'default-frame-alist '(alpha-background . 80)))

(use-package novice :custom (disabled-command-function nil))
(use-package ibuffer :bind ("C-x C-b" . ibuffer))
(use-package elec-pair :config (electric-pair-mode 1))
(use-package savehist :config (savehist-mode 1))
(use-package autorevert :config (global-auto-revert-mode 1))
(use-package saveplace :config (save-place-mode 1))
(use-package scroll-bar :config (scroll-bar-mode 0))
(use-package subword :config (global-subword-mode 1))
(use-package winner :config (winner-mode 1))
(use-package hideshow :hook (prog-mode-hook . hs-minor-mode))
(use-package org :custom (org-hide-emphasis-markers t))
(use-package cc-vars :custom (c-basic-offset 4))
(use-package cc-styles :hook (java-mode-hook . (lambda () (c-set-offset 'case-label '+)))) ;; fix switch indenting in java
(use-package dired :custom (dired-auto-revert-buffer #'dired-buffer-stale-p) (dired-dwim-target t))
(use-package which-key :config (which-key-mode))
(use-package frame :config (blink-cursor-mode -1))
(use-package window :bind ("M-o" . other-window))
(use-package show-paren :custom (show-paren-delay 0))

(use-package flymake
  :custom
  (flymake-show-diagnostics-at-end-of-line 1)
  (flymake-indicator-type 'fringes))

(use-package custom
  :config
  (load-theme 'modus-vivendi)
  (defun swb/on-after-init () (unless (display-graphic-p (selected-frame)) (set-face-background 'default "unspecified-bg" (selected-frame))))
  (add-hook 'window-setup-hook 'swb/on-after-init))

(use-package display-line-numbers
  :custom (display-line-numbers-type 'relative)
  :config (global-display-line-numbers-mode))

(use-package whitespace
  :custom (whitespace-style '(face tabs spaces trailing space-before-tab indentation empty space-after-tab space-mark tab-mark missing-newline-at-eof))
  :hook (prog-mode-hook . whitespace-mode))

(use-package files
  :custom (make-backup-files nil)
  :config (add-hook 'write-file-functions 'delete-trailing-whitespace))

(use-package simple
  :custom
  (read-extended-command-predicate #'command-completion-default-include-p)
  (indent-tabs-mode nil)
  (save-interprogram-paste-before-kill 1)
  :bind
  ("M-u" . upcase-dwim)
  ("M-l" . downcase-dwim)
  ("M-c" . capitalize-dwim))

(use-package tab-bar
  :custom
  (tab-bar-show 1)
  (tab-bar-tab-hints 1)
  (tab-bar-close-button nil)
  (tab-bar-new-button nil))

(use-package compile
  :custom
  (compilation-scroll-output 1)
  (compile-command "")
  :config
  (add-to-list 'compilation-error-regexp-alist 'zig-c-assert)
  (add-to-list 'compilation-error-regexp-alist-alist '(zig-c-assert ".*file \\(.*\\), line \\([0-9]*\\)" 1 2))
  (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter))

(use-package eglot
  :bind
  ("C-c e a" . eglot-code-actions)
  ("C-c e r" . eglot-rename)
  :custom
  (eglot-autoshutdown 1)
  (eglot-sync-connect 0)
  (eglot-connect-timeout nil)
  (jsonrpc-event-hook nil)
  (eglot-events-buffer-size 0)
  (eglot-report-progress nil)
  (eglot-events-buffer-config '(:size 0 :format full))
  :config (add-to-list 'eglot-server-programs '(odin-mode . ("ols" "--stdio" :initializationOptions (:enable_fake_methods t :enable_references t :enable_inlay_hints t)))))

(use-package isearch
  :bind (:map isearch-mode-map ("RET" . swb/isearch-done-select))
  :init (defun swb/isearch-done-select () (interactive) (isearch-exit) (set-mark isearch-other-end)))

(use-package cape :ensure :init (add-hook 'completion-at-point-functions (cape-capf-super #'cape-dabbrev #'cape-keyword)))
(use-package magit :ensure :custom (magit-save-repository-buffers nil))
(use-package orderless :ensure :custom (completion-styles '(orderless)))
(use-package vertico :ensure :init (vertico-mode))

(use-package corfu
  :ensure
  :bind (:map corfu-map ("RET" . nil))
  :custom
  (corfu-auto 1)
  (corfu-auto-prefix 1)
  (corfu-auto-delay 0.0)
  (corfu-cycle 1)
  (corfu-preview-current nil)
  :init
  (global-corfu-mode 1)
  (corfu-echo-mode 1)
  (corfu-history-mode 1))

(use-package corfu-terminal
  :vc (:url "https://codeberg.org/akib/emacs-corfu-terminal")
  :config (unless (display-graphic-p) (corfu-terminal-mode 1)))

(use-package yasnippet
  :ensure
  :bind*
  (:map yas-keymap
        ("C-," . yas-prev-field)
        ("C-." . yas-next-field)
        ("TAB" . nil))
  :config (yas-global-mode 1))

(use-package zig-mode :ensure)
(use-package glsl-mode :ensure :mode "\\.vs\\'" "\\.fs\\'")
(use-package odin-mode :vc (:url "https://github.com/mattt-b/odin-mode"))
(use-package markdown-mode :ensure)
(use-package cmake-mode :ensure)
(use-package rust-mode :ensure)

(use-package format-all
  :ensure
  :hook (prog-mode . format-all-mode)
  :config
  (setq-default format-all-formatters
                '(("Java" (astyle "--mode=java"))
                  ("C" (clang-format))
                  ("Rust" (rustfmt)))))

(use-package visual-regexp :ensure)
(use-package visual-regexp-steroids :ensure)

(use-package multiple-cursors
  :ensure
  :bind (:map mc/keymap ("<return>" . nil))
  :config
  ;; don't want C-g to quit multiple cursors
  (defun mc/keyboard-quit () (interactive) (when (use-region-p) (deactivate-mark)))
  (defun swb/quit-mcs () (interactive) (mc/disable-multiple-cursors-mode)))

(use-package avy :ensure :custom (avy-keys (number-sequence ?a ?z)))

(use-package expand-region :ensure)

;; custom modal editing

;; borrowed from meow mode
;; i do not understand this
(unless window-system
  (defun swb/esc (map)
    (if (and (let ((keys (this-single-command-keys)))
               (and (> (length keys) 0)
                    (= (aref keys (1- (length keys))) ?\e)))
             (sit-for 0.01))
        (prog1 [escape]
          (when defining-kbd-macro
            (end-kbd-macro)
            (setq last-kbd-macro (vconcat last-kbd-macro [escape]))
            (start-kbd-macro t t)))
      map))

  (defun swb/fix-term-esc (frame)
    (with-selected-frame frame
      (let ((term (frame-terminal frame)))
        (when (not (terminal-parameter term 'esc-map))
          (let ((esc-map (lookup-key input-decode-map [?\e])))
            (set-terminal-parameter term 'esc-map esc-map)
            (define-key input-decode-map [?\e] `(menu-item "" ,esc-map :filter ,#'swb/esc)))))))

  (add-hook 'after-make-frame-functions 'swb/fix-term-esc)
  (mapc 'swb/fix-term-esc (frame-list)))

(global-set-key (kbd "<escape>") 'swb/simple-mode)

(define-minor-mode swb/simple-mode "Simple editing mode"
  :keymap (make-sparse-keymap)
  :after-hook (deactivate-mark))

(add-hook 'prog-mode-hook 'swb/simple-mode)
(add-hook 'magit-mode-hook 'swb/simple-mode)
(add-hook 'git-commit-mode-hook (lambda () (interactive) (swb/simple-mode -1)))
(add-hook 'help-mode-hook 'swb/simple-mode)

(defun swb/start-marking () (interactive) (when (not mark-active) (set-mark (point))))
(defun swb/stop-marking () (interactive) (when mark-active (deactivate-mark)))

(defmacro swb/with-expand (key fn &optional affects-all-cursors)
  (let ((without-expand-symbol (intern (format "swb/without-expand/%s" fn)))
        (with-expand-symbol    (intern (format "swb/with-expand/%s" fn))))
    (list 'progn
          (list 'defun without-expand-symbol '(&rest args)
                (interactive-form fn)
                (if affects-all-cursors
                    '(mc/execute-command-for-all-cursors 'swb/stop-marking)
                  '(swb/stop-marking))
                (list 'apply (list 'quote fn) 'args))
          (list 'defun with-expand-symbol '(&rest args)
                (interactive-form fn)
                (if affects-all-cursors
                    '(mc/execute-command-for-all-cursors 'swb/start-marking)
                  '(swb/start-marking))
                (list 'apply (list 'quote fn) 'args))
          (list 'bind-key key                (list 'quote without-expand-symbol) 'swb/simple-mode-map)
          (list 'bind-key (list 'upcase key) (list 'quote with-expand-symbol)    'swb/simple-mode-map))))

(defun swb/go-to-beginning-of-region () (interactive) (when (and mark-active (> (point) (mark))) (exchange-point-and-mark)))
(defun swb/go-to-end-of-region () (interactive) (when (and mark-active (< (point) (mark))) (exchange-point-and-mark)))

(defun swb/insert-before ()
  (interactive)
  (swb/go-to-beginning-of-region)
  (swb/simple-mode -1))

(defun swb/insert-above ()
  (interactive)
  (swb/go-to-beginning-of-region)
  (goto-char (line-beginning-position))
  (save-mark-and-excursion (newline))
  (indent-according-to-mode)
  (swb/simple-mode -1))

(defun swb/insert-after ()
  (interactive)
  (swb/go-to-end-of-region)
  (swb/simple-mode -1))

(defun swb/insert-below ()
  (interactive)
  (swb/go-to-end-of-region)
  (goto-char (line-end-position))
  (newline)
  (indent-according-to-mode)
  (swb/simple-mode -1))

(defun swb/kill ()
  (interactive)
  (if mark-active (kill-region nil nil t) (delete-char 1)))

(defun swb/delete ()
  (interactive)
  (if mark-active (delete-region (point) (mark)) (delete-char 1)))

(defun swb/change ()
  (interactive)
  (swb/kill)
  (swb/simple-mode -1))

(defun swb/replace ()
  (interactive)
  (swb/delete)
  (yank))

(defun swb/select-next-symbol (arg)
  (interactive "p")
  (forward-symbol arg)
  (when (not mark-active)
    (er/mark-symbol)
    (exchange-point-and-mark)))

(defun swb/select-prev-symbol (arg)
  (interactive "p")
  (forward-symbol (- arg))
  (when (not mark-active)
    (er/mark-symbol)))

(defun swb/select-line (arg)
  (interactive "p")
  (swb/start-marking)
  (let ((flip (< (point) (mark))))
    (when flip (exchange-point-and-mark))
    (beginning-of-line)
    (forward-line 1)
    (exchange-point-and-mark)
    (beginning-of-line)
    (exchange-point-and-mark)))

(defun swb/select-join (arg)
  (interactive "p")
  (if (< arg 0) (back-to-indentation) (end-of-line))
  (swb/start-marking)
  (forward-line arg)
  (if (< arg 0) (end-of-line) (back-to-indentation)))

(defun swb/find (arg char)
  (interactive "p\ncfind:")
  (mc/execute-command-for-all-cursors
   (lambda () (interactive)
     (let ((end (save-mark-and-excursion (search-forward (char-to-string char) nil t arg))))
       (when end
         (swb/start-marking)
         (goto-char end))))))

(defun swb/till (arg char)
  (interactive "p\nctill:")
  (mc/execute-command-for-all-cursors
   (lambda () (interactive)
     (let ((end (save-mark-and-excursion
                  (progn
                    (forward-char (if (> arg 0) 1 -1))
                    (search-forward (char-to-string char) nil t arg)))))
       (when end
         (setq end (+ end (if (< arg 0) 1 -1)))
         (swb/start-marking)
         (goto-char end))))))

(bind-key [remap self-insert-command] 'ignore 'swb/simple-mode-map)

(bind-keys :map swb/simple-mode-map
           ("<escape>" . (lambda () (interactive) (deactivate-mark)))

           ("1" . digit-argument)
           ("2" . digit-argument)
           ("3" . digit-argument)
           ("4" . digit-argument)
           ("5" . digit-argument)
           ("6" . digit-argument)
           ("7" . digit-argument)
           ("8" . digit-argument)
           ("9" . digit-argument)
           ("-" . negative-argument)

           (";" . exchange-point-and-mark)
           ("'" . repeat)

           ("i" . swb/insert-before)
           ("I" . swb/insert-above)
           ("a" . swb/insert-after)
           ("A" . swb/insert-below)

           ("d" . swb/kill)
           ("c" . swb/change)
           ("y" . kill-ring-save)
           ("p" . yank)
           ("r" . swb/replace)

           ("o" . er/expand-region)

           ("s" . vr/mc-mark)
           ("," . mc/skip-to-previous-like-this)
           ("." . mc/skip-to-next-like-this)
           ("<" . mc/mark-previous-like-this)
           (">" . mc/mark-next-like-this)
           ("/" . swb/quit-mcs)
           )

(swb/with-expand "h" backward-char)
(swb/with-expand "j" next-line)
(swb/with-expand "k" previous-line)
(swb/with-expand "l" forward-char)

(swb/with-expand "e" swb/select-next-symbol)
(swb/with-expand "b" swb/select-prev-symbol)

(swb/with-expand "x" swb/select-line)
(swb/with-expand "m" swb/select-join)

(swb/with-expand "f" swb/find t)
(swb/with-expand "t" swb/till t)
