# Log File Cleanup Script
# This script reads a CSV file and deletes log files based on the KeepForDays value

param(
    [Parameter(Mandatory=$true)]
    [string]$CsvPath, # Path to the CSV file
    [Parameter(Mandatory=$false)]
    [string[]]$ExcludeFiles = @("important.log", "do_not_delete.txt"), # Files to exclude
    [Parameter(Mandatory=$false)]
    [switch]$WhatIf # Enable dry run mode
)

# Import CSV file
$logEntries = Import-Csv -Path $CsvPath

# Get today's date
$today = Get-Date

# Process each entry in the CSV
foreach ($entry in $logEntries) {
    # Construct the full file path
    $filePath = Join-Path -Path $entry.DirectoryPath -ChildPath $entry.FileName

    # Check if the file exists
    if (Test-Path -Path $filePath) {
        # Get the file creation time
        $fileCreationTime = (Get-Item -Path $filePath).CreationTime

        # Calculate the cutoff date based on KeepForDays
        $cutoffDate = $today.AddDays(-[int]$entry.KeepForDays)

        # Check if the file should be deleted
        if ($entry.KeepForDays -eq 0 -or $fileCreationTime -lt $cutoffDate) {
            # Check if the file is in the exclusion list
            if ($ExcludeFiles -notcontains $entry.FileName) {
                # Delete the file (or simulate deletion in WhatIf mode)
                Remove-Item -Path $filePath -Force -WhatIf:$WhatIf
                Write-Host "Deleted file: $filePath"
            } else {
                Write-Host "Skipping file: $filePath (excluded)"
            }
        } else {
            Write-Host "Keeping file: $filePath (within retention period)"
        }
    } else {
        Write-Host "File not found: $filePath"
    }
}

Write-Host "Log cleanup process completed."