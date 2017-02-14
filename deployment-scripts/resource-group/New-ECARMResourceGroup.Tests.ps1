$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-ResourceGroup" {
    BeforeAll{
        $rg = Get-AzureRmResourceGroup -Name 'elec-cars-test-rg'
    }

    Context 'ResourceGroup Test' {
        It 'Resource Group Name should be  elec-cars-test-rg' {
            $rg.ResourceGroupName | Should Be 'elec-cars-test-rg'
        }
        It 'Resource Group should be located in uksouth region' {
            $rg.Location | Should Be 'uksouth'
        }
        It 'Has a project tag of Electric Cars Azure functions' {
            $rg.Tags.Project | Should Be 'Electric Cars Azure functions'
        }
        It 'Has an env tag to dev' {
            $rg.Tags.Env | Should Be 'dev'
        }
    }

    
}