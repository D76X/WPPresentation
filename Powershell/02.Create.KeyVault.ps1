#----------------------------------------------------------------------------------------------------------------------------
# Setting up

# Must run as Admin

# Must log in some account
Connect-AzureRmAccount

# Find the subscriptions forthe account you are logged on
Get-AzureRmSubscription

# https://stackoverflow.com/questions/34928451/how-to-find-the-current-azure-rm-subscription
# https://blogs.msdn.microsoft.com/benjaminperkins/2017/08/02/how-to-set-azure-powershell-to-a-specific-azure-subscription/
Get-AzureRmContext
(Get-AzureRmContext).Subscription
Set-AzureRmContext -SubscriptionId "df17c9fe-de76-4143-bbae-77b75fa0705b"

#----------------------------------------------------------------------------------------------------------------------------
# Create a Resource Group
# https://docs.microsoft.com/en-us/powershell/module/azurerm.resources/new-azurermresourcegroup?view=azurermps-6.13.0
# https://app.pluralsight.com/player?course=microsoft-azure-resource-groups-using&author=gary-grudzinskas&name=a02863bf-68fa-4377-ba2f-7ae560f0cd22&clip=3&mode=live
$rgname = "wppres1rg1"
$loc = "West Europe"
New-AzureRmResourceGroup -Name $rgname -Location $loc
#----------------------------------------------------------------------------------------------------------------------------

# creating a new Azure Key Vault
# https://app.pluralsight.com/player?course=microsoft-azure-data-securing&author=reza-salehi&name=83d87507-3bef-4754-a046-46980dbdfc55&clip=3&mode=live
$kvname = "wppres1kv1"
New-AzureRmKeyVault -VaultName 'wppres1kv1' -ResourceGroupName $rgname -Location $loc
# VaultUri   : https://wppres1kv1.vault.azure.net
# ResourceId : /subscriptions/df17c9fe-de76-4143-bbae-77b75fa0705b/resourceGroups/wppres1rg1/providers/Microsoft.KeyVault/vaults/wppres1kv1
# VaultName  : wppres1kv1
#----------------------------------------------------------------------------------------------------------------------------

# convert our secret value to a "secure string"
$secretvalue = ConvertTo-SecureString –String 'myaddressbookplus.redis.cache.windows.net:6380,password=hQwiwqd+jij2nZZHzyW5AtawOTq71P4DkNn3n5BFPrw=,ssl=True,abortConnect=False' -AsPlainText -Force

# add the secure string to our new Key Vault
$secret = Set-AzureKeyVaultSecret -VaultName 'AddressBookPlusVault03' -Name 'CacheConnection' -SecretValue $secretvalue

$secret.Id

Set-AzureRmKeyVaultAccessPolicy -VaultName 'AddressBookPlusVault03' -ServicePrincipalName 386424df-c14a-4436-b872-f186ea2ddc98 -PermissionsToSecrets Get

