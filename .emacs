(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(epg-gpg-program "gpg")
 '(package-selected-packages
   '(corfu-terminal odin-mode visual-regexp visual-regexp-steroids))
 '(package-vc-selected-packages '((odin-mode :url "https://github.com/mattt-b/odin-mode"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(eglot-diagnostic-tag-unnecessary-face ((t (:inherit shadow :underline t))))
 '(eglot-highlight-symbol-face ((t (:foreground "#FF00FF"))))
 '(eglot-inlay-hint-face ((t (:inherit shadow))))
 '(flymake-end-of-line-diagnostics-face ((t (:inherit nil :box nil :height 1.0))))
 '(flymake-error ((t (:inherit error :underline t))))
 '(flymake-note ((t (:inherit success :underline t))))
 '(flymake-warning ((t (:inherit warning :underline t))))
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
  (defun swb/editor-mode () (cond (swb/simple-mode (propertize "NORMAL" 'face 'bold))
                                  (t               (propertize "INSERT" 'face 'warning))))
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
(use-package flymake :custom (flymake-indicator-type 'fringes))

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
  ("C-c e o" . eglot-code-action-organize-imports)
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
  :demand
  :bind (:map mc/keymap ("<return>" . nil))
  :config
  ;; don't want C-g to quit multiple cursors
  (push 'corfu-mode mc/unsupported-minor-modes)
  (push 'swb/point-and-mark-ring mc/cursor-specific-vars)
  (defun mc/keyboard-quit () (interactive) (when (use-region-p) (deactivate-mark)))
  (defun swb/quit-mcs () (interactive) (mc/disable-multiple-cursors-mode)))

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
        (unless (terminal-parameter term 'esc-map)
          (let ((esc-map (lookup-key input-decode-map [?\e])))
            (set-terminal-parameter term 'esc-map esc-map)
            (define-key input-decode-map [?\e] `(menu-item "" ,esc-map :filter ,#'swb/esc)))))))

  (add-hook 'after-make-frame-functions 'swb/fix-term-esc)
  (mapc 'swb/fix-term-esc (frame-list)))

(global-set-key (kbd "<escape>") 'swb/simple-mode)

(define-minor-mode swb/simple-mode "Simple editing mode"
  :init-value t
  :keymap (make-sparse-keymap)
  :after-hook
  (deactivate-mark)
  (corfu-quit)
  (force-mode-line-update)
  (setq swb/anchored nil))

(add-hook 'minibuffer-mode-hook (lambda () (interactive) (swb/simple-mode -1)))
(add-hook 'git-commit-mode-hook (lambda () (interactive) (swb/simple-mode -1)))

(defvar-local swb/anchored nil)

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
          (when (and (= next-char (string-to-char pop)) (/= prev-char (string-to-char push)))
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

(defun swb/add-text-object (char inner-beg inner-end &optional outer-beg outer-end)
  (push (list char . (inner-beg
                      inner-end
                      (or outer-beg inner-beg)
                      (or outer-end inner-end)))
        swb/text-objects))

(defun swb/add-delimited-text-object (char opener closer)
  (swb/add-text-object char
                       `(lambda () (interactive) (swb/find-delimiter ,opener ,closer t t))
                       `(lambda () (interactive) (swb/find-delimiter ,opener ,closer nil t))
                       `(lambda () (interactive) (swb/find-delimiter ,opener ,closer t nil))
                       `(lambda () (interactive) (swb/find-delimiter ,opener ,closer nil nil))))

(defun swb/add-regex-contained-text-object (char opener &optional closer)
  (setq closer (or closer opener))
  (swb/add-text-object char
                       `(lambda () (interactive) (swb/find-regex ,opener t t))
                       `(lambda () (interactive) (swb/find-regex ,closer nil t))
                       `(lambda () (interactive) (swb/find-regex ,opener t nil))
                       `(lambda () (interactive) (swb/find-regex ,closer nil nil))))

(defun swb/execute-text-object-fn (char element)
  (let ((object (assoc char swb/text-objects)))
    (unless object (user-error (format "Invalid object \"%c\"" char)))
    (funcall (nth element (cdr object)))))

(defun swb/select-text-object-generic (n char forward-index backward-index)
  (when (< n 0)
    (setq n (- n))
    (cl-rotatef forward-index backward-index))
  (when swb/anchored (swb/start-marking))
  (dotimes (i n) (swb/execute-text-object-fn char forward-index))
  (unless swb/anchored
    (set-mark (point))
    (swb/execute-text-object-fn char backward-index)
    (exchange-point-and-mark)))

(defun swb/select-prev-text-object-inner (n char) (interactive "p\ncObject:") (swb/select-text-object-generic n char 0 1))
(defun swb/select-next-text-object-inner (n char) (interactive "p\ncObject:") (swb/select-text-object-generic n char 1 0))
(defun swb/select-prev-text-object-outer (n char) (interactive "p\ncObject:") (swb/select-text-object-generic n char 2 3))
(defun swb/select-next-text-object-outer (n char) (interactive "p\ncObject:") (swb/select-text-object-generic n char 3 2))

(setq swb/text-objects nil) ;; just makes it easier to re-eval all this
(swb/add-text-object ?p 'start-of-paragraph-text 'end-of-paragraph-text 'backward-paragraph 'forward-paragraph)
(swb/add-text-object ?l 'swb/backward-line-text 'swb/forward-line-text 'swb/backward-line 'forward-line)
(swb/add-text-object ?b 'beginning-of-buffer 'end-of-buffer)
(swb/add-text-object ?x 'backward-sexp 'forward-sexp)
(swb/add-text-object ?f 'beginning-of-defun 'end-of-defun)
(swb/add-text-object ?w 'backward-word 'forward-word)
(swb/add-text-object ?W (lambda () (forward-symbol -1)) (lambda () (forward-symbol 1)))

(swb/add-delimited-text-object ?r "(" ")")
(swb/add-delimited-text-object ?c "{" "}")
(swb/add-delimited-text-object ?s "[" "]")
(swb/add-delimited-text-object ?a "<" ">")

(swb/add-regex-contained-text-object ?  "[ \n]")
(swb/add-regex-contained-text-object ?g "\"")
(swb/add-regex-contained-text-object ?q "'")

(defun swb/go-to-beginning-of-region () (interactive) (when (and mark-active (> (point) (mark))) (exchange-point-and-mark)))
(defun swb/go-to-end-of-region () (interactive) (when (and mark-active (< (point) (mark))) (exchange-point-and-mark)))

(defun swb/insert-before ()
  (interactive)
  (swb/go-to-beginning-of-region)
  (swb/simple-mode -1))

(defun swb/insert-before-line-text ()
  (interactive)
  (back-to-indentation)
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

(defun swb/insert-after-line-text ()
  (interactive)
  (end-of-line)
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
  (if mark-active (kill-region nil nil t) (delete-char 1))
  (setq swb/anchored nil))

(defun swb/delete ()
  (interactive)
  (if mark-active (delete-region (point) (mark)) (delete-char 1))
  (setq swb/anchored nil))

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

(defun swb/find (arg char)
  (interactive "p\ncFind:")
  (let ((end (save-mark-and-excursion (search-forward (char-to-string char) nil t arg))))
    (when end
      (unless swb/anchored (deactivate-mark))
      (swb/start-marking)
      (goto-char end))))

(defun swb/till (arg char)
  (interactive "p\ncTill:")
  (let ((end (save-mark-and-excursion
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
    (ring-insert swb/point-and-mark-ring (list (point) (if mark-active (mark) nil)))
    (setq swb/last-point-push-command last-command)))

(add-hook 'pre-command-hook 'swb/maybe-push-point-to-ring)
(add-hook 'post-command-hook 'swb/maybe-push-point-to-ring)

(defun swb/go-to-point-and-mark (point-and-mark)
  (goto-char (car point-and-mark))
  (let ((mark (cadr point-and-mark))) (if mark (set-mark mark) (deactivate-mark))))

(defun swb/pop-point-and-mark-from-ring (arg)
  (interactive "p")
  (let* ((back (< arg 0))
         (point-and-mark (swb/ring-rotate swb/point-and-mark-ring back)))
    (when (swb/at-point-and-mark point-and-mark) (setq point-and-mark (swb/ring-rotate swb/point-and-mark-ring back)))
    (swb/go-to-point-and-mark point-and-mark)))

(defun swb/reset-point-and-mark-ring-for-all-cursors ()
  (mc/execute-command-for-all-cursors (lambda () (interactive) (setq swb/point-and-mark-ring (swb/make-point-and-mark-ring)))))

(advice-add 'mc/maybe-multiple-cursors-mode :after 'swb/reset-point-and-mark-ring-for-all-cursors)

(defun swb/make-repeat-behave-with-multiple-cursors (orig-fn repeat-arg)
  (when (eq last-repeatable-command 'repeat)
    (setq last-repeatable-command repeat-previous-repeated-command))

  (if (memq last-repeatable-command mc/cmds-to-run-for-all)
      (mc/execute-command-for-all-cursors (lambda () (interactive) (funcall orig-fn repeat-arg)))
    (funcall orig-fn repeat-arg)))

(advice-add 'repeat :around 'swb/make-repeat-behave-with-multiple-cursors)

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
  (next-line n))

(defun swb/backward-line-update-mark (&optional n)
  (interactive "p")
  (if swb/anchored (swb/start-marking) (deactivate-mark))
  (previous-line n))

(defmacro swb/prompt-once-run-for-all-cursors (fn)
  (let ((name (intern (format "swb/prompt-once-run-for-all-cursors/%s" fn))))
    `(defun ,name (&rest args)
       ,(interactive-form fn)
       (mc/execute-command-for-all-cursors
        (lambda ()
          (interactive)
          (apply ,(list 'quote fn) args))))))

(bind-key [remap self-insert-command] 'ignore 'swb/simple-mode-map)

(bind-keys :map swb/simple-mode-map
           ("<escape>" . (lambda () (interactive) (deactivate-mark) (setq swb/anchored nil)))

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

           ("i"   . swb/insert-before)
           ("a"   . swb/insert-after)
           ("I"   . swb/insert-before-line-text)
           ("A"   . swb/insert-after-line-text)
           ("M-i" . swb/insert-above)
           ("M-a" . swb/insert-below)

           ("d" . swb/kill)
           ("c" . swb/change)
           ("y" . kill-ring-save)
           ("p" . yank)
           ("r" . swb/replace)

           ("h" . swb/backward-char-update-mark)
           ("j" . swb/forward-line-update-mark)
           ("k" . swb/backward-line-update-mark)
           ("l" . swb/forward-char-update-mark)

           ("e" . swb/select-next-symbol)
           ("b" . swb/select-prev-symbol)

           ("x" . swb/select-line)

           ("v" . (lambda () (interactive) (setq swb/anchored t)))

           ("s"   . vr/mc-mark)
           ("M-<" . mc/skip-to-previous-like-this)
           ("M->" . mc/skip-to-next-like-this)
           ("<"   . mc/mark-previous-like-this)
           (">"   . mc/mark-next-like-this)
           ("/"   . swb/quit-mcs)

           ("g d" . xref-find-definitions)
           ("g r" . xref-find-references)
           ("g b" . xref-go-back)
           ("g f" . flymake-goto-next-error)
           ("g c" . next-error)

           ("z" . swb/pop-point-and-mark-from-ring)
           )

(bind-key "f" (swb/prompt-once-run-for-all-cursors swb/find) swb/simple-mode-map)
(bind-key "t" (swb/prompt-once-run-for-all-cursors swb/till) swb/simple-mode-map)

(bind-key "[" (swb/prompt-once-run-for-all-cursors swb/select-prev-text-object-inner) swb/simple-mode-map)
(bind-key "]" (swb/prompt-once-run-for-all-cursors swb/select-next-text-object-inner) swb/simple-mode-map)

(bind-key "M-[" (swb/prompt-once-run-for-all-cursors swb/select-prev-text-object-outer) swb/simple-mode-map)
(bind-key "M-]" (swb/prompt-once-run-for-all-cursors swb/select-next-text-object-outer) swb/simple-mode-map)
