Import-Module -Name Azure.Storage
$sasToken = $($env:sasstring)
$outStorAcctName = $($env:outStorAcctName)
$container = $($env:containername)
$key = $($env:apikey)

$ctx = New-AzureStorageContext -StorageAccountName $outStorAcctName -SasToken $sasToken 
$fileName = 'newElectricVehicles.JSON'
$path = 'D:\home\site\temp\'

function New-ApiQuery($uri) {
    try
    {
        $apiResponse = Invoke-RestMethod -Method Get -Uri $uri 
        Return $apiResponse
    }
    catch 
    {
        Write-Output "${in}: Error calling API"
        Return $false
    }
}

# create dir on server if not present
if (-not (Test-Path -Path $path) ){
    New-Item -Path $path -ItemType Directory
}

#get all the makes for 2017
$makes = New-ApiQuery("https://api.edmunds.com/api/vehicle/v2/makes?state=new&year=2017&view=basic&fmt=json&api_key=$key")


# create a file with the data returned from the API query
$makes | ConvertTo-Json | Out-File "$path$fileName" -Force

$blob = Set-AzureStorageBlobContent -File "$path$fileName" -Container $container -Blob $fileName -BlobType Block -Context $ctx -Force

Remove-Item -Path "$path$fileName" -Force

Out-File -Encoding ascii -FilePath $res -inputObject "Copy and paste the following link into your browser address bar to download the new electric vehicle file: https://$outStorAcctName.blob.core.windows.net/$container/$fileName$sasToken "