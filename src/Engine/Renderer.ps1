function Show-ForgeTree {

    param(
        [Parameter(Mandatory)]
        [ForgeNode[]]$Nodes,

        [switch]$Apply
    )


    foreach ($node in $Nodes) {

        $indent = "    " * $node.Depth


        if ($node.IsFolder) {

            if ($Apply) {
                Write-Host "$indent📁 Created: $($node.Name)" -ForegroundColor Green
            }
            else {
                Write-Host "$indent📁 $($node.Name)" -ForegroundColor Green
            }

        }
        else {

            if ($Apply) {
                Write-Host "$indent✏️ Created: $($node.Name)" -ForegroundColor Cyan
            }
            else {
                Write-Host "$indent✏️ $($node.Name)" -ForegroundColor Cyan
            }

        }

    }
}