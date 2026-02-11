
# Define variables
$flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.0-stable.zip"
$installDir = "C:\src"
$zipPath = "$env:TEMP\flutter.zip"
$flutterDir = "$installDir\flutter"

# Create installation directory
if (!(Test-Path -Path $installDir)) {
    Write-Host "Creating directory $installDir..."
    New-Item -ItemType Directory -Force -Path $installDir
}

# Download Flutter SDK
Write-Host "Downloading Flutter SDK from $flutterUrl..."
Invoke-WebRequest -Uri $flutterUrl -OutFile $zipPath

# Extract Zip
Write-Host "Extracting Flutter SDK to $installDir..."
Expand-Archive -Path $zipPath -DestinationPath $installDir -Force

# Clean up zip
Remove-Item -Path $zipPath

# Add to PATH (User scope)
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$flutterDir\bin*") {
    Write-Host "Adding Flutter to PATH..."
    $newPath = "$currentPath;$flutterDir\bin"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
} else {
    Write-Host "Flutter is already in PATH."
}

Write-Host "Installation complete! Please restart your terminal."
