class ForgeNode {

    [string]$Name
    [string]$RelativePath
    [string]$FullPath
    [bool]$IsFolder
    [int]$Depth

    ForgeNode(
        [string]$name,
        [string]$relativePath,
        [string]$fullPath,
        [bool]$isFolder,
        [int]$depth
    ) {
        $this.Name = $name
        $this.RelativePath = $relativePath
        $this.FullPath = $fullPath
        $this.IsFolder = $isFolder
        $this.Depth = $depth
    }
}