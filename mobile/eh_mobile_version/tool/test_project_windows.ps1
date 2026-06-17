$ErrorActionPreference = "Stop"

& "$PSScriptRoot\fix_flutter_windows_ios_crash.ps1"

flutter pub get
flutter analyze
flutter test

Write-Host "Project checks completed."
