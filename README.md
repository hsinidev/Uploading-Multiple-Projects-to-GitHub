# Uploading-Multiple-Projects-to-GitHub
# 🚀 Batch GitHub Uploader

> **Automate your workflow.** Upload multiple local projects to GitHub repositories in seconds.

This powerful toolkit allows you to scan your local directories, generate a project list, and automatically initialize, create, and push repositories to GitHub. Perfect for backing up local work or migrating to GitHub.

---

## ✨ Features

- **Automatic Repository Creation**: Uses GitHub CLI to create public private repositories instantly.
- **Smart Git Initialization**: Automatically initializes Git, adds files, and handles `main` branch creation.
- **Batch Processing**: Handles dozens of projects in a single loop.
- **Robust Error Handling**: Detects existing repos and handles synchronization gracefully.

---

## 🛠️ Prerequisites

1.  **Git**: [Download Git](https://git-scm.com/)
2.  **GitHub CLI (`gh`)**:
    ```powershell
    winget install --id GitHub.cli
    # After install, run:
    gh auth login
    ```
3.  **Python 3.x**: Required for parsing directory names.

---

## 🚀 Usage Guide

### Step 1: Prepare Project List

First, scan your folder to generate the list of projects you want to upload.

```bash
# Basic usage
python get_repo_names.py --path "C:\Path\To\MyProjects"

# Output will be saved to 'repo_names.txt'
```

Copy the desired folder names from `repo_names.txt` into `project_list.py`:

```python
# project_list.py
PROJECT_NAMES = [
    "my-awesome-game",
    "backend-api",
    "portfolio-site"
]
```

### Step 2: Run the Uploader

Run the PowerShell script. It will interactively ask for your details if you don't provide them.

```powershell
.\upload_batch.ps1
```

Or run it with arguments for full automation:

```powershell
.\upload_batch.ps1 -GitHubUser "hsinidev" -ParentDir "C:\Users\hsini\Desktop\Projects"
```

---

## 👨‍💻 Author & Credits

<div align="center">

**Powered by [HSINI MOHAMED](https://github.com/hsinidev)**

[![Website](https://img.shields.io/badge/Website-doodax.com-blue?style=for-the-badge&logo=google-chrome)](https://doodax.com)
[![Email](https://img.shields.io/badge/Email-hsini.web%40gmail.com-red?style=for-the-badge&logo=gmail)](mailto:hsini.web@gmail.com)
[![GitHub](https://img.shields.io/badge/GitHub-hsinidev-black?style=for-the-badge&logo=github)](https://github.com/hsinidev)

</div>

---

**Note:** Ensure you have the rights to upload the code you are processing. This tool is provided as-is to help automate your personal workflow.
