Using module ./T9A-Books.psm1

Class CompileResult {
    [string]$BookId
    [int]$ExitCode
    [string]$PdfPath
    [string]$LogPath
    [string]$LogTail
    [System.DateTime]$StartTime
    [System.DateTime]$EndTime
    [System.TimeSpan]$ElapsedTime
}

Function Start-Compile {
    param (
    
        [Parameter(Position = 0, Mandatory = $true)]        
        [T9ABook[]] $Books,
        [switch] $Release,
        [int]$ThrottleLimit = 128
    )
    Begin {
        Write-Host ""
        Write-Host "Compiling: " -NoNewline
        $output | ForEach-Object { $_.BookId } | Join-String -Separator "," | Write-Host  -ForegroundColor DarkCyan -NoNewline
        Write-Host ""

        $allStartTime = Get-Date
    }

    Process {
    
        $lualatexResults = $Books | ForEach-Object -Parallel {
            Import-Module $(Join-Path $using:PSScriptRoot -ChildPath T9A-Compile.psm1) -Force
            Start-Lualatex -BookId $_.BookId -TexDir $_.GetTexDir() -release:$using:Release
        }  -ThrottleLimit $ThrottleLimit 
        $lualatexResults | Copy-PdfsToOutputDir -openOutputDirWhenFinished    
    }

    End {    
        return Write-LualatexSummary -lualatexResults $lualatexResults -allStartTime $allStartTime
    }
}

Function Start-Lualatex {
    [CmdletBinding()]
    Param (        
        [Parameter(Mandatory = $true)]
        [string]$BookId,
        [Parameter(Mandatory = $true)]
        [System.IO.DirectoryInfo]$TexDir,
        [Parameter(Mandatory = $true)]
        [switch] $release
    )

    Begin {        
        $startTime = Get-Date        

        $compiles = 1 #default to debug
        if ($release) {
            $compiles = 3
        }

        Set-Location $TexDir
    }

    Process {

        try {

            $result = Get-ChildItem $TexDir -Filter *EN.tex
            $texFile = [System.IO.FileInfo]$result

            for ($i = 0; $i -lt $compiles; $i++) {

                Write-Host "Compile #$($i+1) of '$BookId' from '$($texFile.Name)' starting..." -ForegroundColor DarkCyan

                . lualatex -halt-on-error -interaction=nonstopmode $texFile.Name | Write-Host -ForegroundColor DarkGray
                if ($LastExitCode -ne 0) {
                    break
                }
            }            

            $pdfPath = Join-Path $(Get-Location) -ChildPath $texFile.Name.Replace(".tex", ".pdf")
            $logPath = Join-Path $(Get-Location) -ChildPath $texFile.Name.Replace(".tex", ".log")
            $logOutput = Get-Item -Path $logPath | Get-Content -Tail 20
        }
        finally {
            
            Set-Location $PSScriptRoot
        }        
    }

    End {
        $fatal = $false

        foreach ($line in $logOutput) {
            if ($line.StartsWith("!")) {
                $fatal = $true                
                break
            }
        }

        if ($fatal) {            
            $exitCode = 1
        }
        else {
            $exitCode = 0
        }
        
        $endTime = Get-Date
        return New-Object CompileResult -Property  @{
            BookId      = $BookId
            ExitCode    = $exitCode
            PdfPath     = $pdfPath
            LogPath     = $logPath
            LogTail     = $logOutput
            StartTime   = $startTime
            EndTime     = $endTime
            ElapsedTime = $endTime - $startTime
        }
    }
}

Function Copy-PdfsToOutputDir {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true,        
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [PSCustomObject[]] $lualatexResults,
        [switch] $openOutputDirWhenFinished
    )

    Begin {
        $outputDir = Join-Path $PSScriptRoot -ChildPath "../__PdfOutput"

        if (Test-Path $outputDir -PathType Container) {
            Remove-Item $outputDir\*.* -Recurse -Force
        }
        else {
            New-Item -Path $outputDir -ItemType Directory -Force
        }
    }

    Process {
        $lualatexResults | ForEach-Object {
            if ($_.ExitCode -eq 0) {
                $pdfPathInfo = [System.IO.FileInfo]$_.PdfPath
                $destination = Join-Path $outputDir -ChildPath $pdfPathInfo.Name
                Copy-Item -Path $_.PdfPath -Destination $destination
            }
        }
        if ($openOutputDirWhenFinished) {
            start $outputDir
        }        
    }
    End {
        return $lualatexResults
    }
}

Function Write-LualatexErrorLog {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [PSCustomObject] $lualatexResult
    )

    process {
        Write-Host " $($lualatexResult.BookId.PadRight(3)) " -ForegroundColor DarkMagenta  -BackgroundColor Gray -NoNewline
        Write-Host " Error log START: " -BackgroundColor DarkRed -ForegroundColor White -NoNewline
        Write-Host ""
        $lualatexResult.LogTail | ForEach-Object { 
            if ($_.StartsWith("!")) {
                Write-Host "$_" -ForegroundColor Red
            }
            else {
                Write-Host "$_" 
            }
            
        }
        Write-Host " $($lualatexResult.BookId.PadRight(3)) " -ForegroundColor DarkMagenta  -BackgroundColor Gray -NoNewline
        Write-Host " Error log END " -BackgroundColor DarkRed -ForegroundColor White -NoNewline
        Write-Host " "
        Write-Host " "
    }
}

Function Write-LualatexSummary {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [PSCustomObject[]] $lualatexResults,
        [Parameter(Mandatory = $true)]
        $allStartTime
    )

    Begin {
        $hasErrors = $lualatexResults | Test-Any { $_.ExitCode -ne 0 }
        $elapsedTime = $(Get-Date) - $allStartTime
    }

    process {
        
        Write-Host ""
        Write-Host "*****************************************************************************"
        Write-Host "*                                                                           *"
        Write-Host "*                                Summary                                    *"
        Write-Host "*                                                                           *"
        Write-Host "*****************************************************************************"
        Write-Host ""
        
        if ($hasErrors) {
            Write-Host "*                             " -BackgroundColor DarkRed -ForegroundColor White -NoNewline
            Write-Host "Errors found!" -BackgroundColor DarkRed -ForegroundColor White -NoNewline
            Write-Host "                                 *" -BackgroundColor DarkRed -ForegroundColor White -NoNewline
            Write-Host ""
            Write-Host ""

            $lualatexResults | Sort-Object $_.BookId | ForEach-Object {  
                if ($_.ExitCode -ne 0) {        
                    Write-LualatexErrorLog -lualatexResult $_
                }
            }
        }
        else {
            Write-Host "*                               " -BackgroundColor DarkGreen -ForegroundColor White -NoNewline
            Write-Host "No errors!" -BackgroundColor DarkGreen -ForegroundColor White -NoNewline
            Write-Host "                                  *" -BackgroundColor DarkGreen -ForegroundColor White -NoNewline
            Write-Host ""
            Write-Host ""
        }

        

        Write-Host " Everything " -ForegroundColor DarkMagenta  -BackgroundColor Gray -NoNewline
        Write-Host  " finished in " -NoNewline
        Write-Host  "$($elapsedTime.ToString("h'h 'm'm 's's'"))" -ForegroundColor DarkCyan

        $lualatexResults | Sort-Object $_.BookId | ForEach-Object {  
            Write-Host  "       " -NoNewline
            Write-Host " $($_.BookId.PadRight(3)) " -ForegroundColor DarkMagenta  -BackgroundColor Gray -NoNewline
            Write-Host  " finished in " -NoNewline
            Write-Host  "$($_.ElapsedTime.ToString("h'h 'm'm 's's'"))" -ForegroundColor DarkCyan -NoNewline            
            if ($_.ExitCode -eq 0) {
                Write-Host  ""
            }
            else {
                Write-Host  " with " -NoNewline
                Write-Host " Fatal error " -BackgroundColor DarkRed -ForegroundColor White -NoNewline
                Write-Host " (See log for details)"            
            }
        }
    }

    End {        
    }
}


Function Test-Any {

    [CmdletBinding()]
    param(
        [ScriptBlock] $Filter,
        [Parameter(ValueFromPipeline = $true)] $InputObject
    )

    process {
        if (-not $Filter -or (Foreach-Object $Filter -InputObject $InputObject)) {
            $true # Signal that at least 1 [matching] object was found
            # Now that we have our result, stop the upstream commands in the
            # pipeline so that they don't create more, no-longer-needed input.
          (Add-Type -Passthru -TypeDefinition '
            using System.Management.Automation;
            namespace net.same2u.PowerShell {
              public static class CustomPipelineStopper {
                public static void Stop(Cmdlet cmdlet) {
                  throw (System.Exception) System.Activator.CreateInstance(typeof(Cmdlet).Assembly.GetType("System.Management.Automation.StopUpstreamCommandsException"), cmdlet);
                }
              }
            }')::Stop($PSCmdlet)
        }
    }
    end { $false }
}