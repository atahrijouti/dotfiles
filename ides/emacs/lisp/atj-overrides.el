(add-to-list 'load-path "~/.emacs.d/lisp/machine-overrides/")

(pcase system-name
  ("SAPHIRE-TOWER" (require 'atj-machine-saphire-tower))
  ("Silver-Pond" (require 'atj-machine-silver-pond))
)

(if (eq system-type 'darwin)
   (progn
     (setq atj/font-height 130)
     (setq atj/font-family "JetBrainsMono Nerd Font")
   )
)

(provide 'atj-overrides)
