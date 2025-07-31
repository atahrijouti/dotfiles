(use-package format-all
  :ensure t)

(use-package helix
  :after multiple-cursors
  :config
    (helix-mode)
    (helix-jj-setup 0.2)
    (helix-multiple-cursors-setup)
    (helix-define-typable-command
      "format"
      (lambda () (call-interactively #'format-all-buffer))
    )
)

(provide 'atj-helix)
