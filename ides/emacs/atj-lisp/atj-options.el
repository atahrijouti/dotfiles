(setq ring-bell-function #'ignore)
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq default-directory "~/")
(setq delete-by-moving-to-trash t)
(setq warning-minimum-level :emergency)

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq backup-directory-alist '((".*" . "~/.emacs.d/emacs-backup")))
(setq create-lockfiles nil)

;; Scrolling sanely
(setq scroll-margin 6
      scroll-conservatively 101
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01
      scroll-preserve-screen-position t
      auto-window-vscroll nil)

(delete-selection-mode 1)
(electric-indent-mode -1)
(electric-pair-mode 1)

;; Automatically show changes if the file has changed
(global-auto-revert-mode t)

(global-display-line-numbers-mode 1)
(global-visual-line-mode 1)
(pixel-scroll-precision-mode t)


(setq org-return-follows-link  t)


(provide 'atj-options)
