param([string]$Path, [string]$FileName)
return @"
set -e
echo "Running ${FileName}..."
"@