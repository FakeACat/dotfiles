;;;  -*- lexical-binding: t -*-

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(epg-gpg-program "gpg")
 '(package-selected-packages
   '(cape cmake-mode corfu ess format-all glsl-mode json-mode magit markdown-mode
          multiple-cursors odin-mode orderless rust-mode smart-tabs-mode vertico
          visual-regexp-steroids wgrep yasnippet zig-mode))
 '(package-vc-selected-packages '((odin-mode :url "https://github.com/mattt-b/odin-mode"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(eglot-highlight-symbol-face ((t (:underline t))))
 '(mc/cursor-bar-face ((t (:background "#FFFF00" :inverse-video nil))))
 '(mc/cursor-face ((t (:background "#FFFF00" :inverse-video nil)))))

(defmacro swb/cmd (&rest body) `(lambda (&rest _) (interactive) ,@body))

(use-package package
  :config (add-to-list 'package-archives
                       '("melpa" . "https://melpa.org/packages/") t))

(use-package use-package-core :custom (use-package-always-defer 1))

(use-package emacs
  :custom
  (inhibit-splash-screen 1)
  (initial-scratch-message nil)
  (enable-recursive-minibuffers t)
  (minibuffer-prompt-properties '(read-only
                                  t
                                  cursor-intangible
                                  t
                                  face
                                  minibuffer-prompt))
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
  (server-client-instructions nil)
  (vc-follow-symlinks t)
  (frame-title-format "%b - Notepad")
  :config
  (tool-bar-mode 0)
  (menu-bar-mode 0)
  (set-frame-parameter (selected-frame) 'alpha-background 80)
  (add-to-list 'default-frame-alist '(alpha-background . 80))
  (defun swb/editor-mode ()
    (cond (swb/anchored    (propertize "ANCHOR" 'face 'error))
          (swb/simple-mode (propertize "NORMAL" 'face 'bold))
          (t               (propertize "INSERT" 'face 'warning)))))

(use-package novice :custom (disabled-command-function nil))
(use-package savehist :config (savehist-mode 1))
(use-package autorevert :config (global-auto-revert-mode 1))
(use-package saveplace :config (save-place-mode 1))
(use-package scroll-bar :config (scroll-bar-mode 0))
(use-package subword :config (global-subword-mode 1))
(use-package hideshow :hook (prog-mode-hook . hs-minor-mode))
(use-package org :custom (org-hide-emphasis-markers t))

(use-package cc-styles
  :hook
  (java-mode-hook . (lambda ()
                      (c-set-offset 'case-label '+)))) ;; fix switch indenting in java

(use-package dired
  :custom
  (dired-auto-revert-buffer #'dired-buffer-stale-p)
  (dired-dwim-target t))

(use-package grep
  :custom
  (grep-use-null-device nil)
  (grep-command "rg --no-heading ''")
  (grep-command-position (length grep-command)))

(use-package which-key :config (which-key-mode))
(use-package show-paren :custom (show-paren-delay 0))
(use-package flymake :custom (flymake-indicator-type 'fringes))
(use-package frame :config (blink-cursor-mode -1))
(use-package winner :config (winner-mode))

(use-package display-fill-column-indicator
  :custom (fill-column 80)
  :config (global-display-fill-column-indicator-mode))

(use-package custom :config (load-theme 'modus-vivendi))

(use-package display-line-numbers
  :custom (display-line-numbers-type 'relative)
  :config (global-display-line-numbers-mode))

(use-package hl-line :config (global-hl-line-mode 1))

(use-package whitespace
  :custom (whitespace-style '(face
                              tabs
                              spaces
                              trailing
                              space-before-tab
                              indentation
                              empty
                              space-after-tab
                              tab-mark
                              missing-newline-at-eof))
  :hook (prog-mode-hook . whitespace-mode))

(use-package files
  :custom (make-backup-files nil)
  :config (add-hook 'write-file-functions 'delete-trailing-whitespace))

(use-package simple
  :custom
  (read-extended-command-predicate #'command-completion-default-include-p)
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
  (compilation-ask-about-save nil)
  :config
  (add-to-list 'compilation-error-regexp-alist
               'zig-c-assert)
  (add-to-list 'compilation-error-regexp-alist-alist
               '(zig-c-assert ".*file \\(.*\\), line \\([0-9]*\\)" 1 2))
  (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter))

(use-package eglot
  :custom
  (eglot-autoshutdown 1)
  (eglot-sync-connect 0)
  (eglot-connect-timeout nil)
  (jsonrpc-event-hook nil)
  (eglot-events-buffer-size 0)
  (eglot-report-progress nil)
  (eglot-events-buffer-config '(:size 0 :format full))
  :config
  (add-to-list 'eglot-server-programs
               '(odin-mode . ("ols"
                              "--stdio"
                              :initializationOptions
                              (:enable_fake_methods t
                               :enable_references   t
                               :enable_inlay_hints  t)))))

(use-package eldoc
  :custom
  ;; low but not so low that it shows everything i scroll over
  (eldoc-idle-delay 0.05))

(use-package isearch
  :bind (:map isearch-mode-map
              ("RET" . swb/isearch-done-select)
              ("<return>" . swb/isearch-done-select)
              ("<escape>" . isearch-abort)
              ("C-<backspace>" . swb/isearch-delete-entire-query)
              ("M-DEL" . swb/isearch-delete-entire-query))
  :init
  (defun swb/isearch-done-select ()
    (interactive)
    (isearch-exit)
    (set-mark isearch-other-end))
  :config
  ;; https://stackoverflow.com/a/32002122
  (defun swb/isearch-with-region ()
    (when mark-active
      (let ((region (funcall region-extract-function nil)))
        (goto-char (region-beginning))
        (deactivate-mark)
        (isearch-update)
        (isearch-yank-string region))))
  (add-hook 'isearch-mode-hook #'swb/isearch-with-region)
  ;; https://www.reddit.com/r/emacs/comments/ydbxtw/comment/itrc6rl/
  (defun swb/isearch-delete-entire-query ()
    (interactive)
    (isearch-del-char most-positive-fixnum)))

(use-package elec-pair :config (electric-pair-mode 1))

(use-package cape
  :ensure
  :init
  (add-hook 'completion-at-point-functions
            (cape-capf-super #'cape-dabbrev #'cape-keyword)))

(use-package magit :ensure :custom (magit-save-repository-buffers nil))

(use-package orderless
  :ensure
  :demand
  :custom (completion-styles '(orderless)))

(use-package vertico
  :ensure
  :demand
  :config
  (setq vertico-multiform-categories
        '((file (:keymap . vertico-directory-map))))
  (vertico-multiform-mode)
  (vertico-mode))

(use-package corfu
  :ensure
  :custom
  (corfu-cycle 1)
  (corfu-quit-at-boundary nil)
  :init
  (global-corfu-mode 1)
  (corfu-history-mode 1))

(use-package yasnippet
  :ensure
  :config
  (yas-global-mode)
  (setq yas-keymap nil))

;; https://github.com/jcsalomon/smarttabs/pull/54
(defmacro smart-tabs-create-advice-list (advice-list)
  `(cl-loop for (func . offset) in ,advice-list
            collect `(smart-tabs-advice ,func ,offset)))

(use-package smart-tabs-mode
  :ensure
  :custom
  (indent-tabs-mode nil)
  (tab-width 4)
  :config
  (defvaralias 'c-basic-offset 'tab-width)
  (defvaralias 'js-indent-level 'tab-width)
  (smart-tabs-add-language-support odin odin-mode-hook
    ((js-indent-line . js-indent-level)
     (indent-region-line-by-line . js-indent-level)))
  (smart-tabs-insinuate 'odin)
  (add-hook 'odin-mode-hook (swb/cmd (indent-tabs-mode 1)
                                     (setq tab-width 4))))

(use-package zig-mode :ensure)
(use-package glsl-mode :ensure :mode "\\.vs\\'" "\\.fs\\'")
(use-package odin-mode :vc (:url "https://github.com/mattt-b/odin-mode") :config (push '("Odin" odin-mode) language-id--definitions))
(use-package markdown-mode :ensure)
(use-package cmake-mode :ensure)
(use-package rust-mode :ensure)
(use-package json-mode :ensure)
(use-package ess :ensure :custom (ess-indent-with-fancy-comments nil))

(use-package format-all
  :ensure
  :hook (prog-mode . format-all-mode)
  :config
  (define-format-all-formatter odinfmt
    (:executable "odinfmt")
    (:install)
    (:languages "Odin")
    (:features)
    (:format (format-all--buffer-easy executable "-stdin")))
  (setq-default format-all-formatters
                '(("Java" (google-java-format "-a"))
                  ("C" (astyle "-toO"))
                  ("C++" (astyle "-tO"))
                  ("C#" (astyle))
                  ("Rust" (rustfmt))
                  ("Odin" (odinfmt)))))

(use-package visual-regexp :ensure)
(use-package visual-regexp-steroids :ensure)

(use-package multiple-cursors
  :ensure
  :demand
  :bind (:map mc/keymap ("<return>" . nil))
  :config
  (push 'corfu-mode mc/unsupported-minor-modes)
  (push 'global-hl-line-mode mc/unsupported-minor-modes)
  (push 'swb/point-and-mark-ring mc/cursor-specific-vars)
  ;; don't want C-g to quit multiple cursors
  (defun mc/keyboard-quit ()
    (interactive)
    (when (use-region-p)
      (deactivate-mark)))
  (defun swb/quit-mcs ()
    (interactive)
    (mc/disable-multiple-cursors-mode))
  ;; only on linux since bar multiple cursors don't work on windows
  (when (eq system-type 'gnu/linux)
    (setq-default cursor-type '(bar . 2))))

(use-package wgrep :ensure)

;; custom modal editing

(defun swb/simple-mode-or-exit-minibuffer ()
  (interactive)
  (if (minibufferp) (abort-minibuffers) (swb/simple-mode 1)))

(global-set-key (kbd "<escape>") 'swb/simple-mode-or-exit-minibuffer)
(global-set-key (kbd "M-<escape>") (swb/cmd (swb/simple-mode)))

(define-minor-mode swb/simple-mode "Simple editing mode"
  :init-value t
  :keymap (make-sparse-keymap)
  :after-hook
  (deactivate-mark)
  (corfu-quit)
  (setq swb/anchored nil)
  (force-mode-line-update))

(add-hook 'minibuffer-mode-hook (lambda () (interactive) (swb/simple-mode -1)))
(add-hook 'git-commit-mode-hook (lambda () (interactive) (swb/simple-mode -1)))

(defvar-local swb/anchored nil)

(advice-add 'deactivate-mark :after (swb/cmd (setq swb/anchored nil)
                                             (force-mode-line-update)))

(defun swb/start-marking () (interactive) (unless mark-active (set-mark (point))))
(defun swb/stop-marking () (interactive) (when mark-active (deactivate-mark)))

(defun swb/forward-line-text ()
  (let ((point (point)))
    (end-of-line)
    (when (= point (point))
      (forward-line 1)
      (end-of-line))))

(defun swb/backward-line-text ()
  (let ((point (point)))
    (back-to-indentation)
    (when (>= (point) point)
      (forward-line -1)
      (back-to-indentation))))

(defun swb/forward-line-join ()
  (let ((indentation (save-mark-and-excursion (back-to-indentation) (point))))
    (if (> indentation (point))
        (goto-char indentation)
      (forward-line)
      (back-to-indentation))))

(defun swb/backward-line-join ()
  (forward-line -1)
  (end-of-line))

(defun swb/is-whitespace (char)
  (or (eq char ? )
      (eq char ?\t)
      (eq char ?\n)))

(defun swb/next-to-char-ignoring-whitespace (char &optional back)
  (save-excursion
    (while (swb/is-whitespace (if back (char-before) (char-after)))
      (backward-char))
    (eq (if back (char-before) (char-after)) char)))

(defun swb/forward-argument ()
  (while (and
          (ignore-errors (forward-sexp) t)
          (not (swb/next-to-char-ignoring-whitespace ?,)))))

(defun swb/backward-argument ()
  (while (and
          (ignore-errors (backward-sexp) t)
          (not (swb/next-to-char-ignoring-whitespace ?, t)))))

(defun swb/forward-whitespace (&optional back)
  (if back (backward-char) (forward-char))
  (while (let ((next-char (if back (char-before) (char-after)))
               (prev-char (if back (char-after) (char-before))))
           (or (swb/is-whitespace next-char)
               (not (swb/is-whitespace prev-char))))
    (if back (backward-char) (forward-char))))

(defun swb/backward-whitespace ()
  (swb/forward-whitespace t))

(defun swb/forward-contiguous (&optional back)
  (if back (backward-char) (forward-char))
  (while (let ((next-char (if back (char-before) (char-after)))
               (prev-char (if back (char-after) (char-before))))
           (or (not (swb/is-whitespace next-char))
               (swb/is-whitespace prev-char)))
    (if back (backward-char) (forward-char))))

(defun swb/backward-contiguous ()
  (swb/forward-contiguous t))

(defvar swb/alphanumeric-regex "[a-zA-Z0-9_]")
(defvar swb/whitespace-regex "[\s\n\t]")
(defvar swb/not-alphanumeric-or-whitespace-regex "[^a-zA-Z0-9_\s\n\t]")

(defvar swb/end-of-vim-word-regex
  (concat swb/alphanumeric-regex
          swb/not-alphanumeric-or-whitespace-regex
          "\\|"
          swb/not-alphanumeric-or-whitespace-regex
          swb/alphanumeric-regex
          "\\|"
          swb/alphanumeric-regex
          swb/whitespace-regex
          "\\|"
          swb/not-alphanumeric-or-whitespace-regex
          swb/whitespace-regex))

(defvar swb/beginning-of-vim-word-regex
  (concat swb/alphanumeric-regex
          swb/not-alphanumeric-or-whitespace-regex
          "\\|"
          swb/not-alphanumeric-or-whitespace-regex
          swb/alphanumeric-regex
          "\\|"
          swb/whitespace-regex
          swb/alphanumeric-regex
          "\\|"
          swb/whitespace-regex
          swb/not-alphanumeric-or-whitespace-regex))

(defun swb/forward-vim-word ()
  (when (re-search-forward swb/end-of-vim-word-regex nil 1)
    (backward-char)))

(defun swb/backward-vim-word ()
  (if (re-search-backward swb/beginning-of-vim-word-regex nil 1)
      (forward-char)
    (goto-char (point-min))))

(defvar swb/text-objects)

(defun swb/add-text-object (char beg end)
  (push (list char . (beg end)) swb/text-objects))

(defun swb/execute-text-object-fn (char element)
  (let ((object (assoc char swb/text-objects)))
    (unless object (user-error (format "Invalid object \"%c\"" char)))
    (funcall (nth element (cdr object)))))

(defun swb/select-text-object (n char)
  (interactive "p\ncObject:")
  (let ((forward-index 1) (backward-index 0))
    (when (< n 0)
      (setq n (- n))
      (cl-rotatef forward-index backward-index))
    (when swb/anchored (swb/start-marking))
    (swb/execute-text-object-fn char forward-index)
    (unless swb/anchored
      (set-mark (point))
      (swb/execute-text-object-fn char backward-index)
      (exchange-point-and-mark))
    (dotimes (i (- n 1)) (swb/execute-text-object-fn char forward-index))))

(defun swb/select-text-object-back (n char)
  (interactive "p\ncObject:")
  (swb/select-text-object (- n) char))

(defun swb/mark-text-objects-in-region (char)
  (interactive "cObject:")
  (when (not mark-active) (user-error "mark must be active"))
  (let ((new-cursors nil))
    (mc/execute-command-for-all-cursors
     (swb/cmd
      (let ((point (point))
            (mark (mark)))
        (deactivate-mark)
        (when (> point mark) (cl-rotatef mark point))
        (goto-char point)
        (let ((prev-point (- (point-min) 1)))
          (while (and (< (point) mark) (< prev-point (point)))
            (setq prev-point (point))
            (ignore-errors
              (swb/select-text-object 1 char))
            (when (< (mark) mark)
              (push (list (point) (mark))
                    new-cursors)))))))
    (mc/disable-multiple-cursors-mode)
    (dolist (pt-and-mark new-cursors nil)
      (swb/go-to-point-and-mark pt-and-mark)
      (mc/create-fake-cursor-at-point))
    (mc/pop-state-from-overlay (car (mc/all-fake-cursors))))
  (mc/maybe-multiple-cursors-mode))

(defun swb/mark-text-objects-in-region-back (char)
  (interactive "cObject:")
  (swb/mark-text-objects-in-region char)
  (mc/execute-command-for-all-cursors (cmd/swb (exchange-point-and-mark))))

(defun swb/transpose-text-objects (n char)
  (interactive "p\ncObject:")
  (deactivate-mark)
  (transpose-subr (lambda (n2)
                    (interactive "p")
                    (swb/select-text-object n2 char))
                  n)
  (setq deactivate-mark nil)
  (swb/select-text-object -1 char)
  (exchange-point-and-mark))

(defun swb/transpose-text-objects-back (n char)
  (interactive "p\ncObject:")
  (swb/transpose-text-objects (- n) char))

(setq swb/text-objects nil) ;; just makes it easier to re-eval all this
(swb/add-text-object ?p 'start-of-paragraph-text 'end-of-paragraph-text)
(swb/add-text-object ?l 'swb/backward-line-text 'swb/forward-line-text)
(swb/add-text-object ?b 'beginning-of-buffer 'end-of-buffer)
(swb/add-text-object ?x 'backward-sexp 'forward-sexp)
(swb/add-text-object ?f 'beginning-of-defun 'end-of-defun)
(swb/add-text-object ?w 'backward-word 'forward-word)
(swb/add-text-object ?s (lambda () (forward-symbol -1)) (lambda () (forward-symbol 1)))
(swb/add-text-object ?j 'swb/backward-line-join 'swb/forward-line-join)
(swb/add-text-object ?a 'swb/backward-argument 'swb/forward-argument)
(swb/add-text-object (string-to-char " ") 'swb/backward-whitespace 'swb/forward-whitespace)
(swb/add-text-object ?v 'swb/backward-vim-word 'swb/forward-vim-word)
(swb/add-text-object ?V 'swb/backward-contiguous 'swb/forward-contiguous)

(defun swb/go-to-beginning-of-region ()
  (interactive)
  (when (and mark-active (> (point) (mark))) (exchange-point-and-mark)))

(defun swb/go-to-end-of-region ()
  (interactive)
  (when (and mark-active (< (point) (mark))) (exchange-point-and-mark)))

(defun swb/insert-before ()
  (interactive)
  (swb/go-to-beginning-of-region)
  (swb/simple-mode -1))

(defun swb/newline-above (arg)
  (interactive "p")
  (save-excursion
    (swb/go-to-beginning-of-region)
    (beginning-of-line)
    (newline arg)))

(defun swb/insert-above (arg)
  (interactive "p")
  (swb/go-to-beginning-of-region)
  (beginning-of-line)
  (save-mark-and-excursion (newline arg))
  (indent-according-to-mode)
  (swb/simple-mode -1))

(defun swb/insert-after ()
  (interactive)
  (swb/go-to-end-of-region)
  (swb/simple-mode -1))

(defun swb/newline-below (arg)
  (interactive "p")
  (save-excursion
    (swb/go-to-end-of-region)
    (end-of-line)
    (newline arg)))

(defun swb/insert-below (arg)
  (interactive "p")
  (swb/go-to-end-of-region)
  (end-of-line)
  (newline arg)
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

(defun swb/select-next-vim-word (arg)
  (interactive "p")
  (swb/select-text-object arg ?v))

(defun swb/select-prev-vim-word (arg)
  (interactive "p")
  (swb/select-text-object (- arg) ?v))

(defun swb/select-next-vim-WORD (arg)
  (interactive "p")
  (swb/select-text-object arg ?V))

(defun swb/select-prev-vim-WORD (arg)
  (interactive "p")
  (swb/select-text-object (- arg) ?V))

(defun swb/expand-to-lines (arg)
  (interactive "p")
  (swb/start-marking)
  (let ((flip (< (point) (mark))))
    (when flip (exchange-point-and-mark))
    (beginning-of-line)
    (forward-line 1)
    (exchange-point-and-mark)
    (beginning-of-line)
    (unless flip (exchange-point-and-mark))))

(defun swb/expand-to-line-text (arg)
  (interactive "p")
  (swb/start-marking)
  (let ((flip (< (point) (mark))))
    (when flip (exchange-point-and-mark))
    (end-of-line)
    (exchange-point-and-mark)
    (back-to-indentation)
    (unless flip (exchange-point-and-mark))))

(defun swb/find (arg char)
  (interactive "p\ncFind:")
  (let* ((case-fold-search nil)
         (end (save-mark-and-excursion
                (search-forward (char-to-string char) nil t arg))))
    (when end
      (unless swb/anchored (deactivate-mark))
      (swb/start-marking)
      (goto-char end))))

(defun swb/till (arg char)
  (interactive "p\ncTill:")
  (let* ((case-fold-search nil)
         (end (save-mark-and-excursion
                (progn
                  (forward-char (if (> arg 0) 1 -1))
                  (search-forward (char-to-string char) nil t arg)))))
    (when end
      (setq end (+ end (if (< arg 0) 1 -1)))
      (unless swb/anchored (deactivate-mark))
      (swb/start-marking)
      (goto-char end))))

(defun swb/ring-rotate (ring &optional back)
  (if back
      (let ((element (ring-remove ring)))
        (ring-insert ring element)
        element)
    (let ((element (ring-remove ring 0)))
      (ring-insert-at-beginning ring element)
      element)))

(defun swb/make-point-and-mark-ring () (make-ring 20))

(defvar-local swb/point-and-mark-ring (swb/make-point-and-mark-ring))
(defvar-local swb/last-point-push-command nil)

(defun swb/at-point-and-mark (point-and-mark)
  (and (eq (car point-and-mark) (point))
       (eq (cadr point-and-mark) (if mark-active (mark) nil))))

(defun swb/maybe-push-point-to-ring ()
  (unless (or (and (not (ring-empty-p swb/point-and-mark-ring))
                   (swb/at-point-and-mark (ring-ref swb/point-and-mark-ring 0)))
              (eq this-command 'swb/pop-point-and-mark-from-ring))
    (ring-insert swb/point-and-mark-ring
                 (list (point) (if mark-active (mark) nil)))
    (setq swb/last-point-push-command last-command)))

(add-hook 'pre-command-hook 'swb/maybe-push-point-to-ring)
(add-hook 'post-command-hook 'swb/maybe-push-point-to-ring)

(defun swb/go-to-point-and-mark (point-and-mark)
  (goto-char (car point-and-mark))
  (let ((mark (cadr point-and-mark)))
    (if mark
        (set-mark mark)
      (deactivate-mark))))

(defun swb/pop-point-and-mark-from-ring (arg)
  (interactive "p")
  (let* ((back (< arg 0))
         (point-and-mark (swb/ring-rotate swb/point-and-mark-ring back)))
    (when (swb/at-point-and-mark point-and-mark)
      (setq point-and-mark (swb/ring-rotate swb/point-and-mark-ring back)))
    (swb/go-to-point-and-mark point-and-mark)))

(defun swb/reset-point-and-mark-ring-for-all-cursors ()
  (mc/execute-command-for-all-cursors
   (lambda ()
     (interactive)
     (setq swb/point-and-mark-ring (swb/make-point-and-mark-ring)))))

(advice-add 'mc/maybe-multiple-cursors-mode
            :after
            'swb/reset-point-and-mark-ring-for-all-cursors)

(defun swb/make-repeat-behave-with-multiple-cursors (orig-fn repeat-arg)
  (when (eq last-repeatable-command 'repeat)
    (setq last-repeatable-command repeat-previous-repeated-command))

  (if (memq last-repeatable-command mc/cmds-to-run-for-all)
      (mc/execute-command-for-all-cursors
       (lambda ()
         (interactive)
         (funcall orig-fn repeat-arg)))
    (funcall orig-fn repeat-arg)))

(advice-add 'repeat :around 'swb/make-repeat-behave-with-multiple-cursors)

(defvar swb/last-repeatable-command nil)

(defun swb/save-last-repeatable-command ()
  (when (and swb/simple-mode
             (not (member last-repeatable-command
                          '(swb/anchor
                            exchange-point-and-mark
                            swb/simple-mode-or-exit-minibuffer
                            swb/save-dwim))))
    (setq swb/last-repeatable-command last-repeatable-command)))

(add-hook 'pre-command-hook 'swb/save-last-repeatable-command)

(defun swb/fix-repeatable-command (&rest _) (setq last-repeatable-command swb/last-repeatable-command))

(advice-add 'repeat :before 'swb/fix-repeatable-command)

(defun swb/delete-current-cursor (&optional back)
  (interactive)
  (let ((next-cursor
         (if back
             (mc/prev-fake-cursor-before-point)
           (mc/next-fake-cursor-after-point))))
    (when next-cursor
      (mc/pop-state-from-overlay next-cursor))))

(defun swb/delete-current-cursor-back ()
  (interactive)
  (swb/delete-current-cursor t))

(defun swb/forward-char-update-mark (&optional n)
  (interactive "p")
  (if swb/anchored (swb/start-marking) (deactivate-mark))
  (forward-char n))

(defun swb/backward-char-update-mark (&optional n)
  (interactive "p")
  (if swb/anchored (swb/start-marking) (deactivate-mark))
  (backward-char n))

(defun swb/forward-line-update-mark (&optional n)
  (interactive "p")
  (if swb/anchored (swb/start-marking) (deactivate-mark))
  (setq this-command 'next-line)
  (next-line n))

(defun swb/backward-line-update-mark (&optional n)
  (interactive "p")
  (if swb/anchored (swb/start-marking) (deactivate-mark))
  (setq this-command 'previous-line)
  (previous-line n))

(defun swb/expand (arg)
  (interactive "p")
  (when swb/anchored (swb/start-marking))
  (backward-up-list (abs arg) t t)
  (if swb/anchored
      (when (> arg 0) (forward-sexp))
    (if (> arg 0)
        (progn (set-mark (point))
               (forward-sexp))
      (mark-sexp))))

(defun swb/shrink (arg)
  (interactive "p")
  (unless mark-active (user-error "mark must be active"))
  (if (> (point) (mark))
      (progn
        (goto-char (- (point) 1))
        (set-mark (+ (mark) 1)))
    (goto-char (+ (point) 1))
    (set-mark (- (mark) 1))))

(defvar swb/reverse-one-shot nil)

(defun swb/begin-reverse-one-shot ()
  (interactive)
  (swb/simple-mode -1)
  (setq swb/reverse-one-shot t))

(add-hook 'pre-command-hook (swb/cmd
                              (when swb/reverse-one-shot
                                (swb/simple-mode)
                                (setq swb/reverse-one-shot nil))))

(defun wgreppable-mode (mode) (member mode '(grep-mode compilation-mode xref--xref-buffer-mode)))

(defun swb/writable-begin ()
  (interactive)
  (cond ((wgreppable-mode major-mode) (wgrep-change-to-wgrep-mode))
        ((eq major-mode 'dired-mode) (wdired-change-to-wdired-mode))
        (t (user-error "major mode not supported"))))

(defun swb/writable-cancel ()
  (interactive)
  (cond ((wgreppable-mode major-mode) (wgrep-abort-changes))
        ((eq major-mode 'wdired-mode) (wdired-abort-changes))
        (t (user-error "major mode not supported"))))

(defun swb/save-dwim ()
  (interactive)
  (cond ((eq major-mode 'grep-mode) (wgrep-finish-edit))
        ((eq major-mode 'wdired-mode) (wdired-finish-edit))
        (t (save-buffer))))

(defmacro swb/prompt-once-run-for-all-cursors (fn)
  (let ((name (intern (format "swb/prompt-once-run-for-all-cursors/%s" fn))))
    `(defun ,name (&rest args)
       ,(interactive-form fn)
       (mc/execute-command-for-all-cursors
        (lambda ()
          (interactive)
          (apply ,(list 'quote fn) args))))))

(defmacro swb/key (key-name command)
  `(bind-key ,key-name ,(macroexpand command) swb/simple-mode-map))

(swb/key [remap self-insert-command] 'ignore)

;; misc

(swb/key "<escape>" 'deactivate-mark)

(swb/key "1" 'digit-argument)
(swb/key "2" 'digit-argument)
(swb/key "3" 'digit-argument)
(swb/key "4" 'digit-argument)
(swb/key "5" 'digit-argument)
(swb/key "6" 'digit-argument)
(swb/key "7" 'digit-argument)
(swb/key "8" 'digit-argument)
(swb/key "9" 'digit-argument)
(swb/key "-" 'negative-argument)

(swb/key "C-/" (swb/cmd
                (deactivate-mark)
                (undo)
                (setq deactivate-mark nil)))

(swb/key "C--" 'text-scale-adjust)
(swb/key "C-=" 'text-scale-adjust)
(swb/key "C-0" 'text-scale-adjust)

(swb/key "`" 'swb/begin-reverse-one-shot)

;; movement/selection

(swb/key "h" 'swb/backward-char-update-mark)
(swb/key "j" 'swb/forward-line-update-mark)
(swb/key "k" 'swb/backward-line-update-mark)
(swb/key "l" 'swb/forward-char-update-mark)

;; these are flipped ???
(swb/key "C-u" 'scroll-down-command)
(swb/key "C-d" 'scroll-up-command)

(swb/key "b" 'swb/select-prev-vim-word)
(swb/key "e" 'swb/select-next-vim-word)

(swb/key "B" 'swb/select-prev-vim-WORD)
(swb/key "E" 'swb/select-next-vim-WORD)

(swb/key "t" (swb/prompt-once-run-for-all-cursors swb/till))
(swb/key "f" (swb/prompt-once-run-for-all-cursors swb/find))

(swb/key "," (swb/prompt-once-run-for-all-cursors swb/select-text-object-back))
(swb/key "." (swb/prompt-once-run-for-all-cursors swb/select-text-object))

(swb/key "M-," 'swb/mark-text-objects-in-region-back)
(swb/key "M-." 'swb/mark-text-objects-in-region)

(swb/key "C-," (swb/prompt-once-run-for-all-cursors swb/transpose-text-objects-back))
(swb/key "C-." (swb/prompt-once-run-for-all-cursors swb/transpose-text-objects))

(swb/key "'" 'swb/expand)
(swb/key "M-'" 'swb/shrink)

(defun swb/anchor () (interactive) (setq swb/anchored t) (force-mode-line-update))
(swb/key "v" 'swb/anchor)

(swb/key "x" 'swb/expand-to-lines)
(swb/key "o" 'swb/expand-to-line-text)

(swb/key ";" 'exchange-point-and-mark)
(swb/key "u" 'repeat)

(swb/key "s" 'vr/mc-mark)
(swb/key "/" 'swb/quit-mcs)

(swb/key "M-s" 'replace-string)

(swb/key "z" 'swb/pop-point-and-mark-from-ring)

(swb/key "q"   'mc/mark-previous-like-this)
(swb/key "Q"   'mc/skip-to-previous-like-this)
(swb/key "C-q" 'mc/cycle-backward)
(swb/key "M-q" 'swb/delete-current-cursor-back)
(swb/key "w"   'mc/mark-next-like-this)
(swb/key "W"   'mc/skip-to-next-like-this)
(swb/key "C-w" 'mc/cycle-forward)
(swb/key "M-w" 'swb/delete-current-cursor)

;; editing

(swb/key "i" 'swb/insert-before)
(swb/key "a" 'swb/insert-after)

(swb/key "d" 'swb/kill)
(swb/key "y" 'kill-ring-save)
(swb/key "p" (swb/cmd
              (setq swb/anchored nil)
              (yank)
              (setq deactivate-mark nil)
              (activate-mark)))
(swb/key "M-p" (swb/cmd
                (setq swb/anchored nil)
                (yank-pop)
                (setq deactivate-mark nil)
                (activate-mark)))
(swb/key "r" 'swb/replace)
(swb/key "c" 'swb/change)

;; pairs

(swb/key "[ i" 'swb/insert-above)
(swb/key "] i" 'swb/insert-below)

(swb/key "[ SPC" 'swb/newline-above)
(swb/key "] SPC" 'swb/newline-below)

(swb/key "[ e" 'previous-error)
(swb/key "] e" 'next-error)

(swb/key "[ f" 'flymake-goto-prev-error)
(swb/key "] f" 'flymake-goto-next-error)

;; go to commands

(swb/key "g d" 'xref-find-definitions)
(swb/key "g r" 'xref-find-references)
(swb/key "g b" 'xref-go-back)

(swb/key "g f" 'ffap)

(swb/key "g g" 'grep)
(swb/key "g l" 'goto-line)
(swb/key "g i" 'imenu)

;; leader commands

(swb/key "C-x" 'ignore)

(swb/key "SPC f" 'find-file)
(swb/key "SPC d" 'dired)
(swb/key "SPC b" 'switch-to-buffer)
(swb/key "SPC k" 'kill-buffer)
(swb/key "SPC g" 'magit-status)
(swb/key "SPC s" 'swb/save-dwim)
(swb/key "SPC Q" 'save-buffers-kill-emacs)
(swb/key "SPC c" 'compile)
(swb/key "SPC r" 'recompile)
(swb/key "SPC p" (global-key-binding (kbd "C-x p")))

(swb/key "SPC e a" 'eglot-code-actions)
(swb/key "SPC e r" 'eglot-rename)
(swb/key "SPC e o" 'eglot-code-action-organize-imports)

(swb/key "SPC h t" 'hs-toggle-hiding)
(swb/key "SPC h s" 'hs-show-all)
(swb/key "SPC h h" 'hs-hide-all)

(swb/key "SPC m r" 'mc/reverse-regions)

(swb/key "SPC w b" 'swb/writable-begin)
(swb/key "SPC w c" 'swb/writable-cancel)

(defun swb/surround (begin end) (save-mark-and-excursion
                                  (swb/go-to-beginning-of-region)
                                  (insert-char begin)
                                  (swb/go-to-end-of-region)
                                  (insert-char end)))

(defun swb/surround-char (char) (interactive "cCharacter:") (swb/surround char char))

(swb/key "SPC a c" (swb/prompt-once-run-for-all-cursors swb/surround-char))
(swb/key "SPC a {" (swb/cmd (swb/surround ?{ ?})))
(swb/key "SPC a [" (swb/cmd (swb/surround ?[ ?])))
(swb/key "SPC a (" (swb/cmd (swb/surround ?( ?))))
(swb/key "SPC a <" (swb/cmd (swb/surround ?< ?>)))
(swb/key "SPC a \"" (swb/cmd (swb/surround ?\" ?\")))
(swb/key "SPC a RET" (swb/cmd (swb/surround ?\n ?\n)))
(swb/key "SPC a DEL" (swb/cmd (save-mark-and-excursion
                                (let ((delete-active-region nil))
                                  (swb/go-to-beginning-of-region)
                                  (delete-char 1)
                                  (swb/go-to-end-of-region)
                                  (delete-char -1)))))

;; window commands

(swb/key "\\ h" 'windmove-left)
(swb/key "\\ j" 'windmove-down)
(swb/key "\\ k" 'windmove-up)
(swb/key "\\ l" 'windmove-right)

(swb/key "\\ s h" 'windmove-swap-states-left)
(swb/key "\\ s j" 'windmove-swap-states-down)
(swb/key "\\ s k" 'windmove-swap-states-up)
(swb/key "\\ s l" 'windmove-swap-states-right)

(swb/key "\\ b" 'split-window-right)
(swb/key "\\ v" 'split-window-below)

(swb/key "\\ q" 'delete-window)
(swb/key "\\ o" 'delete-other-windows)

(swb/key "\\ /" 'winner-undo)
(swb/key "\\ ?" 'winner-redo)

;; tab commands

(swb/key "SPC t n" 'tab-new)
(swb/key "SPC t q" 'tab-close)
(swb/key "SPC t o" 'tab-close-other)

(swb/key "SPC 1" 'tab-select)
(swb/key "SPC 2" 'tab-select)
(swb/key "SPC 3" 'tab-select)
(swb/key "SPC 4" 'tab-select)
(swb/key "SPC 5" 'tab-select)
(swb/key "SPC 6" 'tab-select)
(swb/key "SPC 7" 'tab-select)
(swb/key "SPC 8" 'tab-select)
(swb/key "SPC 9" 'tab-select)
