
$logFile = "$PSScriptRoot\install_log.txt"
Start-Transcript -Path $logFile -Append

try {
    # Define variables
    $flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.0-stable.zip"
    $installDir = "C:\src"
    $zipPath = "$env:TEMP\flutter.zip"
    $flutterDir = "$installDir\flutter"

    Write-Host "Starting installation..."

    # Create installation directory
    if (!(Test-Path -Path $installDir)) {
        Write-Host "Creating directory $installDir..."
        New-Item -ItemType Directory -Force -Path $installDir
    } else {
        Write-Host "Directory $installDir already exists."
    }

    # Download Flutter SDK
    if (Test-Path $zipPath) {
        Write-Host "Found existing zip at $zipPath. Checking size..."
        $size = (Get-Item $zipPath).Length
        if ($size -lt 1000000) { # Less than 1MB, probably corrupt
             Write-Host "Zip too small, re-downloading..."
             Invoke-WebRequest -Uri $flutterUrl -OutFile $zipPath
        } else {
             Write-Host "Using existing zip."
        }
    } else {
        Write-Host "Downloading Flutter SDK from $flutterUrl..."
        Invoke-WebRequest -Uri $flutterUrl -OutFile $zipPath
    }

    # Extract Zip
    Write-Host "Extracting Flutter SDK to $installDir..."
    Expand-Archive -Path $zipPath -DestinationPath $installDir -Force

    # Clean up zip
    # Write-Host "Cleaning up zip..."
    # Remove-Item -Path $zipPath

    # Add to PATH (User scope)
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$flutterDir\bin*") {
        Write-Host "Adding Flutter to PATH..."
        $newPath = "$currentPath;$flutterDir\bin"
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    } else {
        Write-Host "Flutter is already in PATH."
    }

    Write-Host "Installation successful!"
} catch {
    Write-Error "An error occurred: $_"
    exit 1
} finally {
    Stop-Transcript
}
