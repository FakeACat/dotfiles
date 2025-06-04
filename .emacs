(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(epg-gpg-program "gpg")
 '(package-selected-packages
   '(ace-window cape cmake-mode corfu embark-consult format-all glsl-mode
                hydra magit markdown-mode meow odin-mode orderless
                rust-mode yasnippet zig-mode))
 '(package-vc-selected-packages '((odin-mode :url "https://github.com/mattt-b/odin-mode"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
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
  (scroll-margin 10)
  (scroll-conservatively 0)
  (scroll-up-aggressively 0.01)
  (scroll-down-aggressively 0.01)
  (use-short-answers 1)
  (dabbrev-case-fold-search nil)
  (ring-bell-function 'ignore)
  (mode-line-format '("%e"
                      " "
                      "%b"
                      (:eval (propertize (when buffer-read-only " read-only") 'face 'shadow))
                      (:eval (propertize (when (buffer-modified-p) " unsaved") 'face 'warning))
                      " "
                      (:eval (propertize default-directory 'face 'shadow))
                      mode-line-format-right-align
                      (:eval (when flymake-mode flymake-mode-line-format))
                      "  "))
  :config
  (tool-bar-mode 0)
  (menu-bar-mode 0)
  (set-frame-parameter (selected-frame) 'alpha-background 80))

(use-package novice :custom (disabled-command-function nil))
(use-package ibuffer :bind ("C-x C-b" . ibuffer))
(use-package paren :custom (show-paren-delay 0))
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
(use-package hl-line :config (global-hl-line-mode 1))
(use-package frame :config (blink-cursor-mode -1))

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
  :bind
  (:map isearch-mode-map
        ("C-<return>" . swb/isearch-done-opposite)
        ("C-M-s" . swb/isearch-repeat-forward-embark-select)
        ("C-M-r" . swb/isearch-repeat-backward-embark-select)
        ("M-`" . swb/isearch-embark-select-all))
  :init
  ;; https://emacs.stackexchange.com/questions/52549
  (defun swb/isearch-done-opposite (&optional nopush edit)
    "End current search in the opposite side of the match."
    (interactive)
    (funcall #'isearch-done nopush edit)
    (when isearch-other-end (goto-char isearch-other-end)))

  (defun swb/isearch-embark-select ()
    (interactive)
    (save-mark-and-excursion
      (set-mark isearch-other-end)
      (activate-mark)
      (embark-select)))

  (defun swb/isearch-repeat-forward-embark-select ()
    (interactive)
    (swb/isearch-embark-select)
    (isearch-repeat-forward))

  (defun swb/isearch-repeat-backward-embark-select ()
    (interactive)
    (swb/isearch-embark-select)
    (isearch-repeat-backward))

  (defun swb/isearch-embark-select-all ()
    (interactive)
    (cl-assert isearch-mode)
    (save-mark-and-excursion
      (goto-char 0)
      (isearch-repeat-forward)
      (while isearch-success (swb/isearch-repeat-forward-embark-select)))
    (isearch-exit)))

(use-package hydra :ensure)
(use-package cape :ensure :init (add-hook 'completion-at-point-functions (cape-capf-super #'cape-dabbrev #'cape-keyword)))
(use-package ace-window :ensure :bind ("M-o" . ace-window))
(use-package corfu :ensure :custom (corfu-auto t) :init (global-corfu-mode 1))

(use-package magit
  :ensure
  :custom (magit-save-repository-buffers nil)
  :config (add-hook 'git-commit-mode-hook 'meow-insert))

(use-package orderless
  :ensure
  :custom
  (completion-styles '(orderless))
  (icomplete-compute-delay 0)
  :bind (:map icomplete-minibuffer-map ("SPC" . self-insert-command))
  :init
  (add-hook 'icomplete-minibuffer-setup-hook (lambda () (setq-local completion-styles '(orderless))))
  (fido-vertical-mode 1))

(use-package yasnippet
  :ensure
  :bind*
  (:map yas-keymap
        ("C-," . yas-prev-field)
        ("C-." . yas-next-field))
  :config
  (yas-global-mode 1))

(use-package zig-mode :ensure)
(use-package glsl-mode :ensure :mode "\\.vs\\'" "\\.fs\\'")
(use-package odin-mode :vc (:url "https://github.com/mattt-b/odin-mode"))
(use-package markdown-mode :ensure)
(use-package cmake-mode :ensure)
(use-package rust-mode :ensure)

(setq major-mode-remap-alist
      '((java-mode . java-ts-mode)
        (c-mode    . c-ts-mode)))

(use-package format-all
  :ensure
  :hook (prog-mode . format-all-mode)
  :config
  (setq-default format-all-formatters
                '(("Java" (astyle "--mode=java"))
                  ("C" (clang-format))
                  ("Rust" (rustfmt)))))

(use-package embark
  :ensure
  :custom (embark-confirm-act-all nil)
  :bind*
  ("C-." . embark-act)
  ("`" . embark-select)
  ("M-`" . swb/embark-act-all-and-deselect)
  :config
  (push 'embark--allow-edit (alist-get 'eglot-rename embark-target-injection-hooks))
  (push 'embark--ignore-target (alist-get 'eglot-rename embark-target-injection-hooks))

  (push 'embark--allow-edit (alist-get 'eglot-code-actions embark-target-injection-hooks))
  (push 'embark--ignore-target (alist-get 'eglot-code-actions embark-target-injection-hooks))

  (defun swb/embark-act-all-and-deselect ()
    (interactive)
    (embark-act-all)
    (execute-kbd-macro (kbd "C-. A SPC"))
    (setq embark--selection nil)))

(use-package consult
  :ensure
  :after embark-consult
  :demand
  :custom
  (xref-show-xrefs-function 'consult-xref)
  (xref-show-definitions-function 'consult-xref))

(use-package embark-consult :ensure :demand)

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
   '("0" . (lambda () (interactive) (if (swb/meow-currently-expanding) (meow-expand-0) (meow-digit-argument))))
   '("1" . (lambda () (interactive) (if (swb/meow-currently-expanding) (meow-expand-1) (meow-digit-argument))))
   '("2" . (lambda () (interactive) (if (swb/meow-currently-expanding) (meow-expand-2) (meow-digit-argument))))
   '("3" . (lambda () (interactive) (if (swb/meow-currently-expanding) (meow-expand-3) (meow-digit-argument))))
   '("4" . (lambda () (interactive) (if (swb/meow-currently-expanding) (meow-expand-4) (meow-digit-argument))))
   '("5" . (lambda () (interactive) (if (swb/meow-currently-expanding) (meow-expand-5) (meow-digit-argument))))
   '("6" . (lambda () (interactive) (if (swb/meow-currently-expanding) (meow-expand-6) (meow-digit-argument))))
   '("7" . (lambda () (interactive) (if (swb/meow-currently-expanding) (meow-expand-7) (meow-digit-argument))))
   '("8" . (lambda () (interactive) (if (swb/meow-currently-expanding) (meow-expand-8) (meow-digit-argument))))
   '("9" . (lambda () (interactive) (if (swb/meow-currently-expanding) (meow-expand-9) (meow-digit-argument))))
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
   '("c" . (lambda () (interactive) (if mark-active (meow-change) (meow-insert))))
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-symbol)
   '("E" . meow-next-word)
   '("f" . meow-find)
   '("g v" . meow-visit)
   '("g n" . swb/go-to-next-hydra/body)
   '("g p" . swb/go-to-prev-hydra/body)
   '("g d" . xref-find-definitions)
   '("g r" . xref-find-references)
   '("g c" . consult-compile-error)
   '("g f" . consult-flymake)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("k" . meow-prev)
   '("l" . meow-right)
   '("m" . meow-join)
   '("n" . meow-search)
   '("N" . (lambda () (interactive) (if mark-active (call-interactively 'narrow-to-region) (widen))))
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("r" . meow-replace)
   '("s" . (lambda () (interactive) (when mark-active (meow-kill))))
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . (lambda () (interactive) (setq swb/anchor (if (or swb/anchor (not mark-active)) (point) (mark)))))
   '("w" . meow-mark-symbol)
   '("W" . meow-mark-word)
   '("x" . meow-line)
   '("y" . meow-save)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . (lambda ()
                    (interactive)
                    (setq swb/anchor nil)
                    (meow-cancel-selection))))

  (setq meow-cursor-type-default       '(bar . 2))
  (setq meow-cursor-type-normal        '(bar . 2))
  (setq meow-cursor-type-motion        '(bar . 2))
  (setq meow-cursor-type-beacon        '(bar . 2))
  (setq meow-cursor-type-region-cursor '(bar . 2))
  (setq meow-cursor-type-insert        '(bar . 2))
  (setq meow-cursor-type-keypad        '(bar . 2))

  (add-hook 'meow-motion-mode-hook (lambda () (when meow-motion-mode
                                                (meow-motion-mode -1)
                                                (meow-normal-mode 1))))
  (meow-global-mode 1)

  (defun swb/meow-currently-expanding ()
    (and meow--expand-nav-function
         (region-active-p)
         (meow--selection-type)))

  (defvar swb/anchor nil)

  (add-hook 'post-command-hook
            (lambda ()
              (cond
               (meow-insert-mode
                (setq swb/anchor nil)
                (set-cursor-color "green1"))
               (swb/anchor
                (set-mark swb/anchor)
                (activate-mark)
                (set-cursor-color "red"))
               (t
                (set-cursor-color "white")))))

  (advice-add 'exchange-point-and-mark
              :after
              (lambda (&rest r)
                (when swb/anchor (setq swb/anchor (mark)))))

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
