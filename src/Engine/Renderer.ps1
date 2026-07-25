# Renderer.ps1: Displays preview


# ==========================
# Working tree with lines but not sorted
# ==========================

function Show-ForgeTree {

    param(
        [Parameter(Mandatory)]
        $Nodes,

        [Parameter(Mandatory=$false)]
        [switch]$Apply
    )


    function Show-Node {

        param(
            $Node,
            $Prefix = "",
            $IsLast = $true,
            $IsRoot = $false
        )


        if ($IsRoot) {

            $line = ""

        }
        elseif ($IsLast) {

            $line = "$Prefix└── "

        }
        else {

            $line = "$Prefix├── "

        }


        if ($Node.IsFolder) {

            Write-Host "$line📁 $($Node.Name)" `
                -ForegroundColor Green

        }
        else {

            Write-Host "$line✏️ $($Node.Name)" `
                -ForegroundColor Cyan

        }


$parentPath = ($Node.RelativePath -replace '\\','/').TrimEnd('/')


$children = @(
    $Nodes |
        Where-Object {

            $_.Depth -eq ($Node.Depth + 1) -and
            (
                ($_.RelativePath -replace '\\','/')
            ).StartsWith(
                "$parentPath/"
            )

        } |
        Sort-Object `
            @{Expression={ if ($_.IsFolder) {0} else {1} }},
            @{Expression={ $_.Name.ToLowerInvariant() }}
)


        for ($i = 0; $i -lt $children.Count; $i++) {

            $childPrefix = $Prefix

            if ($IsLast) {
                $childPrefix += "    "
            }
            else {
                $childPrefix += "│   "
            }


            Show-Node `
                -Node $children[$i] `
                -Prefix $childPrefix `
                -IsLast ($i -eq ($children.Count - 1))

        }

    }


$roots = @(
    $Nodes |
        Where-Object {
            $_.Depth -eq 0
        } |
        Sort-Object `
            @{Expression={ if ($_.IsFolder) {0} else {1} }},
            @{Expression={ $_.Name.ToLowerInvariant() }}
)


    for ($i = 0; $i -lt $roots.Count; $i++) {

        Show-Node `
            -Node $roots[$i] `
            -IsRoot $true

    }

}




# =============
# Function two:
# =============

function Get-ForgePlanStats {

    param(
        [Parameter(Mandatory)]
        [ForgeNode[]]$Nodes
    )


    $stats = @{
        Folders = 0
        Files   = 0
    }


    foreach ($node in $Nodes) {

        if ($node.IsFolder) {
            $stats.Folders++
        }
        else {
            $stats.Files++
        }

    }


    return $stats
}