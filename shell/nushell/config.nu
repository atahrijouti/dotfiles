# config.nu
#
# Installed by:
# version = "0.107.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

$env.config.show_banner = false
# $env.LS_COLORS = (vivid generate modus-operandi)
$env.LS_COLORS = ""
$env.config.table.mode = 'none'

alias l = lfcd
alias lg = lazygit

$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)' --terminal-width (term size).columns
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = ""
# $env.PROMPT_INDICATOR_VI_INSERT = ": "
# $env.PROMPT_INDICATOR_VI_NORMAL = "λ"
# $env.PROMPT_MULTILINE_INDICATOR = "::: "
$env.TRANSIENT_PROMPT_COMMAND = "∂"
