(use-package diminish)

;; Icons everywhere
(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))
(use-package all-the-icons-dired
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))


; EVIL
(use-package evil
  :init
    (setq
        evil-want-keybinding nil
        evil-vsplit-window-right t
        evil-split-window-below t
    )
    (evil-mode)
)
(use-package evil-collection
  :after evil
  :config
    (add-to-list 'evil-collection-mode-list 'help)
    (evil-collection-init)
)
(use-package evil-tutor)


;; Better command completion
(use-package ivy
  :diminish
  :config (ivy-mode)
)
(use-package counsel
  :after ivy
  :diminish
  :config 
    (counsel-mode)
)
(use-package ivy-rich
    :after ivy
    :ensure t
    :init (ivy-rich-mode 1)
)

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))


;; Projects
(use-package projectile
  :config
  (projectile-mode 1))




;; Git
(use-package magit)



;;;;;;;;;;;;;;;;;;; UI

(use-package dashboard
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
        ;; (bookmarks . 3)
        ;; (registers . 3)
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
  :init
    (which-key-mode 1)
  :diminish
  :config
    (setq which-key-side-window-location 'bottom
	  which-key-sort-order #'which-key-key-order-alpha
	  which-key-allow-imprecise-window-fit nil
	  which-key-add-column-padding 1
	  which-key-max-display-columns nil
	  which-key-min-display-lines 6
	  which-key-allow-imprecise-window-fit nil
    )
)


;;;;;;;;;;;;;;;;;;;;; Languages
(use-package lua-mode)


(provide 'atj-packages)

