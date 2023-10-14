(use-package evil
    :init
    (setq evil-want-integration t
          evil-want-keybinding nil
          evil-vsplit-window-right t
          evil-split-window-below t
          evil-undo-system 'undo-redo)
    (evil-mode))

(use-package evil-tutor)



(provide 'atj-modal)
