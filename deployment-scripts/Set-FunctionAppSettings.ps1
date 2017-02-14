param (
   [string] $functionAppName,
   [string] $appServicePlan,
   [string] $resourceGroupName,
   [hashtable] $appsettings
)

$params = @{
    'Name' = $functionAppName;
     'AppServicePlan' = $appServicePlan;
     'resourceGroupName' = $resourceGroupName;
     'AppSettings' = $appsettings
}

Set-AzureRmWebApp @params