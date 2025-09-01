(use-package diminish)

(use-package doom-themes
  :ensure t)

(use-package auto-dark
  :ensure t
  :diminish
  :config

  (setq auto-dark-themes '((doom-nord-aurora) (doom-nord-light)))
  (setq auto-dark-allow-osascript t)
  (auto-dark-mode t)
)

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

(use-package neotree)

(provide 'atj-ui)
