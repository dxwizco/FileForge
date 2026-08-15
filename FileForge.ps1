param(

    [Parameter(Mandatory=$false)]
    [string]$Target = ".",

    [Parameter(Mandatory=$false)]
    [string]$File = "test",

    [Parameter(Mandatory=$false)]
    [switch]$Run,

    [Parameter(Mandatory=$false)]
    [switch]$Force,

    [Parameter(Mandatory=$false)]
    [switch]$ShowActions,

    [Parameter(Mandatory=$false)]
    [switch]$Help,

    [Parameter(Mandatory=$false)]
    [switch]$Version,

    [Parameter(Mandatory=$false)]
    [switch]$List

)


$Root = $PSScriptRoot
$FileForgeVersion = "2.0.0"

$Source = Join-Path $Root "src"

if ($Version) {

    Write-Host ""
    Write-Host "FileForge v$FileForgeVersion" -ForegroundColor Cyan
    Write-Host ""
    exit 0

}

if ($List) {

    Write-Host ""
    Write-Host "Available FileForge Definitions" -ForegroundColor Cyan
    Write-Host "==============================="

    $definitionPath = Join-Path $Root "files"

    if (!(Test-Path $definitionPath)) {

        Write-Host ""
        Write-Host "No definition folder found." -ForegroundColor Yellow
        exit 0

    }

    $definitions = Get-ChildItem `
        -Path $definitionPath |
        Where-Object {
            $_.Extension -ieq ".md"
        } |
        Sort-Object Name

    Write-Host ""

    foreach ($definition in $definitions) {
        Write-Host "  $($definition.BaseName)"
    }

    Write-Host ""

    exit 0

}

if ($Help) {

    Write-Host ""

    Write-Host "FileForge v$FileForgeVersion" -ForegroundColor Cyan
    Write-Host "============================"

    Write-Host ""

    Write-Host "Usage:"

    Write-Host ""
    Write-Host "  Linux / macOS / WSL:"
    Write-Host "    pwsh ./FileForge.ps1 -File <name> -Target <path> [options]"

    Write-Host ""
    Write-Host "  Windows PowerShell:"
    Write-Host "    .\FileForge.ps1 -File <name> -Target <path> [options]"

    Write-Host ""

    Write-Host "Modes:"
    Write-Host "  (default)      PREVIEW only"
    Write-Host "  -Run           EXECUTION mode"

    Write-Host ""

    Write-Host "Options:"
    Write-Host "  -ShowActions   Show detailed create/update/skip actions"
    Write-Host "  -Force         Replace existing files during execution"
    Write-Host "  -List          List available FileForge definition files"
    Write-Host "  -Help          Show this help"
    Write-Host "  -Version       Show FileForge version"

    Write-Host ""

    Write-Host "Examples:"

    Write-Host ""

    Write-Host "List available definitions:"

    Write-Host "  Linux / macOS / WSL:"
    Write-Host "    pwsh ./FileForge.ps1 -List"

    Write-Host "  Windows PowerShell:"
    Write-Host "    .\FileForge.ps1 -List"

    Write-Host ""

    Write-Host "Preview:"

    Write-Host "  Linux / macOS / WSL:"
    Write-Host "    pwsh ./FileForge.ps1 -File test -Target ./App"

    Write-Host "  Windows PowerShell:"
    Write-Host "    .\FileForge.ps1 -File test -Target `".\App`""

    Write-Host ""

    Write-Host "Preview with actions:"

    Write-Host "  Linux / macOS / WSL:"
    Write-Host "    pwsh ./FileForge.ps1 -File test -Target ./App -ShowActions"

    Write-Host "  Windows PowerShell:"
    Write-Host "    .\FileForge.ps1 -File test -Target `".\App`" -ShowActions"

    Write-Host ""

    Write-Host "Execute:"

    Write-Host "  Linux / macOS / WSL:"
    Write-Host "    pwsh ./FileForge.ps1 -File test -Target ./App -Run"

    Write-Host "  Windows PowerShell:"
    Write-Host "    .\FileForge.ps1 -File test -Target `".\App`" -Run"

    Write-Host ""

    Write-Host "Execute with actions:"

    Write-Host "  Linux / macOS / WSL:"
    Write-Host "    pwsh ./FileForge.ps1 -File test -Target ./App -Run -ShowActions"

    Write-Host "  Windows PowerShell:"
    Write-Host "    .\FileForge.ps1 -File test -Target `".\App`" -Run -ShowActions"

    Write-Host ""

    Write-Host "Execute with force:"

    Write-Host "  Linux / macOS / WSL:"
    Write-Host "    pwsh ./FileForge.ps1 -File test -Target ./App -Run -Force"

    Write-Host "  Windows PowerShell:"
    Write-Host "    .\FileForge.ps1 -File test -Target `".\App`" -Run -Force"

    Write-Host ""

    Write-Host "Execute with force and actions:"

    Write-Host "  Linux / macOS / WSL:"
    Write-Host "    pwsh ./FileForge.ps1 -File test -Target ./App -Run -Force -ShowActions"

    Write-Host "  Windows PowerShell:"
    Write-Host "    .\FileForge.ps1 -File test -Target `".\App`" -Run -Force -ShowActions"

    Write-Host ""

    exit 0

}

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
. (Join-Path $Source "Engine/Planner.ps1")
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

foreach ($node in $tree) {

    $node.Action = Get-ForgeAction `
        -Node $node `
        -Force:$Force

}

foreach ($warning in $validation.Warnings) {

    Write-Host "⚠️ $warning" -ForegroundColor Yellow

}

Write-Host ""



# Calculate planned structure statistics (works for both modes)
$planStats = Get-ForgePlanStats -Nodes $tree


if ($Run) {

    Write-Host "Mode: EXECUTION" -ForegroundColor Green

    $stats = Invoke-ForgeCreation `
        -Nodes $tree `
        -Force:$Force

}
else {

    Write-Host "MODE: PREVIEW" -ForegroundColor Yellow

}


Write-Host ""

Show-ForgeTree `
    -Nodes $tree
    # -Apply:$Run

if ($ShowActions) {

    Write-Host ""

    Show-ForgeActions `
        -Nodes $tree `
        -Execution:$Run

}


Write-Host ""

Write-Host "=========================" -ForegroundColor Cyan
Write-Host " FileForge Summary" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan

Write-Host ""


if ($Run) {

    Write-Host "MODE: EXECUTION" -ForegroundColor Green

    Write-Host ""

    Write-Host "Folders created: $($stats.Folders)" -ForegroundColor Green
    Write-Host "Files created:   $($stats.Created)" -ForegroundColor Green
    Write-Host "Files updated:   $($stats.Updated)" -ForegroundColor Yellow
    Write-Host "Files skipped:   $($stats.Skipped)" -ForegroundColor DarkYellow

}
else {

    Write-Host "Mode: PREVIEW" -ForegroundColor Yellow

    Write-Host ""

    Write-Host "Folders planned: $($planStats.Folders)" -ForegroundColor Green
    Write-Host "Files planned:   $($planStats.Files)" -ForegroundColor Green

}

Write-Host "Duplicates found:  $duplicateCount" -ForegroundColor Red

Write-Host ""

Write-Host "=========================" -ForegroundColor Cyan