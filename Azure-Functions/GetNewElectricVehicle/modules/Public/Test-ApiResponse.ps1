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
        $Response,
        [string]
        $Path,
        [string]
        $FileName
    )

    if ($Response[2] -eq $false) {
    $errorMessage = $Response[1] | ConvertFrom-Json
    $errorMessage | ConvertTo-Json | Out-File -FilePath $Path$FileName -Append -Force
    Return $false
    }
}
