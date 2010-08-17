;; {{{
;; Place backups in a non-evident directory.

(setq backup-directory-alist (quote ((".*" . "~/.emacs.d/backups"))))

;; }}}

(add-to-list 'load-path "~/elisp/")
(add-to-list 'load-path "~/elisp/ruby-mode")
(add-to-list 'load-path "~/elisp/color-theme-6.6.0")
(add-to-list 'load-path "~/elisp/twittering-mode")

(require 'twittering-mode)

(menu-bar-mode 1)
(require 'zenburn)
(require 'magit)
(require 'multi-term)

(zenburn)

(require 'smart-compile)

(set-background-color "black")
(set-foreground-color "white")

(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; {{{
;; Ruby-mode.

(autoload 'ruby-mode "ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))

;; }}}

;; {{{
;; C-indentation/appearance related stuff.

(global-font-lock-mode t)
(defun linux-c-mode ()
  "C mode with adjusted defaults for use with the Linux kernel."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (global-set-key "\C-u" 'c-electric-delete)
  (setq tab-width 8)
  (setq indent-tabs-mode t)
  (setq c-basic-offset 2))

(setq kill-whole-line t)
(setq c-hungry-delete-key t)

(setq c-auto-newline 0)

(add-hook 'c-mode-common-hook
          '(lambda ()
             (turn-on-auto-fill)
             (setq fill-column 75)
             (setq comment-column 60)
             (modify-syntax-entry ?_ "w") ;; '_' is now a delimiter.
             (c-set-style "ellemtel") ;; indentation style
             (local-set-key [(control tab)] ;; move to next temporary mark
                            'tempo-forward-mark)
             ))

;; }}}

(transient-mark-mode t)
(autoload 'javascript-mode "javascript" nil t)

;; {{{
;; General look and feel.
(setq default-frame-alist
      '((top . 80) (left . 64)
	(width . 75) (height . 40)
	(cursor-type . box)))
;; }}}

(add-hook 'octave-mode-hook
(lambda()
(setq octave-auto-indent 1)
(setq octave-blink-matching-block 1)
(setq octave-block-offset 8)
(setq octave-send-line-auto-forward 0)
(abbrev-mode 1)
(auto-fill-mode 1)
(if (eq window-system 'x)
(font-lock-mode 1))))

;; {{{
;; Codepad.

(add-to-list 'load-path "~/elisp/emacs-codepad")
(autoload 'codepad-paste-region "codepad" "Paste region to codepad.org." t)
(autoload 'codepad-paste-buffer "codepad" "Paste buffer to codepad.org." t)
(autoload 'codepad-fetch-code "codepad" "Fetch code from codepad.org." t)

;; }}}

;; {{{
;; Autocomplete Stuff.

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/elisp/auto-complete-1.3//ac-dict")
(ac-config-default)

;; dirty fix for having AC everywhere, can get annoying.

(define-globalized-minor-mode real-global-auto-complete-mode
  auto-complete-mode (lambda ()
		       (if (not (minibufferp (current-buffer)))
			   (auto-complete-mode 1))
		       ))
(real-global-auto-complete-mode t)

;; }}}

;; {{{
;; ERC stuff.

(require 'erc-nick-colors)
(require 'erc-log)

(erc-spelling-mode 1)

(setq erc-prompt ">")
(setq erc-modules (delq 'fill erc-modules))
(require 'erc-fill)                     ;Support for message filling
(erc-fill-disable)			;  but disable it by default.

(require 'erc-log)                      ;Enable IRC message logging
(setq erc-log-channels-directory "/home/parser/.erc/logs/")
(setq erc-save-buffer-on-part t         ; Laptop friendly logging.
      erc-save-queries-on-quit t
      erc-log-write-after-send nil
      erc-log-write-after-insert nil)
(erc-log-enable)

(require 'erc-ring)
(erc-ring-mode 1)

(setq erc-user-full-name "parser"
      erc-email-userid "parser")

;; Some defaults for /part and buffer killing.
(setq erc-kill-queries-on-quit nil)
(setq erc-kill-buffer-on-part nil)
(setq erc-kill-server-buffer-on-quit nil)


;; Send notices to the minibuffer, when the server window is invisible?
(setq erc-minibuffer-notice nil)

(setq erc-hide-list '("JOIN" "NICK" "PART" "QUIT"))

;; }}}

;; {{{
;; MPD-ERC mode.

(defun mpd-erc-np ()
  (interactive)
  (erc-send-message
   (concat "NP: "
	   (let* ((string (shell-command-to-string "mpc")))
	     (string-match "[^/]*$" string)
	     (match-string 0 string)))))
;; }}}


;; {{{
;; Mozilla REPL, Javascript stuff.
(add-to-list 'load-path "~/elisp/mozrepl")

;; JS Major mode.

(autoload 'js-mode "js-mode")
(add-to-list 'auto-mode-alist '("\\.js$" . js-mode))
(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)
(add-hook 'js-mode-hook 'js-mozrepl-custom-setup)
(defun js-mozrepl-custom-setup ()
  (moz-minor-mode 1))

;; }}}

;; {{{
;; Mpd-np.

(defun mpd-erc-np ()
      (interactive)
      (erc-send-message
       (concat "NP: "
(let* ((string (shell-command-to-string "mpc")))
(string-match "[^/]*$" string)
(match-string 0 string)))))

;; }}}

;; {{{
;; Lua-mode
(setq auto-mode-alist (cons '("\\.lua$" . lua-mode) auto-mode-alist))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-hook 'lua-mode-hook 'turn-on-font-lock)
(add-hook 'lua-mode-hook 'hs-minor-mode)

;; }}}

;; {{{
;; Python-Mode

(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))

(add-hook 'python-mode-hook
	  (lambda ()
	    (set (make-variable-buffer-local 'beginning-of-defun-function)
		 'py-beginning-of-def-or-class)
	    (setq outline-regexp "def\\|class ")))

;; }}}

;; {{{
;; Ruby stuff.

;; {{{
;; RVM integration

(require 'rvm)

(rvm-use-default) ;; use rvm’s default ruby for the current Emacs session

;; }}}

(autoload 'ruby-mode "ruby-mode" "Ruby Mode." t)
(add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))

;; }}}

;; {{{
;; Slime mode

(add-to-list 'load-path "~/elisp/slime/")
(setq inferior-lisp-program "/usr/bin/sbcl")
(require 'slime)

(slime-setup '(
	       slime-parse slime-mrepl
			   slime-autodoc
			   slime-references
			   slime-fancy))

;; }}}

;; {{{ 
;; ERC stuff

;; {{
;;; ERC nick tracker.

;; Only track my nick(s)

(defadvice erc-track-find-face (around erc-track-find-face-promote-query activate)
  (if (erc-query-buffer-p)
      (setq ad-return-value (intern "erc-current-nick-face"))
    ad-do-it))

(setq erc-keywords '("celph" "celph"))

(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
                                "324" "329" "332" "333" "353" "477"))

;;
;; }}

;; {{
;; ERC logging.

(setq erc-log-channels-directory "~/.erc/logs/")
(setq erc-save-buffer-on-part t)
(defadvice save-buffers-kill-emacs (before save-logs (arg) activate)
  (save-some-buffers t (lambda () (when (eq major-mode 'erc-mode) t))))

;;
;; }}

'(erc-track-showcount nil)
'(erc-track-switch-direction (quote importance))


;; 
;; }}}

;; {{{
;;

(require 'flymake)

;; I don't like the default colors :)
(set-face-background 'flymake-errline "red4")
(set-face-background 'flymake-warnline "dark slate blue")

;; Invoke ruby with '-c' to get syntax checking
(defun flymake-ruby-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
	 (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "ruby" (list "-c" local-file))))

(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)

(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)

(add-hook 'ruby-mode-hook
          '(lambda ()

	     ;; Don't want flymake mode for ruby regions in rhtml files and also on read only files
	     (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
		 (flymake-mode))
	     ))
;;
;; }}}

;; {{{

;; {{{
;; Multiterm

(autoload 'multi-term "multi-term" nil t)
(autoload 'multi-term-next "multi-term" nil t)

(setq multi-term-program "/bin/bash")   ;; use bash

;; only needed if you use autopair
(add-hook 'term-mode-hook
  #'(lambda () (setq autopair-dont-activate t)))


(global-set-key (kbd "C-c t") 'multi-term-next)
(global-set-key (kbd "C-c T") 'multi-term) ;; create a new one

;;
;; }}}
