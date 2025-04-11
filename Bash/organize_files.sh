#!/bin/bash

# organize_files.sh
# Student: Jessica Moore
# Description: Organizes files in the Downloads folder by file type

# Create directories if they don't exist
mkdir -p ~/Downloads/Images ~/Downloads/Documents ~/Downloads/Archives ~/Downloads/Others

# Move files to appropriate folders
for file in ~/Downloads/*; do
    if [ -f "$file" ]; then  # Only process files (not folders)
        case "$file" in
            *.jpg|*.png|*.gif)
                mv "$file" ~/Downloads/Images/
                ;;
            *.pdf|*.docx|*.txt)
                mv "$file" ~/Downloads/Documents/
                ;;
            *.zip|*.tar|*.gz)
                mv "$file" ~/Downloads/Archives/
                ;;
            *)
                mv "$file" ~/Downloads/Others/
                ;;
        esac
        echo "Moved: $(basename "$file")"
    fi
done

echo "Organization complete!"