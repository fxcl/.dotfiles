;;; -*- lexical-binding: t; -*-


 (after! org-journal
  :config
  (setq
    org-journal-dir "~/workspace/journal"
    org-journal-file-format "%Y-%B Week %W.org"
    org-journal-file-header "#+TITLE: %Y-%B Week %W - Notes\n#+FILETAGS: %Y %B personal notes\n#+STARTUP: folded\n"
    org-journal-file-type 'weekly))
