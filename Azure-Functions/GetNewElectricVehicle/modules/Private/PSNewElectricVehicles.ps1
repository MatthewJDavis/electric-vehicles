<#
.Synopsis
   Checks the year and makes sure it is not one greater than one year in advanced
.DESCRIPTION
   Used in PSNewElectricVehicle module to check that the year submitted it not greater than one year in advanced. It will set and return the current year if
   there is no year input or the year is more than a year in advanced.
.EXAMPLE
   Test-Year
   Returns the current year
.EXAMPLE
   Test-Year -Year 2015
   Returns 2015
.Example
    Test-Year -Year (Get-Date).AddYears(2).Year
    Returns the current year
.Example
    Test-Year -Year (Get-Date).AddYears(1).Year
    Returns next year
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