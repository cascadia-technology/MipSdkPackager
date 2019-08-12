function Publish-NugetPackage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Path
    )
    
    process {
        $apiKey = $script:Config.NuGetApiKey | ConvertTo-UnsecureString
        .$script:NuGet push $Path $apiKey -Source https://api.nuget.org/v3/index.json
        $apiKey = $null
    }
}