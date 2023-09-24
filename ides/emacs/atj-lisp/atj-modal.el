(use-package ryo-modal
  ;; :commands ryo-modal-mode
  ;; :bind ("C-c SPC" . ryo-modal-mode)
  :config
  (setq viper-mode 0)
  (require 'viper)

  (defun ryo-enter () "Enter normal mode" (interactive) (ryo-modal-mode 1))
   (add-hook 'prog-mode-hook #'ryo-enter)
   (add-hook 'text-mode-hook #'ryo-enter)

   ;; use keykoard to be able to use jk
   ;; (global-set-key (kbd "jk") #'ryo-enter)

   (ryo-modal-keys
   (:mc-all t)
   
   ;; Basic movement
   ("h" backward-char)
   ("j" next-line)
   ("k" previous-line)
   ("l" forward-char)

   ("," ryo-modal-repeat)
   ("q" ryo-modal-mode)

   ("w" viper-forward-word)
   ("b" viper-backward-word)
  )


  ;; C-u {number} 
  (ryo-modal-keys
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
   ("9" "M-9")
   )
)

(provide 'atj-modal)
