# # FileForge.ps1


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
    # FIX: Use -LiteralPath here to safely detect brackets
    if (!(Test-Path -LiteralPath $Target)) {

        New-Item `
            -ItemType Directory `
            -Path $Target `
            -Force `
            -ErrorAction Stop | Out-Null

        Write-Host "📁 Created target folder: $Target"

    }
}



# Resolve dynamic file list
$fileListPath = Join-Path $PSScriptRoot "files\$File.txt"


# FIX: Use -LiteralPath for template list verification
if (!(Test-Path -LiteralPath $fileListPath)) {

    Write-Host "❌ File list not found: $fileListPath" -ForegroundColor Red
    exit

}



Write-Host ""
Write-Host "Using file list:"
Write-Host $fileListPath -ForegroundColor Cyan
Write-Host ""



# Read file list
$files = Get-Content -LiteralPath $fileListPath | # FIX: Added -LiteralPath here
    ForEach-Object {

        # Remove inline comments
        ($_ -replace '#.*$', '').Trim()

    } |
    Where-Object {

        $_ -ne ""

    }



# Parsed files summary
Write-Host "===== Parsed Files =====" -ForegroundColor Cyan
Write-Host "Count: $($files.Count)"
Write-Host "========================"
Write-Host ""



# Counters
$createdCount = 0
$skippedCount = 0
$failedCount  = 0



# Create files
foreach ($relativeFile in $files) {


    try {

        # If the entry ends with / or \, treat it as a directory
        if ($relativeFile -match '[\\/]$') {

            $folderPath = Join-Path `
                $Target `
                ($relativeFile.TrimEnd('\','/'))

            # FIX: Use -LiteralPath for structural directories
            if (!(Test-Path -LiteralPath $folderPath)) {

                New-Item `
                    -ItemType Directory `
                    -Path $folderPath `
                    -Force `
                    -ErrorAction Stop | Out-Null

                Write-Host "📁 Created folder: $folderPath" -ForegroundColor Green

                $createdCount++
            }
            else {

                Write-Host "➡️ Folder exists: $folderPath" -ForegroundColor Yellow

                $skippedCount++
            }

            continue
        }

        # === end of folder adding ===


        $filePath = Join-Path `
            $Target `
            $relativeFile



        $directory = Split-Path `
            $filePath `
            -Parent



        # Create directory
        # FIX: Use -LiteralPath when creating nested directories for files
        if (!(Test-Path -LiteralPath $directory)) {


            New-Item `
                -ItemType Directory `
                -Path $directory `
                -Force `
                -ErrorAction Stop | Out-Null


            Write-Host "📁 Created folder: $directory"

        }


        # Check if the file already exists on disk
        # FIX: Changed -Path to -LiteralPath to avoid bracket wildcard mismatch
        if (Test-Path -LiteralPath $filePath -PathType Leaf) {
            Write-Host `
                "➡️ Skipped (already exists): $filePath" `
                -ForegroundColor Yellow
            
            $skippedCount++
            continue # This instantly moves to the next file, skipping the creation below
        }

        # If it doesn't exist, build the template and create it
        $content = Get-Template $relativeFile

        # FIX: Changed -Path to -LiteralPath to let it write filenames with brackets correctly
        Set-Content `
            -LiteralPath $filePath `
            -Value $content `
            -ErrorAction Stop

        Write-Host `
            "✏️ Added template: $filePath" `
            -ForegroundColor Green

        $createdCount++

    }
    catch {


        Write-Host `
            "❌ Failed: $relativeFile" `
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

