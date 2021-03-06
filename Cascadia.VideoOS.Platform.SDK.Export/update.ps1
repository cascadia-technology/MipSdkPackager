param([string] $MipSdkVersion, [string] $ManifestVersion, [string] $ReleaseNotes)

$name = (Get-Item $PSScriptRoot).Name
$binPath = "$($script:Config.MipSdkRepo)\$MipSdkVersion\Bin"
$targetsFileContent = '<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
    <ItemGroup>
        <NativeLibs Include="$(MSBuildThisFileDirectory)**\*.*" />
        <None Include="@(NativeLibs)">
        <Link>%(RecursiveDir)%(FileName)%(Extension)</Link>
        <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
        </None>
    </ItemGroup>
</Project>'

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

    if (Test-Path $PSScriptRoot\build) {
        Get-ChildItem $PSScriptRoot\build | Remove-Item -Recurse -Force
    } else {
        New-Item $PSScriptRoot\build -ItemType Directory
    }

    try {
        Push-Location $binPath
        . ".\CopyExportFiles.bat" $PSScriptRoot\build
        $targetsFileContent | Set-Content -Path "$PSScriptRoot\build\$name.targets"
    } finally {
        Pop-Location
    }
    
    $forbiddenFiles = @("Autofac.dll", "VideoOS.Platform.dll", "VideoOS.Platform.SDK.dll")
    foreach ($file in $forbiddenFiles) {
        if (Test-Path "$PSScriptRoot\build\$file") {
            Remove-Item "$PSScriptRoot\build\$file"
        }
    }

    Move-Item "$PSScriptRoot\build\VideoOS.Platform.SDK.Export.dll" "$PSScriptRoot\Bin"
    
    Set-NuspecProperty -Path "$PSScriptRoot\$name.nuspec" -Property version -Value $ManifestVersion
    if (![string]::IsNullOrEmpty($ReleaseNotes)) {
        Set-NuspecProperty -Path "$PSScriptRoot\$name.nuspec" -Property releaseNotes -Value $ReleaseNotes
        Set-NuspecDependency -Path "$PSScriptRoot\$name.nuspec" -Id Cascadia.VideoOS.Platform.SDK -Version $MipSdkVersion
    }
} catch {
    throw
}
