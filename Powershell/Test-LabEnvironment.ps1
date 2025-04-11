<#
.SYNOPSIS
Verifies required software for programming lab
.DESCRIPTION
Student: Jessica Moore
Checks for installed applications, Python modules, and network connectivity
#>

# Required configuration
$RequiredSoftware = @("Python 3.11", "VSCode", "Wireshark")
$PythonModules = @("numpy", "pandas", "matplotlib")
$LabServer = "labserver.comp-sci.edu"

# 1. Check installed applications
Write-Host "`nCHECKING INSTALLED SOFTWARE:`n" -ForegroundColor Yellow
$softwareReport = @()

foreach ($app in $RequiredSoftware) {
    $installed = Get-Package -Name $app -ErrorAction SilentlyContinue
    if ($installed) {
        $status = "OK"
        $color = "Green"
    } else {
        $status = "MISSING"
        $color = "Red"
    }
    Write-Host "$($app.PadRight(15)) $status" -ForegroundColor $color
    $softwareReport += [PSCustomObject]@{
        Software = $app
        Status = $status
        Version = if ($installed) { $installed.Version } else { "N/A" }
    }
}

# 2. Check Python modules
Write-Host "`nCHECKING PYTHON MODULES:`n" -ForegroundColor Yellow
$pythonReport = @()

foreach ($module in $PythonModules) {
    try {
        $version = python -c "import $module; print($module.__version__)" 2>$null
        $status = "OK"
        $color = "Green"
    } catch {
        $version = "N/A"
        $status = "MISSING"
        $color = "Red"
    }
    Write-Host "$($module.PadRight(15)) $status" -ForegroundColor $color
    $pythonReport += [PSCustomObject]@{
        Module = $module
        Status = $status
        Version = $version
    }
}

# 3. Test lab server connection
Write-Host "`nTESTING LAB CONNECTION:`n" -ForegroundColor Yellow
$ping = Test-NetConnection -ComputerName $LabServer -InformationLevel Quiet
Write-Host "Connection to $LabServer : $(if ($ping) {'OK' else {'FAILED'})" -ForegroundColor $(if ($ping) {'Green' else {'Red'})

# Generate HTML report
$reportPath = "$HOME\Desktop\LabEnvironmentReport_$(Get-Date -Format yyyyMMdd).html"
$softwareReport | ConvertTo-Html -Title "Software Check" -PreContent "<h1>Lab Environment Report</h1>" | Out-File $reportPath
$pythonReport | ConvertTo-Html -Title "Python Modules" | Out-File $reportPath -Append

Write-Host "`nFull report saved to $reportPath" -ForegroundColor Cyan