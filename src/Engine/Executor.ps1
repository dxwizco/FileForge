function Invoke-ForgeCreation {

    param(
        [Parameter(Mandatory)]
        [ForgeNode[]]$Nodes
    )


    foreach ($node in $Nodes) {


        if ($node.IsFolder) {

            if (!(Test-Path -LiteralPath $node.FullPath)) {

                New-Item `
                    -ItemType Directory `
                    -Path $node.FullPath `
                    -Force |
                    Out-Null
            }

        }
        else {


            $parent = Split-Path `
                -Path $node.FullPath `
                -Parent


            if (!(Test-Path -LiteralPath $parent)) {

                New-Item `
                    -ItemType Directory `
                    -Path $parent `
                    -Force |
                    Out-Null
            }


            if (!(Test-Path -LiteralPath $node.FullPath)) {

                $content = Get-Template $node.RelativePath


                Set-Content `
                    -LiteralPath $node.FullPath `
                    -Value $content `
                    -Encoding UTF8
            }

        }

    }
}