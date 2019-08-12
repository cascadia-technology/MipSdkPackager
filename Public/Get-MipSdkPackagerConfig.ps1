function Get-MipSdkPackagerConfig {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $Reload
    )

    process {
        if ($Reload) {
            $script:Config = Get-Content $script:ConfigPath | ConvertFrom-Json
        }
        $script:Config
    }
}