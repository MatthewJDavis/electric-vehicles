<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Send-ElectricVehicleResponse
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [string]
        $FilePath = $Res,
        [string]
        $OutStorAcctName,
        [string]
        $Container,
        [string]
        $FileName,
        [string]
        $ReadSasToken
    )
    Out-File -Encoding ascii -FilePath $Res -inputObject "Copy and paste the following link into your browser address bar to download the new electric vehicle file: https://$OutStorAcctName.blob.core.windows.net/$Container/$FileName$ReadSasToken "
}
