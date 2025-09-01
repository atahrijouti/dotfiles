(add-to-list 'load-path "~/.emacs.d/lisp/machine-overrides/")

(pcase system-name
  ("SAPHIRE-TOWER" (require 'atj-machine-saphire-tower))
  ("Silver-Pond" (require 'atj-machine-silver-pond))
)

(provide 'atj-overrides)
