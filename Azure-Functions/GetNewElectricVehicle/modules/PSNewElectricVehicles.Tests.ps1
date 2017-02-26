$ThisModule = "$($MyInvocation.MyCommand.Path -replace '\.Tests\.ps1$', '').psm1"
$ThisModuleName = (($ThisModule | Split-Path -Leaf) -replace '\.psm1')
Get-Module -Name $ThisModuleName -All | Remove-Module -Force
Import-Module -Name $ThisModule -Force -ErrorAction Stop

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
