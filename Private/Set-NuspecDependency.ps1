function Set-NuspecDependency {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Path,
        [Parameter(Mandatory)]
        [string]
        $Id,
        [Parameter(Mandatory)]
        [string]
        $Version
    )
    
    process {
        $nuspec = [xml](Get-Content $Path -Raw)
        $dependency = $nuspec.SelectSingleNode("/package/metadata/dependencies/dependency[@id='$Id']")
        if ($null -ne $dependency) {
            $dependency.Attributes["version"].Value = $Version
        } else {
            $dependency = $nuspec.CreateElement("dependency")
            $idAttr = $nuspec.CreateAttribute("id")
            $idAttr.Value = $Id
            $dependency.Attributes.Append($idAttr)
            $versionAttr = $nuspec.CreateAttribute("version")
            $versionAttr.Value = $Version
            $dependency.Attributes.Append($versionAttr)
            $dependencies = $nuspec.SelectSingleNode("/package/metadata/dependencies")
            $dependencies.AppendChild($dependency)
        }
        $nuspec.Save($Path)
    }
}