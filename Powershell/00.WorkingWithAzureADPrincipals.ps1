#need to get the service principal of the thing to grant access to
Get-AzureRmADServicePrincipal 
Get-AzureRmADServicePrincipal -SearchString '04WebApp'
Get-AzureRmADServicePrincipal -ServicePrincipalName 'https://davidespanoxgmail.onmicrosoft.com/04WebApp'

#for some operation an Azure artifact needs to have a principal 
#associated to it. One can be created from its ObjectID and DisplayName
Get-AzureRmResource -ResourceName '04WebApp' -ResourceGroupName $rgname

# Updates an existing azure active directory service principal
Set-AzureRmADServicePrincipal `
-ObjectId 784136ca-3ae2-4fdd-a388-89d793e7c780 `
-DisplayName "UpdatedNameForSp" 
