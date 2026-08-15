# Validator.ps1: Checks duplicate paths

function Test-ForgeTree {

    param(
        [Parameter(Mandatory)]
        $Nodes
    )


    $errors = New-Object System.Collections.Generic.List[string]
    $warnings = New-Object System.Collections.Generic.List[string]


    #
    # Duplicate physical paths
    #
    $duplicates = @(
        $Nodes |
            Group-Object -Property FullPath |
            Where-Object { $_.Count -gt 1 }
    )


    foreach ($item in $duplicates) {

        $warnings.Add(
            "Duplicate path detected: $($item.Name)"
        )

    }



    #
    # Missing names
    #
    foreach ($node in $Nodes) {

        if ([string]::IsNullOrWhiteSpace($node.Name)) {

            $errors.Add(
                "Empty node name detected"
            )

        }

    }



    #
    # Invalid target paths
    #
    foreach ($node in $Nodes) {
        
        if ($node.Name -match '[<>:"|?*]') {
            $errors.Add(
                "Invalid filesystem characters: $($node.FullPath)"
            )

        }

    }



    return @{
    Errors          = $errors.ToArray()
    Warnings        = $warnings.ToArray()
    DuplicateCount  = $duplicates.Count
    Valid           = ($errors.Count -eq 0)
}
}