param (
    [string]$sourcePath,
    [string]$replicaPath,
    [string]$logFilePath
)

# Function to log messages to both console and log file
function Log-Message {
    param (
        [string]$message
    )

    # Write to console
    Write-Host $message

    # Write to log file
    Add-Content -Path $logFilePath -Value $message
}

# Check if the source and replica directories exist
if (-not (Test-Path $sourcePath)) {
    Write-Host "Source directory does not exist!"
    exit
}

if (-not (Test-Path $replicaPath)) {
    Write-Host "Replica directory does not exist!"
    exit
}

# Synchronize files from source to replica
function Sync-Folders {
    # Get list of files and subdirectories in source and replica
    $sourceFiles = Get-ChildItem -Path $sourcePath -Recurse
    $replicaFiles = Get-ChildItem -Path $replicaPath -Recurse

    # Remove files and folders in replica that don't exist in source
    foreach ($replicaItem in $replicaFiles) {
        $relativePath = $replicaItem.FullName.Substring($replicaPath.Length)
        $sourceItem = Join-Path -Path $sourcePath -ChildPath $relativePath

        if (-not (Test-Path $sourceItem)) {
            if ($replicaItem.PSIsContainer) {
                # Remove empty directory in replica
                Log-Message "Removing directory: $($replicaItem.FullName)"
                Remove-Item -Path $replicaItem.FullName -Recurse
            } else {
                # Remove file in replica
                Log-Message "Removing file: $($replicaItem.FullName)"
                Remove-Item -Path $replicaItem.FullName
            }
        }
    }

    # Copy new or updated files from source to replica
    foreach ($sourceItem in $sourceFiles) {
        $relativePath = $sourceItem.FullName.Substring($sourcePath.Length)
        $replicaItem = Join-Path -Path $replicaPath -ChildPath $relativePath

        if (-not (Test-Path $replicaItem)) {
            # Copy new file or directory
            if ($sourceItem.PSIsContainer) {
                Log-Message "Creating directory: $($replicaItem)"
                New-Item -Path $replicaItem -ItemType Directory
            } else {
                Log-Message "Copying file: $($sourceItem.FullName) to $($replicaItem)"
                Copy-Item -Path $sourceItem.FullName -Destination $replicaItem
            }
        } elseif ($sourceItem.LastWriteTime -gt (Get-Item $replicaItem).LastWriteTime) {
            # Update file if the source is newer
            Log-Message "Updating file: $($replicaItem)"
            Copy-Item -Path $sourceItem.FullName -Destination $replicaItem -Force
        }
    }
}

# Run synchronization
Log-Message "Starting synchronization between $sourcePath and $replicaPath"

Sync-Folders

Log-Message "Synchronization complete."
