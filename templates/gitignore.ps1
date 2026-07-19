param([string]$Path, [string]$FileName)
return @"
# Logs
*.log
npm-debug.log*

# Dependency directories
node_modules/
__pycache__/

# IDEs and editors
.idea/
.vscode/
*.suo
*.ntvs*
*.njsproj
*.sln
"@