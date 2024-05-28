(use-package ryo-modal
  :commands ryo-modal-mode
  :bind ("C-c SPC" . ryo-modal-mode)
  :config
  
  (ryo-modal-keys

   ("i" ryo-modal-mode)
   

   ("." ryo-modal-repeat)

   ("h" backward-char)
   ("j" next-line)
   ("k" previous-line)
   ("l" forward-char)
   ("w" forward-word)
   ("b" backward-word)
  )

  (ryo-modal-keys
   ;; First argument to ryo-modal-keys may be a list of keywords.
   ;; These keywords will be applied to all keybindings.
   (:norepeat t)
   ("0" "M-0")
   ("1" "M-1")
   ("2" "M-2")
   ("3" "M-3")
   ("4" "M-4")
   ("5" "M-5")
   ("6" "M-6")
   ("7" "M-7")
   ("8" "M-8")
   ("9" "M-9"))
  )

(add-hook 'text-mode-hook 'ryo-modal-mode)
(add-hook 'prog-mode-hook 'ryo-modal-mode)
(global-set-key (kbd "C-<return>") 'ryo-modal-mode)


(provide 'atj-modal)
