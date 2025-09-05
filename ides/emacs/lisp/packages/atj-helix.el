(defun helix-setup ()
  (helix-normal-mode)
  (helix-jj-setup 0.2)
  (helix-multiple-cursors-setup)
  (helix-define-typable-command
   "format"
   (lambda () (call-interactively #'format-all-buffer))
   )
  )

(use-package helix
  :after (multiple-cursors format-all)
  :hook ((prog-mode text-mode conf-mode) . helix-setup)
  :ensure t
  )

(provide 'atj-helix)
