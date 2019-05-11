# ----------------------------------------------------------------------------------------------
# Create an Azure App Service Web App
# Refs
# https://blogs.msdn.microsoft.com/benjaminperkins/2017/10/02/create-an-azure-app-service-web-app-using-powershell/
# https://blogs.msdn.microsoft.com/benjaminperkins/2014/10/01/azure-website-hosting-plans-whp/
# https://www.youtube.com/watch?v=jCfJWYocz1M
# ----------------------------------------------------------------------------------------------
Login-AzureRmAccount
Set-AzureRmContext -Subscription "df17c9fe-de76-4143-bbae-77b75fa0705b"

$resourceGroupName = "wppres1rg1"
$location = "West Europe"          
$appServicePlanName = "wpserviceplan1"
$appServiceName ="04WebApp"

New-AzureRmAppServicePlan -ResourceGroupName $resourceGroupName `
-Location $location `
-Tier Free `
-Name $appServicePlanName

New-AzureRmWebApp -ResourceGroupName $resourceGroupName `
-Location $location `
-AppServicePlan $appServicePlanName `
-Name $appServiceName `

Get-AzureRmWebApp