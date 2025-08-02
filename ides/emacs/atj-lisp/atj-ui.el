(use-package diminish)

(use-package doom-themes
  :ensure t)

(use-package auto-dark
  :ensure t
  :diminish
  :config

  (setq custom-safe-themes
    '("dfcd2b13f10da4e5e26eb1281611e43a134d4400b06661445e7cbb183c47d2ec"
     "3b8713240ad8a387afc4ca9033d2df9abb2fd32b0ce09a4159169878067327e6"
     "0b2c80b52629015e3b52d7406ffb0b82f9c10dce5113c9a46bb42653914f1d05"
     default)
  )
  
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
