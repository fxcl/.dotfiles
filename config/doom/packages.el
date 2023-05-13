;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! notdeft
  :recipe (:host github :repo "hasu/notdeft") :pin "1b7054dcfc3547a7cafeb621552cec01d0540478")

(package! ox-hugo
  :recipe (:host github :repo "kaushalmodi/ox-hugo") :pin "706b5f622d168bb8e0cf503e0525d2db9177c83e")

(package! org-roam
  :recipe (:host github :repo "org-roam/org-roam") :pin "f9228ce31969cab9ca46ad4890e82e2ea7de3738")

(package! org-roam-ui
  :recipe (:host github :repo "org-roam/org-roam-ui") :pin "6bf6a5eecc1fa7ddbb1fcda85e08fe9c393f9298")

(package! git-auto-commit-mode
  :recipe (:host github :repo "ryuslash/git-auto-commit-mode") :pin "a6b6e0fa183be381463e2b44ef128db1b6c4234b")

(package! straight :pin "3eca39d")
