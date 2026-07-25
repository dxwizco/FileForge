# FileForge Example Definition

This document demonstrates how to define a project structure using FileForge.

---

## Commands to use FileForge

```bash
# PREVIEW: Show planned structure only
pwsh ./FileForge.ps1 -File test -Target ./xxx

# PREVIEW: Show structure with actions
pwsh ./FileForge.ps1 -File test -Target ./xxx -ShowActions

# EXECUTION: Create files and skip existing files
pwsh ./FileForge.ps1 -File test -Target ./xxx -Run

# EXECUTION: Create files, skip existing files and show executed actions
pwsh ./FileForge.ps1 -File test -Target ./xxx -Run -ShowActions

# EXECUTION + FORCE: Replace existing files
pwsh ./FileForge.ps1 -File test -Target ./xxx -Run -Force

# EXECUTION + FORCE: Replace files and show executed actions
pwsh ./FileForge.ps1 -File test -Target ./xxx -Run -Force -ShowActions
```

---

## ⚙️ Command Usage

### Run From FileForge Folder (Output Inside FileForge Folder)

When your terminal is inside the FileForge folder.

> Not recommended for production projects. Prefer generating into a separate target folder.

Linux/macOS PowerShell:

```bash
pwsh ./FileForge.ps1 -File test -Target ./Project
```

Windows PowerShell:

```powershell
.\FileForge.ps1 -File test -Target ".\Project"
```

---

### Run From FileForge Folder (Output To Another Folder)

When FileForge is inside one folder and the generated project should be somewhere else.

Linux/macOS PowerShell:

```bash
pwsh ./FileForge.ps1 -File test -Target ./Projects/App
```

If the folder name contains spaces:

```bash
pwsh ./FileForge.ps1 -File test -Target "./Projects Folder/App"
```

Windows PowerShell:

```powershell
.\FileForge.ps1 -File test -Target "D:\Projects\App"
```

---

### Run From Any Location

FileForge can also be executed using its full script path.

Linux/macOS PowerShell:

```bash
pwsh "/home/user/Tools/FileForge/FileForge.ps1" -File test -Target "/home/user/Projects/App"
```

Windows PowerShell:

```powershell
& "D:\Tools\FileForge\FileForge.ps1" -File test -Target "D:\Projects\App"
```

---

### Parameters

| Parameter | Description                                         |
| --------- | --------------------------------------------------- |
| `-File`   | Selects the definition file from the `files` folder |
| `-File`   | defaults to `test` if not specified                 |
| `-Target` | Defines where the generated project will be created |
| `-Target` | defaults to the current directory if not specified  |

### Available Options

| Option         | Description                                              |
| -------------- | -------------------------------------------------------- |
| `-Run`         | Execute file creation operations and skip existing files |
| `-ShowActions` | Show detailed create/update/skip actions                 |
| `-Force`       | Replace existing files during execution                  |

---

## FileForge Definition Block and Format

FileForge reads only fenced blocks marked with the language identifier `fileforge`.

The `fileforge` fence tells FileForge which section contains the project definition.

The definition block must use indentation to represent folders and files.

Use spaces for indentation (recommended) or tabs.

Use:

```fileforge
Project/
    src/
        main.ps1
```

Do not use:

```text
Project/
    src/
        main.ps1
```

---

## Formatted block with files to be created

The following block describes the generated project tree:

```fileforge
# This is full line comment
TestProject/    # First root folder
    app/
        testfolder/
        test-folder/
        # Special folders
        [dynamic-route]/
            page.tsx
        /(group)/
            page.tsx

        styles/
            main.css  # This is inline comment

    # Single line folder + file path
    public/index.html

    # Components
    components/Button.tsx

    README.md
    infra/
        Dockerfile
        Dockerfile.backend
        Dockerfile.frontend
        compose.yaml
        compose.dev.yaml
    README.md   # Duplicate file example
    .gitignore
    .dockerignore

# Root level file
textfile.md

# 🖼️ Second root folder with emoji support
TestOutputs/
    template-outputs/
        file-type.ts
        file-type.tsx
        file-type.js
        file-type.jsx
        file-type.css
        file-type.scss
        file-type.html
        file-type.py
        file-type.sql
        file-type.json
        file-type.ps1
        file-type.sh
        file-type.yml
        file-type.yaml
        file-type.env
        file-type.md
        file-type.cs
        file-type.go
        file-type.rs
        file-type.vue
```
