#region New-PSResourceGroup
<#---------------------------------------------------------------------------#>
<# New-PSResourceGroup                                                       #>
<#---------------------------------------------------------------------------#>
function New-PSResourceGroup ()
{ 
<#
  .SYNOPSIS
  Create a new resource group.

  .DESCRIPTION
  Checks to see if the passed in resource group name exists, if not it will 
  create it in the location that matches the location parameter.
  
  .PARAMETER ResourceGroupName
  The name of the resource group to create

  .PARAMETER Location
  The Azure geographic location to store the resource group in.

  .INPUTS
  System.String

  .OUTPUTS
  n/a

  .EXAMPLE
  New-PSResourceGroup -ResourceGroupName 'ArcaneRG' -Location 'southcentralus'

  .NOTES
  Author: Davide Spano
#>
  [cmdletbinding()]
  param(
         [Parameter( Mandatory=$true
                   , HelpMessage='The name of the resource group to create'
                   )
         ]
         [string]$ResourceGroupName 
       , [Parameter( Mandatory=$true
                   , HelpMessage='The geo location to store the Resource Group in'
                   )
         ]
         [string]$Location
       )
  
  $fn = 'New-PSResourceGroup:'
  # Check to see if the resource group already exists
  Write-Verbose "$fn Checking for Resource Group $ResourceGroupName"

  # Method 1 - Ignores errors
  # $rgExists = Get-AzureRmResourceGroup -Name $ResourceGroupName `
  #                                      -ErrorAction SilentlyContinue

  # Method 2 - Filters on this end
  $rgExists = Get-AzureRmResourceGroup |
     Where-Object {$_.ResourceGroupName -eq $ResourceGroupName}

  
  # If not, create it.
  if ( $rgExists -eq $null )
  {
    Write-Verbose "$fn Creating Resource Group $ResourceGroupName"
    New-AzureRmResourceGroup -Name $ResourceGroupName `
                             -Location $Location
  }
}
#endregion New-PSResourceGroup

#region New-PSStorageAccount
<#---------------------------------------------------------------------------#>
<# New-PSStorageAccount                                                      #>
<#---------------------------------------------------------------------------#>
function New-PSStorageAccount ()
{ 
<#
  .SYNOPSIS
  Create a new storage account

  .DESCRIPTION
  Checks to see if an Azure storage account exists in a particular resource
  group. If not, it will create it. 

  .PARAMETER StorageAccountName
  The name of the storage account to create.

  .PARAMETER ResourceGroupName
  The resource group to put the storage account in.

  .Parameter Location
  The Azure geographic location to put the storage account in.

  .INPUTS
  System.String

  .OUTPUTS
  A new storage account

  .EXAMPLE
  New-PSStorageAccount -StorageAccountName 'ArcaneStorageAcct' `
                       -ResourceGroupName 'ArcaneRG' `
                       -Location 'southcentralus'

  .NOTES
  Author: Davide Spano
#>
  [cmdletbinding()]
  param(
         [Parameter( Mandatory=$true
                   , HelpMessage='The name of the storage account to create'
                   )
         ]
         [string]$StorageAccountName
       , [Parameter( Mandatory=$true
                   , HelpMessage='The resource group to put the storage account in'
                   )
         ]
         [string]$ResourceGroupName 
       , [Parameter( Mandatory=$true
                   , HelpMessage='The geo location to put the storage account in'
                   )
         ]
         [string]$Location
       )

  $fn = 'New-PSStorageAccount:'

  # Check to see if the storage account exists
  Write-Verbose "$fn Checking Storage Account $StorageAccountName"
  $saExists = Get-AzureRMStorageAccount `
                -ResourceGroupName $ResourceGroupName `
                -Name $StorageAccountName `
                -ErrorAction SilentlyContinue

  # If not, create it.
  if ($saExists -eq $null)
  { 
    Write-Verbose "$fn Creating Storage Account $StorageAccountName"
    New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName `
                              -Name $StorageAccountName `
                              -Location $Location `
                              -Type Standard_LRS
  }
}
#endregion New-PSStorageAccount