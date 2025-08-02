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

  (require 'kakoune-utils)

  (define-key ryo-modal-mode-map [remap self-insert-command] 'undefined)

  (global-subword-mode 1)

  (ryo-modal-keys
   (:mc-all t)
   ("h" backward-char :first '(kakoune-deactivate-mark))
   ("j" next-line :first '(kakoune-deactivate-mark))
   ("k" previous-line :first '(kakoune-deactivate-mark))
   ("l" forward-char :first '(kakoune-deactivate-mark))

   ("b" kakoune-backward-same-syntax :first '(kakoune-set-mark-here) :mc-all t)
   ;; ("B" kakoune-backward-same-syntax :first '(kakoune-set-mark-if-inactive) :mc-all t)
   ("w" forward-same-syntax :first '(kakoune-set-mark-here) :mc-all t)
   ;; ("W" forward-same-syntax :first '(kakoune-set-mark-if-inactive) :mc-all t))

   ("u" undo-tree-undo)
   ("U" undo-tree-redo)

   ("." ryo-modal-repeat)

   ("i" ryo-modal-mode 0)
   ("I" back-to-indentation :exit t)
   ("a" forward-char :exit t)
   ("A" move-end-of-line :exit t)

   ("o" kakoune-o :exit t)
   ("O" kakoune-O :exit t)

   ("v"  set-mark-command)

   ("x" kakoune-x)
   ("X" kakoune-X)
   ("%" mark-whole-buffer)

   ("y"  kill-ring-save)
   ("p"  yank)

   ("d" kakoune-d)
   ("c" kakoune-d :exit t)
   ("r" kakoune-replace-char)
   ("R" kakoune-replace-selection)

   (">" kakoune-indent-right)
   ("<" kakoune-indent-left)

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
