param(

    [Parameter(Mandatory=$false)]
    [string]$Target = ".",

    [Parameter(Mandatory=$false)]
    [string]$File = "test",

    [Parameter(Mandatory=$false)]
    [switch]$Apply,

    [Parameter(Mandatory=$false)]
    [switch]$Force

)


$Root = $PSScriptRoot

$Source = Join-Path $Root "src"



#
# Load template system
#

. (Join-Path $Source "Templates.ps1")



#
# Load engine
#

. (Join-Path $Source "Engine/Models.ps1")
. (Join-Path $Source "Engine/MarkdownParser.ps1")
. (Join-Path $Source "Engine/TreeParser.ps1")
. (Join-Path $Source "Engine/Validator.ps1")
. (Join-Path $Source "Engine/Renderer.ps1")
. (Join-Path $Source "Engine/Executor.ps1")



#
# Resolve target
#

$Target = [System.IO.Path]::GetFullPath($Target)



#
# Load markdown definition
#

$filePath = Join-Path $Root "files/$File.md"



if (!(Test-Path -LiteralPath $filePath)) {

    Write-Host "❌ File definition not found: $filePath" -ForegroundColor Red
    exit 1

}



Write-Host ""
Write-Host "🚀 FileForge v2" -ForegroundColor Cyan
Write-Host "==============="

Write-Host "Definition:"
Write-Host " $filePath"

Write-Host "Target:"
Write-Host " $Target"



#
# Parse
#

$lines = @(Get-FileForgeBlock `
    -FilePath $filePath)

# Write-Host "Loaded scaffold lines: $($lines.Count)" -ForegroundColor DarkGray



$tree = Convert-ToForgeTree `
    -Lines $lines `
    -Target $Target

$validation = Test-ForgeTree -Nodes $tree
$duplicateCount = $validation.DuplicateCount


if (!$validation.Valid) {

    Write-Host ""
    Write-Host "❌ Validation failed" -ForegroundColor Red


    foreach ($error in $validation.Errors) {

        Write-Host "   $error" -ForegroundColor DarkRed

    }


    exit 1
}



foreach ($warning in $validation.Warnings) {

    Write-Host "⚠️ $warning" -ForegroundColor Yellow

}

Write-Host ""



# Calculate planned structure statistics (works for both modes)
$planStats = Get-ForgePlanStats -Nodes $tree


if ($Apply) {

    Write-Host "MODE: APPLY" -ForegroundColor Green

    $stats = Invoke-ForgeCreation `
        -Nodes $tree `
        -Force:$Force

}
else {

    Write-Host "MODE: DRY RUN" -ForegroundColor Yellow

}


Write-Host ""

Show-ForgeTree `
    -Nodes $tree `
    -Apply:$Apply


Write-Host ""

Write-Host "=========================" -ForegroundColor Cyan
Write-Host " FileForge Summary" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan

Write-Host ""


if ($Apply) {

    Write-Host "Mode: APPLY" -ForegroundColor Green

    Write-Host ""

    Write-Host "Folders created: $($stats.Folders)" -ForegroundColor Green
    Write-Host "Files created:   $($stats.Created)" -ForegroundColor Green
    Write-Host "Files updated:   $($stats.Updated)" -ForegroundColor Yellow
    Write-Host "Files skipped:   $($stats.Skipped)" -ForegroundColor DarkYellow

}
else {

    Write-Host "Mode: DRY RUN" -ForegroundColor Yellow

    Write-Host ""

    Write-Host "Folders planned: $($planStats.Folders)" -ForegroundColor Green
    Write-Host "Files planned:   $($planStats.Files)" -ForegroundColor Green

}

Write-Host "Duplicates found:  $duplicateCount" -ForegroundColor Red

Write-Host ""

Write-Host "=========================" -ForegroundColor Cyan