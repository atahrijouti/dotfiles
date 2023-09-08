(set-face-attribute 'default nil
  :font "JetBrainsMono NFM")

(setq ring-bell-function #'ignore)
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq make-backup-files nil)
(setq default-directory "~/")

(global-auto-revert-mode t)  ;; Automatically show changes if the file has changed
(global-display-line-numbers-mode 1) ;; Display line numbers

(provide 'atj-options)