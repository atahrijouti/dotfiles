# Shell
set -o emacs

# Oh-My-Zsh
export ZSH="/Users/atahrijouti/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-lazyload)
source $ZSH/oh-my-zsh.sh

# Starship Prompt
eval "$(starship init zsh)"

# Homebrew
lazy_load_brew() {
    if type brew &>/dev/null
    then
        FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

        autoload -Uz compinit
        compinit
    fi
}
lazyload brew -- lazy_load_brew

# NVM
lazy_load_nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
lazyload nvm -- lazy_load_nvm

# Rbenv
lazy_load_rbenv() {
    eval "$(rbenv init - zsh)"
}
lazyload rbenv -- lazy_load_rbenv

# SDKMan
# [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Jabba
lazy_load_jabba() {
    [ -s "$JABBA_HOME/jabba.sh" ] && source "$JABBA_HOME/jabba.sh"
}
lazyload jabba -- lazy_load_jabba

# Custom shell
# functions
source_infra() {
    [ -s "${INFRA_AUTO_HOME}/setup-environment.zsh" ] && \. "${INFRA_AUTO_HOME}/setup-environment.zsh"
}

connect_to_mas_prod() {
    "$HOME/playground/web/merchant-apps-service/tools/connect_to_rds_in_isolated_subnet.sh" $1 prod 6667
}

run_iz_docker_service() {
    cd $IZETTLE_DOCKER_SERVICES && docker-compose up -d "$1" && cd -
}

run_portal_service() {
    cd $PORTAL_FOLDER && docker-compose up -d "$1" && cd -
}

#aliases
alias ls="ls -F --color"

source "$HOME/.work_zshrc"