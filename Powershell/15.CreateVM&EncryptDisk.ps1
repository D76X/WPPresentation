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

#------------------------------------------------------------------------------

# Refs
# https://docs.microsoft.com/en-us/azure-stack/user/azure-stack-quick-create-vm-windows-powershell

#------------------------------------------------------------------------------

# Step 1 - Create storage resources

$resourceGroupName = "wppres1rg1"
$location = "West Europe"
$storageAccountName = "wppres1sa2"
$storageAccountSkuName = "Standard_LRS" # https://docs.microsoft.com/en-us/rest/api/storagerp/skus/list

# Create a new storage account
$storageAccount = New-AzureRMStorageAccount `
  -Location $location `
  -ResourceGroupName $resourceGroupName `
  -Type $storageAccountSkuName `
  -Name $storageAccountName

# modifies the current Azure Storage account of the specified Azure subscription in Azure PowerShell. 
# The current Storage account is used as the default when you access Storage without specifying a 
# Storage account name
Set-AzureRmCurrentStorageAccount `
  -StorageAccountName $storageAccountName `
  -ResourceGroupName $resourceGroupName

# -----------------------------------------------------------------------------

# Step 2 - Create networking resources for the VM

# Create a subnet configuration
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig `
  -Name mySubnet `
  -AddressPrefix 192.168.1.0/24

# Create a virtual network
$vnet = New-AzureRmVirtualNetwork `
  -ResourceGroupName $resourceGroupName `
  -Location $location `
  -Name MyVnet `
  -AddressPrefix 192.168.0.0/16 `
  -Subnet $subnetConfig

# Create a public IP address and specify a DNS name
$pip = New-AzureRmPublicIpAddress `
  -ResourceGroupName $resourceGroupName `
  -Location $location `
  -AllocationMethod Static `
  -IdleTimeoutInMinutes 4 `
  -Name "mypublicdns$(Get-Random)"

# -----------------------------------------------------------------------------

# Step 3 - Create a network security group and a network security group and rules for inbound traffic

# NSG secures the virtual machine by using inbound and outbound rules.
# create an inbound rule for port 3389  and an inbound rule for port 80 

# Create an inbound network security group rule for port 3389
# to allow incoming Remote Desktop connections RDP
$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig `
  -Name myNetworkSecurityGroupRuleRDP `
  -Protocol Tcp `
  -Direction Inbound `
  -Priority 1000 `
  -SourceAddressPrefix * `
  -SourcePortRange * `
  -DestinationAddressPrefix * `
  -DestinationPortRange 3389 `
  -Access Allow

# Create an inbound network security group rule for port 80
# to allow incoming web traffic.
$nsgRuleWeb = New-AzureRmNetworkSecurityRuleConfig `
  -Name myNetworkSecurityGroupRuleWWW `
  -Protocol Tcp `
  -Direction Inbound `
  -Priority 1001 `
  -SourceAddressPrefix * `
  -SourcePortRange * `
  -DestinationAddressPrefix * `
  -DestinationPortRange 80 `
  -Access Allow

# Create a network security group
$nsg = New-AzureRmNetworkSecurityGroup `
  -ResourceGroupName $resourceGroupName `
  -Location $location `
  -Name myNetworkSecurityGroup `
  -SecurityRules $nsgRuleRDP,$nsgRuleWeb

# -----------------------------------------------------------------------------

# Step 4 - Create a network card for the virtual machine

# The network card connects the virtual machine to a subnet, network security group, and public IP address.
# Create a virtual network card and associate it with public IP address and NSG
$nic = New-AzureRmNetworkInterface `
  -Name myNic `
  -ResourceGroupName $ResourceGroupName `
  -Location $location `
  -SubnetId $vnet.Subnets[0].Id `
  -PublicIpAddressId $pip.Id `
  -NetworkSecurityGroupId $nsg.Id

# -----------------------------------------------------------------------------

# Step 5 - Create the virtual machine configuration and a VM

# Define a credential object to store the username and password for the virtual machine
$UserName='dspano'
$Password='Password@123'| ConvertTo-SecureString -Force -AsPlainText
$Credential=New-Object PSCredential($UserName,$Password)

# ---------------------------------------------------------------------------
# Create the virtual machine configuration object
# We choose the smalest possible size of the VM
# also remember to switch it off to save money
# https://buildazure.com/2017/03/16/properly-shutdown-azure-vm-to-save-money/
# ---------------------------------------------------------------------------
$VmName = "wppres1Vm1"
$VmSize = "Standard_B1ls" # https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-general
# https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage
$vmSkuName = '2016-Datacenter'

$VirtualMachine = New-AzureRmVMConfig `
  -VMName $VmName `
  -VMSize $VmSize

$VirtualMachine = Set-AzureRmVMOperatingSystem `
  -VM $VirtualMachine `
  -Windows `
  -ComputerName "MyWindowsPC" `
  -Credential $Credential

$VirtualMachine = Set-AzureRmVMSourceImage `
  -VM $VirtualMachine `
  -PublisherName "MicrosoftWindowsServer" `
  -Offer "WindowsServer" `
  -Skus $vmSkuName `
  -Version "latest"


# Sets the operating system disk properties on a virtual machine.
$VirtualMachine = Set-AzureRmVMOSDisk `
  -VM $VirtualMachine `
  -CreateOption FromImage | `
  Set-AzureRmVMBootDiagnostics -ResourceGroupName $resourceGroupName `
  -StorageAccountName $storageAccountName -Enable |`
  Add-AzureRmVMNetworkInterface -Id $nic.Id

# Create the virtual machine.
New-AzureRmVM `
  -ResourceGroupName $ResourceGroupName `
  -Location $location `
  -VM $VirtualMachine

# -----------------------------------------------------------------------------

# Step 6 - Connect to the virtual machine

#  you need the Vm'S public IP address
Get-AzureRmPublicIpAddress -ResourceGroupName $resourceGroupName | Select IpAddress
<#-----------
IpAddress   
---------   
51.136.54.10
-----------#>

# RDP into it 
mstsc /v 51.136.54.10 

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

#Enable the Azure Key Vault provider within your Azure subscription
$rgName = "DEDemoResourceGroup"
$location = "East US"
New-AzureRmResourceGroup -Location "East US" -Name $rgName

Register-AzureRmResourceProvider -ProviderNamespace "Microsoft.KeyVault"

#create a new Key Vault
$keyVaultName = "myDEKeyVaultName"
New-AzureRmKeyVault -Location $location `
    -ResourceGroupName $rgName `
    -VaultName $keyVaultName `
    -EnabledForDiskEncryption

#Create a cryptographic key
Add-AzureKeyVaultKey -VaultName $keyVaultName `
    -Name "myDEKey" `
    -Destination "Software"

#When virtual disks are encrypted or decrypted, you specify an account to handle the authentication and exchanging of 
# cryptographic keys from Key Vault. This account, an Azure Active Directory service principal, allows the Azure platform
# to request the appropriate cryptographic keys on behalf of the VM. A default Azure Active Directory instance is available
# in your subscription, though many organizations have dedicated Azure Active Directory directories.
$appName = "My DE Demo App"
$securePassword = ConvertTo-SecureString -String "P@ssw0rd!" -AsPlainText -Force
$app = New-AzureRmADApplication -DisplayName $appName `
    -HomePage "https://myaddressbookplus.azurewebsites.net" `
    -IdentifierUris "https://myaddressbookplus.azurewebsites.net/contact" `
    -Password $securePassword
New-AzureRmADServicePrincipal -ApplicationId $app.ApplicationId

#o successfully encrypt or decrypt virtual disks, permissions on the cryptographic key stored in Key Vault must be set 
# to permit the Azure Active Directory service principal to read the keys.
Set-AzureRmKeyVaultAccessPolicy -VaultName $keyvaultName `
    -ServicePrincipalName $app.ApplicationId `
    -PermissionsToKeys "WrapKey" `
    -PermissionsToSecrets "Set"

#To test the encryption process, create a VM
$cred = Get-Credential

$vmName = "myDEDemoVM"   # rezaadmin , Sssqloledb65!

<#
New-AzureRmVm `
    -ResourceGroupName $rgName `
    -Name $vmName `
    -Location $location `
    -VirtualNetworkName "myVnet" `
    -SubnetName "mySubnet" `
    -SecurityGroupName "myNetworkSecurityGroup" `
    -PublicIpAddressName "myPublicIpAddress" `
    -Credential $cred
#>

#To encrypt the virtual disks, you bring together all the previous components:
$keyVault = Get-AzureRmKeyVault -VaultName $keyVaultName -ResourceGroupName $rgName;
$diskEncryptionKeyVaultUrl = $keyVault.VaultUri;
$keyVaultResourceId = $keyVault.ResourceId;
$keyEncryptionKeyUrl = (Get-AzureKeyVaultKey -VaultName $keyVaultName -Name 'myDEKey').Key.kid;

Set-AzureRmVMDiskEncryptionExtension -ResourceGroupName $rgName `
    -VMName $vmName `
    -AadClientID $app.ApplicationId `
    -AadClientSecret (New-Object PSCredential "user",$securePassword).GetNetworkCredential().Password `
    -DiskEncryptionKeyVaultUrl $diskEncryptionKeyVaultUrl `
    -DiskEncryptionKeyVaultId $keyVaultResourceId `
    -KeyEncryptionKeyUrl $keyEncryptionKeyUrl `
    -KeyEncryptionKeyVaultId $keyVaultResourceId

# review the encryption status
Get-AzureRmVmDiskEncryptionStatus  -ResourceGroupName $rgName -VMName $vmName

#OsVolumeEncrypted          : Encrypted
#DataVolumesEncrypted       : Encrypted
#OsVolumeEncryptionSettings : Microsoft.Azure.Management.Compute.Models.DiskEncryptionSettings
#ProgressMessage            : OsVolume: Encrypted, DataVolumes: Encrypted

#Disable disk encryption
Disable-AzureRmVMDiskEncryption -ResourceGroupName $rgName -VMName $vmName

#confirmed working!