# code for importing MS photos. 

# Silently install MS Photos 
New-Item -Path "C:/" -Name CustomSoftware -ItemType Directory -ErrorAction SilentlyContinue
$LocalPath = 'C:/CustomSoftware'

# XAML
$sourceXaml = "https://dl.dropboxusercontent.com/s/k6xilnopjoudr8r/Microsoft.UI.XAML.2.4.appx"
$destinationXaml = "$LocalPath\Microsoft.UI.XAML.2.4.appx"
Invoke-WebRequest $sourceXaml -OutFile $destinationXaml

# VC Libs
$sourceVcLibs = "https://dl.dropboxusercontent.com/s/prem0pziup2w74x/Microsoft.VCLibs.140.00.Appx"
$destinationVcLibs = "$LocalPath\Microsoft.VCLibs.140.appx"
Invoke-WebRequest $sourceVcLibs -OutFile $destinationVcLibs

# Photos
$sourceWindowsPhotos = "https://dl.dropboxusercontent.com/s/zz0pwwwifm2urip/Microsoft.Windows.Photos.AppxBundle"
$destinationWindowsPhotos = "$LocalPath\Microsoft.Windows.Photos.AppxBundle"
Invoke-WebRequest $sourceWindowsPhotos -OutFile $destinationWindowsPhotos

$hashUiXaml = "EA9720E4E2F3FA7B3ECDCF39E1D92D5295E9DA211F9783B21815DBF9355A6265"
$hashVcLibs = "E3339B2B40EE2522703FCAA451236653D8B9ACA2B98AE9162C427F978D08139A"
$hashMsPhotos = "D20984EB8F70B4FCE3A7255C600A2FFE2F5DCF39E731B126A6012F876E523C67"

$checkHashVcLibs = Get-FileHash -Algorithm SHA256 C:\CustomSoftware\Microsoft.VCLibs.140.appx | Select-Object -ExpandProperty Hash
$checkHashUiXaml = Get-FileHash -Algorithm SHA256 C:\CustomSoftware\Microsoft.UI.XAML.2.4.appx | Select-Object -ExpandProperty Hash
$checkHashMsPhotos = Get-FileHash -Algorithm SHA256 C:\CustomSoftware\Microsoft.Windows.Photos.AppxBundle | Select-Object -ExpandProperty Hash

if ($checkHashUiXaml -ne $hashUiXaml) {
    Write-Host "Hash for UI XAML isn't matching! ABORTING installation and removing files."
    Remove-Item "C:/CustomSoftware" -Force -Recurse
    exit
}

if ($checkHashVcLibs -ne $hashVcLibs) {
    Write-Host "Hash for UI XAML isn't matching! ABORTING installation and removing files."
    Remove-Item "C:/CustomSoftware" -Force -Recurse
    exit
}

if ($checkHashMsPhotos -ne $hashMsPhotos) {
    Write-Host "Hash for UI XAML isn't matching! ABORTING installation and removing files."
    Remove-Item "C:/CustomSoftware" -Force -Recurse
    exit
}

# Start the installation when download is finished
Dism.exe /online /Add-ProvisionedAppxPackage /PackagePath:C:\CustomSoftware\Microsoft.VCLibs.140.appx /SkipLicense
Dism.exe /online /Add-ProvisionedAppxPackage /PackagePath:C:\CustomSoftware\Microsoft.UI.XAML.2.4.appx /SkipLicense
Dism.exe /online /Add-ProvisionedAppxPackage /PackagePath:C:\CustomSoftware\Microsoft.Windows.Photos.AppxBundle /SkipLicense

Remove-Item "C:/CustomSoftware" -Force -Recurse

Get-AzCosmosDBAccount
