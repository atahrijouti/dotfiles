(add-to-list 'load-path "~/.emacs.d/lisp/machine-overrides/")

(pcase system-name
  ("SAPHIRE-TOWER" (require 'atj-machine-saphire-tower))
  ("Silver-Pond" (require 'atj-machine-silver-pond))
)

(if (eq system-type 'darwin)
  (setq atj/font-height 130)
)

(provide 'atj-overrides)
