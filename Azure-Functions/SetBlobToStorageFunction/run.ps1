Import-Module -Name Azure.Storage
$sasToken = $($env:sasstring)
$storageAccountName = $($env:storagename)
$container = $($env:containername)
$ctx = New-AzureStorageContext -StorageAccountName $storageAccountName -SasToken $sasToken 
$fileName = 'newElectricVehicles.JSON'
$path = 'D:\home\site\temp'

# create dummy file - this will be json returned from API
New-Item "$path\test.JSON" -ItemType file -Value "test" -Force

$blob = Set-AzureStorageBlobContent -File D:\home\site\temp\test.txt -Container $container -Blob $fileName -BlobType Block -Context $ctx -Force

Remove-Item -Path "$path\test.JSON" -Force

Out-File -Encoding ascii -FilePath $res -inputObject "Copy and paste the following link into your browser address bar to download the new electric vehicle file: https://$storageAccountName.blob.core.windows.net/$container/$file$sasToken "