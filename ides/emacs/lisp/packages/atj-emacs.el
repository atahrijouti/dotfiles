(use-package emacs
  :ensure nil

  :custom
    (column-number-mode t)
    (auto-save-default nil)
    (create-lockfiles nil)
    (delete-by-moving-to-trash t)
    (global-auto-revert-non-file-buffers t)
    (history-length 25)
    (inhibit-startup-message t)
    (initial-scratch-message "")
    (ispell-dictionary "en_US")
    (make-backup-files nil)
    (pixel-scroll-precision-mode t)
    (pixel-scroll-precision-use-momentum nil)
    (ring-bell-function 'ignore)
    (split-width-threshold 300)
    (switch-to-buffer-obey-display-actions t)
    (tab-always-indent 'complete)
    (tab-width 4)
    (treesit-font-lock-level 4)
    (use-dialog-box nil)
    (use-short-answers t)
    (warning-minimum-level :emergency)

  :hook
    (prog-mode . display-line-numbers-mode)

  :config

    (setq default-directory "~/")
    (setq backup-directory-alist '((".*" . "~/.emacs.d/emacs-backup")))

    (electric-indent-mode -1)
    (electric-pair-mode 1)

    ;; Scrolling sanely
    (setq scroll-margin 6
          scroll-conservatively 101
          scroll-up-aggressively 0.01
          scroll-down-aggressively 0.01
          scroll-preserve-screen-position t
          auto-window-vscroll nil)

    (defun skip-these-buffers (_window buffer _bury-or-kill)
      "Function for `switch-to-prev-buffer-skip'."
      (string-match "\\*[^*]+\\*" (buffer-name buffer)))
    (setq switch-to-prev-buffer-skip 'skip-these-buffers)

    (defun atj/set-font (&optional frame)
      (with-selected-frame
        (or frame (selected-frame))
        (set-face-attribute 'default nil :family atj/font-family :height atj/font-height)))
    (add-hook 'after-make-frame-functions #'atj/set-font)

    (when (display-graphic-p)
      (atj/set-font))

    (setq custom-file (expand-file-name "custom-vars.el" user-emacs-directory))
    (when (file-exists-p custom-file)
      (load custom-file))

    (set-display-table-slot standard-display-table 'vertical-border (make-glyph-code ?│))

  :init
    (tool-bar-mode t)
    (menu-bar-mode t)

    (when (fboundp 'scroll-bar-mode)
      (scroll-bar-mode -1))

    (global-visual-line-mode 1)
    (global-hl-line-mode -1)
    (global-auto-revert-mode 1)

    (setq-default indent-tabs-mode nil)

    (delete-selection-mode 1)

    (setq-default truncate-lines t)

    (recentf-mode 1)
    (setq recentf-max-saved-items 200
          recentf-auto-cleanup 'never)

    (savehist-mode 1)
    (setq savehist-additional-variables
          '(kill-ring search-ring regexp-search-ring))

    (save-place-mode 1)
    (winner-mode 1)
    (xterm-mouse-mode 1)
    (file-name-shadow-mode 1)

    (modify-coding-system-alist 'file "" 'utf-8)
)

(provide 'atj-emacs)
