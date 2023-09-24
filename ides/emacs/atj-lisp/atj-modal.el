(setq viper-mode 0)
(require 'viper)

(use-package ryo-modal
  :commands ryo-modal-mode
  :bind ("C-c SPC" . ryo-modal-mode)
  :config
  (ryo-modal-keys
   ("," ryo-modal-repeat)
   ("q" ryo-modal-mode)

   ("h" backward-char)
   ("j" next-line)
   ("k" previous-line)
   ("l" forward-char)

   ("w" viper-forward-word)
   ("b" viper-backward-word)
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
  :init
    (ryo-modal-mode)
  )

(provide 'atj-modal)
