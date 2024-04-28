;; Projects

;(use-package projectile
;  :diminish
;  :config
;  (projectile-mode 1))

(require 'project)

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

(use-package dashboard
  :init
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

(use-package ripgrep)

(provide 'atj-project)
