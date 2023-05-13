;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Bruno Henriques"
      user-mail-address "4727729+bphenriques@users.noreply.github.com")

(load! "+theme")
(load! "+macos")
(load! "+org-mode")
(load! "+org-roam")
(load! "+org-journal")
(load! "+scala")
(load! "+notdeft")
(load! "custom")

(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 tab-width 4                                      ; Set width for tabs
 undo-limit 80000000                              ; Raise undo-limit to 80Mb
 evil-want-fine-undo t                            ; By default while in insert all changes are one big blob. Be more granular
 inhibit-compacting-font-caches t                 ; When there are lots of glyphs, keep them in memory
 initial-major-mode 'org-mode                     ; New buffers will have org-mode enabled by default
)

;;;
;;; Display list of buffers on the right/bottom when splitting windows
;;;
(setq
 evil-vsplit-window-right t
 evil-split-window-below t)

(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (+ivy/switch-buffer))

(setq +ivy-buffer-preview t)

(xterm-mouse-mode 1) ; Enable basic mouse support when running in the terminal

