(use-package key-chord
  :after (ryo-modal)
  :config
  (key-chord-mode 1)
  (key-chord-define-global "jk" 'ryo-modal-mode)
)

(use-package ryo-modal
  :after (project)
  :commands ryo-modal-mode
  :bind ("C-c SPC" . ryo-modal-mode)
  :config
  
  (ryo-modal-keys
   ("h" backward-char)
   ("j" next-line)
   ("k" previous-line)
   ("l" forward-char)
   ("w" forward-word)
   ("b" backward-word)
   
   ("u" undo-tree-undo)
   ("U" undo-tree-redo)   

   ("." ryo-modal-repeat)

   ("i" ryo-modal-mode 0)
   ("a" forward-char :exit t)

   ("O"  move-beginning-of-line :then '(open-line))
   ("o"  move-end-of-line :then '(newline))
   
   ("v"  set-mark-command)

   ("y"  kill-ring-save)
   ("p"  yank)

   ("g h" beginning-of-line)
   ("g s" beginning-of-line-text)
   ("g l" end-of-line)
   ("g g" beginning-of-buffer)
   ("g e" end-of-buffer)

   ;; Space map
   ("SPC"
    (("w" save-buffer)
     ("q" save-buffers-kill-emacs)
     ("f" project-find-file)
     ("b" consult-buffer)
     )
    )
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
