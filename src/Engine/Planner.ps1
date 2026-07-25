# Planner.ps1: 

function Get-ForgeAction {

    param(
        [Parameter(Mandatory)]
        [ForgeNode]$Node,

        [switch]$Force
    )


    if ($Node.IsFolder) {
        return "folder"
    }


    if (!(Test-Path -LiteralPath $Node.FullPath)) {
        return "create"
    }


    if ($Force) {
        return "update"
    }


    return "skip"
}