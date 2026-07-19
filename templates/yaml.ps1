param([string]$Path, [string]$FileName)
return @"
version: '3.8'
metadata:
  name: ${FileName}
"@