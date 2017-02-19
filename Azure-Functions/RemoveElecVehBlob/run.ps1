Import-Module -Name Azure.Storage
$sasToken = $($env:sasstring)
$storAcctName = $($env:outStorAcctName)
$container = $($env:containername)
$ctx = New-AzureStorageContext -StorageAccountName $storAcctName -SasToken $sasToken 
$blobName = 'newElectricVehicles.JSON'

# Remove blob daily to comply with terms of service http://developer.edmunds.com/terms_of_service/index.html
$blob = Get-AzureStorageBlob -Container $container -Context $ctx | Where-Object -Property Name -eq $blobName


if ($blob -ne $null)
{
    Write-Output "$blobName found - deleted"
    Remove-AzureStorageBlob -Blob $blobName -Container $container -Context $ctx -Force
} else
{
    Write-Output "$blobName was not found"
}
Write-Output "RemoveElecVehBlob function executed at:$(get-date)"