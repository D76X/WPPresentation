#----------------------------------------------------------------------------------------------------------------------------
# Setting up

# Must run as Admin

# Must log in some account
Connect-AzureRmAccount
# ----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------
# Geat&SetSubscriptionContextForAzureAccount
# Find the subscriptions forthe account you are logged on
Get-AzureRmSubscription

# https://stackoverflow.com/questions/34928451/how-to-find-the-current-azure-rm-subscription
# https://blogs.msdn.microsoft.com/benjaminperkins/2017/08/02/how-to-set-azure-powershell-to-a-specific-azure-subscription/
Get-AzureRmContext
(Get-AzureRmContext).Subscription
Set-AzureRmContext -SubscriptionId "df17c9fe-de76-4143-bbae-77b75fa0705b"
# ----------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------
# Create a Resource Group
# https://docs.microsoft.com/en-us/powershell/module/azurerm.resources/new-azurermresourcegroup?view=azurermps-6.13.0
# https://app.pluralsight.com/player?course=microsoft-azure-resource-groups-using&author=gary-grudzinskas&name=a02863bf-68fa-4377-ba2f-7ae560f0cd22&clip=3&mode=live
$rgname = "wppres1rg1"
$loc = "West Europe"
New-AzureRmResourceGroup -Name $rgname -Location $loc
#----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------
# creating a new Azure Key Vault
# https://app.pluralsight.com/player?course=microsoft-azure-data-securing&author=reza-salehi&name=83d87507-3bef-4754-a046-46980dbdfc55&clip=3&mode=live
$kvname = "wppres1kv1"
New-AzureRmKeyVault -VaultName 'wppres1kv1' -ResourceGroupName $rgname -Location $loc
# VaultUri   : https://wppres1kv1.vault.azure.net
# ResourceId : /subscriptions/df17c9fe-de76-4143-bbae-77b75fa0705b/resourceGroups/wppres1rg1/providers/Microsoft.KeyVault/vaults/wppres1kv1
# VaultName  : wppres1kv1
#----------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------
# First have a look what is on the key vault already
$kvname = "wppres1kv1"
# all info on the key vault and its access policies
Get-AzureRmKeyVault -VaultName 'wppres1kv1'
#----------------------------------------------------------------------------------------------------------------------------
# Query for Secrets, Certificates & Keys
# https://docs.microsoft.com/en-us/powershell/module/azurerm.keyvault/get-azurekeyvaultsecret?view=azurermps-6.13.0
Get-AzureKeyVaultSecret -VaultName $kvname
Get-AzureKeyVaultCertificate -VaultName $kvname
Get-AzureKeyVaultKey -VaultName $kvname 
# ----------------------------------------------------------------
$keyName = (Get-AzureKeyVaultKey -VaultName $kvname)[0].Name
$keyName
Get-AzureKeyVaultKey -VaultName $kvname -Name $keyName -IncludeVersions
# ----------------------------------------------------------------
$secretName = (Get-AzureKeyVaultSecret -VaultName $kvname)[0].Name
$secretName
Get-AzureKeyVaultSecret -VaultName $kvname -Name $secretName -IncludeVersions
#----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------
# send to and store on securely a secret on Azure Key Vault 
# convert our secret value to a "secure string"
$secretvalue = ConvertTo-SecureString –String 'This is an important secret!' -AsPlainText -Force
$secretname = "importantsecret1"
# add the secure string to our new Key Vault
$secret = Set-AzureKeyVaultSecret -VaultName $kvname -Name "importantsecret1" -SecretValue $secretvalue
$secret.Id

# --------------------------------------------------------------------------------------
# Application Registration with Azure AD
# Name : 01KeyVaultApp
# Application(client) ID: 3da2ec55-4670-4e30-b7f2-6c4a29ec9a3f
# Directory(tenant) ID : 981b07d1-b261-4c3e-a400-b86f7809d9bc
# Object ID : 2458fef3-3247-4fb2-a3ab-e144b93d1818
# Supported account types : My organization only
# Redirect URIs :Add a Redirect URI
# Managed application in local directory :01KeyVaultApp
# --------------------------------------------------------------------------------------
# # Application Registration with Azure AD - Create a new Key
# Se also Certificates and Secrets tab
# Application Secret (aka Client Secret)
# /nKN++8?2m2LUUTdWva5bwcZHR__slTr
# --------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------
# https://stackoverflow.com/questions/2608144/how-to-split-long-commands-over-multiple-lines-in-powershell
# Access Policies on Azure Key Vault
$kvname = "wppres1kv1"
(Get-AzureRmKeyVault -VaultName "wppres1kv1").AccessPolicies
# set the access policy 
Set-AzureRmKeyVaultAccessPolicy -VaultName $kvname `
-ServicePrincipalName 386424df-c14a-4436-b872-f186ea2ddc98 `
-PermissionsToSecrets Get
# ----------------------------------------------------------------------------------------------------------------------------
