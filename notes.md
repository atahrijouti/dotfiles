# In Repo notes

## Emacs

using the following command assures that emacsclient opens in focus
emacsclient -cn --eval '(progn (raise-frame) (select-frame-set-input-focus (selected-frame)))'
