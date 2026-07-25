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


        $children = @(
            $Nodes |
                Where-Object {
                    $_.Depth -eq ($Node.Depth + 1) -and
                    $_.RelativePath.StartsWith(
                        $Node.RelativePath + "/"
                    )
                }
        )


        for ($i = 0; $i -lt $children.Count; $i++) {

            $childPrefix = $Prefix

            if (-not $IsRoot) {

                if ($IsLast) {
                    $childPrefix += "    "
                }
                else {
                    $childPrefix += "│   "
                }

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
            }
    )


    for ($i = 0; $i -lt $roots.Count; $i++) {

        Show-Node `
            -Node $roots[$i] `
            -IsRoot $true

    }

}


# ==========================
# Working tree wihtout lines
# ==========================

# function Show-ForgeTree {
#     param(
#         [Parameter(Mandatory)]
#         $Nodes,

#         [Parameter(Mandatory=$false)]
#         [switch]$Apply
#     )

#     function Show-Node {
#         param(
#             $Node,
#             $Level
#         )

#         $indent = "    " * $Level

#         if ($Node.IsFolder) {
#             Write-Host "$indent📁 $($Node.Name)" `
#                 -ForegroundColor Green

#         }
#         else {
#             Write-Host "$indent✏️ $($Node.Name)" `
#                 -ForegroundColor Cyan

#         }

#         $prefix = $Node.RelativePath.TrimEnd('/','\')

#         $children = @(
#             $Nodes |
#                 Where-Object {
#                     $_.Depth -eq ($Node.Depth + 1) -and
#                     $_.RelativePath.StartsWith(
#                         "$prefix/"
#                     )
#                 }
#         )

#         foreach ($child in $children) {
#             Show-Node `
#                 -Node $child `
#                 -Level ($Level + 1)
#         }
#     }

#     $roots = @(
#         $Nodes |
#             Where-Object {
#                 $_.Depth -eq 0
#             }
#     )

#     foreach ($root in $roots) {

#         Show-Node `
#             -Node $root `
#             -Level 0

#     }

# }




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