<#
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
#>
Import-Module C:\git\electric-vehicles\Azure-Functions\GetNewElectricVehicle\modules\PSNewElectricVehicles.psm1

Describe "PSNewElectricVehicles" {
    Context year{
        It "Returns the year 2018" {
            Test-Year -Year 2018 | Should Be 2018
        }
        It 'Returns the year 2017' {
            Test-Year -Year 2019 | Should Be 2017
        }
        It 'Returns this year' {
            Test-Year -Year (Get-Date).Year | Should Be (Get-Date).Year
        }
        It 'Returns this is year if nothing is passed to it' {
            Test-Year | Should Be (Get-Date).Year
        }
    }
}
