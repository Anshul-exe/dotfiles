#!/bin/bash

set -e

BACKUP_FILE=~/Downloads_backup_"$(date +%Y%m%d_%H%M%S)".tar.gz

echo "Starting backup to $BACKUP_FILE"

tar -czf "$BACKUP_FILE" -C ~/ \
  --exclude='*/node_modules' \
  --exclude='*/.*cache*' \
  --exclude='*/tmp' \
  --exclude='*/temp' \
  --exclude='*/.npm' \
  --exclude='*/.cache' \
  --exclude='*/cache' \
  --exclude='*/__pycache__' \
  --exclude='*/.DS_Store' \
  --checkpoint=1000 --checkpoint-action=dot \
  --warning=no-file-ignored \
  --ignore-failed-read \
  Downloads/ 2>&1 | tee ~/Downloads_backup.log

if [ $? -eq 0 ] && [ -f "$BACKUP_FILE" ]; then
  echo -e "\n Backup completed successfully: $BACKUP_FILE"
  echo "Size: $(du -sh "$BACKUP_FILE" | cut -f1)"
else
  echo -e "\n Backup failed or no files were backed up."
  exit 1
fi
