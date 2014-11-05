;;; Xclipboard-mode.el --- X clipboard utilities for GNU Emacs

;; Copyright (C) 2014  Spencer Allen

;; Author: Spencer Allen
;; Keywords: convenience
;; Version 0.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This extension provides a way to replace the kill-ring functionally
;; with the gnu X clipboard. It uses xsel http://www.vergenet.net/~conrad/software/xsel/
;; a command-line program for getting and setting the contents of the
;; X selection.
;;
;; The functions provided include :
;; yank region to X clipboard
;; kill region to X clipboard
;; kill line to X clipboard
;; paste from X clipboard
;;
;; Enjoy.

;;; Code:
;; Functions
(defun yank-region-to-x-clipboard ()
  (interactive)
  (if (region-active-p)
      (progn
	(shell-command-on-region (region-beginning) (region-end) "xsel -i -b")
	(deactivate-mark))))

(defun kill-region-to-x-clipboard ()
  (interactive)
  (if (region-active-p)
      (progn
	(shell-command-on-region (region-beginning) (region-end) "xsel -i -b")
	(delete-region (region-beginning) (region-end)))))

(defun kill-line-to-x-clipboard ()
  (interactive)
  (execute-kbd-macro (symbol-function 'set-eol-region))
  (if (region-active-p)
      (progn
	(shell-command-on-region (region-beginning) (region-end) "xsel -i -b")
	(delete-region (region-beginning) (region-end)))))

(defun paste-from-x-clipboard ()
  (interactive)
  (insert (shell-command-to-string "xsel -o -b")))

;; Macros
(fset 'set-eol-region
   "\C-@\C-e")

;; define mode
(define-minor-mode xclipboard-mode
  "Integrates x clipboard with Emacs using xsel"
  nil
  ;; The indicator for the mode line.
  :lighter " Xclipboard"
  ;; Make mode global rather than buffer local
  :global 1
  ;; keymap
  '(([M-w] . yank-region-to-x-clipboard)
    ([C-w] . kill-region-to-x-clipboard)
    ([C-k] . kill-line-to-x-clipboard)
    ([C-y] . paste-from-x-clipboard))
  :group 'clipboard
  )

(provide 'Xclipboard-mode)
