Using module ./T9A-Books.psm1
Function Initialize-Release {
    param (    
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [T9ABook[]] $books,        
        [int]$EditionVersion = 2,
        [Parameter(Mandatory = $true)]
        [int]$BalanceVersion,        
        [ValidateSet("EN", "ES", "FR", "DE", "IT")]
        [string]$Language = "EN",
        [int]$AlphaVersion,
        [int]$BetaVersion,
        [int]$HotfixVersion,
        [string]$ReleaseDate,
        [string]$SpecialVersion,
        [Switch]$SkipTexFileRename
    )
    Begin {
        $Language = $Language.ToUpperInvariant()
    }

    Process {

        $books | Set-BookMetaData -EditionVersion $EditionVersion -BalanceVersion $BalanceVersion

        if ($AlphaVersion) { $books | Set-BookMetaData -AlphaVersion $AlphaVersion } else { $books | Hide-BookMetaData -AlphaVersion }
        if ($BetaVersion) { $books | Set-BookMetaData -BetaVersion $BetaVersion } else { $books | Hide-BookMetaData -BetaVersion }
        if ($HotfixVersion) { $books | Set-BookMetaData -HotfixVersion $HotfixVersion } else { $books | Hide-BookMetaData -HotfixVersion }
        if ($ReleaseDate) { $books | Set-BookMetaData -ReleaseDate $ReleaseDate } else { $books | Hide-BookMetaData -ReleaseDate }
        if ($SpecialVersion) { $books | Set-BookMetaData -SpecialVersion $SpecialVersion } else { $books | Hide-BookMetaData -SpecialVersion }        
        $books | ForEach-Object {
            
            $sourceTexPath = Get-ChildItem -Path $_.GetTexDir()  -Filter *EN.tex

            if (-NOT($SkipTexFileRename)) {
                $targetTexPath = "T9A-FB_$($EditionVersion)ed_$($_.BookId)_$($BalanceVersion)"
                if ($AlphaVersion) {
                    $targetTexPath += "_alpha$AlphaVersion"
                }
                if ($BetaVersion) {
                    $targetTexPath += "_beta$BetaVersion"
                }
                if ($HotfixVersion) {
                    $targetTexPath += "_hotfix$HotfixVersion"
                }

                $targetTexPath += "_$Language.tex"
                $targetTexPath = Join-Path $_.GetTexDir() -ChildPath $targetTexPath

    
                if ($sourceTexPath.FullName.ToUpperInvariant() -ne $targetTexPath.ToUpperInvariant()) {
                    
                    Move-Item  $sourceTexPath -Destination $targetTexPath -Force
                    
                    $sourceName = $([System.IO.FileInfo]$sourceTexPath).Name
                    $targetName = $([System.IO.FileInfo]$targetTexPath).Name

                    Write-Host $sourceName -ForegroundColor Green -NoNewline
                    Write-Host " renamed to " -NoNewline
                    Write-Host $targetName -ForegroundColor Green
                }            
            }            
        }
    }
    End {     
    }
}

Function Hide-BookMetaData {
    param (    
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [T9ABook[]] $books,
        [Switch]$AlphaVersion,
        [Switch]$BetaVersion,
        [Switch]$HotfixVersion,
        [Switch]$ReleaseDate,
        [Switch]$SpecialVersion,
        [Switch]$ThereIsChangeLog
    )
    Begin {}

    Process {
        $books | ForEach-Object {            

            $bookId = $_.BookId

            $texPath = Get-ChildItem -Path $_.GetTexDir()  -Filter *EN.tex #deduct tex file here to get updated filename (if new version has been set, thus filename has changed)

            $i = 1

            $laTeX = Get-Content $texPath | ForEach-Object {

                $updated = $true

                $output = ""
                if ($($AlphaVersion) -and $_.Contains("\newcommand{\alphaversion}{")) {                    
                    $output += "%$($_)"
                }
                elseif ($($BetaVersion) -and $_.Contains("\newcommand{\betaversion}{")) {
                    $output += "%$($_)"
                }
                elseif ($($HotfixVersion) -and $_.Contains("\newcommand{\hotfixversion}{")) {
                    $output += "%$($_)"
                }
                elseif ($($ReleaseDate) -and $_.Contains("\newcommand\releasedate{")) {
                    $output += "%$($_)"
                }
                elseif ($($SpecialVersion) -and $_.Contains("\newcommand{\specialversion}{")) {
                    $output += "%$($_)"
                }
                elseif ($($ThereIsChangeLog) -and $_.Contains("\def\thereisachangelog{}")) {
                    $output += "%$($_)"
                }
                else {
                    $output = $_
                    $updated = $false
                }
                
                if ($updated) {

                    while ($output.StartsWith("%%")) {
                        $output = $output.SubString(1)
                    }
                    Write-Host "[$($bookId.PadRight(3))]::" -ForegroundColor DarkGray -NoNewline
                    Write-Host "$i " -NoNewline
                    Write-Host $output -ForegroundColor DarkMagenta
                }                
                $i++
                $output #Do NOT delete!
            }

            Set-Content -Path $texPath -Value $laTeX -Force            
        }
    }
    End {}
}

Function Set-BookMetaData {
    param (    
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [T9ABook[]] $books,
        [int]$EditionVersion,        
        [int]$BalanceVersion,        
        [ValidateSet("EN", "ES", "FR", "DE", "IT")]
        [string]$Language,
        [int]$AlphaVersion,
        [int]$BetaVersion,
        [int]$HotfixVersion,
        [string]$ReleaseDate,
        [string]$SpecialVersion,
        [Switch]$ThereIsChangeLog
    )
    Begin {
        if ($Language) {
            $Language = $Language.ToUpperInvariant()
        }        
    }

    Process {

        $books | ForEach-Object {
            

            $bookId = $_.BookId
            
            $texPath = Get-ChildItem -Path $_.GetTexDir()  -Filter *EN.tex #deduct tex file here to get updated filename (if new version has been set, thus filename has changed)

            $i = 1

            $laTeX = Get-Content $texPath | ForEach-Object {

                $updated = $true

                $output = ""
                if ($($EditionVersion) -and $_.Contains("\newcommand{\editionversion}{\nth{")) {                    
                    $output += "\newcommand{\editionversion}{\nth{$($EditionVersion)} Edition}"
                }
                elseif ($($BalanceVersion) -and $_.Contains("\newcommand{\balanceversion}{")) {                    
                    $output += "\newcommand{\balanceversion}{$($BalanceVersion)}"
                }                
                elseif ($($AlphaVersion) -and $_.Contains("\newcommand{\alphaversion}{")) {
                    $output += "\newcommand{\alphaversion}{$($AlphaVersion)}% 1 if first alpha, 2 if second alpha, etc."
                }
                elseif ($($BetaVersion) -and $_.Contains("\newcommand{\betaversion}{")) {
                    $output += "\newcommand{\betaversion}{$($BetaVersion)}% 1 if first beta, 2 if second beta, etc."
                }
                elseif ($($HotfixVersion) -and $_.Contains("\newcommand{\hotfixversion}{")) {
                    $output += "\newcommand{\hotfixversion}{$($HotfixVersion)}% undefined if no hotfix (= version 0), 1 for first hotfix, etc. this version number is language specific, each translation can be in his own hotfix number"
                }
                elseif ($($ReleaseDate) -and $_.Contains("\newcommand\releasedate{")) {
                    $output += "\newcommand\releasedate{$($ReleaseDate)}% Comment if you want to use today's date in your default language"
                }
                elseif ($($SpecialVersion) -and $_.Contains("\newcommand{\specialversion}{")) {
                    $output += "\newcommand{\specialversion}{$($SpecialVersion)}% anything related to the version"
                }
                elseif ($ThereIsChangeLog -and $_.Contains("\def\thereisachangelog{}")) {
                    $output += "\def\thereisachangelog{}"
                }
                else {
                    $output = $_
                    $updated = $false
                }                
                if ($updated) {
                    Write-Host "[$($bookId.PadRight(3))]::" -ForegroundColor DarkGray -NoNewline
                    Write-Host "$i " -NoNewline
                    Write-Host $output -ForegroundColor DarkCyan
                }                
                $i++
                $output #Do NOT delete!
            }                        
            Set-Content -Path $texPath -Value $laTeX -Force            
        }
    }
    End {}
}