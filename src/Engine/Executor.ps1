# Executor.ps1: Creates/updates files

# function Invoke-ForgeCreation {

#     param(
#         [Parameter(Mandatory)]
#         [ForgeNode[]]$Nodes,

#         [Parameter(Mandatory=$false)]
#         [switch]$Force
#     )


#     foreach ($node in $Nodes) {


#         if ($node.IsFolder) {

#             if (!(Test-Path -LiteralPath $node.FullPath)) {

#                 New-Item `
#                     -ItemType Directory `
#                     -Path $node.FullPath `
#                     -Force |
#                     Out-Null
#             }

#         }
#         else {


#             $parent = Split-Path `
#                 -Path $node.FullPath `
#                 -Parent


#             if (!(Test-Path -LiteralPath $parent)) {

#                 New-Item `
#                     -ItemType Directory `
#                     -Path $parent `
#                     -Force |
#                     Out-Null
#             }

#             if (!(Test-Path -LiteralPath $node.FullPath)) {

#                 $content = Get-Template $node.RelativePath

#                 Set-Content `
#                     -LiteralPath $node.FullPath `
#                     -Value $content `
#                     -Encoding UTF8

#                 Write-Host "✏️ Created: $($node.RelativePath)" `
#                     -ForegroundColor Green

#             }
#             elseif ($Force) {

#                 $content = Get-Template $node.RelativePath

#                 Set-Content `
#                     -LiteralPath $node.FullPath `
#                     -Value $content `
#                     -Encoding UTF8

#                 Write-Host "♻️ Updated: $($node.RelativePath)" `
#                     -ForegroundColor Yellow

#             }
#             else {

#                 Write-Host "➡️ Skipped: $($node.RelativePath)" `
#                     -ForegroundColor DarkYellow

#             }

#         }

#     }
# }


# Executor.ps1: Creates/updates files

function Invoke-ForgeCreation {

    param(
        [Parameter(Mandatory)]
        [ForgeNode[]]$Nodes,

        [Parameter(Mandatory=$false)]
        [switch]$Force
    )


    $stats = @{
        Folders = 0
        Created = 0
        Updated = 0
        Skipped = 0
    }


    foreach ($node in $Nodes) {


        if ($node.IsFolder) {

            if (!(Test-Path -LiteralPath $node.FullPath)) {

                New-Item `
                    -ItemType Directory `
                    -Path $node.FullPath `
                    -Force |
                    Out-Null

                $stats.Folders++
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

                Write-Host "✏️ Created: $($node.RelativePath)" `
                    -ForegroundColor Green

                $stats.Created++

            }
            elseif ($Force) {

                $content = Get-Template $node.RelativePath

                Set-Content `
                    -LiteralPath $node.FullPath `
                    -Value $content `
                    -Encoding UTF8

                Write-Host "♻️ Updated: $($node.RelativePath)" `
                    -ForegroundColor Yellow

                $stats.Updated++

            }
            else {

                Write-Host "➡️ Skipped: $($node.RelativePath)" `
                    -ForegroundColor DarkYellow

                $stats.Skipped++

            }

        }

    }


    return $stats
}