(defun helix-setup ()
  (helix-normal-mode)
  (helix-jj-setup 0.2)
  (helix-multiple-cursors-setup)
  (helix-define-typable-command
   "format"
   (lambda () (call-interactively #'format-all-buffer))
   )
  (helix-define-key 'space "w" #'save-buffer)
  (helix-define-key 'space "q" #'kill-buffer)
  )

(use-package helix
  :ensure t
  :after (multiple-cursors format-all)
  :hook ((prog-mode text-mode conf-mode) . helix-setup)
  )

(provide 'atj-helix)
