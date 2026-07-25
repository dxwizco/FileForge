param(

    [string]$Target = ".",

    [string]$File = "test",

    [switch]$Apply

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



if ($Apply) {

    Write-Host "MODE: APPLY" -ForegroundColor Green

    Invoke-ForgeCreation `
        -Nodes $tree

}
else {

    Write-Host "MODE: DRY RUN" -ForegroundColor Yellow

}



Write-Host ""

Show-ForgeTree `
    -Nodes $tree `
    -Apply:$Apply