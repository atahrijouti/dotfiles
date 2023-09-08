(setq ring-bell-function #'ignore)
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq make-backup-files nil)
(setq default-directory "~/")

(set-face-attribute 'default nil
  :font "JetBrainsMono NFM")

(provide 'atj-options)