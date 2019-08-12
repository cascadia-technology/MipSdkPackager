param([string] $MipSdkVersion, [string] $ManifestVersion, [string] $ReleaseNotes)

$name = (Get-Item $PSScriptRoot).Name
$binPath = "$($script:Config.MipSdkRepo)\$MipSdkVersion\Bin"
try {
    Get-ChildItem $PSScriptRoot\Bin -Recurse | Remove-Item -Recurse -Force
    Copy-Item $binPath\* $PSScriptRoot\Bin -Recurse
    $fileList = Get-ChildItem $PSScriptRoot\Bin\* -Recurse | ForEach-Object { 
        if (!$_.Attributes.HasFlag([System.IO.FileAttributes]::Directory)) {
            $_.FullName.Replace($PSScriptRoot, ".")
        } 
    }
    $params = @{
        RootModule = "$name.psm1"
        ModuleVersion = $ManifestVersion
        Guid = "48d002c9-c6f3-4c1b-ae27-4287ca03bf8d"
        Author = "Joshua Hendricks"
        CompanyName = "Cascadia Technology LLC"
        Copyright = "(c) 2019 Cascadia Technology LLC. All rights reserved."
        Description = "Unofficial and unmodified redistributable Milestone MIP SDK binaries packaged for use with PowerShell scripts and modules."
        DotNetFrameworkVersion = "4.7"
        ProcessorArchitecture = "Amd64"
        VariablesToExport = "MipSdkPath"
        FileList = $fileList
        ReleaseNotes = $ReleaseNotes
        IconUri = "https://www.cascadia.tech/wp-content/uploads/2019/08/CascadiaIcon_white.ico"
        ProjectUri = "https://doc.developer.milestonesys.com/html/index.html"
        Tags = @('Milestone', 'MIPSDK', 'XProtect')
    }
    if (Test-Path "$PSScriptRoot\$name.psd1") {
        Remove-Item "$PSScriptRoot\$name.psd1"
    }
    New-ModuleManifest -Path "$PSScriptRoot\$name.psd1" @params
} catch {
    throw
}
