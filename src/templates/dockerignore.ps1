param([string]$Path, [string]$FileName)
return @"
**/.git
**/node_modules
**/__pycache__
*Dockerfile*
*docker-compose*
.env
"@