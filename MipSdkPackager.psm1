$public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction Ignore )
$private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction Ignore )

foreach ($import in $public + $private) {
    try {
        . $import.FullName
    }
    catch {
        Write-Error "Failed to import function $($import.FullName): $_"
    }
}

$script:ModulePath = $PSScriptRoot
$script:ConfigPath = Join-Path $env:ALLUSERSPROFILE "MipSdkPackager\config.json"

if (Test-Path $script:ConfigPath) {
    $script:Config = Get-MipSdkPackagerConfig -Reload
} else {
    $mipSdkRepo = Read-Host -Prompt "Path to MIP SDK repo"
    $nugetApiKey = Read-Host -Prompt "NuGet API Key" -AsSecureString
    $psGalleryApiKey = Read-Host -Prompt "PSGallery API Key" -AsSecureString
    $script:Config = @{
        MipSdkRepo = $mipSdkRepo
        NuGetApiKey = $nugetApiKey | ConvertFrom-SecureString
        PSGalleryApiKey = $psGalleryApiKey | ConvertFrom-SecureString
    }
    Set-MipSdkPackagerConfig @script:Config
}

try {
    $package = Get-Package -Name NuGet.CommandLine -ErrorAction Stop
}
catch {
    $package = Install-Package -Name NuGet.CommandLine -Force -Verbose
}

$script:NuGet = "$(($package.Source | Get-Item).Directory)\tools\nuget.exe"