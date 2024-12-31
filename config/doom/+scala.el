;;; ../../Documents/repos/dotfiles/emacs/.config/doom/+scala.el -*- lexical-binding: t; -*-

(require 'ob-ammonite)

; Ensure that .ammonite/predef.sc's includes "repl.prompt() = "scala>"
(setq ob-ammonite-prompt-str "scala>")

; Provide scala alias for the amm as it is the real name and allows syntax highlight when exporting
; Also detects if Ammonite REPL process is running, otherwise it will fail. See https://github.com/zwild/ob-ammonite/issues/1#issuecomment-482388624
(defun org-babel-execute:scala (body params)
  "Checks if Ammonite is running and execute the scala code in BODY using PARAMS using org-babel-execute:amm"
  (unless (comint-check-proc ammonite-term-repl-buffer-name)
    (error "Ammonite is not running. Evaluate 'run-ammonite' before running code-blocks"))
  (org-babel-execute:amm body params))
