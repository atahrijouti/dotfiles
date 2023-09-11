(use-package ef-themes
  :init
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme 'ef-maris-dark :no-confirm)
)

;; Icons everywhere
(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

;; WhichKey
(use-package which-key
  :diminish
  :init
    (which-key-mode 1)
)


(provide 'atj-ui)