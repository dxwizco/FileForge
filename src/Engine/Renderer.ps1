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