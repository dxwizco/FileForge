# Renderer.ps1: Displays preview

function Show-ForgeTree {

    param(
        [Parameter(Mandatory)]
        $Nodes,

        [Parameter(Mandatory=$false)]
        [switch]$Apply
    )


    foreach ($node in $Nodes) {

        $indent = ""

        if ($node.Depth -gt 0) {
            $indent = "    " * $node.Depth
        }


        if ($node.IsFolder) {

            Write-Host (
                "$indent📁 $($node.Name)"
            ) -ForegroundColor Green

        }
        else {

            Write-Host (
                "$indent✏️ $($node.Name)"
            ) -ForegroundColor Cyan

        }

    }

}


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