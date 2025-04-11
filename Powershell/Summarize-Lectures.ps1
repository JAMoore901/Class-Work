<#
.SYNOPSIS
Creates consolidated study guides from lecture notes
.DESCRIPTION
Student: Jessica Moore
Combines all weekly lecture notes into a single study file with table of contents
#>

# Configuration
$Course = "BIO202"
$NotePath = "D:\Classes\$Course\LectureNotes"
$OutputFile = "D:\StudyGuides\$Course-StudyGuide_$(Get-Date -Format yyyyMMdd).txt"

# Create header
"$COURSE STUDY GUIDE`nGenerated $(Get-Date)`n`nTABLE OF CONTENTS`n" | Out-File $OutputFile

# Process each lecture file
Get-ChildItem -Path $NotePath -Filter "Week*.txt" | Sort-Object Name | ForEach-Object {
    # Add to table of contents
    " - $($_.BaseName)" | Out-File $OutputFile -Append
    
    # Add lecture content with divider
    "`n`n========== $($_.BaseName) ==========`n" | Out-File $OutputFile -Append
    Get-Content $_.FullName | Out-File $OutputFile -Append
}

Write-Host "Study guide created at $OutputFile" -ForegroundColor Green
Write-Host "$(Get-Content $OutputFile | Measure-Object -Line).Lines total" -ForegroundColor Cyan