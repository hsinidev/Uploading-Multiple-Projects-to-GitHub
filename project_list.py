# project_list.py
# This file contains the list of local project folder names to be uploaded.

PROJECT_NAMES = [
    "project-alpha-game",
    "project-beta-api",
    # Add your actual folder names here...
]

def get_project_list_for_powershell():
    """
    Returns the project list formatted as a PowerShell array string.
    This function is called directly by the PowerShell script.
    """
    # Escape quotes if necessary, though simple directory names shouldn't have them
    sanitized_names = [name.replace('"', '`"') for name in PROJECT_NAMES]
    list_string = ',"'.join(sanitized_names)
    return '@("' + list_string + '")'

if __name__ == "__main__":
    # If run directly for testing, print the names
    print(f"Loaded {len(PROJECT_NAMES)} projects:")
    for name in PROJECT_NAMES:
        print(f" - {name}")