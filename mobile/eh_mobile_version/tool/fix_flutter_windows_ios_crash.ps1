$ErrorActionPreference = "Stop"

$projectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$swiftPackageRoot = Join-Path $projectRoot "ios\Flutter\ephemeral\Packages\FlutterGeneratedPluginSwiftPackage"
$swiftTargetRoot = Join-Path $swiftPackageRoot "Sources\FlutterGeneratedPluginSwiftPackage"

New-Item -ItemType Directory -Force -Path $swiftTargetRoot | Out-Null

$packageFile = Join-Path $swiftPackageRoot "Package.swift"
$targetFile = Join-Path $swiftTargetRoot "FlutterGeneratedPluginSwiftPackage.swift"
$packagesMarker = Join-Path $projectRoot "ios\Flutter\ephemeral\Packages\.packages"

if (-not (Test-Path $packageFile)) {
  @'
// swift-tools-version: 5.9
// Generated compatibility package for Flutter tooling on Windows.

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage"
        )
    ]
)
'@ | Set-Content -LiteralPath $packageFile -Encoding UTF8
}

if (-not (Test-Path $targetFile)) {
  "// Empty target used by Flutter tooling when no iOS plugins are registered." | Set-Content -LiteralPath $targetFile -Encoding UTF8
}

if (-not (Test-Path $packagesMarker)) {
  New-Item -ItemType File -Force -Path $packagesMarker | Out-Null
}

Write-Host "Flutter iOS ephemeral Swift package structure is ready."
