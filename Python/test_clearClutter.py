# use this script prior to running the clearClutter.py script to generate a folder inside of Downloads with several test files 
# point the clearClutter.py script towards the newly generated "Downloads_To_Delete" folder now located inside of your "Downloads folder"

import os
import random
import string
from pathlib import Path

def create_test_environment():
    """Create test folder with sample files, preserving existing content."""
    downloads_path = Path.home() / "Downloads"
    test_folder = downloads_path / "Downloads_To_Delete"
    
    # Create folder if it doesn't exist
    test_folder.mkdir(exist_ok=True)
    
    extensions = ['.exe', '.jpg', '.png', '.jpeg', '.img', '.zip', '.txt']
    files_created = []
    
    # Count existing files to avoid name conflicts
    existing_files = list(test_folder.glob('test_file_*'))
    start_num = len(existing_files)
    
    # Create 10-15 new test files
    num_files = random.randint(10, 15)
    
    for i in range(start_num, start_num + num_files):
        ext = random.choice(extensions)
        filename = f"test_file_{i}{ext}"
        filepath = test_folder / filename
        
        # Skip if file already exists (shouldn't happen with our naming)
        if filepath.exists():
            continue
            
        file_size = random.randint(1024, 1048576)  # 1KB to 1MB
        content = ''.join(random.choices(string.ascii_letters + string.digits, k=file_size))
        filepath.write_text(content)
        files_created.append(filename)
    
    print(f"\nAdded {len(files_created)} new test files to: {test_folder}")
    print("File extensions used:", ', '.join(set(extensions)))
    return test_folder

def display_folder_contents(folder_path):
    """Display all files in folder with their sizes."""
    print("\n=== Current Folder Contents ===")
    total_size = 0
    files = list(folder_path.iterdir())
    
    if not files:
        print("Folder is empty")
        return
    
    for i, file_path in enumerate(files, 1):
        file_size = file_path.stat().st_size
        total_size += file_size
        print(f"{i}. {file_path.name} ({file_size/1024:.1f} KB)")
    
    print(f"\nTotal folder size: {total_size/1048576:.2f} MB")

def main():
    print("=== Test File Generator ===")
    print("This adds sample files to Downloads_To_Delete without deleting existing files\n")
    
    test_folder = create_test_environment()
    display_folder_contents(test_folder)
    
    print("\nYou can now run:")
    print(f"python clearClutter.py")
    print("and point it to:", test_folder)
    print("\nOperation complete.")

if __name__ == "__main__":
    main()