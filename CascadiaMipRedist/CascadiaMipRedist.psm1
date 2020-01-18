$MipSdkPath = (Get-Item "$PSScriptRoot\bin").FullName
if ($ENV:Path -notlike "*$MipSdkPath*") {
    $ENV:Path = "$($ENV:Path);$MipSdkPath"
}

foreach ($dll in Get-ChildItem "$MipSdkPath\*.dll") {
    try {
        $null = [System.Reflection.Assembly]::LoadFrom($dll.FullName)
    } catch {
    }
}

Export-ModuleMember -Variable MipSdkPath