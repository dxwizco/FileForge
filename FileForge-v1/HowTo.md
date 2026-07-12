# Project Scaffold Tool

## Purpose

This PowerShell utility creates project folders and files automatically.

Features:

- Creates missing folders
- Creates missing files
- Adds starter templates based on file extension
- Adds file path comments
- Does not overwrite existing content
- Safe to run multiple times

---

# Folder Structure

```
FileForge/

├── Scaffold.ps1
├── Templates.ps1
├── files.txt
└── howto.md

```

---

# Usage

## Step 1: Add files

Edit: files.txt
File will accept Full-line comments as well Inline comments

Example:

```
src/platform/contracts/runtime.ts
src/components/        # Inline comment

# Full-line comments
src/components/Button.tsx
src/styles/main.css
public/index.html

```

Do not add:

```
"" or ,
```

Just plain paths.

---

## Step 2: Run the command

### Option 1 — Go into FileForge folder and run

#### With multiple files

Example:

```powershell
cd D:\WIP-Learn\ScaffoldTools\FileForge

\Scaffold.ps1" -Files react-app -Target "D:\WIP-Learn\dx-test"
```

#### With Single file command versioin using `Scaffold1.ps1`

This works having source file.txt directly in FileForge.

```powershell
.\Scaffold1.ps1 -Target "D:\WIP-Learn\dx-test"
```

---

### Option 2 — Stay anywhere and call the full path

Example:

This format (`&`) is safer when the path contains spaces.

```powershell
& "D:\WIP-Learn\dx-test\FileForge\Scaffold.ps1" `
-Files react-app `
-Target "D:\WIP-Learn\dx-test"
```

```powershell
& "D:\WIP-Learn\dx-test\FileForge\Scaffold.ps1" -Files react-app -Target "D:\WIP-Learn\dx-test"
```

or:

```powershell
"D:\WIP-Learn\dx-test\FileForge\Scaffold.ps1" -Files react-app -Target "D:\WIP-Learn\dx-test"
```

---

### Option 3 — Copy FileForge folder wherever you want

Example:

```text
D:\Tools\FileForge
```

or:

```text
C:\Dev\MyScaffold
```

Then run:

```powershell
.\Scaffold.ps1 -Target "D:\Projects\App1"
```

---

### Recommended usage pattern

Keep one master copy:

```text
D:\DevTools\FileForge
```

Structure:

```text
D:\DevTools\FileForge
│
├── Scaffold.ps1
├── Templates.ps1
├── files.txt
└── howto.md
```

Then generate anywhere:

```powershell
& "D:\DevTools\FileForge\Scaffold.ps1" `
    -Target "D:\Projects\CustomerPortal"
```

or:

```powershell
& "D:\DevTools\FileForge\Scaffold.ps1" `
    -Target "D:\Projects\AdminPortal"
```

---

---

# To DELETE Below

## Step 2: Run scaffold

Open PowerShell:

```
cd FileForge
```

### Generate a new project

Run:

```powershell
.\Scaffold.ps1 -Target "C:\Projects\MyNewApp"
```

### Generate another project

Run:

```powershell
.\Scaffold.ps1 -Target "C:\Projects\AdminPortal"
```

### Generate into current folder of the "FileForge" but not recomended

Run:

```powershell
.\Scaffold.ps1
```

Without target The script will ask confirmation before creating files in the current folder:

```powershell
⚠️ No -Target specified.
Files will be created here:
D:\Tools\FileForge

Continue? (Y/N):
```

If you type: N

Output: ❌ Cancelled.

---

# Result

Example:

```
src/

├── platform/
│   └── contracts/
│       └── runtime.ts

├── components/
│   └── Button.tsx

└── styles/
    └── main.css

public/

└── index.html

```

---

# Existing Files Behavior

## Empty file

Before:

```
runtime.ts
```

After:

```ts
// src/platform/contracts/runtime.ts

export {};
```

## File with content

Before:

```ts
export interface User {}
```

Running scaffold:

```
➡️ Skipped (has content)
```

The file is not changed.

---

# Supported Templates

| Extension | Template        |
| --------- | --------------- |
| .ts       | TypeScript      |
| .tsx      | React component |
| .js       | JavaScript      |
| .css      | CSS starter     |
| .html     | HTML starter    |
| .json     | Empty JSON      |
| .py       | Python header   |
| .sql      | SQL header      |

---

# Future Improvements

Planned:

- Generate single file:

```
.\Scaffold.ps1 src/components/UserCard.tsx
```

- Filename-based templates:

```
useAuth.ts
user.service.ts
Button.test.tsx
index.ts
```

- Preview mode:

```
.\Scaffold.ps1 -Preview
```

---
