;;; -*- lexical-binding: t; -*-

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((eval . (setq-local org-hugo-base-dir (projectile-project-root)))
     (gac-automatically-push-p . t)
     (gac-automatically-add-new-files-p . t)
     (gac-commit-additional-flag . "--no-gpg-sign")
     (org-roam-file-exclude-regexp . "_index.org")
     (org-hugo-section . "notes")
     (eval setq-local org-roam-directory
           (concat
            (file-name-as-directory
             (projectile-project-root))
            "org")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

