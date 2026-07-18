# Changelog

All notable changes to FileForge will be documented in this file.

The format is based on:

- [Keep a Changelog](https://keepachangelog.com/)
- Semantic Versioning

---

# [Unreleased]

## Added

- Initial roadmap for future improvements.
- Community contribution support.

## Planned

- Preview mode (`--what-if`)
- Custom template variables
- Additional template engines
- More built-in project profiles
- Interactive project creation wizard

---

# [1.0.0] - 2026-07-18

## Added

### Core Features

- Initial release of FileForge.
- Generate folders and files from reusable definition files.
- Support multiple project structure profiles.
- Automatically select templates based on file extensions.
- Create starter files using reusable PowerShell templates.
- Add automatic file path headers.

### Safety Features

- Skip existing files containing content.
- Protect existing project files from accidental overwrite.
- Ask for confirmation when no target directory is provided.

### Reporting

- Added generation summary:
  - Total files
  - Created files
  - Skipped files
  - Failed files

### Included Profiles

- React application structure
- Node.js API structure
- .NET API structure
- Python service structure
- Company standard structure

### Included Templates

- TypeScript
- React TSX
- JavaScript
- CSS
- HTML
- JSON
- Python
- SQL

---

# Release Notes

## Versioning Strategy

FileForge follows:

```text
MAJOR.MINOR.PATCH
```

Example:

```text
1.2.3
│ │ │
│ │ └── Bug fixes
│ └──── New features
└────── Breaking changes
```

---

# How to Add Changes

When adding a new change, place it under:

```text
[Unreleased]
```

before the next release.

Example:

```markdown
## Added

- Added Angular project profile.
- Added YAML template support.
```

When releasing:

1. Rename `[Unreleased]` to the version number.
2. Add the release date.
3. Create a new empty `[Unreleased]` section.

---

# Future Releases

Future versions will be documented here as FileForge evolves.
