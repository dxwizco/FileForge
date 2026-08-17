param(

    [Parameter(Mandatory=$false)]
    [string]$Target = ".",

    [Parameter(Mandatory=$false)]
    [string]$File,

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

function Resolve-ForgeDefinition {

    param(
        [Parameter(Mandatory=$false)]
        [AllowEmptyString()]
        [string]$File,

        [Parameter(Mandatory)]
        [string]$FileForgeRoot
    )

    # ============================================================
    # No -File supplied
    # ============================================================
    #
    # Only in this situation do we use the built-in FileForge
    # fallback definition.
    #
    # Default: <FileForge>/files/test.md
    
    if ([string]::IsNullOrWhiteSpace($File)) {

        $defaultDefinition = Join-Path `
            $FileForgeRoot `
            "files/test.md"


        if (!(Test-Path -LiteralPath $defaultDefinition -PathType Leaf)) {

            throw @"
Default FileForge definition was not found.

Expected:
$defaultDefinition

Please provide a definition using:
-File <path-or-name>
"@

        }

        return [System.IO.Path]::GetFullPath(
            (Resolve-Path -LiteralPath $defaultDefinition).Path
        )

    }


    # ============================================================
    # -File was explicitly supplied
    # ============================================================
    #
    # From this point onward, NEVER fall back to: <FileForge>/files/<name>.md
    #
    # The user explicitly selected a definition, so we must use
    # exactly what they specified or report an error.
    #

    $originalFile = $File

    #
    # Add .md when the supplied name/path has no extension.
    #
    $extension = [System.IO.Path]::GetExtension($File)

    if ([string]::IsNullOrWhiteSpace($extension)) {

        $File = "$File.md"

    }


    #
    # ============================================================
    # Absolute path
    # ============================================================
    #
    if ([System.IO.Path]::IsPathRooted($File)) {

        $resolvedPath = [System.IO.Path]::GetFullPath($File)


        if (!(Test-Path -LiteralPath $resolvedPath -PathType Leaf)) {

            throw @"
Specified definition file was not found.

Specified:
$originalFile

Resolved path:
$resolvedPath

Please verify that the file exists and that the path is correct.
"@

        }

        return [System.IO.Path]::GetFullPath(
            (Resolve-Path -LiteralPath $resolvedPath).Path
        )

    }

#
# ============================================================
# Relative path OR definition name
# ============================================================
#

$currentDirectory = (Get-Location).Path


#
# Explicit relative path
#
# Examples:
#
#   .\definitions\backend.md
#   ./definitions/backend.md
#   ..\SharedDefinitions\backend.md
#   ../SharedDefinitions/backend.md
#
# These are always resolved relative to the current directory.
#

$isExplicitRelativePath =
    $File.StartsWith(".\") -or
    $File.StartsWith("./") -or
    $File.StartsWith("..\") -or
    $File.StartsWith("../") -or
    $File.Contains("\") -or
    $File.Contains("/")


if ($isExplicitRelativePath) {

    $resolvedPath = [System.IO.Path]::GetFullPath(
        (Join-Path $currentDirectory $File)
    )


    if (!(Test-Path -LiteralPath $resolvedPath -PathType Leaf)) {

        throw @"
Specified definition file was not found.

Specified:
$originalFile

Resolved path:
$resolvedPath

Current directory:
$currentDirectory

Please verify that the file exists and that the path is correct.
"@

    }

    return [System.IO.Path]::GetFullPath(
        (Resolve-Path -LiteralPath $resolvedPath).Path
    )

}


#
# ============================================================
# Definition name
# ============================================================
#
# Examples:
#   -File test
#   -File test.md
#
# Definition names use FileForge's built-in files directory.
#
# IMPORTANT:
# If the definition does not exist there, we report an error.
# We do NOT silently choose another definition.
#

$definitionName = $File


if ([string]::IsNullOrWhiteSpace(
    [System.IO.Path]::GetExtension($definitionName)
)) {

    $definitionName = "$definitionName.md"

}


$definitionPath = Join-Path `
    $FileForgeRoot `
    "files/$definitionName"


if (!(Test-Path -LiteralPath $definitionPath -PathType Leaf)) {

    throw @"
FileForge definition was not found.

Specified definition:
$originalFile

Expected location:
$definitionPath

Please verify that the definition name is correct or provide an explicit path.
"@

}


return [System.IO.Path]::GetFullPath(
    (Resolve-Path -LiteralPath $definitionPath).Path
)

}


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
    Write-Host "  -File          Definition name or path"
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

    
    Write-Host "External definition:"
    Write-Host ""

    Write-Host "  Linux / macOS / WSL:"
    Write-Host '    pwsh "/path/to/FileForge/FileForge.ps1" -File "/path/to/definitions/backend.md" -Target "/path/to/project"'

    Write-Host ""
    Write-Host "  Windows PowerShell:"
    Write-Host '    & "D:\Tools\FileForge\FileForge.ps1" -File "D:\ProjectDefinitions\backend.md" -Target "D:\Projects\ProjectX"'

    Write-Host ""

    Write-Host "Definition relative to current directory:"
    Write-Host ""

    Write-Host "  Linux / macOS / WSL:"
    Write-Host '    pwsh "/path/to/FileForge/FileForge.ps1" -File "./definitions/backend.md" -Target "."'

    Write-Host ""
    Write-Host "  Windows PowerShell:"
    Write-Host '    & "D:\Tools\FileForge\FileForge.ps1" -File ".\definitions\backend.md" -Target "."'

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

try {

    $filePath = Resolve-ForgeDefinition `
        -File $File `
        -FileForgeRoot $Root

}
catch {

    Write-Host ""
    Write-Host "❌ Definition error" -ForegroundColor Red
    Write-Host ""
    Write-Host $_.Exception.Message -ForegroundColor Yellow
    Write-Host ""

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