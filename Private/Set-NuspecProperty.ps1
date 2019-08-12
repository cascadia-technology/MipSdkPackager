function Set-NuspecProperty {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Path,
        [Parameter(Mandatory)]
        [string]
        $Property,
        [Parameter(Mandatory)]
        [string]
        $Value
    )
    
    begin {
    }
    
    process {
        $nuspec = [xml](Get-Content $Path -Raw)
        $versionNode = $nuspec.SelectSingleNode("/package/metadata/$Property")
        $versionNode.InnerText = $Value
        $nuspec.Save($Path)
    }
    
    end {
    }
}