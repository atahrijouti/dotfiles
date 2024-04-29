(add-to-list 'load-path "~/.emacs.d/atj-lisp/")
(add-to-list 'load-path "~/.emacs.d/atj-machine-specific/")

(require 'elpaca-installer)

(require 'atj-options)

(require 'atj-packages)

(require 'atj-keymap)

(pcase system-name
  ("SAPHIRE-TOWER" (require 'atj-machine-saphire-tower))
  ("Silver-Pond" (require 'atj-machine-silver-pond))
)
