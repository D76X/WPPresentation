# Refs
# https://docs.microsoft.com/en-us/powershell/module/azurerm.keyvault/get-azurermkeyvault?view=azurermps-6.13.0

#----------------------------------------------------------------------------------------------------------------------------
Get-AzureRmKeyVault
#----------------------------------------------------------------------------------------------------------------------------
#ResourceId        : /subscriptions/df17c9fe-de76-4143-bbae-77b75fa0705b/resourceGroups/wppres1rg1/providers/Microsoft.KeyVault/vaults/wppres1kv1
#VaultName         : wppres1kv1
#ResourceGroupName : wppres1rg1
#Location          : westeurope
#Tags              : {}
#TagsTable         : 

#----------------------------------------------------------------------------------------------------------------------------
# all info on the key vault and its access policies
Get-AzureRmKeyVault -VaultName 'wppres1kv1'
#----------------------------------------------------------------------------------------------------------------------------
# ResourceId                   : /subscriptions/df17c9fe-de76-4143-bbae-77b75fa0705b/resourceGroups/wppres1rg1/providers/Microsoft.KeyVault/vaults/wppres1kv1

# Others
Get-AzureRmKeyVault -ResourceGroupName 'wppres1rg1'
Get-AzureRmKeyVault -InRemovedState
Get-AzureRMKeyVault -VaultName 'wppres1kv1'  -Location 'westeurope' -InRemovedState

#----------------------------------------------------------------------------------------------------------------------------
# Query for Secrets, Certificates & Keys
# https://docs.microsoft.com/en-us/powershell/module/azurerm.keyvault/get-azurekeyvaultsecret?view=azurermps-6.13.0
Get-AzureKeyVaultSecret -VaultName 'wppres1kv1'
Get-AzureKeyVaultCertificate -VaultName 'wppres1kv1'
Get-AzureKeyVaultKey -VaultName 'wppres1kv1'
#----------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------
# Query for Secrets, Certificates & Keys with versions
$keyName = (Get-AzureKeyVaultKey -VaultName 'wppres1kv1')[0].Name
$keyName
Get-AzureKeyVaultKey -VaultName 'wppres1kv1'-Name $keyName -IncludeVersions
#----------------------------------------------------------------------------------------------------------------------------
#Version       : 2b357df702d040d697debf4e75f691f9
#Id            : https://wppres1kv1.vault.azure.net:443/keys/KeyFromCert/2b357df702d040d697debf4e75f691f9