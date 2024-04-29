;; open config file quickly
(global-set-key "\C-cc"
		#'(lambda ()
		    (interactive)
		    (find-file user-init-file)
		    )
		  
)


;; why do I need to click escape 3 times?
(global-set-key (kbd "<escape>")      'keyboard-escape-quit)

(global-set-key (kbd "\C-c g d")      'find-file-at-point)


(defun atj/open-init-file ()
  "Open the init file."
  (interactive)
  (find-file user-init-file))


(provide 'atj-keymap)
