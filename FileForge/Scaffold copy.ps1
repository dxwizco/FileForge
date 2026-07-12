# Scaffold.ps1

param(
    [Parameter(Mandatory=$false)]
    [string]$Target,

    [Parameter(Mandatory=$false)]
    [string]$File = "default"
)

# Load templates from this tool folder
. "$PSScriptRoot\Templates.ps1"


# Decide target folder
if ([string]::IsNullOrWhiteSpace($Target)) {

    $Target = (Get-Location).Path

    Write-Host ""
    Write-Host "⚠️ No -Target specified."
    Write-Host "Files will be created here:"
    Write-Host $Target -ForegroundColor Yellow
    Write-Host ""

    $answer = Read-Host "Continue? (Y/N)"

    if ($answer.ToUpper() -ne "Y") {

        Write-Host "❌ Cancelled."
        exit

    }

}
else {

    if (!(Test-Path $Target)) {

        New-Item `
            -ItemType Directory `
            -Path $Target `
            -Force | Out-Null

        Write-Host "📁 Created target folder: $Target"

    }
}

# Resolve dynamic file list
$fileListPath = Join-Path $PSScriptRoot "files\$File.txt"

if (!(Test-Path $fileListPath)) {

    Write-Host "❌ File list not found: $fileListPath" -ForegroundColor Red
    exit

}

Write-Host ""
Write-Host "Using file list:"
Write-Host $fileListPath -ForegroundColor Cyan
Write-Host ""

# Read file list
$files = Get-Content $fileListPath |
    ForEach-Object {

        # Remove inline comments
        ($_ -replace '#.*$', '').Trim()

    } |
    Where-Object {
        $_ -ne ""
    }

# DX: Debug summary Start (remove later if not needed)
Write-Host "===== Parsed Files =====" -ForegroundColor Cyan
Write-Host "Count: $($files.Count)"

# foreach ($f in $files) {
#     Write-Host " - $f"
# }

Write-Host "========================"
# Write-Host ""
# DX: Debug summary END (remove later if not needed)

# Counters
$createdCount = 0
$skippedCount = 0
$failedCount = 0

# Create files
foreach ($relativeFile in $files) {

    $filePath = Join-Path `
        $Target `
        $relativeFile

    $directory = Split-Path `
        $filePath `
        -Parent

    # Create directory
    if (!(Test-Path $directory)) {

        New-Item `
            -ItemType Directory `
            -Path $directory `
            -Force | Out-Null

        Write-Host "📁 Created folder: $directory"

    }

    # Check existing file
    if (Test-Path $filePath -PathType Leaf) {

        $existing = Get-Content `
            $filePath `
            -Raw
    }
    else {
        $existing = ""
    }

    # Add template only if empty
    try {

    if ([string]::IsNullOrWhiteSpace($existing)) {

        $content = Get-Template `
            $relativeFile

        Set-Content `
            -Path $filePath `
            -Value $content `
            -ErrorAction Stop

        Write-Host `
            "✏️ Added template: $filePath" `
            -ForegroundColor Green

        $createdCount++

    }
    else {

        Write-Host `
            "➡️ Skipped (has content): $filePath" `
            -ForegroundColor Yellow

        $skippedCount++

    }

}
catch {

    Write-Host `
        "❌ Failed: $filePath" `
        -ForegroundColor Red

    Write-Host `
        "   Reason: $($_.Exception.Message)" `
        -ForegroundColor DarkRed

    $failedCount++

}

}
# Final summary
Write-Host ""
Write-Host "===== Scaffold Summary =====" -ForegroundColor Cyan
Write-Host "Total:   $($files.Count)"
Write-Host "Created: $createdCount" -ForegroundColor Green
Write-Host "Skipped: $skippedCount" -ForegroundColor Yellow
Write-Host "Failed:  $failedCount" -ForegroundColor Red
Write-Host "==========================="