Login-AzureRmAccount
Set-AzureRmContext -Subscription "df17c9fe-de76-4143-bbae-77b75fa0705b"

#------------------------------------------------------------------------------
#Azure Active Directory PowerShell module.
Install-Module AzureAD

#Verify the installed versions of the modules.
Get-Module AzureRM -ListAvailable | Select-Object -Property Name,Version,Path
Get-Module AzureAD -ListAvailable | Select-Object -Property Name,Version,Path

#------------------------------------------------------------------------------

#connect to Azure
Connect-AzureRmAccount

# --------------------------------------------------------------------------------
# Create a VM
# --------------------------------------------------------------------------------

# --------------------------------------------------------------------------------
# Enable Azure Disk Encryption on the VM
# --------------------------------------------------------------------------------

$resourceGroupName = "wppres1rg1"
$location = "West Europe"

$kvName = 'wppres1kv1'
$rgName = "wppres1rg1"
$aadClientSecret = 'z]lNB8o_GgZA0DHw0MKx.kVZ:XNfANs1'
$appDisplayName = 'AppUsedToRetrieveADEkeyForVM1'
$vmName = 'MyVM1'

$kv = Get-AzureRmKeyVault -VaultName $kvName -ResourceGroupName $rgName
$kvUri = $kv.VaultUri
$kvRID = $kv.ResourceId

$aadApp = Get-AzureRmADApplication -DisplayName $appDisplayName
$appID = $aadApp.ApplicationId


Set-AzureRmVMDiskEncryptionExtension -ResourceGroupName $rgName -VMName $vmName -AadClientID $appID -AadClientSecret $aadClientSecret -DiskEncryptionKeyVaultUrl $kvUri -DiskEncryptionKeyVaultId $kvRID -VolumeType Data

Get-AzureRmVMDiskEncryptionStatus -VMName $vmName -ResourceGroupName $rgName

https://stackoverflow.com/questions/47301391/set-azurermvmdiskencryptionextension-long-running-operation

Set-AzureRmVMDiskEncryptionExtension : Long running operation failed with status 'Failed'. Additional Info:'VM has reported a failure when processing 
extension 'AzureDiskEncryption'. Error message: "Encryption operations on data volume need encryption to be enabled OS volume first".'
ErrorCode: VMExtensionProvisioningError
ErrorMessage: VM has reported a failure when processing extension 'AzureDiskEncryption'. Error message: "Encryption operations on data volume need encryption 
to be enabled OS volume first".
StartTime: 5/17/2019 5:49:12 PM
EndTime: 5/17/2019 5:50:04 PM
OperationID: bb884648-07c1-42fb-81ec-0e0eac90da03
Status: Failed
At line:1 char:1
+ Set-AzureRmVMDiskEncryptionExtension -ResourceGroupName $rgName -VMNa ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : CloseError: (:) [Set-AzureRmVMDiskEncryptionExtension], ComputeCloudException
    + FullyQualifiedErrorId : Microsoft.Azure.Commands.Compute.Extension.AzureDiskEncryption.SetAzureDiskEncryptionExtensionCommand