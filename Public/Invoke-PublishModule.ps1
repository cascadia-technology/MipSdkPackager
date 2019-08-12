function Invoke-PublishModule {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $Build,
        [Parameter()]
        [switch]
        $Force
    )

    process {
        try {
            $docs = [Environment]::GetFolderPath("MyDocuments")
            $modulePath = "$docs\WindowsPowerShell\Modules\CascadiaMipRedist"
            
            if (Test-Path $modulePath) {
                Get-ChildItem -Path $modulePath -Recurse | Remove-Item -Recurse -Force -ErrorAction Stop -Verbose
            } else {
                New-Item $modulePath -ItemType Directory -Force
            }
            
            Copy-Item "$($script:ModulePath)\CascadiaMipRedist\bin" $modulePath -Recurse -Force -ErrorAction Stop -Verbose:$VerbosePreference
            Copy-Item "$($script:ModulePath)\CascadiaMipRedist\CascadiaMipRedist.psd1" $modulePath -ErrorAction Stop -Verbose:$VerbosePreference
            Copy-Item "$($script:ModulePath)\CascadiaMipRedist\CascadiaMipRedist.psm1" $modulePath -ErrorAction Stop -Verbose:$VerbosePreference
        
            if (!$Build) {
                Publish-Module -Name CascadiaMipRedist -NuGetApiKey $script:Config.PSGalleryApiKey -Verbose:$VerbosePreference -Force:$($Force.IsPresent)
            }
        }
        catch {
            throw
        }
    }
    
    end {
    }
}