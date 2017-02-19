Import-Module -Name Azure.Storage
$sasToken = $($env:sasstring)
$outStorAcctName = $($env:outStorAcctName)
$container = $($env:containername)
$key = $($env:apikey)
$fileName = $($env:outFileName)
$path = $($env:tempDirPath)
$ctx = New-AzureStorageContext -StorageAccountName $outStorAcctName -SasToken $sasToken 

function New-ApiQuery($uri) {
    try
    {
        $apiResponse = Invoke-RestMethod -Method Get -Uri $uri 
        Return $apiResponse
    }
    catch [System.Net.WebException]
    {
        Write-Output 'Error calling Edumunds API'
        Write-Output $_.Exception.Message
        Write-Output $_.ErrorDetails.Message
        Return $false
    }
}

# create dir on server if not present
if (-not (Test-Path -Path $path) ){
    New-Item -Path $path -ItemType Directory
}

#get all the makes for 2017
$makes = New-ApiQuery("https://api.edmunds.com/api/vehicle/v2/makes?state=new&year=2017&view=basic&fmt=json&api_key=$key")

#get all of the styles for the new models in 2017
$styles = New-ApiQuery("https://api.edmunds.com/api/vehicle/v2/chevrolet/models?state=new&year=2017&view=basic&fmt=json&api_key=$key")

# code to get engine details here
foreach ($id in $styles.models.years.styles.id)
{
    $id = $id.ToString()
       
    Start-Sleep -Seconds 1 # to prevent going over rate limit
 
    $engine = New-ApiQuery("https://api.edmunds.com/api/vehicle/v2/styles/$id/engines?availability=standard&fmt=json&api_key=$key")
 
    if ($engine.engines.fueltype -like "*electric*")
    {
        Write-Output "electric"
        $elecVehicle = New-ApiQuery("https://api.edmunds.com/api/vehicle/v2/styles/$id?view=full&fmt=json&api_key=$key")
        $elecVehicle | ConvertTo-Json | Out-File -FilePath $path$fileName -Append -Force
    }   
}
# create a file with the data returned from the API query
$makes | ConvertTo-Json | Out-File "$path$fileName" -Force

#upload file to Azure storage
$blob = Set-AzureStorageBlobContent -File "$path$fileName" -Container $container -Blob $fileName -BlobType Block -Context $ctx -Force

# Remove-Item -Path "$path$fileName" -Force

Out-File -Encoding ascii -FilePath $res -inputObject "Copy and paste the following link into your browser address bar to download the new electric vehicle file: https://$outStorAcctName.blob.core.windows.net/$container/$fileName$sasToken "