function Set-MipSdkPackagerConfig {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter()]
        [string]
        $MipSdkRepo,
        # Parameter help description
        [Parameter()]
        [string]
        $NuGetApiKey,
        # Parameter help description
        [Parameter()]
        [string]
        $PSGalleryApiKey
    )
    
    process {
        try {
            if ($PSBoundParameters.ContainsKey("MipSdkRepo")) {
                if (Test-Path $MipSdkRepo -ErrorAction Stop) {
                    $script:Config.MipSdkRepo = $MipSdkRepo
                } else {
                    throw (New-Object System.IO.DirectoryNotFoundException $MipSdkRepo)
                }
            }

            if ($PSBoundParameters.ContainsKey("NuGetApiKey")) {
                $null = $NuGetApiKey | ConvertTo-SecureString -ErrorAction Stop
                $script:Config.NuGetApiKey = $NuGetApiKey
            }

            if ($PSBoundParameters.ContainsKey("PSGalleryApiKey")) {
                $null = $PSGalleryApiKey | ConvertTo-SecureString -ErrorAction Stop
                $script:Config.PSGalleryApiKey = $PSGalleryApiKey
            }
            
            if (!(Test-Path ($script:ConfigPath | Split-Path -Parent))) {
                New-Item -Path ($script:ConfigPath | Split-Path -Parent) -ItemType Directory
            }
            $script:Config | ConvertTo-Json | Set-Content -Path $script:ConfigPath
        }
        catch {
            throw
        }
    }
}