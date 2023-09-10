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


(use-package dashboard
  :after projectile
  :ensure t 
  :init
  (setq initial-buffer-choice 'dashboard-open)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-center-content t)
  (setq dashboard-items'(
        (projects . 5 )
        (recents . 5)
        (bookmarks . 3)
        (registers . 3)
    )
  )
  :custom 
    (dashboard-modify-heading-icons '(
        (recents . "file-text")
        (bookmarks . "book"))
    )
  :config
    (dashboard-setup-startup-hook)
)



;; WhichKey
(use-package which-key
  :diminish
  :init
    (which-key-mode 1)
)


(provide 'atj-ui)