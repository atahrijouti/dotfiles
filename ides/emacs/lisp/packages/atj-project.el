(require 'project)

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

(use-package dashboard
  :ensure t
  :init
  (setq dashboard-display-icons-p t)
  (setq initial-buffer-choice 'dashboard-open)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-projects-backend 'project-el)
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

(use-package ripgrep :ensure t)

(use-package transient :ensure t)
(use-package magit :after(transient) :ensure t)

(provide 'atj-project)
