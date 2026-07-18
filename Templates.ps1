# Templates.ps1

function Get-CommentHeader {

    param(
        [string]$Extension,
        [string]$Path
    )

    switch ($Extension.ToLower()) {
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
        ".json" { return "" }
        default { return "" }
    }
}


function Get-Template {

    param(
        [string]$Path
    )

    $extension = [System.IO.Path]::GetExtension($Path).ToLower()

    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($Path)

    $cleanExtension = $extension.TrimStart('.')


    # Resolve template file
    $templateFile = Join-Path `
        $PSScriptRoot `
        "templates\$cleanExtension.ps1"


    # Load template content
    $content = ""

    if (Test-Path $templateFile) {
        $content = & $templateFile `
            -Path $Path `
            -FileName $fileName
    }

    # Keep full relative scaffold path in file header
    $header = Get-CommentHeader `
        -Extension $extension `
        -Path $Path

    if (![string]::IsNullOrWhiteSpace($header)) {
        return "$header`r`n`r`n$content"
    }
    else {
        return $content
    }
}
