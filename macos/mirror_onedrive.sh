#!/bin/zsh
SOURCE="/Users/atahrijouti/playground/logseq"
TARGET="/Users/atahrijouti/OneDrive - PayPal/logseq"
LOG_FILE="/Users/atahrijouti/.logs/mirror_onedrive/log.txt"

RESULT=$(rsync -rau --delete --exclude=".git" "$SOURCE/" "$TARGET")

if [[ $RESULT ]]; then
  echo $RESULT >> "${LOG_FILE}"
else
  echo "$(tail -n 3000 "${LOG_FILE}")" > "${LOG_FILE}"
  echo "Ran rsync $(date)" >> "${LOG_FILE}"
fi
