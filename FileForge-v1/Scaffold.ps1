# Scaffold.ps1


param(
    [Parameter(Mandatory=$false)]
    [string]$Target
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


# Read files.txt from scaffold tool folder
$files = Get-Content "$PSScriptRoot\files.txt" |
    ForEach-Object {

        # Remove inline comments
        $line = $_ -replace "#.*$",""

        $line.Trim()

    } |
    Where-Object {
        $_ -ne ""
    }



foreach ($relativeFile in $files) {


    # Combine target + relative path
    $file = Join-Path `
        $Target `
        $relativeFile



    $directory = Split-Path $file -Parent



    # Create directory
    if (!(Test-Path $directory)) {

        New-Item `
            -ItemType Directory `
            -Path $directory `
            -Force | Out-Null

        Write-Host "📁 Created folder: $directory"
    }



    # Read existing file
    if (Test-Path $file -PathType Leaf) {

        $existing = Get-Content $file -Raw

    }
    else {

        $existing = ""

    }



    # Add template only if empty
    if ([string]::IsNullOrWhiteSpace($existing)) {


    $content = Get-Template $relativeFile


    Set-Content `
        -Path $file `
        -Value $content


    Write-Host `
        "✏️ Added template: $file" `
        -ForegroundColor Green

    }
    else {


        Write-Host `
            "➡️ Skipped (has content): $file" `
            -ForegroundColor Yellow

    }

}