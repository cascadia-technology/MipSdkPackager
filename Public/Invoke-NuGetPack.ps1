function Invoke-NuGetPack {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Name
    )
    
    begin {
    }
    
    process {
        $pref = $ErrorActionPreference
        $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
        $nuspec = Get-Item "$($script:ModulePath)\$Name\$name.nuspec"
        Push-Location $nuspec.Directory
        try {
            $xml = [xml](Get-Content $nuspec.FullName -Raw)
            $id = $xml.SelectSingleNode("/package/metadata/id").InnerText
            $version = $xml.SelectSingleNode("/package/metadata/version").InnerText
        
            .$script:NuGet pack $nuspec.Name
            Move-Item -Path "$id.$version.nupkg" -Destination "..\Output" -Force -Verbose:$VerbosePreference -PassThru
        } catch {
            throw
        } finally {
            Pop-Location
            $ErrorActionPreference = $pref
        }  
    }
    
    end {
    }
}
