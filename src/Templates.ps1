# Templates.ps1

function Get-CommentHeader {
    param(
        [string]$Extension,
        [string]$Path
    )

    # # Extract the actual file name (e.g., "dockerfile" or "dockerfile.backend")
    # $fileName = [System.IO.Path]::GetFileName($Path).ToLower()

    # # FIX: If it's any variation of a Dockerfile, intercept it immediately and return a '#' header
    # if ($fileName -like "dockerfile*") {
    #     return "# $Path"
    # }

    # Convert to lowercase for clean matching
    $extLower = $Extension.ToLower()
    $fileName = [System.IO.Path]::GetFileName($Path).ToLower()

    # 1. First, check standard, explicitly styled extensions

    switch ($extLower) {
        ".ts"   { return "// $Path" }
        ".tsx"  { return "// $Path" }
        ".js"   { return "// $Path" }
        ".jsx"  { return "// $Path" }
        ".css"  { return "/* $Path */" }
        ".scss" { return "/* $Path */" }
        ".html" { return "<!-- $Path -->" }
        ".py"   { return "# $Path" }
        ".sql"  { return "-- $Path" }
        ".ps1"  { return "# $Path" }
        ".sh"   { return "#!/bin/bash`r`n# $Path" } # Shell scripts get their shebang
        ".yml"  { return "# $Path" }
        ".yaml" { return "# $Path" }
        ".env"  { return "# $Path" }
        ".md"   { return "<!-- $Path -->" }
        ".cs"   { return "// $Path" }
        ".go"   { return "// $Path" }
        ".rs"   { return "// $Path" }
        ".vue"  { return "<!-- $Path -->" }
        ".json" { return "" }                   # Explicitly no header (JSON crashes with comments)
    }

    # 2. UNIVERSAL FALLBACK: Catch special configuration and extensionless files
    # This automatically matches dockerfile, dockerfile.backend, .gitignore, .dockerignore, CNAME, etc.
    if ($fileName -like "dockerfile*" -or 
        $fileName -like ".*ignore" -or 
        $fileName -like "*.example" -or
        $fileName -contains ".env." -or
        [string]::IsNullOrWhiteSpace($extLower)) {
        
        # Exception: Don't add a header to extensionless files that shouldn't have comments (e.g., LICENSE)
        if ($fileName -eq "license") { return "" }
        
        return "# $Path"
    }

    # 3. Absolute default if it matches nothing else
    return ""
}

function Get-Template {
    param(
        [string]$Path
    )

    $extension = [System.IO.Path]::GetExtension($Path).ToLower()
    $fileName = [System.IO.Path]::GetFileName($Path).ToLower() 
    $cleanExtension = $extension.TrimStart('.')

    # 1. Match Exact Filename First (looks for templates/dockerfile.ps1 or templates/compose.dev.yaml.ps1)
    $templateFile = Join-Path $PSScriptRoot "templates\$fileName.ps1"

    # 2. Match Extension Next (looks for templates/yaml.ps1)
    if (!(Test-Path $templateFile) -and ![string]::IsNullOrWhiteSpace($cleanExtension)) {
        $templateFile = Join-Path $PSScriptRoot "templates\$cleanExtension.ps1"
    }

    # Load content if a template was found
    $content = ""
    if (Test-Path $templateFile) {
        # FIX: Wrapped in () so it evaluates the method instead of treating it as text string
        $computedFileName = [System.IO.Path]::GetFileNameWithoutExtension($Path)
        
        $content = & $templateFile `
            -Path $Path `
            -FileName $computedFileName
    }

    # Attach the header if applicable
    $header = Get-CommentHeader -Extension $extension -Path $Path

    if (![string]::IsNullOrWhiteSpace($header)) {
        return "$header`r`n`r`n$content"
    }
    else {
        return $content
    }
}