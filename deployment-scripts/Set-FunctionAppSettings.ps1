param (
   [string] $functionAppName,
   [string] $appServicePlan,
   [string] $resourceGroupName,
   [hashtable] $appsettings
)
# pass a hashtable to set webapp settings e.g. @{"apikey" = "myapikey"; "key" = "value"}
$params = @{
    'Name' = $functionAppName;
     'AppServicePlan' = $appServicePlan;
     'resourceGroupName' = $resourceGroupName;
     'AppSettings' = $appsettings
}

Set-AzureRmWebApp @params