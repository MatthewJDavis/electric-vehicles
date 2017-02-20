Import-Module -Name Azure.Storage
$sasToken = $($env:sasstring)
$readSasToken = $($env:readsasstring)
$outStorAcctName = $($env:outStorAcctName)
$container = $($env:containername)
$key = $($env:apikey)
$fileName = $($env:outFileName)
$path = $($env:outFilePath)
$errorFileName = $($env:errorFileName)
$ctx = New-AzureStorageContext -StorageAccountName $outStorAcctName -SasToken $sasToken 

#check for requested year. Set to this year if no request or requested year is too far in the future
if ($req_query_year)
{
    $year = $req_query_year
    if ($year -gt (Get-Date).AddYears(1).Year)
    {
        $year = (Get-Date).Year
    }
} else
{
    $year = $year = (Get-Date).Year
}

#upload file to Azure storage
function Set-ElecVehicleBlob()
{    
    $blob = Set-AzureStorageBlobContent -File "$path$fileName" -Container $container -Blob $fileName -BlobType Block -Context $ctx -Force
}

function New-ApiQuery($uri) {
    try
    {
        $apiResponse = Invoke-RestMethod -Method Get -Uri $uri 
        Return $apiResponse
    }
    catch [System.Net.WebException]
    {
        $apiError = @()
        $apiError += 'Error calling Edumunds API'
        $apiError += $_.Exception.Message
        $apiError += $_.ErrorDetails.Message
        Return $apiError + $false
    }
}

# stop the function if there is an error returned and upload details to blob storage
function Test-ApiResponse($response)
{
    if($response[3] -eq $false)
    {
        $response[2] | Out-File -FilePath $path$fileName -Append -Force
        Set-ElecVehicleBlob
        break
    }
}




#create dir on server if not present
if (-not (Test-Path -Path $path) ){
    New-Item -Path $path -ItemType Directory
}

#get all the makes for the year requested
$makes = New-ApiQuery("https://api.edmunds.com/api/vehicle/v2/makes?state=new&year=$year&view=basic&fmt=json&api_key=$key")
Test-ApiResponse($makes)

#get all of the styles for the new models- not used because of API call limit of 25 calls per day
<#
$styles = @()

foreach ($model in $models)
{
    Write-Output $model
    $styles += New-ApiQuery("https://api.edmunds.com/api/vehicle/v2/$model/models?state=new&year=$year&view=basic&fmt=json&api_key=$key")
}
#>

#just get the styles of chevrolet due to API limit, should return 2 electric vehicles
$styles = New-ApiQuery("https://api.edmunds.com/api/vehicle/v2/chevrolet/models?state=new&year=$year&view=basic&fmt=json&api_key=$key")
Test-ApiResponse($styles)

#get engine details for styles and check for an error, if no error check if fuel type is electric and add to file
foreach ($id in $styles.models.years.styles.id)
{
    $id = $id.ToString()
       
    Start-Sleep -Seconds .25 # to prevent going over API rate limit
 
    $engine = New-ApiQuery("https://api.edmunds.com/api/vehicle/v2/styles/$id/engines?availability=standard&fmt=json&api_key=$key")
    
    Test-ApiResponse($engine)

    if ($engine.engines.fueltype -like "*electric*")
    {
        Write-Output "electric vehicle found"
        $elecVehicle = New-ApiQuery("https://api.edmunds.com/api/vehicle/v2/styles/$id?view=full&fmt=json&api_key=$key")
        $elecVehicle | ConvertTo-Json | Out-File -FilePath $path$fileName -Append -Force
    }   
}

Set-ElecVehicleBlob

Remove-Item -Path "$path$fileName" -Force

Out-File -Encoding ascii -FilePath $res -inputObject "Copy and paste the following link into your browser address bar to download the new electric vehicle file: https://$outStorAcctName.blob.core.windows.net/$container/$fileName$readSasToken "