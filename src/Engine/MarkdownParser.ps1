function Get-FileForgeBlock {

    param(
        [Parameter(Mandatory)]
        [string]$FilePath
    )


    if (!(Test-Path -LiteralPath $FilePath)) {
        throw "Definition file not found: $FilePath"
    }


    $lines = Get-Content -LiteralPath $FilePath


    $inside = $false
    $result = [System.Collections.Generic.List[string]]::new()


    foreach ($line in $lines) {

        $trimmed = $line.Trim()


        if ($trimmed -eq '```fileforge') {

            $inside = $true
            continue

        }


        if ($inside -and $trimmed -eq '```') {

            break

        }


        if ($inside) {

            $result.Add($line)

        }

    }


    if ($result.Count -eq 0) {

        throw "No fileforge block found in: $FilePath"

    }


    return $result.ToArray()
}