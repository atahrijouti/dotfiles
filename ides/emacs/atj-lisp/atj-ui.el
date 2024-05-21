(use-package diminish)

(use-package ef-themes
  :init
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme 'ef-maris-light :no-confirm)
)

(use-package auto-dark
  :diminish
  :config
  (setq auto-dark-dark-theme 'ef-maris-dark)
  (setq auto-dark-light-theme 'ef-maris-light)
  (setq auto-dark-allow-osascript t)
  (auto-dark-mode t))

;; Icons everywhere
(use-package all-the-icons
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

;; WhichKey
(use-package which-key
  :diminish
  :config
    (which-key-mode 1)
)


(provide 'atj-ui)
