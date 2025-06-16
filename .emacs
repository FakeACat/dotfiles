(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(epg-gpg-program "gpg")
 '(package-selected-packages
   '(avy cape cmake-mode corfu format-all glsl-mode hydra magit
         markdown-mode meow multiple-cursors odin-mode orderless
         rust-mode yasnippet zig-mode))
 '(package-vc-selected-packages '((odin-mode :url "https://github.com/mattt-b/odin-mode"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(eglot-highlight-symbol-face ((t (:underline t))))
 '(eglot-inlay-hint-face ((t (:inherit shadow))))
 '(flymake-end-of-line-diagnostics-face ((t (:inherit nil :box nil :height 1.0))))
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
  (defun swb/editor-mode () (cond (swb/anchor           (propertize "ANCHOR" 'face 'error))
                                  ((meow-normal-mode-p) (propertize "NORMAL" 'face 'bold))
                                  (t                    (propertize "INSERT" 'face 'warning))))
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
(use-package custom :config (load-theme 'modus-vivendi))
(use-package dired :custom (dired-auto-revert-buffer #'dired-buffer-stale-p) (dired-dwim-target t))
(use-package which-key :config (which-key-mode))
(use-package frame :config (blink-cursor-mode -1))
(use-package window :bind ("M-o" . other-window))
(use-package flymake :custom (flymake-show-diagnostics-at-end-of-line 1))

(use-package display-line-numbers
  :custom (display-line-numbers-type 'relative)
  :config (global-display-line-numbers-mode))

(use-package whitespace
  :custom (whitespace-style '(face tabs spaces trailing space-before-tab indentation empty space-after-tab space-mark tab-mark missing-newline-at-eof))
  :hook (prog-mode-hook . whitespace-mode))

(use-package files
  :custom
  (make-backup-files nil)
  :config (add-hook 'write-file-functions 'delete-trailing-whitespace))

(use-package simple
  :custom
  (read-extended-command-predicate #'command-completion-default-include-p)
  (indent-tabs-mode nil)
  (save-interprogram-paste-before-kill 1)
  (line-move-visual nil)
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
  :bind (:map isearch-mode-map ("<return>" . swb/isearch-done-select))
  :init (defun swb/isearch-done-select () (interactive) (isearch-exit) (set-mark isearch-other-end)))

(use-package hydra :ensure)
(use-package cape :ensure :init (add-hook 'completion-at-point-functions (cape-capf-super #'cape-dabbrev #'cape-keyword)))
(use-package corfu :ensure :custom (corfu-auto t) :init (global-corfu-mode 1))
(use-package magit :ensure :custom (magit-save-repository-buffers nil) :config (add-hook 'git-commit-mode-hook 'meow-insert))

(use-package orderless
  :ensure
  :custom
  (completion-styles '(orderless))
  :bind (:map icomplete-minibuffer-map ("SPC" . self-insert-command))
  :init
  (add-hook 'icomplete-minibuffer-setup-hook (lambda () (setq-local completion-styles '(orderless))))
  (fido-vertical-mode 1))

(use-package yasnippet
  :ensure
  :bind*
  (:map yas-keymap
        ("C-," . yas-prev-field)
        ("C-." . yas-next-field)
        ("TAB" . nil))
  :config
  (yas-global-mode 1))

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

(use-package meow
  :ensure
  :demand
  :custom
  (meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-expand-hint-remove-delay nil)
  :config
  ;; modified from https://github.com/meow-edit/meow/blob/master/KEYBINDING_QWERTY.org
  (meow-leader-define-key
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . swb/expand-or-arg-0)
   '("1" . swb/expand-or-arg-1)
   '("2" . swb/expand-or-arg-2)
   '("3" . swb/expand-or-arg-3)
   '("4" . swb/expand-or-arg-4)
   '("5" . swb/expand-or-arg-5)
   '("6" . swb/expand-or-arg-6)
   '("7" . swb/expand-or-arg-7)
   '("8" . swb/expand-or-arg-8)
   '("9" . swb/expand-or-arg-9)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-symbol)
   '("B" . meow-back-word)
   '("c" . meow-change)
   '("C" . meow-insert-mode)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-symbol)
   '("E" . meow-next-word)
   '("f" . swb/meow-find-mc)
   '("g v" . meow-visit)
   '("g n" . swb/go-to-next-hydra/body)
   '("g p" . swb/go-to-prev-hydra/body)
   '("g d" . xref-find-definitions)
   '("g r" . xref-find-references)
   '("g l" . goto-line)
   '("g w" . swb/avy-mark-symbol)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("k" . meow-prev)
   '("l" . meow-right)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("r" . meow-replace)
   '("s" . meow-kill)
   '("t" . swb/meow-till-mc)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . swb/place-anchor)
   '("w" . swb/meow-mark-symbol)
   '("x" . swb/meow-line)
   '("y" . meow-save)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . swb/remove-anchor-and-selection)
   '("/" . swb/multiple-cursors-hydra/body))

  (setq meow-cursor-type-insert 'box)

  (add-hook 'meow-motion-mode-hook (lambda () (when meow-motion-mode (meow-motion-mode -1) (meow-normal-mode 1))))
  (add-hook 'server-after-make-frame-hook 'meow--prepare-face) ;; not called for every frame by default
  (meow-global-mode 1)

  (defun swb/expand-or-arg-0 () (interactive) (if (swb/meow-currently-expanding) (meow-expand-0) (meow-digit-argument)))
  (defun swb/expand-or-arg-1 () (interactive) (if (swb/meow-currently-expanding) (meow-expand-1) (meow-digit-argument)))
  (defun swb/expand-or-arg-2 () (interactive) (if (swb/meow-currently-expanding) (meow-expand-2) (meow-digit-argument)))
  (defun swb/expand-or-arg-3 () (interactive) (if (swb/meow-currently-expanding) (meow-expand-3) (meow-digit-argument)))
  (defun swb/expand-or-arg-4 () (interactive) (if (swb/meow-currently-expanding) (meow-expand-4) (meow-digit-argument)))
  (defun swb/expand-or-arg-5 () (interactive) (if (swb/meow-currently-expanding) (meow-expand-5) (meow-digit-argument)))
  (defun swb/expand-or-arg-6 () (interactive) (if (swb/meow-currently-expanding) (meow-expand-6) (meow-digit-argument)))
  (defun swb/expand-or-arg-7 () (interactive) (if (swb/meow-currently-expanding) (meow-expand-7) (meow-digit-argument)))
  (defun swb/expand-or-arg-8 () (interactive) (if (swb/meow-currently-expanding) (meow-expand-8) (meow-digit-argument)))
  (defun swb/expand-or-arg-9 () (interactive) (if (swb/meow-currently-expanding) (meow-expand-9) (meow-digit-argument)))

  (defvar swb/anchor nil)

  (defun swb/place-anchor ()
    (interactive)
    (setq swb/anchor
          (if (or swb/anchor (not mark-active))
              (point)
            (mark)))
    (force-mode-line-update))

  (defun swb/remove-anchor-and-selection ()
    (interactive)
    (setq swb/anchor nil)
    (meow-cancel-selection))

  (defun swb/meow-currently-expanding ()
    (and meow--expand-nav-function
         (region-active-p)
         (meow--selection-type)))

  (defun swb/meow-mark-symbol ()
    (interactive)
    (meow-inner-of-thing ?e))

  (defun swb/meow-line (count)
    (interactive "p")
    (if swb/anchor
        (if (> swb/anchor (point))
            (progn
              (save-excursion
                (goto-char swb/anchor)
                (move-end-of-line nil)
                (setq swb/anchor (point)))
              (move-beginning-of-line nil)
              (meow-line -1))
          (progn
            (save-excursion
              (goto-char swb/anchor)
              (move-beginning-of-line nil)
              (setq swb/anchor (point)))
            (move-end-of-line nil)
            (meow-line 1)))
      (meow-line count)))

  (defun swb/update-anchor-mark ()
    (cond
     (meow-insert-mode
      (setq swb/anchor nil))
     (swb/anchor
      (if (and mark-active (or (> (mark) swb/anchor (point)) (< (mark) swb/anchor (point))))
          (setq swb/anchor (mark)))
      (set-mark swb/anchor)
      (activate-mark))))

  (add-hook 'post-command-hook 'swb/update-anchor-mark)
  (add-hook 'deactivate-mark-hook 'swb/update-anchor-mark)

  (advice-add 'exchange-point-and-mark :after (lambda (&rest r) (when swb/anchor (setq swb/anchor (mark)))))

  (defhydra swb/go-to-next-hydra nil
    "Go to next"
    ("f" flymake-goto-next-error "Flymake error")
    ("c" next-error "Compilation error")
    ("p" forward-paragraph "Paragraph")
    ("s" scroll-up "Screen")
    ("-" swb/go-to-prev-hydra/body "Reverse" :exit t))

  (defhydra swb/go-to-prev-hydra nil
    "Go to previous"
    ("f" flymake-goto-prev-error "Flymake error")
    ("c" previous-error "Compilation error")
    ("p" backward-paragraph "Paragraph")
    ("s" scroll-down "Screen")
    ("-" swb/go-to-next-hydra/body "Reverse" :exit t)))

(use-package multiple-cursors
  :ensure
  :bind
  (:map mc/keymap ("<return>" . nil))
  :config
  (defhydra swb/multiple-cursors-hydra nil
    "Create/remove multiple cursors"
    ("n"   mc/mark-next-like-this "Mark next like this")
    ("p"   mc/mark-previous-like-this "Mark previous like this")
    ("N"   mc/skip-to-next-like-this "Skip to next like this")
    ("P"   mc/skip-to-previous-like-this "Skip to previous like this")
    ("M-n" mc/unmark-next-like-this "Mark next like this")
    ("M-p" mc/unmark-previous-like-this "Mark previous like this")
    ("s"   mc/mark-all-in-region "Mark all in region" :exit t)
    ("x"   mc/edit-lines "Edit lines" :exit t)
    ("<return>" nil "Done")
    ("<escape>" (lambda () (interactive) (mc/disable-multiple-cursors-mode)) "Cancel" :exit t))

  (defun swb/fix-all-anchors (&rest r) (when swb/anchor (mc/execute-command-for-all-cursors 'swb/fix-anchor)))
  (defun swb/fix-anchor () (interactive) (setq swb/anchor (mark)))
  (advice-add 'mc/maybe-multiple-cursors-mode :after 'swb/fix-all-anchors)
  (push 'swb/anchor mc/cursor-specific-vars)

  (defun swb/meow-find-mc (n ch &optional expand)
    (interactive "p\ncFind:")
    (mc/execute-command-for-all-cursors (lambda () (interactive) (meow-find n ch expand))))
  (defun swb/meow-till-mc (n ch &optional expand)
    (interactive "p\ncTill:")
    (mc/execute-command-for-all-cursors (lambda () (interactive) (meow-till n ch expand)))))

(use-package avy
  :ensure
  :custom
  (avy-keys (number-sequence ?a ?z))
  (avy-dispatch-alist '((?. . swb/avy-action-embark)))
  :config
  (defun swb/avy-action-mark-symbol (pt) (goto-char pt) (swb/meow-mark-symbol))
  (defun swb/avy-mark-symbol () (interactive) (avy-jump "\\_<\\(\\sw\\|\\s_\\)" :action 'swb/avy-action-mark-symbol)))
