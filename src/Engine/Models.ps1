# Models.ps1:

class ForgeNode {

    [string]$Name
    [string]$RelativePath
    [string]$FullPath
    [bool]$IsFolder
    [int]$Depth
    [string]$Action

    ForgeNode(
        [string]$name,
        [string]$relativePath,
        [string]$fullPath,
        [bool]$isFolder,
        [int]$depth,
        [string]$action
    ) {
        $this.Name = $name
        $this.RelativePath = $relativePath
        $this.FullPath = $fullPath
        $this.IsFolder = $isFolder
        $this.Depth = $depth
        $this.Action = $action
    }
}
