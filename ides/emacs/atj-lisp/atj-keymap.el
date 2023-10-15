;; open config file quickly
(global-set-key "\C-cc"
		#'(lambda ()
		    (interactive)
		    (find-file user-init-file)
		    )
		  
)


;; why do I need to click escape 3 times?
(global-set-key (kbd "<escape>")      'keyboard-escape-quit)




(defun atj/open-init-file ()
  "Open the init file."
  (interactive)
  (find-file user-init-file))






(use-package general
  :config
  (general-evil-setup)

  (general-create-definer atj/leader-keys
    :states '(normal visual emacs)
    :keymaps 'override
    :prefix "SPC"
  )

  (atj/leader-keys
   "w" '(save-buffer :wk "Write file")
  )
)





(provide 'atj-keymap)
