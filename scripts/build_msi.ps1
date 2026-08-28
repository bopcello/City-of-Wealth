# Script to package Flutter Windows release build into a professional MSI Installer & Portable ZIP
$ErrorActionPreference = "Stop"

$releaseDir = "build\windows\x64\runner\Release"
$wixToolsDir = "build\wix_tools"

# Extract version dynamically from pubspec.yaml
$pubspecPath = "pubspec.yaml"
if (-not (Test-Path $pubspecPath)) {
    Write-Error "pubspec.yaml not found at $pubspecPath"
}
$pubspecLine = Get-Content $pubspecPath | Select-String "^version:"
$rawVersion = ($pubspecLine -split ":")[1].Trim()
$appVersion = ($rawVersion -split "\+")[0].Trim() # e.g. "3.2.0"

# Format version for WiX Product element (requires 4-part numeric version e.g., "3.2.0.0")
$wixVersion = $appVersion
$versionParts = $wixVersion.Split('.')
if ($versionParts.Count -eq 2) {
    $wixVersion = "$wixVersion.0.0"
} elseif ($versionParts.Count -eq 3) {
    $wixVersion = "$wixVersion.0"
}

Write-Host "Detected app version from pubspec.yaml: $appVersion (WiX Version: $wixVersion)"

$outputMsiName = "CityOfWealth_v${appVersion}_Setup.msi"
$outputMsi = "$releaseDir\$outputMsiName"
if (Test-Path $outputMsi) {
    try {
        Remove-Item $outputMsi -Force -ErrorAction Stop
    } catch {
        $outputMsiName = "CityOfWealth_v${appVersion}_Installer.msi"
        $outputMsi = "$releaseDir\$outputMsiName"
        if (Test-Path $outputMsi) {
            Remove-Item $outputMsi -Force -ErrorAction SilentlyContinue
        }
    }
}

if (-not (Test-Path "$releaseDir\city_of_wealth.exe")) {
    Write-Error "Release build not found. Please run 'flutter build windows' first."
}

if (-not (Test-Path "$wixToolsDir\candle.exe")) {
    Write-Host "WiX Tools not found. Downloading WiX standalone binaries..."
    New-Item -ItemType Directory -Force -Path $wixToolsDir | Out-Null
    $zipPath = "$wixToolsDir\wix311-binaries.zip"
    Invoke-WebRequest -Uri "https://github.com/wixtoolset/wix3/releases/download/wix3112rtm/wix311-binaries.zip" -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath $wixToolsDir -Force
}

Write-Host "Generating custom installer graphics with app logo..."
& "$PSScriptRoot\generate_installer_graphics.ps1"

Write-Host "Harvesting release files with heat.exe..."
& "$wixToolsDir\heat.exe" dir "$releaseDir" -cg ReleaseFiles -dr INSTALLFOLDER -scom -sreg -srd -gg -out "build\ReleaseFiles.wxs"

# Filter out static build files (.lib, .exp) and installers/zips from harvested XML
[xml]$wixXml = Get-Content "build\ReleaseFiles.wxs"
$components = $wixXml.Wix.Fragment.ComponentGroup.Component
foreach ($comp in @($components)) {
    if ($comp.File.Source -like "*.lib" -or $comp.File.Source -like "*.exp" -or $comp.File.Source -like "*.msi" -or $comp.File.Source -like "*.zip") {
        $null = $comp.ParentNode.RemoveChild($comp)
    }
}
$wixXml.Save("$PWD\build\ReleaseFiles.wxs")

Write-Host "Compiling BrowseFolderCA Managed Custom Action..."
$cscPath = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
if (-not (Test-Path $cscPath)) {
    Write-Error "C# compiler (csc.exe) not found at $cscPath"
}
& $cscPath /target:library /out:"build\BrowseFolderCA.dll" /r:"$wixToolsDir\sdk\Microsoft.Deployment.WindowsInstaller.dll" /r:System.Windows.Forms.dll "windows\installer\BrowseFolderCA.cs"

Write-Host "Packaging Custom Action into native DLL with MakeSfxCA.exe..."
$outCAPath = (Get-Item "build").FullName + "\BrowseFolderCA.CA.dll"
$sfxCAPath = (Get-Item "$wixToolsDir\sdk\x64\sfxca.dll").FullName
$inputCAPath = (Get-Item "build\BrowseFolderCA.dll").FullName
$dtfDllPath = (Get-Item "$wixToolsDir\sdk\Microsoft.Deployment.WindowsInstaller.dll").FullName
$caConfigPath = (Get-Item "windows\installer\CustomAction.config").FullName

& "$wixToolsDir\sdk\MakeSfxCA.exe" "$outCAPath" "$sfxCAPath" "$inputCAPath" "$dtfDllPath" "$caConfigPath"

Write-Host "Compiling WiX XML with candle.exe..."
& "$wixToolsDir\candle.exe" -arch x64 -dVersion="$wixVersion" -ext "$wixToolsDir\WixUIExtension.dll" -ext "$wixToolsDir\WixUtilExtension.dll" -out "build\Product.wixobj" "windows\installer\Product.wxs"
if ($LASTEXITCODE -ne 0) {
    throw "WiX failed to compile Product.wxs."
}
& "$wixToolsDir\candle.exe" -arch x64 -ext "$wixToolsDir\WixUIExtension.dll" -ext "$wixToolsDir\WixUtilExtension.dll" -out "build\ReleaseFiles.wixobj" "build\ReleaseFiles.wxs"
if ($LASTEXITCODE -ne 0) {
    throw "WiX failed to compile ReleaseFiles.wxs."
}

Write-Host "Linking MSI installer with light.exe..."
& "$wixToolsDir\light.exe" -ext "$wixToolsDir\WixUIExtension.dll" -ext "$wixToolsDir\WixUtilExtension.dll" -loc "windows\installer\WixUI_en-us.wxl" -b "$releaseDir" -out "$outputMsi" "build\Product.wixobj" "build\ReleaseFiles.wixobj"
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $outputMsi)) {
    throw "WiX failed to link the MSI; the installer was not produced."
}

Write-Host "Post-processing MSI UI navigation..."
$absMsiPath = (Get-Item "$outputMsi").FullName
$comInstaller = New-Object -ComObject WindowsInstaller.Installer
$msiDb = $comInstaller.GetType().InvokeMember("OpenDatabase", "InvokeMethod", $null, $comInstaller, @($absMsiPath, 1))
$uiEventDeletes = @(
    # The custom action supplies the modern folder picker, so the stock dialog
    # must not be opened as well.
    "DELETE FROM ``ControlEvent`` WHERE ``Dialog_``='InstallDirDlg' AND ``Control_``='ChangeFolder' AND ``Event``='SpawnDialog' AND ``Argument``='BrowseDlg'",
    # WixUI_InstallDir normally routes this button to VerifyReadyDlg. Route
    # fresh installs to CustomVerifyReadyDlg, which contains the shortcut
    # choices, while leaving maintenance and uninstall on the stock dialog.
    "DELETE FROM ``ControlEvent`` WHERE ``Dialog_``='InstallDirDlg' AND ``Control_``='Next' AND ``Event``='NewDialog' AND ``Argument``='VerifyReadyDlg'"
)

foreach ($sql in $uiEventDeletes) {
    $msiView = $msiDb.GetType().InvokeMember("OpenView", "InvokeMethod", $null, $msiDb, @($sql))
    $msiView.GetType().InvokeMember("Execute", "InvokeMethod", $null, $msiView, $null)
    $msiView.GetType().InvokeMember("Close", "InvokeMethod", $null, $msiView, $null)
}
$msiDb.GetType().InvokeMember("Commit", "InvokeMethod", $null, $msiDb, $null)

# Create Portable ZIP Package
$portableZipName = "CityOfWealth_v${appVersion}_Portable.zip"
$portableZip = "$releaseDir\$portableZipName"
if (Test-Path $portableZip) {
    Remove-Item $portableZip -Force -ErrorAction SilentlyContinue
}
Write-Host "Packaging Portable ZIP release..."
$filesToZip = Get-ChildItem -Path "$releaseDir\*" -Exclude "*.msi", "*.zip", "*.lib", "*.exp"
Compress-Archive -Path $filesToZip.FullName -DestinationPath "$portableZip" -Force

if (Test-Path "$outputMsi") {
    $msiFile = Get-Item "$outputMsi"
    $zipFile = Get-Item "$portableZip"
    Write-Host "=========================================="
    Write-Host "SUCCESS: Packages created successfully!"
    Write-Host "1. MSI Installer: $($msiFile.FullName) ($([math]::Round($msiFile.Length / 1MB, 2)) MB)"
    Write-Host "2. Portable ZIP:   $($zipFile.FullName) ($([math]::Round($zipFile.Length / 1MB, 2)) MB)"
    Write-Host "=========================================="
} else {
    Write-Error "Failed to build MSI Installer."
}
