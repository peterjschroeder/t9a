Using module ./z_Scripts/T9A-Books.psm1
Using module ./z_Scripts/T9A-Compile.psm1

param (    
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateSet("Test",
        "Rulebook", "AC",
        "BH", "DL", "DE", "DH", "EoS", "HE", "ID", "KoE", "OK", "OnG", "SA", "SE", "UD", "VC", "VS", "WDG",
        "ASK", "CUL", "HG", "MAK", "GIA",
        "sBH", "sDL", "sDE", "sDH", "sEoS", "sHE", "sID", "sKoE", "sOK", "sOnG", "sSA", "sSE", "sUD", "sVC", "sVS", "sWDG",
        "All", "CoreRules", "Supplements", "Scrolls")]
    [string[]] $BookIds,
    [ValidateSet("Rulebook", "AC",
        "BH", "DL", "DE", "DH", "EoS", "HE", "ID", "KoE", "OK", "OnG", "SA", "SE", "UD", "VC", "VS", "WDG",
        "ASK", "CUL", "HG", "MAK", "GIA",
        "sBH", "sDL", "sDE", "sDH", "sEoS", "sHE", "sID", "sKoE", "sOK", "sOnG", "sSA", "sSE", "sUD", "sVC", "sVS", "sWDG")]
    [string[]] $Except,
    [switch] $Release
)
Begin {
    Import-Module $(Join-Path $PSScriptRoot -ChildPath ./z_Scripts/T9A-Books.psm1) -Force
    Import-Module $(Join-Path $PSScriptRoot -ChildPath ./z_Scripts/T9A-Compile.psm1) -Force
}

Process { 

    if ($Except) {
        $books = Get-Books -BookIds $BookIds -Except $Except
    }
    else {
        $books = Get-Books -BookIds $BookIds
    }
    if (-NOT($books)) {
        Write-Host "No boooks selected"
        exit 0
    }

    $hasErrors = Start-Compile -Books $books -Release:$Release    
}

End {
    if ($hasErrors) {
        exit 1
    }
    else { 
        exit 0
    }
}