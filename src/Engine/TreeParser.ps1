# TreeParser.ps1: Creates ForgeNode[]

function Convert-ToForgeTree {

    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        $Lines,

        [Parameter(Mandatory)]
        [string]$Target
    )


    $Lines = @($Lines)


    $nodes = @()


    $stack = @(
        @{
            Depth = -1
            Path = $Target
        }
    )


    foreach ($line in $Lines) {


        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }


        #
        # Remove comments
        #
        $cleanLine = ($line -replace '#.*$', '').Trim()


        if ([string]::IsNullOrWhiteSpace($cleanLine)) {
            continue
        }


        #
        # Calculate depth
        #
        $prefix = $line.Substring(
            0,
            $line.Length - $line.TrimStart().Length
        )


        $spaces = $prefix.Replace("`t","    ").Length

        $depth = [math]::Floor($spaces / 4)



        #
        # Handle paths like:
        #
        # public/index.html
        # components/Button.tsx
        #
        $parts = $cleanLine -split '[\\/]'


        #
        # Remove empty first item caused by:
        #
        # /(group)
        #
        if ($parts[0] -eq "") {
            $parts = $parts[1..($parts.Length-1)]
        }



        #
        # Find correct parent
        #
        while ($stack[-1].Depth -ge $depth) {

            if ($stack.Count -gt 1) {
                $stack = $stack[0..($stack.Count-2)]
            }
            else {
                break
            }
        }



        $parent = $stack[-1].Path



        for ($i = 0; $i -lt $parts.Length; $i++) {


            $part = $parts[$i]


            if ([string]::IsNullOrWhiteSpace($part)) {
                continue
            }



            $isLast = ($i -eq ($parts.Length - 1))


            #
            # Explicit folder marker
            #
            $isFolder = (!$isLast) -or
                        $cleanLine.EndsWith("/") -or
                        $cleanLine.EndsWith("\")



            $fullPath = Join-Path $parent $part


            $relative = $fullPath.Substring(
                $Target.Length
            ).TrimStart('\','/')



            $node = [ForgeNode]::new(
                $part,
                $relative,
                $fullPath,
                $isFolder,
                $depth + $i,
                "none"
            )


            $nodes += $node



            if ($isFolder) {

                $parent = $fullPath


                $stack += @{
                    Depth = $depth + $i
                    Path = $fullPath
                }

            }

        }

    }


    return $nodes
}