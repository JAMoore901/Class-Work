#!/bin/bash
# Backup script for configuration files in Documents
# Written by Jessica Moore 367901

# Get the current timestamp in YYYYMMDD format
timestamp=$(date +'%Y%m%d')

# Set the target and backup locations 
targetFolder="/home/kali/Documents"
backupFolder="/home/kali/Documents/backup_$timestamp"

# dry-run mode for testing 
# to use -- bash /home/kali/Documents/backup_docker_Jessica_Moore.sh --dry-run

dryRun=false
if [ "$1" == "--dry-run" ]; then
  dryRun=true
  echo "Running in dry-run mode. No changes will be made."
fi

echo "Target folder: $targetFolder"
echo "Backup folder will be created as: $backupFolder"

# Check if the target folder exists
if [ ! -d "$targetFolder" ]; then
  echo "Error: Target folder $targetFolder does not exist."
  echo "Make sure the directory exists and is accessible."
  exit 1
fi

# Check for write permissions in the backup directory location
if [ ! -w "$targetFolder" ]; then
  echo "Error: No write permissions in $targetFolder."
  echo "Please check permissions and try again."
  exit 1
fi

# Check if the backup folder already exists
if [ -d "$backupFolder" ]; then
  echo "Backup folder $backupFolder for today already exists."
  if [ "$dryRun" == false ]; then
    echo "Deleting existing backup folder..."
    rm -Rf "$backupFolder"
    if [ $? -ne 0 ]; then
      echo "Error: Could not delete existing backup folder."
      echo "Check permissions and try again."
      exit 1
    fi
  else
    echo "Dry-run: Would delete existing backup folder $backupFolder."
  fi
fi

# Create the backup folder
echo "Creating backup folder: $backupFolder"
if [ "$dryRun" == false ]; then
  mkdir "$backupFolder"
  if [ $? -ne 0 ]; then
    echo "Error: Could not create backup folder."
    echo "Check permissions and try again."
    exit 1
  fi
else
  echo "Dry-run: Would create backup folder $backupFolder."
fi

# Loop through files in the target folder
echo "Scanning $targetFolder for files to back up..."
for file in "$targetFolder"/*; do
  # Check if the file is a regular file
  if [ -f "$file" ]; then
    # Check if the file has a permitted extension
    if [[ "$file" == *.sh || "$file" == *.yaml || "$file" == *.yml || "$file" == *.conf ]]; then
      if [ "$dryRun" == false ]; then
        echo "Copying $(basename "$file")"
        cp "$file" "$backupFolder"
        if [ $? -eq 0 ]; then
          echo "$(basename "$file") copied successfully."
        else
          echo "Error copying $(basename "$file"). Skipping..."
        fi
      else
        echo "Dry-run: Would copy $(basename "$file") to $backupFolder."
      fi
    else
      echo "Skipping file (unwanted extension): $(basename "$file")"
    fi
  elif [ -d "$file" ]; then
    echo "Skipping directory: $(basename "$file") (subfolders are not backed up)"
  fi
done

# Compress the backup folder
echo "Compressing backup folder into $backupFolder.tar.gz"
if [ "$dryRun" == false ]; then
  tar -czf "$backupFolder.tar.gz" -C "$targetFolder" "backup_$timestamp"
  if [ $? -ne 0 ]; then
    echo "Error: Could not compress the backup folder."
    echo "Please check permissions or available disk space."
    exit 1
  fi
else
  echo "Dry-run: Would compress $backupFolder into $backupFolder.tar.gz."
fi

if [ "$dryRun" == false ]; then
  echo "Backup complete. Files are saved in $backupFolder.tar.gz"
else
  echo "Dry-run complete. No changes were made."
fi