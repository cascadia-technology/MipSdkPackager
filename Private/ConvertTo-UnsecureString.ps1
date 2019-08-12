function ConvertTo-UnsecureString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "FromSecureString")]
        [securestring]
        $InputSecureString,
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "FromString")]
        [string]
        $InputString
    )

    process {
        if ($ParameterSetName -eq "FromSecureString") {
            (New-Object pscredential "dummy", $InputSecureString).GetNetworkCredential().Password
        } else {
            (New-Object pscredential "dummy", ($InputString | ConvertTo-SecureString)).GetNetworkCredential().Password
        }
    }
}