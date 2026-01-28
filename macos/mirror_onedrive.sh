#!/bin/zsh
SOURCE="/Users/atahrijouti/playground/logseq"
TARGET="/Users/atahrijouti/OneDrive - PayPal/logseq"
LOG_FILE="/Users/atahrijouti/.logs/mirror_onedrive/log.txt"

# Capture both stdout and stderr
RESULT=$(rsync -rau --delete --exclude=".git" "$SOURCE/" "$TARGET" 2>&1)
EXIT_CODE=$?

# Trim log file first
echo "$(tail -n 3000 "${LOG_FILE}")" > "${LOG_FILE}"

# Log based on exit code, not output
if [[ $EXIT_CODE -eq 0 ]]; then
  echo "[$(date)] rsync completed successfully" >> "${LOG_FILE}"
else
  echo "[$(date)] rsync failed with exit code $EXIT_CODE:" >> "${LOG_FILE}"
  echo "$RESULT" >> "${LOG_FILE}"
fi
