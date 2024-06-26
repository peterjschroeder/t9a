Using module ./z_Scripts/T9A-Books.psm1
Using module ./z_Scripts/T9A-InitRelease.psm1


param (    
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateSet("Rulebook", "AC",
        "BH", "DL", "DE", "DH", "EoS", "HE", "ID", "KoE", "OK", "OnG", "SA", "SE", "UD", "VC", "VS", "WDG",
        "ASK", "CUL", "HG", "MAK", "GIA",
        "HBBlank",
        "All", "CoreRules", "Supplements","HomeBrew")]
    [string[]] $BookIds,
    [ValidateSet("Rulebook", "AC",
        "BH", "DL", "DE", "DH", "EoS", "HE", "ID", "KoE", "OK", "OnG", "SA", "SE", "UD", "VC", "VS", "WDG",
        "ASK", "CUL", "HG", "MAK", "GIA",
        "HBBlank")]
    [string[]] $Except,
    [int]$EditionVersion = 2,
    [Parameter(Mandatory = $true)]
    [int]$BalanceVersion,
    [ValidateSet("EN", "ES", "FR", "DE", "IT")]
    [string]$Language = "EN",
    [int]$AlphaVersion,
    [int]$BetaVersion,
    [int]$HotFixVersion,
    [string]$ReleaseDate,
    [string]$SpecialVersion,
    [Switch]$SkipTexFileRename
)
Begin {
    Import-Module $(Join-Path $PSScriptRoot -ChildPath ./z_Scripts/T9A-Books.psm1) -Force
    Import-Module $(Join-Path $PSScriptRoot -ChildPath ./z_Scripts/T9A-InitRelease.psm1) -Force
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
        
    $books | Initialize-Release -editionversion $EditionVersion -BalanceVersion $BalanceVersion -Language $Language -AlphaVersion $AlphaVersion -BetaVersion $BetaVersion -HotFixVersion $HotFixVersion -ReleaseDate $ReleaseDate -SpecialVersion $SpecialVersion -SkipTexFileRename:$SkipTexFileRename
}

End {}