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

Test-Year -Year $req_query_year

#create dir on server if not present
if (-not (Test-Path -Path $path) ){
    New-Item -Path $path -ItemType Directory
}

#get all the makes for the year requested
$makes = New-ApiQuery("https://api.edmunds.com/api/vehicle/v2/makes?state=new&year=$year&view=basic&fmt=json&api_key=$key")
Test-ApiResponse($makes)
Start-Sleep -Milliseconds 500 # to prevent going over API CPS rate limit 

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

Start-Sleep -Milliseconds 500 # to prevent going over API CPS rate limit 

#get engine details for styles and check for an error, if no error check if fuel type is electric and add to file
foreach ($id in $styles.models.years.styles.id)
{
    $id = $id.ToString()
       
    Start-Sleep -Milliseconds 300 # to prevent going over API CPS rate limit
 
    $engine = New-ApiQuery("https://api.edmunds.com/api/vehicle/v2/styles/$id/engines?availability=standard&fmt=json&api_key=$key")
    
    Test-ApiResponse($engine)

    if ($engine.engines.fueltype -like "*electric*")
    {
        Write-Output "electric vehicle found"
        $elecVehicle = New-ApiQuery("https://api.edmunds.com/api/vehicle/v2/styles/$id`?view=full&fmt=json&api_key=$key")
        $elecVehicle | ConvertTo-Json | Out-File -FilePath $path$fileName -Append -Force
    }   
}

Set-ElectricVehicleBlob
Send-ElectricVehicleResponse

Remove-Item -Path "$path$fileName" -Force

