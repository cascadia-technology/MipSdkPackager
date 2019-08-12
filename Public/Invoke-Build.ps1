function Invoke-Build {
    [CmdletBinding()]
    param (
        [Parameter(Position = 1)]
        [string]
        $MipSdkVersion,
        [Parameter(Position = 2)]
        [string]
        $ManifestVersion,
        [Parameter(Position = 3)]
        [string]
        $ReleaseNotes
    )

    process {
        $errorPreference = $ErrorActionPreference
        $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
        try {
            $updateParams = @{
                MipSdkVersion = $MipSdkVersion
                ManifestVersion = $ManifestVersion
                ReleaseNotes = $ReleaseNotes
            }
            Get-ChildItem $script:ModulePath\Output | Remove-Item
            $packages = @()
    
            ."$($script:ModulePath)\CascadiaMipRedist\update.ps1" @updateParams
            Invoke-PublishModule -Build
    
            ."$($script:ModulePath)\Cascadia.VideoOS.ConfigurationAPI\update.ps1" @updateParams
            $packages += Invoke-NuGetPack -Name Cascadia.VideoOS.ConfigurationAPI
    
            ."$($script:ModulePath)\Cascadia.VideoOS.Management\update.ps1" @updateParams
            $packages += Invoke-NuGetPack -Name Cascadia.VideoOS.Management
    
            ."$($script:ModulePath)\Cascadia.VideoOS.Platform.Transact\update.ps1" @updateParams
            $packages += Invoke-NuGetPack -Name Cascadia.VideoOS.Platform.Transact
    
            ."$($script:ModulePath)\Cascadia.VideoOS.Platform.SDK\update.ps1" @updateParams
            $packages += Invoke-NuGetPack -Name Cascadia.VideoOS.Platform.SDK
            
            ."$($script:ModulePath)\Cascadia.VideoOS.Platform.SDK.Export\update.ps1" @updateParams
            $packages += Invoke-NuGetPack -Name Cascadia.VideoOS.Platform.SDK.Export
            
            ."$($script:ModulePath)\Cascadia.VideoOS.Platform.SDK.Log\update.ps1" @updateParams
            $packages += Invoke-NuGetPack -Name Cascadia.VideoOS.Platform.SDK.Log
            
            ."$($script:ModulePath)\Cascadia.VideoOS.Platform.SDK.Media\update.ps1" @updateParams
            $packages += Invoke-NuGetPack -Name Cascadia.VideoOS.Platform.SDK.Media
    
            ."$($script:ModulePath)\Cascadia.VideoOS.Platform.SDK.UI\update.ps1" @updateParams
            $packages += Invoke-NuGetPack -Name Cascadia.VideoOS.Platform.SDK.UI
        }
        catch {
            throw
        } finally {
            $ErrorActionPreference = $errorPreference
        }
    }
}