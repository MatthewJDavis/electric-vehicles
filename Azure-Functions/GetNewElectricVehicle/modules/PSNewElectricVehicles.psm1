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
function Test-Year
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([string])]
    Param
    (
        [string]
        $Year = (Get-Date).Year
    )
    if ($Year -gt (Get-Date).AddYears(1).Year)
    {
        $Year = (Get-Date).Year
    }
    Return $Year
}