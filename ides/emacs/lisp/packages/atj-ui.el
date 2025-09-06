(use-package diminish :ensure t)

(use-package ef-themes :ensure t)

(use-package auto-dark
  :ensure t
  :diminish
  :config

  (setq auto-dark-themes '((ef-maris-dark) (ef-maris-light)))
  (setq auto-dark-allow-osascript t)
  (auto-dark-mode t)
  )

;; Icons everywhere
(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :ensure t
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

;; WhichKey
(use-package which-key
  :ensure t
  :diminish
  :config
  (which-key-mode 1)
  )

(use-package neotree
  :ensure t
)

(use-package doom-modeline
  :ensure t
  :init
  (setq doom-modeline-buffer-file-name-style 'relative-from-project)
  (doom-modeline-mode 1)
  )

(provide 'atj-ui)
