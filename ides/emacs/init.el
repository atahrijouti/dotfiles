(add-to-list 'load-path "~/.emacs.d/lisp/")

(require 'elpaca-installer)

(require 'atj-options)

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

(use-package evil
  :init
  (evil-mode))