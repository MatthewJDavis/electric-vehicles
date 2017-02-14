# creates a new Azure resource group for the electric cars project with tags for project and environment

$rgName = "elec-cars-dev-rg"
$location = "uksouth"
$project = "Electric Cars Azure functions" 
$env = "dev"

$params = @{
    "Name" = $rgName;
    "Location" = $location;
    "Tag" = @{"Project" = "$project"; "Env" = "$env"}
}

New-AzureRmResourceGroup @params