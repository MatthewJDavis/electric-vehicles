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
        $Response
    )

    if ($Response[1] -eq $false) {
    $errorMessage = $Response[1] | ConvertFrom-Json
    $errorMessage | ConvertTo-Json | Out-File -FilePath $path$fileName -Append -Force
    Return $false
    }
}
