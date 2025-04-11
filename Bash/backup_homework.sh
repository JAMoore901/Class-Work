#!/bin/bash

# backup_homework.sh
# Student: Jessica Moore
# Description: Creates timestamped backups of homework files

# Configuration
COURSE="CS101"
BACKUP_DIR=~/backups/"$COURSE"
FILES_TO_BACKUP=( ~/homework/*.pdf ~/homework/*.docx )

# Create backup directory with date
BACKUP_NAME="$BACKUP_DIR/backup_$(date +%Y-%m-%d_%H-%M-%S)"
mkdir -p "$BACKUP_NAME"

# Copy files and verify
for file in "${FILES_TO_BACKUP[@]}"; do
    if [ -f "$file" ]; then
        cp -v "$file" "$BACKUP_NAME/"
    else
        echo "Warning: $file not found" >&2
    fi
done

# Create checksum for verification
md5sum "$BACKUP_NAME"/* > "$BACKUP_NAME/checksums.md5"

echo "Backup created at: $BACKUP_NAME"
echo "$(ls -1 "$BACKUP_NAME" | wc -l) files backed up"