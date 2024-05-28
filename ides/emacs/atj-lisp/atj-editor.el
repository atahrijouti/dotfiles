(use-package autorevert
  :ensure nil
  :diminish
  :hook (after-init . global-auto-revert-mode))

(use-package expand-region
  :bind ("C-=" . er/expand-region)
  :config
  (when (centaur-treesit-available-p)
    (defun treesit-mark-bigger-node ()
      "Use tree-sitter to mark regions."
      (let* ((root (treesit-buffer-root-node))
             (node (treesit-node-descendant-for-range root (region-beginning) (region-end)))
             (node-start (treesit-node-start node))
             (node-end (treesit-node-end node)))
        ;; Node fits the region exactly. Try its parent node instead.
        (when (and (= (region-beginning) node-start) (= (region-end) node-end))
          (when-let ((node (treesit-node-parent node)))
            (setq node-start (treesit-node-start node)
                  node-end (treesit-node-end node))))
        (set-mark node-end)
        (goto-char node-start)))
    (add-to-list 'er/try-expand-list 'treesit-mark-bigger-node)))

;; Jump to things in Emacs tree-style
(use-package avy
  ;; :bind (("C-:"   . avy-goto-char)
         ;; ("C-'"   . avy-goto-char-2)
         ;; ("M-g l" . avy-goto-line)
         ;; ("M-g w" . avy-goto-word-1)
         ;; ("M-g e" . avy-goto-word-0))
  :hook (after-init . avy-setup-default)
  :config (setq avy-all-windows nil
                avy-all-windows-alt t
		avy-keys (number-sequence ?a ?z)
                avy-style 'at-full)
)


(use-package undo-tree
:config
  (global-undo-tree-mode))
;;
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))


(provide 'atj-editor)
