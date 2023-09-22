(setq ring-bell-function #'ignore)
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq default-directory "~/")

;; Backups
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq backup-directory-alist '((".*" . "~/.emacs.d/emacs-backup")))
(setq create-lockfiles nil)


;; Automatically show changes if the file has changed
(global-auto-revert-mode t)

(global-display-line-numbers-mode 1)

(pixel-scroll-precision-mode t)

(provide 'atj-options)
