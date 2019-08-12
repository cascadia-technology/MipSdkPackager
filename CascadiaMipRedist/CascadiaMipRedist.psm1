$MipSdkPath = (Get-Item "$PSScriptRoot\bin").FullName
if ($ENV:Path -notlike "*$MipSdkPath*") {
    $ENV:Path = "$($ENV:Path);$MipSdkPath"
}

foreach ($dll in Get-ChildItem "$MipSdkPath\*.dll") {
    try {
        Add-Type -Path $dll.FullName -ErrorAction Stop
        
    } catch {
    }
}

Export-ModuleMember -Variable MipSdkPath