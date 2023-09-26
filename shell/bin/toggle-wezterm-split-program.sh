#!/bin/sh
set -e

if [ -z $1 ]; then
    echo "toggle-wezterm-split-program requires a program as argument at least"
    exit 1
fi

program="${1}"
splitDirection="${2:-"--bottom"}"
splitPercent=${3:-50}

targetPaneId=$(wezterm cli list --format json \
| jq "[.[] | select(.title == \"${program}\")] | first | .pane_id // empty")

if [ -z "${targetPaneId}" ]; then
    targetPaneId=$(wezterm cli split-pane $splitDirection --percent ${splitPercent:-50})
    # removed --no-paste from the command as it wasn't working from within MSYS2
    echo "${program}" | wezterm cli send-text --pane-id $targetPaneId 
else
    wezterm cli kill-pane --pane-id $targetPaneId
fi