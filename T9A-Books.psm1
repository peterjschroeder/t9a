Class T9ABook {
    [string]$BookId    
    [int]$FilebaseId
    [int]$ErrorReportId
    [string]$TexDirName

    [System.IO.DirectoryInfo]GetTexDir() {
        return [System.IO.DirectoryInfo]$($(Join-Path $PSScriptRoot -ChildPath "../$($this.TexDirName)"))
    }
    [System.IO.FileInfo]GetTexFile() {
        $texDir = $this.GetTexDir().FullName
        if (-NOT(Test-Path($texDir))) {
            Write-Host "[Error]" -BackgroundColor DarkRed -ForegroundColor White -NoNewline
            Write-Host " " -NoNewline
            Write-Host "$texDir not found!" -ForegroundColor DarkRed -NoNewline
            Write-Host " not found!"
            return $null
        }
        return Get-ChildItem -Path $texDir -Filter *EN.tex #deduct tex file here to get updated filename (if new version has been set, thus filename has changed)
    }
}

Class T9ABooks {
    static [HashTable]$coreRules = @{}    
    static [HashTable]$supplements = @{}
    static [HashTable]$collections = @{}

    static T9ABooks() {
        [T9ABooks]::coreRules.Test = New-Object T9ABook -Property  @{
            BookId        = "Test"
            FilebaseId    = 1230
            ErrorReportId = 65074
            TexDirName    = "Test_Upload"
        }
        [T9ABooks]::coreRules.Rulebook = New-Object T9ABook -Property  @{
            BookId        = "Rulebook"
            FilebaseId    = 325
            ErrorReportId = 60202
            TexDirName    = "Rulebook"
        }        
        [T9ABooks]::coreRules.AC = New-Object T9ABook -Property  @{
            BookId        = "AC"
            FilebaseId    = 299
            ErrorReportId = 48069
            TexDirName    = "Arcane_Compendium"
        }        
        [T9ABooks]::coreRules.BH = New-Object T9ABook -Property  @{
            BookId        = "BH"
            FilebaseId    = 625
            ErrorReportId = 32495
            TexDirName    = "AB_Beast_Herds"
        }
        [T9ABooks]::coreRules.DL = New-Object T9ABook -Property  @{
            BookId        = "DL"
            FilebaseId    = 772
            ErrorReportId = 32542
            TexDirName    = "AB_Daemon_Legions"
        }
        [T9ABooks]::coreRules.DE = New-Object T9ABook -Property  @{
            BookId        = "DE"
            FilebaseId    = 1135
            ErrorReportId = 32471
            TexDirName    = "AB_Dread_Elves"
        }
        [T9ABooks]::coreRules.DH = New-Object T9ABook -Property  @{
            BookId        = "DH"
            FilebaseId    = 1033
            ErrorReportId = 32527
            TexDirName    = "AB_Dwarven_Holds"
        }
        [T9ABooks]::coreRules.EoS = New-Object T9ABook -Property  @{
            BookId        = "EoS"
            FilebaseId    = 892
            ErrorReportId = 32885
            TexDirName    = "AB_Empire_of_Sonnstahl"
        }
        [T9ABooks]::coreRules.HE = New-Object T9ABook -Property  @{
            BookId        = "HE"
            FilebaseId    = 658
            ErrorReportId = 33108
            TexDirName    = "AB_Highborn_Elves"
        }
        [T9ABooks]::coreRules.ID = New-Object T9ABook -Property  @{
            BookId        = "ID"
            FilebaseId    = 1003
            ErrorReportId = 32711
            TexDirName    = "AB_Infernal_Dwarves"
        }
        [T9ABooks]::coreRules.KoE = New-Object T9ABook -Property  @{
            BookId        = "KoE"
            FilebaseId    = 660
            ErrorReportId = 32608
            TexDirName    = "AB_Kingdom_of_Equitaine"
        }
        [T9ABooks]::coreRules.OK = New-Object T9ABook -Property  @{
            BookId        = "OK"
            FilebaseId    = 1134
            ErrorReportId = 32734
            TexDirName    = "AB_Ogre_Khans"
        }
        [T9ABooks]::coreRules.OnG = New-Object T9ABook -Property  @{
            BookId        = "OnG"
            FilebaseId    = 1186
            ErrorReportId = 32686
            TexDirName    = "AB_Orcs_and_Goblins"
        }
        [T9ABooks]::coreRules.SA = New-Object T9ABook -Property  @{
            BookId        = "SA"
            FilebaseId    = 900
            ErrorReportId = 32864
            TexDirName    = "AB_Saurian_Ancients"
        }
        [T9ABooks]::coreRules.SE = New-Object T9ABook -Property  @{
            BookId        = "SE"
            FilebaseId    = 621
            ErrorReportId = 32678
            TexDirName    = "AB_Sylvan_Elves"
        }
        [T9ABooks]::coreRules.UD = New-Object T9ABook -Property  @{
            BookId        = "UD"
            FilebaseId    = 1133
            ErrorReportId = 33110
            TexDirName    = "AB_Undying_Dynasties"
        }
        [T9ABooks]::coreRules.VC = New-Object T9ABook -Property  @{
            BookId        = "VC"
            FilebaseId    = 874
            ErrorReportId = 32715
            TexDirName    = "AB_Vampire_Covenant"
        }
        [T9ABooks]::coreRules.VS = New-Object T9ABook -Property  @{
            BookId        = "VS"
            FilebaseId    = 990
            ErrorReportId = 33109
            TexDirName    = "AB_Vermin_Swarm"
        }
        [T9ABooks]::coreRules.WDG = New-Object T9ABook -Property  @{
            BookId        = "WDG"
            FilebaseId    = 657
            ErrorReportId = 32975
            TexDirName    = "AB_Warriors_of_the_Dark_Gods"
        }

        [T9ABooks]::supplements = @{}
        [T9ABooks]::supplements.ASK = New-Object T9ABook -Property  @{
            BookId        = "ASK"
            FilebaseId    = 867
            ErrorReportId = 47424
            TexDirName    = "Suppl_AB_Asklanders"
        }
        [T9ABooks]::supplements.CU = New-Object T9ABook -Property  @{
            BookId        = "CU"
            FilebaseId    = 1137
            ErrorReportId = 52572
            TexDirName    = "Suppl_AB_Cultists"
        }
        [T9ABooks]::supplements.HG = New-Object T9ABook -Property  @{
            BookId        = "HOB"
            FilebaseId    = 1188
            ErrorReportId = 60580
            TexDirName    = "Suppl_AB_Hobgoblins"
        }
        [T9ABooks]::supplements.MAK = New-Object T9ABook -Property  @{
            BookId        = "MAK"
            FilebaseId    = 1136
            ErrorReportId = 45441
            TexDirName    = "Suppl_AB_Makhar"
        }
        [T9ABooks]::supplements.GIA = New-Object T9ABook -Property  @{
            BookId        = "Giants"
            FilebaseId    = 1036
            ErrorReportId = 0
            TexDirName    = "Suppl_Giants"
        }

        [T9ABooks]::collections = @{}        
        [T9ABooks]::collections.CoreRules = [T9ABooks]::coreRules
        [T9ABooks]::collections.Supplements = [T9ABooks]::supplements
        [T9ABooks]::collections.All = [T9ABooks]::coreRules + [T9ABooks]::supplements
    }
}

Function Get-Books {
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
        [string[]] $Except
    )
    Begin {        
    }

    Process {
        $BookIds = $BookIds | ForEach-Object { $_.ToUpperInvariant() }
        
        
        if ($BookIds.Contains("ALL")) {
            $parsedBookIds += [T9ABooks]::collections.All.Keys            
        }
        if ($BookIds.Contains("CORERULES")) {
            $parsedBookIds += [T9ABooks]::collections.CoreRules.Keys            
        }
        if ($BookIds.Contains("SUPPLEMENTS")) {
            $parsedBookIds += [T9ABooks]::collections.Supplements.Keys
        }
        
        $parsedBookIds += $BookIds | Where-Object { -NOT(($_ -EQ "ALL") -OR ($_ -EQ "CORERULES") -OR ($_ -EQ "SUPPLEMENTS")) }
        
        if ($Except) {            
            $Except = $Except | Sort-Object $_ -Unique | ForEach-Object { $_.ToUpperInvariant() }
            $parsedBookIds = $parsedBookIds | Where-Object {                
                -NOT($Except.Contains($_)) }
        }
    }

    End {
        return $parsedBookIds | Sort-Object $_ -Unique | ForEach-Object { [T9ABooks]::collections.All[$_] } | Sort-Object -Property TexDirName
    }
}
