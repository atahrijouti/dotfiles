(use-package format-all
  :ensure t)

(use-package autorevert
  :ensure nil
  :diminish
  :hook (after-init . global-auto-revert-mode))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region)
  :config
  (defun tree-sitter-mark-bigger-node ()
    (interactive)
    (let* ((root (tsc-root-node tree-sitter-tree))
         (node (tsc-get-descendant-for-position-range root (region-beginning) (region-end)))
         (node-start (tsc-node-start-position node))
         (node-end (tsc-node-end-position node)))
    ;; Node fits the region exactly. Try its parent node instead.
    (when (and (= (region-beginning) node-start) (= (region-end) node-end))
      (when-let ((node (tsc-get-parent node)))
        (setq node-start (tsc-node-start-position node)
              node-end (tsc-node-end-position node))))
    (set-mark node-end)
    (goto-char node-start)))

    (setq er/try-expand-list (append er/try-expand-list
                                 '(tree-sitter-mark-bigger-node)))
)

;; Jump to things in Emacs tree-style
(use-package avy
  :ensure t
  ;; :bind (("C-:"   . avy-goto-char)
         ;; ("C-'"   . avy-goto-char-2)
         ;; ("M-g l" . avy-goto-line)
         ;; ("M-g w" . avy-goto-word-1)
         ;; ("M-g e" . avy-goto-word-0))
  :hook (after-init . avy-setup-default)
  :config (setq avy-all-windows nil
                avy-all-windows-alt t
				avy-keys (number-sequence ?a ?z)
                avy-style 'at-full
				;; avy-style 'de-bruijn
		  )
)

(use-package multiple-cursors :ensure t)

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode)
)

(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))


(provide 'atj-editor)
