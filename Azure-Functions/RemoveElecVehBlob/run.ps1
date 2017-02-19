Import-Module -Name Azure.Storage
$sasToken = $($env:sasstring)
$storAcctName = $($env:outStorAcctName)
$container = $($env:containername)

$ctx = New-AzureStorageContext -StorageAccountName $storAcctName -SasToken $sasToken 
$blobName = 'newElectricVehicles.JSON'

# Remove blob daily to comply with terms of service http://developer.edmunds.com/terms_of_service/index.html
Remove-AzureStorageBlob -Blob $blobName -Container $container -Context $ctx -Force

Write-Output "RemoveElecVehBlob function executed at:$(get-date)";