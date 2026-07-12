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

    $extension = [IO.Path]::GetExtension($Path).ToLower()

    $fileName = [IO.Path]::GetFileNameWithoutExtension($Path)

    $templateFile = Join-Path `
        $PSScriptRoot `
        "templates\$($extension.TrimStart('.')).ps1"

    # Load template content
    if (Test-Path $templateFile) {
        $content = & $templateFile `
            -Path $Path `
            -FileName $fileName
    }
    else {
        $content = ""
    }

    # Add path header
    $header = Get-CommentHeader `
        -Extension $extension `
        -Path $Path

    if (![string]::IsNullOrWhiteSpace($header)) {
        return @"
$header

$content
"@
    }
    else {
        return $content
    }
}