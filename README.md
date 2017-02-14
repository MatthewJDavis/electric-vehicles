# Introduction 
This project uses Azure functions, PowerShell and the edmunds API to look up all the new electric vehicles on the market. 

# Getting Started
The function is invoked via an http request and looks up vehicle data from the edmunds API.
The vehicles are evaluated by engine type to select only electric powered ones.
These are written to a JSON file which is uploaded to Azure blob storage for download.

There is a limit of 25 API calls per day placed on the edmunds API so not all vehicle data will be returned.

# Build and Release
The function will be deployed to Azure via Visual Studio Team Services build and release.

# Useful Links
[Azure functions](https://docs.microsoft.com/en-us/azure/azure-functions)
[edmunds API](http://developer.edmunds.com/api-documentation/overview/)
