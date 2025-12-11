import os
import sys
import argparse

def extract_repository_names(parent_dir, output_file):
    """
    Scans the parent directory, extracts the names of all subdirectories,
    and writes them to an output file.
    """
    if not os.path.exists(parent_dir):
        print(f"❌ Error: Directory not found at: {parent_dir}")
        sys.exit(1)

    # List to store the extracted folder names
    repo_names = []

    print(f"📂 Scanning directory: {os.path.abspath(parent_dir)}")

    try:
        # os.listdir returns all files and folders inside the directory
        for item_name in os.listdir(parent_dir):
            if item_name.startswith('.'):
                continue # Skip hidden files/folders

            # Construct the full path
            item_path = os.path.join(parent_dir, item_name)
            
            # Check if the item is a directory (folder)
            if os.path.isdir(item_path):
                repo_names.append(item_name)
    except PermissionError:
        print(f"❌ Error: Permission denied accessing {parent_dir}")
        sys.exit(1)

    if not repo_names:
        print("⚠️  No subdirectories found.")
        sys.exit(0)
    
    # Write the list of names to the output file
    try:
        with open(output_file, 'w', encoding='utf-8') as f:
            for name in repo_names:
                f.write(f"{name}\n")
        
        print(f"✅ Success! Found {len(repo_names)} projects.")
        print(f"📝 List saved to: {os.path.abspath(output_file)}")

    except Exception as e:
        print(f"❌ Error writing to file: {e}")
        sys.exit(1)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Extract subdirectory names to a text file.")
    parser.add_argument("--path", "-p", default=".", help="The parent directory to scan (default: current dir)")
    parser.add_argument("--output", "-o", default="repo_names.txt", help="The output text file (default: repo_names.txt)")
    
    args = parser.parse_args()
    
    extract_repository_names(args.path, args.output)