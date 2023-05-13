;;; -*- lexical-binding: t; -*-

(require 'cl-lib)

(setq org-knowledge-base-directory "~/workspace/knowledge-base/org")

(after! org-mode
  :config
  (setq
    org-id-link-to-org-use-id t                                                                ; Use ids when linking files.
    org-id-extra-files (directory-files-recursively org-knowledge-base-directory "\.org$")))   ; Follow ids in org-roam.

(after! org-roam
  :init
  (map! :leader
      (:prefix-map ("k" . "knowledge-base")
       :desc "Roam Toggle Side Pane"    "l"    #'org-roam-buffer-toggle
       :desc "Roam Insert"              "i"    #'org-roam-node-insert
       :desc "Roam Node Find"           "f"    #'org-roam-node-find
       :desc "Global Find"              "F"    #'notdeft
       :desc "Roam UI"                  "g"    #'org-roam-ui-open
       :desc "Roam Capture"             "c"    #'org-roam-capture
       (:prefix-map ("d" . "Daily")
        :desc "Capture Today"           "T"    #'org-roam-dailies-capture-today
        :desc "Goto Today"              "t"    #'org-roam-dailies-goto-today
        :desc "Capture Yesterday"       "Y"    #'org-roam-dailies-capture-yesterday
        :desc "Goto Yesterday"          "y"    #'org-roam-dailies-goto-yesterday
        :desc "Capture Date"            "D"    #'org-roam-dailies-goto-date
        :desc "Goto Date"               "d"    #'org-roam-dailies-capture-date
        :desc "List"                    "l"    #'org-roam-dailies-find-directory)))

  (setq org-roam-directory org-knowledge-base-directory)    ; Ensure org-roam is pointing to my knowledge-base by default.
  ; Force emacsql lite to compile as triggering org-roam-db-autosync-mode minor mode does not.
  (unless (file-executable-p emacsql-sqlite-executable)
        (emacsql-sqlite-compile 2)
        (unless (file-executable-p emacsql-sqlite-executable)
          (message (concat "Failed to build emacsql; forge may not work correctly.\n"
                           "See *Compile-Log* buffer for details"))))
  :config
  (org-roam-db-autosync-mode)                               ; Ensure org-roam is available at startup.
  (setq org-roam-capture-templates
        '(
          ("d" "default" plain
           "%?"
           :if-new (file+head "${slug}.org" "#+title: ${title}\n#+filetags: ")
           :empty-lines 1
           :kill-buffer t
           :unnarrowed t)
          )))
