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
function Test-ApiResponse
{
    Param
    (
        [string]
        $Response
    )

    if($Response[2] -eq $false)
    {
        $Response[2] | Out-File -FilePath $path$fileName -Append -Force
        Set-ElectricVehicleBlob
        Send-ElectricVehicleResponse
        break
    }
}
