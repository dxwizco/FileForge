# FileForge

> A lightweight PowerShell scaffolding engine that generates project structures, files, and starter templates from reusable Markdown definitions.

![PowerShell](https://img.shields.io/badge/PowerShell-7%2B-blue)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux%20%7C%20macOS-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

FileForge helps developers create consistent project structures without manually creating folders, files, and starter templates every time.

Define your project structure once, store it as a reusable definition, and generate it whenever you start a new project.

---

# ✨ Features

- ⚡ No installation required — run directly using PowerShell
- 📁 Generate folders and files from Markdown definitions
- 📝 Human-readable `fileforge` definition blocks
- 🌳 Preview project structure before execution
- 📊 Show planned create/update/skip actions
- 🎨 Automatically generate files using extension-based templates
- 🏷 Add generated file path headers to created files
- 🛡 Protect existing files by default
- 🔁 Force execution mode for updating existing files
- 📚 Support multiple reusable project definitions
- 🌎 Cross-platform support:
  - Windows
  - Linux
  - macOS

---

# 🚀 Quick Start

## Requirements

- PowerShell 7+

Check your version:

```powershell
$PSVersionTable.PSVersion
```

---

# Generate Your First Project

FileForge works with definition files stored inside:

```
files/
```

Example:

```
files/test.md
```

Run:

```bash
pwsh ./FileForge.ps1 -File test -Target ./Projects/App
```

FileForge first runs in **PREVIEW mode**.

Example output:

```
MODE: PREVIEW

📁 TestProject
├── 📁 src
│   └── ✨ main.ps1
└── ✨ README.md
```

No files are changed during preview.

---

# Execution Mode

To actually create files:

```bash
pwsh ./FileForge.ps1 -File test -Target ./Projects/App -Run
```

Example:

```
MODE: EXECUTION

✏️ Created: TestProject/src/main.ps1
✏️ Created: TestProject/README.md
```

---

# Force Execution

By default, existing files are skipped.

To update existing files:

```bash
pwsh ./FileForge.ps1 -File test -Target ./Projects/App -Run -Force
```

Example:

```
♻️ Updated: TestProject/README.md
```

---

# 📄 FileForge Definitions

Definitions are stored inside:

```
files/
```

Example:

```
files/test.md
```

A definition file contains a Markdown fenced block using:

```
fileforge
```

The definition block must use indentation to represent folders and files.

Rules:

1. Use spaces for indentation (recommended) or tabs.
2. Use the FileForge fence identifier `fileforge` for the project definition block.
3. Do not use other fence identifiers such as `text`, `bash`, `powershell`, or an empty fence for the definition block.
4. Only the first `fileforge` block in the file is considered as the project definition.

Example:

```fileforge
TestProject/
    src/
        main.ps1
    public/
        index.html

    README.md
```

---

# Comments

FileForge supports comments.

## Full-line comment

```fileforge
# Application files

src/
    main.ps1
```

## Inline comment

```fileforge
src/main.ps1 # Main application entry point
```

---

# Path Support

FileForge supports:

## Nested folders

```fileforge
src/
    components/
        Button.tsx
```

Creates:

```
src
└── components
    └── Button.tsx
```

---

## Single-line folder paths

```fileforge
public/index.html
```

Creates:

```
public
└── index.html
```

---

## Special folder names

Supported:

```fileforge
app/
    [dynamic-route]/
        page.tsx

    (group)/
        page.tsx
```

---

# ⚙️ Command Usage

## Run From FileForge Folder

Linux/macOS/WSL:

```bash
pwsh ./FileForge.ps1 -File test -Target ./Projects/App
```

Windows PowerShell:

```powershell
.\FileForge.ps1 -File test -Target ".\Projects\App"
```

---

## Run From Any Location

Linux/macOS/WSL:

```bash
pwsh "/Tools/FileForge/FileForge.ps1" -File test -Target "/Projects/App"
```

Windows PowerShell:

```powershell
& "D:\Tools\FileForge\FileForge.ps1" -File test -Target "D:\Projects\App"
```

---

# Parameters

| Parameter | Description                                         |
| --------- | --------------------------------------------------- |
| `-File`   | Selects the definition file from the `files` folder |
| `-Target` | Defines where the generated project will be created |

Example:

```bash
-File test
```

uses:

```
files/test.md
```

---

# Options

| Option         | Description                              |
| -------------- | ---------------------------------------- |
| `-Run`         | Execute file creation/update operations  |
| `-ShowActions` | Show detailed create/update/skip actions |
| `-Force`       | Replace existing files during execution  |
| `-Help`        | Show FileForge help                      |
| `-Version`     | Show FileForge version                   |
| `-List`        | List available definitions               |

---

# Command Examples

## Preview

```bash
pwsh ./FileForge.ps1 -File test -Target ./xxx
```

---

## Preview with actions

```bash
pwsh ./FileForge.ps1 -File test -Target ./xxx -ShowActions
```

---

## Execute

```bash
pwsh ./FileForge.ps1 -File test -Target ./xxx -Run
```

---

## Execute with actions

```bash
pwsh ./FileForge.ps1 -File test -Target ./xxx -Run -ShowActions
```

---

## Execute with force update

```bash
pwsh ./FileForge.ps1 -File test -Target ./xxx -Run -Force
```

---

# Built-in Commands

## Version

```bash
pwsh ./FileForge.ps1 -Version
```

Example:

```
FileForge v2.0.0
```

---

## Help

```bash
pwsh ./FileForge.ps1 -Help
```

---

## List Definitions

```bash
pwsh ./FileForge.ps1 -List
```

Example:

```
Available FileForge Definitions

  test
  todo
```

---

# 🛡 Safety Behavior

FileForge protects existing projects.

## Preview Mode

Preview only displays what would happen.

No files are created or modified.

---

## Execution Without Force

Existing files are skipped.

Example:

```
⏭️ Skipped: README.md
```

---

## Execution With Force

Existing files are updated.

Example:

```
♻️ Updated: README.md
```

---

# 🎨 Templates

FileForge selects templates based on file extensions.

Examples:

| Extension | Generated Content       |
| --------- | ----------------------- |
| `.ts`     | TypeScript starter      |
| `.tsx`    | React component starter |
| `.js`     | JavaScript starter      |
| `.css`    | CSS starter             |
| `.html`   | HTML starter            |
| `.json`   | JSON starter            |
| `.py`     | Python starter          |
| `.sql`    | SQL starter             |

Example:

Creating:

```
Button.tsx
```

automatically uses the matching template.

Generated files can include:

```
// TestProject/components/Button.tsx
```

as a file path header.

---

# 📂 Project Structure

Example FileForge installation:

```
FileForge
│
├── files
│   ├── test.md
│   └── todo.md
│
├── templates
│
├── src
│   └── Engine
│       ├── Models.ps1
│       ├── TreeParser.ps1
│       ├── Renderer.ps1
│       ├── Executor.ps1
│       └── Validator.ps1
│
├── FileForge.ps1
├── README.md
└── LICENSE
```

---

# 🗺 Roadmap

Possible future improvements:

- Interactive definition selection
- Template variables
- Additional template engines
- Remote definition repositories
- More built-in project profiles
- Project metadata support

---

# 🤝 Contributing

Contributions are welcome.

If you improve FileForge, add templates, fix bugs, or suggest features, consider opening an issue or pull request.

---

# 🏢 About

FileForge is an open-source project created and maintained by **DXWIZ**.

---

# 📜 License

FileForge is licensed under the MIT License.

See the `LICENSE` file for details.

---

# ⭐ Why FileForge?

Many projects begin with repetitive setup tasks:

- Creating folders
- Adding standard files
- Preparing starter templates
- Maintaining consistent structures

FileForge converts those repeated steps into reusable definitions.

Define once.

Generate anytime.
