# FileForge Example Definition

This is normal text

below is the block which should be fence named as `fileforge`:

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

    public/index.html   # This is to support single line folder files too

    # Components
    components/Button.tsx

    README.md
    infra/
        Dockerfile
        Dockerfile.backend
        Dockerfile.frontend
        compose.yaml
        compose.dev.yaml
    README.md   # This is duplicate file
    .gitignore
    .dockerignore

textfile.md # This is direct file at root

# 🖼️ Templat Outputs: Second root folder
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
