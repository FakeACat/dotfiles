;;; ...  -*- lexical-binding: t -*-

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(epg-gpg-program "gpg")
 '(package-selected-packages
   '(cape cmake-mode consult corfu doom-themes format-all frames-only-mode
          glsl-mode json-mode magit markdown-mode multiple-cursors odin-mode
          orderless rust-mode vertico visual-regexp-steroids zig-mode))
 '(package-vc-selected-packages '((odin-mode :url "https://github.com/mattt-b/odin-mode"))))

(defmacro swb/cmd (&rest body) `(lambda (&rest _) (interactive) ,@body))

(use-package package
  :config (add-to-list 'package-archives
                       '("melpa" . "https://melpa.org/packages/") t))

(use-package use-package-core
  :custom (use-package-always-defer 1))

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
  (tab-width 4)
  (use-short-answers 1)
  (dabbrev-case-fold-search nil)
  (ring-bell-function 'ignore)
  (mode-line-format nil)
  (server-client-instructions nil)
  (vc-follow-symlinks t)
  (cursor-type 'bar)
  :config
  (tool-bar-mode 0)
  (menu-bar-mode 0)
  (server-start))

(use-package novice
  :custom (disabled-command-function nil))

(use-package elec-pair
  :config (electric-pair-mode 1))

(use-package savehist
  :config (savehist-mode 1))

(use-package autorevert
  :config (global-auto-revert-mode 1))

(use-package saveplace
  :config (save-place-mode 1))

(use-package scroll-bar
  :config (scroll-bar-mode 0))

(use-package subword
  :config (global-subword-mode 1))

(use-package hideshow
  :hook (prog-mode-hook . hs-minor-mode))

(use-package org
  :custom (org-hide-emphasis-markers t))

(use-package cc-vars
  :custom (c-basic-offset 4))

(use-package cc-styles
  :hook
  (java-mode-hook . (lambda ()
                      (c-set-offset 'case-label '+)))) ;; fix switch indenting in java

(use-package dired
  :custom
  (dired-auto-revert-buffer #'dired-buffer-stale-p)
  (dired-dwim-target t))

(use-package which-key
  :config (which-key-mode))

(use-package show-paren
  :custom (show-paren-delay 0))

(use-package flymake
  :custom
  (flymake-show-diagnostics-at-end-of-line t)
  (flymake-indicator-type 'fringes))

(use-package frame
  :custom
  (window-divider-default-places t)
  (window-divider-default-bottom-width 1)
  (window-divider-default-right-width 1)
  :config
  (window-divider-mode 1)
  (blink-cursor-mode -1))

(use-package display-fill-column-indicator
  :custom (fill-column 80)
  :config (global-display-fill-column-indicator-mode))

(use-package doom-themes
  :ensure
  :demand
  :config (load-theme 'doom-solarized-dark t))

(use-package display-line-numbers
  :custom (display-line-numbers-type 'relative)
  :config (global-display-line-numbers-mode))

(use-package hl-line
  :config (global-hl-line-mode 1))

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

(use-package isearch
  :bind (:map isearch-mode-map
              ("RET" . swb/isearch-done-select)
              ("<return>" . swb/isearch-done-select))
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
  (add-hook 'isearch-mode-hook #'swb/isearch-with-region))

(use-package cape
  :ensure
  :init
  (add-hook 'completion-at-point-functions
            (cape-capf-super #'cape-dabbrev #'cape-keyword)))

(use-package magit
  :ensure
  :custom (magit-save-repository-buffers nil))

(use-package orderless
  :ensure
  :custom (completion-styles '(orderless)))

(use-package vertico
  :ensure
  :init (vertico-mode))

(use-package corfu
  :ensure
  :custom
  (corfu-cycle 1)
  (corfu-quit-at-boundary nil)
  :init
  (global-corfu-mode 1)
  (corfu-echo-mode 1)
  (corfu-history-mode 1))

(use-package zig-mode
  :ensure)

(use-package glsl-mode
  :ensure
  :mode "\\.vs\\'" "\\.fs\\'")

(use-package odin-mode
  :vc (:url "https://github.com/mattt-b/odin-mode"))

(use-package markdown-mode
  :ensure)

(use-package cmake-mode
  :ensure)

(use-package rust-mode
  :ensure)

(use-package json-mode
  :ensure)

(use-package format-all
  :ensure
  :hook (prog-mode . format-all-mode)
  :config
  (setq-default format-all-formatters
                '(("Java" (astyle "--mode=java"))
                  ("C" (clang-format))
                  ("Rust" (rustfmt)))))

(use-package visual-regexp
  :ensure)

(use-package visual-regexp-steroids
  :ensure)

(use-package multiple-cursors
  :ensure
  :demand
  :bind (:map mc/keymap ("<return>" . nil))
  :config
  ;; don't want C-g to quit multiple cursors
  (push 'corfu-mode mc/unsupported-minor-modes)
  (push 'global-hl-line-mode mc/unsupported-minor-modes)
  (push 'swb/point-and-mark-ring mc/cursor-specific-vars)
  (defun mc/keyboard-quit ()
    (interactive)
    (when (use-region-p)
      (deactivate-mark)))
  (defun swb/quit-mcs ()
    (interactive)
    (mc/disable-multiple-cursors-mode)))

(use-package frames-only-mode
  :ensure
  :demand
  :config (frames-only-mode))

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
  (setq swb/anchored nil))

(add-hook 'minibuffer-mode-hook (lambda () (interactive) (swb/simple-mode -1)))
(add-hook 'git-commit-mode-hook (lambda () (interactive) (swb/simple-mode -1)))

(defvar-local swb/anchored nil)

(advice-add 'deactivate-mark :after (swb/cmd (setq swb/anchored nil)))

(defun swb/start-marking () (interactive) (unless mark-active (set-mark (point))))
(defun swb/stop-marking () (interactive) (when mark-active (deactivate-mark)))

(defun swb/backward-line ()
  (let ((point (point)))
    (beginning-of-line)
    (when (= point (point)) (forward-line -1))))

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

(defun swb/find-delimiter (opener closer back till)
  (cl-assert (= (length opener) 1))
  (cl-assert (= (length closer) 1))

  (let ((search-fn (if back 'search-backward 'search-forward))
        (push (if back closer opener))
        (pop (if back opener closer))
        (initial-point (point))
        (layers 1)
        (failed nil)
        (first-pop nil))

    ;; needs to skip over pop symbols if till, else skip over push symbols
    ;; this lets regions expand correctly
    (let ((next-char (if back (char-before) (char-after)))
          (prev-char (if back (char-after) (char-before))))
      (if till
          (when (and (= next-char (string-to-char pop))
                     (/= prev-char (string-to-char push)))
            (forward-char (if back -1 1)))
        (when (= next-char (string-to-char push))
          (forward-char (if back -1 1)))))

    (while (and (> layers 0) (not failed))
      (let* ((next-push (save-excursion (funcall search-fn push nil t)))
             (next-pop (save-excursion (funcall search-fn pop nil t)))
             (push-dist (if next-push (abs (- next-push (point))) nil))
             (pop-dist (if next-pop (abs (- next-pop (point))) nil)))
        (cond
         ((not next-pop)
          (setq failed t))
         ((or (not next-push) (< pop-dist push-dist))
          (goto-char next-pop)
          (setq layers (- layers 1))
          (when (= layers 1) (unless first-pop (setq first-pop next-pop))))
         (t
          (goto-char next-push)
          (setq layers (+ layers 1))))))

    (if failed
        (progn (goto-char (or first-pop initial-point))
               (when (and till first-pop) (forward-char (if back 1 -1))))
      (when till (forward-char (if back 1 -1))))))

(defun swb/find-regex (regex &optional back till)
  (let* ((search-fn          (if back 're-search-backward 're-search-forward))
         (backward-search-fn (if back 're-search-forward 're-search-backward))
         (end (save-excursion
                (forward-char (if back (- 1) 1))
                (funcall search-fn regex nil t))))
    (swb/start-marking)
    (when end
      (goto-char end)
      (when till (funcall backward-search-fn regex nil t)))))

(defvar swb/text-objects)

(defun swb/add-text-object (char
                            inner-beg
                            inner-end
                            &optional
                            outer-beg
                            outer-end)
  (push (list char . (inner-beg
                      inner-end
                      (or outer-beg inner-beg)
                      (or outer-end inner-end)))
        swb/text-objects))

(defun swb/add-delimited-text-object (char opener closer)
  (swb/add-text-object char
                       `(lambda ()
                          (interactive)
                          (swb/find-delimiter ,opener ,closer t t))
                       `(lambda ()
                          (interactive)
                          (swb/find-delimiter ,opener ,closer nil t))
                       `(lambda ()
                          (interactive)
                          (swb/find-delimiter ,opener ,closer t nil))
                       `(lambda ()
                          (interactive)
                          (swb/find-delimiter ,opener ,closer nil nil))))

(defun swb/add-regex-contained-text-object (char opener &optional closer)
  (setq closer (or closer opener))
  (swb/add-text-object char
                       `(lambda ()
                          (interactive)
                          (swb/find-regex ,opener t t))
                       `(lambda ()
                          (interactive)
                          (swb/find-regex ,closer nil t))
                       `(lambda ()
                          (interactive)
                          (swb/find-regex ,opener t nil))
                       `(lambda ()
                          (interactive)
                          (swb/find-regex ,closer nil nil))))

(defun swb/execute-text-object-fn (char element)
  (let ((object (assoc char swb/text-objects)))
    (unless object (user-error (format "Invalid object \"%c\"" char)))
    (funcall (nth element (cdr object)))))

(defun swb/select-text-object-generic (n char forward-index backward-index)
  (when (< n 0)
    (setq n (- n))
    (cl-rotatef forward-index backward-index))
  (when swb/anchored (swb/start-marking))
  (swb/execute-text-object-fn char forward-index)
  (unless swb/anchored
    (set-mark (point))
    (swb/execute-text-object-fn char backward-index)
    (exchange-point-and-mark))
  (dotimes (i (- n 1)) (swb/execute-text-object-fn char forward-index)))

(defun swb/select-prev-text-object-inner (n char)
  (interactive "p\ncObject:")
  (swb/select-text-object-generic n char 0 1))

(defun swb/select-next-text-object-inner (n char)
  (interactive "p\ncObject:")
  (swb/select-text-object-generic n char 1 0))

(defun swb/select-prev-text-object-outer (n char)
  (interactive "p\ncObject:")
  (swb/select-text-object-generic n char 2 3))

(defun swb/select-next-text-object-outer (n char)
  (interactive "p\ncObject:")
  (swb/select-text-object-generic n char 3 2))

(defun swb/mark-text-objects-in-region (char &optional outer back)
  (interactive "cObject:")
  (when (not mark-active) (user-error "mark must be active"))
  (mc/execute-command-for-all-cursors
   (swb/cmd
    (let ((point (point))
          (mark (mark)))
      (deactivate-mark)
      (when (> point mark) (cl-rotatef mark point))
      (goto-char point)
      (let ((prev-point (point-min)))
        (while (and (< (point) mark) (< prev-point (point)))
          (setq prev-point (point))
          (if outer
              (swb/select-next-text-object-outer 1 char)
            (swb/select-next-text-object-inner 1 char))
          (when (< (mark) mark) (mc/create-fake-cursor-at-point))))
      (mc/pop-state-from-overlay (car (mc/all-fake-cursors))))))
  (mc/maybe-multiple-cursors-mode)
  (when back
    (mc/execute-command-for-all-cursors
     (swb/cmd (exchange-point-and-mark)))))

(defun swb/mark-inner-text-objects-in-region-back (char)
  (interactive "cObject:")
  (swb/mark-text-objects-in-region char nil t))

(defun swb/mark-outer-text-objects-in-region (char)
  (interactive "cObject:")
  (swb/mark-text-objects-in-region char t))

(defun swb/mark-outer-text-objects-in-region-back (char)
  (interactive "cObject:")
  (swb/mark-text-objects-in-region char t t))

(setq swb/text-objects nil) ;; just makes it easier to re-eval all this

(swb/add-text-object ?p
                     'start-of-paragraph-text
                     'end-of-paragraph-text
                     'backward-paragraph
                     'forward-paragraph)

(swb/add-text-object ?l
                     'swb/backward-line-text
                     'swb/forward-line-text
                     'swb/backward-line
                     'forward-line)

(swb/add-text-object ?b
                     'beginning-of-buffer
                     'end-of-buffer)

(swb/add-text-object ?x
                     'backward-sexp
                     'forward-sexp)

(swb/add-text-object ?f
                     'beginning-of-defun
                     'end-of-defun)

(swb/add-text-object ?w
                     'backward-word
                     'forward-word)

(swb/add-text-object ?W
                     (lambda () (forward-symbol -1))
                     (lambda () (forward-symbol 1)))

(swb/add-text-object ?j
                     'swb/backward-line-join
                     'swb/forward-line-join)

(swb/add-text-object ?e
                     'swb/backward-argument
                     'swb/forward-argument)

(swb/add-delimited-text-object ?r "(" ")")
(swb/add-delimited-text-object ?c "{" "}")
(swb/add-delimited-text-object ?s "[" "]")
(swb/add-delimited-text-object ?a "<" ">")

(swb/add-regex-contained-text-object ?g "\"")
(swb/add-regex-contained-text-object ?q "'")

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

(defun swb/select-next-symbol (arg)
  (interactive "p")
  (swb/select-next-text-object-inner arg ?W))

(defun swb/select-prev-symbol (arg)
  (interactive "p")
  (swb/select-prev-text-object-inner arg ?W))

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

(swb/key "\\" 'hs-toggle-hiding)
(swb/key "C-/" (swb/cmd (save-mark-and-excursion
                          (deactivate-mark)
                          (undo)
                          (setq deactivate-mark nil))))

;; movement/selection

(swb/key "h" 'swb/backward-char-update-mark)
(swb/key "j" 'swb/forward-line-update-mark)
(swb/key "k" 'swb/backward-line-update-mark)
(swb/key "l" 'swb/forward-char-update-mark)

(swb/key "M-j" 'scroll-up-command)
(swb/key "M-k" 'scroll-down-command)

(swb/key "b" 'swb/select-prev-symbol)
(swb/key "e" 'swb/select-next-symbol)

(swb/key "t" (swb/prompt-once-run-for-all-cursors swb/till))
(swb/key "f" (swb/prompt-once-run-for-all-cursors swb/find))

(swb/key "n" (swb/prompt-once-run-for-all-cursors
              swb/select-prev-text-object-inner))
(swb/key "m" (swb/prompt-once-run-for-all-cursors
              swb/select-next-text-object-inner))
(swb/key "," (swb/prompt-once-run-for-all-cursors
              swb/select-prev-text-object-outer))
(swb/key "." (swb/prompt-once-run-for-all-cursors
              swb/select-next-text-object-outer))

(swb/key "M-n" 'swb/mark-inner-text-objects-in-region-back)
(swb/key "M-m" 'swb/mark-text-objects-in-region)
(swb/key "M-," 'swb/mark-outer-text-objects-in-region-back)
(swb/key "M-." 'swb/mark-outer-text-objects-in-region)

(swb/key "v" (swb/cmd (setq swb/anchored t)))

(swb/key "x" 'swb/expand-to-lines)
(swb/key "o" 'swb/expand-to-line-text)

(swb/key ";" 'exchange-point-and-mark)
(swb/key "u" 'repeat)

(swb/key "s" 'vr/mc-mark)
(swb/key "/" 'swb/quit-mcs)

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

;; leader commands

(swb/key "SPC f" 'find-file)
(swb/key "SPC b" 'switch-to-buffer)
(swb/key "SPC k" 'kill-buffer)
(swb/key "SPC g" 'magit-status)
(swb/key "SPC s" 'save-buffer)
(swb/key "SPC c" 'compile)
(swb/key "SPC p" (global-key-binding (kbd "C-x p")))
(swb/key "SPC e a" 'eglot-code-actions)
(swb/key "SPC e r" 'eglot-rename)
(swb/key "SPC e o" 'eglot-code-action-organize-imports)

;; this is a terrible hack
;; hopefully fixes the screen not redrawing correctly sometimes
(add-hook 'post-command-hook 'redraw-frame)
