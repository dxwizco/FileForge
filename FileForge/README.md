# FileForge

A lightweight PowerShell-based file and folder generator that creates project structures using reusable file definitions and templates.

FileForge helps you quickly create consistent folder structures, empty files, and starter templates for projects without manually creating everything from scratch.

---

## Features

- Create folders and files from simple definition files
- Support multiple project/file profiles
- Add reusable templates based on file extensions
- Automatically add file path headers
- Skip existing files with content
- Safe by default (does not overwrite existing work)
- Provides creation summary:
  - Total files
  - Created files
  - Skipped files
  - Failed files

---

## How It Works

FileForge uses three layers:

```
File Definition
    |
    v
Template Selection
    |
    v
File Creation
```

Example: files/react-app.txt

defines:

```
src/components/Button.tsx
src/styles/main.css
public/index.html
```

FileForge reads this definition and creates:

```
MyApplication
|
├── src
│ ├── components
│ │ └── Button.tsx
│ └── styles
│ └── main.css
|
└── public
└── index.html
```

---

## Folder Structure

```

FileForge
|
├── FileForge.ps1
├── Templates.ps1
|
├── files
│ ├── react-app.txt
│ ├── node-api.txt
│ └── python-service.txt
|
└── templates
├── ts.ps1
├── tsx.ps1
├── css.ps1
├── html.ps1
├── js.ps1
├── json.ps1
├── py.ps1
└── sql.ps1

```

---

## Requirements

- PowerShell 7+

Check your version:

```powershell
$PSVersionTable.PSVersion
```

FileForge works on:

- Windows
- Linux
- macOS

using PowerShell Core (`pwsh`).

---

# Usage

## Basic Usage

```powershell
.\FileForge.ps1 `
-File react-app `
-Target "D:\Projects\MyApplication"
```

or with a full path:

```powershell
& "D:\Tools\FileForge\FileForge.ps1" `
-File react-app `
-Target "D:\Projects\MyApplication"
```

---

## Parameters

### -File

Selects the file definition to use.

Example:

```powershell
-File react-app
```

Uses:

```
files/react-app.txt
```

Available definitions:

```
files
|
├── react-app.txt
├── node-api.txt
└── python-service.txt
```

---

### -Target

Defines where the generated files should be created.

Example:

```powershell
-Target "D:\Projects\DemoApp"
```

The paths from the definition file are created relative to this location.

---

## Creating a New File Definition

Create a new file:

```
files/angular-app.txt
```

Add required files:

```text
src/app/app.component.ts
src/app/app.component.html
src/styles/main.css
package.json
README.md
```

Run:

```powershell
.\FileForge.ps1 `
-File angular-app `
-Target "D:\Projects\AngularDemo"
```

---

## Templates

Templates are selected automatically based on file extension.

Example:

```
templates
|
├── ts.ps1
├── css.ps1
└── html.ps1
```

When creating:

```
Button.tsx
```

FileForge automatically uses:

```
templates/tsx.ps1
```

---

## Safety Behavior

FileForge is designed to protect existing work.

### Existing files

If a file already contains content:

```
➡️ Skipped (has content)
```

The file is not modified.

---

### New files

If a file does not exist:

```
✏️ Added template:
D:\Projects\App\src\Component.tsx
```

The file is created with the configured template.

---

### Summary Example

```
===== FileForge Summary =====
Total:   13
Created: 9
Skipped: 4
Failed:  0
=============================
```

---

## Example Workflow

Create a new React application structure:

```powershell
.\FileForge.ps1 `
-File react-app `
-Target "D:\Projects\CustomerPortal"
```

Result:

```
CustomerPortal
|
├── src
│   ├── components
│   ├── styles
│   └── contracts
|
├── public
|
└── package.json
```

---

## Why FileForge?

Many projects start with the same repetitive tasks:

- Creating folders
- Adding standard files
- Adding starter templates
- Maintaining consistent structures

FileForge turns those repeated steps into reusable definitions.

Create once.
Generate anytime.

---

## Future Improvements

Possible future enhancements:

- Preview mode (`--what-if`)
- Custom template variables
- File replacement mode
- More template engines
- Project metadata support

---

## License

Personal utility tool.
Use and modify as required.

```

A small suggestion: since you are renaming from `ProjectScaffold` to `FileForge`, also rename:

```

Scaffold.ps1

```

to:

```

FileForge.ps1

````

and update the command:

```powershell
.\FileForge.ps1 -File react-app -Target "D:\Projects\App"
````

The name now matches the actual capability better: it **forges files and folders from blueprints**.
