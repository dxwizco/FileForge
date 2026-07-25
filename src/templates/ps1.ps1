param([string]$Path, [string]$FileName)
return @"
[CmdletBinding()]
param()

Write-Host "Running ${FileName}..."
"@