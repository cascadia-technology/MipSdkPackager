param([string] $MipSdkVersion, [string] $ManifestVersion, [string] $ReleaseNotes)

$binPath = "$($script:Config.MipSdkRepo)\$MipSdkVersion\Bin"
try {
    if ([string]::IsNullOrEmpty($MipSdkVersion)) {
        throw (New-Object System.ArgumentNullException -ArgumentList "MIP SDK version must be provided","MipSdkVersion")
    }

    if ([string]::IsNullOrEmpty($ManifestVersion)) {
        throw (New-Object System.ArgumentNullException -ArgumentList "Manifest version must be provided","ManifestVersion")
    }
    
    if (!(Test-Path $binPath)) {
        throw (New-Object System.ArgumentOutOfRangeException -ArgumentList "MipSdkVersion","MIP SDK $MipSdkVersion binaries not found" )
    }
    
    if (Test-Path $PSScriptRoot\Bin) {
        Get-ChildItem $PSScriptRoot\Bin | Remove-Item -Recurse -Force
    } else {
        New-Item $PSScriptRoot\Bin -ItemType Directory
    }

    Copy-Item "$binPath\VideoOS.Platform.dll" $PSScriptRoot\Bin -Force -Verbose
    Copy-Item "$binPath\VideoOS.Platform.SDK.dll" $PSScriptRoot\Bin -Force -Verbose

    $name = (Get-Item $PSScriptRoot).Name
    Set-NuspecProperty -Path "$PSScriptRoot\$name.nuspec" -Property version -Value $ManifestVersion   
    if (![string]::IsNullOrEmpty($ReleaseNotes)) {
        Set-NuspecProperty -Path "$PSScriptRoot\$name.nuspec" -Property releaseNotes -Value $ReleaseNotes
    }   
} catch {
    throw
}
