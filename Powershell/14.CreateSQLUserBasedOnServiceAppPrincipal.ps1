# Refs
# https://docs.microsoft.com/en-us/cli/azure/sql/server/ad-admin?view=azure-cli-latest

$resourceGroupName = "wppres1rg1"
$location = "West Europe"          
$appServicePlanName = "wpserviceplan1"
$appServiceName ="04WebApp" 

# the applicationid can be used to get the principal Id
Get-AzureRmADApplication
Get-AzureRmADApplication -DisplayName $appServiceName 

# with the ApplicationId
Get-AzureRmADServicePrincipal -ApplicationId 9fc8020f-0a8b-4938-aea4-6168c00e5eef
# ------------------------------------------------------------
<#
ServicePrincipalNames : {https://davidespanoxgmail.onmicrosoft.com/04WebApp_201
                        90511300129, 9fc8020f-0a8b-4938-aea4-6168c00e5eef}
ApplicationId         : 9fc8020f-0a8b-4938-aea4-6168c00e5eef
DisplayName           : 04WebApp
Id                    : c9a09003-0e7b-4001-8207-d0273be7f6b0
AdfsId                : 
Type                  : ServicePrincipal
#>
# ------------------------------------------------------------

# This is the command in AzureCLI run on the portal
az sql server ad-admin create --resource-group wppres1rg1 --server-name wppres1sqlserver1 --display-name msiadmin --object-id c9a09003-0e7b-4001-8207-d0273be7f6b0

# and I got back this

<#
{
  "id": "/subscriptions/df17c9fe-de76-4143-bbae-77b75fa0705b/resourceGroups/wppres1rg1/providers/Microsoft.Sql/servers/wppres1sqlserver1/administratorOperationResults/ActiveDirectory",
  "kind": null,
  "location": "West Europe",
  "login": "msiadmin",
  "name": "ActiveDirectory",
  "resourceGroup": "wppres1rg1",
  "sid": "c9a09003-0e7b-4001-8207-d0273be7f6b0",
  "tenantId": "981b07d1-b261-4c3e-a400-b86f7809d9bc",
  "type": "Microsoft.Sql/servers/administrators"
}
#>

# This can be seen in the portal in the Active Directory Admin blade
# of the SQL Server Instance
https://docs.microsoft.com/en-us/azure/key-vault/service-to-service-authentication#connection-string-support
https://github.com/Microsoft/vscode-mssql/issues/1159
https://social.msdn.microsoft.com/Forums/en-US/fb10d843-3728-4e23-87ba-01b017e8dfb5/need-support-configure-azure-sql-database-with-azure-active-directory-integrated-authentication?forum=ssdsgetstarted
https://localhost:44337/signin-oidc
https://localhost:44337/
https://www.youtube.com/watch?v=TW1_9eIIFyU
https://stackoverflow.com/questions/50011686/aadsts50011-the-reply-url-specified-in-the-request-does-not-match-the-reply-url