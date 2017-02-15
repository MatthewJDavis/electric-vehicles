Import-Module -Name Azure.Storage
$sasToken = $($env:sasstring)
$outStorAcctName = $($env:outStorAcctName)
$container = $($env:containername)
$ctx = New-AzureStorageContext -StorageAccountName $outStorAcctName -SasToken $sasToken 
$fileName = 'newElectricVehicles.JSON'
$path = 'D:\home\site\temp\'

# create dummy file - this will be json returned from API
New-Item "$path$fileName" -ItemType file -Value "test" -Force

$blob = Set-AzureStorageBlobContent -File "$path$fileName" -Container $container -Blob $fileName -BlobType Block -Context $ctx -Force

Remove-Item -Path "$path$fileName" -Force

Out-File -Encoding ascii -FilePath $res -inputObject "Copy and paste the following link into your browser address bar to download the new electric vehicle file: https://$outStorAcctName.blob.core.windows.net/$container/$fileName$sasToken "