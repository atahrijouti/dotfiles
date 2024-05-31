(use-package kakoune
  :autoloads nil
)



(use-package key-chord
  :after (ryo-modal)
  :config
  (key-chord-mode 1)
  (key-chord-define-global "jk" 'ryo-modal-mode)
)

(defun atj/select-line (arg)
  "Select the current line and move the cursor by ARG lines IF
no region is selected.

If a region is already selected when calling this command, only move
the cursor by ARG lines."
  (interactive "p")
  (when (not (use-region-p))
    (forward-line 0)
    (set-mark-command nil))
  (forward-line arg))


(use-package ryo-modal
  :after (project)
  :commands ryo-modal-mode
  :bind ("C-c SPC" . ryo-modal-mode)
  :config

  (define-key ryo-modal-mode-map [remap self-insert-command] 'undefined)

  
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

   ("x"  atj/select-line)

   ("y"  kill-ring-save)
   ("p"  yank)

   ("d" kill-region)
   ("c" kill-region :exit t)

   ("g h" beginning-of-line)
   ("g s" back-to-indentation)
   ("g l" end-of-line)
   ("g g" beginning-of-buffer)
   ("g e" end-of-buffer)

   ;; Space map
   ("SPC"
    (
     ("w" save-buffer)
     ("q" save-buffers-kill-emacs)
     ("f" project-find-file)
     ("b" consult-buffer)
     ("1" neotree-toggle)
    )
   )

   ("RET" undefined)
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
   ("9" "M-9")
  )
)

(defun atj/modal-text-prog-hook ()
  (ryo-modal-mode)
   
)


(add-hook 'text-mode-hook #'atj/modal-text-prog-hook)
(add-hook 'prog-mode-hook #'atj/modal-text-prog-hook)

(provide 'atj-modal)
