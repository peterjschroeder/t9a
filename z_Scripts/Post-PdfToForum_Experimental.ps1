Using module ./T9A-Books.psm1

#Experimental

param (    
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateSet("Test",
        "Rulebook", "AC",
        "BH", "DL", "DE", "DH", "EoS", "HE", "ID", "KoE", "OK", "OnG", "SA", "SE", "UD", "VC", "VS", "WDG",
        "ASK", "CUL", "HG", "MAK", "GIA",
        "All", "CoreRules", "Supplements")]
    [string[]] $BookIds,    
    [ValidateSet("Rulebook", "AC",
        "BH", "DL", "DE", "DH", "EoS", "HE", "ID", "KoE", "OK", "OnG", "SA", "SE", "UD", "VC", "VS", "WDG",
        "ASK", "CUL", "HG", "MAK", "GIA")]
    [string[]] $Except,
    [Parameter(Mandatory = $true)]    
    [String] $Username,
    [Parameter(Mandatory = $true)]    
    [SecureString] $Password
)
Begin {
    Import-Module $(Join-Path $PSScriptRoot -ChildPath T9A-Books.psm1) -Force

    $creds = New-Object System.Management.Automation.PSCredential($Username, $Password)
    $cleartextPassword = $creds.GetNetworkCredential().Password
}

Process { 
    if ($Except) {
        Get-Books -BookIds $BookIds -Except $Except | ForEach-Object { Write-Output $_ }
    }
    else {
        Get-Books -BookIds $BookIds | ForEach-Object { Write-Output $_.GetTexFile().FullName }
    }
    
    $filebaseId=1230
    $errorReportId=65074

    k6 run z_Scripts/PostFileInErrorReport.js -e username=$Username -e password=$cleartextPassword -e filebaseId=$filebaseId -e errorReportId=$errorReportId --no-usage-report
}

End {}

